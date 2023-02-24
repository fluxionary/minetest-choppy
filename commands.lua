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
