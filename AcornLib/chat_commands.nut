version <- "1.0"
name <- "Chat Commands"
dependencies <- "logger"
description <- "Functions to manage chat commands"

function OnLoad() {
	logger.SetLevel(root.logger.LogLevel.ALL)
	logger.SetLocation(root.logger.LogLocation.CONSOLE)
	logger.SetTimeType(root.logger.TimeType.MAP)
	logger.DisableLogFile()
}


commands <- []

function RegisterCommand(commandName, func, scope = null) {
	local removedDuplicate = RemoveCommand(commandName)
	
	commands.append({
		commandName = commandName
		scope = scope
		func = func.bindenv(scope == null ? getroottable() : scope)
	})
	
	if(removedDuplicate) {
		logger.Warn("Replaced command \"" + commandName + "\"")
	} else {
		logger.Info("Registered new command \"" + commandName + "\"")
	}
}

function RegisterCommandAliases(commandName, ...) {
	local registeredCommand
	foreach(command in commands) {
		if(command.commandName == commandName) {
			registeredCommand = command
		}
	}

	if(!registeredCommand) {
		logger.Error("Failed to add aliases for command '" + commandName + "', no such command is registered!")
		return
	}

	foreach(alias in vargv) {
		if(typeof(alias) != "string") {
			logger.Warn("Alias '" + alias + "' for command '" + commandName + "' is not a string!")
			continue
		}

		commands.append({
			aliasedCommand = commandName
			commandName = alias
			scope = registeredCommand.scope
			func = registeredCommand.func
		})

		logger.Info("Added alias '" + alias + "' for command '" + commandName + "'")
	}
}

function RemoveCommand(command) {
	local removed = false
	for(local i = 0; i < commands.len(); i++) {
		local val = commands[i]
		if(val["commandName"] == command || ("aliasedCommand" in val && val["aliasedCommand"] == command)) {
			commands.remove(i)
			i--
			removed = true
		}
	}
	
	return removed
}

function RemoveAllCommands(scope) {
	for(local i = 0; i < commands.len(); i++) {
		if(commands[i].scope == scope) {
			commands.remove(i)
			i--
		}
	}
}

local commandRegex = regexp(@"^\s*([^\s]+)\s*$")

function IsCommand(msg, command){
	if(!commandRegex.match(msg)) 
		return false
	
	local matches = commandRegex.capture(msg)
	
	local commandMatch = msg.slice(matches[1].begin, matches[1].end)
	
	return command == commandMatch
}

local inputCommandRegex = regexp(@"^\s*([^\s]+)\s+(.+)$")

function GetCommandInput(msg, command){
	if(!inputCommandRegex.match(msg)) {
		if(IsCommand(msg, command)) {
			return ""
		} else {
			return null
		}
	}
		
	local matches = inputCommandRegex.capture(msg)
	
	local commandMatch = msg.slice(matches[1].begin, matches[1].end)
	
	if(command != commandMatch)
		return null
	
	local inputMatch = msg.slice(matches[2].begin, matches[2].end)
	
	return inputMatch
}

function OnGameEvent_player_say(params){
	logger.Debug("player_say event parameters: " + TableToString(params))
	
	local text = params["text"]
	local ent = GetPlayerFromUserID(params["userid"])
	
	foreach(command in commands){ 
		local input = GetCommandInput(text, command.commandName)
		if(input) {
			command.func(ent, GetArguments(input), input)
			break
		}
	}
}

local groupedArg = "(?:\"([^\"]+)\")"
local groupedArgRegex = regexp(groupedArg)
local argumentRegex = regexp(groupedArg + "|(?:[^\\s]+)")

function GetArguments(rawInput) {
	local args = []
	for(local search, index = 0; search = argumentRegex.search(rawInput, index);index = search.end) {
		local argument = rawInput.slice(search.begin, search.end)
		
		local matches = groupedArgRegex.capture(argument)
		if(matches) {
			argument = argument.slice(matches[1].begin, matches[1].end)
		}
		
		args.append(argument)
	}
	
	return args
}

function TableToString(table) {
	local output = "{"
	
	local i = 0
	foreach(key, val in table) {
		output += key + " = " + val
		if(i == table.len() - 1) {
			output += "}"
		} else {
			output += ", "
		}
		
		i++
	}
	
	return output
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)