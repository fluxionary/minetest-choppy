choppy.api.register_on_before_chop(function(self, player, pos, node)
	if exhaustion_effect.effect:value(player) > 0 then
		-- abort chopping
		return true
	end
end)
