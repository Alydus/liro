// Player Display Module
// Example Module for Liro

hook.Add("HUDPaint", "PlayerDisplay", function()
	draw.SimpleText(#player.GetAll() .. "/" .. game.MaxPlayers(), "Default", 50, 50, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end)