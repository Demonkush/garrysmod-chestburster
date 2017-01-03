ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Element")
end

if CLIENT then
	function ENT:Initialize()
		self.Emit = ParticleEmitter(self:GetPos())
		self.NextEmit = CurTime() 
	end

	function ENT:Think()
		local color = self.Entity:GetColor()
		if self.NextEmit < CurTime() then
			self.Emit:SetPos(self:GetPos())
			local part = self.Emit:Add("sprites/glow04_noz.vmt",self:GetPos())
			part:SetVelocity(Vector(0,0,4))
			part:SetDieTime(7)
			part:SetStartAlpha(140)
			part:SetEndAlpha(0)
			part:SetStartSize(5)
			part:SetEndSize(6)   
			part:SetColor(color)
			self.NextEmit = CurTime()+0.1
		end
	end

	function ENT:OnRemove()
		self.Emit:Finish()
	end
end