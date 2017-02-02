--[[-------------------------------------------------------
Elements
-------------------------------------------------------]]--
CHESTBURSTER.Elements = {}
CHESTBURSTER.Elements[1] = {
	name = "Fire",status = "Burning",
	buffChance = 85,
	color = Color(255,175,155,255),
	time = 4,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusFire"..target:EntIndex()) then return end
		timer.Create("CB_StatusFire"..target:EntIndex(),1,4,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusFire",true)
				local damp = 0 if target:GetNWBool("StatusWater") == true then damp = 7 end
				local drychance = math.random(1,100) 
				if drychance > 75 then CHESTBURSTER.Elements[5].ClearStatus(target) end
				target:EmitSound("player/pl_burnpain"..math.random(1,3)..".wav",100,75)

				CHESTBURSTER_PlayerDamage(math.random(13,15)-damp,"Fire",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_chbu_firepuff", fx ,true,true)

				net.Start("CHESTBURSTERSENDSTATUS")
					net.WriteString("Burning")	net.WriteInt(4,32)
				net.Send(target)
			else target:SetNWBool("StatusFire",false) timer.Remove("CB_StatusFire"..target:EntIndex()) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			local damp = 0 if target:GetNWBool("StatusWater") == true then damp = 7 end
			local drychance = math.random(1,100) 
			if drychance > 75 then CHESTBURSTER.Elements[5].ClearStatus(target) end

			CHESTBURSTER_PlayerDamage(math.random(10,12)-damp,"Fire",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_chbu_firepuff", fx ,true,true)
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Fire") wep:SetImpactEffect("fx_chbu_firepuff")
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
	buffChance = 85,
	color = Color(175,215,255,255),
	time = 8,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusFrost"..target:EntIndex()) then return end
		timer.Create("CB_StatusFrost"..target:EntIndex(),2,4,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusFrost",true)
				local slowchance = math.random(1,100) if slowchance > 65 then target:Slow(7) end
				target:EmitSound("physics/glass/glass_strain"..math.random(1,4)..".wav",100,95)
				if target:GetNWBool("StatusWater") == true then
					local freezechance = math.random(1,100) if freezechance > 75 then CHESTBURSTER.Elements[5].ClearStatus(target) target:Frostbite(5) end
				end

				CHESTBURSTER_PlayerDamage(math.random(4,5),"Frost",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_chbu_frostpuff", fx ,true,true)

				net.Start("CHESTBURSTERSENDSTATUS")
					net.WriteString("Freezing")	net.WriteInt(8,32)
				net.Send(target)
			else target:SetNWBool("StatusFrost",false) timer.Remove("CB_StatusFrost"..target:EntIndex()) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			if target:GetNWBool("StatusWater") == true then
				local freezechance = math.random(1,100) if freezechance > 75 then target:Frostbite(3) end
			end
			CHESTBURSTER_PlayerDamage(math.random(2,3),"Frost",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_chbu_frostpuff", fx ,true,true)
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Frost") wep:SetImpactEffect("fx_chbu_frostpuff")
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
	buffChance = 65,
	color = Color(185,255,155,255),
	time = 12,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusPoison"..target:EntIndex()) then return end
		timer.Create("CB_StatusPoison"..target:EntIndex(),2,6,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusPoison",true)
				target:EmitSound("ambient/voices/cough"..math.random(1,4)..".wav")

				CHESTBURSTER_PlayerDamage(math.random(6,9),"Poison",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) ) fx:SetScale(1)
				util.Effect( "fx_chbu_poisonpuff", fx ,true,true)

				net.Start("CHESTBURSTERSENDSTATUS")
					net.WriteString("Poisoned")	net.WriteInt(12,32)
				net.Send(target)
			else target:SetNWBool("StatusPoison",false) timer.Remove("CB_StatusPoison"..target:EntIndex()) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			CHESTBURSTER_PlayerDamage(math.random(4,7),"Poison",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_chbu_poisonpuff", fx ,true,true)
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Poison") wep:SetImpactEffect("fx_chbu_poisonpuff")
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
	buffChance = 75,
	color = Color(125,215,255,255),
	time = 6,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusStorm"..target:EntIndex()) then return end
		timer.Create("CB_StatusStorm"..target:EntIndex(),3,2,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusStorm",true)
				local rvel = VectorRand()*255 target:SetVelocity(rvel+Vector(0,0,200))
				target:EmitSound("ambient/machines/zap"..math.random(1,3)..".wav",100,100)
				local add = 1 if target:GetNWBool("StatusWater") == true then add = 2 end

				CHESTBURSTER_PlayerDamage(math.random(7,11)*add,"Storm",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_chbu_stormpuff", fx ,true,true)

				net.Start("CHESTBURSTERSENDSTATUS")
					net.WriteString("Electrified")	net.WriteInt(6,32)
				net.Send(target)
			else target:SetNWBool("StatusStorm",false) timer.Remove("CB_StatusStorm"..target:EntIndex()) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			local rvel = VectorRand()*355 target:SetVelocity(rvel+Vector(0,0,200))
			local add = 1 if target:GetNWBool("StatusWater") == true then add = 2 end
			CHESTBURSTER_PlayerDamage(math.random(5,8)*add,"Storm",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_chbu_stormpuff", fx ,true,true)
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Storm") wep:SetImpactEffect("fx_chbu_stormpuff")
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
	buffChance = 95,
	color = Color(155,155,255,255),
	time = 10,
	onBuff = function(target,attacker)
		if timer.Exists("CB_StatusWater"..target:EntIndex()) then return end
		timer.Create("CB_StatusWater"..target:EntIndex(),5,2,function()
			if IsValid(target) && target:Alive() then
				target:SetNWBool("StatusWater",true)
				target:EmitSound("ambient/water/drip"..math.random(1,4)..".wav",100,50)

				CHESTBURSTER_PlayerDamage(math.random(4,5),"Water",target,attacker)
				local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
				util.Effect( "fx_chbu_waterpuff", fx ,true,true)

				net.Start("CHESTBURSTERSENDSTATUS")
					net.WriteString("Soaking")	net.WriteInt(10,32)
				net.Send(target)
			else target:SetNWBool("StatusWater",false) timer.Remove("CB_StatusWater"..target:EntIndex()) end
		end)
	end,
	onDamage = function(target,attacker)
		if IsValid(target) && target:Alive() then
			CHESTBURSTER_PlayerDamage(math.random(3,4),"Water",target,attacker)
			local fx = EffectData() fx:SetOrigin( target:GetPos() + Vector(0,0,32) )
			util.Effect( "fx_chbu_waterpuff", fx ,true,true)
		end
	end,
	ImbueWeapon = function(ply,wep)
		if IsValid(wep) then
			wep:SetElement("Water") wep:SetImpactEffect("fx_chbu_waterpuff")
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

function CHESTBURSTER.AddElementTable(tab)
	table.Add(CHESTBURSTER.Elements,tab)
end