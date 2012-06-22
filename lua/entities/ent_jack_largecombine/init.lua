AddCSLuaFile("shared.lua")
include('shared.lua')

local NoCannonTable={"npc_helicopter","npc_combinedropship","npc_combinegunship"}

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	local Friendly=false
	if(ply:KeyDown(IN_USE))then
		Friendly=true
	end
	
	util.PrecacheModel("models/combine_helicopter.mdl")
	util.PrecacheModel("models/combine_strider.mdl")
	util.PrecacheModel("models/gunship.mdl")
	util.PrecacheModel("models/combine_dropship.mdl")
	util.PrecacheModel("models/combine_dropship_container.mdl")
	
	local npc1
	local npc2
	local npc3
	local npc4
	local npc5

	//this is for easy editing of the various positions
	local dropshipflyheight=1800
	local dropshipflyradius=2500
	local dropshipspawnpos=Vector(0,-400,500)
	local gunshipflyradius=2250
	local gunshipflyheight=1500
	local gunshipspawnpos=Vector(0,400,300)
	local helicopteroneflyradius=1800
	local helicopteroneflyheight=750
	local helicopteronesecondaryflyradius=700
	local helicopteronesecondaryflyheight=200
	local helicopteronespawnpos=Vector(600,0,100)
	local helicoptertwoflyradius=2500
	local helicoptertwoflyheight=950
	local helicoptertwosecondaryflyradius=700
	local helicoptertwosecondaryflyheight=200
	local helicoptertwospawnpos=Vector(-600,0,100)
	
	
	local MyNodeBuffer={}
	local Nodes=4
	local ent=ents.Create("path_track")
	ent:SetPos(selfpos+Vector(dropshipflyradius,dropshipflyradius,dropshipflyheight))
	ent:Spawn()
	if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
	if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1 end
	local ent=ents.Create("path_track")
	ent:SetPos(selfpos+Vector(dropshipflyradius,-dropshipflyradius,dropshipflyheight))
	ent:Spawn()
	if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
	if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
	local ent=ents.Create("path_track")
	ent:SetPos(selfpos+Vector(-dropshipflyradius,-dropshipflyradius,dropshipflyheight))
	ent:Spawn()
	if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
	if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
	local ent=ents.Create("path_track")
	ent:SetPos(selfpos+Vector(-dropshipflyradius,dropshipflyradius,dropshipflyheight))
	ent:Spawn()
	if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
	if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
	
	local npc=ents.Create("npc_combinedropship")
	npc:SetPos(selfpos+dropshipspawnpos)
	npc:SetAngles(Angle(0,-90,0))
	npc:SetKeyValue("CrateType","1")
	npc:SetKeyValue("Invulnerable","0")
	npc:Spawn()
	npc:Activate()
	npc.HasAJackyAllegiance=true
	if(Friendly)then
		npc.JackyAllegiance="Human"
	else
		npc.JackyAllegiance="Combine"
	end
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	npc.Damage=0
	npc.Sploding=false
	npc.NeedsMoarFirePower=true
	npc.OPSQUADWillDropCombineTech=true
	npc.OPSQUADMineDroppinMotherFucker=true
	npc:Fire("setgunrange","99999")
	local timername="OPSQUADMineDroppinMotherFucker"..npc:EntIndex()
	timer.Create(timername,12.5,40,function()	    --
		if not(IsValid(npc))then timer.Destroy(timername) return end
		npc:Fire("dropmines","3",0)     					                  	        --
	end)																				--
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)
	npc1=npc
	
	for var = 1, Nodes,1  do
		MyNodeBuffer[var]:SetName(tostring(npc) .. tostring(var))
		npc:DeleteOnRemove(MyNodeBuffer[var])
	end
	for var = 1, Nodes,1  do
		if (var != Nodes) then
			MyNodeBuffer[var]:Fire("addoutput","OnPass !activator,SetTrack," ..  tostring(npc) .. tostring((var + 1)),1)
		else
			MyNodeBuffer[var]:Fire("addoutput","OnPass !activator,SetTrack," ..  tostring(npc) .. "1",1)
		end
	end
	
	local TrackName = tostring(npc) .. "1"
	npc:Fire("SetTrack",TrackName,0.1)
	
	timer.Simple(0.05,function()
		local npc=ents.Create("npc_strider")
		npc:SetPos(selfpos)
		npc:SetAngles(Angle(0,-90,0))
		npc:SetKeyValue("spawnflags","65536")
		npc:Spawn()
		npc:Activate()
		npc:SetMaxHealth(60)
		npc:SetHealth(60)
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc.OPSQUADStrider=true
		npc.NeedsMoarFirePower=true
		npc.OPSQUADNeedsAHunter=true
		npc.OPSQUADHasAHunter=false
		npc.Standin=true
		npc.Crouchin=false
		npc:Fire("enablecrouchwalk","",0)
		local timername="OPSQUADWarspaceCannoneer"..npc:EntIndex()
		timer.Create(timername,30,0,function()	        	--
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then													--
				if(npc:GetEnemy():IsPlayer())and not(npc:GetEnemy():Alive())then return end --
				if(table.HasValue(NoCannonTable,npc:GetEnemy():GetClass()))then return end
				local name="AboutToGetFuckedUp"..npc:GetEnemy():EntIndex()
				npc:GetEnemy():SetName(name)                                       --                                              --
				npc:Fire("setcannontarget",name,0)		                                    --											--
			end																		     	--
		end)
		local timername="OPSQUADRandomCroucher"..npc:EntIndex()	--										
		timer.Create(timername,25,0,function()	        	--
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(npc.Standin)then											               		--
				npc:Fire("crouch","",0)   													--
				npc.Standin=false															--
				npc.Crouchin=true															--		
			elseif(npc.Crouchin)then                 										--
				npc:Fire("stand","",0)														--
				npc.Standin=true															--
				npc.Crouchin=false															--
			end                                                                             --
		end)																				--
		local timername="OPSQUADMover"..npc:EntIndex()	--										
		timer.Create(timername,7.5,0,function()	        	--
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then return end
			local npcpos=npc:GetPos()
			local Pos=npcpos+VectorRand()*1000
			if(math.random(1,3)==2)then Pos=npcpos+npc:GetForward()*500 end
			npc:SetLastPosition(Pos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc2=npc
	end)
	
	timer.Simple(0.1,function()
		local MyNodeBuffer={}
		local Nodes=4
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(-gunshipflyradius,gunshipflyradius,gunshipflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(-gunshipflyradius,-gunshipflyradius,gunshipflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(gunshipflyradius,-gunshipflyradius,gunshipflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(gunshipflyradius,gunshipflyradius,gunshipflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		
		local npc=ents.Create("npc_combinegunship")
		npc:SetPos(selfpos+gunshipspawnpos)
		npc:SetAngles(Angle(0,90,0))
		npc:Spawn()
		npc:SetMaxHealth(150)
		npc:SetHealth(150)
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:Fire("blindfireon","",0)
		npc:Fire("enablegroundattack","",0)
		npc.NeedsMoarFirePower=true
		npc.OPSQUADWillDropCombineTech=true
		npc.OPSQUADGunship=true
		local timername="OPSQUADWarspaceCannoneer"..npc:EntIndex()
		timer.Create(timername,40,0,function()	        	--
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then													--
				if(npc:GetEnemy():IsPlayer())and not(npc:GetEnemy():Alive())then return end --
				local name="AboutToGetFuckedUp"..npc:GetEnemy():EntIndex()
				npc:GetEnemy():SetName(name)                                       --                                            --
				npc:Fire("dogroundattack",name,0)		                                    --											--
			end																		     	--
		end)																				--	
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc3=npc
		
		for var = 1, Nodes,1  do
			MyNodeBuffer[var]:SetName(tostring(npc) .. tostring(var))
			npc:DeleteOnRemove(MyNodeBuffer[var])
		end
		for var = 1, Nodes,1  do
			if (var != Nodes) then
				MyNodeBuffer[var]:Fire("addoutput","OnPass !activator,SetTrack," ..  tostring(npc) .. tostring((var + 1)),1)
			else
				MyNodeBuffer[var]:Fire("addoutput","OnPass !activator,SetTrack," ..  tostring(npc) .. "1",1)
			end
		end
		
		local TrackName = tostring(npc) .. "1"
		npc:Fire("SetTrack",TrackName,0.1)
	end)
	
	timer.Simple(0.15,function()
		local MyNodeBuffer={}
		local Nodes=6
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(-helicopteroneflyradius,helicopteroneflyradius,helicopteroneflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(-helicopteronesecondaryflyradius,0,helicopteronesecondaryflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(-helicopteroneflyradius,-helicopteroneflyradius,helicopteroneflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(helicopteroneflyradius,-helicopteroneflyradius,helicopteroneflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(helicopteronesecondaryflyradius,0,helicopteronesecondaryflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(helicopteroneflyradius,helicopteroneflyradius,helicopteroneflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		
		local npc=ents.Create("npc_helicopter")
		npc:SetPos(selfpos+helicopteronespawnpos)

		npc:SetKeyValue("spawnflags","1376512") --256+65536+262144+1048576
		npc:Spawn()
		npc:SetMaxHealth(500)
		npc:SetHealth(500)
		npc.Damage=0
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:Fire("missileon","",0)
		npc:Fire("gunon","",0)
		npc.NeedsMoarFirePower=true
		npc.OPSQUADWillDropCombineTech=true
		npc.OPSQUADGunship=true
		local timername="OPSQUADBombDroppinMotherfucker"..npc:EntIndex()
		timer.Create(timername,4,0,function()	  	--
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then													--
				if(npc:GetEnemy():IsPlayer())and not(npc:GetEnemy():Alive())then return end --
				if(npc:GetEnemy():GetPos().z>npc:GetPos().z)then return end			
				local name="AboutToGetFuckedUp"..npc:GetEnemy():EntIndex()
				npc:GetEnemy():SetName(name)                                       --                                       --
				npc:Fire("dropbombattargetalways",name,0)		                            --
				npc:EmitSound("npc/attack_helicopter/aheli_mine_drop1.wav")
			end																		     	--
		end)
		local timername="OPSQUADInconsistentHelicopterMarksmanship"..npc:EntIndex() --
		timer.Create(timername,30,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local randum=math.random(1,2)
			local mudnar=math.random(1,2)
			if(randum==1)then
				npc:Fire("disabledeadlyshooting","",0)
			elseif(randum==2)then
				npc:Fire("enabledeadlyshooting","",0)
			end
			if(mudnar==1)then
				npc:Fire("startlongcycleshooting","",0)
			elseif(mudnar==2)then
				npc:Fire("startnormalshooting","",0)
			end
		end)
		local timername="OPSQUADHelicopterCarpetBombing"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if not(npc.CarpetBombing)then
				local randum=math.random(1,3)
				if(randum==3)then
					npc:Fire("startcarpetbombing","",0)
					npc.CarpetBombing=true
					timer.Simple(5,function()
						if(IsValid(npc))then
							npc:Fire("stopcarpetbombing","",0)
							npc.CarpetBombing=false
						end
					end)
				end
			end
		end)
		local timername="OPSQUADHelicopterBladeDamage"..npc:EntIndex()
		timer.Create(timername,0.1,0,function()
			if not(IsValid(npc))then
				timer.Destroy(timername)
				return
			end
			for key,found in pairs(ents.FindInSphere(npc:GetPos(),300))do
				if not(found.OPSQUADGunship)then
					if(found:IsPlayer())then
						if(found:Alive())then
							local HeliToVictimVector=(found:GetPos()-npc:GetPos()):GetNormalized()
							local DotProduct=HeliToVictimVector:DotProduct(npc:GetUp())
							local InspectionAngle=(-math.Rad2Deg(math.asin(DotProduct)))
							if(InspectionAngle<10)then --if you're aBOVE the helicopter's level
								local Kaschling=DamageInfo()
								Kaschling:SetDamage(50)
								Kaschling:SetDamageType(DMG_SLASH)
								Kaschling:SetDamagePosition(found:GetPos())
								Kaschling:SetDamageForce(VectorRand()*999999999*3) --9 nines
								Kaschling:SetAttacker(npc)
								Kaschling:SetInflictor(npc)
								found:TakeDamageInfo(Kaschling)
								
								npc:EmitSound("ambient/machines/slicer1.wav")
								npc:EmitSound("ambient/machines/slicer2.wav")
								found:EmitSound("ambient/machines/slicer1.wav")
								found:EmitSound("ambient/machines/slicer2.wav")
							end
						end
					elseif(found:IsNPC())then
						if(found:Health()>0)then
							local HeliToVictimVector=(found:GetPos()-npc:GetPos()):GetNormalized()
							local DotProduct=HeliToVictimVector:DotProduct(npc:GetUp())
							local InspectionAngle=(-math.Rad2Deg(math.asin(DotProduct)))
							if(InspectionAngle<10)then --if you're aBOVE the helicopter's level
								local Kaschling=DamageInfo()
								Kaschling:SetDamage(50)
								Kaschling:SetDamageType(DMG_SLASH)
								Kaschling:SetDamagePosition(found:GetPos())
								Kaschling:SetDamageForce(VectorRand()*999999999*3) --9 nines
								Kaschling:SetAttacker(npc)
								Kaschling:SetInflictor(npc)
								found:TakeDamageInfo(Kaschling)
								
								npc:EmitSound("ambient/machines/slicer1.wav")
								npc:EmitSound("ambient/machines/slicer2.wav")
								found:EmitSound("ambient/machines/slicer1.wav")
								found:EmitSound("ambient/machines/slicer2.wav")
							end
						end
					end
				end
			end
		end)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc4=npc
		
		for var = 1, Nodes,1  do
			MyNodeBuffer[var]:SetName(tostring(npc) .. tostring(var))
			npc:DeleteOnRemove(MyNodeBuffer[var])
		end
		for var = 1, Nodes,1  do
			if (var != Nodes) then
				MyNodeBuffer[var]:Fire("addoutput","OnPass !activator,SetTrack," ..  tostring(npc) .. tostring((var + 1)),1)
			else
				MyNodeBuffer[var]:Fire("addoutput","OnPass !activator,SetTrack," ..  tostring(npc) .. "1",1)
			end
		end
		
		local TrackName = tostring(npc) .. "1"
		npc:Fire("SetTrack",TrackName,0.1)
	end)
	
	timer.Simple(0.2,function()
		local MyNodeBuffer={}
		local Nodes=6
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(0,-helicoptertwosecondaryflyradius,helicoptertwosecondaryflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(helicoptertwoflyradius,-helicoptertwoflyradius,750))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(helicoptertwoflyradius,helicoptertwoflyradius,750))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(0,helicoptertwosecondaryflyradius,helicoptertwosecondaryflyheight))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(-helicoptertwoflyradius,helicoptertwoflyradius,750))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		local ent=ents.Create("path_track")
		ent:SetPos(selfpos+Vector(-helicoptertwoflyradius,-helicoptertwoflyradius,750))
		ent:Spawn()
		if(ent:IsInWorld())then table.insert(MyNodeBuffer,ent) end
		if not(ent:IsInWorld())then ent:Remove(); Nodes=Nodes-1  end
		
		local npc=ents.Create("npc_helicopter")
		npc:SetPos(selfpos+helicoptertwospawnpos)
		npc:SetAngles(Angle(0,180,0))
		npc:SetKeyValue("spawnflags","1376512") --256+65536+262144+1048576
		npc:Spawn()
		npc:SetMaxHealth(500)
		npc:SetHealth(500)
		npc.Damage=0
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:Fire("missileon","",0)
		npc:Fire("gunon","",0)
		npc.NeedsMoarFirePower=true
		npc.OPSQUADWillDropCombineTech=true
		npc.OPSQUADGunship=true
		timer.Simple(2,function()  --this is just to set the bombthrowing off the other heli's
			if(IsValid(npc))then
				local timername="OPSQUADBombDroppinMotherfucker"..npc:EntIndex()
				timer.Create(timername,4,0,function()	  	--
					if not(IsValid(npc))then timer.Destroy(timername) return end
					if(IsValid(npc:GetEnemy()))then													--
						if(npc:GetEnemy():IsPlayer())and not(npc:GetEnemy():Alive())then return end --
						if(npc:GetEnemy():GetPos().z>npc:GetPos().z)then return end
						local name="AboutToGetFuckedUp"..npc:GetEnemy():EntIndex()
						npc:GetEnemy():SetName(name)                                       --
						npc:Fire("dropbombattargetalways",name,0)	
						npc:EmitSound("npc/attack_helicopter/aheli_mine_drop1.wav")						--										--
					end																		     	--
				end)																				--
			end																						--
		end)
		local timername="OPSQUADInconsistentHelicopterMarksmanship"..npc:EntIndex()
		timer.Create(timername,30,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local randum=math.random(1,2)
			local mudnar=math.random(1,2)
			if(randum==1)then
				npc:Fire("disabledeadlyshooting","",0)
			elseif(randum==2)then
				npc:Fire("enabledeadlyshooting","",0)
			end
			if(mudnar==1)then
				npc:Fire("startlongcycleshooting","",0)
			elseif(mudnar==2)then
				npc:Fire("startnormalshooting","",0)
			end
		end)
		local timername="OPSQUADHelicoperCarpetBombing"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if not(npc.CarpetBombing)then
				local randum=math.random(1,3)
				if(randum==3)then
					npc:Fire("startcarpetbombing","",0)
					npc.CarpetBombing=true
					timer.Simple(5,function()
						if(IsValid(npc))then
							npc:Fire("stopcarpetbombing","",0)
							npc.CarpetBombing=false
						end
					end)
				end
			end
		end)
		local timername="OPSQUADHelicopterBladeDamage"..npc:EntIndex()
		timer.Create(timername,0.1,0,function()
			if not(IsValid(npc))then
				timer.Destroy(timername)
				return
			end
			for key,found in pairs(ents.FindInSphere(npc:GetPos(),300))do
				if not(found.OPSQUADGunship)then
					if(found:IsPlayer())then
						if(found:Alive())then
							local HeliToVictimVector=(found:GetPos()-npc:GetPos()):GetNormalized()
							local DotProduct=HeliToVictimVector:DotProduct(npc:GetUp())
							local InspectionAngle=(-math.Rad2Deg(math.asin(DotProduct)))
							if(InspectionAngle<10)then --if you're aBOVE the helicopter's level
								local Kaschling=DamageInfo()
								Kaschling:SetDamage(50)
								Kaschling:SetDamageType(DMG_SLASH)
								Kaschling:SetDamagePosition(found:GetPos())
								Kaschling:SetDamageForce(VectorRand()*999999999*3) --9 nines
								Kaschling:SetAttacker(npc)
								Kaschling:SetInflictor(npc)
								found:TakeDamageInfo(Kaschling)
								
								npc:EmitSound("ambient/machines/slicer1.wav")
								npc:EmitSound("ambient/machines/slicer2.wav")
								found:EmitSound("ambient/machines/slicer1.wav")
								found:EmitSound("ambient/machines/slicer2.wav")
							end
						end
					elseif(found:IsNPC())then
						if(found:Health()>0)then
							local HeliToVictimVector=(found:GetPos()-npc:GetPos()):GetNormalized()
							local DotProduct=HeliToVictimVector:DotProduct(npc:GetUp())
							local InspectionAngle=(-math.Rad2Deg(math.asin(DotProduct)))
							if(InspectionAngle<10)then --if you're aBOVE the helicopter's level
								local Kaschling=DamageInfo()
								Kaschling:SetDamage(50)
								Kaschling:SetDamageType(DMG_SLASH)
								Kaschling:SetDamagePosition(found:GetPos())
								Kaschling:SetDamageForce(VectorRand()*999999999*3) --9 nines
								Kaschling:SetAttacker(npc)
								Kaschling:SetInflictor(npc)
								found:TakeDamageInfo(Kaschling)
								
								npc:EmitSound("ambient/machines/slicer1.wav")
								npc:EmitSound("ambient/machines/slicer2.wav")
								found:EmitSound("ambient/machines/slicer1.wav")
								found:EmitSound("ambient/machines/slicer2.wav")
							end
						end
					end
				end
			end
		end)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc5=npc
		
		for var = 1, Nodes,1  do
			MyNodeBuffer[var]:SetName(tostring(npc) .. tostring(var))
			npc:DeleteOnRemove(MyNodeBuffer[var])
		end
		for var = 1, Nodes,1  do
			if (var != Nodes) then
				MyNodeBuffer[var]:Fire("addoutput","OnPass !activator,SetTrack," ..  tostring(npc) .. tostring((var + 1)),1)
			else
				MyNodeBuffer[var]:Fire("addoutput","OnPass !activator,SetTrack," ..  tostring(npc) .. "1",1)
			end
		end
		
		local TrackName = tostring(npc) .. "1"
		npc:Fire("SetTrack",TrackName,0.1)
	end)
	
	timer.Simple(0.25,function()
		undo.Create("Big Combine Opposition Squad")
			if(IsValid(npc1))then undo.AddEntity(npc1) end
			if(IsValid(npc2))then undo.AddEntity(npc2) end
			if(IsValid(npc3))then undo.AddEntity(npc3) end
			if(IsValid(npc4))then undo.AddEntity(npc4) end
			if(IsValid(npc5))then undo.AddEntity(npc5) end
			undo.SetPlayer(ply)
			undo.SetCustomUndoText("Undone Big Combine Opposition Squad")
		undo.Finish()
	end)
end


