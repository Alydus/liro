print("Detecting Liro version...")
if gmod.GetGamemode().Version then
	print("Running Liro V" .. gmod.GetGamemode().Version)

	http.Fetch( "https://api.github.com/repos/Alydus/liro/releases/latest", function( body, len, headers, code )
			if not liro.isEmpty(body) then
				local json = util.JSONToTable(body)
				local latestVersion = body["tag_name"];
				latestVersion = tonumber(string.gsub(latestVersion, "V", ""))
				print("Latest Liro version is V" .. latestVersion)
			end
		end, function( error )
			print("Failed to fetch latest Liro version from Github")
		end)
else
	print("Failed to detect Liro version. (GM.Version)")
end