# choppy

yet another tree-cutting mod

## differences from other tree-cutting mods

* very little lag
* doesn't try to violate protection
* recognizes specific species of tree
* recognizes tree boundaries (very approximate, but can be extended)
* axes must be whitelisted (commonly known axe names are whitelisted by default)
* can be "on by default"
* differentiates player-built and natural trees
  * overrides tree nodes
    * paramtype1 becomes "placed_by_player"
    * a player placing a tree node will set param1 = 1
  * player-built tree nodes will be ignored

# TODO

* ***add HUD***
* don't compute full list of positions immediately; that's still too slow
  * are mapgen objects any help?
  * add fringe and seen to process
* add command to toggle behavior
* add settings:
  * radius beyond edge of tree, which should also be searched
  * max distance between player and tree (needs to scale to size of tree)
* callbacks
  * register_on_choppy_start
  * register_on_choppy_stop
  * register_on_before_chop
* add more trees
* add "generic" behavior for nodes in "group:tree" and "group:leaves" that aren't other registered
* possibly, prioritize harvesting fruit, then leaves, then trunks?
* don't break tools
* possibly allow cutting leaves quickly even when not wielded a sword...
* perhaps cut the tree from the top down?
* perhaps stop if the player un-equips an axe?
* create API for adding tree shapes
* probably should add a proper API to remove axes from the whitelist
