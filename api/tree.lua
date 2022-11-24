local resolve_item = futil.resolve_item

local api = choppy.api

--[[
{
	nodes = {
		["default:tree"] = "trunk",
		["default:leaves"] = "leaves",
		["default:apple"] = "fruit",
	}
	shape = ...
}
]]

api.registered_trees = {}
api.trees_by_node = futil.DefaultTable(function()
	return {}
end)

function api.register_tree(tree_name, def)
	api.registered_trees[tree_name] = def
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

minetest.register_on_mods_loaded(function()
	-- we assume that all aliasing has happened at this point
	for tree_name, def in pairs(api.registered_trees) do
		local nodes = {}
		for node, type in pairs(def.nodes) do
			local resolved = resolve_item(node)
			if resolved then
				nodes[resolved] = type
			end
		end
		def.nodes = nodes
		for node_name, type in pairs(nodes) do
			table.insert(api.trees_by_node[node_name], tree_name)
		end
	end
end)
