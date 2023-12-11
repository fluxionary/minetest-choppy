local has_mod = minetest.get_modpath
local api = choppy.api

if has_mod("baldcypress") then
	api.register_tree("cooltrees:baldcypress", {
		shape = { type = "box", box = vector.new(11, 19, 11) },
		nodes = {
			["baldcypress:trunk"] = "trunk",
			["baldcypress:leaves"] = "leaves",
			["baldcypress:dry_branches"] = "fruit",
			["baldcypress:liana"] = "fruit",
		},
	})
end

if has_mod("birch") then
	api.register_tree("cooltrees:birch", {
		shape = { type = "box", box = vector.new(5, 6, 5) },
		nodes = {
			["birch:trunk"] = "trunk",
			["birch:leaves"] = "leaves",
		},
	})
end

if has_mod("cacaotree") then
	api.register_tree("cooltrees:cacaotree", {
		shape = { type = "box", box = vector.new(6, 7, 6) },
		nodes = {
			["cacaotree:trunk"] = "trunk",
			["cacaotree:leaves"] = "leaves",
			["cacaotree:flower_creeper"] = "fruit",
			["cacaotree:liana"] = "fruit",
			["cacaotree:pod"] = "fruit",
		},
	})
end

if has_mod("caverealms") then
	-- if ethereal is present, some versions of caverealms_lite uses ethereal's nodes; see ethereal mushroom for
	-- additional logic
	if minetest.registered_nodes["caverealms:mushroom_stem"] then
		api.register_tree("caverealms:mushroom", {
			shape = { type = "box", box = vector.new(8, 11, 8) },
			nodes = {
				["caverealms:mushroom_stem"] = "trunk",
				["caverealms:mushroom_cap"] = "trunk",
				["caverealms:mushroom_gills"] = "leaves",
			},
		})
	end
end

if has_mod("cherrytree") then
	api.register_tree("cooltrees:cherrytree", {
		shape = { type = "box", box = vector.new(6, 7, 6) },
		nodes = {
			["cherrytree:trunk"] = "trunk",
			["cherrytree:leaves"] = "leaves",
			["cherrytree:blossom_leaves"] = "leaves",
			["cherrytree:cherries"] = "fruit",
		},
	})
end

if has_mod("chestnuttree") then
	api.register_tree("cooltrees:chestnuttree", {
		shape = { type = "box", box = vector.new(14, 13, 14) },
		nodes = {
			["chestnuttree:trunk"] = "trunk",
			["chestnuttree:leaves"] = "leaves",
			["chestnuttree:bur"] = "fruit",
		},
	})
end

if has_mod("clementinetree") then
	api.register_tree("cooltrees:clementinetree", {
		shape = { type = "box", box = vector.new(5, 6, 5) },
		nodes = {
			["clementinetree:trunk"] = "trunk",
			["clementinetree:leaves"] = "leaves",
			["clementinetree:clementine"] = "fruit",
		},
	})
end

if has_mod("default") then
	api.register_tree("default:acacia_bush", {
		shape = { type = "box", box = vector.new(3, 2, 3) },
		nodes = {
			["default:acacia_bush_stem"] = "trunk",
			["default:acacia_bush_leaves"] = "leaves",
		},
	})

	api.register_tree("default:acacia", {
		shape = { type = "box", box = vector.new(9, 9, 9) },
		nodes = {
			["default:acacia_tree"] = "trunk",
			["default:acacia_leaves"] = "leaves",
		},
	})

	api.register_tree("default:aspen", {
		shape = { type = "box", box = vector.new(5, 11, 5) },
		nodes = {
			["default:aspen_tree"] = "trunk",
			["default:aspen_leaves"] = "leaves",
		},
	})

	api.register_tree("default:bush", {
		shape = { type = "box", box = vector.new(3, 2, 3) },
		nodes = {
			["default:bush_stem"] = "trunk",
			["default:bush_leaves"] = "leaves",
		},
	})

	api.register_tree("default:jungletree", {
		shape = { type = "box", box = vector.new(7, 26, 7) },
		nodes = {
			["default:jungletree"] = "trunk",
			["default:jungleleaves"] = "leaves",
		},
	})

	api.register_tree("default:pine_bush", {
		shape = { type = "box", box = vector.new(3, 2, 3) },
		nodes = {
			["default:pine_bush_stem"] = "trunk",
			["default:pine_bush_needles"] = "leaves",
		},
	})

	api.register_tree("default:pine", {
		shape = { type = "box", box = vector.new(5, 15, 5) },
		nodes = {
			["default:pine_tree"] = "trunk",
			["default:pine_needles"] = "leaves",
		},
	})

	api.register_tree("default:tree", {
		shape = { type = "box", box = vector.new(7, 7, 7) },
		nodes = {
			["default:tree"] = "trunk",
			["default:leaves"] = "leaves",
			["default:apple"] = "fruit",
		},
	})
