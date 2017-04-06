function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local scale = data:GetScale()
	for i=0, 1 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetStartAlpha(255)
		part:SetStartSize(125*scale)
		part:SetEndSize(0)
		part:SetDieTime(0.5)
		part:SetColor(255,185,155) 
	end
	for i=0, 10*scale do
		local part = emit:Add("particles/flamelet"..math.random(1,5),data:GetOrigin()+(VectorRand()*64))
		part:SetVelocity((VectorRand()*5)+Vector(math.random(-55,55),math.random(-55,55),5)*scale)
		part:SetStartAlpha(185)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(30,35)*scale)
		part:SetEndSize(1)
		part:SetDieTime(0.6)
		part:SetColor(255,185,155) 
		part:SetGravity(Vector(0,0,512))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end