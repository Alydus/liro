// Liro - liro/config.lua

/* This is the main configuration file for the Liro gamemode base, it
allows you to customize the boot of the gamemode. */

liro.config = {
	doInitMessages = true, // Output information on Liro's initialization?

	enableModules = true, // Enable Liro's module system?

	disabledModules = { // Disable the initialization of any modules?
		// "modulename",
	},

	moduleLoadPrefixes = {
		server = "sv_",
		client = "cl_",
		shared = "sh_"
	}
}