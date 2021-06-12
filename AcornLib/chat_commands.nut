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

function RegisterCommand(command, func, scope = null) {
	local removedDuplicate = RemoveCommand(command)
	
	commands.append({
		commandName = command
		func = func.bindenv(scope == null ? getroottable() : scope)
	})
	
	if(removedDuplicate) {
		logger.Info("Replaced command \"" + command + "\"")
	} else {
		logger.Info("Registered new command \"" + command + "\"")
	}
}

function RemoveCommand(command) {
	foreach(idx, val in commands) {
		if(val["commandName"] == command) {
			commands.remove(idx)
			return true
		}
	}
	
	return false
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