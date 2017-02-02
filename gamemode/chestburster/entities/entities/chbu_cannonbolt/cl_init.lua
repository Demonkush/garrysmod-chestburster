include("shared.lua")
function ENT:Initialize()
	self:DrawShadow(false)
	self.Emit = ParticleEmitter(self:GetPos())
	self.NextEmit = RealTime() 
end

function ENT:Think() self.Emit:SetPos(self:GetPos()) return true end

function ENT:Draw()
	local rt = RealTime()
	local pos = self:GetPos()
	local color = self.Entity:GetColor()
	if rt < self.NextEmit then return end
	local Emitter = self.Emit
	Emitter:SetPos(pos)
	local particle = Emitter:Add("sprites/glow04_noz",pos)
	particle:SetVelocity(VectorRand()*15)
	particle:SetDieTime(1)
	particle:SetStartAlpha(75)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.random(25,35))
	particle:SetEndSize(1)
	particle:SetRoll(math.Rand(0,360))
	particle:SetRollDelta(math.Rand(-1,1))
	particle:SetGravity(Vector(0,0,0))
	particle:SetAirResistance(255)
	particle:SetColor(color.r,color.g,color.b,55)
	self.NextEmit = rt+0.02
end

function ENT:OnRemove()
	self.Emit:Finish()
end