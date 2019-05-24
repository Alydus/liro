-- Liro - init.lua

-- Micro optimisations
local include = include
local AddCSLuaFile = AddCSLuaFile
local util = util
local os = os
local math = math

-- Include dependant files
include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local isRefresh = false

if liro then
	isRefresh = true
end

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

if isRefresh and liro.bootComplete then
	liro.diagnosticPrint("Lua Auto-Refresh loaded Liro " .. GM.LiroVersion .. " serverside code in " .. math.Round(os.clock() - liro.startTime, 3) .. " second(s).")
else
	liro.diagnosticPrint("Successfully loaded Liro " .. GM.LiroVersion .. " in " .. math.Round(os.clock() - liro.startTime, 3) .. " second(s).")
end

liro.bootComplete = true
