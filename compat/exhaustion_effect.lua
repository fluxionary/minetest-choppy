exhaustion_effect.effect:register_on_change(function(self, player, new_total, old_total)
	local player_name = player:get_player_name()
	local process = choppy.api.get_process(player_name)
	if process then
		process:set_paused(new_total > 0, "exhausted")
	end
end)
