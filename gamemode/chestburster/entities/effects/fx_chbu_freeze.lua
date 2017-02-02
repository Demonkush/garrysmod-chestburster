function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 45 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+(VectorRand()*24))
		part:SetVelocity(VectorRand()*Vector(math.random(-155,155),math.random(-155,155),155))
		part:SetStartAlpha(215)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,25))
		part:SetEndSize(0)
		part:SetDieTime(math.random(3.5,4))
		part:SetColor(155,175,255) 
		part:SetGravity(Vector(0,0,56))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end