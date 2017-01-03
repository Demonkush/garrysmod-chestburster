function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 25 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+Vector(0,0,math.random(-32,32)))
		part:SetVelocity(VectorRand()*Vector(math.random(-255,255),math.random(-255,255),255))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,25))
		part:SetEndSize(0)
		part:SetDieTime(math.random(0.5,1))
		part:SetColor(255,235,155) 
		part:SetGravity(Vector(0,0,256))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end