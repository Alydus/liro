-- Liro - moduleloader.lua

local gamemodeFolderName = GM.FolderName
liro.networkStrings = {}

-- liro.recursiveInclusion(moduleName, folderPath)
-- Recursively includes a folder's files & folders by calling its self upon it's subdirectories
function liro.recursiveInclusion(moduleData, folderPath)
	local moduleName = moduleData.folderName
	local blacklistedFiles = moduleData.blacklistedFiles

	local folderFiles, folderDirectories = file.Find(folderPath .. "/*", "LUA")

	for _, folder in pairs(folderDirectories) do
		liro.recursiveInclusion(moduleData, folderPath .. "/" .. folder)
	end

	for _, fileToLoad in pairs(folderFiles) do
		local relativePath = folderPath .. "/" .. fileToLoad

		-- If the file attempting to load if the registermodule file name, it will not load it again
		-- If the file isn't per-module blacklisted, load it
		-- If the file isn't globally blacklisted, load it
		if string.lower(fileToLoad) != string.lower(liro.config.registerFileName) or not table.HasValue(liro.config.globalBlacklistedFiles, fileToLoad) or not table.HasValue(blacklistedFiles, fileToLoad) then
			-- Define load prefixes, use per-module prefixes, or default (defined in config)

			if moduleData.loadPrefixes != nil or not moduleData.loadPrefixes then
				serverLoadPrefix = string.lower(moduleData.loadPrefixes.server)
				clientLoadPrefix = string.lower(moduleData.loadPrefixes.client)
				sharedLoadPrefix = string.lower(moduleData.loadPrefixes.shared)
			else
				serverLoadPrefix = string.lower(liro.config.moduleLoadPrefixes.server)
				clientLoadPrefix = string.lower(liro.config.moduleLoadPrefixes.client)
				sharedLoadPrefix = string.lower(liro.config.moduleLoadPrefixes.shared)
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
		if file.Exists(moduleFoldersPath .. "/" .. moduleName .. "/" .. string.lower(liro.config.registerFileName), "LUA") then
			AddCSLuaFile(moduleFoldersPath .. "/" .. moduleName .. "/" .. string.lower(liro.config.registerFileName))
			include(moduleFoldersPath .. "/" .. moduleName .. "/" .. string.lower(liro.config.registerFileName))
		else
			if not string.sub(moduleName, 1, 4) == "DSB_" then
				liro.diagnosticPrint("A Liro module is missing a registermodule.lua, obtain an example from Liro source on github")
			end
		end
	end
end

-- liro.versionCheck()
-- Checks for a new version of liro
function liro.versionCheck()
	http.Fetch("https://api.github.com/repos/Alydus/liro/releases/latest", function(body, len, headers, code)
		if not liro.isEmpty(body) then
			local json = util.JSONToTable(body)
			local latestVersion = tostring(json.tag_name)
			latestVersion = string.gsub(latestVersion, "V", "")

			-- Outdated Liro version warning
			if liro.config.doOutdatedWarning and latestVersion != "" and tonumber(latestVersion) > tonumber(GAMEMODE.Version) and latestVersion and json then
				liro.diagnosticPrint("Liro is outdated, updating is recommended. (Running V" .. GAMEMODE.Version .. ", Latest is " .. latestVersion .. ")")
			end

			-- If GAMEMODE.Version is higher than the latest release version, display a developmental version warning
			if liro.config.doOutdatedWarning and latestVersion != "" and tonumber(latestVersion) < tonumber(GAMEMODE.Version) and latestVersion and json then
				liro.diagnosticPrint("Liro is running a developmental version, most likely from development branch, expect issues. (Running V" .. GAMEMODE.Version .. ", Latest is " .. latestVersion .. ")")
			end
		end
			end,
		function(error)
			liro.diagnosticPrint("liro.versionCheck() - HTTP Error has occured; error states: \"" .. error .. "\"")
	end)
end

