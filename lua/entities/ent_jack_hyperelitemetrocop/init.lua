AddCSLuaFile("shared.lua")
include('shared.lua')

function JACK_MetrocopPhysique(npc)
	local Tummy=npc:LookupBone("ValveBiped.Bip01_Spine")
	if(Tummy)then npc:SetNetworkedInt("InflateSize"..Tummy,-16) end
	local Chest=npc:LookupBone("ValveBiped.Bip01_Spine2")
	if(Chest)then npc:SetNetworkedInt("InflateSize"..Chest,7) end
	local LeftUpperArm=npc:LookupBone("ValveBiped.Bip01_L_UpperArm")
	if(LeftUpperArm)then npc:SetNetworkedInt("InflateSize"..LeftUpperArm,12) end
	local RightUpperArm=npc:LookupBone("ValveBiped.Bip01_R_UpperArm")
	if(RightUpperArm)then npc:SetNetworkedInt("InflateSize"..RightUpperArm,12) end
	local LeftForeArm=npc:LookupBone("ValveBiped.Bip01_L_ForeArm")
	if(LeftForeArm)then npc:SetNetworkedInt("InflateSize"..LeftForeArm,9) end
	local RightForeArm=npc:LookupBone("ValveBiped.Bip01_R_ForeArm")
	if(RightForeArm)then npc:SetNetworkedInt("InflateSize"..RightForeArm,9) end
	local RightHand=npc:LookupBone("ValveBiped.Bip01_R_Hand")
	if(RightHand)then npc:SetNetworkedInt("InflateSize"..RightHand,5) end
	local LeftHand=npc:LookupBone("ValveBiped.Bip01_L_Hand")
	if(LeftHand)then npc:SetNetworkedInt("InflateSize"..LeftHand,5) end
	local LeftCalf=npc:LookupBone("ValveBiped.Bip01_L_Calf")
	if(LeftCalf)then npc:SetNetworkedInt("InflateSize"..LeftCalf,30) end
	local RightCalf=npc:LookupBone("ValveBiped.Bip01_R_Calf")
	if(RightCalf)then npc:SetNetworkedInt("InflateSize"..RightCalf,30) end
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
	
	local npc = JACK_Spawn_EliteMetrocop(selfpos)
	if(Friendly)then
		npc.JackyAllegiance="Human"
	else
		npc.JackyAllegiance="Combine"
	end
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)

	undo.Create("JackyEliteCP")
		undo.AddEntity(npc)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone HyperElite Combine")
	undo.Finish()
end

function JACK_Spawn_EliteMetrocop(selfpos)
	local npc=ents.Create("npc_metropolice")
	npc:SetPos(selfpos)
	npc:SetKeyValue("additionalequipment","wep_jack_combinesuperpistol")
	npc:SetKeyValue("model","models/combine_soldier.mdl")
	npc:SetKeyValue("spawnflags","256")
	npc:SetMaxHealth(45)
	npc:SetHealth(45)
	npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
	npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
	npc.SpottedEnemies={}
	npc.HasAJackyAllegiance=true
	npc:SetKeyValue("SquadName","Combine")
	npc:Spawn()
	//npc:SetKeyValue("manhacks","2")
	npc:SetMaterial("models/combine/badass_sheet")
	npc.HasBadassMetrocopSkin=true
	npc.CanShootExtraordinarilyWellAtVitalAreas=true
	npc.HasAdvancedCombineBodyArmor=true
	npc:SetBloodColor(-1)
	npc.HasAnAdvancedCombineHelmet=true
	npc.OPSQUADWillDropAR2Ammo=true
	npc.WillMoveWhenShot=true
	npc.IsAFuckingBeast=true
	npc.IsAHyperEliteMetrocop=true
	npc:Activate()
	//npc:Fire("EnableManhackToss","1",0)
	JACK_MetrocopPhysique(npc)
	npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
	npc:Fire("startpatrolling","",10)
	JACK_SetupAmazingHunter(npc)
	JACK_SetupIntelligentGunfighter(npc)
	JACK_SetupAutomedic(npc)
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)
	
	//npc:SetNoDraw(true) --THE METROCOP NEEDS THE SUPERPISTOL WEAPON IN ORDER TO WORK RIGHT
	
	//for i=0, npc:GetBoneCount() - 1 do
	//	print(npc:GetBoneName(i)) --DEBUG: GOTTA SEE SOME MOAR STUFF
	//end
	return npc
end

local function GitGoin(ent,inflictor,attacker,dmginfo)
	if(ent.WillMoveWhenShot)then
		local Dist=(ent:GetPos()-attacker:GetPos()):Length()
		if(Dist>1500)then
			local NewPos=ent:GetPos()+VectorRand()*750
			ent:SetLastPosition(NewPos)
			ent:SetSchedule(SCHED_FORCED_GO_RUN)
		end
	end
end
hook.Add("EntityTakeDamage","JackysIntelligenceForNPCs",GitGoin)


