AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	local Friendly=false
	if(ply:KeyDown(IN_USE))then
		Friendly=true
	end
	
	util.PrecacheModel("models/combine_helicopter.mdl")
	
	local MyNodeBuffer={}
	local Nodes=50
	local CheckPosition=selfpos+Vector(0,0,300)
	local CheckEntity=nil
	for i=1,50 do
		local ent=ents.Create("path_track")
		if(math.random(1,7)==1)then
			ent:SetPos(Vector(math.Rand(-15000,15000),math.Rand(-15000,15000),math.Rand(selfpos.z+2500,selfpos.z+15000)))
		else
			ent:SetPos(Vector(math.Rand(-15000,15000),math.Rand(-15000,15000),math.Rand(selfpos.z+300,selfpos.z+1000)))
		end
		ent:Spawn()
		local CheckTraceData={}
		CheckTraceData.start=ent:GetPos()
		CheckTraceData.endpos=CheckPosition
		CheckTraceData.filter={ent,CheckEntity}
		local CheckTrace=util.TraceLine(CheckTraceData)
		if not(CheckTrace.Hit)then 
			table.insert(MyNodeBuffer,ent)
			CheckPosition=ent:GetPos()
			CheckEntity=ent
		else
			ent:Remove()
			Nodes=Nodes-1
		end
	end
	
	local npc=ents.Create("npc_helicopter")
	npc:SetPos(selfpos+Vector(0,0,300))
	npc:SetKeyValue("spawnflags","1376512") --256+65536+262144+1048576
	npc:Spawn();npc:SetKeyValue("SquadName","InstantCombineOpposition");npc.InAJackyCombineSquad=true
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
	npc:Fire("choosenearestpathpoint","",0)
	npc:Fire("startbreakablemovement","",0)
	npc:Fire("startsprinklebehavior","",0)
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
	local timername="OPSQUADInconsistentHelicopterMarksmanship"..npc:EntIndex()		--
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
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)
	
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

	undo.Create("JackyHunterCopter")
		undo.AddEntity(npc)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone Combine HunterCopter")
	undo.Finish()

end


