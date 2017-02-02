ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Rare")
	self:NetworkVar("Bool",1,"Trap")
end