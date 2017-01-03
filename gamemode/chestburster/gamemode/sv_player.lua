function CHESTBURSTER.PlayerReset(ply)
	ply:StripWeapons()
	ply:SetNWBool("Spectating",false)
	ply:SetNWBool("SpawnNextRound",true)

	ply.AssignedWeapon = nil
	ply.NextTaunt = 0

	ply:SetNWBool("KnockedOut",false)
	ply:SetNWBool("KOImmunity",false)
	ply:SetNWInt("KO",0)
	ply:SetNWInt("KOMax",CHESTBURSTER.KOMax)	-- Total amount of KO power before you are KO'd, can be amplified with powerups.

	ply:SetNWInt("TotalKO",0) 		-- KO's against other players
	ply:SetNWInt("SelfKO",0) 		-- KO's against yourself
	ply:SetNWInt("Gold",0)			-- Total Gold collected

	ply.BaseWalkSpeed 	= 215
	ply.BaseRunSpeed 	= 355
	ply.BaseCrouchSpeed = 155

	ply:SetWalkSpeed(ply.BaseWalkSpeed)
	ply:SetRunSpeed(ply.BaseRunSpeed)
	ply:SetCrouchedWalkSpeed(ply.BaseCrouchSpeed)


	ply:SetNWInt("DamageMultiplier",1)
	ply:SetNWInt("DamageResistance",0)

	-- Fire: Powerful but short DoT
	-- Frost: Slowing / Freezing
	-- Poison: Weak but long DoT
	-- Storm: Disorientating
	-- Water: Amplifier / Dampener ( If wet, storm attacks are stronger but fire attacks are weaker )

	ply:SetNWBool("ImbueFire",false)
	ply:SetNWBool("ImbueFrost",false)
	ply:SetNWBool("ImbuePoison",false)
	ply:SetNWBool("ImbueStorm",false)
	ply:SetNWBool("ImbueWater",false)

	ply:SetModel(table.Random(CHESTBURSTER.Playermodels))

	ply:Give(CHESTBURSTER.FistWeapon)

	CHESTBURSTER.ClearElementalStatus(ply)
end

function GM:PlayerInitialSpawn(ply) CHESTBURSTER.PlayerReset(ply) end
function GM:PlayerSpawn(ply) CHESTBURSTER.PlayerReset(ply) end
function GM:PlayerDeath(victim,inflictor,attacker) end
function GM:DoPlayerDeath() end
function GM:GetFallDamage( ply, speed ) return 0 end

function CHESTBURSTER.CollectGold(ply,gold)
	ply:EmitSound("ambient/levels/labs/coinslot1.wav")
	ply:SetNWInt("Gold",ply:GetNWInt("Gold")+gold)
	if ply:GetNWInt("Gold") >= CHESTBURSTER.MaxGold then
		CHESTBURSTER.RoundEnd()
	end
end

function CHESTBURSTER.DropGold(ply,gold)
	if ply:GetNWInt("Gold")-gold <= 50 then return end
	ply:PrintMessage(HUD_PRINTTALK,"You dropped "..gold.." gold!")
	ply:SetNWInt("Gold",ply:GetNWInt("Gold")-gold)
	for i=1,5 do
		local golddrop = ents.Create("chbu_gold")
		golddrop:SetPos(ply:GetPos()+Vector(0,0,64))
		golddrop:Spawn()
		golddrop.GoldAmount = math.Round(gold*0.2)

		local phys = golddrop:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(VectorRand()*600+Vector(0,0,150))
		end
	end
end

function CHESTBURSTER.ImbueWeapon(ply,element)
	local wep = ply:GetActiveWeapon()
	if !IsValid(wep) then return end
	if wep:GetClass() != CHESTBURSTER.FistWeapon then
		for a, b in pairs(CHESTBURSTER.Elements) do
			if element == b.name then b.ImbueWeapon(ply,wep) end
		end
	end
end

function CHESTBURSTER.GiveWeapon(ply,a)
	if ply.AssignedWeapon == nil then
		ply:StripWeapons()
		ply:Give(CHESTBURSTER.Weapons[a].wep)
		ply.AssignedWeapon = CHESTBURSTER.Weapons[a].wep
		CHESTBURSTER_Message(target, "Weapon", "Received the "..CHESTBURSTER.Weapons[a].name.."!", Vector(155,255,155), false)
		ply:EmitSound("items/ammo_pickup.wav")
	end
end

