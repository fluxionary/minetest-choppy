local get_dig_params = minetest.get_dig_params

local s = choppy.settings

local util = {}

function util.get_neighbors(pos)
	local v_new = vector.new
	local sr = s.step_radius
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
	table.shuffle(ns, 2, 5)
	table.shuffle(ns, 6, 9)
	local i = 0
	return function()
		i = i + 1
		return ns[i]
	end
end

local function try_snappy_multiplier(toolcaps)
	return (
		s.leaves_mode == "snappy_multiplier"
		and toolcaps
		and toolcaps.groupcaps
		and toolcaps.groupcaps[s.choppy_cap_name]
		and not toolcaps.groupcaps[s.snappy_cap_name]
	)
end

local function get_snappy_caps(toolcaps)
	local choppy_caps = toolcaps.groupcaps[s.choppy_cap_name]
	local snappy_caps = {
		times = {},
		uses = choppy_caps.uses * s.snappy_multiplier,
		maxlevel = choppy_caps.maxlevel,
	}
	for k, time in pairs(choppy_caps.times) do
		snappy_caps.times[k] = time / s.snappy_multiplier
	end
	return {
		groupcaps = {
			[s.snappy_cap_name] = snappy_caps,
		},
	}
end

function util.get_dig_time_and_wear(node_name, wielded, hand)
	local node_def = minetest.registered_nodes[node_name]
	if not node_def then
		return
	end

	local node_groups = node_def.groups or {}
	local wielded_caps = wielded:get_tool_capabilities()
	local wielded_wear = wielded:get_wear()

	local dig_params = get_dig_params(node_groups, wielded_caps, wielded_wear)
	if dig_params.diggable then
		local dig_time = dig_params.time / s.dig_speed_multiplier
		dig_time = math.max(dig_time, 1 / s.max_trunks_per_second)
		return dig_time, dig_params.wear
	elseif try_snappy_multiplier(wielded_caps) then
		local snappy_caps = get_snappy_caps(wielded_caps)
		dig_params = get_dig_params(node_groups, snappy_caps, wielded_wear)
		if dig_params.diggable then
			return dig_params.time / s.dig_speed_multiplier, dig_params.wear
		end
	end

	-- if all else fails, use the hand
	dig_params = get_dig_params(node_def.groups or {}, hand:get_tool_capabilities(), hand:get_wear())

	if dig_params.diggable then
		return dig_params.time / s.dig_speed_multiplier, 0
	end
end

function util.will_digging_break_tool(node_name, wielded)
	local node_def = minetest.registered_nodes[node_name]
	if not node_def then
		return
	end

	local node_groups = node_def.groups or {}
	local wielded_caps = wielded:get_tool_capabilities()
	local wielded_wear = wielded:get_wear()

	local dig_params = get_dig_params(node_groups, wielded_caps, wielded_wear)
	local added_wear
	if dig_params.diggable then
		added_wear = dig_params.wear
	elseif try_snappy_multiplier(wielded_caps) then
		local snappy_caps = get_snappy_caps(wielded_caps)
		dig_params = get_dig_params(node_groups, snappy_caps, wielded_wear)
		if dig_params.diggable then
			added_wear = dig_params.wear
		end
	end

	return added_wear and wielded_wear + added_wear >= 65536
end

choppy.util = util
