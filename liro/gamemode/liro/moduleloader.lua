// Liro - moduleloader.lua

local gamemodeFolderName = GM.FolderName

function liro.recursiveInclusion(moduleName, folderPath, first)
	local folderFiles, folderDirectories = file.Find(folderPath .. "/*", "LUA")

	for _, folder in pairs(folderDirectories) do
		liro.recursiveInclusion(moduleName, folderPath .. "/" .. folder, false)
	end

	for _, fileToLoad in pairs(folderFiles) do
		local relativePath = folderPath .. "/" .. fileToLoad
	
		if string.match( fileToLoad, "^" .. liro.config.moduleLoadPrefixes.server) then
			if SERVER then
				include(relativePath)
			end
		elseif string.match( fileToLoad, "^" .. liro.config.moduleLoadPrefixes.shared) then
			include(relativePath)
			if SERVER then
				AddCSLuaFile(relativePath)
			end
		elseif string.match( fileToLoad, "^" .. liro.config.moduleLoadPrefixes.client) then
			AddCSLuaFile(relativePath)
			if CLIENT then
				include(relativePath)
			end
		end

		if first then

		end
	end
end

function liro.countModules()
	local moduleCount = 0

	local _, moduleFolders = file.Find(gamemodeFolderName .. "/gamemode/modules/*", "LUA")

	for _, moduleFolder in pairs(moduleFolders) do
		moduleCount = moduleCount + 1
	end

	return moduleCount
end

function liro.loadModules()
	moduleLoadLog = {
		"----------------------------------",
		"Attempting to load modules (" .. tostring(liro.countModules()) .. " detected):"
	}

	local _, moduleFolders = file.Find(gamemodeFolderName .. "/gamemode/modules/*", "LUA")

	for _, moduleName in pairs(moduleFolders) do
		if table.HasValue(liro.config.disabledModules, moduleName) then
			local moduleDisabled = true
			table.insert(moduleLoadLog, "Module: " .. moduleName .. " (Disabled)")
		else
			local moduleDisabled = false
			table.insert(moduleLoadLog, "Module: " .. moduleName .. " (Enabled)")
		end

		local modulePath = gamemodeFolderName .. "/gamemode/modules/" .. moduleName

		if not moduleDisabled then
			liro.recursiveInclusion(moduleName, modulePath, true) // liro/gamemode/modules/helloworld
		end
	end

	table.insert(moduleLoadLog, "All modules successfully loaded!")
	table.insert(moduleLoadLog, "-----------------------------------")

	liro.fancyPrint(moduleLoadLog)
end

liro.loadModules()