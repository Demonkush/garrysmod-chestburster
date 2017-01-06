AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate002a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end

	self.EatDelay = 0
	self.HP = 55
	self.Damage = 15
end

function ENT:Think()
	if self.EatDelay < CurTime() then
		for a,b in pairs(ents.FindInSphere(self:GetPos(),95)) do
			if b:IsPlayer() then
				if self != b then
					CHESTBURSTER_PlayerDamage(self.Damage,"Physical",b,self)
					self:EmitSound("npc/fast_zombie/claw_strike1.wav",85,125)
					local fx = EffectData() fx:SetOrigin(b:GetPos()) 
					util.Effect("fx_chbu_bloodpuff",fx,true,true)
				end
			end
		end
		self.EatDelay = CurTime() + 1
	end
end

function ENT:DropGold()
	local golddrop = ents.Create("chbu_gold")
	golddrop:SetPos(self:GetPos()+Vector(0,0,16))
	golddrop:Spawn()
	golddrop.GoldAmount = self.Damage

	local phys = golddrop:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(VectorRand()*175+Vector(0,0,75))
	end
end

function ENT:OnTakeDamage(damage)
	self.HP = self.HP - damage:GetDamage()
	if self.HP <= 0 then self:DropGold() self:Remove() end
end

function ENT:OnRemove()
	local fx = EffectData() fx:SetOrigin(self:GetPos()) 
	util.Effect("fx_chbu_bloodpuff",fx,true,true)
end