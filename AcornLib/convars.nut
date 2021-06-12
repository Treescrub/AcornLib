version <- "1.0"
name <- "Convars"
dependencies <- "logger, timing"
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

		if(currentValue != listener.oldValue && listener.oldValue != null) {
			listener.func(listener.name, listener.oldValue, currentValue)
		}

		listener.oldValue <- currentValue
	}
}

function AddCustomConvar(convarName, defaultValue) {
	SendToServerConsole("setinfo " + convarName + " " + defaultValue)

	logger.Debug("Added custom convar \"" + convarName + "\" with a default value of \"" + defaultValue + "\"")
}

listener_count <- 0

function AddConvarListener(convarName, func, scope = null) {
	if(Convars.GetStr(convarName) == null) {
		logger.Warn("The convar \"" + convarName + "\" doesn't exist.")

		return false
	}

	convarListeners.append({
		name = convarName
		func = scope ? func.bindenv(scope) : func
		id = listener_count
		oldValue = null
	})

	logger.Debug("Added convar listener to the convar \"" + convarName + "\" (id=" + listener_count + ")")

	return listener_count++
}

function RemoveConvarListener(id) {
	foreach(index, listener in convarListeners) {
		if(listener.id == id) {
			convarListeners.remove(index)

			return true
		}
	}

	logger.Warn("Failed to remove convar listener (id=" + id + ")")

	return false
}