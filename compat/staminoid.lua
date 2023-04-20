staminoid.register_on_exhaust_player(function(player, amount, reason)
	if type(reason) == "table" and reason.type == "dig" and reason.node then
		local player_name = player:get_player_name()
		local process = choppy.api.get_process(player_name)
		if process and choppy.api.is_same_tree(process.tree_name, reason.node.name) then
			return amount * 0.25
		end
	end
end)
