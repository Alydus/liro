-- Liro - datamanagement.lua

-- Micro optimisation
local net = net
local util = util
local table = table

-- Handling of players serverside when they post-initialize Liro on their clients
averageLLT = averageLTT or {0}

net.Receive("liro.receiveClientInformation", function(len, ply)
	local playerDataTable = net.ReadString()
	playerDataTable = util.JSONToTable(playerDataTable)

	liro.activateDeveloperHook("liro.newClient", playerDataTable)

	if not ply:IsBot() then
		table.insert(averageLLT, playerDataTable.loadTime)
		if liro.config.averageLoadTime then
			liro.diagnosticPrint("Liro has calculated an average LLT (Client Load Time) of " .. liro.mean(averageLLT))
		end
	end

	if liro.config.doPlayerInitializationMessage then
		liro.diagnosticPrint("[C] " .. ply:GetName() .. " (SteamID: " .. ply:SteamID() .. ", Screen Res: " .. playerDataTable.screenWidth .. "x" .. playerDataTable.screenHeight .. ", Country: " .. playerDataTable.country .. ", liroLoadTime = " .. playerDataTable.loadTime .. "s, OS: " .. playerDataTable.os .. ", Battery: " .. liro.formatBatteryPower(playerDataTable.batteryPower) .. ") has reached Liro Post-Initialization.")
	end
end)
