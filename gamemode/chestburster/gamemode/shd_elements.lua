--[[-------------------------------------------------------
Elements
-------------------------------------------------------]]--
CHESTBURSTER.Elements = {}
CHESTBURSTER.Elements[1] = {
	name = "Fire",status = "Burning",
	buffChance = 35,
	color = Color(255,175,155,255),
	time = 3,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusFire"..target:EntIndex()) then return end
		timer.Create("CB_StatusFire"..target:EntIndex(),1,3,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusFire",true)
				local damp = 0 if target:GetNWBool("StatusWater") == true then damp = 7 end
				local drychance = math.random(1,100) 
				if drychance > 75 then CHESTBURSTER.Elements[5].ClearStatus(target) end
				target:EmitSound("player/pl_burnpain"..math.random(1,3)..".wav",100,75)

				CHESTBURSTER_PlayerDamage(math.random(13,15)-damp,"Fire",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_cb_firepuff", fx )
			else target:SetNWBool("StatusFire",false) timer.Remove("CB_StatusFire"..target) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			local damp = 0 if target:GetNWBool("StatusWater") == true then damp = 7 end

			CHESTBURSTER_PlayerDamage(math.random(10,12)-damp,"Fire",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_cb_firepuff", fx )
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Fire") wep.ImpactEffect = "fx_chbu_firepuff"
			net.Start("CHESTBURSTERWEAPONINFO") net.WriteString("Flaming") net.Send(ply)
		end
	end,
	ClearStatus = function(ply)
		if IsValid(ply) then
			ply:SetNWBool("StatusFire",false)
			if timer.Exists("CB_StatusFire"..ply:EntIndex()) then timer.Remove("CB_StatusFire"..ply:EntIndex()) end
		end
	end
}
CHESTBURSTER.Elements[2] = {
	name = "Frost",status = "Freezing",
	buffChance = 65,
	color = Color(175,215,255,255),
	time = 5,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusFrost"..target:EntIndex()) then return end
		timer.Create("CB_StatusFrost"..target:EntIndex(),1,5,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusFrost",true)
				local slowchance = math.random(1,100) if slowchance > 65 then target:Slow(7) end
				target:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav",100,95)
				if target:GetNWBool("StatusWater") == true then
					local freezechance = math.random(1,100) if freezechance > 75 then CHESTBURSTER.Elements[5].ClearStatus(target) target:Frostbite(5) end
				end

				CHESTBURSTER_PlayerDamage(math.random(4,5),"Frost",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_cb_frostpuff", fx )
			else target:SetNWBool("StatusFrost",false) timer.Remove("CB_StatusFrost"..target) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			if target:GetNWBool("StatusWater") == true then
				local freezechance = math.random(1,100) if freezechance > 75 then target:Frostbite(3) end
			end
			CHESTBURSTER_PlayerDamage(math.random(2,3),"Frost",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_cb_frostpuff", fx )
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Frost") wep.ImpactEffect = "fx_chbu_frostpuff"
			net.Start("CHESTBURSTERWEAPONINFO") net.WriteString("Freezing") net.Send(ply)
		end
	end,
	ClearStatus = function(ply)
		if IsValid(ply) then
			ply:SetNWBool("StatusFrost",false)
			if timer.Exists("CB_StatusFrost"..ply:EntIndex()) then timer.Remove("CB_StatusFrost"..ply:EntIndex()) end
		end
	end
}
CHESTBURSTER.Elements[3] = {
	name = "Poison",status = "Poisoned",
	buffChance = 50,
	color = Color(185,255,155,255),
	time = 12,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusPoison"..target:EntIndex()) then return end
		timer.Create("CB_StatusPoison"..target:EntIndex(),2,6,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusPoison",true)
				target:EmitSound("ambient/voices/cough"..math.random(1,4)..".wav")

				CHESTBURSTER_PlayerDamage(math.random(6,9),"Poison",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_cb_poisonpuff", fx )
			else target:SetNWBool("StatusPoison",false) timer.Remove("CB_StatusPoison"..target) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			CHESTBURSTER_PlayerDamage(math.random(4,7),"Poison",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_cb_poisonpuff", fx )
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Poison") wep.ImpactEffect = "fx_chbu_poisonpuff"
			net.Start("CHESTBURSTERWEAPONINFO") net.WriteString("Venom") net.Send(ply)
		end
	end,
	ClearStatus = function(ply)
		if IsValid(ply) then
			ply:SetNWBool("StatusPoison",false)
			if timer.Exists("CB_StatusPoison"..ply:EntIndex()) then timer.Remove("CB_StatusPoison"..ply:EntIndex()) end
		end
	end
}
CHESTBURSTER.Elements[4] = {
	name = "Storm",status = "Electrified",
	buffChance = 50,
	color = Color(125,215,255,255),
	time = 2,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusStorm"..target:EntIndex()) then return end
		timer.Create("CB_StatusStorm"..target:EntIndex(),3,1,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusStorm",true)
				target:SetEyeAngles(Angle(0,math.random(0,360),0))
				local rvel = VectorRand()*50 target:SetVelocity(rvel)
				target:EmitSound("ambient/machines/zap"..math.random(1,3)..".wav",100,100)

				CHESTBURSTER_PlayerDamage(math.random(7,11),"Storm",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_cb_stormpuff", fx )
			else target:SetNWBool("StatusStorm",false) timer.Remove("CB_StatusStorm"..target) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			CHESTBURSTER_PlayerDamage(math.random(5,8),"Storm",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_cb_stormpuff", fx )
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Storm") wep.ImpactEffect = "fx_chbu_stormpuff"
			net.Start("CHESTBURSTERWEAPONINFO") net.WriteString("Lightning") net.Send(ply)
		end
	end,
	ClearStatus = function(ply)
		if IsValid(ply) then
			ply:SetNWBool("StatusStorm",false)
			if timer.Exists("CB_StatusStorm"..ply:EntIndex()) then timer.Remove("CB_StatusStorm"..ply:EntIndex()) end
		end
	end
}
CHESTBURSTER.Elements[5] = {
	name = "Water",status = "Soaked",
	buffChance = 50,
	color = Color(155,155,255,255),
	time = 9,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusWater"..target:EntIndex()) then return end
		timer.Create("CB_StatusWater"..target:EntIndex(),9,1,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusWater",true)
				target:EmitSound("ambient/water/drip"..math.random(1,4)..".wav",100,50)

				CHESTBURSTER_PlayerDamage(math.random(4,5),"Water",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_cb_waterpuff", fx )
			else target:SetNWBool("StatusWater",false) timer.Remove("CB_StatusWater"..target) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			CHESTBURSTER_PlayerDamage(math.random(3,4),"Water",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_cb_waterpuff", fx )
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Water") wep.ImpactEffect = "fx_chbu_waterpuff"
			net.Start("CHESTBURSTERWEAPONINFO") net.WriteString("Soaking") net.Send(ply)
		end
	end,
	ClearStatus = function(ply)
		if IsValid(ply) then
			ply:SetNWBool("StatusWater",false)
			if timer.Exists("CB_StatusWater"..ply:EntIndex()) then timer.Remove("CB_StatusWater"..ply:EntIndex()) end
		end
	end
}