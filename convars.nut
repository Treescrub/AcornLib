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
}

listener_count <- 0

function AddConvarListener(convarName, func) {
	convarListeners.append({
		name = convarName
		func = func
		id = listener_count
	})

	return listener_count++
}

function RemoveConvarListener(id) {
	foreach(index, listener in convarListeners) {
		if(listener.id = id) {
			convarListeners.remove(index)
			return true
		}
	}

	return false
}