-- Liro - moduleloader.lua

-- Define variable with gamemode folder name for future inclusion
local gamemodeFolderName = GM.FolderName

-- liro.recursiveInclusion()
-- Recursively includes a folder as a module
function liro.recursiveInclusion(moduleName, folderPath)
	if liro.config.enableDeveloperHooks then hook.Call("liro.attemptRecursiveInclusion") end

	-- Defines folderFiles and folderDirectories to search
	local folderFiles, folderDirectories = file.Find(folderPath .. "/*", "LUA")

	-- Recursively include each folder within the current folder
	for _, folder in pairs(folderDirectories) do
		liro.recursiveInclusion(moduleName, folderPath .. "/" .. folder)
	end

	-- For each file
	for _, fileToLoad in pairs(folderFiles) do
		-- Get relative path for file for later inclusion
		local relativePath = folderPath .. "/" .. fileToLoad

		-- Define loadPrefix variables for different enviroments dependant on config
		-- If the module has  a specific loadPrefix
		if istable(liro.config.perModuleLoadPrefixes[moduleName]) then
			-- Define the loadPrefix for that module as specified in config
			serverLoadPrefix = liro.config.perModuleLoadPrefixes[moduleName].server
			clientLoadPrefix = liro.config.perModuleLoadPrefixes[moduleName].client
			sharedLoadPrefix = liro.config.perModuleLoadPrefixes[moduleName].shared
		else
			-- If the module has no specific defined loadPrefix then use default global loadPrefix from config
			serverLoadPrefix = liro.config.moduleLoadPrefixes.server
			clientLoadPrefix = liro.config.moduleLoadPrefixes.client
			sharedLoadPrefix = liro.config.moduleLoadPrefixes.shared
		end

		-- Server file
		-- If the file has a serverLoadPrefix then load in serverside enviroment
		if string.match( fileToLoad, "^" .. serverLoadPrefix) then
			if SERVER then
				include(relativePath)
			end
		-- Shared file
		-- If the file has a sharedLoadPrefix then load in all enviroments (shared)
		elseif string.match( fileToLoad, "^" .. sharedLoadPrefix) then
			include(relativePath)
			if SERVER then
				AddCSLuaFile(relativePath)
			end
		-- Client File
		-- If the file has a clientLoadPrefix then load in clientside enviroment
		elseif string.match( fileToLoad, "^" .. clientLoadPrefix) then
			AddCSLuaFile(relativePath)
			if CLIENT then
				include(relativePath)
			end
		end
	end
end

-- liro.countModules()
-- Counts all the modules in the module folder
function liro.countModules()
	if liro.config.enableDeveloperHooks then hook.Call("liro.attemptCountModules") end

	local moduleCount = 0

	local _, moduleFolders = file.Find(gamemodeFolderName .. "/gamemode/modules/*", "LUA")

	for _, moduleFolder in pairs(moduleFolders) do
		moduleCount = moduleCount + 1
	end

	if liro.config.enableDeveloperHooks then hook.Call("liro.successfullyCountModules") end

	return moduleCount
end

-- liro.loadModules()
-- Initial function called to load the modules
function liro.loadModules()
	-- Define a load log variable to print later
	moduleLoadLog = {
	"----------------------------------",
	"Attempting to load modules (" .. tostring(liro.countModules()) .. " detected):"
}

-- Define a moduleFolders search table
local _, moduleFolders = file.Find(gamemodeFolderName .. "/gamemode/modules/*", "LUA")

-- For each module
for _, moduleName in pairs(moduleFolders) do
	if table.HasValue(liro.config.disabledModules, moduleName) then
		-- If the module is disabled then print it as disabled and define variable
		local moduleDisabled = true
		table.insert(moduleLoadLog, "MODULE: " .. moduleName .. " (Disabled)")
	else
		-- If the module is enabled then print it as enabled and define variable
		local moduleDisabled = false
		table.insert(moduleLoadLog, "MODULE: " .. moduleName .. " (Enabled)")
	end

	-- Define variable of relative path of module for inclusion later
	local modulePath = gamemodeFolderName .. "/gamemode/modules/" .. moduleName

	-- If the module is not disabled then use recursively include it
	if not moduleDisabled then
			liro.recursiveInclusion(moduleName, modulePath) -- liro/gamemode/modules/helloworld
		end
	end

	-- Add to initial moduleLoadLog noting that all modules have successfully loaded
	table.insert(moduleLoadLog, "All modules successfully loaded!")
	table.insert(moduleLoadLog, "-----------------------------------")

	-- If developer hooks are enabled, call liro.allModulesLoaded
	if liro.config.enableDeveloperHooks then hook.Call("liro.successfullyLoadedModules") end

	-- If moduleLoadMessages is enabled then print load log
	if liro.config.doModuleLoadMessages then
		liro.fancyPrint(moduleLoadLog)
	end
end

-- Initial condition to start the load module process
if liro.config.enableModules then
	-- If developer hooks are enabled then call liro.attemptLoadModules
	if liro.config.enableDeveloperHooks then hook.Call("liro.attemptLoadModules") end

	-- Attempt to load all the modules
	liro.loadModules()
end
