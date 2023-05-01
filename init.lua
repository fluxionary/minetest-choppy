futil.check_version({ year = 2023, month = 3, day = 26 })

choppy = fmod.create()

choppy.dofile("util")
choppy.dofile("api", "init")
choppy.dofile("callbacks")
choppy.dofile("drop_behavior")
choppy.dofile("known_axes")
choppy.dofile("known_trees")
choppy.dofile("commands")

choppy.dofile("compat", "init")
