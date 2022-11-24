local api = choppy.api

if minetest.get_modpath("default") then
	api.register_axe("default:axe_bronze")
	api.register_axe("default:axe_diamond")
	api.register_axe("default:axe_mese")
	api.register_axe("default:axe_steel")
	api.register_axe("default:axe_stone")
	api.register_axe("default:axe_wood")

	if minetest.get_modpath("enchanting") then
		api.register_axe("default:enchanted_axe_bronze_durable")
		api.register_axe("default:enchanted_axe_bronze_fast")
		api.register_axe("default:enchanted_axe_diamond_durable")
		api.register_axe("default:enchanted_axe_diamond_fast")
		api.register_axe("default:enchanted_axe_mese_durable")
		api.register_axe("default:enchanted_axe_mese_fast")
		api.register_axe("default:enchanted_axe_steel_durable")
		api.register_axe("default:enchanted_axe_steel_fast")
	end
end

if minetest.get_modpath("ethereal") then
	api.register_axe("ethereal:axe_crystal")
end

if minetest.get_modpath("moreores") then
	api.register_axe("moreores:axe_mithril")
	api.register_axe("moreores:axe_silver")

	if minetest.get_modpath("enchanting") then
		api.register_axe("moreores:enchanted_axe_mithril_durable")
		api.register_axe("moreores:enchanted_axe_mithril_fast")
		api.register_axe("moreores:enchanted_axe_silver_durable")
		api.register_axe("moreores:enchanted_axe_silver_fast")
	end
end

if minetest.get_modpath("nether") then
	api.register_axe("nether:axe_nether")
end

if minetest.get_modpath("rainbow_ore") then
	api.register_axe("rainbow_ore:rainbow_ore_axe")
end