end

if has_mod("ebony") then
	api.register_tree("cooltrees:ebony", {
		shape = { type = "box", box = vector.new(11, 16, 11) },
		nodes = {
			["ebony:trunk"] = "trunk",
			["ebony:leaves"] = "leaves",
			["ebony:persimmon"] = "fruit",
			["ebony:creeper"] = "fruit",
			["ebony:creeper_leaves"] = "fruit",
			["ebony:liana"] = "fruit",
		},
	})
end

if has_mod("ethereal") then
	api.register_tree("ethereal:bamboo", {
		shape = { type = "box", box = vector.new(3, 16, 3) },
		nodes = {
			["ethereal:bamboo"] = "trunk",
			["ethereal:bamboo_leaves"] = "leaves",
		},
	})

	api.register_tree("ethereal:banana", {
		shape = { type = "box", box = vector.new(7, 8, 7) },
		nodes = {
			["ethereal:banana_trunk"] = "trunk",
			["ethereal:bananaleaves"] = "leaves",
			["ethereal:banana"] = "fruit",
		},
	})

	api.register_tree("ethereal:birch", {
		shape = { type = "box", box = vector.new(5, 5, 5) },
		nodes = {
			["ethereal:birch_trunk"] = "trunk",
			["ethereal:birch_leaves"] = "leaves",
		},
	})

	api.register_tree("ethereal:frost", {
		shape = { type = "box", box = vector.new(8, 15, 8) },
		nodes = {
			["ethereal:frost_tree"] = "trunk",
			["ethereal:frost_leaves"] = "leaves",
		},
	})

	api.register_tree("ethereal:redwood", {
		shape = { type = "box", box = vector.new(15, 30, 15) },
		nodes = {
			["ethereal:redwood_trunk"] = "trunk",
			["ethereal:redwood_leaves"] = "leaves",
		},
	})

	-- ethereal has a hard dependency on default, this will always exist
	api.add_nodes_to_tree("default:tree", {
		["ethereal:lemon_leaves"] = "leaves",
		["ethereal:lemon"] = "fruit",
	})

	api.register_tree("ethereal:mushroom", {
		shape = { type = "box", box = vector.new(8, 11, 8) },
		nodes = {
			["ethereal:mushroom_trunk"] = "trunk",
			["ethereal:mushroom"] = "trunk",
			["ethereal:mushroom_pore"] = "leaves",
		},
	})

	if has_mod("caverealms") then
		api.add_nodes_to_tree("ethereal:mushroom", {
			["caverealms:mushroom_gills"] = "leaves",
		})
	end

	api.register_tree("ethereal:olive", {
		shape = { type = "box", box = vector.new(8, 9, 8) },
		nodes = {
			["ethereal:olive_trunk"] = "trunk",
			["ethereal:olive_leaves"] = "leaves",
			["ethereal:olive"] = "fruit",
		},
	})

	api.register_tree("ethereal:scorched", {
		shape = { type = "box", box = vector.new(1, 6, 1) },
		nodes = {
			["ethereal:scorched_tree"] = "trunk",
		},
	})

	-- ethereal has a hard dependency on default, this will always exist
	api.add_nodes_to_tree("default:tree", {
		["ethereal:orange_leaves"] = "leaves",
		["ethereal:orange"] = "fruit",
	})

	api.register_tree("ethereal:palm", {
		shape = { type = "box", box = vector.new(7, 8, 7) },
		nodes = {
			["ethereal:palm_trunk"] = "trunk",
			["ethereal:palmleaves"] = "leaves",
			["ethereal:coconut"] = "fruit",
		},
	})

	api.register_tree("ethereal:sakura", {
		shape = { type = "box", box = vector.new(10, 9, 10) },
		nodes = {
			["ethereal:sakura_trunk"] = "trunk",
			["ethereal:sakura_leaves"] = "leaves",
			["ethereal:sakura_leaves2"] = "leaves",
		},
	})

	api.register_tree("ethereal:willow", {
		shape = { type = "box", box = vector.new(12, 13, 12) },
		nodes = {
			["ethereal:willow_trunk"] = "trunk",
			["ethereal:willow_twig"] = "leaves",
		},
	})

	api.register_tree("ethereal:yellow", {
		shape = { type = "box", box = vector.new(9, 19, 9) },
		nodes = {
			["ethereal:yellow_trunk"] = "trunk",
			["ethereal:yellowleaves"] = "leaves",
			["ethereal:golden_apple"] = "fruit",
		},
	})
