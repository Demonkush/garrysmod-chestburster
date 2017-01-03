# garrysmod-chestburster
Chestburster by Demonkush
Gamemode for Garry's Mod, a submission for the 2016 Facepunch Gamemode Contest

Contest Page: https://facepunch.com/showthread.php?t=1537519


What is Chestburster?

Chestburster is a "loot-race" where players run around maps looting chests for gold and goodies, while knocking out other players to plunder their gold too!
Weapons, powerups and gold can be obtained from chests. Some chests are trapped, so be careful!


Configuration Help

Some functions and variables in Chestburster are somewhat easy to modify. There are some basic variables under shared.lua, but if you wanted to modify or add elements / powerups / weapons, you'd have to access the shd_elements/etc file associated. If you know a bit of lua, it should be easy to add features. Sounds can be added via shd_sounds.lua.

Elements

name(string), buffChance(integer), color(color), onBuff(function), onDamage(function), ImbueWeapon(function), ClearStatus(function)


Powerups

name(string), desc(string), color(color), time(integer), onPickup(function), onExpire(function)


Weapons

name(string), wep(weapon entity)


Traps

name(string), doTrap(function)


You can see how they are used inside of their corresponding table files.
