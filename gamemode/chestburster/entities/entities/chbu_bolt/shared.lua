ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Element")
end

if CLIENT then
	function ENT:Initialize()
		self.Emit = ParticleEmitter(self:GetPos())
		self.NextEmit = RealTime() 
	end

	function ENT:Think() self.Emit:SetPos(self:GetPos()) return true end

	function ENT:Draw()
		local color = self.Entity:GetColor()
		if RealTime() > self.NextEmit then
			local Emit = self.Emit
			Emit:SetPos(self:GetPos())
			local particle = Emit:Add("sprites/glow04_noz",self:GetPos())
			particle:SetVelocity(VectorRand()*155)
			particle:SetDieTime(1)
			particle:SetStartAlpha(75)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(15,25))
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0,360))
			particle:SetRollDelta(math.Rand(-1,1))
			particle:SetGravity(Vector(0,0,0))
			particle:SetAirResistance(255)
			particle:SetColor(color.r,color.g,color.b,55)
			self.NextEmit = RealTime()+0.05
		end
	end

	function ENT:OnRemove()
		self.Emit:Finish()
	end
end