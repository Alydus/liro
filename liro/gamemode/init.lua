-- Liro - init.lua

-- Include dependant files
include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Define base Liro data array
liro = liro or {}

-- Include shared configuration
include("liro/config.lua")
AddCSLuaFile("liro/config.lua")

-- LUA Autorefresh Warning
if liro and liro.config.doAutoRefreshWarning then
  print("Change has been detected, Liro will now re-initialize.")
end

-- Include functions
include("liro/functions.lua")
AddCSLuaFile("liro/functions.lua")

-- Include module loader
include("liro/moduleloader.lua")
AddCSLuaFile("liro/moduleloader.lua")
