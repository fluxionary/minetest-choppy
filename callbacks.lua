local swap_node = minetest.swap_node

local api = choppy.api

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not api.is_tree_node(oldnode.name, "trunk") then
		-- not a tree trunk
		return
	end

	if not minetest.is_player(digger) then
		return
	end

	local player_name = digger:get_player_name()

	if api.get_process(player_name) then
		-- already cutting
		return
	end

	if api.is_wielding_axe(digger) and api.is_enabled(digger) then
		api.start_process(digger, pos, oldnode.name)
	end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	local node_name = newnode.name
	if api.is_tree_node(node_name) then
		local def = minetest.registered_nodes[node_name]
		if def.paramtype == "placed_by_player" then
			newnode.param1 = 1
			swap_node(pos, newnode)
		end
	end
end)

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		local process = api.get_process(player_name)
		if
			process
			and (
				not api.is_enabled(player)
				or not api.is_wielding_axe(player)
				or not api.player_in_bounds(player:get_pos(), process.start_pos, process.tree_shape)
			)
		then
			api.stop_process(player_name)
		end
	end

	api.process_globalstep(dtime)
end)

minetest.register_on_leaveplayer(function(player, timed_out)
	local player_name = player:get_player_name()
	api.stop_process(player_name)
end)
