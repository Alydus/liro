-- Liro - datamanagement.lua

-- Handling of players serverside when they post-initialize Liro on their clients
net.Receive("liro.receiveClientInformation", function(len, ply)
	local playerDataTable = net.ReadString()
	playerDataTable = util.JSONToTable(playerDataTable)

	if liro.config.doPlayerInitializationMessage then
		liro.diagnosticPrint("[C] " .. ply:GetName() .. " (SteamID: " .. ply:SteamID() .. ", Screen Res: " .. playerDataTable.screenWidth .. "x" .. playerDataTable.screenHeight .. ", Country: " .. playerDataTable.country .. ", liroLoadTime = " .. playerDataTable.loadTime .. "s, OS: " .. playerDataTable.os .. ", Battery: " .. liro.formatBatteryPower(playerDataTable.batteryPower) .. ") has reached Liro Post-Initialization.")
	end
end)