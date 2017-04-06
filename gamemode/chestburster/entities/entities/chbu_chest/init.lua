AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate002a.mdl")
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

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
		phys:EnableMotion(false)
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

	if CHESTBURSTER.ChestDespawnDelay > 1 then
		timer.Simple(CHESTBURSTER.ChestDespawnDelay,function()
			if IsValid(self) && self.Opened == false then
				self:Remove()
			end
		end)
	end

	self.Opened = false
end

function ENT:Think()
	local fx = EffectData() fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_chbu_chestparticles", fx ,true,true)
end

function ENT:DoFX(fx)
	local effect = EffectData() effect:SetOrigin(self:GetPos()+Vector(0,0,32))
	util.Effect(fx,effect,true,true)
end

function ENT:Use(ply)
	if self.Opened == true then return end
	self.Opened = true
	CHESTBURSTER_Message(ply, "Chest", "Opening...", Vector(255,215,185), false)
	ply:Freeze(true)
	timer.Simple(1,function() 
		if IsValid(ply) then 
			if !timer.Exists("chbu_frostbite"..ply:EntIndex()) then
				if ply:GetNWBool("KnockedOut") == false then
					ply:Freeze(false)
				end
			end
		end 
		CHESTBURSTER.OpenChest(ply,self) 
	end)
end

function ENT:OnRemove()
	local fx = EffectData() fx:SetOrigin(self:GetPos())
	util.Effect("fx_chbu_poof",fx,true,true)
end