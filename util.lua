local get_dig_params = minetest.get_dig_params

local multiplier = choppy.settings.dig_speed_multiplier
local step_radius = choppy.settings.step_radius

local util = {}

function util.get_neighbors(pos)
	local v_new = vector.new
	local sr = step_radius
	local x0, y0, z0 = pos.x, pos.y, pos.z
	local ns = {}
	for x = -sr, sr do
		for y = -sr, sr do
			for z = -sr, sr do
				if not (x == 0 and y == 0 and z == 0) then
					ns[#ns + 1] = v_new(x0 + x, y0 + y, z0 + z)
				end
			end
		end
	end
	table.shuffle(ns)
	local i = 0
	return function()
		i = i + 1
		return ns[i]
	end
end

function util.get_neighbors_above(pos)
	local v_new = vector.new
	local x0, y1, z0 = pos.x, pos.y + 1, pos.z
	local ns = {
		v_new(x0, y1, z0),
		v_new(x0 - 1, y1, z0),
		v_new(x0 + 1, y1, z0),
		v_new(x0, y1, z0 - 1),
		v_new(x0, y1, z0 + 1),
		v_new(x0 - 1, y1, z0 - 1),
		v_new(x0 - 1, y1, z0 + 1),
		v_new(x0 + 1, y1, z0 - 1),
		v_new(x0 + 1, y1, z0 + 1),
	}
	local i = 0
	return function()
		i = i + 1
		return ns[i]
	end
end

function util.get_dig_time_and_wear(node_name, wielded, hand)
	local node_def = minetest.registered_nodes[node_name]
	if not node_def then
		return
	end

	local dig_params = get_dig_params(node_def.groups or {}, wielded:get_tool_capabilities(), wielded:get_wear())
	if dig_params.diggable then
		return dig_params.time / multiplier, dig_params.wear
	else
		dig_params = get_dig_params(node_def.groups or {}, hand:get_tool_capabilities(), hand:get_wear())

		if dig_params.diggable then
			return dig_params.time / multiplier, 0
		end
	end
end

choppy.util = util
