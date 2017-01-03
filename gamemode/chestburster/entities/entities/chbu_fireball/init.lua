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
	end

	self:SetElement("Fire")
	self.Damage = 10
end

function ENT:Explode()
	for a, b in pairs(ents.FindInSphere(self:GetPos(),135)) do
		CHESTBURSTER_PlayerDamage(25,self:GetElement(),b,b)
	end

	local fx = EffectData() fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_chbu_volcano", fx )

	self:Remove()
end

function ENT:PhysicsCollide()
	self:Explode()
end