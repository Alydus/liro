-- Liro - liro/config.lua

-- This is the main configuration file for the Liro gamemode base, it
-- allows you to customize the boot of the gamemode.

liro.config = {
	-- Output basic module load information on gamemode initialization?
	doModuleLoadMessages = true,

	-- Enable the module system?
	enableModules = true, 

	-- Enable developer hooks for liro events?
	enableDeveloperHooks = true,

	-- Enable AddNetworkString table?
	enableNetworkStrings = true,

	-- Include your network strings in here and they will be util.AddNetworkString'd before module initalization. (e.g. "networkString", "")
	-- This will only work if enableNetworkStrings is set to true.
	-- Note that util.AddNetworkString only supports 2048 networkStrings.
	networkStrings = {},

	-- Disable any modules? (e.g. "moduleName", "")
	disabledModules = {},

	-- Global prefixes that define the enviroment that the file will be loaded in.
	-- These prefixes are overidden if the module has a perModuleLoadPrefix set.
	moduleLoadPrefixes = {
		server = "sv_",
		client = "cl_",
		shared = "sh_"
	},
  
	-- When installing a module, you should be informed if the module has specific load prefixes.
	-- If so, define them in perModuleLoadPrefixes.

  	perModuleLoadPrefixes = {
		--[[simpledebug = {
    			server = "sv_",
			client = "cl_",
			shared = "sh_"
      		}--]]
	},
}

--[[-------------------------------------------------------------------------
Developer Hooks
-----------------------------------------------------------------------------
	All of the following hooks are shared (avaliable on all enviroments)

	-- Attempt hooks
	liro.attemptLoadModules - Called when liro attempts to load all of the modules
	liro.attemptLoad(MODULENAME) - Called when the specified module attempts to load
	liro.attemptCountModules - Called when liro attempts to count all the modules

	-- Success hooks
	liro.successfullyCountModules - Called when liro successfully loads all the modules
	liro.successfullyLoaded(MODULENAME) - Called when the specified module attempts to load
	liro.successfullyLoadedModules - Called when liro has successfully loaded all modules
--]]

--[[-------------------------------------------------------------------------
Developer Functions
-----------------------------------------------------------------------------
	All of the following hooks are shared (avaliable on all enviroments)

	liro.pullLoadedModules() - Returns the currently loaded module names in a table
--]]
