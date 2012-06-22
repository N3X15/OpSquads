AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	local Friendly=false
	if(ply:KeyDown(IN_USE))then
		Friendly=true
	end
	
	local MyNodeBuffer={}
	local Nodes=50
	local CheckPosition=selfpos+Vector(0,0,300)
	local CheckEntity=nil
	for i=1,50 do
		local ent=ents.Create("path_track")
		if(math.random(1,7)==1)then
			ent:SetPos(Vector(math.Rand(-15000,15000),math.Rand(-15000,15000),math.Rand(selfpos.z+3000,selfpos.z+15000)))
		else
			ent:SetPos(Vector(math.Rand(-15000,15000),math.Rand(-15000,15000),math.Rand(selfpos.z+750,selfpos.z+3000)))
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
	
	local npc=ents.Create("npc_combinegunship")
	npc:SetPos(selfpos+Vector(0,0,300))
	npc:SetAngles(Angle(0,90,0))
	npc:SetKeyValue("spawnflags","256")
	npc:Spawn();npc:SetKeyValue("SquadName","InstantCombineOpposition");npc.InAJackyCombineSquad=true
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
	npc:Fire("missileon","",0)
	npc:Fire("enablegroundattack","",0)
	npc.NeedsMoarFirePower=true
	npc.OPSQUADWillDropCombineTech=true
	npc.OPSQUADGunship=true
	timer.Create("OPSQUADWarspaceCannoneer"..npc:EntIndex(),40,0,function()	        	--
		if not(IsValid(npc))then timer.Destroy("OPSQUADWarspaceCannoneer"..npc:EntIndex()) return end
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

	undo.Create("JackyCombineGunship")
		undo.AddEntity(npc)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone Combine Gunship")
	undo.Finish()

end


