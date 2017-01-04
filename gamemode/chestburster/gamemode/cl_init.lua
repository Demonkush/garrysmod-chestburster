include("shared.lua")
local CHESTBURSTER_TimerCL = 0
local CHESTBURSTER_TimerTick = 0
local CHESTBURSTER_PBarDistance = 0

function GM:Initalize()
	LocalPlayer().Detection = false
end

function GM:Think()
	if CHESTBURSTER_TimerTick < CurTime() then
		if CHESTBURSTER_TimerCL > 0 then
			CHESTBURSTER_TimerCL = CHESTBURSTER_TimerCL - 1 CHESTBURSTER_TimerTick = CurTime() + 1
		end
	end
	CHESTBURSTER_PBarDistance = CHESTBURSTER_PBarDistance - 1
	if CHESTBURSTER_PBarDistance < -1000 then
		CHESTBURSTER_PBarDistance = 2000
	end
end

function GM:HUDPaint()
	CHESTBURSTER_DrawHUD() CHESTBURSTER_DrawPlayerBar()
	CHESTBURSTER_DrawStatuses() CHESTBURSTER_DrawPowerups()
	CHESTBURSTER_DrawDetection() CHESTBURSTER_DrawDebug()
end

function CHESTBURSTER_DrawDetection()
	-- Draw Player and Chest info ( for detection powerup )
	if LocalPlayer().Detection == true then
		for a, b in pairs(ents.GetAll()) do
			if b:IsPlayer() then
				local ts = (b:GetPos() + Vector(0,0,16)):ToScreen()
				draw.SimpleTextOutlined("V","Trebuchet18",ts.x,ts.y,Color(215,215,215,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
				draw.SimpleTextOutlined(b:Name().." [ "..b:GetNWInt("Gold").."/"..CHESTBURSTER.MaxGold.." ]","Trebuchet18",ts.x,ts.y-15,Color(255,235,185,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			end
			if b:GetClass() == "chbu_chest" then
				local ts2 = (b:GetPos() + Vector(0,0,16)):ToScreen()
				draw.SimpleTextOutlined("V","Trebuchet18",ts2.x,ts2.y,Color(55,255,55,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
				if b:GetRare() == true then
					draw.SimpleTextOutlined("Rare Chest!","Trebuchet18",ts2.x,ts2.y-15,Color(255,235,185,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
				end
				if b:GetTrap() == true then
					draw.SimpleTextOutlined("Trap!","Trebuchet18",ts2.x,ts2.y-15,Color(255,55,55,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
				end
			end
		end
	end
end
net.Receive("CHESTBURSTERDETECTION",function(len) local time = net.ReadInt(8) LocalPlayer().Detection = true timer.Simple(time,function() LocalPlayer().Detection = false end) end)

function CHESTBURSTER_DrawDebug()
	if CHESTBURSTER.Debug == true then
		-- Draw Chest Spawns
		for a, b in pairs(CHESTBURSTER.ChestSpawnTable) do
			local ts = (b + Vector(0,0,16)):ToScreen()
			draw.SimpleTextOutlined("V","Trebuchet18",ts.x,ts.y,Color(55,255,55,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
			draw.SimpleTextOutlined("Chest Spawn [ "..a.." ]","Trebuchet18",ts.x,ts.y-15,Color(55,255,55,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,155))
		end
	end
end
net.Receive("CHESTBURSTERDEBUGUPDATE",function(len) CHESTBURSTER.ChestSpawnTable = net.ReadTable() end)

function CHESTBURSTER_SetWeaponName(name)
	local wep = LocalPlayer():GetActiveWeapon()
	wep.PrintName = name.." "..wep.RealName
end
net.Receive("CHESTBURSTERWEAPONINFO",function(len) local name = net.ReadString() CHESTBURSTER_SetWeaponName(name) end)

function CHESTBURSTER_DrawPlayerBar()
	surface.SetDrawColor(Color(5,5,5,155))
	surface.DrawRect(0,0,ScrW(),25)

	local margin = 0
	for k, v in pairs(player.GetAll()) do
		draw.SimpleTextOutlined(v:Name().." : "..v:GetNWInt("Gold"),"Trebuchet24",CHESTBURSTER_PBarDistance+margin,0,Color(155,55,55,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
		margin = margin + 150 + (string.len(v:Name())*5) + (string.len(v:GetNWInt("Gold"))*5)
	end
end

function CHESTBURSTER_DrawHUD()
	draw.SimpleTextOutlined("CHESTBURSTER "..CHESTBURSTER.Version..", by Demonkush","Trebuchet18",5,30,Color(255,255,255,55),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(0,0,0,55))

	-- Spectator
	if LocalPlayer():GetNWBool("Spectating") == true then
		draw.SimpleTextOutlined("Spectating","Trebuchet24",ScrW()/2,ScrH()-55,Color(155,55,55,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
		if LocalPlayer():GetNWBool("SpawnNextRound") == true then
			draw.SimpleTextOutlined("Will spawn next round...","Trebuchet24",ScrW()/2,ScrH()-125,Color(155,155,155,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
		end
	end

	-- Draw Weapon
	local sw,sh = ScrW(),ScrH()
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) then
		draw.SimpleTextOutlined(wep.PrintName,"DermaLarge",ScrW()/2,ScrH()-35,Color(255,255,255,215),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,155))
	end

	-- Draw KO Power meter ( KO over Max KO )
	local ko,komax = LocalPlayer():GetNWInt("KO"),LocalPlayer():GetNWInt("KOMax")
	local kometer = ko/komax*250
	local kocolor = Color(155+ko,215-ko,155-ko,55)
	if LocalPlayer():GetNWBool("KnockedOut") == true then
		kocolor = Color(255,105,105,55)
		kometer = 0
		draw.SimpleTextOutlined("Knocked Out!","Trebuchet24",ScrW()/2,ScrH()-70,Color(215,55,55,215),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,155))
	end
	surface.SetDrawColor(0,0,0,155) surface.DrawRect(sw/2-127,ScrH()-77,254,29)
	surface.SetDrawColor(kocolor)
	surface.DrawRect(sw/2-125,ScrH()-75,kometer,25)
	draw.SimpleTextOutlined("KO Meter","DermaLarge",ScrW()/2,ScrH()-90,Color(155+ko,155,155-ko,215),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,155))

	-- Draw GOLD, Suffered KOs and Total KOs
	local gold,goldmax = LocalPlayer():GetNWInt("Gold"),CHESTBURSTER.MaxGold
	local kos,kod = LocalPlayer():GetNWInt("TotalKO"),LocalPlayer():GetNWInt("SelfKO")
	draw.SimpleTextOutlined("Gold: "..gold.."/"..goldmax,"DermaLarge",ScrW()/2,65,Color(255,215,155,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
	draw.SimpleTextOutlined(kos.." : Knockouts / Knocked Out : "..kod,"Trebuchet18",ScrW()/2,105,Color(215,215,215,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))

	-- Round Info
	local roundstate,timer,msg = CHESTBURSTER.RoundState,CHESTBURSTER_TimerCL,""
	if timer > 0 then draw.SimpleTextOutlined("Time Left: "..timer,"DermaLarge",ScrW()/2,35,Color(215,215,155,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255)) end
	if roundstate == 0 then msg = "" elseif roundstate == 1 then msg = "Waiting for more players!" elseif roundstate == 2 then msg = "" elseif roundstate == 3 then msg = "Round over!" end
	draw.SimpleTextOutlined(msg,"DermaLarge",ScrW()/2,ScrH()/3,Color(215,215,155,155),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
end

function GM:ScoreboardShow() end
function GM:ScoreboardHide() end

net.Receive("CHESTBURSTERROUNDINFO",function(len)
	local roundstate,roundstart = net.ReadInt(8),net.ReadBool()
	if roundstart == true then
		local_powerup_table = {}
		local_status_table = {}
	end
	CHESTBURSTER.RoundState = roundstate
end)
net.Receive("CHESTBURSTERROUNDTIMER",function(len)
	local timer = net.ReadInt(32)
	if timer == -1 then timer = 0 end
	CHESTBURSTER_TimerCL = timer
end)

function CHESTBURSTER_EndRoundScoreboard(winners)
	--print("[CHBU_DEBUG] End Round Scoreboard")
	--PrintTable(winners)
	if winners[1] then print("[1st Place!~] "..winners[1].name.." || Gold: "..winners[1].gold.." || KOs: "..winners[1].kos.." || KO'd: "..winners[1].kod) end
	if winners[2] then print("[2nd Place!~] "..winners[2].name.." || Gold: "..winners[2].gold.." || KOs: "..winners[2].kos.." || KO'd: "..winners[2].kod) end
	if winners[3] then print("[3rd Place!~] "..winners[3].name.." || Gold: "..winners[3].gold.." || KOs: "..winners[3].kos.." || KO'd: "..winners[3].kod) end

	local EndRoundScoreboard = vgui.Create("DFrame")
	EndRoundScoreboard:SetPos(ScrW()/2-400,ScrH()/2-300)
	EndRoundScoreboard:SetSize(800,250)
	EndRoundScoreboard:SetTitle("Round over!")
	EndRoundScoreboard:ShowCloseButton(true)
	EndRoundScoreboard.OnRemove = function() gui.EnableScreenClicker(false) end
	EndRoundScoreboard.Paint = function() 
		surface.SetDrawColor(0,0,0,185)
		surface.DrawTexturedRect(0,0,EndRoundScoreboard:GetWide(),EndRoundScoreboard:GetTall())
	end
	if winners[1] then
		local Winner1 = vgui.Create("DLabel",EndRoundScoreboard)
		Winner1:SetPos(15,50)
		Winner1:SetFont("Trebuchet24") Winner1:SetTextColor(Color(255,215,155,255))
		Winner1:SetText("[1st Place!~] "..winners[1].name.." || Gold: "..winners[1].gold.." || KOs: "..winners[1].kos.." || KO'd: "..winners[1].kod)
		Winner1:SetContentAlignment(5) Winner1:SizeToContents()
	end
	if winners[2] then
		local Winner2 = vgui.Create("DLabel",EndRoundScoreboard)
		Winner2:SetPos(55,100)
		Winner2:SetFont("Trebuchet18") Winner2:SetTextColor(Color(215,255,155,215))
		Winner2:SetText("[2nd Place!~] "..winners[2].name.." || Gold: "..winners[2].gold.." || KOs: "..winners[2].kos.." || KO'd: "..winners[2].kod)
		Winner2:SetContentAlignment(5) Winner2:SizeToContents()
	end
	if winners[3] then
		local Winner3 = vgui.Create("DLabel",EndRoundScoreboard)
		Winner3:SetPos(55,150)
		Winner3:SetFont("Trebuchet18") Winner3:SetTextColor(Color(215,215,215,185))
		Winner3:SetText("[3rd Place!~] "..winners[3].name.." || Gold: "..winners[3].gold.." || KOs: "..winners[3].kos.." || KO'd: "..winners[3].kod)
		Winner3:SetContentAlignment(5) Winner3:SizeToContents()
	end

	gui.EnableScreenClicker(true)

	timer.Simple(15,function() EndRoundScoreboard:Remove() end)
end
net.Receive("CHESTBURSTERROUNDWINNERS",function(len)
	local winners = net.ReadTable()
	CHESTBURSTER_EndRoundScoreboard(winners)
end)

--[[-------------------------------------------------------------------------
Powerups
---------------------------------------------------------------------------]]--
local local_powerup_table = {}
function CHESTBURSTER_DrawPowerups()
	local margin = 0
	for a, b in pairs(local_powerup_table) do
		draw.SimpleTextOutlined(b,"DermaLarge",ScrW()/2+250,ScrH()-75-margin,Color(155,155,255,215),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,155))
		margin = margin + 30
	end
end
net.Receive("CHESTBURSTERSENDPOWERUP",function(len)
	local powerup,time = net.ReadString(),net.ReadInt(8)
	if !table.HasValue(local_powerup_table,powerup) then table.insert(local_powerup_table,powerup) end
	if !timer.Exists("CLTimerPowerup"..powerup) then
		timer.Create("CLTimerPowerup"..powerup,time,1,function()
			table.RemoveByValue(local_powerup_table,powerup)
		end)
	end
end)


--[[-------------------------------------------------------------------------
Statuses
---------------------------------------------------------------------------]]--
local local_status_table = {}
function CHESTBURSTER_DrawStatuses()
	local margin = 0
	for a, b in pairs(local_status_table) do
		draw.SimpleTextOutlined(b,"DermaLarge",ScrW()/2-250,ScrH()-75-margin,Color(255,155,155,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
		margin = margin + 30
	end
end
net.Receive("CHESTBURSTERSENDSTATUS",function(len)
	local status,time = net.ReadString(),net.ReadInt(8)
	if !table.HasValue(local_status_table,status) then table.insert(local_status_table,status) end
	if !timer.Exists("CLTimerStatus"..status) then
		timer.Create("CLTimerStatus"..status,time,1,function()
			table.RemoveByValue(local_status_table,status)
		end)
	end
end)


--[[-------------------------------------------------------------------------
Blinding
---------------------------------------------------------------------------]]--
function CHESTBURSTER_Blind(time)
	local blind = vgui.Create("DPanel")
	blind:SetPos(0,0)
	blind:SetSize(ScrW(),ScrH())
	blind.Paint = function()
		surface.SetDrawColor(0,0,0,253)
		surface.DrawRect(0,0,ScrW(),ScrH())
	end

	local randwords = {"Blinded!","I can't see!","Who turned out the lights?!"}
	local blindtext = vgui.Create("DLabel",blind)
	blindtext:SetPos(blind:GetWide()/2,blind:GetTall()/2)
	blindtext:SetTextColor(Color(255,55,55,253))
	blindtext:SetFont("DermaLarge")
	blindtext:SetText(table.Random(randwords))
	blindtext:SetContentAlignment(5)
	blindtext:SizeToContents()

	timer.Simple(time,function() blind:Remove() end)
end
net.Receive("CHESTBURSTERBLIND",function(len) local time = net.ReadInt(8) CHESTBURSTER_Blind(time) end)

--[[-------------------------------------------------------------------------
Notifications
---------------------------------------------------------------------------]]--
function RecieveNotification(UM)
    local ttype,text,col
    ttype = UM:ReadString()
    text = UM:ReadString()
    col  = UM:ReadVector()
    local col2 = Color(col.x,col.y,col.z)
    chat.AddText(Color(215,155,115),"["..ttype.."] ",col2,text)
end
usermessage.Hook("CHBU_ChatMsg",RecieveNotification)

local hide={CHudHealth=true,CHudBattery=true,CHudWeaponSelection=true,CHudAmmo=true,CHudSecondaryAmmo=true,CHudDamageIndicator=true}
hook.Add("HUDShouldDraw","HideHUD",function(name)
	if (hide[name]) then return false end
end)