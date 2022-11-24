local api = choppy.api

api.registered_axes = {}

function api.register_axe(itemstring)
	api.registered_axes[itemstring] = true
end

function api.is_axe(itemstring)
	return api.registered_axes[itemstring] or false
end
