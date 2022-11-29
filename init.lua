futil.check_version({ year = 2022, month = 11, day = 22 })

choppy = fmod.create()

choppy.dofile("util")
choppy.dofile("api", "init")
choppy.dofile("callbacks")
choppy.dofile("known_axes")
choppy.dofile("known_trees")
choppy.dofile("commands")
