if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
	SWEP.PrintName 		= "Sticky Nades"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end
SWEP.Base = "weapon_chbu_base"

SWEP.HoldType           = "grenade"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_grenade.mdl"
SWEP.WorldModel         = "models/weapons/w_grenade.mdl"

SWEP.Primary.Sound 			= Sound("weapons/slam/throw.wav")
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

SWEP.Projectile = "chbu_grenade"
SWEP.ProjectilePower = 4600
SWEP.ProjectileGravity = true

function SWEP:PrimaryAttack()
	self:CHBU_ProjectileAttack()
end