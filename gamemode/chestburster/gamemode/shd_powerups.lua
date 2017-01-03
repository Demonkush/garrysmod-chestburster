--[[-------------------------------------------------------
Powerups
-------------------------------------------------------]]--
CHESTBURSTER.Powerups = {}
CHESTBURSTER.Powerups[1] = {
	name = "Enhanced Damage",
	desc = "Damage is increased for 25 seconds!",
	color = Color(255,185,155),
	time = 25,
	onPickup = function(ply)
		ply:SetNWInt("DamageMultiplier",2)
	end,
	onExpire = function(ply)
		ply:SetNWInt("DamageMultiplier",1)
	end
}
CHESTBURSTER.Powerups[2] = {
	name = "KO Armor",
	desc = "Gained enhanced resistance to KO for 25 seconds!",
	color = Color(215,185,155),
	time = 25,
	onPickup = function(ply)
		ply:SetNWInt("DamageResistance",5)
	end,
	onExpire = function(ply)
		ply:SetNWInt("DamageResistance",0)
	end
}
CHESTBURSTER.Powerups[3] = {
	name = "Invulnerability",
	desc = "Invincible to KOs for 15 seconds!",
	color = Color(215,215,155),
	time = 15,
	onPickup = function(ply)
		ply:SetNWBool("KOImmunity",true)
	end,
	onExpire = function(ply)
		ply:SetNWBool("KOImmunity",false)
	end
}
CHESTBURSTER.Powerups[4] = {
	name = "Inferno",
	desc = "Fire resistance enhanced for 15 seconds! Weapon imbued with the power of fire!",
	color = Color(215,185,155),
	time = 15,
	onPickup = function(ply)
		ply:SetNWBool("ImbueFire",true)
		CHESTBURSTER.ImbueWeapon(ply,"Fire")
	end,
	onExpire = function(ply)
		ply:SetNWBool("ImbueFire",false)
	end
}
CHESTBURSTER.Powerups[5] = {
	name = "Freezing",
	desc = "Frost resistance enhanced for 15 seconds! Weapon imbued with the power of frost!",
	color = Color(125,185,255),
	time = 15,
	onPickup = function(ply)
		ply:SetNWBool("ImbueFrost",true)
		CHESTBURSTER.ImbueWeapon(ply,"Frost")
	end,
	onExpire = function(ply)
		ply:SetNWBool("ImbueFrost",false)
	end
}
CHESTBURSTER.Powerups[6] = {
	name = "Venom",
	desc = "Poison resistance enhanced for 15 seconds! Weapon imbued with the power of poison!",
	color = Color(155,255,155),
	time = 15,
	onPickup = function(ply)
		ply:SetNWBool("ImbuePoison",true)
		CHESTBURSTER.ImbueWeapon(ply,"Poison")
	end,
	onExpire = function(ply)
		ply:SetNWBool("ImbuePoison",false)
	end
}
CHESTBURSTER.Powerups[7] = {
	name = "Shocking",
	desc = "Storm resistance enhanced for 15 seconds! Weapon imbued with the power of storm!",
	color = Color(185,215,255),
	time = 15,
	onPickup = function(ply)
		ply:SetNWBool("ImbueStorm",true)
		CHESTBURSTER.ImbueWeapon(ply,"Storm")
	end,
	onExpire = function(ply)
		ply:SetNWBool("ImbueStorm",false)
	end
}
CHESTBURSTER.Powerups[8] = {
	name = "Soaking",
	desc = "Water resistance enhanced for 15 seconds! Weapon imbued with the power of water!",
	color = Color(155,185,255),
	time = 15,
	onPickup = function(ply)
		ply:SetNWBool("ImbueWater",true)
		CHESTBURSTER.ImbueWeapon(ply,"Water")
	end,
	onExpire = function(ply)
		ply:SetNWBool("ImbueWater",false)
	end
}
CHESTBURSTER.Powerups[9] = {
	name = "Extra KO",
	desc = "Gained 50 extra KO power for 25 seconds!",
	color = Color(215,255,155),
	time = 25,
	onPickup = function(ply)
		ply:SetNWInt("KOMax",CHESTBURSTER.KOMax+50)
	end,
	onExpire = function(ply)
		ply:SetNWInt("KOMax",CHESTBURSTER.KOMax)
		if ply:GetNWInt("KO") > ply:GetNWInt("KOMax") then
			ply:SetNWInt("KO",CHESTBURSTER.KOMax)
		end
	end
}
CHESTBURSTER.Powerups[10] = {
	name = "Haste",
	desc = "Gained enhanced movement speed for 25 seconds!",
	color = Color(215,255,155),
	time = 25,
	onPickup = function(ply)
		ply:Haste(25)
	end,
	onExpire = function(ply)
		ply:ClearMovementEffects()
	end
}
CHESTBURSTER.Powerups[11] = {
	name = "Detection",
	desc = "Gained detection of players and chests for 25 seconds!",
	color = Color(215,255,155),
	time = 25,
	onPickup = function(ply)
		ply:Detection(25)
	end,
	onExpire = function(ply)
	end
}