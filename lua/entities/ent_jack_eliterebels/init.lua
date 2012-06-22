AddCSLuaFile("shared.lua")
include('shared.lua')

local ModelTable={
	"models/Jumans/Group03/Male_01.mdl",
	"models/Jumans/Group03/male_02.mdl",
	"models/Jumans/Group03/male_03.mdl",
	"models/Jumans/Group03/Male_04.mdl",
	"models/Jumans/Group03/Male_05.mdl",
	"models/Jumans/Group03/male_06.mdl",
	"models/Jumans/Group03/male_07.mdl",
	"models/Jumans/Group03/male_08.mdl",
	"models/Jumans/Group03/male_09.mdl"
}

local MedicModelTable={
	"models/Jumans/Group03m/Male_01.mdl",
	"models/Jumans/Group03m/male_02.mdl",
	"models/Jumans/Group03m/male_03.mdl",
	"models/Jumans/Group03m/Male_04.mdl",
	"models/Jumans/Group03m/Male_05.mdl",
	"models/Jumans/Group03m/male_06.mdl",
	"models/Jumans/Group03m/male_07.mdl",
	"models/Jumans/Group03m/male_08.mdl",
	"models/Jumans/Group03m/male_09.mdl"
}

local function HaveSchizophrenia(npc)
	if(math.random(1,15)==6)then
		npc:Fire("speakidleresponse","",0)
	end
end

local function ClearLoSBetween(npc1,npc2)
	local TrDat={}
	TrDat.start=npc1:GetPos()+Vector(0,0,50)
	TrDat.endpos=npc2:GetPos()+Vector(0,0,20)
	TrDat.filter={npc1,npc2}
	local Tr=util.TraceLine(TrDat)
	if not(Tr.Hit)then
		return true
	else
		return false
	end
end

