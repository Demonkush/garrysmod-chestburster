AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/plastic/plastic_angle_360.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	self:SetColor(Color(255,215,155))

	self:SetModelScale(0.25)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end

	self.GoldAmount = 50
	self.Received = false
end

function ENT:Touch(ent)
	if SERVER then
		if ent:IsPlayer() then
			if self.Received == true then return end self.Received = true
			CHESTBURSTER.CollectGold(ent,self.GoldAmount)
			self:Remove()
		end
	end
end

function ENT:Use(activator)
	if SERVER then
		if self.Received == true then return end self.Received = true
		CHESTBURSTER.CollectGold(activator,self.GoldAmount)
		self:Remove()
	end
end

function ENT:OnRemove()
	local fx = EffectData() fx:SetOrigin(self:GetPos()) util.Effect("fx_chbu_goldpuff",fx,true,true)
end