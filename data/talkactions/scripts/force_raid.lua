function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GAMEMASTER then
		return false
	end

	local raid = Raid(param)
	if raid then
		raid:execute()
	else
		player:sendCancelMessage("There is no raid with that name.")
	end
	return true
end
