if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
	SWEP.PrintName 		= "Sorcerer Cannon"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end
SWEP.Base = "weapon_chbu_base"

SWEP.HoldType           = "rpg"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_rpg.mdl"
SWEP.WorldModel         = "models/weapons/w_rocketlauncher.mdl"

SWEP.Primary.Sound 			= Sound("weapons/flaregun/fire.wav")
SWEP.Primary.Damage 		= 15
SWEP.Primary.Delay 			= 2
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"

SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

SWEP.Element = "None"

SWEP.Projectile = "chbu_cannonbolt"
SWEP.ProjectilePower = 5600
SWEP.ProjectileGravity = false

function SWEP:PrimaryAttack()
	self:CHBU_ProjectileAttack()
end