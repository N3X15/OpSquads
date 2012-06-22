AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	util.PrecacheModel("models/zombie/classic.mdl")
	util.PrecacheModel("models/zombie/fast_torso.mdl")
	util.PrecacheModel("models/zombie/fast.mdl")
	util.PrecacheModel("models/zombie/zombie_soldier.mdl")
	util.PrecacheModel("models/zombie/classic_torso.mdl")
	
	local npc1
	local npc2
	local npc3
	local npc4
	local npc5
	local npc6
	local npc7
	local npc8
	local npc9
	
	local npc=ents.Create("npc_zombine")
	npc:SetPos(selfpos)
	npc:SetMaterial("models/flesh")
	npc:SetColor(200,200,200,255)
	npc.IsDeathZombie=true
	npc:SetKeyValue("spawnflags","512")
	npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
	npc:Activate()
	npc.HasAJackyAllegiance=true
	npc.JackyAllegiance="Demon"
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	npc:SetBloodColor(BLOOD_COLOR_RED)
	npc:SetMaxHealth(npc:Health()*4)
	npc:SetHealth(npc:GetMaxHealth())
	npc:SetBodygroup(1,0)
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)
	npc1=npc
	
	timer.Simple(0.05,function()
		local npc=ents.Create("npc_zombie")
		npc:SetPos(selfpos+Vector(100,0,0))
		npc:SetMaterial("models/flesh")
		npc:SetColor(200,200,200,255)
		npc.IsDeathZombie=true
		npc:SetKeyValue("spawnflags","512")
		npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
		npc:Activate()
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Demon"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetBloodColor(BLOOD_COLOR_RED)
		npc:SetMaxHealth(npc:Health()*4)
		npc:SetHealth(npc:GetMaxHealth())
		npc:SetBodygroup(1,0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc2=npc
	end)
	
	timer.Simple(0.1,function()
		local npc=ents.Create("npc_fastzombie_torso")
		npc:SetPos(selfpos+Vector(50,50,0))
		npc:SetAngles(Angle(0,45,0))
		npc:SetMaterial("models/flesh")
		npc:SetColor(200,200,200,255)
		npc.IsDeathZombie=true
		npc:SetKeyValue("spawnflags","512")
		npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
		npc:Activate()
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Demon"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetBloodColor(BLOOD_COLOR_RED)
		npc:SetMaxHealth(npc:Health()*4)
		npc:SetHealth(npc:GetMaxHealth())
		npc:SetBodygroup(1,0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc3=npc
	end)
	
	timer.Simple(0.15,function()
		local npc=ents.Create("npc_fastzombie")
		npc:SetPos(selfpos+Vector(0,100,0))
		npc:SetAngles(Angle(0,90,0))
		npc:SetMaterial("models/flesh")
		npc:SetColor(200,200,200,255)
		npc.IsDeathZombie=true
		npc:SetKeyValue("spawnflags","512")
		npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
		npc:Activate()
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Demon"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetBloodColor(BLOOD_COLOR_RED)
		npc:SetMaxHealth(npc:Health()*4)
		npc:SetHealth(npc:GetMaxHealth())
		npc:SetBodygroup(1,0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc4=npc
	end)
	
	timer.Simple(0.2,function()
		local npc=ents.Create("npc_zombie_torso")
		npc:SetPos(selfpos+Vector(-50,50,0))
		npc:SetAngles(Angle(0,135,0))
		npc:SetMaterial("models/flesh")
		npc:SetColor(200,200,200,255)
		npc.IsDeathZombie=true
		npc:SetKeyValue("spawnflags","512")
		npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
		npc:Activate()
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Demon"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetBloodColor(BLOOD_COLOR_RED)
		npc:SetMaxHealth(npc:Health()*4)
		npc:SetHealth(npc:GetMaxHealth())
		npc:SetBodygroup(1,0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc5=npc
	end)

	timer.Simple(0.25,function()
		local npc=ents.Create("npc_zombie")
		npc:SetPos(selfpos+Vector(-100,0,0))
		npc:SetAngles(Angle(0,180,0))
		npc:SetMaterial("models/flesh")
		npc:SetColor(200,200,200,255)
		npc.IsDeathZombie=true
		npc:SetKeyValue("spawnflags","512")
		npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
		npc:Activate()
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Demon"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetBloodColor(BLOOD_COLOR_RED)
		npc:SetMaxHealth(npc:Health()*4)
		npc:SetHealth(npc:GetMaxHealth())
		npc:SetBodygroup(1,0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc6=npc
	end)
	
	timer.Simple(0.3,function()
		local npc=ents.Create("npc_fastzombie_torso")
		npc:SetPos(selfpos+Vector(-50,-50,0))
		npc:SetAngles(Angle(0,225,0))
		npc:SetMaterial("models/flesh")
		npc:SetColor(200,200,200,255)
		npc.IsDeathZombie=true
		npc:SetKeyValue("spawnflags","512")
		npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
		npc:Activate()
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Demon"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetBloodColor(BLOOD_COLOR_RED)
		npc:SetMaxHealth(npc:Health()*4)
		npc:SetHealth(npc:GetMaxHealth())
		npc:SetBodygroup(1,0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc7=npc
	end)
	
	timer.Simple(0.35,function()
		local npc=ents.Create("npc_fastzombie")
		npc:SetPos(selfpos+Vector(0,-100,0))
		npc:SetAngles(Angle(0,270,0))
		npc:SetMaterial("models/flesh")
		npc:SetColor(200,200,200,255)
		npc.IsDeathZombie=true
		npc:SetKeyValue("spawnflags","512")
		npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
		npc:Activate()
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Demon"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetBloodColor(BLOOD_COLOR_RED)
		npc:SetMaxHealth(npc:Health()*4)
		npc:SetHealth(npc:GetMaxHealth())
		npc:SetBodygroup(1,0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc8=npc
	end)
	
	timer.Simple(0.4,function()
		local npc=ents.Create("npc_zombie_torso")
		npc:SetPos(selfpos+Vector(50,-50,0))
		npc:SetAngles(Angle(0,315,0))
		npc:SetMaterial("models/flesh")
		npc:SetColor(200,200,200,255)
		npc.IsDeathZombie=true
		npc:SetKeyValue("spawnflags","512")
		npc:Spawn();npc:SetKeyValue("SquadName","InstantDeathZombieOpposition")
		npc:Activate()
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Demon"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:SetBloodColor(BLOOD_COLOR_RED)
		npc:SetMaxHealth(npc:Health()*4)
		npc:SetHealth(npc:GetMaxHealth())
		npc:SetBodygroup(1,0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc9=npc
	end)
	
	timer.Simple(0.45,function()
		undo.Create("DeathZombie Opposition Squad")
		undo.SetPlayer(ply)
		if(IsValid(npc1))then undo.AddEntity(npc1) end
		if(IsValid(npc2))then undo.AddEntity(npc2) end
		if(IsValid(npc3))then undo.AddEntity(npc3) end
		if(IsValid(npc4))then undo.AddEntity(npc4) end
		if(IsValid(npc5))then undo.AddEntity(npc5) end
		if(IsValid(npc6))then undo.AddEntity(npc6) end
		if(IsValid(npc7))then undo.AddEntity(npc7) end
		if(IsValid(npc8))then undo.AddEntity(npc8) end
		if(IsValid(npc9))then undo.AddEntity(npc9) end
		undo.SetCustomUndoText("Undone DeathZombie Opposition Squad")
		undo.Finish()
	end)
end




