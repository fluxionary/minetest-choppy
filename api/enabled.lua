local private_state = ...
local mod_storage = private_state.mod_storage

local f = string.format

local is_yes = minetest.is_yes

local api = choppy.api

local sneak_enable_cache = {}

local function sneak_enable_key(player_name)
	return f("toggled:%s", player_name)
end

function api.get_sneak_enable(player_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end

	local sneak_enable = sneak_enable_cache[player_name]
	if sneak_enable == nil then
		sneak_enable = is_yes(mod_storage:get(sneak_enable_key(player_name)))
		sneak_enable_cache[player_name] = sneak_enable
	end
	return sneak_enable
end

api.get_toggled = api.get_sneak_enable -- backwards compatibility

function api.set_sneak_enable(player_name, sneak_enable)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end

	local key = sneak_enable_key(player_name)
	mod_storage:set_string(key, sneak_enable and "y" or "")
	sneak_enable_cache[player_name] = sneak_enable
	return sneak_enable
end

function api.toggle_sneak_enable(player_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end

	local key = sneak_enable_key(player_name)
	local sneak_enable = sneak_enable_cache[player_name]
	if sneak_enable == nil then
		sneak_enable = is_yes(mod_storage:get(key))
	end

	sneak_enable = not sneak_enable

	mod_storage:set_string(key, sneak_enable and "y" or "")
	sneak_enable_cache[player_name] = sneak_enable
	return sneak_enable
end

api.toggle_enabled = api.toggle_sneak_enable -- backwards compatibility

local initialized_cache = {}

local function initialized_key(player_name)
	return f("initialized:%s", player_name)
end

function api.is_initialized(player_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end

	local initialized = initialized_cache[player_name]
	if initialized == nil then
		local key = initialized_key(player_name)
		initialized = is_yes(mod_storage:get(key))
		initialized_cache[player_name] = initialized
	end
	return initialized
end

function api.set_initialized(player_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end

	local key = initialized_key(player_name)
	mod_storage:set_string(key, "y")
	initialized_cache[player_name] = true
end

local disabled_cache = {}

local function disabled_key(player_name)
	return f("disabled:%s", player_name)
end

function api.is_disabled(player_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end

	local disabled = disabled_cache[player_name]
	if disabled == nil then
		local key = disabled_key(player_name)
		disabled = is_yes(mod_storage:get(key))
		disabled_cache[player_name] = disabled
	end
	return disabled
end

function api.toggle_disabled(player_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end

	local key = disabled_key(player_name)
	local disabled = disabled_cache[player_name]
	if disabled == nil then
		disabled = is_yes(mod_storage:get(key))
	end

	disabled = not disabled

	mod_storage:set_string(key, disabled and "y" or "")
	disabled_cache[player_name] = disabled
	return disabled
end

function api.is_enabled(player)
	if api.is_disabled(player) or not api.is_initialized(player) then
		return false
	end

	local control = player:get_player_control()
	local sneak_enable = api.get_sneak_enable(player)

	return sneak_enable == control.sneak
end
