function CHESTBURSTER.SaveMapConfig()
	local map = game.GetMap()
	local path = "chestburster/"..map..".txt"
	local spawns = util.TableToJSON(CHESTBURSTER.ChestSpawnTable)
	if !file.Exists("chestburster","DATA") then
		file.CreateDir("chestburster")
	end
	file.Write(path,spawns)
end

function CHESTBURSTER.LoadMapConfig()
	local map = game.GetMap()

	-- Load from sv_presetmaps.lua
	if CHESTBURSTER.MapChangeMode == "default" then
		CHESTBURSTER.GetPresetSpawnData()
		CHESTBURSTER.MapConfigLoaded = true
		print("[CHBU DEBUG] Loaded preset configuration for "..map..".bsp!")
		return
	end

	-- Load from .txt data
	local path = "chestburster/"..map..".txt"
	if file.Exists(path,"DATA") then
		local load = file.Read(path,"DATA")
		local spawns = util.JSONToTable( load )
		table.Empty(CHESTBURSTER.ChestSpawnTable)
		CHESTBURSTER.ChestSpawnTable = table.Copy(spawns)
		CHESTBURSTER.MapConfigLoaded = true
		print("[CHBU DEBUG] Loaded configuration for "..map..".bsp!")
	else
		print("[CHBU DEBUG] Loot configuration missing for "..map..".bsp!")
	end
end

function CHESTBURSTER.RoundTimerFunc(mode)
	if mode == 1 then
		CHESTBURSTER.RoundTimer = CHESTBURSTER.RoundTime
	elseif mode == 2 then
		CHESTBURSTER.RoundTimer = 0
	end
	net.Start("CHESTBURSTERROUNDTIMER")
		net.WriteInt(CHESTBURSTER.RoundTimer,32)
	net.Broadcast()
end

function CHESTBURSTER.CleanUpMap()
	game.CleanUpMap()
	local rements = {"chbu_chest","chbu_gold","chbu_mimic"}
	for a, b in pairs(ents.GetAll()) do
		if table.HasValue(rements,b:GetClass()) then b:Remove() end
		if string.match(b:GetClass(),"weapon_") && b:GetOwner() == nil then b:Remove() end
	end
end

-- Pre Round = 1, Active Round = 2, Post Round = 3
function CHESTBURSTER.RoundStart()
	CHESTBURSTER.CleanUpMap()
	CHESTBURSTER.LoadMapConfig()
	CHESTBURSTER.RoundNumber = CHESTBURSTER.RoundNumber + 1
	CHESTBURSTER.RoundState = 2
	CHESTBURSTER.RoundTimerFunc(1)

	CHESTBURSTER_Message(self, "Game", "Round "..CHESTBURSTER.RoundNumber.." has begun!", Vector(255,215,215), true)
	local rements = {"chbu_chest","chbu_gold"}
	for a, b in pairs(ents.GetAll()) do
		if table.HasValue(rements,b:GetClass()) then b:Remove() end
	end

	for k, v in pairs(player.GetAll()) do
		if v:GetNWBool("SpawnNextRound") == true then v:Spawn() CHESTBURSTER.PlayerReset(v) end
	end

	CHESTBURSTER.SendRoundInfo(true)
end

function CHESTBURSTER.GameRestart()
	CHESTBURSTER.RoundState = 1
	CHESTBURSTER.RoundNumber = 0
	CHESTBURSTER.RoundTimerFunc(2)
	CHESTBURSTER.SendRoundInfo(false)
	CHESTBURSTER_Message(self, "Game", "Round ending, not enough players to continue!", Vector(255,215,215), true)
end

function CHESTBURSTER.FullGameRestart()
	CHESTBURSTER.CleanUpMap()
	gamemode.RoundTickDelay = CurTime() + 5

	for k, v in pairs(player.GetAll()) do
		v:Spawn() CHESTBURSTER.PlayerReset(v,1)
	end

	CHESTBURSTER.RoundState = 1
	CHESTBURSTER.RoundNumber = 0
	CHESTBURSTER.RoundTimerFunc(2)

	CHESTBURSTER.SendRoundInfo(false)
	CHESTBURSTER_Message(self, "Game", "The game was reset! Will restart in 5 seconds...", Vector(215,255,175), true)
end

function CHESTBURSTER.SendRoundInfo(mode)
	net.Start("CHESTBURSTERROUNDINFO")
		net.WriteInt(CHESTBURSTER.RoundState,8)
		net.WriteBool(mode)
	net.Broadcast()
end

function CHESTBURSTER.RoundEnd()
	if CHESTBURSTER.RoundState != 2 then return end
	CHESTBURSTER.RoundState = 3
	CHESTBURSTER.RoundTimerFunc(2)

	local players = {}
	for k, v in pairs(player.GetAll()) do
		if v:GetNWBool("Spectating") == false && !v:IsBot() then table.insert(players,v) end
	end
	table.sort(players,function(a,b) return a:GetNWInt("Gold")>b:GetNWInt("Gold") end)

	local winning = {}
	if IsValid(players[1]) then table.insert(winning,{ply=players[1],gold=players[1]:GetNWInt("Gold"),kos=players[1]:GetNWInt("TotalKO"),kod=players[1]:GetNWInt("SelfKO")}) end
	if IsValid(players[2]) then table.insert(winning,{ply=players[2],gold=players[2]:GetNWInt("Gold"),kos=players[2]:GetNWInt("TotalKO"),kod=players[2]:GetNWInt("SelfKO")}) end
	if IsValid(players[3]) then table.insert(winning,{ply=players[3],gold=players[3]:GetNWInt("Gold"),kos=players[3]:GetNWInt("TotalKO"),kod=players[3]:GetNWInt("SelfKO")}) end

	CHESTBURSTER_Message(self, "Game", "The round is over!", Vector(215,215,215), true)

	if IsValid(winning[1].ply) then
		if winning[1].gold > 0 then
			winning[1].ply:AddFrags(1)
			CHESTBURSTER_Message(self, "Game", winning[1].ply:Name().." is the winner!", Vector(155,215,255), true)
			net.Start("CHESTBURSTERROUNDWINNERS") net.WriteTable(winning) net.Broadcast()
		end
		if winning[2] && IsValid(winning[2].ply) then
			if winning[1].gold > 0 && winning[1].gold == winning[2].gold then
				CHESTBURSTER_Message(self, "Game", "It was a tie!", Vector(215,215,115), true)
			end
		end
	end
	if CHESTBURSTER.RoundNumber >= CHESTBURSTER.MaxRounds then
		CHESTBURSTER_Message(self, "Game", "The game is over! Map is changing!", Vector(255,215,215), true)
		CHESTBURSTER.ChangeMap()
	else
		timer.Simple(3,function()
			CHESTBURSTER.RoundStart()
		end)
	end
end

function CHESTBURSTER.ChangeMap()
	timer.Simple(CHESTBURSTER.MapVoteDelay,function()
		if CHESTBURSTER.MapChangeMode == "nextmap" then RunConsoleCommand("changelevel",game.GetMapNext())
			-- Dont touch
		elseif CHESTBURSTER.MapChangeMode == "mapvote" then	
			-- >> Custom map vote functions go here!!! <<
			XMPSwitch.GamevoteInit()
		elseif CHESTBURSTER.MapChangeMode == "default" then
			-- Dont touch
			CHESTBURSTER.PresetChangeMap()
		end

		-- Failsafe ( if previous conditions were not met for some reason )
		timer.Simple(120,function()
			RunConsoleCommand("changelevel",game.GetMap())
		end)
	end)
end
