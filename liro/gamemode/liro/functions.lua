-- Liro - liro/functions.lua

-- liro.activateDeveloperHook()
-- Calls a hook after checking if developer hooks are enabled
function liro.activateDeveloperHook(name, arg)
	if liro.enableDeveloperHooks then
		if arg == nil or arg == "" then
			hook.Call(name)
		else
			hook.Call(name, arg)
		end
	end
end

-- liro.isEmpty(variable)
-- Checks if a variable is nil
function liro.isEmpty(s)
	return s == nil or s == ""
end

-- liro.moduleIntegrity(moduleData)
function liro.moduleIntegrity(md)
	if liro.isEmpty(md.folderName) or liro.isEmpty(md.loadPriority) or liro.isEmpty(md.author) or liro.isEmpty(md.description) or liro.isEmpty(md.website) or liro.isEmpty(md.version) then
		return false
	end
	return true
end

-- liro.isModuleLoaded(moduleName)
function liro.isModuleLoaded(moduleName)
	if moduleName != "" then
		return liro.loadedModules[moduleName]
	end
end
