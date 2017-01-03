function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 45 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+(VectorRand()*25))
		part:SetVelocity(VectorRand()*Vector(math.random(-25,25),math.random(-25,25),25))
		part:SetStartAlpha(25)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(75,85))
		part:SetEndSize(0)
		part:SetDieTime(math.random(7,8))
		part:SetColor(215,255,155) 
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end