staminoid.register_on_exhaust_player(function(player, amount, reason)
	if type(reason) == "table" and reason.type == "dig" and reason.node then
		local player_name = player:get_player_name()
		local process = choppy.api.get_process(player_name)
		if process and choppy.api.is_same_tree(process.tree_name, reason.node.name) then
			return amount * 0.25
		end
	end
end)

-- don't exhaust when cutting non-choppy nodes (leaves)
local staminoid_disabled_by_player_name = {}
local function should_disable_staminoid(node_name)
	return minetest.get_item_group(node_name, choppy.settings.choppy_cap_name) == 0
end

choppy.api.register_on_before_chop(function(self, player, pos, node)
	if should_disable_staminoid(node.name) then
		staminoid_disabled_by_player_name[player:get_player_name()] = true
	end
end)
choppy.api.register_on_before_chop(function(self, player, pos, node)
	staminoid_disabled_by_player_name[player:get_player_name()] = nil
end)

staminoid.register_on_exhaust_player(function(player, amount, reason)
	local player_name = player:get_player_name()
	if staminoid_disabled_by_player_name[player_name] and reason == "dig" then
		return 0
	end
end)