function CHESTBURSTER.DropWeapon(ply)
	if ply.AssignedWeapon == nil then return end
	if !IsValid(ply:GetActiveWeapon()) then return end
	ply:DropWeapon(ply:GetActiveWeapon())
	ply.AssignedWeapon = nil
	ply:StripWeapons()
	ply:Give(CHESTBURSTER.FistWeapon)
	ply:EmitSound("weapons/physcannon/physcannon_drop.wav")
end

function GM:PlayerCanPickupWeapon(ply,wep)
	if ply:GetNWBool("KnockedOut") == true then return false end
	if IsValid(ply:GetActiveWeapon()) then 
		if ply:GetActiveWeapon():GetClass() == CHESTBURSTER.FistWeapon then 
			ply:StripWeapon(CHESTBURSTER.FistWeapon) return true 
		end
	end
	if ply.AssignedWeapon != nil then if ply.AssignedWeapon == wep then ply:StripWeapon(CHESTBURSTER.FistWeapon) return true end end
	return false
end

function CHESTBURSTER.GivePowerup(ply,powerup)
	CHESTBURSTER.Powerups[powerup].onPickup(ply)

	local fx = EffectData() fx:SetOrigin( ply:GetPos() + Vector(0,0,32) )
	util.Effect( "fx_cb_powerup", fx )
	ply:EmitSound("npc/scanner/cbot_energyexplosion1.wav",100,85)
	CHESTBURSTER_Message(target, "Powerup", CHESTBURSTER.Powerups[powerup].name.." activated! "..CHESTBURSTER.Powerups[powerup].desc, Vector(155,255,155), false)

	timer.Simple(CHESTBURSTER.Powerups[powerup].time,function()
		CHESTBURSTER.Powerups[powerup].onExpire(ply)
	end)

	net.Start("CHESTBURSTERSENDPOWERUP")
		net.WriteString(CHESTBURSTER.Powerups[powerup].name)
		net.WriteInt(CHESTBURSTER.Powerups[powerup].time,32)
	net.Send(ply)
end

function CHESTBURSTER.MovetoSpec(ply)
	if ply:GetNWBool("Spectating") == true then return end
	ply:SetNWBool("Spectating",true)
	ply:SetNWBool("SpawnNextRound",false)

	ply:Spectate()
end
function CHESTBURSTER.MovefromSpec(ply)
	if ply:GetNWBool("Spectating") == false then return end
	ply:SetNWBool("SpawnNextRound",true)
end

function CHESTBURSTER.ClearElementalStatus(ply)
	for a, b in pairs(CHESTBURSTER.Elements) do
		b.ClearStatus()
	end
end

function CHESTBURSTER.ApplyElementalDamage(element,target,attacker)
	if target:GetNWBool("KnockedOut") == true then return end
	if target:GetNWBool("KOImmunity") == true then return end
	for a, b in pairs(CHESTBURSTER.Elements) do
		if element == b.name then
			b.onDamage(target,attacker)
			local r = math.random(1,100)
			if r <= b.buffChance then b.onBuff(target,attacker) end
		end
	end
end

function CHESTBURSTER.HandleElements(etype,element,target)
	if etype == 1 then
		local resist = false
		if element == "Fire" 	&& target:GetNWBool("ImbueFire") 	== true then resist = true end
		if element == "Frost" 	&& target:GetNWBool("ImbueFrost") 	== true then resist = true end
		if element == "Poison" 	&& target:GetNWBool("ImbuePoison") 	== true then resist = true end
		if element == "Storm" 	&& target:GetNWBool("ImbueStorm") 	== true then resist = true end
		if element == "Water" 	&& target:GetNWBool("ImbueWater") 	== true then resist = true end
		return resist
	else
		local element2
		if target:GetNWBool("ImbueFire") 	then element2 = "Fire" end 
		if target:GetNWBool("ImbueFrost") 	then element2 = "Frost" end 
		if target:GetNWBool("ImbuePoison") 	then element2 = "Poison" end 
		if target:GetNWBool("ImbueStorm") 	then element2 = "Storm" end 
		if target:GetNWBool("ImbueWater") 	then element2 = "Water" end 
		return element2
	end
end

function CHESTBURSTER.ElementalDamage(element,target,attacker)
	if target == attacker then return end
	local r = math.random(1,100)
	for a, b in pairs(CHESTBURSTER.Elements) do
		if b.name == element then
			if r >= b.buffChance then
				b.onBuff(target,attacker)
				net.Start("CHESTBURSTERSENDSTATUS")
					net.WriteString(b.status)
					net.WriteInt(b.time,32)
				net.Send(target)
			end
		end
	end
end

