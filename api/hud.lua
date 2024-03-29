local S = choppy.S
local api = choppy.api

choppy.text_hud = futil.define_hud("choppy:text", {
	period = 1,
	enabled_by_default = true,
	get_hud_def = function(player)
		local player_name = player:get_player_name()
		local process = api.get_process(player_name)
		if not process then
			return
		end

		local tree_name = process.tree_name
		local text_parts = {
			S("chopping @1", tree_name),
			S("@1 chopped, at least @2 remaining", process.nodes_chopped, process:targets_remaining()),
		}

		if api.get_sneak_enable(player_name) then
			table.insert(text_parts, S("release SNEAK to stop"))
		else
			table.insert(text_parts, S("press & hold SNEAK to stop"))
		end

		if process:is_paused() then
			table.insert(text_parts, S("chopping is paused"))
		end

		return {
			hud_elem_type = "text",
			position = { x = 0.5, y = 0.2 },
			alignment = { x = 0, y = 0 },
			offset = { x = 0, y = 0 },
			number = 0xFFFFFF,
			text = table.concat(text_parts, "\n"),
		}
	end,
})

choppy.image_hud = futil.define_hud("choppy:image", {
	period = 1,
	enabled_by_default = true,
	get_hud_def = function(player)
		local player_name = player:get_player_name()
		local process = api.get_process(player_name)
		if not process then
			return
		end

		local tree_name = process.tree_name
		local tree_image = api.get_tree_image(tree_name)

		if tree_image then
			return {
				hud_elem_type = "image",
				position = { x = 0.5, y = 0.1 },
				scale = { x = 5, y = 5 },
				alignment = { x = 0, y = 0 },
				offset = { x = 0, y = 0 },
				z_index = -1,
				text = tree_image .. "^[resize:16x16",
			}
		end
	end,
})

choppy.waypoint_hud = futil.define_hud("choppy:waypoint", {
	period = 1,
	name_field = "text2",
	get_hud_def = function(player)
		local player_name = player:get_player_name()
		local process = api.get_process(player_name)
		if not (process and api.get_visualize_enabled(player_name)) then
			return
		end

		return {
			name = "choppy",
			hud_elem_type = "waypoint",
			number = 0xFFFFFF,
			precision = 0,
			world_pos = process.current_pos,
		}
	end,
})

function api.toggle_visualize_enabled(player_name)
	local player = minetest.get_player_by_name(player_name)
	if player then
		return choppy.waypoint_hud:toggle_enabled(player)
	end
end

function api.get_visualize_enabled(player_name)
	local player = minetest.get_player_by_name(player_name)
	if player then
		return choppy.waypoint_hud:is_enabled(player)
	end
end
