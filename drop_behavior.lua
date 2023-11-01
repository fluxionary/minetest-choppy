if choppy.settings.handle_drop_behavior == "add_item" then
	local old_handle_node_drops = minetest.handle_node_drops
	function minetest.handle_node_drops(pos, drops, player)
		if not futil.is_player(player) then
			return old_handle_node_drops(pos, drops, player)
		end
		local player_name = player:get_player_name()
		local process = choppy.api.get_process(player_name)
		if not (process and process.is_digging) then
			return old_handle_node_drops(pos, drops, player)
		end
		for i = 1, #drops do
			local drop = ItemStack(drops[i])
			if drop:is_known() and not drop:is_empty() then
				minetest.add_item(pos, drop)
			end
		end
	end
end
