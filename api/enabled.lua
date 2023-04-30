local private_state = ...
local mod_storage = private_state.mod_storage

local f = string.format

local is_yes = minetest.is_yes

local api = choppy.api

local cache = {}

local function toggled_key(player_name)
	return f("toggled:%s", player_name)
end

function api.get_toggled(player_name)
	local toggled = cache[player_name]
	if toggled == nil then
		toggled = is_yes(mod_storage:get(toggled_key(player_name)))
		cache[player_name] = toggled
	end
	return toggled
end

function api.toggle_enabled(player_name)
	local key = toggled_key(player_name)
	local toggled = not api.get_toggled(player_name)
	if toggled then
		mod_storage:set_string(key, "y")
	else
		mod_storage:set_string(key, "")
	end
	cache[player_name] = toggled
	return toggled
end

function api.is_enabled(player)
	local player_name = player:get_player_name()
	local control = player:get_player_control()
	local toggled = api.get_toggled(player_name)

	return toggled == control.sneak
end