function GM:EntityTakeDamage(target,dmginfo)
	local attacker = dmginfo:GetAttacker()
	if !target:IsPlayer() then return end
	if !dmginfo:GetAttacker():IsPlayer() then return end
	if attacker:GetActiveWeapon():GetClass() == CHESTBURSTER.FistWeapon then
		CHESTBURSTER_PlayerDamage(CHESTBURSTER.FistDamage,"Physical",target,dmginfo:GetAttacker())
		local diff = target:GetPos()-attacker:GetPos()
		target:SetVelocity((diff*CHESTBURSTER.FistPower)+Vector(0,0,0.5*CHESTBURSTER.FistPower))
	end
	return true
end
function GM:ScalePlayerDamage(ply,hitgroup,dmginfo) end

function CHESTBURSTER_PlayerDamage(damage,element,target,attacker)
	if CHESTBURSTER.RoundState == 3 then return end
	if !target:IsPlayer() then return end if !attacker:IsPlayer() then return end
	if target:GetNWBool("KOImmunity") == true then return end
	if element == nil then element = "Physical" end
	target:EmitSound(table.Random(CHESTBURSTER.HurtSounds),100,100)

	damage = damage + attacker:GetNWInt("DamageMultiplier")
	damage = damage - target:GetNWInt("DamageResistance")

	if CHESTBURSTER.HandleElements(1,element,target) == true then -- Handle elemental resistance
		damage = math.Round(damage/1.5)
	end
	element = CHESTBURSTER.HandleElements(2,element,target) -- Handle elemental imbue damage
	CHESTBURSTER.ElementalDamage(element,target,attacker)

	target:ChangeKO(damage,"+")

	if target:IsPlayer() && target:GetNWBool("KnockedOut") == false then
		if target:GetNWInt("KO") >= target:GetNWInt("KOMax") then
			if attacker == target then
				CHESTBURSTER_Message(target, "Damage", attacker:Name().." was knocked out!", Vector(255,155,155), true)
			end
			if attacker:IsPlayer() && attacker != target then 
				attacker:SetNWInt("TotalKO",attacker:GetNWInt("TotalKO")+1) 
				CHESTBURSTER_Message(target, "Damage", attacker:Name().." knocked out "..target:Name().."!", Vector(255,155,155), true)
			end
			target:SetNWInt("SelfKO",target:GetNWInt("SelfKO")+1)
			target:KnockOut()
		end
	end
end

local player = FindMetaTable("Player")
function player:KnockOut()
	if self:GetNWBool("KnockedOut") == true then return end
	CHESTBURSTER_Message(self, "Damage", "You've been KO'd! Will recover in "..CHESTBURSTER.KOTime.." seconds!", Vector(255,155,155), false)
	self:Freeze(true) self:SetNWBool("KnockedOut",true)
	CHESTBURSTER.DropWeapon(self)

	local fx = EffectData() fx:SetOrigin(self:GetPos())
	util.Effect("fx_chbu_ko",fx)

	self:EmitSound(table.Random(CHESTBURSTER.KOSounds),100,80)
	self:ClearMovementEffects()
	CHESTBURSTER.ClearElementalStatus(self)

	local gold = math.Round( self:GetNWInt("Gold") / CHESTBURSTER.GoldDropFraction )
	CHESTBURSTER.DropGold(self,gold)

	timer.Simple(CHESTBURSTER.KOTime,function()
		if IsValid(self) then self:Recover() end
	end)
end

function player:ChangeKO(n,mode)
	if self:GetNWBool("KnockedOut") == true then return end
	local amt,cur,max = n,self:GetNWInt("KO"),self:GetNWInt("KOMax")
	if mode == "+" then
		if cur+n <= 0 then amt = 0 end if cur+n >= max then amt = max end
		self:SetNWInt("KO",cur+amt)
	elseif mode == "-" then
		if cur-n <= 0 then self:SetNWInt("KO",0) return end 
		if cur-n >= max then self:SetNWInt("KO",max) return end
		if cur-n > 0 && cur-n < max then self:SetNWInt("KO",cur-amt) end
	end
end

function player:Recover()
	self:Freeze(false)
	self:SetNWBool("KnockedOut",false) self:SetNWBool("KOImmunity",true)
	self:SetNWInt("KO",0)
	CHESTBURSTER_Message(self, "Damage", "Recovered from KO! Immune to KOs for "..CHESTBURSTER.KORecoveryTime.." seconds!", Vector(155,155,255), false)
	self:EmitSound(table.Random(CHESTBURSTER.RecoverSounds),100,100)

	local fx = EffectData() fx:SetOrigin(self:GetPos())
	util.Effect("fx_chbu_recovery",fx)

	timer.Simple(CHESTBURSTER.KORecoveryTime,function()
		if IsValid(self) then
			self:SetNWBool("KOImmunity",false)
			CHESTBURSTER_Message(self, "Damage", "Recovery lost!", Vector(115,185,255), false)
		end
	end)
