function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 25 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+Vector(0,0,math.random(-32,32)))
		part:SetVelocity(VectorRand()*Vector(math.random(-55,55),math.random(-55,55),215))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,35))
		part:SetEndSize(0)
		part:SetDieTime(math.random(1,1.5))
		part:SetColor(115,255,115) 
		part:SetGravity(Vector(0,0,256))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end