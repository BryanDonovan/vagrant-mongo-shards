# -*- mode: ruby -*-

$shardSetupScript = "setup-test-cluster.js"
$CONFIG_SERVER_NAME = "configsrv.local"
$CONFIG_SERVER_PORT = 27018
$SHARD_ROUTER_NAME = "configsrv.local"
$SHARD_ROUTER_PORT = 27019

package { 'vim':
	ensure => present,
}

group { 'puppet':
	ensure => 'present',
}

package { 'libnss-mdns':
	ensure  => present,
}

file { '/home/vagrant/mongo_configdb':
	ensure  => directory,
}

file { '/etc/apt/sources.list.d/10gen.list':
  ensure  => 'present',
  source  => '/vagrant/manifests/10gen.list',
}

exec { 'add-10genkey':
  command => '/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && /usr/bin/apt-get update && touch /home/vagrant/updated',
  path    => '/usr/local/bin/:/bin/:/usr/bin/',
  creates => '/home/vagrant/updated',
  require => File['/etc/apt/sources.list.d/10gen.list'],
}

package { 'mongodb-10gen':
  ensure  => present,
  require => Exec['add-10genkey'],
}

file { '/etc/mongodb.conf':
  ensure  => present,
  source  => '/vagrant/manifests/mongodb.conf',
  require => Package['mongodb-10gen'],
}

file { "/tmp/${shardSetupScript}":
  ensure  => present,
  source  => "/vagrant/manifests/${shardSetupScript}",
}

#Start the config server
exec { 'start-cfg':
	command => "/usr/bin/mongod --configsvr --dbpath /home/vagrant/mongo_configdb/ --port ${CONFIG_SERVER_PORT} > /tmp/mongocfg.log &",
  path    => '/usr/local/bin/:/bin/',
  #onlyif  => 'test `ps -efa | grep mongod --configsrv | wc -l` -lt 1',
	require => [ File['/home/vagrant/mongo_configdb'], Package['mongodb-10gen'] ],
}

#Start the Shard Router and connect to the Config Server (in Prod, there would be 3, but we just have 1 for testing)
#Note that we sleep 60 to ensure mongod comes up first
#Todo: add this to startup
exec { 'start-mongos':
  command => "/bin/sleep 30 && /usr/bin/mongos --configdb ${CONFIG_SERVER_NAME}:${CONFIG_SERVER_PORT} --port ${SHARD_ROUTER_PORT} > /tmp/mongos.log &",
  path    => '/usr/local/bin/:/bin/',
  #onlyif  => 'test `ps -efa | grep mongos | wc -l` -lt 1',
  require => [ Exec['start-cfg'], Package['mongodb-10gen'] ],
}

#Connect to Shard Router and Add Shards to the Cluster
#Note that we sleep 90 to ensure mongos comes up first -- this is a hack, but try_sleep seems not to work as imagined
exec { 'setup-cluster':
  command => "/bin/sleep 60 && /usr/bin/mongo --host ${SHARD_ROUTER_NAME} --port ${SHARD_ROUTER_PORT} /tmp/${shardSetupScript}",
  path    => '/usr/local/bin/:/bin/',
  require => [ Exec['start-mongos'], Package['mongodb-10gen'], File["/tmp/${shardSetupScript}"] ],
}