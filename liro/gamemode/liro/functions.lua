-- Liro - liro/functions.lua

-- Micro optimisation
local hook = hook
local string = string
local jit = jit
local pairs = pairs
local math = math
local istable = istable
local util = util
local tostring = tostring
local tonumber = tonumber
local http = http

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
	return s == nil or string.Trim(s) == ""
end

-- liro.isEmptyUnknown(variable)
-- Returns 'Unknown' if the variable is nil or an empty string
function liro.isEmptyUnknown(s)
	if not s or string.Trim(s) == "" then
		return "Unknown"	
	end
	return s
end

-- liro.moduleIntegrity(moduleData)
-- Checks if provided module data is valid
function liro.moduleIntegrity(md)
	if liro.isEmpty(md.folderName) or liro.isEmpty(md.loadPriority) or liro.isEmpty(md.version) then
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
	if string.Trim(tostring(module)) != "" then
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

-- liro.versionCheck()
-- Checks for a new version of liro
function liro.versionCheck()
	http.Fetch("https://api.github.com/repos/Alydus/liro/releases/latest", function(body, len, headers, code)
		if not liro.isEmpty(body) and not liro.isEmpty(len) and code == 304 then
			local json = util.JSONToTable(body)
			local latestVersion = tostring(json.tag_name)
			latestVersion = string.gsub(latestVersion, "V", "")

			-- Outdated Liro version warning
			if liro.config.doOutdatedWarning and latestVersion != "" and tonumber(latestVersion) > tonumber(GM.LiroVersion) and latestVersion and json then
				liro.diagnosticPrint("Liro is outdated, updating is recommended. (Running V" .. GM.LiroVersion .. ", Latest is " .. latestVersion .. ")")
			end

			-- If GM.LiroVersion is higher than the latest release version, display a developmental version warning
			if liro.config.doOutdatedWarning and latestVersion != "" and tonumber(latestVersion) < tonumber(GM.LiroVersion) and latestVersion and json then
				liro.diagnosticPrint("Liro is running a developmental version, most likely from development branch, expect issues. Detected Liro Version is higher than publically released version. (Running V" .. GM.LiroVersion .. ", Latest is " .. latestVersion .. ")")
			end
		end
	end,
	function(error)
		liro.diagnosticPrint("liro.versionCheck() - HTTP Error has occured with HTTP Code of; " .. code .. ", this is most likely due to Github rate limiting of the version fetching API.")
	end)
end
