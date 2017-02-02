include("shared.lua")
function ENT:Initialize()
	self.spawnfxtype = 1
	self.Emit = ParticleEmitter(self:GetPos())
	self.NextEmit = RealTime() 

	if self.spawnfxtype == 1 then
		self.Entity:SetModelScale(0.1)
		self.scale=0 self.maxscale = 1
	elseif self.spawnfxtype == 2 then
		self.Entity:SetColor(Color(255,255,255,0))
		self.col=0 self.maxcol = 255
	end
end

function ENT:Draw()
	self.Entity:DrawModel()

	local rt = RealTime()
	local pos = self:GetPos()
	local color = Color(255,215,105)
	local size = 6
	if self:GetRare() == true then size = 20 end
	if rt < self.NextEmit then return end
	local Emitter = self.Emit
	Emitter:SetPos(pos)
	local particle = Emitter:Add("sprites/glow04_noz",pos+(VectorRand()*size))
	particle:SetVelocity(VectorRand()*95)
	particle:SetDieTime(1)
	particle:SetStartAlpha(75)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.random(15,25))
	particle:SetEndSize(1)
	particle:SetRoll(math.Rand(0,360))
	particle:SetRollDelta(math.Rand(-1,1))
	particle:SetGravity(Vector(0,0,155))
	particle:SetAirResistance(255)
	particle:SetColor(color.r,color.g,color.b,55)
	self.NextEmit = rt+0.1
end

function ENT:Think()
	if !self.Emit then self.Emit = ParticleEmitter(self:GetPos()) end
	local color = Color(215,155,125)
	local lite = DynamicLight(self:EntIndex())
	local size,brightness = 80,1
	if self:GetRare() == true then
		size,brightness,color = 200,3,Color(255,215,105)
	end
	if self:GetTrap() == true then
		size,brightness,color = 100,1,Color(215,75,75)
	end
	if (lite) then
		lite.pos = self:GetPos()
        lite.R 			= color.r
        lite.G 			= color.g
        lite.B 			= color.b
        lite.Brightness = brightness
        lite.Decay 		= 15
        lite.Size 		= size
        lite.DieTime 	= CurTime()+0.1
	end
	if self.spawnfxtype == 1 then
		if self.scale < self.maxscale then
			self.scale = self.scale + 0.01
			self.Entity:SetModelScale(self.scale)
		end
	elseif self.spawnfxtype == 2 then
		if self.col < self.maxcol then
			self.col = self.col + 0.01 
			self.Entity:SetColor(Color(255,255,255,self.col))
		end
	end
	return true
end

function ENT:OnRemove()
	self.Emit:Finish()
end