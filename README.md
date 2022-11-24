# choppy

yet another treecutting mod

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
