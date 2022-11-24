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

	local wielded = digger:get_wielded_item()
	local wielded_name = wielded:get_name()
	if not api.is_axe(wielded_name) then
		-- not an axe
		return
	end

	local controls = digger:get_player_control()
	if controls.sneak then
		-- don't start a process
		return
	end

	api.start_process(digger, pos, oldnode.name)
end)

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local player_name = player:get_player_name()
		local controls = player:get_player_control()
		if controls.is_sneaking then
			api.stop_process(player_name)
		end
	end

	api.process_globalstep(dtime)
end)

minetest.register_on_leaveplayer(function(player, timed_out)
	local player_name = player:get_player_name()
	api.stop_process(player_name)
end)
