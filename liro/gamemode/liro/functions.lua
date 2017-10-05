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
-- Checks if provided module data is valid
function liro.moduleIntegrity(md)
	if liro.isEmpty(md.folderName) or liro.isEmpty(md.loadPriority) or liro.isEmpty(md.author) or liro.isEmpty(md.description) or liro.isEmpty(md.website) or liro.isEmpty(md.version) then
		return false
	end
	return true
end

-- liro.getSystemOS()
-- Returns the OS String
function liro.getSystemOS()
	if system.IsOSX() then
		return "OSX"
	elseif system.IsWindows() then
		return "Windows"
	elseif system.IsLinux() then
		return "Linux"
	else
		return false
	end
end

-- liro.isModuleLoaded(module)
-- Returns if the provided module name/data is loaded
function liro.isModuleLoaded(module)
	if module != "" then
		if istable(module) then
			if liro.moduleIntegrity(module) then
				return liro.loadedModules[module.folderName]
			else
				return false	
			end
		else
			return liro.loadedModules[module]
		end
	end
end
