include("shared.lua")
function ENT:Initialize()
	self.spawnfxtype = 1

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
end

function ENT:Think()
	local color = Color(215,155,125)
	local lite = DynamicLight(self:EntIndex())
	local size,brightness = 80,1
	if self:GetRare() == true then
		size,brightness,color = 150,2,Color(255,215,105)
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