local abs = math.abs

local resolve_item = futil.resolve_item

local halo_size = choppy.settings.halo_size
local player_scale = choppy.settings.player_scale

local api = choppy.api

api.registered_tree_shapes = {}
function api.register_tree_shape(shape_name, def)
	api.registered_tree_shapes[shape_name] = def
end

api.registered_trees = {}
api.trees_by_node = futil.DefaultTable(function()
	return {}
end)

function api.register_tree(tree_name, def)
	api.registered_trees[tree_name] = def
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

minetest.register_on_mods_loaded(function()
	-- we assume that all aliasing has happened at this point
	for tree_name, def in pairs(api.registered_trees) do
		local nodes = {}
		for node, type in pairs(def.nodes) do
			local resolved = resolve_item(node)
			if resolved then
				nodes[resolved] = type

				local node_def = minetest.registered_nodes[resolved]
				local paramtype = node_def.paramtype
				if not paramtype or paramtype == "" or paramtype == "none" then
					minetest.override_item(resolved, {
						paramtype = "placed_by_player",
					})
				end
			end
		end
		def.nodes = nodes
		for node_name, type in pairs(nodes) do
			table.insert(api.trees_by_node[node_name], tree_name)
		end
	end
end)

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

function api.in_bounds(pos, start_pos, shape)
	return api.registered_tree_shapes[shape.type].in_bounds(pos, start_pos, shape)
end

function api.player_in_bounds(player_pos, start_pos, shape)
	return api.registered_tree_shapes[shape.type].player_in_bounds(player_pos, start_pos, shape)
end
