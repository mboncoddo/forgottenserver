function onStartup()
	db.query("TRUNCATE TABLE `players_online`")
	db.asyncQuery("DELETE FROM `guild_wars` WHERE `status` = 0")
	db.asyncQuery("DELETE FROM `players` WHERE `deleted_at` < DATE_SUB(NOW(), INTERVAL 2 MONTH)")
	db.asyncQuery("DELETE FROM `ip_bans` WHERE `expires_at` <= NOW()")
	db.asyncQuery("DELETE FROM `market_history` WHERE `created_at` <= DATE_SUB(NOW(), INTERVAL " .. configManager.getNumber(configKeys.MARKET_OFFER_DURATION) .. " SECOND)")

	-- Move expired bans to ban history
	local resultId = db.storeQuery("SELECT * FROM `account_bans` WHERE `expires_at` <= NOW()")
	if resultId ~= false then
		repeat
			local accountId = result.getDataInt(resultId, "account_id")
			db.asyncQuery("INSERT INTO `account_ban_history` (`account_id`, `reason`, `banned_at`, `expired_at`, `banned_by`) VALUES (" .. accountId .. ", " .. db.escapeString(result.getDataString(resultId, "reason")) .. ", FROM_UNIXTIME(" .. result.getDataLong(resultId, "banned_at") .. "), FROM_UNIXTIME(" .. result.getDataLong(resultId, "expires_at") .. "), " .. result.getDataInt(resultId, "banned_by") .. ")")
			db.asyncQuery("DELETE FROM `account_bans` WHERE `account_id` = " .. accountId)
		until not result.next(resultId)
		result.free(resultId)
	end

	-- Check house auctions
	local resultId = db.storeQuery("SELECT `id`, `highest_bidder`, `last_bid`, (SELECT `balance` FROM `players` WHERE `players`.`id` = `highest_bidder`) AS `balance` FROM `houses` WHERE `owner` IS NOT NULL AND `bid_end` IS NOT NULL AND `bid_end` < NOW()")
	if resultId ~= false then
		repeat
			local house = House(result.getDataInt(resultId, "id"))
			if house ~= nil then
				local highestBidder = result.getDataInt(resultId, "highest_bidder")
				local balance = result.getDataLong(resultId, "balance")
				local lastBid = result.getDataInt(resultId, "last_bid")
				if balance >= lastBid then
					db.query("UPDATE `players` SET `balance` = " .. (balance - lastBid) .. " WHERE `id` = " .. highestBidder)
					house:setOwnerGuid(highestBidder)
				end
				db.asyncQuery("UPDATE `houses` SET `last_bid` = NULL, `bid_end` = NULL, `highest_bidder` = NULL, `bid` = NULL WHERE `id` = " .. house:getId())
			end
		until not result.next(resultId)
		result.free(resultId)
	end
end
