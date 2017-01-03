if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
	SWEP.PrintName 		= "Wandbar"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end
SWEP.Base = "weapon_chbu_base"

SWEP.PrintName 			= "Wandbar"
SWEP.HoldType           = "melee"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Sound 			= Sound("weapons/physcannon/energy_sing_flyby1.wav")
SWEP.Primary.Damage 		= 15
SWEP.Primary.Delay 			= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		    = "none"

SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

SWEP.Element = "None"

SWEP.Projectile = "chbu_bolt"
SWEP.ProjectilePower = 3600
SWEP.ProjectileGravity = false

function SWEP:PrimaryAttack()
	self:CHBU_ProjectileAttack()
end