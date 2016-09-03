//use the default 'test' database
db = db.getSiblingDB('test');

//Add shards
sh.addShard( "shard01.local:27017" );
sh.addShard( "shard02.local:27017" );
sh.addShard( "shard03.local:27017" );

//Enable sharding for the database
sh.enableSharding("test");

//Set chunk size
//switch to the 'Config' database
db = db.getSiblingDB('config');
db.settings.save( { _id:"chunksize", value: 1 } );  //chunk size set to 1MB for testing purposes (default is 64mb)

