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

function util.get_dig_time_and_wear(node_name, wielded, hand)
	local node_def = minetest.registered_nodes[node_name]
	if not node_def then
		return
	end

	local dig_params = get_dig_params(node_def.groups or {}, wielded:get_tool_capabilities())
	if dig_params.diggable then
		return dig_params.time, dig_params.wear
	else
		dig_params = get_dig_params(node_def.groups or {}, hand:get_tool_capabilities())

		if dig_params.diggable then
			return dig_params.time, 0
		end
	end
end

choppy.util = util
