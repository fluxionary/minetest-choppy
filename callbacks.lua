local swap_node = minetest.swap_node

local resolve_item = futil.resolve_item

local api = choppy.api
local halo_size = choppy.settings.halo_size
local will_digging_break_tool = choppy.util.will_digging_break_tool

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	if not api.is_tree_node(node.name, "trunk") then
		-- not a tree trunk
		return
	end

	if not futil.is_player(puncher) then
		return
	end

	if api.is_wielding_axe(puncher) and not api.is_initialized(puncher) then
		choppy.show_first_use_form(puncher)
	end
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not api.is_tree_node(oldnode.name, "trunk") then
		-- not a tree trunk
		return
	end

	if not futil.is_player(digger) then
		return
	end

	if api.get_process(digger) then
		-- already cutting
		return
	end

	if api.is_wielding_axe(digger) and api.is_enabled(digger) then
		local treetop = api.find_treetop(pos, oldnode, digger)
		api.start_process(digger, pos, treetop or pos, oldnode.name)
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
		if process then
			local wielded_item = player:get_wielded_item()
			local wielded_def = wielded_item:get_definition()
			local tool_range = (wielded_def.range or 4) + halo_size
			local in_bounds = api.player_in_bounds(player:get_pos(), process.base_pos, process.tree_shape, tool_range)

			if not api.is_enabled(player) or not in_bounds then
				api.stop_process(player_name)
			else
				local paused = false

				if not api.is_wielding_axe(player) then
					paused = true
					process:set_paused(true, "no axe")
				else
					local next_pos = process:peek_next_valid_target()
					if next_pos then
						local next_node = minetest.get_node(next_pos).name
						if will_digging_break_tool(next_node, wielded_item) then
							paused = true
						end
					end
				end

				process:set_paused(paused, "no axe")
			end
		end
	end

	api.process_globalstep(dtime)
end)

minetest.register_on_leaveplayer(function(player, timed_out)
	api.stop_process(player)
end)

minetest.register_on_dieplayer(function(player, reason)
	api.stop_process(player)
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
