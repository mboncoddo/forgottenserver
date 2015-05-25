function onUpdateDatabase()
	print("> Updating database to version 19 (reward chests)")
	db.query("CREATE TABLE IF NOT EXISTS `player_rewardchestitems` (player_id` int(11) NOT NULL, sid` int(11) NOT NULL, pid` int(11) NOT NULL DEFAULT '0', itemtype` smallint(6) NOT NULL, count` smallint(5) NOT NULL DEFAULT '0', attributes` blob NOT NULL,  KEY `player_id_2` (`player_id`, `sid`),  KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE) ENGINE=InnoDB;")
	return true
end
