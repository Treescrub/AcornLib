/* Module ideas

	events - game events
	callbacks - hooks, etc
	custom_weapons - custom melee weapon logic
	more_methods - more methods in base classes
	netprops - netprop utilities
	pretty_chat - pretty chat printing, can provide a list of players to send to
	hud - EMS hud utilities. every tick instead of every 3 ticks
	file_utils - file utilities, append to file, parse file, etc.
	persistent_data - simple functions to save and load data through sessions/quits
	exceptions - functions to test and throw exceptions
	entities - utilities to find and iterate through entities
	utilities - list classes, other useful standard classes
	print - printf, ClientPrint, error
	convars - create custom convars and add listeners to convars

*/

// TODO: Convert a script using HookController to this library
// TODO: Look at scripts and determine common features/functions to include
// TODO: will cyclic dependency cause issues loading/unloading? don't think so, when loading a module it checks if its already loaded


modules <- {}

this.setdelegate(modules)

function RefreshModule(name) {
	UnloadModule(name)
	
	if(!LoadModule(name))
		return false
}

function LoadModule(name) {
	if(typeof(name) != "string") {
		printl("Failed to load module: The module name \"" + name + "\" is not a string")
		return false
	}

	name = name.tolower()
	
	if(HasModule(name)) {
		printl("Failed to load module: Module \"" + name + "\" is already loaded")
		return false
	}
		
	local moduleTable = {
		root = this
		load_time = Time()
	}
	
	moduleTable.setdelegate(this)
	
	IncludeScript(GetFullModulePath(name), moduleTable)
	
	if(!TableIsModule(moduleTable)) {
		printl("Failed to load module: Module \"" + name + "\" is not a valid module or does not exist")
		return false
	}
	
	if("dependencies" in moduleTable && typeof(moduleTable["dependencies"]) == "string") 
		LoadDependencies(moduleTable["dependencies"])
		
	PrintModuleLoadInfo(moduleTable)

	modules[name] <- moduleTable

	if("OnLoad" in moduleTable) 
		moduleTable["OnLoad"]()
	
	return true
}

function PrintModuleLoadInfo(module) {
	printl("Loaded module: " + module["name"] + " (" + module["short_name"] + ")")
	if("description" in module) 
		printl("\t" + module["description"])
		
	printl("\n\tVersion: " + module["version"])
	
	if("dependencies" in module) 
		printl("\tDependencies: " + module["dependencies"])
}

local dependenciesRegex = regexp(@"\s*(\w+)[,\s$]*")

function LoadDependencies(dependenciesStr) {
	for(local start = 0, match = null; match = dependenciesRegex.search(dependenciesStr, start); start = match.end) {
		local section = dependenciesStr.slice(match.begin, match.end)
		local group = dependenciesRegex.capture(section)
		local dependency = section.slice(group[1].begin, group[1].end)
		
		if(!HasModule(dependency)) {
			printl("Loading dependency: " + dependency)
			LoadModule(dependency)
		}
	}
}

function UnloadModule(name) {
	name = name.tolower()

	if(!HasModule(name))
		return false
		
	local moduleTable = modules[name]
	
	if("OnUnload" in moduleTable) 
		moduleTable["OnUnload"]()
	
	moduleTable.clear()
	
	delete modules[name]
	
	return true
}

function UnloadAllModules() {
	foreach(key, val in modules) {
		UnloadModule(key)
	}
}

function TableIsModule(table) {
	return "name" in table && "version" in table && "short_name" in table
}

function HasModule(name) {
	return name.tolower() in modules
}

function GetFullModulePath(moduleName) {
	return basePath + moduleName
}

basePath <- null

local locationRegex = regexp(@"^scripts/vscripts/((?:.+/)*).+\.nu(?:c|t)$")

function DetermineBasePath() {
	local info = getstackinfos(1)
	
	local script = info.src
	
	if(!locationRegex.match(script)) {
		printl("Unknown script source \"" + script + "\"")
		return
	}
	
	local matches = locationRegex.capture(script)
	
	basePath = script.slice(matches[1].begin, matches[1].end)
}

DetermineBasePath()