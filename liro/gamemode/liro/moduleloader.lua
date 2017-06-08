-- Liro - moduleloader.lua

local gamemodeFolderName = GM.FolderName
liro.networkStrings = {}

-- liro.recursiveInclusion(moduleName, folderPath)
-- Recursively includes a folder's files & folders by calling its self upon it's subdirectories
function liro.recursiveInclusion(moduleData, folderPath)
	local moduleName = moduleData.folderName

	local folderFiles, folderDirectories = file.Find(folderPath .. "/*", "LUA")

	for _, folder in pairs(folderDirectories) do
		liro.recursiveInclusion(moduleData, folderPath .. "/" .. folder)
	end

	for _, fileToLoad in pairs(folderFiles) do
		local relativePath = folderPath .. "/" .. fileToLoad

		if fileToLoad != "registermodule.lua" then
			if moduleData.loadPrefixes != nil or not moduleData.loadPrefixes then
				serverLoadPrefix = moduleData.loadPrefixes.server
				clientLoadPrefix = moduleData.loadPrefixes.client
				sharedLoadPrefix = moduleData.loadPrefixes.shared
			else
				serverLoadPrefix = liro.config.moduleLoadPrefixes.server
				clientLoadPrefix = liro.config.moduleLoadPrefixes.client
				sharedLoadPrefix = liro.config.moduleLoadPrefixes.shared
			end

			if string.match( fileToLoad, "^" .. serverLoadPrefix) then
				if SERVER then
					include(relativePath)
				end
			elseif string.match( fileToLoad, "^" .. sharedLoadPrefix) then
				include(relativePath)
				if SERVER then
					AddCSLuaFile(relativePath)
				end
			elseif string.match( fileToLoad, "^" .. clientLoadPrefix) then
				AddCSLuaFile(relativePath)
				if CLIENT then
					include(relativePath)
				end
			end
		end
	end
end

-- liro.countModules()
-- Returns the amount of modules in the modules folder with no checking
function liro.countModules(doDisabled)
	liro.activateDeveloperHook("liro.attemptCountModules")

	local moduleCount = 0

	local _, moduleFolders = file.Find(gamemodeFolderName .. "/gamemode/modules/*", "LUA")

	for _, moduleFolder in pairs(moduleFolders) do
		if not doDisabled or doDisabled == nil then
			moduleCount = moduleCount + 1
		else
			if table.HasValue(liro.config.disabledModuleNames, moduleFolder) then
				moduleCount = moduleCount + 1
			end
		end
	end

	liro.activateDeveloperHook("liro.successfullyCountModules")

	return moduleCount
end

-- liro.initalizeModules()
-- Loads the registermodule file in each module
function liro.initalizeModules()
	liro.toLoadModules = {}

	local moduleFoldersPath = gamemodeFolderName .. "/gamemode/modules"
	local _, moduleDirectories = file.Find(moduleFoldersPath .. "/*", "LUA")

	for _, moduleName in pairs(moduleDirectories) do
		if file.Exists(moduleFoldersPath .. "/" .. moduleName .. "/registermodule.lua", "LUA") then
			AddCSLuaFile(moduleFoldersPath .. "/" .. moduleName .. "/registermodule.lua")
			include(moduleFoldersPath .. "/" .. moduleName .. "/registermodule.lua")
		else
			print("A liro module is missing a registermodule.lua")
			print("Check the documentation on how to add one")
		end
	end
end

-- liro.loadModules()
-- Loads the files within the module in order of load priority and outputs to console status
function liro.loadModules()
	table.sort(liro.toLoadModules, function(a, b)
		return tonumber(a["loadPriority"]) > tonumber(b["loadPriority"])
	end)

	liro.activateDeveloperHook("liro.attemptLoadModules")

	liro.loadedModules = {}
	liro.unloadedDisabledModules = {}

	for _, moduleData in pairs(liro.toLoadModules) do
		local moduleName = moduleData.folderName

		if not table.HasValue(liro.config.disabledModuleNames, moduleName) then

			if liro.loadedModules[moduleName] then
				print("Liro has failed to fully load")
				print("Two modules have the same folder name")

				return false
			end

			if SERVER then
				if moduleData.networkStrings and moduleData.networkStrings[1] then
					for _, networkString in pairs(moduleData.networkStrings) do
						if networkString != "" then
							table.insert(liro.networkStrings, networkString)
							util.AddNetworkString(networkString)
						else
							print("Liro detected a empty network string in module '" .. moduleData.folderName .. "'")
						end
					end
				end
			end
			liro.activateDeveloperHook("liro.attemptLoad" .. moduleData.folderName)

			liro.recursiveInclusion(moduleData, gamemodeFolderName .. "/gamemode/modules")

			liro.activateDeveloperHook("liro.successfullyLoaded" .. moduleData.folderName, moduleData)

			liro.loadedModules[moduleName] = moduleData

		elseif table.HasValue(liro.config.disabledModuleNames, moduleName) then
			liro.unloadedDisabledModules[moduleName] = moduleData
		end
	end

	for networkStringIndex, networkString in pairs(liro.config.networkStrings) do
		if networkString != "" then
			table.insert(liro.networkStrings, networkString)
			util.AddNetworkString(networkString)
		else
			print("Liro detected a empty network string in the config (liro.config.networkStrings[" .. networkStringIndex .. "])")
		end
	end

	if liro.config.doModuleLoadMessages then
		print("//////////////////////////////")
		print("//          Liro            //")
		print("//  A modular gamemode base //")
		if next(liro.loadedModules) then
			print("//////////////////////////////")
			print("// Loaded module(s):        //")
			for _, moduleData in pairs(liro.loadedModules) do
				print("// Module: \"" .. moduleData.folderName .. "\"")
			end
		end
		if next(liro.unloadedDisabledModules) then
			print("//////////////////////////////")
			print("// Disabled module(s):      //")
			for _, moduleData in pairs(liro.unloadedDisabledModules) do
				print("// Module: \"" .. moduleData.folderName .. "\"")
			end
		end
		print("//////////////////////////////")
		print("// Disabled: " .. table.Count(liro.unloadedDisabledModules) .. " | Enabled: " .. table.Count(liro.loadedModules))
		print("//////////////////////////////")
	end

	liro.activateDeveloperHook("liro.successfullyLoadedModules")
end

hook.Add("liro.registerModule", "loadModuleHook", function(moduleData)
	local tableModuleData = util.JSONToTable(moduleData)
	if not liro.moduleIntegrity(tableModuleData) then
		print("A module has failed to load as it is missing values within it's registermodule.lua file")
		return false
	end
	liro.toLoadModules[tableModuleData.folderName] = tableModuleData

	if liro.countModules() == table.Count(liro.toLoadModules) then
		liro.loadModules()
	end
end)

liro.initalizeModules()