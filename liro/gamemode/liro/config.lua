// Liro - liro/config.lua

/* This is the main configuration file for the Liro gamemode base, it
allows you to customize the boot of the gamemode. */

liro.config = {
	doModuleLoadMessages = true, // Output basic module load information on gamemode initalisation?

	enableModules = true, // Enable the module system?

	disabledModules = { // Disable any modules?
		
	},

	// Global/per module prefixes that define the enviroment that the file will be loaded in.
	// You may change these per module for things
	moduleLoadPrefixes = {
		server = "sv_",
		client = "cl_",
		shared = "sh_"
		perModuleLoadPrefixes = {
			simpledebug = {
				server = "sv_",
				client = "cl_",
				shared = "sh_"
			}
		}
	},
	
	/*moduleConfiguration = {
                simpledebug = {
                    enableSimpleDebug = true
                },

                playerdisplay = {
                    enablePlayerDisplay = true
                }
    }*/
}
