function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 25 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+Vector(0,0,math.random(-32,32)))
		part:SetVelocity(VectorRand()*Vector(math.random(-55,55),math.random(-55,55),115))
		part:SetStartAlpha(155)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(25,35))
		part:SetEndSize(0)
		part:SetDieTime(math.random(1.5,2))
		part:SetColor(155,215,55) 
		part:SetGravity(Vector(0,0,-155))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end