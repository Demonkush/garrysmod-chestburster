-- Chestburster -- by Demonkush --
-- http://steamcommunity.com/id/Demonkush/
-- www.xmpstudios.com --
include("shared.lua")
include("sv_chest.lua")
include("sv_player.lua")
include("sv_round.lua")
include("sv_presetmaps.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("shd_elements.lua")
AddCSLuaFile("shd_powerups.lua")
AddCSLuaFile("shd_sounds.lua")
AddCSLuaFile("shd_traps.lua")
AddCSLuaFile("shd_weapons.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_scoreboard.lua")
util.AddNetworkString("CHESTBURSTERSENDSTATUS")
util.AddNetworkString("CHESTBURSTERSENDPOWERUP")
util.AddNetworkString("CHESTBURSTERROUNDINFO")
util.AddNetworkString("CHESTBURSTERROUNDTIMER")
util.AddNetworkString("CHESTBURSTERROUNDWINNERS")
util.AddNetworkString("CHESTBURSTERSCOREBOARD")
util.AddNetworkString("CHESTBURSTERNOTIFICATION")
util.AddNetworkString("CHESTBURSTERWEAPONINFO")
util.AddNetworkString("CHESTBURSTERDEBUGUPDATE")
util.AddNetworkString("CHESTBURSTERBLIND")
util.AddNetworkString("CHESTBURSTERDETECTION")

function GM:Initialize()
	gamemode.TimerDelay = 1
	gamemode.RoundTickDelay = 5
	gamemode.ChestSpawnDelay = 5
	gamemode.PlayerKODelay = 2
	CHESTBURSTER.LoadMapConfig()
	timer.Create("CHBUPrelimSetup",3,3,function() CHBUPreSetup() end)
end

function CHBUPreSetup()
	for k,v in pairs(ents.GetAll()) do
		if string.match(v:GetClass(),"weapon_chbu") == false or string.match(v:GetClass(),"weapon_fists") == false then		
			if string.match(v:GetClass(),"item_") then v:Remove() end
			if string.match(v:GetClass(),"weapon_") then v:Remove() end
			if string.match(v:GetClass(),"prop_physics") then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
				end
			end
		end
	end
end

function GM:Think()
	if gamemode.TimerDelay < CurTime() then
		if CHESTBURSTER.RoundState == 2 then
			CHESTBURSTER.RoundTimer = CHESTBURSTER.RoundTimer - 1 
			if CHESTBURSTER.RoundTimer < 0 then CHESTBURSTER.RoundEnd() end 
		end
		gamemode.TimerDelay = CurTime() + 1
	end
	if gamemode.RoundTickDelay < CurTime() then
		CHESTBURSTER.RoundTick() gamemode.RoundTickDelay = CurTime() + 5
	end
	if gamemode.ChestSpawnDelay < CurTime() then
		CHESTBURSTER.SpawnChest() gamemode.ChestSpawnDelay = CurTime() + CHESTBURSTER.ChestSpawnDelay
	end
	if gamemode.PlayerKODelay < CurTime() then
		CHESTBURSTER.PlayerKOTick() gamemode.PlayerKODelay = CurTime() + CHESTBURSTER.KORegenDelay
	end
end

function CHESTBURSTER.PlayerKOTick()
	for k, v in pairs(player.GetAll()) do
		if v:GetNWBool("Spectating") == false then
			v:SetHealth(100)
			v:ChangeKO(CHESTBURSTER.KORegen,"-")
		end
	end
end

function CHESTBURSTER.RoundTick()
	local function CheckForPlayers()
		local plys = #player.GetAll()
		for k, v in pairs(player.GetAll()) do
			if v:GetNWBool("Spectating") == true then
				plys = plys - 1
			end
		end
		return plys
	end

	if CHESTBURSTER.RoundState == 1 then
		if CheckForPlayers() >= 2 then
			CHESTBURSTER.RoundStart()
		end
	elseif CHESTBURSTER.RoundState == 2 then
		if CheckForPlayers() <= 1 then
			CHESTBURSTER.GameRestart()
		end
	end
end

function CHESTBURSTER_Message(ply,ttype,msg,col,broadcast)
	local msg = tostring( msg )
	local col = Vector( col.x, col.y, col.z )
	if broadcast == false then
		umsg.Start("CHBU_ChatMsg",ply)
		  	umsg.String(ttype)
		  	umsg.String(msg)
		  	umsg.Vector(Vector(col.x,col.y,col.z))
		umsg.End()
	elseif broadcast == true then
		for a, b in pairs(player.GetAll()) do
			umsg.Start("CHBU_ChatMsg",b)
			  	umsg.String(ttype)
			  	umsg.String(msg)
			  	umsg.Vector(Vector(col.x,col.y,col.z))
			umsg.End()
		end
	end
end

function CHESTBURSTER_UpdateDebug(ply)
	timer.Simple(0.1,function()
		net.Start("CHESTBURSTERDEBUGUPDATE") net.WriteTable(CHESTBURSTER.ChestSpawnTable) net.WriteBool(CHESTBURSTER.Debug) net.Send(ply)
	end)
end

--[[-------------------------------------------------------------------------
Add Chest ( Adds a chest spawn at your position )
---------------------------------------------------------------------------]]--
concommand.Add("chbu_addchest", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	ply:PrintMessage(HUD_PRINTTALK,"Added a chest spawn at: "..tostring("x: "..ply:GetPos().x.." / y: "..ply:GetPos().y.." / z: "..ply:GetPos().z) )
	table.insert(CHESTBURSTER.ChestSpawnTable,ply:GetPos())
	CHESTBURSTER_UpdateDebug(ply)
end)

--[[-------------------------------------------------------------------------
Remove Chest ( Removes a chest spawn based on its key, easy to view position and keys with CHESTBURSTER.Debug enabled in shared.lua )
---------------------------------------------------------------------------]]--
concommand.Add("chbu_removechest", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	local key = tonumber(args[1])
	ply:PrintMessage(HUD_PRINTTALK,"Removed chest "..key)
	table.remove(CHESTBURSTER.ChestSpawnTable,key)
	CHESTBURSTER_UpdateDebug(ply)
end)

--[[-------------------------------------------------------------------------
Save Chests ( Saves spawn data in a text file )
---------------------------------------------------------------------------]]--
concommand.Add("chbu_savemap", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	ply:PrintMessage(HUD_PRINTTALK,"Attempted to save the map spawn data.")
	CHESTBURSTER.SaveMapConfig()
end)

--[[-------------------------------------------------------------------------
Load Chests ( Loads spawn data if available )
---------------------------------------------------------------------------]]--
concommand.Add("chbu_loadmap", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	ply:PrintMessage(HUD_PRINTTALK,"Attempted to load the map spawn data.")
	CHESTBURSTER.LoadMapConfig()
	CHESTBURSTER_UpdateDebug(ply)
end)

--[[-------------------------------------------------------------------------
Clear Chests ( Clears chest spawn table )
---------------------------------------------------------------------------]]--
concommand.Add("chbu_clearchests", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	ply:PrintMessage(HUD_PRINTTALK,"Cleared all chest spawn data.")
	CHESTBURSTER.ChestSpawnTable = {}
	CHESTBURSTER_UpdateDebug(ply)
end)

--[[-------------------------------------------------------------------------
Print Spawn Table (Server Only)
---------------------------------------------------------------------------]]
concommand.Add("chbu_printspawns", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	ply:PrintMessage(HUD_PRINTTALK,"Spawn data printed to server console.")
	print(table.ToString(CHESTBURSTER.ChestSpawnTable))
end)

--[[-------------------------------------------------------------------------
Toggle Debug
---------------------------------------------------------------------------]]--
concommand.Add("chbu_debug", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	ply:PrintMessage(HUD_PRINTTALK,"Debug toggled.")
	if CHESTBURSTER.Debug == false then CHESTBURSTER.Debug = true CHESTBURSTER_UpdateDebug(ply) return end
	if CHESTBURSTER.Debug == true then CHESTBURSTER.Debug = false CHESTBURSTER_UpdateDebug(ply) return end
end)

--[[-------------------------------------------------------------------------
Game Restart
---------------------------------------------------------------------------]]--
concommand.Add("chbu_restartgame", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end CHESTBURSTER.FullGameRestart()
end)

--[[-------------------------------------------------------------------------
Help
---------------------------------------------------------------------------]]--
concommand.Add("chbu_help", function(ply,cmd,args)
	print("----Chestburster Help----")
	print("+--+--Controls:")
	print("Tab / Scoreboard: Taunt")
	print("R / Reload: Drop Weapon")
	print("E / USE: Climb")
	print("----")
	print("+--+--How to Play:")
	print("Knock out other players and collect gold from opening chests!")
	print("Easy huh?")
end)