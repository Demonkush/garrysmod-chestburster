ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Rare")
	self:NetworkVar("Bool",1,"Trap")
end

if CLIENT then
	function ENT:Initialize()
		self.Emit = ParticleEmitter(self:GetPos())
		self.NextEmit = RealTime() 
	end

	function ENT:Draw()
		self.Entity:DrawModel()
		local color = Color(255,215,105)
		local size = 6
		if self:GetRare() == true then
			size = 20
		end
		if RealTime() > self.NextEmit then
			local Emit = self.Emit
			Emit:SetPos(self:GetPos())
			local particle = Emit:Add("sprites/glow04_noz",self:GetPos()+(VectorRand()*size))
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
			self.NextEmit = RealTime()+0.1
		end
	end

	function ENT:Think()
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
		self.Emit:SetPos(self:GetPos())
		return true
	end

	function ENT:OnRemove()
		self.Emit:Finish()
	end
end