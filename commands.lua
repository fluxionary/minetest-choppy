local S = choppy.S
local api = choppy.api

minetest.register_chatcommand("toggle_choppy", {
	description = S("toggles whether choppy is enabled while sneaking or disabled while sneaking"),
	func = function(name)
		if api.toggle_enabled(name) then
			return true, S("press & hold sneak to enable choppy")
		else
			return false, S("press & hold sneak to disable choppy")
		end
	end,
})

minetest.register_chatcommand("visualize_choppy", {
	description = S("toggles whether choppy shows waypoints where cutting is occurring"),
	func = function(name)
		if api.toggle_visualize_enabled(name) then
			return true, S("visualization enabled")
		else
			return false, S("visualization disabled")
		end
	end,
})
