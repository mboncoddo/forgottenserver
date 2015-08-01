local messageTypes = {
	["warning"] = MESSAGE_STATUS_WARNING,
	["event"] = MESSAGE_EVENT_ADVANCE,
	["default"] = MESSAGE_EVENT_DEFAULT,
	["description"] = MESSAGE_INFO_DESCR,
	["smallstatus"] = MESSAGE_STATUS_SMALL,
	["blueconsole"] = MESSAGE_STATUS_CONSOLE_BLUE,
	["redconsole"] = MESSAGE_STATUS_CONSOLE_RED,
}

function Raids.broadcast(delay, message, messageType)
	local mType = messageTypes[messageType]
	if mType == nil then
		mType = messageTypes["default"]
		print("[Notice] Raid: Unknown type value for announce event. Using default: " .. mType)
	end

	return addEvent(broadcastMessage, delay, message, mType)
end

function Raids.addSpawn(delay, monsterName, position)
	return addEvent(Game.createMonster, delay, monsterName, position)
end
