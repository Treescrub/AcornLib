version <- "1.0"
name <- "Sprinting"
short_name <- "sprinting"
dependencies <- "constants,callbacks,convars,timing"
description <- "Allows survivors to sprint for a short time instead of walking. Only works for one person."

function OnLoad() {
    convars.AddCustomConvar("sprint_max_time", maxSprintTime)
    convars.AddCustomConvar("sprint_recover_rate", 0.033)
    convars.AddCustomConvar("sprint_speed", 3)
    convarListenerId <- convars.AddConvarListener("sprint_max_time", MaxSprintTimeChanged, this)

    walkCallbackId <- callbacks.RegisterKeyCallback(WalkKeyPress, constants.Keys.SPEED, this)

    tickFuncId <- timing.RegisterTickFunction(OnTick, this)

    logger.SetLevel(logger.LogLevel.INFO)
	logger.SetLocation(logger.LogLocation.CONSOLE)
	logger.SetTimeType(logger.TimeType.MAP)
	logger.DisableLogFile()
}

function OnUnload() {
	timing.RemoveTickFunction(tickFuncId)
    convars.RemoveConvarListener(convarListenerId)
    callbacks.RemoveKeyCallback(walkCallbackId)
}

sprintStart <- null

maxSprintTime <- 5
stamina <- maxSprintTime

function MaxSprintTimeChanged(convar, old, new) {
    maxSprintTime = new
    stamina = new
}

function OnTick() {
    if(sprintStart == null) {
        stamina += Convars.GetFloat("sprint_recover_rate")

        if(stamina > maxSprintTime) {
            stamina = maxSprintTime
        }
    }
}

function WalkKeyPress(player, keyState) {
    switch(keyState) {
        case callbacks.KeyState.START:
            sprintStart = Time()
            break
        case callbacks.KeyState.TICK:
            if(Time() - sprintStart < stamina) {
                NetProps.SetPropFloat(player, "m_flVelocityModifier", Convars.GetFloat("sprint_speed"))
            }
            break
        case callbacks.KeyState.END:
            stamina -= Time() - sprintStart
            sprintStart = null
            break
    }
    if(keyState == callbacks.KeyState.START) {
        sprintStart = Time()
    }
}