end

if has_mod("ferns") then
	api.register_tree("ferns:giant_tree_fern", {
		shape = { type = "box", box = vector.new(9, 16, 9) },
		nodes = {
			["ferns:fern_trunk_big"] = "trunk",
			["ferns:fern_trunk_big_top"] = "trunk",
			["ferns:tree_fern_leaves_giant"] = "leaves",
			["ferns:tree_fern_leave_big_end"] = "leaves",
			["ferns:tree_fern_leave_big"] = "leaves",
		},
	})

	api.register_tree("ferns:tree_fern", {
		shape = { type = "box", box = vector.new(1, 10, 1) },
		nodes = {
			["ferns:fern_trunk "] = "trunk",
			["ferns:tree_fern_leaves"] = "leaves",
			["ferns:tree_fern_leaves_02"] = "leaves",
		},
	})

	-- these tree ferns have their own logic for falling down, but they don't deal w/ the leaves. disable it.
	minetest.registered_nodes["ferns:fern_trunk_big"].after_destruct = nil
	minetest.registered_nodes["ferns:tree_fern_leave_big"].after_destruct = nil
	minetest.registered_nodes["ferns:fern_trunk"].after_destruct = nil
end

if has_mod("hollytree") then
	api.register_tree("hollytree:hollytree", {
		shape = { type = "box", box = vector.new(10, 12, 10) },
		nodes = {
			["hollytree:trunk"] = "trunk",
			["hollytree:leaves"] = "leaves",
		},
	})
end

if has_mod("jacaranda") then
	api.register_tree("jacaranda:jacaranda", {
		shape = { type = "box", box = vector.new(7, 8, 7) },
		nodes = {
			["jacaranda:trunk"] = "trunk",
			["jacaranda:blossom_leaves"] = "leaves",
		},
	})
end

if has_mod("larch") then
	api.register_tree("larch:larch", {
		shape = { type = "box", box = vector.new(11, 17, 11) },
		nodes = {
			["larch:trunk"] = "trunk",
			["larch:leaves"] = "leaves",
			["larch:moss"] = "fruit",
		},
	})
end

if has_mod("lemontree") then
	api.register_tree("lemontree:lemontree", {
		shape = { type = "box", box = vector.new(5, 7, 5) },
		nodes = {
			["lemontree:trunk"] = "trunk",
			["lemontree:leaves"] = "leaves",
			["lemontree:lemon"] = "fruit",
		},
	})
end

if has_mod("mahogany") then
	api.register_tree("mahogany:mahogany", {
		shape = { type = "box", box = vector.new(5, 7, 5) },
		nodes = {
			["mahogany:trunk"] = "trunk",
			["mahogany:leaves"] = "leaves",
			["mahogany:creeper"] = "other",
			["mahogany:flower_creeper"] = "other",
			["mahogany:hanging_creeper"] = "other",
		},
	})
end

if has_mod("mahogany") then
	api.register_tree("mahogany:mahogany", {
		shape = { type = "box", box = vector.new(7, 17, 7) },
		nodes = {
			["mahogany:trunk"] = "trunk",
			["mahogany:leaves"] = "leaves",
			["mahogany:creeper"] = "fruit",
			["mahogany:flower_creeper"] = "fruit",
			["mahogany:hanging_creeper"] = "fruit",
		},
	})
end

