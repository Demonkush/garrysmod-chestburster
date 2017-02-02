ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Element")
	self:NetworkVar("String",1,"ImpactEffect")
end