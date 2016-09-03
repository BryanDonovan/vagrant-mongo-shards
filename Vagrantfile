# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  #set max memory to 512mb per node
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "512"]
  end
  
  #This should be a Replica Set in Prod
  config.vm.define "shard01" do |shard01| 
    shard01.vm.box = "precise64"
    shard01.vm.box_url = "http://files.vagrantup.com/precise64.box"

    shard01.vm.network "private_network", ip: "192.168.0.11"    
    shard01.vm.host_name = "shard01"
    shard01.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "sharding-playground.pp"
    end
  end

  #This should be a Replica Set in Prod
  config.vm.define "shard02" do |shard02| 
    shard02.vm.box = "precise64"
    shard02.vm.box_url = "http://files.vagrantup.com/precise64.box"

    #set this to my interface to avoid questions from vagrant, use 'shard02.vm.network :bridged' to allow interactive mode
    #shard02.vm.network :bridged, :bridge => 'en1: WLAN (AirPort)'
    shard02.vm.network "private_network", ip: "192.168.0.12"    
    shard02.vm.host_name = "shard02"
    shard02.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "sharding-playground.pp"
    end
  end

  #This should be a Replica Set in Prod
  config.vm.define "shard03" do |shard03| 
    shard03.vm.box = "precise64"
    shard03.vm.box_url = "http://files.vagrantup.com/precise64.box"

    #set this to my interface to avoid questions from vagrant, use 'shard03.vm.network :bridged' to allow interactive mode
    #shard03.vm.network :bridged, :bridge => 'en1: WLAN (AirPort)'
    shard03.vm.network "private_network", ip: "192.168.0.13"
    shard03.vm.host_name = "shard03"
    shard03.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "sharding-playground.pp"
    end
  end
  
  #There should be three of these in Prod
  config.vm.define "configsrv" do |configsrv| 
    configsrv.vm.box = "precise64"
    configsrv.vm.box_url = "http://files.vagrantup.com/precise64.box"

    #set this to my interface to avoid questions from vagrant, use 'configsrv.vm.network :bridged' to allow interactive mode
    #configsrv.vm.network :bridged, :bridge => 'en1: WLAN (AirPort)'
    configsrv.vm.network "private_network", ip: "192.168.0.14"
    configsrv.vm.host_name = "configsrv"
    configsrv.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "configserver-playground.pp"
    end
  end
end
