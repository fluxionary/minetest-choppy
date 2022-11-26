local abs = math.abs

local get_node = minetest.get_node
local hash_node_position = minetest.hash_node_position

local sum = futil.math.sum

local get_neighbors_above = choppy.util.get_neighbors_above

local halo_size = choppy.settings.halo_size
local player_scale = choppy.settings.player_scale

local api = choppy.api

api.registered_tree_shapes = {}
api.registered_trees = {}
api.trees_by_node = futil.DefaultTable(function()
	return {}
end)

function api.register_tree_shape(shape_name, def)
	api.registered_tree_shapes[shape_name] = def
end

function api.in_bounds(pos, start_pos, shape)
	return api.registered_tree_shapes[shape.type].in_bounds(pos, start_pos, shape)
end

function api.player_in_bounds(player_pos, start_pos, shape)
	return api.registered_tree_shapes[shape.type].player_in_bounds(player_pos, start_pos, shape)
end

api.register_tree_shape("prism", {
	in_bounds = function(pos, start_pos, shape)
		local prism = shape.prism
		return abs(pos.x - start_pos.x) <= (prism.x - 1 + halo_size)
			and abs(pos.y - start_pos.y) <= (prism.y - 1 + halo_size)
			and abs(pos.z - start_pos.z) <= (prism.z - 1 + halo_size)
	end,

	player_in_bounds = function(player_pos, start_pos, shape)
		local prism = shape.prism
		return abs(player_pos.x - start_pos.x) <= (prism.x * player_scale)
			and abs(player_pos.y - start_pos.y) <= (prism.y * player_scale)
			and abs(player_pos.z - start_pos.z) <= (prism.z * player_scale)
	end,
})

function api.register_tree(tree_name, def)
	api.registered_trees[tree_name] = def
end

function api.add_nodes_to_tree(tree_name, extra_nodes)
	local def = api.registered_trees[tree_name]
	for node_name, node_type in pairs(extra_nodes) do
		def.nodes[node_name] = node_type
	end
end

function api.unregister_tree(tree_name)
	api.registered_trees[tree_name] = nil
end

function api.is_tree_node(node_name, kind)
	local trees = rawget(api.trees_by_node, node_name)
	if not trees then
		return false
	end

	local registered_trees = api.registered_trees

	for _, tree_name in ipairs(trees) do
		local node_kind = registered_trees[tree_name].nodes[node_name]
		if node_kind and (not kind or kind == node_kind) then
			return true
		end
	end

	return false
end

function api.get_tree_and_kind(node_name)
	local trees = rawget(api.trees_by_node, node_name)
	if not trees then
		return
	end

	local registered_trees = api.registered_trees

	for _, tree_name in ipairs(trees) do
		local node_kind = registered_trees[tree_name].nodes[node_name]
		if node_kind then
			return tree_name, node_kind
		end
	end
end

function api.is_same_tree(tree_name, node_name)
	if not api.registered_trees[tree_name] then
		error(string.format("unknown tree %s (%s)", tree_name, node_name))
	end

	return api.registered_trees[tree_name].nodes[node_name]
end

function api.get_tree_image(tree_name)
	local def = api.registered_trees[tree_name]
	for node_name, kind in pairs(def.nodes) do
		if kind == "trunk" then
			local node_def = minetest.registered_nodes[node_name]
			if node_def then
				local inventory_image = node_def.inventory_image
				if inventory_image and inventory_image ~= "" then
					return inventory_image
				end
				local wield_image = node_def.wield_image
				if wield_image and wield_image ~= "" then
					return wield_image
				end
				local tiles = node_def.tiles
				if tiles then
					if type(tiles) == "string" then
						return tiles
					elseif type(tiles) == "table" and #tiles > 0 then
						local tile = tiles[1]
						if type(tile) == "string" then
							return tile
						elseif type(tile) == "table" and tile.name then
							return tile.name
						end
					end
				end
			end
		end
	end
end

function api.find_treetop(start_pos, node, player_name)
	local node_name = node.name
	local tree_name, node_kind = api.get_tree_and_kind(node_name)
	if not (tree_name and node_kind == "trunk") then
		return
	end
	local tree_def = api.registered_trees[tree_name]
	local tree_shape = tree_def.shape
	local fringe = { start_pos }
	local seen = {}
	local registered_nodes = minetest.registered_nodes

	local function is_valid_target(pos)
		if minetest.is_protected(pos, player_name) then
			return false
		end

		local target_node = get_node(pos)
		local target_node_name = target_node.name
		local node_type = api.is_same_tree(tree_name, target_node_name)
		if not node_type then
			return false
		end

		local def = registered_nodes[target_node_name] or {}
		if def.paramtype == "placed_by_player" and target_node.param1 > 0 then
			return false
		end

		return node_type
	end

	local function should_add_position(pos, hash)
		return not seen[hash] and api.in_bounds(pos, start_pos, tree_shape) and is_valid_target(pos)
	end

	-- search upward and outward
	while true do
		local next_fringe = {}
		local aboves = {}
		for i = 1, #fringe do
			aboves[#aboves + 1] = get_neighbors_above(fringe[i])
		end
		local o = 1
		while o <= 9 and #next_fringe <= 9 do
			for i = 1, #aboves do
				local neighbor = aboves[i]()
				local hash = hash_node_position(neighbor)
				if should_add_position(neighbor, hash) then
					next_fringe[#next_fringe + 1] = neighbor
				end
				seen[hash] = true
			end
			o = o + 1
		end

		if #next_fringe > 0 then
			fringe = next_fringe
		else
			break
		end
	end

	local v_distance = vector.distance
	if #fringe > 0 then
		local centroid = sum(fringe) / #fringe
		table.sort(fringe, function(a, b)
			return v_distance(a, centroid) < v_distance(b, centroid)
		end)
		local to_return = fringe[1]
		if not vector.equals(start_pos, to_return) then
			return to_return
		end
	end
end
