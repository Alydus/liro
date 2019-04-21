-- Liro - cl_init.lua

-- Include dependant files
include("shared.lua")

-- Define base Liro data array
liro = liro or {}

-- Define clientside start time, will be used later in liro/moduleloader.lua for load time
liro.startTime = os.clock()

-- Include misc
include("liro/misc.lua")

-- Include shared configuration
include("liro/config.lua")

-- Include functions
include("liro/functions.lua")

-- Include module loader
include("liro/moduleloader.lua")