if has_mod("maple") then
	api.register_tree("maple:maple", {
		shape = { type = "box", box = vector.new(10, 10, 10) },
		nodes = {
			["maple:trunk"] = "trunk",
			["maple:leaves"] = "leaves",
		},
	})
end

if has_mod("moretrees") then
	api.register_tree("moretrees:apple", {
		shape = { type = "box", box = vector.new(18, 9, 18) },
		nodes = {
			["moretrees:apple_tree_trunk"] = "trunk",
			["moretrees:apple_tree_leaves"] = "leaves",
			["moretrees:apple_blossoms"] = "leaves",
			["default:apple"] = "fruit",
		},
	})

	api.register_tree("moretrees:beech", {
		shape = { type = "box", box = vector.new(9, 8, 9) },
		nodes = {
			["moretrees:beech_trunk"] = "trunk",
			["moretrees:beech_leaves"] = "leaves",
		},
	})

	api.register_tree("moretrees:birch", {
		shape = { type = "box", box = vector.new(14, 24, 14) },
		nodes = {
			["moretrees:birch_trunk"] = "trunk",
			["moretrees:birch_leaves"] = "leaves",
		},
	})

	api.register_tree("moretrees:cedar", {
		shape = { type = "box", box = vector.new(15, 26, 15) },
		nodes = {
			["moretrees:cedar_trunk"] = "trunk",
			["moretrees:cedar_leaves"] = "leaves",
			["moretrees:cedar_cone"] = "fruit",
		},
	})

	api.register_tree("moretrees:date_palm", {
		shape = { type = "box", box = vector.new(23, 30, 23) },
		nodes = {
			["moretrees:date_palm_trunk"] = "trunk",
			["moretrees:date_palm_ffruit_trunk"] = "trunk",
			["moretrees:date_palm_fruit_trunk"] = "trunk",
			["moretrees:date_palm_mfruit_trunk"] = "trunk",
			["moretrees:date_palm_leaves"] = "leaves",
			["moretrees:dates_f0"] = "fruit",
			["moretrees:dates_f1"] = "fruit",
			["moretrees:dates_f2"] = "fruit",
			["moretrees:dates_f3"] = "fruit",
			["moretrees:dates_f4"] = "fruit",
			["moretrees:dates_fn"] = "fruit",
			["moretrees:dates_m0"] = "fruit",
			["moretrees:dates_n"] = "fruit",
		},
	})

	api.register_tree("moretrees:douglas_fir", {
		shape = { type = "box", box = vector.new(7, 28, 7) },
		nodes = {
			["moretrees:fir_trunk"] = "trunk",
			["moretrees:fir_leaves"] = "leaves",
			["moretrees:fir_leaves_bright"] = "leaves",
			["moretrees:fir_cone"] = "fruit",
		},
	})

	api.register_tree("moretrees:jungletree", {
		shape = { type = "box", box = vector.new(15, 35, 15) },
		nodes = {
			["moretrees:jungletree_trunk"] = "trunk",
			["default:jungleleaves"] = "leaves",
			["moretrees:jungletree_leaves_red"] = "leaves",
			["moretrees:jungletree_leaves_yellow"] = "leaves",
		},
	})

	api.register_tree("moretrees:oak", {
		shape = { type = "box", box = vector.new(15, 15, 15) },
		nodes = {
			["moretrees:oak_trunk"] = "trunk",
			["moretrees:oak_leaves"] = "leaves",
			["moretrees:acorn"] = "fruit",
		},
	})

	api.register_tree("moretrees:palm", {
		shape = { type = "box", box = vector.new(18, 15, 18) },
		nodes = {
			["moretrees:palm_trunk"] = "trunk",
			["moretrees:palm_fruit_trunk"] = "trunk",
			["moretrees:palm_fruit_trunk_gen"] = "trunk",
			["moretrees:palm_leaves"] = "leaves",
			["moretrees:coconut"] = "fruit",
			["moretrees:coconut_0"] = "fruit",
			["moretrees:coconut_1"] = "fruit",
			["moretrees:coconut_2"] = "fruit",
			["moretrees:coconut_3"] = "fruit",
		},
	})

	api.register_tree("moretrees:poplar", {
		shape = { type = "box", box = vector.new(5, 26, 5) },
		nodes = {
			["moretrees:poplar_trunk"] = "trunk",
			["moretrees:poplar_leaves"] = "leaves",
		},
	})

	api.register_tree("moretrees:rubber", {
		shape = { type = "box", box = vector.new(17, 13, 17) },
		nodes = {
			["moretrees:rubber_tree_trunk"] = "trunk",
			["moretrees:rubber_tree_trunk_empty"] = "trunk",
			["moretrees:rubber_tree_leaves"] = "leaves",
		},
	})

	api.register_tree("moretrees:sequoia", {
		shape = { type = "box", box = vector.new(18, 42, 18) },
		nodes = {
			["moretrees:sequoia_trunk"] = "trunk",
			["moretrees:sequoia_leaves"] = "leaves",
		},
	})

	api.register_tree("moretrees:spruce", {
		shape = { type = "box", box = vector.new(19, 34, 19) },
		nodes = {
			["moretrees:spruce_trunk"] = "trunk",
			["moretrees:spruce_leaves"] = "leaves",
			["moretrees:spruce_cone"] = "fruit",
		},
	})

	api.register_tree("moretrees:willow", {
		shape = { type = "box", box = vector.new(22, 14, 22) },
		nodes = {
			["moretrees:willow_trunk"] = "trunk",
			["moretrees:willow_leaves"] = "leaves",
		},
	})
