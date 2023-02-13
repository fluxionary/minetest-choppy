futil.check_version({ year = 2023, month = 2, day = 1 })

choppy = fmod.create()

choppy.dofile("util")
choppy.dofile("api", "init")
choppy.dofile("callbacks")
choppy.dofile("known_axes")
choppy.dofile("known_trees")
choppy.dofile("commands")
