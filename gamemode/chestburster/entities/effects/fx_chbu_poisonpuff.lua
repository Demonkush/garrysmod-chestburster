function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local scale = data:GetScale()
	for i=0, 1 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetStartAlpha(155)
		part:SetStartSize(45*scale)
		part:SetEndSize(0)
		part:SetDieTime(2*scale)
		part:SetColor(215,255,155) 
	end
	for i=0, 10*scale do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+Vector(0,0,math.random(-32,32)))
		part:SetVelocity(VectorRand()*Vector(math.random(-155,155),math.random(-155,155),115)*scale)
		part:SetStartAlpha(155)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,25)*scale)
		part:SetEndSize(0)
		part:SetDieTime(math.random(1,1.5)*scale)
		part:SetColor(215,255,155) 
		part:SetGravity(Vector(0,0,55))
		part:SetCollide(true)
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end