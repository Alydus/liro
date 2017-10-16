-- Put your Lua here
-- liro.loadModules()
-- Loads the files within the module in order of load priority and outputs to console status
function liro.loadModules()
    -- Add the global network strings defined in config
    if SERVER then
        for networkStringIndex, networkString in pairs(liro.config.networkStrings) do
            if networkString != "" then
                table.insert(liro.networkStrings, networkString)
                util.AddNetworkString(networkString)
            else
                print("Liro detected a empty network string in the config, it will not be added (liro.config.networkStrings[" .. networkStringIndex .. "])")
            end
        end
    end

    -- Sort modules in order of loadPriority, taken from module data
    table.sort(liro.toLoadModules, function(module1, module2) return tonumber(module1["loadPriority"]) > tonumber(module2["loadPriority"]) end)
    liro.activateDeveloperHook("liro.attemptLoadModules")
    liro.loadedModules = {}
    liro.unloadedDisabledModules = {}

    for _, moduleData in pairs(liro.toLoadModules) do
        local moduleName = moduleData.folderName

        if not table.HasValue(liro.config.disabledModuleNames, moduleName) then
            if not (liro.config.doQuickDisableModulePrefix and (string.sub(moduleName, 1, 4) == DSB_)) then
                if liro.loadedModules[moduleName] then
                    print("Liro has failed to fully load")
                    print("Two modules have the same folder name")

                    return false
                end

                if SERVER then
                    if moduleData.networkStrings and moduleData.networkStrings[1] then
                        for _, networkString in pairs(moduleData.networkStrings) do
                            if networkString != "" then
                                table.insert(liro.networkStrings, networkString)
                                util.AddNetworkString(networkString)
                            else
                                print("Liro detected a empty network string in module '" .. moduleData.folderName .. "'")
                            end
                        end
                    end
                end

                liro.activateDeveloperHook("liro.attemptLoad" .. moduleData.folderName)
                liro.recursiveInclusion(moduleData, gamemodeFolderName .. "/gamemode/modules")
                liro.activateDeveloperHook("liro.successfullyLoaded" .. moduleData.folderName, moduleData)
                liro.loadedModules[moduleName] = moduleData
            end
        elseif table.HasValue(liro.config.disabledModuleNames, moduleName) then
            liro.unloadedDisabledModules[moduleName] = moduleData
        end
    end

    -- Console Output
    if liro.config.doModuleLoadMessages then
        -- Version Checker
        http.Fetch("https://api.github.com/repos/Alydus/liro/releases/latest", function(body, len, headers, code)
            if not liro.isEmpty(body) then
                local json = util.JSONToTable(body)
                local latestVersion = tostring(json.tag_name)
                latestVersion = string.gsub(latestVersion, "V", "")

                -- Outdated Liro version warning
                if liro.config.doOutdatedWarning and tonumber(latestVersion) > tonumber(GAMEMODE.Version) then
                    print("Liro is outdated, updating is recommended. (Running V" .. GAMEMODE.Version .. ", Latest is " .. latestVersion .. ")")
                end

                print("/////////////////////////////////////////")
                print("//             / Liro V" .. GAMEMODE.Version .. " /           //")
                print("//               OS: " .. liro.getSystemOS() .. "             //")
                print("/////////////////////////////////////////")
                print("//     Post-Initialization Complete    //")
                print("//          Latest Version: " .. latestVersion .. "        //")

                if next(liro.loadedModules) then
                    print("/////////////////////////////////////////")
                    print("// Loaded module(s):                   //")

                    for moduleLoadedOrderKey, moduleData in pairs(liro.loadedModules) do
                        if liro.moduleIntegrity(moduleData) then
                            print("// Module: \"" .. moduleData.folderName .. "\" by \"" .. moduleData.author .. "\"")
                        end
                    end
                end

                if next(liro.unloadedDisabledModules) then
                    print("/////////////////////////////////////////")
                    print("// Disabled module(s):      //")

                    for _, moduleData in pairs(liro.unloadedDisabledModules) do
                        if liro.moduleIntegrity(moduleData) then
                            print("// Module: \"" .. moduleData.folderName .. "\" by \"" .. moduleData.author .. "\"")
                        end
                    end
                end

                print("/////////////////////////////////////////")
                print("// Disabled: " .. table.Count(liro.unloadedDisabledModules) .. " | Enabled: " .. table.Count(liro.loadedModules))
                print("/////////////////////////////////////////")
            end
        end)
    end

    -- Linux System uppercase filenames/paths warning
    if system.IsLinux() and liro.config.doLinuxUppercasePathWarning then
        print("Liro is running on Linux, module(s) and/or uppercase file name paths will cause issues, same with spaces/tabs.")
    end

    liro.activateDeveloperHook("liro.successfullyLoadedModules")
end
