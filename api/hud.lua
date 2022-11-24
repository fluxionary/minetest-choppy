local S = choppy.S
local api = choppy.api

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
	local text = S("chopping @1\npress SNEAK to stop", tree_name)

	local text_hud_id, image_hud_id = unpack(hud_ids_by_player_name[player_name] or {})
	if text_hud_id then
		player:hud_change(text_hud_id, text)
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
				text = tree_image,
			})
		end

		hud_ids_by_player_name[player_name] = { text_hud_id, image_hud_id }
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

	local text_hud_id, image_hud_id = unpack(hud_ids)
	local text_hud = player:hud_get(text_hud_id)
	if text_hud and text_hud.name == "choppy:text" then
		player:hud_remove(text_hud_id)
	end

	if image_hud_id then
		local image_hud = player:hud_get(image_hud_id)
		if image_hud and image_hud.name == "choppy:image" then
			player:hud_remove(image_hud_id)
		end
	end

	hud_ids_by_player_name[player_name] = nil
end
