version <- "1.0.0"
name <- "Anti-Bhop"
short_name <- "anti-bhop"
dependencies <- "logger,constants,callbacks, timing"
description <- "Prevents speed gains from bunnyhopping"

function OnLoad() {
	jumpCallbackId <- callbacks.RegisterKeyCallback(JumpKeyPress, constants.Keys.JUMP, this)
    tickFuncId <- timing.RegisterTickFunction(OnTick, this)

    logger.SetLevel(logger.LogLevel.DEBUG)
	logger.SetLocation(logger.LogLocation.CHAT)
	logger.SetTimeType(logger.TimeType.CLOCK)
	logger.DisableLogFile()
}

function OnUnload() {
    callbacks.RemoveKeyCallback(jumpCallbackId)
    timing.RemoveTickFunction(tickFuncId)
}


function OnTick() {
    for(local player = null; player = Entities.FindByClassname(player, "player");) {
        if(NetProps.GetPropInt(player, "m_fFlags") & 1) {
            player.ValidateScriptScope()
            player.GetScriptScope()["onGround"] <- true
        }
    }
}

function JumpKeyPress(player, keyState) {
    if(keyState != callbacks.KeyState.START) 
        return

    if(!player.ValidateScriptScope() || !("onGround" in player.GetScriptScope()) || !player.GetScriptScope()["onGround"])
        return

    local maxSpeed = NetProps.GetPropFloat(player, "m_flMaxspeed")
    local velocity = player.GetVelocity()

    if(velocity.Length2D() > maxSpeed + 1) {
        local scaledVelocity = Vector(velocity.x, velocity.y, 0)
        scaledVelocity = scaledVelocity.Scale(maxSpeed / velocity.Length2D())
        scaledVelocity.z = velocity.z

        player.SetVelocity(scaledVelocity)

        logger.Debug("Scaling velocity of " + player.GetPlayerName() + " from " + velocity.Length2D() + " -> " + scaledVelocity.Length2D())
    }

    player.GetScriptScope()["onGround"] = false
}