local s = minetest.settings

choppy.settings = {
	halo_size = tonumber(s:get("choppy.halo_size")) or 1,
	player_scale = tonumber(s:get("choppy.player_scale")) or 1.1,
	fast_leaves = s:get_bool("choppy:fast_leaves", true),
	step_radius = tonumber(s:get("choppy.player_scale")) or 2,
}