end

function player:Frostbite(time)
	local fx = EffectData() fx:SetOrigin(self:GetPos())
	util.Effect("fx_chbu_freeze",fx)
	self:Freeze(true)
	timer.Create("chbu_frostbite"..self:EntIndex(),time,1,function()
		if IsValid(self) then self:Freeze(false) end
	end)
	net.Start("CHESTBURSTERSENDSTATUS")
		net.WriteString("Frostbite") net.WriteInt(time,32)
	net.Send(self)
end

function player:Slow(time)
	local fx = EffectData() fx:SetOrigin(self:GetPos())
	util.Effect("fx_chbu_slowed",fx)
	self:SetWalkSpeed(self.BaseWalkSpeed/CHESTBURSTER.SlowRating) self:SetRunSpeed(self.BaseRunSpeed/CHESTBURSTER.SlowRating) self:SetCrouchedWalkSpeed(self.BaseCrouchSpeed/CHESTBURSTER.SlowRating)
	timer.Create("chbu_slow"..self:EntIndex(),time,1,function()
		self:ResetMovementSpeed()
	end)
	net.Start("CHESTBURSTERSENDSTATUS")
		net.WriteString("Slowed") net.WriteInt(time,32)
	net.Send(self)
end

function player:Haste(time)
	local fx = EffectData() fx:SetOrigin(self:GetPos())
	util.Effect("fx_chbu_haste",fx)
	self:SetWalkSpeed(self.BaseWalkSpeed*CHESTBURSTER.HasteRating) self:SetRunSpeed(self.BaseRunSpeed*CHESTBURSTER.HasteRating) self:SetCrouchedWalkSpeed(self.BaseCrouchSpeed*CHESTBURSTER.HasteRating)
	timer.Create("chbu_haste"..self:EntIndex(),time,1,function()
		self:ResetMovementSpeed()
	end)
end

function player:ClearMovementEffects()
	if timer.Exists("chbu_frostbite"..self:EntIndex()) then timer.Remove("chbu_frostbite"..self:EntIndex()) if IsValid(self) then self:Freeze(false) end end
	if timer.Exists("chbu_slow"..self:EntIndex()) then timer.Remove("chbu_slow"..self:EntIndex()) self:ResetMovementSpeed() end
	if timer.Exists("chbu_haste"..self:EntIndex()) then timer.Remove("chbu_haste"..self:EntIndex()) self:ResetMovementSpeed() end
end

function player:ResetMovementSpeed()
	self:SetWalkSpeed(self.BaseWalkSpeed) self:SetRunSpeed(self.BaseRunSpeed) self:SetCrouchedWalkSpeed(self.BaseCrouchSpeed)
end

function player:Taunt()
	local pitch = 135
	if self.NextTaunt < CurTime() then
		if self:GetNWInt("KO") < (self:GetNWInt("KOMax")/2) then pitch = 95 end
		self:EmitSound(table.Random(CHESTBURSTER.Taunts),100,pitch)	
		self.NextTaunt = CurTime() + 6
	end
end

function player:Blind(time)
	local fx = EffectData() fx:SetOrigin(self:GetPos())
	util.Effect("fx_chbu_blinded",fx)
	net.Start("CHESTBURSTERBLIND") net.WriteInt(time,8) net.Send(self)
end

function player:Detection(time)
	net.Start("CHESTBURSTERDETECTION") net.WriteInt(time,8) net.Send(self)
end

function player:Climb()
	if self:GetEyeTrace().HitWorld == true then
		local length = (self:GetEyeTrace().HitPos-self:GetPos()):Length()
		if length < 100 && length > 70 then
			if self:OnGround() then
				self:SetPos(self:GetPos()+Vector(0,0,1))
				self:SetVelocity(Vector(0,0,275))
			else
				self:SetVelocity(Vector(0,0,175))
			end
		end
	end
end

function CHESTBURSTER.KeyPress(ply,key)
	if key == IN_SCORE then ply:Taunt() end
	if key == IN_RELOAD then CHESTBURSTER.DropWeapon(ply) end
	if key == IN_USE then ply:Climb() end
end
hook.Add("KeyPress","CHBUKeyPress",CHESTBURSTER.KeyPress)