-- liro.loadModules()
-- Loads the files within the module in order of load priority and outputs to console status
function liro.loadModules()
	if SERVER then
		-- Add the global network strings defined in config
		for networkStringIndex, networkString in pairs(liro.config.networkStrings) do
			if networkString and networkString != "" then
				table.insert(liro.networkStrings, networkString)
				util.AddNetworkString(networkString)
			else
				liro.diagnosticPrint("Liro detected a empty network string in the Liro config networkStrings (liro.config.networkStrings[" .. networkStringIndex .. "])")
			end
		end
	end

	-- Sort modules in order of loadPriority, taken from module data
	table.sort(liro.toLoadModules, function(module1, module2)
		return tonumber(module1["loadPriority"]) > tonumber(module2["loadPriority"])
	end)

	liro.activateDeveloperHook("liro.attemptLoadModules")

	liro.loadedModules = {}
	liro.unloadedDisabledModules = {}

	for _, moduleData in pairs(liro.toLoadModules) do
		local moduleName = moduleData.folderName

		if not table.HasValue(liro.config.disabledModuleNames, moduleName) then
			
			if not (liro.config.doQuickDisableModulePrefix and (string.sub(moduleName, 1, 4) == "DSB_")) then

				if liro.loadedModules[moduleName] then
					liro.diagnosticPrint("Liro has failed to fully load, two modules have the same folder name")

					return false
				end

				if SERVER and moduleData.networkStrings and moduleData.networkStrings[1] then
					for networkStringIndex, networkString in pairs(moduleData.networkStrings) do
						if networkString != "" then
							table.insert(liro.networkStrings, networkString)
							util.AddNetworkString(networkString)
						else
							liro.diagnosticPrint("Liro detected a empty network string in module '" .. moduleData.folderName .. "' (moduleData.networkStrings[" .. networkStringIndex .. "]), it will not be added.")
						end
					end
				end

				-- Check if the module is empty, no point running recursive inclusion if it's empty
				local folderFiles, folderDirectories = file.Find(gamemodeFolderName .. "/gamemode/modules/" .. moduleData.folderName .. "/*", "LUA")

				if #folderFiles == 0 and #folderDirectories == 0 then
					liro.diagnosticPrint("Liro has detected an empty module (" .. moduleData.folderName .. "), it will not load.")
				else
					liro.activateDeveloperHook("liro.attemptLoad" .. moduleData.folderName)

					liro.recursiveInclusion(moduleData, gamemodeFolderName .. "/gamemode/modules")

					liro.activateDeveloperHook("liro.successfullyLoaded" .. moduleData.folderName, moduleData)

					liro.loadedModules[moduleName] = moduleData
				end
			end

		elseif table.HasValue(liro.config.disabledModuleNames, moduleName) then
				liro.unloadedDisabledModules[moduleName] = moduleData
		end
	end

	-- Console Output
	if liro.config.doModuleLoadMessages then
		local loadTime = math.Round(os.clock() - liro.startTime, 3)
		if SERVER or (CLIENT and liro.config.showConsoleLoadSequenceClientside) then

			if SERVER or (CLIENT and liro.config.showConsoleLoadSequenceClientside and liro.config.showConsoleLoadSequenceRanksOnly and LocalPlayer() and LocalPlayer():GetUserGroup() and table.HasValue(liro.config.showConsoleLoadSequenceClientsideRanks, LocalPlayer():GetUserGroup())) then

				-- Linux System uppercase filenames/paths warning
				if system.IsLinux() and liro.config.doLinuxUppercasePathWarning then
					liro.diagnosticPrint("Liro is running on Linux, module(s) and/or uppercase file name paths will cause issues, same with spaces/tabs.")
				end

				print("/////////////////////////////////////////////////////////////////////")
				print("//")
				print("// Liro V" .. GAMEMODE.Version)
				print("//")
				print("// OS: " .. liro.getSystemOS())
				print("// LLT (Load Time): " .. loadTime .. "s")
				print("// IP (Public IP:Listen Port): " .. game.GetIPAddress())
				print("// Enabled Modules: " .. table.Count(liro.loadedModules))
				print("// Disabled Modules: " .. table.Count(liro.unloadedDisabledModules))
				print("//")
				print("/////////////////////////////////////////////////////////////////////")
				print("//                   Post-Initialization Complete                  //")

				if next(liro.loadedModules) then
					print("/////////////////////////////////////////////////////////////////////")
					print("// Loaded Module(s):")
					print("//")
					for moduleLoadedOrderKey, moduleData in pairs(liro.loadedModules) do
						if liro.moduleIntegrity(moduleData) then
							print("// -- MODULE: " .. moduleData.folderName)
							print("//    -- Developer: " .. moduleData.author .. ", Website: " .. moduleData.website .. ", Network Strings: " .. table.Count(moduleData.networkStrings))
						end
					end
				end

				if next(liro.unloadedDisabledModules) then
					print("/////////////////////////////////////////////////////////////////////")
					print("// Disabled Module(s):")
					print("//")
					for _, moduleData in pairs(liro.unloadedDisabledModules) do
						if liro.moduleIntegrity(moduleData) then
							print("// -- MODULE: " .. moduleData.folderName)
							print("//    -- Developer: \"" .. moduleData.author .. "\", Website: \"" .. moduleData.website .. "\", Network Strings: " .. table.Count(moduleData.networkStrings))
						end
					end
				end
				print("//")
				print("/////////////////////////////////////////////////////////////////////")
			end
		end

		if CLIENT then
			net.Start("liro.receiveClientInformation")
			net.WriteString(util.TableToJSON({loadTime = math.Round(os.clock() - liro.startTime, 3), os = liro.getSystemOS(), country = system.GetCountry(), windowed = system.IsWindowed(), steamTime = system.SteamTime(), upTime = system.UpTime(), screenWidth = ScrW(), screenHeight = ScrH(), batteryPower = system.BatteryPower()}))
			net.SendToServer()
		end

		liro.diagnosticPrint("Liro has completed the multi-stage loading process in " .. loadTime .. "s.")
	end

	liro.activateDeveloperHook("liro.successfullyLoadedModules")

	liro.versionCheck()
end

hook.Add("liro.registerModule", "loadModuleHook", function(moduleData)
	local tableModuleData = util.JSONToTable(moduleData)
	
	-- Throw warning if module being registered has incomplete/invalid module data
	if not liro.moduleIntegrity(tableModuleData) then
		if tableModuleData.folderName then
			liro.diagnosticPrint("A module (" .. tableModuleData.folderName .. ") has failed to load as it is missing required value(s) within JSON metadata (registermodule.lua)")
		else
			liro.diagnosticPrint("A module with an unknown name has failed to load as it is missing required value(s) within JSON metadata (registermodule.lua)")
		end
		return false
	end

	liro.toLoadModules[tableModuleData.folderName] = tableModuleData

	-- If all modules have been loaded successfully, load properly.
	if liro.countModules() == table.Count(liro.toLoadModules) then
		liro.loadModules()
	end
end)

function GM:Initialize()
	liro.initalizeModules()
end
