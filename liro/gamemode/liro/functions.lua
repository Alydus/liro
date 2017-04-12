// Liro - liro/functions.lua

function liro.textPrefix(prefix, text)
	return prefix .. " " .. text
end

function liro.fancyPrint(textTable)
	print(liro.textPrefix("--", "Start of Liro message"))
	for _, text in pairs(textTable) do
		print(liro.textPrefix("--", text))
	end
	print(liro.textPrefix("--", "End of Liro message"))
end

function liro.performError(errorDesc)
	local liroError = {
		"ERROR:",
		errorDesc,
	}

	liro.fancyPrint(liroError)
end