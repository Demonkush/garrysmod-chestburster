--[[-------------------------------------------------------
Traps
-------------------------------------------------------]]--
CHESTBURSTER.Trap = {}
CHESTBURSTER.Trap[1] = {
	name = "Poison Gas",
	doTrap = function(ply,chest)
		if IsValid(chest) then
			chest:DoFX("fx_chbu_poisongas")
			for k, v in pairs(ents.FindInSphere(chest:GetPos(),155)) do
				if IsValid(v) && v:IsPlayer() then
					CHESTBURSTER.Elements[3].onBuff(v,v)
					net.Start("CHESTBURSTERSENDSTATUS")
						net.WriteString("Poisoned")	net.WriteInt(CHESTBURSTER.Elements[3].time,32)
					net.Send(ply)
				end
			end

			timer.Simple(5,function() if chest:IsValid() then chest:Remove() end end)
		end
	end
}
CHESTBURSTER.Trap[2] = {
	name = "Explosion",
	doTrap = function(ply,chest)
		if IsValid(chest) then
			local effectdata = EffectData()
			effectdata:SetOrigin(chest:GetPos())
			util.Effect("Explosion",effectdata,true,true)
			for k, v in pairs(ents.FindInSphere(chest:GetPos(),255)) do
				if v:IsPlayer() then
					CHESTBURSTER_PlayerDamage(45,"Fire",v,v)
				end
			end
			chest:Remove()
		end
	end
}
CHESTBURSTER.Trap[3] = {
	name = "Mimic",
	doTrap = function(ply,chest)
		local mimic = ents.Create("chbu_mimic")
		mimic:SetPos(chest:GetPos()) mimic:SetAngles(chest:GetAngles())
		mimic:Spawn()
		mimic:SetModel(chest:GetModel())
		chest:DoFX("fx_chbu_bloodpuff")
		chest:Remove()
		timer.Create("Mimic"..math.random(1,10000),1,15,function()
			if IsValid(mimic) then
				local phys = mimic:GetPhysicsObject()
				if IsValid(phys) && IsValid(ply) then
					local diff = (ply:GetPos()-mimic:GetPos()) local normal = diff:GetNormal() phys:SetVelocity(normal*550+Vector(0,0,200))
				end
			end
		end)
		timer.Simple(15,function() if IsValid(mimic) then mimic:Remove() end end)
	end
}
CHESTBURSTER.Trap[4] = {
	name = "Blindness",
	doTrap = function(ply,chest)
		if IsValid(chest) then
			ply:Blind(3)
			chest:DoFX("fx_chbu_shadows")
			timer.Simple(3,function() if IsValid(chest) then chest:Remove() end end)
		end
	end
}
CHESTBURSTER.Trap[5] = {
	name = "Freeze",
	doTrap = function(ply,chest)
		if IsValid(chest) then
			ply:Frostbite(3)
			chest:DoFX("fx_chbu_freeze")
			timer.Simple(3,function() if IsValid(chest) then chest:Remove() end end)
		end
	end
}
CHESTBURSTER.Trap[6] = {
	name = "Volcano",
	doTrap = function(ply,chest)
		timer.Create("cb_volcano"..math.random(1,100),1,7,function()
			if IsValid(chest) then
				chest:DoFX("fx_chbu_volcano")
				local fireball = ents.Create("chbu_fireball") fireball:SetPos(chest:GetPos()+Vector(0,0,25))
				fireball:Spawn()
				local phys = fireball:GetPhysicsObject() if IsValid(phys) then phys:SetVelocity((VectorRand()*155)+Vector(0,0,155)) end
			end
		end)
		timer.Simple(8,function() if IsValid(chest) then chest:Remove() end end)
	end
}
CHESTBURSTER.Trap[7] = {
	name = "Swarm",
	doTrap = function(ply,chest)
		for i=1, 3 do
			local swarm = ents.Create("chbu_mimic")
			swarm:SetPos(chest:GetPos()+(VectorRand()*25)) swarm:SetAngles(AngleRand())
			swarm:Spawn()
			swarm:SetModel("models/hunter/blocks/cube05x05x05.mdl")
			chest:DoFX("fx_chbu_bloodpuff")
			chest:Remove()
			timer.Create("Swarm"..math.random(1,10000),1,15,function()
				if IsValid(swarm) then
					local phys = swarm:GetPhysicsObject()
					if IsValid(phys) && IsValid(ply) then
						local diff = (ply:GetPos()-swarm:GetPos()) local normal = diff:GetNormal() phys:SetVelocity(normal*550+Vector(0,0,200))
					end
				end
			end)
			timer.Simple(15,function() if IsValid(swarm) then swarm:Remove() end end)
		end
	end
}