AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate002a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )

	local r = math.random(1,#CHESTBURSTER.ChestModels)
	for a,b in pairs(CHESTBURSTER.ChestModels) do
		if a == r then
			self:SetModel(b.model)
			self:SetPos(self:GetPos()+b.offset)
		end
	end

	local angles = {Angle(0,90,0),Angle(0,0,0),Angle(0,180,0),Angle(0,270,0)}
	self:SetAngles(table.Random(angles))

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	self:SetTrap(false)
	local r = math.random(1,100)
	if r <= CHESTBURSTER.TrapChestChance then
		self:SetTrap(true)
	end

	self:SetRare(false)
	local r = math.random(1,100)
	if r <= CHESTBURSTER.RareChestChance then
		self:SetRare(true)
		self:SetTrap(false)
	end

	timer.Simple(25,function()
		if IsValid(self) && self.Opened == false then
			self:Remove()
		end
	end)

	self.Opened = false
end

function ENT:DoFX(fx)
	local effect = EffectData() effect:SetOrigin(self:GetPos()+Vector(0,0,32))
	util.Effect(fx,effect,true,true)
end

function ENT:Use(ply)
	if self.Opened == true then return end
	self.Opened = true
	CHESTBURSTER_Message(ply, "Chest", "Opening...", Vector(255,215,185), false)
	timer.Simple(1,function() CHESTBURSTER.OpenChest(ply,self) end)
end

function ENT:OnRemove()
	local fx = EffectData() fx:SetOrigin(self:GetPos())
	util.Effect("fx_chbu_poof",fx)
end