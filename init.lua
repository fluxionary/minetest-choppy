futil.check_version({ year = 2023, month = 11, day = 1 }) -- is_player

choppy = fmod.create()

choppy.dofile("util")

choppy.dofile("api", "init")

choppy.dofile("callbacks")
choppy.dofile("commands")
choppy.dofile("drop_behavior")
choppy.dofile("first_use_form")
choppy.dofile("known_axes")
choppy.dofile("known_trees")

choppy.dofile("compat", "init")
