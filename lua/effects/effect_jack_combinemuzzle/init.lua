function EFFECT:Init(data)

	local dirkshun=data:GetNormal()
	local pozishun=data:GetStart()
	local skayul=data:GetScale()
	
	local NumParticles = 10*skayul
	
	local emitter = ParticleEmitter(data:GetOrigin())
	
		for i = 0, NumParticles do

			local rollparticle = emitter:Add("particles/flamelet"..math.random(1,3),pozishun+VectorRand()*math.Rand(0,10)*skayul)

			if (rollparticle) then
				rollparticle:SetVelocity((Vector(math.Rand(-30,30),math.Rand(-30,30),math.Rand(-30,30))+dirkshun*math.Rand(250,750))*skayul)
				
				rollparticle:SetLifeTime(0)
				local life=math.Rand(0.025,0.075)*skayul^0.25
				local begin=CurTime()
				rollparticle:SetDieTime(life)
				
				rollparticle:SetColor(0,math.Rand(100,150),math.Rand(235,255))
				
				rollparticle:SetStartAlpha(255)
				rollparticle:SetEndAlpha(0)
				
				rollparticle:SetStartSize(10*skayul)
				rollparticle:SetEndSize(15*skayul)
				
				rollparticle:SetRoll(math.Rand(-360, 360))
				rollparticle:SetRollDelta(math.Rand(-0.61, 0.61)*5)
				
				rollparticle:SetAirResistance(1000)
				
				rollparticle:SetGravity(Vector(0,0,0))

				rollparticle:SetCollide(false)

				rollparticle:SetLighting(false)
			end
			
			local rollparticle = emitter:Add("particles/flamelet"..math.random(1,3),pozishun)

			if (rollparticle) then
				rollparticle:SetVelocity((Vector(math.Rand(-5,5),math.Rand(-5,5),math.Rand(-5,5))+dirkshun*math.Rand(750,2500))*skayul)
				
				rollparticle:SetLifeTime(0)
				local life=math.Rand(0.025,0.075)*skayul^0.5
				local begin=CurTime()
				rollparticle:SetDieTime(life)
				
				rollparticle:SetColor(100,175,255)
				
				rollparticle:SetStartAlpha(255)
				rollparticle:SetEndAlpha(0)
				
				rollparticle:SetStartSize(5*skayul)
				rollparticle:SetEndSize(10*skayul)
				
				rollparticle:SetRoll(math.Rand(-360, 360))
				rollparticle:SetRollDelta(math.Rand(-0.61, 0.61)*5)
				
				rollparticle:SetAirResistance(1000)
				
				rollparticle:SetGravity(Vector(0,0,0))

				rollparticle:SetCollide(false)

				rollparticle:SetLighting(false)
			end
		end
		
	emitter:Finish()
	
	local dlight=DynamicLight(self:EntIndex())
	if(dlight)then
		dlight.Pos=pozishun
		dlight.r=190
		dlight.g=225
		dlight.b=255
		dlight.Brightness=2*skayul
		dlight.Size=200*skayul
		dlight.Decay=600*skayul
		dlight.DieTime=CurTime()+0.03*skayul^0.25
		dlight.Style=0
	end
end

function EFFECT:Think()

	return false
end

function EFFECT:Render()
end