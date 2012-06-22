function EFFECT:Init(data)
	
	local NumParticles = 3000
	
	local emitter = ParticleEmitter(data:GetOrigin())
	
		for i = 0, NumParticles do

			local Pos = (data:GetOrigin() + Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(-10, 10)))
		
			local particle = emitter:Add("sprites/spark", Pos)

			if (particle) then
				particle:SetVelocity(VectorRand()*math.Rand(200,600)+Vector(0,0,200))
				
				particle:SetLifeTime(0)
				particle:SetDieTime(math.Rand(7,10))
				
				particle:SetColor(100,20,20)			

				particle:SetStartAlpha(255)
				particle:SetEndAlpha(255)

				local derpikins=math.random(1,7)
				particle:SetStartSize(derpikins)
				particle:SetEndSize(1)
				
				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))
				
				particle:SetAirResistance(100)
				
				particle:SetGravity(Vector(0,0,math.Rand(-600,-1400)))

				particle:SetCollide(true)
				particle:SetBounce(0)

				particle:SetLighting(1)
			end
		end
		
	emitter:Finish()
end

function EFFECT:Think()

	return false
end

function EFFECT:Render()
end