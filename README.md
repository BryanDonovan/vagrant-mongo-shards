# Vagrant MongoDB Sharding Definitions

## Purpose

This is forked from [BryanDonovan/vagrant-mongo-shards](https://github.com/BryanDonovan/vagrant-mongo-shards).
[Vagrant](http://vagrantup.com/) is a nice way to experiment with technologies without polluting your own machine with software.

## Preconditions

Please follow the install instructions at http://vagrantup.com/. In summary:

1. Make sure the VT-x feature is enabled in the BIOS settings.
2. Install Virtualbox (https://www.virtualbox.org/wiki/Downloads)
3. Install Vagrant (http://downloads.vagrantup.com/)
4. Clone this project
5. Go to the project root directory
6. Type:
```
vagrant up
```

## What it Does

This sets up 4 servers with MongoDB connected via a host-only network.

Startup:
```
vagrant up
```

The startup can take a while.

The IP addresses of the 3 shard servers are

- shard01.local
- shard02.local
- shard03.local

The IP adress of the configserver and mongos instance is

- configsrv.local

Each server has the same setup. If you want to connect to a certain server via ssh use (e.g. shard01):

```
vagrant ssh shard01
```

Connect to the MongoDB instances from your host:

```
mongo --host configsrv.local --port 27017
```

#### Add the shards 

```
sh.addShard( "shard01.local:27017" )
sh.addShard( "shard02.local:27017" )
sh.addShard( "shard03.local:27017" )
```

#### Set chunk size to something demo usable (optional)

```
use config
db.settings.save( { _id:"chunksize", value: 1 } )
```

#### Links

Useful link to the MongoDB documentation: http://docs.mongodb.org/manual/administration/sharding/
