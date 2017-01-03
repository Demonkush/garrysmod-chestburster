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
	end

	self.GoldAmount = 50
end

function ENT:Touch(ent)
	if ent:IsPlayer() then
		CHESTBURSTER.CollectGold(ent,self.GoldAmount)
		ent:PrintMessage(HUD_PRINTTALK,"Picked up "..self.GoldAmount.." gold!")
		self:Remove()
	end
end

function ENT:Use(activator)
	CHESTBURSTER.CollectGold(activator,self.GoldAmount)
	activator:PrintMessage(HUD_PRINTTALK,"Picked up "..self.GoldAmount.." gold!")
	self:Remove()
end

function ENT:OnRemove()
	local fx = EffectData() fx:SetOrigin(self:GetPos()) util.Effect("fx_chbu_goldpuff",fx)
end