AddCSLuaFile("shared.lua")
include('shared.lua')

local function HaveSchizophrenia(npc)
	if(math.random(1,15)==6)then
		npc:Fire("speakidleresponse","",0)
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

	local npc1
	local npc2
	local npc3
	local npc4
	local npc5
	local npc6

	local npc=ents.Create("npc_citizen")
	npc:SetPos(selfpos+Vector(20,-20,0))
	npc:SetAngles(Angle(0,-45,0))
	npc:SetKeyValue("additionalequipment","wep_jack_combine_ucsmg")
	npc:SetKeyValue("citizentype","3")
	npc:SetKeyValue("expressiontype","3")
	npc:SetKeyValue("spawnflags","524544") --256+524288(SF_CITIZEN_AMMORESUPPLIER)
	npc:SetKeyValue("ammosupply","AR2")
	npc:SetKeyValue("ammoamount","15")
	npc:SetMaxHealth(40)
	npc:SetHealth(40)
	npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
	npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
	npc:Spawn()
	npc.OPSQUADWillDropAR2Ammo=tue
	npc:Activate()
	npc.HasAJackyAllegiance=true
	if not(Hostile)then
		npc.JackyAllegiance="Human"
	else
		npc.JackyAllegiance="Rogues"
	end
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	//npc:Fire("startpatrolling","",10)
	npc:Fire("disableweaponpickup","",0)
	npc:Fire("setammoresupplieron","",0)
	
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)
	npc1=npc
	
	timer.Simple(0.05,function()
		local npc=ents.Create("npc_citizen")
		npc:SetPos(selfpos+Vector(20,20,0))
		npc:SetAngles(Angle(0,45,0))
		npc:SetKeyValue("additionalequipment","wep_jack_combine_amr")
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetKeyValue("spawnflags","256")
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc:Spawn()
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if not(Hostile)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Rogues"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		//npc:Fire("startpatrolling","",10)
		npc:Fire("disableweaponpickup","",0)

		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc2=npc
	end)
	
	timer.Simple(0.1,function()
		local npc=ents.Create("npc_citizen")
		npc:SetPos(selfpos+Vector(-20,20,0))
		npc:SetAngles(Angle(0,135,0))
		npc:SetKeyValue("additionalequipment","wep_jack_combine_br")
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetKeyValue("spawnflags","131328") --256+131072(SF_CITIZEN_MEDIC)
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc.SpottedEnemies={}
		npc:Spawn()
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if not(Hostile)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Rogues"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		//npc:Fire("startpatrolling","",10)
		npc:Fire("disableweaponpickup","",0)
		npc:Fire("setmedicon","",0)
		
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc3=npc
	end)
	
	timer.Simple(0.15,function()
		local npc=ents.Create("npc_citizen")
		npc:SetPos(selfpos+Vector(-20,-20,0))
		npc:SetAngles(Angle(0,-135,0))
		npc:SetKeyValue("additionalequipment","wep_jack_combine_ucsg")
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetKeyValue("spawnflags","256")
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc:Spawn()
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if not(Hostile)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Rogues"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		//npc:Fire("startpatrolling","",10)
		npc:Fire("disableweaponpickup","",0)

		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc4=npc
	end)
	
	timer.Simple(0.2,function()
		local npc=ents.Create("npc_citizen")
		npc:SetPos(selfpos+Vector(0,-40,0))
		npc:SetAngles(Angle(0,-135,0))
		npc:SetKeyValue("additionalequipment","wep_jack_combine_dmr")
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetKeyValue("spawnflags","256")
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc:Spawn()
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if not(Hostile)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Rogues"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		//npc:Fire("startpatrolling","",10)
		npc:Fire("disableweaponpickup","",0)

		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc5=npc
	end)
	
	timer.Simple(0.25,function()
		local npc=ents.Create("npc_citizen")
		npc:SetPos(selfpos+Vector(0,40,0))
		npc:SetAngles(Angle(0,-135,0))
		npc:SetKeyValue("additionalequipment","wep_jack_combine_sr")
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetKeyValue("spawnflags","256")
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc:Spawn()
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if not(Hostile)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Rogues"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		//npc:Fire("startpatrolling","",10)
		npc:Fire("disableweaponpickup","",0)

		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc6=npc
	end)
	
	timer.Simple(0.3,function()
		undo.Create("Combine-Armed Rebel Squad")
		undo.SetPlayer(ply)
		if(IsValid(npc1))then undo.AddEntity(npc1) end
		if(IsValid(npc2))then undo.AddEntity(npc2) end
		if(IsValid(npc3))then undo.AddEntity(npc3) end
		if(IsValid(npc4))then undo.AddEntity(npc4) end
		if(IsValid(npc5))then undo.AddEntity(npc5) end
		if(IsValid(npc6))then undo.AddEntity(npc6) end
		undo.SetCustomUndoText("Combine-Armed Rebel Squad")
		undo.Finish()
	end)
end

