local api = choppy.api

api.registered_axes = {}

function api.register_axe(itemstring)
	api.registered_axes[itemstring] = true
end

function api.unregister_axe(itemstring)
	api.registered_axes[itemstring] = nil
end

function api.is_axe(itemstring)
	return api.registered_axes[itemstring] or false
end

function api.is_wielding_axe(player)
	return api.is_axe(player:get_wielded_item():get_name())
end
