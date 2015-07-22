local function alterTables()
	-- creating columns
	db.query("ALTER TABLE `account_ban_history` ADD COLUMN `banned_at_new` TIMESTAMP NOT NULL AFTER `banned_at`, ADD COLUMN `expired_at_new` TIMESTAMP NOT NULL AFTER `expired_at`")
	db.query("ALTER TABLE `account_bans` ADD COLUMN `banned_at_new` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `banned_at`, ADD COLUMN `expires_at_new` TIMESTAMP NOT NULL AFTER `expires_at`")
	db.query("ALTER TABLE `accounts` ADD COLUMN `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `creation`")
	db.query("ALTER TABLE `guilds` CHANGE COLUMN `ownerid` `owner` INT NOT NULL, ADD COLUMN `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `creationdata`")
	db.query("ALTER TABLE `guildwar_kills` CHANGE COLUMN `killerguild` `killer_guild` INT NOT NULL, CHANGE COLUMN `targetguild` `target_guild` INT NOT NULL, CHANGE COLUMN `warid` `war_id` INT NOT NULL, ADD COLUMN `killed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `time`")
	db.query("ALTER TABLE `guild_wars` ADD COLUMN `started_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `started`, ADD COLUMN `ended_at` TIMESTAMP NULL AFTER `ended`")
	db.query("ALTER TABLE `houses` CHANGE COLUMN `owner` `owner` INT NULL, CHANGE COLUMN `bid` `bid` INT UNSIGNED NULL, ADD COLUMN `bid_end_at` TIMESTAMP NULL AFTER `bid_end`, CHANGE COLUMN `last_bid` `last_bid` INT UNSIGNED NULL, CHANGE COLUMN `highest_bidder` `highest_bidder` INT NULL")
	db.query("ALTER TABLE `ip_bans` ADD COLUMN `banned_at_new` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `banned_at`, ADD COLUMN `expires_at_new` TIMESTAMP NULL AFTER `expires_at`")
	db.query("ALTER TABLE `market_history` ADD COLUMN `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `inserted`, ADD COLUMN `expired_at` TIMESTAMP NULL AFTER `expires_at`")
	db.query("ALTER TABLE `market_offers` ADD COLUMN `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `created`")
	db.query("ALTER TABLE `player_deaths` ADD COLUMN `killed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `time`")
	db.query("ALTER TABLE `player_namelocks` ADD COLUMN `namelocked_at_new` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `namelocked_at`")
	db.query("ALTER TABLE `players` ADD COLUMN `deleted_at` TIMESTAMP NULL AFTER `deletion`, ADD COLUMN `lastlogin_new` TIMESTAMP NULL AFTER `lastlogin`, ADD COLUMN `lastlogout_new` TIMESTAMP NULL AFTER `lastlogout`")
end

