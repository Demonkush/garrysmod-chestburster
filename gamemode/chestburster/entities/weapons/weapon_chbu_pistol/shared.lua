if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
	SWEP.PrintName 		= "Magic Pistol"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end
SWEP.Base = "weapon_chbu_base"

SWEP.PrintName 			= "Magic Pistol"
SWEP.HoldType           = "pistol"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_pistol.mdl"
SWEP.WorldModel         = "models/weapons/w_pistol.mdl"

SWEP.Primary.Sound 			= Sound("weapons/pistol/pistol_fire2.wav")
SWEP.Primary.Damage 		= 8
SWEP.Primary.Delay 			= 0.35
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"

SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

SWEP.Element = "None"

function SWEP:PrimaryAttack()
	self:CHBU_BulletAttack()
end