local f = string.format

local is_yes = minetest.is_yes

local api = choppy.api

local mod_storage = choppy.mod_storage

local cache = {}

function api.is_enabled(player)
	local player_name = player:get_player_name()
	local control = player:get_player_control()
	local toggled = cache[player_name]
	if toggled == nil then
		local key = f("toggled:%s", player_name)
		toggled = is_yes(mod_storage:get(key))
		cache[player_name] = toggled
	end

	return (toggled and control.sneak) or (not toggled and not control.sneak)
end

function api.toggle_enabled(player_name)
	local key = f("toggled:%s", player_name)
	local toggled = is_yes(mod_storage:get(key))
	if toggled then
		mod_storage:set_string(key, "")
		return false
	else
		mod_storage:set_string(key, "y")
		return true
	end
end
