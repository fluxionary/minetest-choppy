local get_node = minetest.get_node
local hash_node_position = minetest.hash_node_position

local api = choppy.api

local get_dig_time = choppy.util.get_dig_time
local get_neighbors = choppy.util.get_neighbors
local in_bounds = choppy.util.in_bounds

api.process_by_player = {}

function api.is_good_position(pos, player_name, tree_name)
	if minetest.is_protected(pos, player_name) then
		return false
	end

	local node = get_node(pos)
	return api.is_same_tree(tree_name, node.name)
end

local function get_valid_front(positions, player_name, tree_name)
	-- peek the front, but ignore anything that's currently protected
	local pos = positions:peek_front()
	while pos do
		if api.is_good_position(pos, player_name, tree_name) then
			return pos
		else
			positions:pop_front()
			pos = positions:peek_front()
		end
	end
end

function api.get_process(player_name)
	return api.process_by_player[player_name]
end

local get_us_time = minetest.get_us_time

function api.create_process(start_pos, player_name, tree_name)
	local start = get_us_time()
	local tree_shape = api.registered_trees[tree_name].shape
	local positions = futil.Deque()
	local fringe = futil.Deque()
	local seen = { [hash_node_position(start_pos)] = true }

	local function should_add(pos, hash)
		return not seen[hash]
			and in_bounds(pos, start_pos, tree_shape)
			and api.is_good_position(pos, player_name, tree_name)
	end

	for neighbor in get_neighbors(start_pos) do
		local hash = hash_node_position(neighbor)
		if should_add(neighbor, hash) then
			positions:push_back(neighbor)
			fringe:push_back(neighbor)
		end
		seen[hash] = true
	end

	local next_pos = fringe:pop_front()

	while next_pos do
		for neighbor in get_neighbors(next_pos) do
			local hash = hash_node_position(neighbor)
			if should_add(neighbor, hash) then
				positions:push_back(neighbor)
				fringe:push_back(neighbor)
			end
			seen[hash] = true
		end

		next_pos = fringe:pop_front()
	end

	if positions:size() > 0 then
		minetest.chat_send_all(
			string.format(
				"[DEBUG] starting cutting %s w/ %s nodes in %.2f",
				tree_name,
				positions:size(),
				(get_us_time() - start) / 1e6
			)
		)

		return {
			tree = tree_name,
			positions = positions,
			elapsed = 0,
		}
	end
end

function api.start_process(player, pos, tree_node)
	local player_name = player:get_player_name()
	local tree_name = api.trees_by_node[tree_node][1]

	api.process_by_player[player_name] = api.create_process(pos, player_name, tree_name)
end

function api.stop_process(player_name)
	minetest.chat_send_all("[DEBUG] stopping process")
	api.process_by_player[player_name] = nil
end

function api.process_globalstep(dtime)
	for player_name, process in pairs(api.process_by_player) do
		local player = minetest.get_player_by_name(player_name)
		if player then
			local positions = process.positions
			local elapsed = process.elapsed + dtime
			local tree_name = process.tree
			local wielded = player:get_wielded_item()
			local hand = player:get_inventory():get_stack("hand", 1)
			local pos = get_valid_front(positions, player_name, tree_name)

			while pos do
				local node = get_node(pos)
				local dig_time = get_dig_time(node.name, wielded, hand)

				if dig_time then
					if dig_time > elapsed then
						break
					end
					-- todo 'before_dig_hook'
					minetest.node_dig(pos, node, player)
					elapsed = elapsed - dig_time
				end

				positions:pop_front()
				pos = get_valid_front(positions, player_name, tree_name)
			end

			if not pos then
				api.stop_process(player_name)
			else
				process.elapsed = elapsed
			end
		else
			api.stop_process(player_name)
		end
	end
end
