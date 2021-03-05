version <- "1.0"
name <- "Timing"
short_name <- "timing"
dependencies <- "logger"
description <- "Functions to manage timing, which includes task scheduling and tick think functions"

function OnLoad() {
	timer = SpawnEntityFromTable("logic_timer", {RefireTime = 0})
	timer.ValidateScriptScope()
	timer.GetScriptScope()["scope"] <- this
	timer.GetScriptScope()["func"] <- function(){
		scope.Think()
	}
	timer.ConnectOutput("OnTimer", "func")
	EntFire("!self", "Enable", null, 0, timer)
	
	logger.SetLevel(logger.LogLevel.DEBUG)
	logger.SetLocation(logger.LogLocation.CONSOLE)
	logger.SetTimeType(logger.TimeType.MAP)
	logger.DisableLogFile()
}

function OnUnload() {
	timer.Kill()
}


timer <- null

tickFunctions <- []
tasks <- []

function Think() {
	foreach(func in tickFunctions) 
		func()
	
	for(local i = 0; i < tasks.len(); i++) {
		local task = tasks[i]
		if(Time() >= task.time) {
			if(!task.repeat) {
				tasks.remove(i)
				i--
			}
			task.args[task.funcKey]()
		}
	}
}

function RegisterTickFunction(func, scope = null) {
	if(typeof(func) != "function" && typeof(func) != "native function") {
		logger.Debug("Failed to register tick function, function is not a function")
		return false
	}
	
	local infos = func.getinfos()
	
	if(infos.native) {
		logger.Warn("Native functions cannot be registered as tick functions (name=" + infos.name + ")")
		return false
	}
	
	if(infos.parameters.len() > 1) {
		logger.Warn("Tick functions cannot have arguments (src=" + infos.src + ":" + infos.name + ")")
		return false
	}
	
	if(scope)
		func = func.bindenv(scope)
	
	tickFunctions.append(func)
	
	logger.Debug("Registered " + infos.src + ":" + infos.name + " as a tick function")
	
	return func
}

function RemoveTickFunction(func) {	
	for(local i = 0; i < tickFunctions.len(); i++) {
		if(tickFunctions[i] == func) {
			tickFunctions.remove(i)
			return true
		}
	}
	
	logger.Debug("Cannot remove function \"" + func.getinfos().name + "\", it isn't a tick function")
	
	return false
}

task_count <- 1

function CancelTask(id) {
	for(local i = 0; i < tasks.len(); i++) {
		if(tasks[i].id == id) {
			tasks.remove(i)
			logger.Debug("Canceled task (id=" + id + ")")
			return true
		}
	}
	
	return false
}

// TODO: pass the args to the function?
function ScheduleTask(func, time, args = {}, absoluteTime = false, repeat = false) {
	local funcKey = UniqueString()
	args[funcKey] <- func
	
	time = absoluteTime ? time : Time() + time
	
	logger.Debug("Scheduled task at time " + time)
	
	tasks.append({
		id = task_count
		funcKey = funcKey
		time = time
		args = args
		repeat = repeat
	})
	
	local temp = task_count
	
	task_count++
	
	return temp
}

function DoNextTick(func, args) {
	ScheduleTask(func, 0, args)
}