AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/dav0r/hoverball.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end

	self:SetElement("None")
	self.ImpactEffect = "fx_chbu_normpuff"
	self.Damage = 10
end

function ENT:SetElementColor()
	for a, b in pairs(CHESTBURSTER.Elements) do
		if self:GetElement() == b.name then self:SetColor(b.color) end
	end
end

function ENT:Explode()
	self:EmitSound("ambient/energy/zap"..math.random(1,9)..".wav",95,125)

	for a, b in pairs(ents.FindInSphere(self:GetPos(),175)) do
		if b != self:GetOwner() then
			CHESTBURSTER_PlayerDamage(self.Damage,self:GetElement(),b,self:GetOwner())
		end
	end

	local fx = EffectData() fx:SetOrigin( self:GetPos() ) fx:SetScale(1)
	util.Effect( self.ImpactEffect, fx )

	if self:GetElement() == "Storm" then
		CHESTBURSTER.DoTesla(self:GetPos())
	end

	self:Remove()
end

function ENT:PhysicsCollide()
	self:Explode()
end