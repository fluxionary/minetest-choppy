local s = minetest.settings

choppy.settings = {
	halo_size = tonumber(s:get("choppy.halo_size")) or 0,
	player_scale = tonumber(s:get("choppy.player_scale")) or 1,
}
