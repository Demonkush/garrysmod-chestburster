function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 3 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin())
		part:SetVelocity(Vector(0,0,math.random(15,75)))
		part:SetStartAlpha(255)
		part:SetStartSize(45)
		part:SetEndSize(0)
		part:SetDieTime(2)
		part:SetColor(255,155,75) 
	end
	for i=0, 25 do
		local part = emit:Add("particles/flamelet"..math.random(1,5),data:GetOrigin()+Vector(0,0,math.random(-32,32)))
		part:SetVelocity(VectorRand()*Vector(math.random(-155,155),math.random(-155,155),115))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,25))
		part:SetEndSize(0)
		part:SetDieTime(math.random(1,1.5))
		part:SetColor(255,155,75) 
		part:SetGravity(Vector(0,0,256))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end