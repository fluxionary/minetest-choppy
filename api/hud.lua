local S = choppy.S
local api = choppy.api

local enable_waypoint = false -- don't enable this code yet

local hud_ids_by_player_name = {}

function api.update_hud(player_name)
	local player = minetest.get_player_by_name(player_name)

	if not player then
		hud_ids_by_player_name[player_name] = nil
		return
	end

	local process = api.get_process(player_name)
	if not process then
		api.remove_hud(player_name)
		return
	end

	local tree_name = process.tree_name
	local text
	if api.get_toggled(player_name) then
		text = S("chopping @1\nrelease SNEAK to stop", tree_name)
	else
		text = S("chopping @1\npress SNEAK to stop", tree_name)
	end

	local hud_ids = hud_ids_by_player_name[player_name] or {}
	local text_hud_id = hud_ids.text
	local waypoint_hud_id = hud_ids.waypoint
	local image_hud_id = hud_ids.image

	if text_hud_id then
		local text_hud_def = player:hud_get(text_hud_id)
		if text_hud_def and text_hud_def.name == "choppy:text" and text_hud_def.text ~= text then
			player:hud_change(text_hud_id, "text", text)
		end

		if waypoint_hud_id then
			local waypoint_hud_def = player:hud_get(waypoint_hud_id)
			if waypoint_hud_def and waypoint_hud_def.text2 == "choppy:waypoint" then
				player:hud_change(waypoint_hud_id, "world_pos", process.current_pos)
			end
		end
	else
		text_hud_id = player:hud_add({
			name = "choppy:text",
			hud_elem_type = "text",
			position = { x = 0.5, y = 0.3 },
			alignment = { x = 0, y = 0 },
			offset = { x = 0, y = 0 },
			number = 0xFFFFFF,
			text = text,
		})

		if enable_waypoint then
			waypoint_hud_id = player:hud_add({
				name = "choppy",
				hud_elem_type = "waypoint",
				number = 0xFFFFFF,
				text2 = "choppy:waypoint",
				precision = 0,
				world_pos = process.current_pos,
			})
		end

		local tree_image = api.get_tree_image(tree_name)
		if tree_image then
			image_hud_id = player:hud_add({
				name = "choppy:image",
				hud_elem_type = "image",
				position = { x = 0.5, y = 0.2 },
				scale = { x = 5, y = 5 },
				alignment = { x = 0, y = 0 },
				offset = { x = 0, y = 0 },
				z_index = -1,
				text = tree_image .. "^[resize:16x16",
			})
		end

		hud_ids_by_player_name[player_name] = {
			text = text_hud_id,
			waypoint = waypoint_hud_id,
			image = image_hud_id,
		}
	end
end

function api.remove_hud(player_name)
	local player = minetest.get_player_by_name(player_name)

	if not player then
		hud_ids_by_player_name[player_name] = nil
		return
	end

	local hud_ids = hud_ids_by_player_name[player_name]
	if not hud_ids then
		return
	end

	local text_hud_id = hud_ids.text
	local waypoint_hud_id = hud_ids.waypoint
	local image_hud_id = hud_ids.image

	local text_hud_def = player:hud_get(text_hud_id)
	if text_hud_def and text_hud_def.name == "choppy:text" then
		player:hud_remove(text_hud_id)
	end

	if waypoint_hud_id then
		local waypoint_hud_def = player:hud_get(waypoint_hud_id)
		if waypoint_hud_def and waypoint_hud_def.text2 == "choppy:waypoint" then
			player:hud_remove(waypoint_hud_id)
		end
	end

	if image_hud_id then
		local image_hud_def = player:hud_get(image_hud_id)
		if image_hud_def and image_hud_def.name == "choppy:image" then
			player:hud_remove(image_hud_id)
		end
	end

	hud_ids_by_player_name[player_name] = nil
end
