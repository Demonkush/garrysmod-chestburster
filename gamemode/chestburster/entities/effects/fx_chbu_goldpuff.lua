function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 15 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin())
		part:SetVelocity(VectorRand()*Vector(math.random(-55,55),math.random(-55,55),55))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,25))
		part:SetEndSize(0)
		part:SetDieTime(math.random(1,1.5))
		part:SetColor(255,215,175) 
		part:SetGravity(Vector(0,0,56))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end