# choppy

yet another tree-cutting mod

## differences from other tree-cutting mods

* [x] no lag
* [x] cuts from the top down
* [x] recognizes specific species of tree (new trees must be registered)

  please ask me to add more trees! PRs or descriptions of the node IDs and tree size are appreciated,
  but i will add most or all trees :)

* [x] recognizes tree boundaries (very approximate, but can be extended)
* [x] axes must be whitelisted (commonly known axe names are whitelisted by default)

  please ask me to add your preferred axes!

* [x] respects protection
* [x] can be "on by default" - allows new players to discover the mechanic naturally.
* [x] will automatically stop before breaking your axe
* [x] digs nodes in proportion to the axe's true speed, and will "catch up" if there's lag.
* [x] differentiates player-built and natural trees when possible
  * NOTE: this only applies to structures built after this mod is installed.

### commands

* `/toggle_choppy`

  toggles whether you have to hold down "sneak" to enable choppy, or whether it will be enabled by default.

### settings

see [settingtypes.txt]

### api

* `choppy.api.register_axe(itemstring)`

  register a tool that will work as an axe

* `choppy.api.unregister_axe(itemstring)`

  unregister a tool that will work as an axe

* `choppy.api.is_enabled(player)`

  returns "true" if choppy mode is enabled for a player. this means that existing processes will continue,
  and new processes can be started.

* `choppy.api.toggle_enabled(player_name)`

  toggles whether the player has to hold down "sneak" to enable choppy, or whether it will be enabled by default.

* `choppy.api.register_on_choppy_start(function(process, player, start_pos, tree_node))`

  called when a choppy process is started. return "true" to abort the process.

* `choppy.api.register_on_choppy_stop(function(player_name))`

  called when a choppy process is stopped.

* `choppy.api.register_on_before_chop(function(process, player, pos, node))`

  called before chopping a node. return "true" to skip the node.

* `choppy.api.register_tree_shape(shape_name, def)`

  register a tree "shape", which allows limited ways of preventing multiple trees from being felled simultaneously.
  def includes two callbacks:

  * `in_bounds = function(pos, start_pos, shape)`

    called for each node which may be chopped.

  * `player_in_bounds = function(player_pos, start_pos, shape)`

    called to check whether the player has wandered away from the tree

* `choppy.api.register_tree(tree_name, def)`

  register a tree. def defines a shape and a map of nodes to their type (trunk, leaves, etc.)

* `choppy.api.unregister_tree(tree_name)`

  removes a tree from the registry
