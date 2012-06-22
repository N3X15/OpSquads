AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local selfpos = tr.HitPos + tr.HitNormal * 50
	
	local JuggerPigeon=ply:KeyDown(IN_USE)
	
	local npc1
	local npc2
	local npc3
	local npc4
	local npc5
	local npc6
	local npc7
	local npc8
	local npc9
	local npc10
	
	local npc=ents.Create("npc_pigeon")
	npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
	npc:SetAngles(Angle(0,math.Rand(0,360),0))
	npc.IsAStupidPigeon=true
	npc:Spawn()
	npc:Activate()
	npc1=npc
	local Shine=EffectData()
	Shine:SetEntity(npc)
	util.Effect("propspawn",Shine)
	npc.HasAJackyAllegiance=true
	npc.JackyAllegiance="Prey"
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	local timername="OPSQUADWander"..npc:EntIndex()
	timer.Create(timername,10,0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		local newpos=npc:GetPos()+VectorRand()*500
		npc:SetLastPosition(newpos)
		npc:SetSchedule(SCHED_FORCED_GO_RUN)
	end)
	
	if(JuggerPigeon)then
		npc:SetMaxHealth(25000)
		npc:SetHealth(25000)
		npc:SetMaterial("models/mat_jack_juggerpigeon")
		undo.Create("Human Opposition Squad")
		undo.SetPlayer(ply)
		undo.AddEntity(npc)
		undo.SetCustomUndoText("Undone Juggernaut Pigeon")
		undo.Finish()
		return
	end
	
	timer.Simple(0.05,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc2=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end)
	
	timer.Simple(0.1,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc3=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end)
	
	timer.Simple(0.15,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc4=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end)
	
	timer.Simple(0.2,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc5=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end)
	
	timer.Simple(0.25,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc6=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end)
	
	timer.Simple(0.3,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc7=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)	
	end)
	
	timer.Simple(0.35,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc8=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end)
	
	timer.Simple(0.4,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc9=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end)
	
	timer.Simple(0.45,function()
		local npc=ents.Create("npc_pigeon")
		npc:SetPos(selfpos+VectorRand()*math.Rand(0,40))
		npc:SetAngles(Angle(0,math.Rand(0,360),0))
		npc.IsAStupidPigeon=true
		npc:Spawn()
		npc:Activate()
		npc10=npc
		local Shine=EffectData()
		Shine:SetEntity(npc)
		util.Effect("propspawn",Shine)
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance="Prey"
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADWander"..npc:EntIndex()
		timer.Create(timername,10,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local newpos=npc:GetPos()+VectorRand()*500
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end)
	end)

	timer.Simple(0.5,function()
		undo.Create("Human Opposition Squad")
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
		if(IsValid(npc10))then undo.AddEntity(npc10) end
		undo.SetCustomUndoText("Undone Birds")
		undo.Finish()
	end)
end



