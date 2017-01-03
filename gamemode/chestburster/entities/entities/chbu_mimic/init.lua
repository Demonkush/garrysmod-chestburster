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
	self.Health = 50
end

function ENT:Think()
	if self.EatDelay < CurTime() then
		for a,b in pairs(ents.FindInSphere(self:GetPos(),95)) do
			if b:IsPlayer() then
				if self != b then
					CHESTBURSTER_PlayerDamage(15,"Physical",b,b)
					self:EmitSound("npc/fast_zombie/claw_strike1.wav",85,125)
					local fx = EffectData() fx:SetOrigin(b:GetPos()) 
					util.Effect("fx_chbu_bloodpuff",fx)
				end
			end
		end
		self.EatDelay = CurTime() + 1
	end
end

function ENT:OnTakeDamage(damage)
	self.Health = self.Health - damage
	if self.Health <= 0 then self:Remove() end
end