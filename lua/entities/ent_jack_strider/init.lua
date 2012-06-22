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


	undo.Create("JackyStrider")
		undo.AddEntity(npc)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone Combine Strider")
	undo.Finish()

end


