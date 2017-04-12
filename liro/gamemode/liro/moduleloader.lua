// Liro - moduleloader.lua

local gamemodeFolderName = GM.FolderName

local function liro.recursiveInclusion(moduleName, folderPath, first)
	local folderFiles, folderDirectories = file.Find(folderPath .. "/*", "LUA")

	for _, folder in pairs(folderDirectories) do
		liro.recursiveInclusion(moduleName, folderPath .. "/" .. folder, false)
	end

	for _, fileToLoad in pairs(folderFiles) do
		local relativePath = string.gsub(scanDirectory .. "/" .. fileToLoad, GM.FolderName .. "/gamemode/", "")
	
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

local function liro.countModules()
	local moduleCount = 0

	local _, moduleFolders = file.Find(gamemodeFolderName .. "/gamemode/modules/*", "LUA")

	for _, moduleFolder in pairs(moduleFolders) do
		moduleCount = moduleCount + 1
	end

	return moduleCount
end

local function liro.loadModules()
	local moduleLoadLog = {
		"Attempting to load modules (" .. tostring(liro.countModules()) .. " detected):"
	}

	local _, moduleFolders = file.Find(gamemodeFolderName .. "/gamemode/modules/*", "LUA")

	for _, moduleName in pairs(moduleFolders)
		table.insert(moduleLoadLog, "Module: " .. moduleName)

		local modulePath = gamemodeFolderName .. "/gamemode/modules/" .. moduleName

		liro.recursiveInclusion(moduleName, modulePath, true) // liro/gamemode/modules/helloworld
	end
end

liro.loadModules()