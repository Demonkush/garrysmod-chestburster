-- Chestburster v1.0 -- by Demonkush --
-- http://steamcommunity.com/id/Demonkush/
-- www.xmpstudios.com --
include("shared.lua")
include("sv_chest.lua")
include("sv_player.lua")
include("sv_round.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("shd_elements.lua")
AddCSLuaFile("shd_powerups.lua")
AddCSLuaFile("shd_sounds.lua")
AddCSLuaFile("shd_traps.lua")
AddCSLuaFile("shd_weapons.lua")
AddCSLuaFile("cl_init.lua")
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
	timer.Create("CleanupHL2DM",3,3,function() CleanupHL2DM() end)
end

function CleanupHL2DM()
	for k,v in pairs(ents.GetAll()) do
		if string.match(v:GetClass(),"item_") then v:Remove() end
		if string.match(v:GetClass(),"weapon_") then v:Remove() end
	end
end

function GM:Think()
	if gamemode.TimerDelay < CurTime() then
		if CHESTBURSTER.RoundState == 2 then
			CHESTBURSTER.RoundTimer = CHESTBURSTER.RoundTimer - 1 
			if CHESTBURSTER.RoundTimer < 0 then CHESTBURSTER.RoundEnd() end 
			print(CHESTBURSTER.RoundTimer)
		end
		gamemode.TimerDelay = CurTime() + 1
	end
	if gamemode.RoundTickDelay < CurTime() then
		CHESTBURSTER.RoundTick() gamemode.RoundTickDelay = CurTime() + 5
	end
	if gamemode.ChestSpawnDelay < CurTime() then
		CHESTBURSTER.SpawnChest() gamemode.ChestSpawnDelay = CurTime() + 7
	end
	if gamemode.PlayerKODelay < CurTime() then
		CHESTBURSTER.PlayerKOTick() gamemode.PlayerKODelay = CurTime() + 2
	end
end

function CHESTBURSTER.PlayerKOTick()
	for k, v in pairs(player.GetAll()) do
		if v:GetNWBool("Spectating") == false then
			v:ChangeKO(5,"-")
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

--[[-------------------------------------------------------------------------
Add Chest ( Adds a chest spawn at your position )
---------------------------------------------------------------------------]]--
concommand.Add("chbu_addchest", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	ply:PrintMessage(HUD_PRINTTALK,"Added a chest spawn at: "..tostring("x: "..ply:GetPos().x.." / y: "..ply:GetPos().y.." / z: "..ply:GetPos().z) )
	table.insert(CHESTBURSTER.ChestSpawnTable,ply:GetPos())
	net.Start("CHESTBURSTERDEBUGUPDATE") net.WriteTable(CHESTBURSTER.ChestSpawnTable) net.Send(ply)
end)

--[[-------------------------------------------------------------------------
Remove Chest ( Removes a chest spawn based on its key, easy to view position and keys with CHESTBURSTER.Debug enabled in shared.lua )
---------------------------------------------------------------------------]]--
concommand.Add("chbu_removechest", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	local key = tonumber(args[1])
	ply:PrintMessage(HUD_PRINTTALK,"Removed chest "..key)
	table.remove(CHESTBURSTER.ChestSpawnTable,key)
	net.Start("CHESTBURSTERDEBUGUPDATE") net.WriteTable(CHESTBURSTER.ChestSpawnTable) net.Send(ply)
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
	net.Start("CHESTBURSTERDEBUGUPDATE") net.WriteTable(CHESTBURSTER.ChestSpawnTable) net.Send(ply)
end)

--[[-------------------------------------------------------------------------
Clear Chests ( Clears chest spawn table )
---------------------------------------------------------------------------]]--
concommand.Add("chbu_clearchests", function(ply,cmd,args)
	if !ply:IsSuperAdmin() then return end
	ply:PrintMessage(HUD_PRINTTALK,"Cleared all chest spawn data.")
	CHESTBURSTER.ChestSpawnTable = {}
	net.Start("CHESTBURSTERDEBUGUPDATE") net.WriteTable(CHESTBURSTER.ChestSpawnTable) net.Send(ply)
end)