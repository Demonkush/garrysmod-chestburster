GM.Name = "Chestburster"
GM.Author = "Demonkush"
GM.Website = "http://www.xmpstudios.com"

CHESTBURSTER = {}
CHESTBURSTER.Version = "1.1b"
CHESTBURSTER.ChestSpawnTable = {}

include("shd_elements.lua")
include("shd_powerups.lua")
include("shd_traps.lua")
include("shd_sounds.lua")
include("shd_weapons.lua")

CHESTBURSTER.ChestModels = {}
CHESTBURSTER.ChestModels[1] = {model="models/hunter/blocks/cube05x1x05.mdl",offset=Vector(0,0,12)}
CHESTBURSTER.ChestModels[2] = {model="models/props_junk/wood_crate002a.mdl",offset=Vector(0,0,20)}
CHESTBURSTER.ChestModels[3] = {model="models/Items/ammocrate_smg1.mdl",offset=Vector(0,0,15)}
CHESTBURSTER.ChestModels[4] = {model="models/props_c17/FurnitureDrawer001a.mdl",offset=Vector(0,0,20)}
CHESTBURSTER.ChestModels[5] = {model="models/props_lab/filecabinet02.mdl",offset=Vector(0,0,15)}

CHESTBURSTER.Playermodels = {
	"models/player/kleiner.mdl",
	"models/player/gman_high.mdl",
	"models/player/alyx.mdl",
	"models/player/eli.mdl"
}

-- Hard Variables ( do not change )
CHESTBURSTER.RoundTimer = 0
CHESTBURSTER.RoundState = 1 -- 1 = waiting, 2 = active, 3 = ended / ending.
CHESTBURSTER.RoundNumber = 0
CHESTBURSTER.MapConfigLoaded = false
CHESTBURSTER.Debug = false -- Toggle this with the concommand chbu_debug.

-- Safe Variables ( configure these to your liking )
CHESTBURSTER.MaxGold = 1000 -- Total gold to collect to win the game.
CHESTBURSTER.GoldDropFraction = 4 -- Fraction of gold dropped on KO.

CHESTBURSTER.RoundTime 		= 240 	-- Duration of a round.
CHESTBURSTER.MapVoteDelay 	= 10 	-- Delay between end of last round and map vote starting.
CHESTBURSTER.MaxRounds 		= 3 	-- Total number of rounds before map change.

CHESTBURSTER.FistWeapon 	= "weapon_fists"	-- Weapon to use for default fist weapon.
CHESTBURSTER.FistDamage 	= 15 				-- Amount of damage dealt with fists.
CHESTBURSTER.FistPower 		= 100				-- Knockback value.

CHESTBURSTER.GoldRating 		= 50 	-- Amount of gold acquired from chests.
CHESTBURSTER.GoldDiff 			= 25 	-- Random difference applied to gold. ( ex: 10 = (5 to 25 from 15) )
CHESTBURSTER.RareChestChance	= 20   	-- Chance to spawn a rare chest.
CHESTBURSTER.TrapChestChance	= 55 	-- Chance to spawn a trap chest.
CHESTBURSTER.RareGoldRating 	= 4 	-- Multiplier for getting gold from rare chests.
CHESTBURSTER.WeaponChance 		= 77 	-- Percentage of getting a weapon from a chest.
CHESTBURSTER.PowerupChance 		= 77 	-- Percentage of getting a powerup from a chest.
CHESTBURSTER.ChestSpawnDelay 	= 4 	-- Chest spawn delay.
CHESTBURSTER.ChestDespawnDelay 	= 60    -- When to despawn chests after spawning. ( 0 = disable )

CHESTBURSTER.SlowRating 	= 2  	-- Multiplier for movement slowing buff.
CHESTBURSTER.HasteRating 	= 2 	-- Multiplier for movement speed buff.

CHESTBURSTER.KOTime 		= 7 	-- time in seconds spent KO'd.
CHESTBURSTER.KORecoveryTime = 3 	-- time in seconds immune to KO.
CHESTBURSTER.KOMax 			= 100 	-- Max KO power.

CHESTBURSTER.KORegen		= 5 	-- Amount of KO to regen overtime.
CHESTBURSTER.KORegenDelay	= 2 	-- KO regeneration delay.

-- Available MapChangeMode types -- 
-- "nextmap": Automatically retrieves and changes to next map. See mapcycle.txt in garrysmod/cfg
-- "mapvote": Third party map vote system ( requires user config, see CHESTBURSTER.ChangeMap() )
CHESTBURSTER.MapChangeMode = "nextmap"

concommand.Remove("kill")