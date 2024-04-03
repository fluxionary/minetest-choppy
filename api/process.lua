local get_node = minetest.get_node
local hash_node_position = minetest.hash_node_position

local get_dig_time_and_wear = choppy.util.get_dig_time_and_wear
local get_neighbors = choppy.util.get_neighbors

local api = choppy.api

api.process_by_player = {}

api.registered_on_choppy_starts = {}
api.registered_on_choppy_stops = {}

api.registered_check_before_chops = {}
api.registered_before_chops = {}
api.registered_after_chops = {}

function api.register_on_choppy_start(callback)
	table.insert(api.registered_on_choppy_starts, callback)
end

function api.register_on_choppy_stop(callback)
	table.insert(api.registered_on_choppy_stops, callback)
end

function api.register_check_before_chop(callback)
	table.insert(api.registered_check_before_chops, callback)
end

function api.register_before_chop(callback)
	table.insert(api.registered_before_chops, callback)
end

function api.register_after_chop(callback)
	table.insert(api.registered_after_chops, callback)
end

local Process = futil.class1()
api.Process = Process

function Process:_init(base_pos, start_pos, player_name, tree_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end
	self.base_pos = base_pos
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
	self.paused_by_source = {}
	self.is_digging = false
end

function Process:set_paused(paused, source)
	if not source then
		error("set_paused requires a second argument to allow pauses for multiple reasons.")
	end
	if paused then
		self.paused_by_source[source] = paused
	else
		self.paused_by_source[source] = nil
	end
end

function Process:is_paused()
	return next(self.paused_by_source) ~= nil
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
	if node.name == "air" and vector.equals(pos, self.base_pos) then
		return "base_pos"
	end

	local node_type = api.is_same_tree(self.tree_name, node_name)
	if not node_type then
		return false
	end

	local def = minetest.registered_nodes[node_name] or {}
	if def._choppy_placed_by_player and node.param1 > 0 then
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

function Process:peek_next_valid_target()
	local positions = self.positions
	self:ensure_positions()
	local pos = positions:pop_front()
	while pos do
		if self:is_valid_target(pos) then
			positions:push_front(pos)
			return pos
		else
			self:ensure_positions()
			pos = positions:pop_front()
		end
	end
end

function Process:should_add_position(pos, hash)
	return not self.seen[hash] and api.in_bounds(pos, self.base_pos, self.tree_shape) and self:is_valid_target(pos)
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

function Process:on_globalstep(dtime, player)
	if self:is_paused() then
		return
	end

	local elapsed
	local wielded = player:get_wielded_item()
	local hand = player:get_inventory():get_stack("hand", 1)
	local positions = self.positions
	local pos = self:get_next_valid_target()
	local node_dig = minetest.node_dig

	while pos do
		self.current_pos = pos
		local node = get_node(pos)

		local skip_node = false
		for _, callback in ipairs(api.registered_check_before_chops) do
			if callback(self, player, pos, node) then
				skip_node = true
				break
			end
		end

		if not skip_node then
			local dig_time, wear = get_dig_time_and_wear(node.name, wielded, hand)

			if dig_time then
				if not elapsed then
					-- this is initialized here so that we don't advance the timer if a dig event is cancelled
					elapsed = (self.elapsed or 0) + dtime
				end

				if dig_time > elapsed then
					-- not enough time has elapsed to dig another node
					positions:push_front(pos) -- put it back at the front of the queue
					break
				end

				if wielded:get_wear() + wear >= 65536 then
					self:set_paused(true, "no axe")
					return
				end

				for _, callback in ipairs(api.registered_before_chops) do
					callback(self, player, pos, node)
				end
				self.is_digging = true
				node_dig(pos, node, player)
				self.is_digging = false
				for _, callback in ipairs(api.registered_after_chops) do
					callback(self, player, pos, node)
				end

				self.nodes_chopped = self.nodes_chopped + 1
				play_sound(pos, node.name)
				wielded = player:get_wielded_item()
				elapsed = elapsed - dig_time

				if self:is_paused() then
					break
				end
			end
		end

		pos = self:get_next_valid_target()
	end

	self.elapsed = elapsed
end

function api.get_process(player_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end
	return api.process_by_player[player_name]
end

function api.start_process(player, base_pos, start_pos, tree_node)
	local tree_name = assert(api.trees_by_node[tree_node][1], string.format("%q is not a tree node", tree_node))
	local process = Process(base_pos, start_pos, player, tree_name)
	local found_targets = process:step_fringe()
	while found_targets == false do
		found_targets = process:step_fringe()
	end

	if not process:is_complete() then
		local abort_process = false
		for _, callback in ipairs(api.registered_on_choppy_starts) do
			if callback(process, player, tree_node) then
				abort_process = true
				break
			end
		end

		if not abort_process then
			local player_name = player:get_player_name()
			api.process_by_player[player_name] = process
		end
	end
end

function api.stop_process(player_name)
	if type(player_name) ~= "string" then
		player_name = player_name:get_player_name()
	end
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