function ENT:SpawnFunction(ply, tr)

	//524288(SF_CITIZEN_AMMORESUPPLIER)
	//131072(SF_CITIZEN_MEDIC)
	
	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	local Hostile=false
	if(ply:KeyDown(IN_USE))then
		Hostile=true
	end
	
	local Hos

	local npc1
	local npc2
	local npc3
	local npc4
	
	local model1=ModelTable[math.random(1,9)]
	local model3=ModelTable[math.random(1,9)]
	while(model3==model1)do
		model3=ModelTable[math.random(1,9)]
	end
	local model2=MedicModelTable[math.random(1,9)]
	local model4=MedicModelTable[math.random(1,9)]
	while(model4==model3)do
		model4=MedicModelTable[math.random(1,9)]
	end

	local npc=ents.Create("npc_citizen")
	npc:SetPos(selfpos+Vector(20,-20,0))
	npc:SetAngles(Angle(0,-45,0))
	npc:SetKeyValue("additionalequipment","weapon_smg1")
	npc:SetKeyValue("citizentype","3")
	npc:SetKeyValue("expressiontype","3")
	npc:SetKeyValue("spawnflags","524544") --256+524288(SF_CITIZEN_AMMORESUPPLIER)
	npc:SetKeyValue("ammosupply","SMG1_Grenade")
	npc:SetKeyValue("ammoamount","1")
	npc:SetMaxHealth(40)
	npc:SetHealth(40)
	npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
	npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
	npc.SpottedEnemies={}
	npc:Spawn()
	npc.OPSQUADWillDropSMGAmmo=true
	npc.OPSQUADWillDropSMGGrenade=true
	npc.CanShootExceptionallyWellAtVitalAreas=true
	npc.IsUsingAmericanAmmunition=true
	npc.IsUsingAnHKWeapon=true
	npc.HasAmericanBodyArmor=true
	npc:SetBloodColor(-1)
	npc:Activate()
	npc.HasAJackyAllegiance=true
	if not(Hostile)then
		npc.JackyAllegiance="Human"
	else
		npc.JackyAllegiance="Rogues"
	end
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	npc:SetModel(model1)
	MilitaryPhysique(npc)
	npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
	//npc:Fire("startpatrolling","",10)
	npc:Fire("disableweaponpickup","",0)
	npc.NextGiveTime=CurTime()+math.Rand(10,60)
	npc:Fire("setammoresupplieroff","",0)
	npc:AddRelationship("npc_turret_floor D_FR 90")
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
				if(npc:Disposition(found)==2)then
					if not(IsValid(npc:GetEnemy()))then
						local enemypos=found:GetPos()
						if(ClearLoSBetween)then
							if(found:Health()>0)then
								npc:UpdateEnemyMemory(found,enemypos)
							end
						end
					end
				end
			end
		end
	end)
	local timername="PrioritizeYouRetardedJackass"..npc:EntIndex()
	timer.Create(timername,1,0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		local current=npc:GetEnemy()
		if(IsValid(current))then
			npc:Fire("setammoresupplieroff","",0)
		else
			if(npc.NextGiveTime<CurTime())then
				if not(Hostile)then
					npc:Fire("setammoresupplieron","",0)
				end
			end
			HaveSchizophrenia(npc)
		end
	end)
	local timername="OPSQUADIntelligentGunfighter"..npc:EntIndex()	--										
	timer.Create(timername,1,0,function()	        	--
		if not(IsValid(npc))then timer.Destroy(timername) return end
		if not(IsValid(npc:GetEnemy()))then return end
		local NumberOfCreeps=0
		for key,found in pairs(ents.FindInSphere(npc:GetPos(),100))do
			if((found:IsNPC())or(found:IsPlayer()))then
				if(npc:Disposition(found)==2)then
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
	local timername="OPSQUADStickTogether"..npc:EntIndex()
	timer.Create(timername,math.Rand(10,20),0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		if(IsValid(npc:GetEnemy()))then return end
		local dudes=ents.FindByClass("npc_citizen")
		local NumberOfDudes=table.Count(dudes)
		local dude=dudes[math.random(1,NumberOfDudes)]
		if(IsValid(dude))then
			local dir=(dude:GetPos()-npc:GetPos()):GetNormalized()
			local newpos=npc:GetPos()+dir*490
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO)
		end
	end)

	//for i=0, npc:GetBoneCount() - 1 do
	//	print(npc:GetBoneName(i)) --DEBUG: GOTTA SEE SOME MOAR STUFF
	//end
	
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)
	npc1=npc
	
	timer.Simple(0.1,function()
		local npc=ents.Create("npc_citizen")
		npc:SetPos(selfpos+Vector(20,20,0))
		npc:SetAngles(Angle(0,45,0))
		npc:SetKeyValue("additionalequipment","weapon_annabelle")
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetKeyValue("spawnflags","131328") --256+131072(SF_CITIZEN_MEDIC)
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc.SpottedEnemies={}
		npc:Spawn()
		npc.OPSQUADWillDropRevolverAmmo=true
		npc.OPSQUADWillDropHealthVial=true
		npc.OPSQUADWillDropHealthKit=true
		npc.CanShootExceptionallyWellAtVitalAreas=true
		npc.IsUsingABeastWeapon=true
		npc.IsUsingAmericanAmmunition=true
		npc.HasAmericanBodyArmor=true
		npc:SetBloodColor(-1)
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if not(Hostile)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Rogues"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetModel(model2)
		MilitaryPhysique(npc)
		npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
		//npc:Fire("startpatrolling","",10)
		npc:Fire("disableweaponpickup","",0)
		npc:AddRelationship("npc_turret_floor D_FR 90")
		local timername="AmazingHunter"..npc:EntIndex()
		timer.Create(timername,2,0,function()
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
					if(npc:Disposition(found)==2)then
						if not(IsValid(npc:GetEnemy()))then
							local enemypos=found:GetPos()
							if(ClearLoSBetween(npc,found))then
								if(found:Health()>0)then
									npc:UpdateEnemyMemory(found,enemypos)
								end
							end
						end
					end
				end
			end
		end)
		local timername="PrioritizeYouRetardedJackass"..npc:EntIndex()
		timer.Create(timername,2,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then
				npc:Fire("setmedicoff","",0)
			else
				if not(Hostile)then
					npc:Fire("setmedicon","",0)
				end
				HaveSchizophrenia(npc)
			end
		end)
		local timername="OPSQUADIntelligentGunfighter"..npc:EntIndex()	--										
		timer.Create(timername,1,0,function()	        	--
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if not(IsValid(npc:GetEnemy()))then return end
			local NumberOfCreeps=0
			for key,found in pairs(ents.FindInSphere(npc:GetPos(),100))do
				if((found:IsNPC())or(found:IsPlayer()))then
					if(npc:Disposition(found)==2)then
						NumberOfCreeps=NumberOfCreeps+1
					end
				end
			end
			if(NumberOfCreeps>0)then
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
		local timername="OPSQUADStickTogether"..npc:EntIndex()
		timer.Create(timername,math.Rand(10,20),0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then return end
			local dudes=ents.FindByClass("npc_citizen")
			local NumberOfDudes=table.Count(dudes)
			local dude=dudes[math.random(1,NumberOfDudes)]
			if(IsValid(dude))then
				local dir=(dude:GetPos()-npc:GetPos()):GetNormalized()
				local newpos=npc:GetPos()+dir*490
				npc:SetLastPosition(newpos)
				npc:SetSchedule(SCHED_FORCED_GO)
			end
		end)

		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc2=npc
	end)
	
	timer.Simple(0.2,function()
		local npc=ents.Create("npc_citizen")
		npc:SetPos(selfpos+Vector(-20,20,0))
		npc:SetAngles(Angle(0,135,0))
		npc:SetKeyValue("additionalequipment","weapon_smg1")
		npc.IsTrainedWithRocketLaunchers=true
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetKeyValue("spawnflags","524544") --256+524288(SF_CITIZEN_AMMORESUPPLIER)
		npc:SetKeyValue("ammosupply","smg1")
		npc:SetKeyValue("ammoamount","45")
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc.SpottedEnemies={}
		npc:Spawn()
		npc.OPSQUADWillDropSMGAmmo=true
		npc.CanShootExceptionallyWellAtVitalAreas=true
		npc.IsUsingAmericanAmmunition=true
		npc.IsUsingAnHKWeapon=true
		npc.HasAmericanBodyArmor=true
		npc:SetBloodColor(-1)
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if not(Hostile)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Rogues"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetModel(model3)
		MilitaryPhysique(npc)
		npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
		//npc:Fire("startpatrolling","",10)
		npc:Fire("disableweaponpickup","",0)
		npc.NextGiveTime=CurTime()+math.Rand(10,45)
		npc:Fire("setammoresupplieroff","",0)
		npc:AddRelationship("npc_turret_floor D_FR 90")
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
					if(npc:Disposition(found)==2)then
						if not(IsValid(npc:GetEnemy()))then
							local enemypos=found:GetPos()
							if(ClearLoSBetween(npc,found))then
								if(found:Health()>0)then
									npc:UpdateEnemyMemory(found,enemypos)
								end
							end
						end
					end
				end
			end
		end)
		local timername="PrioritizeYouRetardedJackass"..npc:EntIndex()
		timer.Create(timername,1,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then
				npc:Fire("setammoresupplieroff","",0)
			else
				if(npc.NextGiveTime<CurTime())then
					if not(Hostile)then
						npc:Fire("setammoresupplieron","",0)
					end
				end
				HaveSchizophrenia(npc)
			end
		end)
		local timername="OPSQUADIntelligentGunfighter"..npc:EntIndex()	--										
		timer.Create(timername,1,0,function()	        	--
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if not(IsValid(npc:GetEnemy()))then return end
			local NumberOfCreeps=0
			for key,found in pairs(ents.FindInSphere(npc:GetPos(),100))do
				if((found:IsNPC())or(found:IsPlayer()))then
					if(npc:Disposition(found)==2)then
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
		local timername="OPSQUADStickTogether"..npc:EntIndex()
		timer.Create(timername,math.Rand(10,20),0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then return end
			local dudes=ents.FindByClass("npc_citizen")
			local NumberOfDudes=table.Count(dudes)
			local dude=dudes[math.random(1,NumberOfDudes)]
			if(IsValid(dude))then
				local dir=(dude:GetPos()-npc:GetPos()):GetNormalized()
				local newpos=npc:GetPos()+dir*490
				npc:SetLastPosition(newpos)
				npc:SetSchedule(SCHED_FORCED_GO)
			end
		end)
		
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc3=npc
	end)
	
	timer.Simple(0.3,function()
		local npc=ents.Create("npc_citizen")
		npc:SetPos(selfpos+Vector(-20,-20,0))
		npc:SetAngles(Angle(0,-135,0))
		npc:SetKeyValue("additionalequipment","wep_jack_rocketlauncher")
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetKeyValue("spawnflags","131328") --256+131072(SF_CITIZEN_MEDIC)
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc.SpottedEnemies={}
		npc:Spawn()
		npc.OPSQUADWillDropSMGAmmo=true
		npc.OPSQUADWillDropHealthVial=true
		npc.OPSQUADWillDropHealthKit=true
		npc.IsTrainedWithRocketLaunchers=true
		npc.IsUsingAmericanAmmunition=true
		npc.HasAmericanBodyArmor=true
		npc:SetBloodColor(-1)
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if not(Hostile)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Rogues"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetModel(model4)
		MilitaryPhysique(npc)
		npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
		//npc:Fire("startpatrolling","",10)
		npc:Fire("disableweaponpickup","",0)
		npc:AddRelationship("npc_turret_floor D_FR 90")
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
					if(npc:Disposition(found)==2)then
						if not(IsValid(npc:GetEnemy()))then
							local enemypos=found:GetPos()
							if(ClearLoSBetween(npc,found))then
								if(found:Health()>0)then
									npc:UpdateEnemyMemory(found,enemypos)
								end
							end
						end
					end
				end
			end
		end)
		local timername="PrioritizeYouRetardedJackass"..npc:EntIndex()
		timer.Create(timername,1,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then
				npc:Fire("setmedicoff","",0)
			else
				if not(Hostile)then
					npc:Fire("setmedicon","",0)
				end
				HaveSchizophrenia(npc)
			end
		end)
		local timername="OPSQUADIntelligentGunfighter"..npc:EntIndex()	--										
		timer.Create(timername,1,0,function()	        	--
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if not(IsValid(npc:GetEnemy()))then return end
			local NumberOfCreeps=0
			for key,found in pairs(ents.FindInSphere(npc:GetPos(),100))do
				if((found:IsNPC())or(found:IsPlayer()))then
					if(npc:Disposition(found)==2)then
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
		local timername="OPSQUADStickTogether"..npc:EntIndex()
		timer.Create(timername,math.Rand(10,20),0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then return end
			local dudes=ents.FindByClass("npc_citizen")
			local NumberOfDudes=table.Count(dudes)
			local dude=dudes[math.random(1,NumberOfDudes)]
			if(IsValid(dude))then
				local dir=(dude:GetPos()-npc:GetPos()):GetNormalized()
				local newpos=npc:GetPos()+dir*490
				npc:SetLastPosition(newpos)
				npc:SetSchedule(SCHED_FORCED_GO)
			end
		end)

		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc4=npc
	end)
	
	timer.Simple(0.4,function()
		undo.Create("Elite Rebel Squad")
		undo.SetPlayer(ply)
		if(IsValid(npc1))then undo.AddEntity(npc1) end
		if(IsValid(npc2))then undo.AddEntity(npc2) end
		if(IsValid(npc3))then undo.AddEntity(npc3) end
		if(IsValid(npc4))then undo.AddEntity(npc4) end
		undo.SetCustomUndoText("Undone Elite Rebel Squad")
		undo.Finish()
	end)
end

function MilitaryPhysique(npc)
	local Tummy=npc:LookupBone("ValveBiped.Bip01_Spine")
	if(Tummy)then npc:SetNetworkedInt("InflateSize"..Tummy,-21) end
	local Chest=npc:LookupBone("ValveBiped.Bip01_Spine2")
	if(Chest)then npc:SetNetworkedInt("InflateSize"..Chest,6) end
	local LeftUpperArm=npc:LookupBone("ValveBiped.Bip01_L_UpperArm")
	if(LeftUpperArm)then npc:SetNetworkedInt("InflateSize"..LeftUpperArm,7) end
	local RightUpperArm=npc:LookupBone("ValveBiped.Bip01_R_UpperArm")
	if(RightUpperArm)then npc:SetNetworkedInt("InflateSize"..RightUpperArm,7) end
	local LeftForeArm=npc:LookupBone("ValveBiped.Bip01_L_ForeArm")
	if(LeftForeArm)then npc:SetNetworkedInt("InflateSize"..LeftForeArm,5) end
	local RightForeArm=npc:LookupBone("ValveBiped.Bip01_R_ForeArm")
	if(RightForeArm)then npc:SetNetworkedInt("InflateSize"..RightForeArm,5) end
	local LeftCalf=npc:LookupBone("ValveBiped.Bip01_L_Calf")
	if(LeftCalf)then npc:SetNetworkedInt("InflateSize"..LeftCalf,15) end
	local RightCalf=npc:LookupBone("ValveBiped.Bip01_R_Calf")
	if(RightCalf)then npc:SetNetworkedInt("InflateSize"..RightCalf,15) end
	//local Neck=npc:LookupBone("ValveBiped.Bip01_Neck1")
	//if(Neck)then npc:SetNetworkedInt("InflateSize"..Neck,-50) end
end

