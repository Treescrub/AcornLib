version <- "1.0"
name <- "Logger"


LogLevel <- {
	OFF = 0
	FATAL = 100
	ERROR = 200
	WARN = 300
	INFO = 400
	TRACE = 500
	DEBUG = 600
	ALL = 2147483647
}

LogLocation <- {
	CONSOLE = 1
	ERROR = 2
	CHAT = 4
}

TimeType <- {
	NONE = 0
	MAP = 1
	CLOCK = 2
}

file_logging <- {}

log_levels <- {}
log_locations <- {}
log_times <- {}

log_levels[root.basePath + "logger"] <- LogLevel.DEBUG
log_locations[root.basePath + "logger"] <- LogLocation.CONSOLE
log_times[root.basePath + "logger"] <- TimeType.CLOCK

custom_levels <- {}

LogLevel.setdelegate(custom_levels)

const DEFAULT_BUFFER_SIZE = 50

function AddLevel(levelName, levelValue) {
	custom_levels[levelName] <- levelValue
}

function SetLevel(level, scriptOverride = null) {
	local name = scriptOverride ? scriptOverride : GetCallerInfo().script
	
	Debug("Setting level of script \"" + name + "\" to " + GetLevelName(level))
	
	log_levels[name] <- level
}

function SetLocation(location, scriptOverride = null) {
	local name = scriptOverride ? scriptOverride : GetCallerInfo().script
	
	Debug("Setting location of script \"" + name + "\" to " + location)
	
	log_locations[name] <- location
}

function SetTimeType(timeType, scriptOverride = null) {
	local name = scriptOverride ? scriptOverride : GetCallerInfo().script
	
	Debug("Setting time type of script \"" + name + "\" to " + timeType)
	
	log_times[name] <- timeType
}


function SetFileLevel(level, scriptOverride = null) {
	local script = scriptOverride ? scriptOverride : GetCallerInfo().script
	
	Debug("Setting file level of script \"" + script + "\" to " + GetLevelName(level))
	
	VerifyFileSettings(script)

	file_logging[script].level = level
}

function EnableLogFile(scriptOverride = null) {
	SetLogFileEnabled(true, scriptOverride ? scriptOverride : GetCallerInfo().script)
}

function DisableLogFile(scriptOverride = null) {
	SetLogFileEnabled(false, scriptOverride ? scriptOverride : GetCallerInfo().script)
}

function SetLogFileEnabled(value, scriptOverride = null) {
	local script = scriptOverride ? scriptOverride : GetCallerInfo().script
	
	VerifyFileSettings(script)

	file_logging[script].enabled = value
}

function SetFileBufferSize(size, scriptOverride = null) {
	local script = scriptOverride ? scriptOverride : GetCallerInfo().script
	
	VerifyFileSettings(script)
		
	file_logging[script].bufferSize = size
	
	if(file_logging[script].buffer.len() >= size) {
		FlushFileBuffer(script)
	}
		
	return true
}

function FlushFileBuffer(scriptOverride = null) {
	local script = scriptOverride ? scriptOverride : GetCallerInfo().script
	
	VerifyFileSettings(script)
	
	local fileName = script + "_log.txt"

	local splitFilename = split(fileName, "/\\")

	fileName = ""

	foreach(index, value in splitFilename) {
		fileName += value

		if(index < splitFilename.len() - 1) {
			fileName += "_"
		}
	}

	local fileContents = FileToString(fileName)
	
	if(fileContents == null) {
		fileContents = ""
	}
	
	foreach(val in file_logging[script].buffer) {
		fileContents += val + "\n"
	}
	
	StringToFile(fileName, fileContents)
	
	file_logging[script].buffer.clear()

	Debug("Flushing file buffer for script \"" + script + "\"")
	
	return true
}

function VerifyFileSettings(script) {
	if(!(script in file_logging)) {
		file_logging[script] <- {
			level = LogLevel.OFF
			enabled = false
			buffer = []
			bufferSize = DEFAULT_BUFFER_SIZE
		}
	}
}