local function copyData()
	-- copying old data
	db.query("UPDATE `account_ban_history` SET `banned_at_new` = FROM_UNIXTIME(`banned_at`), `expired_at_new` = FROM_UNIXTIME(`expired_at`)")
	db.query("UPDATE `account_bans` SET `banned_at_new` = FROM_UNIXTIME(`banned_at`), `expires_at_new` = FROM_UNIXTIME(`expires_at`)")
	db.query("UPDATE `accounts` SET `created_at` = FROM_UNIXTIME(`creation`)")
	db.query("UPDATE `guilds` SET `created_at` = FROM_UNIXTIME(`creationdata`)")
	db.query("UPDATE `guildwar_kills` SET `killed_at` = FROM_UNIXTIME(`time`)")
	db.query("UPDATE `guild_wars` SET `started_at` = FROM_UNIXTIME(`started`) WHERE `started` != 0")
	db.query("UPDATE `guild_wars` SET `ended_at` = FROM_UNIXTIME(`ended`) WHERE `ended` != 0")
	db.query("UPDATE `houses` SET `owner` = NULL WHERE `owner` = 0")
	db.query("UPDATE `houses` SET `bid` = NULL WHERE `bid` = 0 AND `bid_end` = 0")
	db.query("UPDATE `houses` SET `bid_end_at` = FROM_UNIXTIME(`bid_end`) WHERE `bid_end` != 0")
	db.query("UPDATE `houses` SET `last_bid` = NULL WHERE `last_bid` = 0 AND `highest_bidder_id` = 0")
	db.query("UPDATE `houses` SET `highest_bidder` = NULL WHERE `highest_bidder` = 0")
	db.query("UPDATE `ip_bans` SET `banned_at_new` = FROM_UNIXTIME(`banned_at`), `expires_at_new` = FROM_UNIXTIME(`expires_at`)")
	db.query("UPDATE `market_history` SET `created_at` = FROM_UNIXTIME(`inserted`), `expired_at` = FROM_UNIXTIME(`expires_at`)")
	db.query("UPDATE `market_offers` SET `created_at` = FROM_UNIXTIME(`created`)")
	db.query("UPDATE `player_deaths` SET `killed_at` = FROM_UNIXTIME(`time`)")
	db.query("UPDATE `player_namelocks` SET `namelocked_at_new` = FROM_UNIXTIME(`namelocked_at`)")
	db.query("UPDATE `players` SET `deleted_at` = FROM_UNIXTIME(`deletion`) WHERE `deletion` != 0")
	db.query("UPDATE `players` SET `lastlogin_new` = FROM_UNIXTIME(`lastlogin`) WHERE `lastlogin` != 0")
	db.query("UPDATE `players` SET `lastlogout_new` = FROM_UNIXTIME(`lastlogout`)  WHERE `lastlogout` != 0")
end

local function dropColumns()
	-- removing old columns
	db.query("ALTER TABLE `account_ban_history` DROP COLUMN `banned_at`, DROP COLUMN `expired_at`");
	db.query("ALTER TABLE `account_bans` DROP COLUMN `banned_at`, DROP COLUMN `expires_at`");
	db.query("ALTER TABLE `accounts` DROP COLUMN `creation`")
	db.query("ALTER TABLE `guilds` DROP COLUMN `creationdata`")
	db.query("ALTER TABLE `guildwar_kills` DROP COLUMN `time`")
	db.query("ALTER TABLE `guild_wars` DROP COLUMN `started`, `ended`")
	db.query("ALTER TABLE `houses` DROP COLUMN `bid_end`")
	db.query("ALTER TABLE `ip_bans` DROP COLUMN `banned_at`, DROP COLUMN `expires_at`");
	db.query("ALTER TABLE `market_history` DROP COLUMN `inserted`, DROP COLUMN `expires_at`");
	db.query("ALTER TABLE `market_offers` DROP COLUMN `created`");
	db.query("ALTER TABLE `player_deaths` DROP COLUMN `time`")
	db.query("ALTER TABLE `player_namelocks` DROP COLUMN `namelocked_at`")
	db.query("ALTER TABLE `players` DROP COLUMN `deletion`, DROP COLUMN `lastlogin`, DROP COLUMN `lastlogout`");
end

local function renameColumns()
	-- changing temporary names
	db.query("ALTER TABLE `account_ban_history` CHANGE COLUMN `banned_at_new` `banned_at` TIMESTAMP NOT NULL, CHANGE COLUMN `expired_at_new` `expired_at` TIMESTAMP NOT NULL")
	db.query("ALTER TABLE `account_bans` CHANGE COLUMN `banned_at_new` `banned_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, CHANGE COLUMN `expires_at_new` `expires_at` TIMESTAMP NOT NULL")
	db.query("ALTER TABLE `ip_bans` CHANGE COLUMN `banned_at_new` `banned_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, CHANGE COLUMN `expires_at_new` `expires_at` TIMESTAMP NOT NULL")
	db.query("ALTER TABLE `player_namelocks` CHANGE COLUMN `namelocked_at_new` `namelocked_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
	db.query("ALTER TABLE `players` CHANGE COLUMN `lastlogin_new` `lastlogin` TIMESTAMP NULL, CHANGE COLUMN `lastlogout_new` `lastlogout` TIMESTAMP NULL")
end

function onUpdateDatabase()
	print("> Updating database to version 19 (coherency improvements)")
	alterTables()
	copyData()
	dropColumns()
	renameColumns()
end
