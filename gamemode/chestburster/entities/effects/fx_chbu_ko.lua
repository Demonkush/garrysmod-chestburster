function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 3 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetStartAlpha(255)
		part:SetStartSize(215)
		part:SetEndSize(0)
		part:SetDieTime(2)
		part:SetColor(math.random(100,255),math.random(100,255),math.random(100,255)) 
	end
	for i=0, 45 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+Vector(0,0,math.random(-64,64)))
		part:SetVelocity(VectorRand()*Vector(math.random(-125,125),math.random(-125,125),125))
		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
		part:SetStartSize(math.random(15,35))
		part:SetEndSize(0)
		part:SetDieTime(math.random(2,3))
		part:SetColor(math.random(100,255),math.random(100,255),math.random(100,255)) 
		part:SetGravity(Vector(0,0,-256))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end