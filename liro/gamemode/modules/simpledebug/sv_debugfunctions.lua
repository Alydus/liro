// Simple Debug
// A debug module for Liro

function liro.debugVarChat(variable, times, delay)
	if variable and times and delay then
		if times <= 0 then
			timer.Create("simpleDebugTimer", delay, 0, function()
				for _,v in pairs(player.GetAll()) do
					if istable(variable) then
						v:ChatPrint("SIMPLEDEBUG: TABLE: " .. tostring(variable))
					else
						v:ChatPrint("SIMPLEDEBUG: VARIABLE: " .. tostring(variable))
					end
				end
			end)
		elseif times > 1 then
			timer.Create("simpleDebugTimer", delay, times, function()
				for _,v in pairs(player.GetAll()) do
					if istable(variable) then
						v:ChatPrint("SIMPLEDEBUG: TABLE: " .. tostring(variable))
					else
						v:ChatPrint("SIMPLEDEBUG: VARIABLE: " .. tostring(variable))
					end
				end
			end)
		end
	end
end