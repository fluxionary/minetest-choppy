* `choppy.api.register_axe(itemstring)`

  register a tool that will work as an axe

* `choppy.api.unregister_axe(itemstring)`

  unregister a tool that will work as an axe

* `choppy.api.is_enabled(player)`

  returns "true" if choppy mode is enabled for a player. this means that existing processes will continue,
  and new processes can be started.

* `choppy.api.toggle_sneak_enabled(player_name)`

  toggles whether the player has to hold down "sneak" to enable choppy, or whether it will be enabled by default.

* `choppy.api.register_on_choppy_start(function(process, player, start_pos, tree_node))`

  called when a choppy process is started. return "true" to abort the process.

* `choppy.api.register_on_choppy_stop(function(player_name))`

  called when a choppy process is stopped.

* `choppy.api.register_check_before_chop(function(process, player, pos, node))`

  called before chopping a node. return "true" to skip the node (process continues).

* `choppy.api.register_tree_shape(shape_name, def)`

  register a tree "shape", which allows limited ways of preventing multiple trees from being felled simultaneously.
  def includes two callbacks:

  * `in_bounds = function(pos, base_pos, shape)`

    called for each node which may be chopped.

  * `player_in_bounds = function(player_pos, base_pos, shape)`

    called to check whether the player has wandered away from the tree

* `choppy.api.register_tree(tree_name, def)`

  register a tree. def defines a shape and a map of nodes to their type (trunk, leaves, etc.)

* `choppy.api.unregister_tree(tree_name)`

  removes a tree from the registry
