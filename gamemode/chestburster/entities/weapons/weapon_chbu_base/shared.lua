if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
	SWEP.PrintName 		= "CHBU Base"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.ViewModelFlip	= false
end
SWEP.PrintName 			= "CHBU Base"
SWEP.HoldType           = "ar2"
SWEP.Spawnable 			= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Sound 			= Sound("weapons/pistol/pistol_fire3.wav")
SWEP.Primary.Damage 		= 15
SWEP.Primary.Delay 			= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		    = "none"

SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo           = "none"

SWEP.Element = "None"

SWEP.ImpactEffect = "fx_chbu_normpuff"

SWEP.Projectile = "chbu_grenade"
SWEP.ProjectilePower = 600
SWEP.ProjectileGravity = true

function SWEP:SetupDataTables()
	self:NetworkVar("String",0,"Element")
end

function SWEP:Initialize()
	self.RealName = self.PrintName

	self:SetHoldType(self.HoldType)
	self:SetElement("None")
end

function SWEP:Deploy()
	self.Owner:PrintMessage(HUD_PRINTTALK,"Picked up "..self.PrintName)
	self.Owner.AssignedWeapon = self.Weapon:GetClass()
end

function SWEP:PrimaryAttack()
	-- Primary Attack
	self:CHBU_BulletAttack()
end

function SWEP:SecondaryAttack()
	-- Secondary Attack
end

function SWEP:CHBU_BulletAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(0.1,0.1,0)
	bullet.Tracer	= 1
	bullet.TracerName = "Tracer"
	bullet.Force	= self.Primary.Damage*5
	bullet.Damage	= damage
	bullet.Callback = function(att,tr,dmginfo)
		if SERVER then
			for k, v in pairs(ents.FindInSphere(tr.HitPos,100)) do
				CHESTBURSTER_PlayerDamage(self.Primary.Damage,self:GetElement(),tr.Entity,self.Owner)
			end
		end
		local fx = EffectData() fx:SetOrigin( tr.HitPos ) fx:SetScale(1)
		util.Effect( self.ImpactEffect, fx )
	end
	self.Owner:FireBullets(bullet)


	self.Weapon:EmitSound(self.Primary.Sound,135,math.random(95,115))
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:ViewPunch(Angle(-5,0,0))

	self:SetNextPrimaryFire(CurTime()+self.Primary.Delay)
end

function SWEP:CHBU_ProjectileAttack()
	if self:GetNextSecondaryFire() > CurTime() then return end

	if SERVER then
		local forward,right,up = self.Owner:GetForward(),self.Owner:GetRight(),self.Owner:GetUp()
		local proj = ents.Create(self.Projectile)
		proj:SetPos(self.Owner:GetShootPos()+(right*8)+(up*-2))
		proj:SetAngles(self.Owner:GetAngles())
		proj:SetOwner(self.Owner)
		proj:Spawn()

		proj:SetElement(self:GetElement())
		proj.Damage = self.Primary.Damage
		proj.ImpactEffect = self.ImpactEffect

		proj:SetElementColor()

		local phys = proj:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceCenter(self.Owner:GetAimVector()+self.Owner:GetForward()*self.ProjectilePower)
			phys:EnableGravity(self.ProjectileGravity)
		end
	end

	self.Weapon:EmitSound(self.Primary.Sound,135,math.random(95,115))
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:ViewPunch(Angle(-5,0,0))

	self:SetNextPrimaryFire(CurTime()+self.Primary.Delay)
end