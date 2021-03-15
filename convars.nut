version <- "1.0"
name <- "Convars"
short_name <- "convars"
dependencies <- "logging, timing"
description <- "Provides custom convar creation and convar change listening"


local tickFuncId = null

function OnLoad() {
    logger.SetLevel(logger.LogLevel.DEBUG)
	logger.SetLocation(logger.LogLocation.CONSOLE)
	logger.SetTimeType(logger.TimeType.MAP)
	logger.DisableLogFile()

	tickFuncId = timing.RegisterTickFunction(Think, this)
}

function OnUnload() {
	timing.RemoveTickFunction(tickFuncId)
}


local convarListeners = []

function Think() {
	foreach(listener in convarListeners) {
		local currentValue = Convars.GetStr(listener.name)

		if(Convars.GetStr(listener.name) != listener.oldValue) {
			listener.func(listener.name, listener.oldValue, Convars.GetStr(listener.name))
		}
	}
}

function AddCustomConvar(convarName, defaultValue) {
	SendToServerConsole("setinfo " + convarName + " " + defaultValue)

	Debug("Added custom convar \"" + convarName + "\" with a default value of \"" + defaultValue + "\"")
}

listener_count <- 0

function AddConvarListener(convarName, func) {
	if(Convars.GetStr(convarName) == null) { // Convar doesn't exist
		Warn("Could not add listener for the convar \"" + convarName + "\", it doesn't exist.")

		return -1
	}

	convarListeners.append({
		name = convarName
		func = func
		id = listener_count
	})

	Debug("Added convar listener to the convar \"" + convarName + "\"")

	return listener_count++
}

function RemoveConvarListener(id) {
	foreach(index, listener in convarListeners) {
		if(listener.id = id) {
			convarListeners.remove(index)

			return true
		}
	}

	Warn("Failed to remove convar listener with id " + id)

	return false
}