//use the default 'test' database
db = db.getSiblingDB('test');

//Add shards
sh.addShard( "shard01.local:27017" );
sh.addShard( "shard02.local:27017" );
sh.addShard( "shard03.local:27017" );

//Enable sharding for the database
sh.enableSharding("test");

//Enable sharding for a collection
sh.shardCollection("test.persons", { "countryCode": 1, "_id": 1 } );

//Add shard tags
sh.addShardTag("shard0000", "NA");
sh.addShardTag("shard0001", "EU");
sh.addShardTag("shard0002", "Japan");

//Tag shard key range
//Shard ranges are always inclusive of the lower value and exclusive of the upper boundary.
//In this test, assume a countryCode maps to a particular country, we use codes because
//collections are assigned to tagged shards based on a range with upper and lower bounds, so
//using an alphabetic name will not allow us to reliably target countries to specific tags
//Alternative is to use alpha names, and have a single-country tag range 
sh.addTagRange("test.persons", { countryCode: 0 }, { countryCode: 100 }, "NA");
sh.addTagRange("test.persons", { countryCode: 100 }, { countryCode: 200 }, "EU");
sh.addTagRange("test.persons", { countryCode: 200 }, { countryCode: 300 }, "Japan");

//Set chunk size
//switch to the 'Config' database
db = db.getSiblingDB('config');
db.settings.save( { _id:"chunksize", value: 1 } );  //chunk size set to 1MB for testing purposes (default is 64mb)

