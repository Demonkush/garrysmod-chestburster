--[[-------------------------------------------------------
Weapons
-------------------------------------------------------]]--
CHESTBURSTER.Weapons = {}
CHESTBURSTER.Weapons[1] = {
	name = "Wandbar",
	wep = "weapon_chbu_crowbar"
}
CHESTBURSTER.Weapons[2] = {
	name = "Magic Pistol",
	wep = "weapon_chbu_pistol"
}
CHESTBURSTER.Weapons[3] = {
	name = "Sticky Nades",
	wep = "weapon_chbu_grenade"
}
CHESTBURSTER.Weapons[4] = {
	name = "Sorcerer Cannon",
	wep = "weapon_chbu_cannon"
}

function CHESTBURSTER.AddWeaponTable(tab)
	table.Add(CHESTBURSTER.Weapons,tab)
end