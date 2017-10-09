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

	-- Enable a Linux Uppercase Path Warning on post initialization?
	doLinuxUppercasePathWarning = true,

	-- Register module file name
	-- It's recommended to NOT change this (developer reasons only)
	-- Changing this may make modules cease to load due to their lack of register file
	registerFileName = "registermodule.lua",

	-- Include your network strings in here and they will be util.AddNetworkString'd before module initalization. (e.g. "networkString", "")
	-- This will only work if enableNetworkStrings is set to true.
	-- Modules may also contain network strings.
	
	-- Note that util.AddNetworkString only supports 2048 networkStrings.
	-- http://wiki.garrysmod.com/page/util/AddNetworkString
	networkStrings = {},

	-- Disable any modules? (e.g. "moduleName", "")
	disabledModuleNames = {},
	
	-- Blacklisted Files (stops files from loading) (e.g. "fileName", "")
	-- This works recursively (within folders of the module)
	globalBlacklistedFiles = {},

	-- Global prefixes that define the enviroment that the file will be loaded in.
	-- These prefixes are overidden if the module specific load prefixes set in it's registermodule.lua
	-- Note: It's recommended not to change these, for if the module authors don't specify per module prefixes and expect 'sv_', 'cl_' and 'sh_' to be used
	moduleLoadPrefixes = {
		server = "sv_",
		client = "cl_",
		shared = "sh_"
	}
}

-- See the facepunch thread for a list of developer hooks
