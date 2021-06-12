version <- "1.0"
name <- "Callbacks"
description <- "Various callbacks"
dependencies <- "logger,timing,constants"

function OnLoad() {
	tickFuncReference <- timing.RegisterTickFunction(OnTick, this)
	
	logger.SetLevel(root.logger.LogLevel.ALL)
	logger.SetLocation(root.logger.LogLocation.CONSOLE)
	logger.SetTimeType(root.logger.TimeType.MAP)
	logger.DisableLogFile()
}

function OnUnload() {
	timing.RemoveTickFunction(tickFuncReference)
}


class PlayerInfo {
	player = null
	keys = 0
	
	constructor(player) {
		this.player = player
	}
	
	function GetPlayer() {
		return player
	}
	
	function SetKeys(keys) {
		this.keys = keys
	}
	
	function GetKeys() {
		return keys
	}
}

class Callback {
	func = null
	key = 0
	id = 0
	
	constructor(func, key, id) {
		this.func = func
		this.key = key
		this.id = id
	}
	
	function GetFunction() {
		return func
	}
	
	function GetKey() {
		return key
	}

	function GetID() {
		return id
	}
}

playerInfos <- []
keyCallbacks <- []

KeyState <- {
	START = 0
	TICK = 1
	END = 2
}

key_callback_count <- 0

// callback function is passed player and keystate
function RegisterKeyCallback(func, key, scope = null) {	
	func = func.bindenv(scope ? scope : getroottable())

	keyCallbacks.append(Callback(func, key, key_callback_count))
	
	logger.Info("Added key press callback for key \"" + GetKeyName(key) + "\" (id=" + key_callback_count + ")")

	return key_callback_count++
}

function RemoveKeyCallback(id) {
	foreach(index, callback in keyCallbacks) {
		if(callback.GetID() == id) {
			keyCallbacks.remove(index)
			return true
		}
	}

	logger.Debug("Failed to remove key callback (id=" + id + ")")

	return false
}

function OnTick() {
	foreach(callback in keyCallbacks) {
		local key = callback.GetKey()
		
		foreach(info in playerInfos) {
			if(!info.GetPlayer() || !info.GetPlayer().IsValid())
				continue
			
			local player = info.GetPlayer()
			local keyName = GetKeyName(key)
			
			if((info.GetKeys() & key) && (player.GetButtonMask() & key)) {
				RunKeyCallback(callback, player, KeyState.TICK)
			}
			if((info.GetKeys() & key) && !(player.GetButtonMask() & key)) {
				RunKeyCallback(callback, player, KeyState.END)
			}
			if(!(info.GetKeys() & key) && (player.GetButtonMask() & key)) {
				RunKeyCallback(callback, player, KeyState.START)
			}
		}
	}
	
	UpdatePlayerInfos()
}

function GetKeyName(keyId) {
	foreach(key, val in constants.Keys) {
		if(val == keyId) {
			return key
		}
	}
}

function RunKeyCallback(callback, player, keyState) {
	try {
		callback.GetFunction()(player, keyState)
	} catch(exception) {
		logger.Error("Ran into an error while running key callback: " + exception)
	}
}

function UpdatePlayerInfos() {
	for(local ent = null; ent = Entities.FindByClassname(ent, "player");) {
		local found = false
		for(local i = 0; i < playerInfos.len(); i++) {
			if(playerInfos[i].GetPlayer() == ent) {
				found = true
				playerInfos[i].SetKeys(ent.GetButtonMask())
				break
			}
		}
		
		if(!found) {
			playerInfos.append(PlayerInfo(ent))
		}
	}
	
	for(local i = 0; i < playerInfos.len(); i++) {
		local found = false
		for(local ent = null; ent = Entities.FindByClassname(ent, "player");) {
			if(playerInfos[i].GetPlayer() == ent) {
				found = true
				break
			}
		}
		
		if(!found) {
			playerInfos.remove(i)
			i--
		}
	}
}