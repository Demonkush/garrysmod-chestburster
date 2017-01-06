--[[-------------------------------------------------------
Traps
-------------------------------------------------------]]--
CHESTBURSTER.Trap = {}
CHESTBURSTER.Trap[1] = {
	name = "Poison Gas",
	doTrap = function(ply,chest)
		if IsValid(chest) then
			chest:EmitSound("ambient/wind/wind_hit1.wav")
			chest:DoFX("fx_chbu_poisongas")
			for k, v in pairs(ents.FindInSphere(chest:GetPos(),225)) do
				if IsValid(v) && v:IsPlayer() then
					CHESTBURSTER.Elements[3].onBuff(v,chest)
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
					CHESTBURSTER_PlayerDamage(45,"Fire",v,chest)
				end
			end
			chest:Remove()
		end
	end
}
CHESTBURSTER.Trap[3] = {
	name = "Mimic",
	doTrap = function(ply,chest)
		ply:EmitSound("npc/strider/striderx_alert4.wav")
		local mimic = ents.Create("chbu_mimic")
		mimic:SetPos(chest:GetPos()) mimic:SetAngles(chest:GetAngles())
		mimic:Spawn()
		mimic:SetModel(chest:GetModel())
		mimic:SetColor(Color(255,55,55,255))
		chest:DoFX("fx_chbu_bloodpuff")
		chest:Remove()
		timer.Create("Mimic"..math.random(1,10000),1,15,function()
			if IsValid(mimic) then
				mimic:EmitSound("npc/zombie_poison/pz_warn1.wav",85,math.random(100,125))
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
			ply:EmitSound("vo/npc/male01/ohno.wav")
			ply:Blind(6)
			chest:DoFX("fx_chbu_shadows")
			timer.Simple(3,function() if IsValid(chest) then chest:Remove() end end)
		end
	end
}
CHESTBURSTER.Trap[5] = {
	name = "Freeze",
	doTrap = function(ply,chest)
		if IsValid(chest) then
			ply:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav",100,95)
			ply:Frostbite(3)
			chest:DoFX("fx_chbu_freeze")
			timer.Simple(3,function() if IsValid(chest) then chest:Remove() end end)
		end
	end
}
CHESTBURSTER.Trap[6] = {
	name = "Volcano",
	doTrap = function(ply,chest)
		timer.Create("cb_volcano"..math.random(1,10000),1,7,function()
			if IsValid(chest) then
				chest:EmitSound("weapons/underwater_explode4.wav",85,125)
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
		ply:EmitSound("vo/npc/male01/hacks01.wav")
		for i=1, 3 do
			local swarm = ents.Create("chbu_mimic")
			swarm:SetPos(chest:GetPos()+Vector(0,0,64)+(VectorRand()*25)) swarm:SetAngles(AngleRand())
			swarm:Spawn()
			swarm:SetModel("models/hunter/blocks/cube05x05x05.mdl")
			swarm:SetColor(Color(255,55,55,255))
			swarm.Damage = 7
			swarm.HP = 10
			chest:DoFX("fx_chbu_bloodpuff")
			chest:Remove()
			timer.Create("Swarm"..math.random(1,10000),1.5,10,function()
				if IsValid(swarm) then
					swarm:EmitSound("npc/fast_zombie/wake1.wav",85,math.random(100,125))
					local phys = swarm:GetPhysicsObject()
					if IsValid(phys) && IsValid(ply) then
						local diff = (ply:GetPos()-swarm:GetPos()) local normal = diff:GetNormal() phys:SetVelocity(normal*550+Vector(0,0,200))
					end
				end
			end)
			timer.Simple(10,function() if IsValid(swarm) then swarm:Remove() end end)
		end
	end
}