--[[-------------------------------------------------------
Weapons
-------------------------------------------------------]]--
CHESTBURSTER.Weapons = {}
CHESTBURSTER.Weapons[1] = {
	name = "Fists",
	wep = "weapon_chbu_fists"
}
CHESTBURSTER.Weapons[2] = {
	name = "Wandbar",
	wep = "weapon_chbu_crowbar"
}
CHESTBURSTER.Weapons[3] = {
	name = "Magic Pistol",
	wep = "weapon_chbu_pistol"
}
CHESTBURSTER.Weapons[4] = {
	name = "Sticky Nades",
	wep = "weapon_chbu_grenade"
}
CHESTBURSTER.Weapons[5] = {
	name = "Sorcerer Cannon",
	wep = "weapon_chbu_cannon"
}

function CHESTBURSTER.AddWeaponTable(tab)
	table.Add(CHESTBURSTER.Weapons,tab)
end