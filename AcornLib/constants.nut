version <- "1.0"
name <- "Constants"
description <- "Miscellaneous constants"

Keys <- {
	ATTACK = 1
	JUMP = 2
	DUCK = 4
	FORWARD = 8
	BACKWARD = 16
	USE = 32
	CANCEL = 64
	LEFT = 128
	RIGHT = 256
	MOVELEFT = 512
	MOVERIGHT = 1024
	ATTACK2 = 2048
	RUN = 4096
	RELOAD = 8192
	ALT1 = 16384
	ALT2 = 32768
	SHOWSCORES = 65536
	SPEED = 131072
	WALK = 262144
	ZOOM = 524288
	WEAPON1 = 1048576
	WEAPON2 = 2097152
	BULLRUSH = 4194304
	GRENADE1 = 8388608
	GRENADE2 = 16777216
	LOOKSPIN = 33554432
}

VariableTypes <- {
	INTEGER = "integer"
	FLOAT = "float"
	BOOLEAN = "bool"
	STRING = "string"
	TABLE = "table"
	ARRAY = "array"
	FUNCTION = "function"
	CLASS = "class"
	INSTANCE = "instance"
	THREAD = "thread"
	NULL = "null"
}

Flags <- {
	ONGROUND = 1 // At rest / on the ground
	DUCKING = 2 // Player flag -- Player is fully crouched
	WATERJUMP = 4 // player jumping out of water
	ONTRAIN = 8 // Player is _controlling_ a train, so movement commands should be ignored on client during prediction.
	INRAIN = 16 // Indicates the entity is standing in rain
	FROZEN = 32 // Player is frozen for 3rd person camera
	ATCONTROLS = 64 // Player can't move, but keeps key inputs for controlling another entity
	CLIENT = 128 // Is a player
	FAKECLIENT = 256 // Fake client, simulated server side; don't send network messages to them
	INWATER = 512
	FLY = 1024 // Changes the SV_Movestep() behavior to not need to be on ground
	SWIM = 2048 // Changes the SV_Movestep() behavior to not need to be on ground (but stay in water)
	CONVEYOR = 4096
	NPC = 8192
	GODMODE = 16384
	NOTARGET = 32768
	AIMTARGET = 65536 // set if the crosshair needs to aim onto the entity
	PARTIALGROUND = 131072 // not all corners are valid
	STATICPROP = 262144
	GRAPHED = 524288 // worldgraph has this ent listed as something that blocks a connection
	GRENADE = 1048576
	STEPMOVEMENT = 2097152 // Changes the SV_Movestep() behavior to not do any processing
	DONTTOUCH = 4194304 // Doesn't generate touch functions, generates Untouch() for anything it was touching when this flag was set
	BASEVELOCITY = 8388608 // Base velocity has been applied this frame (used to convert base velocity into momentum)
	WORLDBRUSH = 16777216 // Not moveable/removeable brush entity (really part of the world, but represented as an entity for transparency or something)
	OBJECT = 33554432 // Terrible name. This is an object that NPCs should see. Missiles, for example.
	KILLME = 67108864 // This entity is marked for death -- will be freed by game DLL
	ONFIRE = 134217728
	DISSOLVING = 268435456
	TRANSRAGDOLL = 536870912 // In the process of turning into a client side ragdoll.
	UNBLOCKABLE_BY_PLAYER = 1073741824 // pusher that can't be blocked by the player
	FREEZING = 2147483648
}

RenderFX <- {
	NONE = 0
	PULSE_SLOW = 1
	PULSE_FAST = 2
	PULSE_SLOW_WIDE = 3
	PULSE_FAST_WIDE = 4
	FADE_SLOW = 5
	FADE_FAST = 6
	SOLID_SLOW = 7
	SOLID_FAST = 8
	STROBE_SLOW = 9
	STROBE_FAST = 10
	STROBE_FASTER = 11
	FLICKER_SLOW = 12
	FLICKER_FAST = 13
	NO_DISSIPATION = 14
	DISTORT = 15
	HOLOGRAM = 16
	EXPLODE = 17
	GLOWSHELL = 18
	CLAMP_MIN_SCALE = 19
	ENV_RAIN = 20
	ENV_SNOW = 21
	SPOTLIGHT = 22
	RAGDOLL = 23
	PULSE_FAST_WIDER = 24
}

