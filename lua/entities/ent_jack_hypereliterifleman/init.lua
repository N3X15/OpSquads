AddCSLuaFile("shared.lua")
include('shared.lua')

local function EliteOverWatchPhysique(npc)
	local Tummy=npc:LookupBone("ValveBiped.Bip01_Spine")
	if(Tummy)then npc:SetNetworkedInt("InflateSize"..Tummy,-25) end
	local Chest=npc:LookupBone("ValveBiped.Bip01_Spine2")
	if(Chest)then npc:SetNetworkedInt("InflateSize"..Chest,0) end
	local LeftUpperArm=npc:LookupBone("ValveBiped.Bip01_L_UpperArm")
	if(LeftUpperArm)then npc:SetNetworkedInt("InflateSize"..LeftUpperArm,7) end
	local RightUpperArm=npc:LookupBone("ValveBiped.Bip01_R_UpperArm")
	if(RightUpperArm)then npc:SetNetworkedInt("InflateSize"..RightUpperArm,7) end
	local LeftForeArm=npc:LookupBone("ValveBiped.Bip01_L_ForeArm")
	if(LeftForeArm)then npc:SetNetworkedInt("InflateSize"..LeftForeArm,5) end
	local RightForeArm=npc:LookupBone("ValveBiped.Bip01_R_ForeArm")
	if(RightForeArm)then npc:SetNetworkedInt("InflateSize"..RightForeArm,5) end
	local LeftCalf=npc:LookupBone("ValveBiped.Bip01_L_Calf")
	if(LeftCalf)then npc:SetNetworkedInt("InflateSize"..LeftCalf,20) end
	local RightCalf=npc:LookupBone("ValveBiped.Bip01_R_Calf")
	if(RightCalf)then npc:SetNetworkedInt("InflateSize"..RightCalf,20) end
	//local Neck=npc:LookupBone("ValveBiped.Bip01_Neck1")
	//if(Neck)then npc:SetNetworkedInt("InflateSize"..Neck,-50) end
end

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	local Friendly=false
	if(ply:KeyDown(IN_USE))then
		Friendly=true
	end
	

	local npc=ents.Create("npc_combine_s")
	npc:SetPos(selfpos)
	npc:SetAngles(Angle(0,45,0))
	npc:SetKeyValue("additionalequipment","weapon_ar2")
	npc:SetKeyValue("model","models/combine_super_soldier.mdl")
	npc:SetKeyValue("spawnflags","256")
	npc:SetMaxHealth(40)
	npc:SetHealth(40)
	npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
	npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
	npc.SpottedEnemies={}
	npc:Spawn()
	npc:SetMaterial("models/combine/cyclops")
	npc.OPSQUADWillDropAR2Ammo=true
	npc.OPSQUADWillDropIonBalls=true
	npc.CanShootWellAtVitalAreas=true
	npc.HasAdvancedCombineBodyArmor=true
	npc:SetBloodColor(-1)
	npc.HasAnAdvancedCombineHelmet=true
	npc.HasBadassCyclopsSkin=true
	npc:Activate()
	EliteOverWatchPhysique(npc)
	npc.HasAJackyAllegiance=true
	if(Friendly)then
		npc.JackyAllegiance="Human"
	else
		npc.JackyAllegiance="Combine"
	end
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
	npc:Fire("startpatrolling","",10)
	npc.NextHealTime=CurTime()
	local timername="OPSQUADIonBaller"..npc:EntIndex()
	timer.Create(timername,5,0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		local Enemy=npc:GetEnemy()
		if(IsValid(Enemy))then
			local LoSTraceData={}
			LoSTraceData.start=npc:LocalToWorld(npc:OBBCenter())
			LoSTraceData.endpos=Enemy:LocalToWorld(Enemy:OBBCenter())
			LoSTraceData.filter={Enemy,npc}
			local LoSTrace=util.TraceLine(LoSTraceData)
			if not(LoSTrace.Hit)then
				Enemy:SetName("AboutToGetFuckedUp"..Enemy:EntIndex())
				npc:Fire("throwgrenadeattarget","AboutToGetFuckedUp"..Enemy:EntIndex())
			end
		end
	end)
	local timername="AmazingHunter"..npc:EntIndex()
	timer.Create(timername,0.5,0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		local CurrentEnemy=npc:GetEnemy()
		if(IsValid(CurrentEnemy))then
			if not(table.HasValue(npc.SpottedEnemies,CurrentEnemy))then
				table.ForceInsert(npc.SpottedEnemies,CurrentEnemy)
			end
		end
		table.foreach(npc.SpottedEnemies,function(key,creature)
			if(IsValid(creature))then
				if not(creature:Health()>0)then
					table.remove(npc.SpottedEnemies,key)
				end
			else
				table.remove(npc.SpottedEnemies,key)
			end
		end)
		for key,target in pairs(ents.GetAll())do --amazing tracking abilities
			if((target:IsNPC())or(target:IsPlayer()))then
				if(table.HasValue(npc.SpottedEnemies,target))then
					if((target:Health()>0)and not(npc:GetEnemy()==target))then
						npc:UpdateEnemyMemory(target,target:GetPos())
					end
				end
			end
		end
		for key,found in pairs(ents.GetAll())do --fucking eagle eyes
			if((found:IsNPC())or(found:IsPlayer()))then
				if(npc:Disposition(found)==1)then
					if not(IsValid(npc:GetEnemy()))then
						local enemypos=found:GetPos()
						local LoSTraceData={}
						LoSTraceData.start=npc:GetPos()+Vector(0,0,10)
						LoSTraceData.endpos=enemypos+Vector(0,0,10)
						LoSTraceData.filter={found,npc}
						local LoSTrace=util.TraceLine(LoSTraceData)
						if not(LoSTrace.Hit)then
							if(found:Health()>0)then
								npc:UpdateEnemyMemory(found,enemypos)
							end
						end
					end
				end
			end
		end
	end)
	local timername="OPSQUADIntelligentGunfighter"..npc:EntIndex()	--										
	timer.Create(timername,1,0,function()	        	--
		if not(IsValid(npc))then timer.Destroy(timername) return end
		if not(IsValid(npc:GetEnemy()))then return end
		local NumberOfCreeps=0
		for key,found in pairs(ents.FindInSphere(npc:GetPos(),100))do
			if((found:IsNPC())or(found:IsPlayer()))then
				if(npc:Disposition(found)==1)then
					NumberOfCreeps=NumberOfCreeps+1
				end
			end
		end
		if(NumberOfCreeps>1)then
			local selfpos=npc:GetPos()
			local newpos=selfpos+((selfpos-npc:GetEnemy():GetPos()):GetNormalized())*500
			local checkdat={}
			checkdat.start=selfpos
			checkdat.endpos=newpos
			checkdat.filter=npc
			local check=util.TraceLine(checkdat)
			if(check.Hit)then
				newpos=selfpos+VectorRand()*750
			end
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end
	end)
	local timername="AutoMedic"..npc:EntIndex()
	timer.Create(timername,1,0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		local Helth=npc:Health()
		local MexHalth=npc:GetMaxHealth()
		if(not(IsValid(npc:GetEnemy()))and(Helth<MexHalth))then
			if(npc.NextHealTime<CurTime())then
				npc:SetHealth(Helth+1)
				npc:EmitSound("lolsounds/cyborgheal.wav",60,100)
				npc:SetSequence(16)
			end
		else
			npc.NextHealTime=CurTime()+5
		end
	end)
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)

	undo.Create("JackyHyperEliteRifleman")
		undo.AddEntity(npc)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone HyperElite Combine")
	undo.Finish()

end


