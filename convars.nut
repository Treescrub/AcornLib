version <- "1.0"
name <- "Convars"
short_name <- "convars"
dependencies <- "logging, timing"
description <- "Provides custom convar creation and convar change listening"


tickFuncId <- 0

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


function Think() {

}

function AddCustomConvar() {

}

function AddConvarListener() {

}

function RemoveConvarListener() {
    
}