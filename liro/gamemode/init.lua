-- Liro - init.lua

-- Include dependant files
include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Define base Liro data array
liro = liro or {}

-- Add network string for client join information later
util.AddNetworkString("liro.receiveClientInformation")

-- Define serverside start time, will be used later in liro/moduleloader.lua for load time
liro.startTime = os.clock()

-- Include misc
include("liro/misc.lua")
AddCSLuaFile("liro/misc.lua")

-- Include shared configuration
include("liro/config.lua")
AddCSLuaFile("liro/config.lua")

-- Include functions
include("liro/functions.lua")
AddCSLuaFile("liro/functions.lua")

-- Include data management
include("liro/datamanagement.lua")

-- Include module loader
include("liro/moduleloader.lua")
AddCSLuaFile("liro/moduleloader.lua")