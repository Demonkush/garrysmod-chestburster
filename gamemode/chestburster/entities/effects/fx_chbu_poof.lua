function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 1 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetStartAlpha(255)
		part:SetStartSize(75)
		part:SetEndSize(0)
		part:SetDieTime(2)
		part:SetColor(155,155,155) 
	end
	for i=0, 15 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+Vector(0,0,math.random(-32,32)))
		part:SetVelocity(VectorRand()*Vector(math.random(-155,155),math.random(-155,155),115))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(35,45))
		part:SetEndSize(0)
		part:SetDieTime(math.random(1,1.5))
		part:SetColor(155,155,155)
		part:SetGravity(Vector(0,0,-215))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end