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

-- Pre Round = 1, Active Round = 2, Post Round = 3
function CHESTBURSTER.RoundStart()
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

	net.Start("CHESTBURSTERROUNDINFO")
		net.WriteInt(CHESTBURSTER.RoundState,8)
		net.WriteBool(true)
	net.Broadcast()
end

function CHESTBURSTER.GameRestart()
	CHESTBURSTER.RoundState = 1
	CHESTBURSTER.RoundTimerFunc(2)

	net.Start("CHESTBURSTERROUNDINFO")
		net.WriteInt(CHESTBURSTER.RoundState,8)
		net.WriteBool(false)
	net.Broadcast()

	CHESTBURSTER_Message(self, "Game", "Round ending, not enough players to continue!", Vector(255,215,215), true)
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

	local winning = {} table.SortByKey(players)
	if IsValid(players[1]) then table.insert(winning,{name=players[1]:Name(),gold=players[1]:GetNWInt("Gold"),kos=players[1]:GetNWInt("TotalKO"),kod=players[1]:GetNWInt("SelfKO")}) end
	if IsValid(players[2]) then table.insert(winning,{name=players[2]:Name(),gold=players[2]:GetNWInt("Gold"),kos=players[2]:GetNWInt("TotalKO"),kod=players[2]:GetNWInt("SelfKO")}) end
	if IsValid(players[3]) then table.insert(winning,{name=players[3]:Name(),gold=players[3]:GetNWInt("Gold"),kos=players[3]:GetNWInt("TotalKO"),kod=players[3]:GetNWInt("SelfKO")}) end

	CHESTBURSTER_Message(self, "Game", "The round is over!", Vector(255,215,215), true)
	CHESTBURSTER_Message(self, "Game", players[1]:Name().." is the winner!", Vector(255,215,215), true)
	net.Start("CHESTBURSTERROUNDWINNERS") net.WriteTable(winning) net.Broadcast()

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

		elseif CHESTBURSTER.MapChangeMode == "mapvote" then	
			-- Third Party Mapvote system commands go here, will differ depending on the addon
			-- Example: RunConsoleCommand("mapvote_force_vote") -- KmapVote
		end

		-- Failsafe ( if previous conditions were not met for some reason )
		timer.Simple(60,function()
			RunConsoleCommand("changelevel",game.GetMap())
		end)
	end)
end
