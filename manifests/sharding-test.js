//MongoDB sharding test
db = db.getSiblingDB('test')

//Load data
//NA: countryCode 0-49
//EU: countryCode 50-149
//Japan: countryCode 150
for (var i=0; i < 100000; i++) {
	db.persons.insert( { name: "US-" + i, countryCode: 0 } )
	db.persons.insert( { name: "UK-" + i, countryCode:  100} )
	db.persons.insert( { name: "Japan-" + i, countryCode: 200 } )
	db.persons.insert( { name: "Canada-" + i, countryCode: 1 } )
	db.persons.insert( { name: "Germany-" + i, countryCode: 101 } )
	db.persons.insert( { name: "Switzerland-" + i, countryCode: 102 } )
	db.persons.insert( { name: "France-" + i, countryCode: 103 } )
}