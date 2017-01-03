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

	self:SetElement("None")
	self.ImpactEffect = "fx_chbu_normpuff"
	self.Damage = 10
	self.Collided = false

	timer.Simple(3,function()
		if IsValid(self) then
			self:Explode()
		end
	end)
end

function ENT:SetElementColor()
	for a, b in pairs(CHESTBURSTER.Elements) do
		if self:GetElement() == b.name then self:SetColor(b.color) end
	end
end

function ENT:Explode()
	self:EmitSound("npc/roller/mine/rmine_explode_shock1.wav")

	for a, b in pairs(ents.FindInSphere(self:GetPos(),255)) do
		if b != self:GetOwner() then
			CHESTBURSTER_PlayerDamage(35,self:GetElement(),b,self:GetOwner())
		end
	end

	local fx = EffectData() fx:SetOrigin( self:GetPos() ) fx:SetScale(2)
	util.Effect( self.ImpactEffect, fx )

	self:Remove()
end

local colents = {"prop_physics","prop_physics_multiplayer"}
function ENT:PhysicsCollide(data,phys)
	if self.Collided == true then return end
	self:SetVelocity(Vector(0,0,0))
	if table.HasValue(colents,data.HitEntity:GetClass()) then self:SetParent(data.HitEntity) self.Collided = true end
	timer.Simple(1,function()
		if IsValid(self) then
			self:Explode()
		end
	end)
end

function ENT:Touch(ent)
	if ent:IsPlayer() then
		self:SetVelocity(Vector(0,0,0))
		self:SetParent(ent)
	end
end