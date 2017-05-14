![Liro Banner](https://app.alydus.net/static/alydus/liro/banner.png)

# What is Liro?
Liro is a modular Garry's Mod gamemode base. It has been designed from the ground up for code reusability and ease of use.

# Features
* A optimized **recursive module loader** and clean output load logs
* Global functions that can be reused from the Liro base files
* No messing about with include() and AddCSLuaFile()
* Configurable file prefixes (per module & global) for running files in different enviroments (e.g. sh_, sv_, cl_)
* Ability to **disable/enable modules** in the base config. (gamemode/liro/config.lua)
* All code is mostly all **fully commented**, meaning the code is easy to contribute to and modify to your own needs

# Developer Hooks
### Attempt Hooks
* liro.attemptLoadModules - Called when liro attempts to load all of the modules
* liro.attemptLoad(MODULENAME) - Called when the specified module attempts to load
* liro.attemptCountModules - Called when liro attempts to count all the modules

### Success Hooks
* liro.successfullyCountModules - Called when liro successfully loads all the modules
* liro.successfullyLoaded(MODULENAME) - Called when the specified module attempts to load
* liro.successfullyLoadedModules - Called when liro has successfully loaded all modules

# Developer Functions
### Return functions

* liro.pullLoadedModules() - Returns the currently loaded module names in a table
