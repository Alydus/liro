-- Liro - liro/config.lua

-- This is the main configuration file for the Liro gamemode base, it
-- allows you to customize the boot of the gamemode.

-- Setting a value to true will enable it's function, setting it to false will do the opposite.

liro.config = {
	-- Output basic module load information on gamemode initialization?
	doModuleLoadMessages = true,

	-- Enable the module system?
	enableModules = true, 

	-- Enable developer hooks for liro events?
	enableDeveloperHooks = true,
        
	-- Enable AddNetworkString table?
	enableNetworkStrings = true,

	-- Add serverside console message for post-initialized players, recommended to be enabled (includes detailed information like; country, screen resolution, steamid and more)
	doPlayerInitializationMessage = true,

	-- Enable a Linux Uppercase Path Warning on post initialization?
	doLinuxUppercasePathWarning = true,

	-- Show the average load time of every player that has joined when a player finishes loading Liro,
	averageLoadTime = true,
	
	-- Enable adding "DSB_" to the beginning of a moduleFolderName to disable it
	doQuickDisableModulePrefix = true,

	-- Show the module loading sequence in clientside console for clients (useful if you want make Liro usage more discreet)
	showConsoleLoadSequenceClientside = true,

	-- Show the module loading sequence in clientside console for clients with ranks defined in showConsoleLoadSequenceClientsideRanks
	showConsoleLoadSequenceClientsideRanksOnly = false,

	-- Ranks that will see module loading sequence in clientside console, works if only showConsoleLoadSequenceClientside/RanksOnly is true
	showConsoleLoadSequenceClientsideRanks = {"superadmin", "admin"},

	-- The prefix for printing using liro.diagnosticPrint(), recommened to have a space after the prefix
	diagnosticPrintPrefix = "[LIRO] ",

	-- Enable outdated Liro version on post initialization?
	doOutdatedWarning = true,

	-- Register module file name
	-- It's recommended to NOT change this (developer reasons only)
	-- Changing this may make modules cease to load due to their lack of register file
	registerFileName = "registermodule.lua",

	-- Include your network strings in here and they will be util.AddNetworkString()'d before module initalization. (e.g. "networkString", "")
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
-- https://gmod.facepunch.com/f/gmodaddon/jjfx/Liro-A-modular-gamemode-base/
