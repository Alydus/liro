-- Liro - liro/config.lua

-- This is the main configuration file for the Liro gamemode base, it
-- allows you to customize the boot of the gamemode.

liro.config = {
	-- Output basic module load information on gamemode initialization?
	doModuleLoadMessages = true,

	-- Enable the module system?
	enableModules = true, 

	-- Enable developer hooks for liro events?
	enableDeveloperHooks = true

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
	-- If so, define them in perModuleLoadPrefixes

  	perModuleLoadPrefixes = {
		simpledebug = {
    			server = "sv_",
			client = "cl_",
			shared = "sh_"
      		}
	},
}

--[[-------------------------------------------------------------------------
Developer Hooks
-----------------------------------------------------------------------------
	All of the following hooks are shared (avaliable on all enviroments)

	-- Attempt hooks
	liro.attemptLoadModules - Called when liro attempts to load all of the modules
	liro.attemptCountModules - Called when liro attempts to count all the modules

	-- Success hooks
	liro.successfullyCountModules - Called when liro successfully loads all the modules
	liro.successfullyLoadedModules - Called when liro has successfully loaded all modules
--]]


