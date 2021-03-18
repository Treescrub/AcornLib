version <- "1.0" // Version string
name <- "Human Friendly Module Name"
short_name <- "lowercase_name_that_matches_script_name"
dependencies <- "required,module,names, separated, by, commas"
description <- "A short description of what this module provides"

function OnLoad() {
	// This function will be called after everything has been initialized. Dependencies will only be guaranteed to be loaded when this is called.
}

function OnUnload() {
	// This function will be called just before this module is unloaded.
}

// Module code should go here
