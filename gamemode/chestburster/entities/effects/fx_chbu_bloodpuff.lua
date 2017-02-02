function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 15 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+Vector(0,0,math.random(-32,32)))
		part:SetVelocity(VectorRand()*Vector(math.random(-155,155),math.random(-155,155),115))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(12,15))
		part:SetEndSize(0)
		part:SetDieTime(math.random(1,1.5))
		part:SetColor(math.random(215,255),55,55) 
		part:SetGravity(Vector(0,0,512))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end