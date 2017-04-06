function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 3 do
		local part = emit:Add("sprites/glow04_noz",data:GetOrigin()+(VectorRand()*25))
		part:SetVelocity(Vector(0,0,5))
		part:SetStartAlpha(100)
		part:SetEndAlpha(0)
		part:SetStartSize(1)
		part:SetEndSize(3)
		part:SetDieTime(math.random(0.5,1))
		part:SetColor(255,215,155)
		part:SetGravity(Vector(0,0,55))
	end
	emit:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end