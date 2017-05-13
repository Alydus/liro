-- Liro - liro/functions.lua

-- liro.textPrefix()
-- Prefixes a string with the given prefix
function liro.textPrefix(prefix, text)
	return prefix .. " " .. text
end

-- liro.fancyPrint()
-- Prints a table with prefix and suffix
function liro.fancyPrint(textTable)
	print(liro.textPrefix("--", "Start of Liro message"))
	for _, text in pairs(textTable) do
		print(liro.textPrefix("--", text))
	end
	print(liro.textPrefix("--", "End of Liro message"))
end

-- liro.performError()
-- Prints a error string
function liro.performError(errorDesc)
	local liroError = {
		"ERROR:",
		errorDesc,
	}

	liro.fancyPrint(liroError)
end