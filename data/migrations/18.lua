function onUpdateDatabase()
	print("> Updating database to version 19 (alter password field to handle different encryption)")
	db.query("ALTER TABLE `accounts` CHANGE `password` `password` VARCHAR(128) NOT NULL")
	return true
end
