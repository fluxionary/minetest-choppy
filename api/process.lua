local get_node = minetest.get_node
local hash_node_position = minetest.hash_node_position

local get_dig_time_and_wear = choppy.util.get_dig_time_and_wear
local get_neighbors = choppy.util.get_neighbors

local api = choppy.api

local has_staminoid = choppy.has.staminoid

api.process_by_player = {}

api.registered_on_choppy_starts = {}
api.registered_on_choppy_stops = {}
api.registered_on_before_chops = {}

function api.register_on_choppy_start(callback)
	table.insert(api.registered_on_choppy_starts, callback)
end

function api.register_on_choppy_stop(callback)
	table.insert(api.registered_on_choppy_stops, callback)
end

function api.register_on_before_chop(callback)
	table.insert(api.registered_on_before_chops, callback)
end

local Process = futil.class1()
api.Process = Process

function Process:_init(start_pos, player_name, tree_name)
	self.start_pos = start_pos
	self.current_pos = start_pos
	self.player_name = player_name
	self.tree_name = tree_name
	self.tree_shape = api.registered_trees[tree_name].shape
	self.positions = futil.Deque()
	self.fringe = futil.Deque()
	self.fringe:push_back(start_pos)
	self.seen = {}
	self.elapsed = 0
	self.nodes_chopped = 0
end

function Process:targets_remaining()
	return self.positions:size()
end

function Process:is_complete()
	return self.positions:size() == 0 and self.fringe:size() == 0
end

function Process:is_valid_target(pos)
	if minetest.is_protected(pos, self.player_name) then
		return false
	end

	local node = get_node(pos)
	local node_name = node.name
	local node_type = api.is_same_tree(self.tree_name, node_name)
	if not node_type then
		return false
	end

	local def = minetest.registered_nodes[node_name] or {}
	if def.paramtype == "placed_by_player" and node.param1 > 0 then
		return false
	end

	return node_type
end

function Process:get_next_valid_target()
	local positions = self.positions
	self:ensure_positions()
	local pos = positions:pop_front()
	while pos do
		if self:is_valid_target(pos) then
			return pos
		else
			self:ensure_positions()
			pos = positions:pop_front()
		end
	end
end

function Process:should_add_position(pos, hash)
	return not self.seen[hash] and api.in_bounds(pos, self.start_pos, self.tree_shape) and self:is_valid_target(pos)
end

function Process:step_fringe()
	local fringe = self.fringe
	local next_pos = fringe:pop_front()

	if not next_pos then
		return
	end

	local positions = self.positions
	local seen = self.seen
	local any_added = false

	for neighbor in get_neighbors(next_pos) do
		local hash = hash_node_position(neighbor)
		local node_type = self:should_add_position(neighbor, hash)
		if node_type then
			if node_type == "trunk" or node_type == "leaves" then
				positions:push_back(neighbor)
			else
				-- prioritize fruit
				positions:push_front(neighbor)
			end
			fringe:push_back(neighbor)
			any_added = true
		end
		seen[hash] = true
	end

	return any_added
end

function Process:ensure_positions()
	local positions = self.positions
	local fringe = self.fringe
	while positions:size() == 0 and fringe:size() > 0 do
		self:step_fringe()
	end
end

local sound_cache = {}

local function play_sound(pos, node_name)
	local spec = sound_cache[node_name]
	if not spec then
		local def = minetest.registered_nodes[node_name]
		if not (def and def.sounds and def.sounds.dug) then
			return
		end
		spec = def.sounds.dug
		sound_cache[node_name] = spec
	end

	minetest.sound_play(spec, {
		pos = pos,
		max_hear_distance = 32,
	}, true)
end

local staminoid_disabled_by_player_name = {}
local function should_disable_staminoid(node_name)
	return minetest.get_item_group(node_name, "choppy") == 0
end

if has_staminoid then
	staminoid.register_on_exhaust_player(function(player, amount, reason)
		local player_name = player:get_player_name()
		if staminoid_disabled_by_player_name[player_name] and reason == "dig" then
			return 0
		end
	end)
end

function Process:on_globalstep(dtime, player)
	local elapsed = self.elapsed + dtime
	local player_name = player:get_player_name()
	local wielded = player:get_wielded_item()
	local hand = player:get_inventory():get_stack("hand", 1)
	local positions = self.positions
	local pos = self:get_next_valid_target()
	local node_dig = minetest.node_dig

	while pos do
		self.current_pos = pos
		local node = get_node(pos)
		local dig_time, wear = get_dig_time_and_wear(node.name, wielded, hand)

		if dig_time then
			if dig_time > elapsed then
				positions:push_front(pos) -- put it back at the front of the queue
				break
			end

			if wielded:get_wear() + wear >= 65536 then
				api.stop_process(self.player_name)
				return
			end

			local cancel_dig = false
			for _, callback in ipairs(api.registered_on_before_chops) do
				if callback(self, player, pos, node) then
					cancel_dig = true
					break
				end
			end

			if cancel_dig then
				break
			end

			if has_staminoid and should_disable_staminoid(node.name) then
				-- if node is not a trunk, temporarily disable staminoid
				staminoid_disabled_by_player_name[player_name] = true
				node_dig(pos, node, player)
				staminoid_disabled_by_player_name[player_name] = nil
			else
				node_dig(pos, node, player)
			end
			self.nodes_chopped = self.nodes_chopped + 1
			play_sound(pos, node.name)
			wielded = player:get_wielded_item()
			elapsed = elapsed - dig_time
		end

		pos = self:get_next_valid_target()
	end

	self.elapsed = elapsed
end

function api.get_process(player_name)
	return api.process_by_player[player_name]
end

function api.start_process(player, start_pos, tree_node)
	local player_name = player:get_player_name()
	local tree_name = assert(api.trees_by_node[tree_node][1], string.format("%q is not a tree node", tree_node))
	local process = Process(start_pos, player_name, tree_name)
	local found_targets = process:step_fringe()
	while found_targets == false do
		found_targets = process:step_fringe()
	end

	if not process:is_complete() then
		local abort_process = false
		for _, callback in ipairs(api.registered_on_choppy_starts) do
			if callback(process, player, start_pos, tree_node) then
				abort_process = true
				break
			end
		end

		if not abort_process then
			api.process_by_player[player_name] = process
		end
	end
end

function api.stop_process(player_name)
	api.process_by_player[player_name] = nil

	for _, callback in ipairs(api.registered_on_choppy_stops) do
		callback(player_name)
	end
end

function api.process_globalstep(dtime)
	for player_name, process in pairs(api.process_by_player) do
		local player = minetest.get_player_by_name(player_name)
		if player then
			process:on_globalstep(dtime, player)

			if process:is_complete() then
				api.stop_process(player_name)
			end
		else
			api.stop_process(player_name)
		end
	end
end