EntityEffects <- {
	BONEMERGE = 1
	BRIGHT_LIGHT = 2
	DIM_LIGHT = 4
	NO_INTERP = 8
	NO_SHADOW = 16
	NO_DRAW = 32
	NO_RECEIVE_SHADOW = 64
	BONEMERGE_FASTCULL = 128
	ITEM_BLINK = 256
	PARENT_ANIMATES = 512
}

RenderModes <- {
	NORMAL = 0
	TRANS_COLOR = 1
	TRANS_TEXTURE = 2
	GLOW = 3
	TRANS_ALPHA = 4
	TRANS_ADD = 5
	ENVIRONMENTAL = 6
	TRANS_ADD_FRAME_BLEND = 7
	TRANS_ALPHA_ADD = 8
	WORLD_GLOW = 9
	NONE = 10
}

MoveTypes <- {
	NONE = 0
	ISOMETRIC = 1
	WALK = 2
	STEP = 3
	FLY = 4
	FLYGRAVITY = 5
	VPHYSICS = 6
	PUSH = 7
	NOCLIP = 8
	LADDER = 9
	OBSERVER = 10
	CUSTOM = 11
}

DamageTypes <- {
	GENERIC = 0
	CRUSH = 1
	BULLET = 2
	SLASH = 4
	BURN = 8
	VEHICLE = 16
	FALL = 32
	BLAST = 64
	CLUB = 128
	SHOCK = 256
	SONIC = 512
	ENERGYBEAM = 1024
	PREVENT_PHYSICS_FORCE = 2048
	NEVERGIB = 4096
	ALWAYSGIB = 8192
	DROWN = 16384
	PARALYZE = 32768
	NERVEGAS = 65536
	POISON = 131072
	RADIATION = 262144
	DROWNRECOVER = 524288
	ACID = 1048576
	MELEE = 2097152
	REMOVENORAGDOLL = 4194304
	PHYSGUN = 8388608
	PLASMA = 16777216
	STUMBLE = 33554432
	DISSOLVE = 67108864
	BLAST_SURFACE = 134217728
	DIRECT = 268435456
	BUCKSHOT = 536870912
	HEADSHOT = 1073741824
}

SolidTypes <- {
	NONE = 0
	BSP = 1
	BBOX = 2
	OBB = 3
	OBB_YAW = 4
	CUSTOM = 5
	VPHYSICS = 6
}

SolidFlags <- {
	CUSTOMRAYTEST = 1
	CUSTOMBOXTEST = 2
	NOT_SOLID = 4
	TRIGGER = 8
	NOT_STANDABLE = 16
	VOLUME_CONTENTS = 32
	FORCE_WORLD_ALIGNED = 64
	USE_TRIGGER_BOUNDS = 128
	ROOT_PARENT_ALIGNED = 256
	TRIGGER_TOUCH_DEBRIS = 512
}

MoveCollide <- {
	DEFAULT = 0
	FLY_BOUNCE = 1
	FLY_CUSTOM = 2
	FLY_SLIDE = 3
}

CollisionGroups <- {
	NONE = 0
	DEBRIS = 1
	DEBRIS_TRIGGER = 2
	INTERACTIVE_DEBRIS = 3
	INTERACTIVE = 4
	PLAYER = 5
	BREAKABLE_GLASS = 6
	VEHICLE = 7
	PLAYER_MOVEMENT = 8
	NPC = 9
	IN_VEHICLE = 10
	WEAPON = 11
	VEHICLE_CLIP = 12
	PROJECTILE = 13
	DOOR_BLOCKER = 14
	PASSABLE_DOOR = 15
	DISSOLVING = 16
	PUSHAWAY = 17
	NPC_ACTOR = 18
	NPC_SCRIPTED = 19
}

TraceContent <- {
	EMPTY = 0
	SOLID = 1
	WINDOW = 2
	AUX = 4
	GRATE = 8
	SLIME = 16
	WATER = 32
	MIST = 64
	OPAQUE = 128
	TESTFOGVOLUME = 256
	UNUSED5 = 512
	UNUSED6 = 1024
	TEAM1 = 2048
	TEAM2 = 4096
	IGNORE_NODRAW_OPAQUE = 8192
	MOVEABLE = 16384
	AREAPORTAL = 32768
	PLAYERCLIP = 65536
	MONSTERCLIP = 131072
	CURRENT_0 = 262144
	CURRENT_90 = 524288
	CURRENT_180 = 1048576
	CURRENT_270 = 2097152
	CURRENT_UP = 4194304
	CURRENT_DOWN = 8388608
	ORIGIN = 16777216
	MONSTER = 33554432
	DEBRIS = 67108864
	DETAIL = 134217728
	TRANSLUCENT = 268435456
	LADDER = 536870912
	HITBOX = 1073741824
}

