function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 55 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+Vector(0,0,math.random(-32,32)))
		part:SetVelocity(VectorRand()*Vector(math.random(-115,115),math.random(-115,115),215))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(25,35))
		part:SetEndSize(0)
		part:SetDieTime(math.random(1.5,3))
		part:SetColor(25,25,25) 
		part:SetAirResistance(10)
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end