function All(message) {
	Log(message, LogLevel.ALL, GetCallerInfo())
}

function Debug(message) {
	Log(message, LogLevel.DEBUG, GetCallerInfo())
}

function Trace(message) {
	Log(message, LogLevel.TRACE, GetCallerInfo())
}

function Info(message) {
	Log(message, LogLevel.INFO, GetCallerInfo())
}

function Warn(message) {
	Log(message, LogLevel.WARN, GetCallerInfo())
}

function Error(message) {
	Log(message, LogLevel.ERROR, GetCallerInfo())
}

function Fatal(message) {
	Log(message, LogLevel.FATAL, GetCallerInfo())
}

local scriptNameRegex = regexp(@"(?:.+/)*(.+)")

function Log(message, level, callerInfo = null) {
	if(callerInfo == null) {
		callerInfo = GetCallerInfo()
	}

	local script = callerInfo.script
	
	local matches = scriptNameRegex.capture(script)
	local scriptName = script.slice(matches[1].begin, matches[1].end)

	local prefix
	if(root.HasModule(scriptName)) {
		prefix = "MODULE " + root[scriptName].name + " v" + root[scriptName].version + " " + scriptName
	} else {
		prefix = callerInfo.script
	}

	message = prefix + ":" + callerInfo.func + ":" + callerInfo.line + " - " + message
	
	message = GetLevelName(level) + " " + message
	
	local timestamp = GetTimeInfo(script)
	if(timestamp != null)
		message = timestamp + " " + message + " "
		
	if(IsLevelSet(script) && IsLevelAllowed(level, script)) {
		local location = script in log_locations ? log_locations[script] : LogLocation.CONSOLE
		
		if(location & LogLocation.CONSOLE) {
			printl(message)
		}
		if(location & LogLocation.ERROR) {
			error(message + "\n")
		}
		if(location & LogLocation.CHAT) {
			ClientPrint(null, 3, message)
		}
	}
	
	if(IsFileLevelAllowed(level, script)) {
		local settings = file_logging[script]
		
		settings.buffer.append(message)
		
		if(settings.buffer.len() >= settings.bufferSize) {
			FlushFileBuffer(script)
		}
	}
}

function GetLevelName(level) {
	foreach(key, val in LogLevel) {
		if(val == level) {
			return key
		}
	}
	
	foreach(key, val in custom_levels) {
		if(val == level) {
			return key
		}
	}
	
	return "UNKNOWN LEVEL"
}

function IsLevelSet(script) {
	return script in log_levels
}

function IsLevelAllowed(level, script) {
	return log_levels[script] >= level
}

function IsFileLevelAllowed(level, script) {
	return script in file_logging && file_logging[script].level >= level
}

function GetTimeInfo(script) {
	if(!(script in log_times) || log_times[script] == TimeType.NONE) 
		return null
	
	if(log_times[script] == TimeType.CLOCK) {
		local time = {}
		LocalTime(time)
		
		return time.year + "-" + PadInt(time.month, 2) + "-" + PadInt(time.day, 2) + " " + PadInt(time.hour, 2) + ":" + PadInt(time.minute, 2) + ":" + PadInt(time.second, 2)
	}
	
	if(log_times[script] == TimeType.MAP) {
		return Time().tostring()
	}
}

function PadInt(value, amount) {
	local newVal = value.tostring()
	for(; newVal.len() < amount;) {
		newVal = "0" + newVal
	}
	
	return newVal
}

local locationRegex = regexp(@"^scripts/vscripts/((?:.+/)*.+)\.nu(?:c|t)$")

function GetCallerInfo(callLevel = 3) {
	local stackInfo = getstackinfos(callLevel)
	local srcName = stackInfo.src
	local matches = locationRegex.capture(srcName)

	local isAnonymousScript = srcName == "unnamed"
	local script = isAnonymousScript ? "unnamed" : srcName.slice(matches[1].begin, matches[1].end)

	local info = {
		script = script
		line = stackInfo.line
		func = stackInfo.func
	}
	
	return info
}