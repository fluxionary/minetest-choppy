local swap_node = minetest.swap_node

local resolve_item = futil.resolve_item

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

minetest.register_on_dieplayer(function(player, reason)
	local player_name = player:get_player_name()
	api.stop_process(player_name)
end)

minetest.register_on_mods_loaded(function()
	-- resolve alias nodes
	-- we assume that all aliasing has happened at this point
	for tree_name, def in pairs(api.registered_trees) do
		local nodes = {}
		for node, type in pairs(def.nodes) do
			local resolved = resolve_item(node)
			if resolved then
				nodes[resolved] = type

				-- indicate that a node is natural or placed by a player
				local node_def = minetest.registered_nodes[resolved]
				local paramtype = node_def.paramtype
				if not paramtype or paramtype == "" or paramtype == "none" then
					minetest.override_item(resolved, {
						paramtype = "placed_by_player",
					})
				end
			end
		end
		def.nodes = nodes

		-- create the trees by node index
		for node_name, type in pairs(nodes) do
			table.insert(api.trees_by_node[node_name], tree_name)
		end
	end
end)
