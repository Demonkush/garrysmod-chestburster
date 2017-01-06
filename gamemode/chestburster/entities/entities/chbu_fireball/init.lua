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

	self:SetElement("Fire")
	self.Damage = 10
end

function ENT:Explode()
	self:EmitSound("ambient/fire/mtov_flame2.wav",95,125)

	for a, b in pairs(ents.FindInSphere(self:GetPos(),175)) do
		if b:IsPlayer() then
			local r = math.random(1,100)
			if r > 50 then
				CHESTBURSTER.Elements[1].onBuff(b,self)
			end
			CHESTBURSTER_PlayerDamage(30,self:GetElement(),b,self)
		end
		if !b:IsPlayer() then
			local dmg = DamageInfo()
			dmg:SetDamage(25)
			b:TakeDamageInfo(dmg)
		end
	end

	local fx = EffectData() fx:SetOrigin( self:GetPos() )
	util.Effect( "fx_chbu_volcano", fx ,true,true)

	self:Remove()
end

function ENT:PhysicsCollide()
	self:Explode()
end