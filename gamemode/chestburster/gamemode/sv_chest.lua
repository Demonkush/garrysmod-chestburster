function CHESTBURSTER.OpenChest(ply,chest)
	if !IsValid(chest) then return end
	if CHESTBURSTER.RoundState == 3 then return end
	--CHESTBURSTER.RespawnChest(chest:GetPos(),chest:GetAngles())

	chest.Opened = true

	chest:EmitSound("plats/hall_elev_door.wav",85,85)

	local r = math.random(1,100)
	local gr,gd = CHESTBURSTER.GoldRating, math.random(CHESTBURSTER.GoldDiff*-1,CHESTBURSTER.GoldDiff) 
	gr = gr + gd
	if chest:GetRare() != true then
		if r <= CHESTBURSTER.TrapChestChance then
			CHESTBURSTER_Message(ply, "Chest", "It was a trap!", Vector(215,155,155), false)
			chest:EmitSound(table.Random(CHESTBURSTER.TrapSounds),100,100)
			local ab = math.random(1,#CHESTBURSTER.Trap)
			for a, b in pairs(CHESTBURSTER.Trap) do if ab == a then b.doTrap(ply,chest) end end
			return
		end
	else 
		CHESTBURSTER_Message(ply, "Chest", "Lucky! It was a rare chest!", Vector(255,215,155), false)
		gr = gr * CHESTBURSTER.RareGoldRating 
	end

	if chest:GetTrap() == true then
		CHESTBURSTER_Message(ply, "Chest", "It was a trap!", Vector(215,155,155), false)
		chest:EmitSound(table.Random(CHESTBURSTER.TrapSounds),100,100)
		local ab = math.random(1,#CHESTBURSTER.Trap)
		for a, b in pairs(CHESTBURSTER.Trap) do if ab == a then b.doTrap(ply,chest) end end
		return
	end

	chest:EmitSound(table.Random(CHESTBURSTER.ChestSounds),100,100)

	if ply.AssignedWeapon == nil then
		if r <= CHESTBURSTER.WeaponChance then
			local awr = math.random(1,#CHESTBURSTER.Weapons) CHESTBURSTER.GiveWeapon(ply,awr)
		end
	end
	timer.Simple(1,function()
		if IsValid(ply) then
			if r <= CHESTBURSTER.PowerupChance then
				local abr = math.random(1,#CHESTBURSTER.Powerups) CHESTBURSTER.GivePowerup(ply,abr)
			end
		end
	end)

	CHESTBURSTER.CollectGold(ply,gr)
	ply:PrintMessage(HUD_PRINTTALK,"Received "..gr.." gold!")
	timer.Simple(1,function() if IsValid(chest) then chest:Remove() end end)
end
--[[
function CHESTBURSTER.RespawnChest(pos,ang)
	local chest = ents.Create("chbu_chest")
	chest:SetPos(pos)
	chest:SetAngles(ang)
	chest:Spawn()

	local fx = EffectData() fx:SetOrigin(pos)
	util.Effect("fx_chbu_chestspawn",fx)
end]]

function CHESTBURSTER.SpawnChest()
	if CHESTBURSTER.RoundState == 3 then return end
	if CHESTBURSTER.MapConfigLoaded == false then print("[CHESTBURSTER] No map config found!") return end
	if CHESTBURSTER.ChestSpawnTable then
		local r = math.random(1,#CHESTBURSTER.ChestSpawnTable)
		for k, v in pairs(CHESTBURSTER.ChestSpawnTable) do
			if k == r then
				local chest = ents.Create("chbu_chest")
				chest:SetPos(v)
				chest:Spawn()
				CHESTBURSTER.CheckSpawnPlace(chest)

				local fx = EffectData() fx:SetOrigin(chest:GetPos())
				util.Effect("fx_chbu_chestspawn",fx)
			end
		end
	end
end

function CHESTBURSTER.CheckSpawnPlace(chest)
	timer.Simple(0.5,function()
		if IsValid(chest) then
			for a, b in pairs(ents.FindInSphere(chest:GetPos(),100)) do
				if b != chest then
					if b:GetClass() == "chbu_chest" then b:Remove() end
				end
			end
		end
	end)
end