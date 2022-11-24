local f = string.format

local get_dig_params = minetest.get_dig_params

local util = {}

function util.get_neighbors(pos)
	local x0, y0, z0 = pos.x, pos.y, pos.z
	local ns = {}
	for x = -1, 1 do
		for y = -1, 1 do
			for z = -1, 1 do
				if not (x == 0 and y == 0 and z == 0) then
					ns[#ns + 1] = { x = x0 + x, y = y0 + y, z = z0 + z }
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

local dig_time_cache = {}
function util.get_dig_time(node_name, wielded, hand)
	local key = f("%s:%s:%s", node_name, wielded:to_string(), hand:to_string())
	local cached = dig_time_cache[key]
	if cached then
		return cached
	end

	local node_def = minetest.registered_nodes[node_name]
	if not node_def then
		return
	end

	local dig_params = get_dig_params(node_def.groups or {}, wielded:get_tool_capabilities())
	if not dig_params.diggable then
		dig_params = get_dig_params(node_def.groups or {}, hand:get_tool_capabilities())

		if not dig_params.diggable then
			return
		end
	end

	local time = dig_params.time
	dig_time_cache[key] = time
	return time
end

function util.in_bounds(pos, origin, shape)
	if shape.type == "prism" then
		local prism = shape.prism
		return math.abs(pos.x - origin.x) <= (prism.x - 1) -- TODO allow configurable fudge factor
			and math.abs(pos.y - origin.y) <= (prism.y - 1)
			and math.abs(pos.z - origin.z) <= (prism.z - 1)
	end

	return false
end

choppy.util = util
