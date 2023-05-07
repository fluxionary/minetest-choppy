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

see [API.md]
