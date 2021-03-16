version <- "1.0"
name <- "Callbacks"
short_name <- "callbacks"
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
	
	constructor(func, key) {
		this.func = func
		this.key = key
	}
	
	function GetFunction() {
		return func
	}
	
	function GetKey() {
		return key
	}
}

playerInfos <- []
keyCallbacks <- []

KeyState <- {
	START = 0
	TICK = 1
	END = 2
}

// callback function is passed player and keystate
function RegisterKeyCallback(func, key) {
	for(local i = 0; i < keyCallbacks.len(); i++) {
		foreach(idx, callback in keyCallbacks) {
			if(callback.GetFunction() == func) {
				keyCallbacks.remove(idx)
				logger.Info("Replaced key press callback function \"" + callback.GetFunction() + "\" with \"" + func + "\"")
				break
			}
		}
	}
	
	keyCallbacks.append(Callback(func, key))
	
	logger.Info("Added key press callback for function \"" + func + "\" with key \"" + GetKeyName(key) + "\"")
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
	callback.GetFunction()(player, keyState)
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