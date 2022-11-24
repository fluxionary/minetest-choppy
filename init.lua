local f = string.format

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

choppy = {
	author = "flux",
	license = "AGPL_v3",
	version = os.time({ year = 2022, month = 11, day = 23 }),
	fork = "flux",

	modname = modname,
	modpath = modpath,
	S = S,

	has = {},

	log = function(level, messagefmt, ...)
		return minetest.log(level, f("[%s] %s", modname, f(messagefmt, ...)))
	end,

	dofile = function(...)
		return dofile(table.concat({ modpath, ... }, DIR_DELIM) .. ".lua")
	end,
}

choppy.dofile("util")
choppy.dofile("api", "init")
choppy.dofile("callbacks")
choppy.dofile("known_axes")
choppy.dofile("known_trees")
