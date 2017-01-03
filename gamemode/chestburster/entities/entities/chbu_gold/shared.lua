ENT.Type = "anim"
ENT.Base = "base_anim"

if CLIENT then
	function ENT:Initialize()
		self.Emit = ParticleEmitter(self:GetPos())
		self.NextEmit = CurTime()
	end

	function ENT:Think()
		if self.NextEmit < CurTime() then
			self.Emit:SetPos(self:GetPos())
			local part = self.Emit:Add("sprites/glow04_noz.vmt",self:GetPos()+(VectorRand()*15))
			part:SetVelocity(Vector(0,0,4))
			part:SetDieTime(7)
			part:SetStartAlpha(140)
			part:SetEndAlpha(0)
			part:SetStartSize(5)
			part:SetEndSize(6)   
			part:SetColor(255,215,125)
			self.NextEmit = CurTime()+1
		end
	end

	function ENT:OnRemove()
		self.Emit:Finish()
	end
end