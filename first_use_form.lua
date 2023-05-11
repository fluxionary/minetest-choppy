local f = string.format
local F = minetest.formspec_escape
local S = choppy.S
local FS = function(...)
	return F(S(...))
end

local api = choppy.api

function choppy.show_first_use_form(player)
	local form_parts = {
		"formspec_version[6]",
		"size[10,6]",
		f(
			"textarea[1,1;8,3;;;%s]",
			FS(
				"welcome to choppy, an automatic tree-cutting mod. choppy will automatically cut down a tree starting "
					.. 'from the top. would you rather that choppy be enabled when the "sneak" key is pressed, or enabled '
					.. 'by default and disabled when "sneak" is pressed? you can change this behavior any time with the '
					.. "command `/toggle_choppy`."
			)
		),
		f("button_exit[1,4;3,1;set_disabled;%s]", FS("press & hold sneak\nto enable choppy")),
		f("button_exit[6,4;3,1;set_enabled;%s]", FS("press & hold sneak\nto disable choppy")),
	}

	local player_name = player:get_player_name()
	minetest.show_formspec(player_name, "choppy:first_use", table.concat(form_parts, ""))
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "choppy:first_use" then
		return
	end

	local player_name = player:get_player_name()
	if fields.set_disabled then -- enabled with sneak
		api.set_sneak_enable(player_name, true)
		api.set_initialized(player_name)
		minetest.chat_send_player(player_name, S("press & hold sneak to enable choppy"))
		minetest.close_formspec(player_name, formname)
	elseif fields.set_enabled then
		api.set_sneak_enable(player_name, false)
		api.set_initialized(player_name)
		minetest.chat_send_player(player_name, S("press & hold sneak to disable choppy"))
		minetest.close_formspec(player_name, formname)
	end
end)