TraceMasks <- {
	ALL = -1
	SOLID = 33570827
	PLAYERSOLID = 33636363
	NPCSOLID = 33701899
	WATER = 16432
	OPAQUE = 16513
	OPAQUE_AND_NPCS = 33570945
	VISIBLE = 24705
	VISIBLE_AND_NPCS = 33579137
	SHOT = 1174421507
	SHOT_HULL = 100679691
	SHOT_PORTAL = 16387
	SOLID_BRUSHONLY = 16395
	PLAYERSOLID_BRUSHONLY = 81931
	NPCSOLID_BRUSHONLY = 147467
	NPCWORLDSTATIC = 131083
	SPLITAREAPORTAL = 48
}

BotCommands <- {
	ATTACK = 0
	MOVE = 1
	RETREAT = 2
	RESET = 3
}

BotSense <- {
	CANT_SEE = 1
	CANT_HEAR = 2
	CANT_FEEL = 4
}

HUDPositions <- {
	LEFT_TOP = 0
	LEFT_BOT = 1
	MID_TOP = 2
	MID_BOT = 3
	RIGHT_TOP = 4
	RIGHT_BOT = 5
	TICKER = 6
	FAR_LEFT = 7
	FAR_RIGHT = 8
	MID_BOX = 9
	SCORE_TITLE = 10
	SCORE_1 = 11
	SCORE_2 = 12
	SCORE_3 = 13
	SCORE_4 = 14
}

HUDFlags <- {
	PRESTR = 1
	POSTSTR = 2
	BEEP = 4
	BLINK = 8
	AS_TIME = 16
	COUNTDOWN_WARN = 32
	NOBG = 64
	ALLOWNEGTIMER = 128
	ALIGN_LEFT = 256
	ALIGN_CENTER = 512
	ALIGN_RIGHT = 768
	TEAM_SURVIVORS = 1024
	TEAM_INFECTED = 2048
	TEAM_MASK = 3072
	NOTVISIBLE = 16384
}

ZombieTypes <- {
	COMMON = 0
	SMOKER = 1
	BOOMER = 2
	HUNTER = 3
	SPITTER = 4
	JOCKEY = 5
	CHARGER = 6
	WITCH = 7
	TANK = 8
	SURVIVOR = 9
	MOB = 10
	WITCHBRIDE = 11
	MUDMEN = 12
}

EntityFlags <- {
	KILLME = 1
	DORMANT = 2
	NOCLIP_ACTIVE = 4
	SETTING_UP_BONES = 8
	KEEP_ON_RECREATE_ENTITIES = 16
	HAS_PLAYER_CHILD = 32
	DIRTY_SHADOWUPDATE = 64
	NOTIFY = 128
	FORCE_CHECK_TRANSMIT = 256
	BOT_FROZEN = 512
	SERVER_ONLY = 1024
	NO_AUTO_EDICT_ATTACH = 2048
	DIRTY_ABSTRANSFORM = 4096
	DIRTY_ABSVELOCITY = 8192
	DIRTY_ABSANGVELOCITY = 16384
	DIRTY_SURR_COLLISION_BOUNDS = 32768
	DIRTY_SPATIAL_PARTITION = 65536
	IN_SKYBOX = 262144
	USE_PARTITION_WHEN_NOT_SOL = 524288
	TOUCHING_FLUID = 1048576
	IS_BEING_LIFTED_BY_BARNACLE = 2097152
	NO_ROTORWASH_PUSH = 4194304
	NO_THINK_FUNCTION = 8388608
	NO_GAME_PHYSICS_SIMULATION = 16777216
	CHECK_UNTOUCH = 33554432
	DONTBLOCKLOS = 67108864
	DONTWALKON = 134217728
	NO_DISSOLVE = 268435456
	NO_MEGAPHYSCANNON_RAGDOLL = 536870912
	NO_WATER_VELOCITY_CHANGE = 1073741824 
	NO_PHYSCANNON_INTERACTION = 2147483648
	NO_DAMAGE_FORCES = 4294967296
}