end

if has_mod("oak") then
	api.register_tree("oak:oak", {
		shape = { type = "box", box = vector.new(11, 17, 11) },
		nodes = {
			["oak:trunk"] = "trunk",
			["oak:leaves"] = "leaves",
			["oak:acorn"] = "fruit",
		},
	})
end

if has_mod("palm") then
	api.register_tree("palm:palm", {
		shape = { type = "box", box = vector.new(7, 6, 7) },
		nodes = {
			["palm:trunk"] = "trunk",
			["palm:leaves"] = "leaves",
			["palm:coconut"] = "fruit",
		},
	})
end

if has_mod("plumtree") then
	api.register_tree("plumtree:plumtree", {
		shape = { type = "box", box = vector.new(9, 11, 9) },
		nodes = {
			["plumtree:trunk"] = "trunk",
			["plumtree:leaves"] = "leaves",
			["plumtree:plum"] = "fruit",
		},
	})
end

if has_mod("pomegranate") then
	api.register_tree("pomegranate:pomegranate", {
		shape = { type = "box", box = vector.new(3, 5, 3) },
		nodes = {
			["pomegranate:trunk"] = "trunk",
			["pomegranate:leaves"] = "leaves",
			["pomegranate:pomegranate"] = "fruit",
		},
	})
end

if has_mod("sequoia") then
	api.register_tree("sequoia:sequoia", {
		shape = { type = "box", box = vector.new(17, 48, 17) },
		nodes = {
			["sequoia:trunk"] = "trunk",
			["sequoia:leaves"] = "leaves",
		},
	})
end

if has_mod("willow") then
	api.register_tree("willow:willow", {
		shape = { type = "box", box = vector.new(10, 12, 10) },
		nodes = {
			["willow:trunk"] = "trunk",
			["willow:leaves"] = "leaves",
		},
	})
end

if has_mod("x_farming") then
	api.register_tree("x_farming:kiwi", {
		shape = { type = "box", box = vector.new(5, 4, 5) },
		nodes = {
			["x_farming:kiwi_tree"] = "trunk",
			["x_farming:kiwi_leaves"] = "leaves",
			["x_farming:kiwi"] = "fruit",
		},
	})

	api.register_tree("x_farming:cocoa", {
		shape = { type = "box", box = vector.new(5, 18, 5) },
		nodes = {
			["x_farming:jungle_tree"] = "trunk",
			["x_farming:jungle_leaves"] = "leaves",
			["x_farming:cocoa_1"] = "fruit",
			["x_farming:cocoa_2"] = "fruit",
			["x_farming:cocoa_3"] = "fruit",
		},
	})

	api.register_tree("x_farming:pine_nut", {
		shape = { type = "box", box = vector.new(5, 7, 5) },
		nodes = {
			["x_farming:pine_nut_tree"] = "trunk",
			["x_farming:pine_nut_leaves"] = "leaves",
			["x_farming:pine_nut"] = "fruit",
		},
	})
end
