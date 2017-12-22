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
	if jit.os != "Other" then
		return jit.os
	else
		return "Unknown"
	end
end


-- liro.mean(table)
-- Returns the mean/average number in a table
function liro.mean(t)
	local sum = 0
	local count= 0

	for _, v in pairs(t) do
		if type(v) == "number" then
			sum = sum + v
			count = count + 1
		end
	end

	return sum / count
end

-- liro.formatBatteryPower(batteryPower)
-- Returns formatted battery power, returns "Plug" if not on battery or plugged in
function liro.formatBatteryPower(batteryPower)
	if batteryPower == 255 or not batteryPower then
		return "Plug"
	else
		return math.Round(batteryPower)
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

-- liro.diagnosticPrint(message)
-- Prints a message with the liro prefix
function liro.diagnosticPrint(message)
	if message != "" and message then
		print(liro.config.diagnosticPrintPrefix .. message)
	end
end