-- This file includes a nice syntax for you to use within your module to keep it easily configurable and clean.

exampleModule = {}

exampleModule.config = {
	configOption1 = "somevalue"
}
function exampleModule.initializeModule()
	-- Example Module Loaded
end
hook.Add("liro.successfullyLoadedexamplemodule", "moduleLoadedExampleHook", exampleModule.initializeModule)
