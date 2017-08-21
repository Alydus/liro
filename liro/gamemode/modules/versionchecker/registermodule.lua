-- Define module information
-- All module data must be set correctly, skipping keys will result in a error
-- Module data is in JSON format

-- Must be set (case sensitive)
-- If 'folderName' is not set, Liro will completely fail to load!
local folderName = "versionchecker"
local moduleData = '{"folderName": "' .. folderName .. '", "loadPriority": 9999,"author": "Alydus","description": "Liro Version Checker","website": "alydus.net","version": "0.1", "blacklistedFiles": [], "networkStrings": [], "loadPrefixes": {"server": "sv_", "client": "cl_", "shared": "sh_"}}'

-- Finally, Register the module - Do not touch
hook.Run("liro.registerModule", moduleData)
