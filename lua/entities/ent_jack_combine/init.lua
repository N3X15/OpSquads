AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	local Friendly=false
	if(ply:KeyDown(IN_USE))then
		Friendly=true
	end
	
	util.PrecacheModel("models/props_combine/combine_mine01.mdl")
	util.PrecacheModel("models/roller.mdl")
	util.PrecacheModel("models/combine_soldier.mdl")
	util.PrecacheModel("models/combine_super_soldier.mdl")
	util.PrecacheModel("models/combine_soldier_prisonguard.mdl")
	util.PrecacheModel("models/hunter.mdl")
	util.PrecacheModel("models/manhack.mdl")
	util.PrecacheModel("models/police.mdl")
	util.PrecacheModel("models/combine_turrets/floor_turret.mdl")
	
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
	local npc11
	local npc12
	local npc13
	local npc14
	local npc15
	local npc16
	local npc17
	local npc18
	local npc19
	local npc20
	local npc21
	local npc22
	local npc23
	local npc24
	local npc25
	local npc26
	local npc27
	local npc28
	local npc29
	
	local npc=ents.Create("npc_hunter")
	npc:SetPos(selfpos)
	npc:Spawn()
	npc:Activate()
	npc.HasAJackyAllegiance=true
	if(Friendly)then
		npc.JackyAllegiance="Human"
	else
		npc.JackyAllegiance="Combine"
	end
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	npc.OPSQUADNeedsAStrider=true
	npc.OPSQUADHasAStrider=false
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)
	npc1=npc

	timer.Simple(0.05,function()
		local npc=ents.Create("npc_combine_s")
		npc:SetPos(selfpos+Vector(75,0,0))
		npc:SetKeyValue("additionalequipment","weapon_ar2")
		npc:SetModel("models/combine_super_soldier.mdl")
		npc:SetKeyValue("NumGrenades","3")
		npc:SetMaxHealth(60)
		npc:SetHealth(60)
		npc:Spawn()
		npc.OPSQUADWillDropIonBalls=true
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADIonBaller"..npc:EntIndex()
		timer.Create(timername,20,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local Enemy=npc:GetEnemy()
			if(IsValid(Enemy))then
				Enemy:SetName("AboutToGetFuckedUp"..Enemy:EntIndex())
				npc:Fire("throwgrenadeattarget","AboutToGetFuckedUp"..Enemy:EntIndex())
			end
		end)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc2=npc
	end)
	
	timer.Simple(0.1,function()
		local npc=ents.Create("npc_combine_s")
		npc:SetPos(selfpos+Vector(75,75,0))
		npc:SetAngles(Angle(0,45,0))
		npc:SetKeyValue("additionalequipment","weapon_ar2")
		npc:SetKeyValue("NumGrenades","3")
		npc:Spawn()
		npc.OPSQUADWillDropGrenades=true
		npc.OpSquadWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADCombineGrenadier"..npc:EntIndex()
		timer.Create(timername,20,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local Enemy=npc:GetEnemy()
			if(IsValid(Enemy))then
				Enemy:SetName("AboutToGetFuckedUp"..Enemy:EntIndex())
				npc:Fire("throwgrenadeattarget","AboutToGetFuckedUp"..Enemy:EntIndex())
			end
		end)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc3=npc
	end)
	
	timer.Simple(0.15,function()
		local npc=ents.Create("npc_combine_s")
		npc:SetPos(selfpos+Vector(0,75,0))
		npc:SetAngles(Angle(0,90,0))
		npc:SetKeyValue("additionalequipment","weapon_shotgun")
		npc:SetModel("models/combine_soldier_prisonguard.mdl")
		npc:Spawn()
		npc.OPSQUADWillDropShotgunAmmo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc4=npc
	end)
	
	timer.Simple(0.2,function()
		local npc=ents.Create("npc_combine_s")
		npc:SetPos(selfpos+Vector(-75,75,0))
		npc:SetAngles(Angle(0,135,0))
		npc:SetKeyValue("additionalequipment","weapon_ar2")
		npc:SetKeyValue("NumGrenades","3")
		npc:Spawn()
		npc.OPSQUADWillDropGrenades=true
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADGrenadier"..npc:EntIndex()
		timer.Create(timername,20,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local Enemy=npc:GetEnemy()
			if(IsValid(Enemy))then
				Enemy:SetName("AboutToGetFuckedUp"..Enemy:EntIndex())
				npc:Fire("throwgrenadeattarget","AboutToGetFuckedUp"..Enemy:EntIndex())
			end
		end)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc5=npc
	end)
	
	timer.Simple(0.25,function()
		local npc=ents.Create("npc_combine_s")
		npc:SetPos(selfpos+Vector(-75,0,0))
		npc:SetAngles(Angle(0,180,0))
		npc:SetKeyValue("additionalequipment","weapon_ar2")
		npc:SetModel("models/combine_super_soldier.mdl")
		npc:SetKeyValue("NumGrenades","3")
		npc:SetMaxHealth(60)
		npc:SetHealth(60)
		npc:Spawn()
		npc.OPSQUADWillDropIonBalls=true
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local timername="OPSQUADIonBaller"..npc:EntIndex()
		timer.Create(timername,20,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local Enemy=npc:GetEnemy()
			if(IsValid(Enemy))then
				Enemy:SetName("AboutToGetFuckedUp"..Enemy:EntIndex())
				npc:Fire("throwgrenadeattarget","AboutToGetFuckedUp"..Enemy:EntIndex())
			end
		end)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc6=npc
	end)
	
	timer.Simple(0.3,function()
		local npc=ents.Create("npc_combine_s")
		npc:SetPos(selfpos+Vector(-75,-75,0))
		npc:SetAngles(Angle(0,225,0))
		npc:SetKeyValue("additionalequipment","weapon_ar2")
		npc:SetKeyValue("NumGrenades","3")
		npc:Spawn()
		npc.OPSQUADWillDropGrenades=true
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc7=npc
	end)
	
	timer.Simple(0.35,function()
		local npc=ents.Create("npc_combine_s")
		npc:SetPos(selfpos+Vector(0,-75,0))
		npc:SetAngles(Angle(0,270,0))
		npc:SetKeyValue("additionalequipment","weapon_shotgun")
		npc:SetModel("models/combine_soldier_prisonguard.mdl")
		npc:Spawn()
		npc.OPSQUADWillDropShotgunAmmo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc8=npc
	end)
	
	timer.Simple(0.4,function()
		local npc=ents.Create("npc_combine_s")
		npc:SetPos(selfpos+Vector(75,-75,0))
		npc:SetAngles(Angle(0,315,0))
		npc:SetKeyValue("additionalequipment","weapon_ar2")
		npc:SetKeyValue("NumGrenades","3")
		npc:Spawn()
		npc.OPSQUADWillDropGrenades=true
		npc.OPSQUADWillDropAR2Ammo=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc9=npc
	end)
	
	timer.Simple(0.45,function()
		local npc=ents.Create("npc_metropolice")
		npc:SetPos(selfpos+Vector(150,0,0))
		npc:SetKeyValue("additionalequipment","weapon_pistol")
		npc:SetKeyValue("manhacks","10")
		npc:Spawn()
		npc:Fire("EnableManhackToss","1",0)
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc10=npc
	end)
	
	timer.Simple(0.5,function()
		local npc=ents.Create("npc_turret_floor")
		npc:SetPos(selfpos+Vector(150,150,-5))
		npc:SetAngles(Angle(0,45,0))
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
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc11=npc
	end)
	
	timer.Simple(0.55,function()
		local npc=ents.Create("npc_metropolice")
		npc:SetPos(selfpos+Vector(0,150,0))
		npc:SetAngles(Angle(0,90,0))
		npc:SetKeyValue("additionalequipment","weapon_stunstick")
		npc:SetKeyValue("manhacks","10")
		npc:Spawn()
		npc:Fire("EnableManhackToss","1",0)
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc12=npc
	end)
	
	timer.Simple(0.6,function()
		local npc=ents.Create("npc_turret_floor")
		npc:SetPos(selfpos+Vector(-150,150,-5))
		npc:SetAngles(Angle(0,135,0))
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
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc13=npc
	end)

	timer.Simple(0.65,function()
		local npc=ents.Create("npc_metropolice")
		npc:SetPos(selfpos+Vector(-150,0,0))
		npc:SetAngles(Angle(0,180,0))
		npc:SetKeyValue("additionalequipment","weapon_pistol")
		npc:SetKeyValue("manhacks","10")
		npc:Spawn()
		npc:Fire("EnableManhackToss","1",0)
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc14=npc
	end)
	
	timer.Simple(0.7,function()
		local npc=ents.Create("npc_turret_floor")
		npc:SetPos(selfpos+Vector(-150,-150,-5))
		npc:SetAngles(Angle(0,225,0))
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
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc15=npc
	end)
	
	timer.Simple(0.75,function()
		local npc=ents.Create("npc_metropolice")
		npc:SetPos(selfpos+Vector(0,-150,0))
		npc:SetAngles(Angle(0,270,0))
		npc:SetKeyValue("additionalequipment","weapon_stunstick")
		npc:SetKeyValue("manhacks","10")
		npc:Spawn()
		npc:Fire("EnableManhackToss","1",0)
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc16=npc
	end)
	
	timer.Simple(0.8,function()
		local npc=ents.Create("npc_turret_floor")
		npc:SetPos(selfpos+Vector(150,-150,-5))
		npc:SetAngles(Angle(0,315,0))
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
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc17=npc
	end)
	
	timer.Simple(0.85,function()
		local npc=ents.Create("npc_manhack")
		npc:SetPos(selfpos+Vector(0,20,100))
		npc:SetAngles(Angle(0,90,0))
		npc:SetKeyValue("spawnflags","65536")
		npc:Spawn()
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:Fire("unpack","",0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc23=npc
	end)
	
	timer.Simple(0.9,function()
		local npc=ents.Create("npc_rollermine")
		npc:SetPos(selfpos+Vector(225,225,0))
		npc:SetKeyValue("uniformsightdist","1")
		npc:SetKeyValue("startburied","1")
		npc:Spawn()
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc18=npc
	end)
	
	timer.Simple(0.95,function()
		local npc=ents.Create("npc_manhack")
		npc:SetPos(selfpos+Vector(0,-20,100))
		npc:SetAngles(Angle(0,270,0))
		npc:SetKeyValue("spawnflags","65536")
		npc:Spawn()
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:Fire("unpack","",0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc24=npc
	end)
	
	timer.Simple(1,function()
		local npc=ents.Create("npc_rollermine")
		npc:SetPos(selfpos+Vector(-225,225,0))
		npc:SetKeyValue("uniformsightdist","1")
		npc:SetKeyValue("startburied","1")
		npc:Spawn()
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc19=npc
	end)
	
	timer.Simple(1.05,function()
		local npc=ents.Create("npc_manhack")
		npc:SetPos(selfpos+Vector(20,0,100))
		npc:SetKeyValue("spawnflags","65536")
		npc:Spawn()
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:Fire("unpack","",0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc25=npc
	end)
	
	timer.Simple(1.1,function()
		local npc=ents.Create("npc_rollermine")
		npc:SetPos(selfpos+Vector(-225,-225,0))
		npc:SetKeyValue("uniformsightdist","1")
		npc:SetKeyValue("startburied","1")
		npc:Spawn()
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc20=npc
	end)
	
	timer.Simple(1.15,function()
		local npc=ents.Create("npc_manhack")
		npc:SetPos(selfpos+Vector(-20,0,100))
		npc:SetAngles(Angle(0,180,0))
		npc:SetKeyValue("spawnflags","65536")
		npc:Spawn()
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		npc:Fire("unpack","",0)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc26=npc
	end)
	
	timer.Simple(1.2,function()
		local npc=ents.Create("npc_rollermine")
		npc:SetPos(selfpos+Vector(225,-225,0))
		npc:SetKeyValue("uniformsightdist","1")
		npc:SetKeyValue("startburied","1")
		npc:Spawn()
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc21=npc
	end)
	
	timer.Simple(1.25,function()
		local npc=ents.Create("npc_cscanner")
		npc:SetPos(selfpos+Vector(0,-150,75))
		npc:SetAngles(Angle(0,270,0))
		npc:Spawn()
		npc.OPSQUADWillDropBattery=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc27=npc
	end)
	
	timer.Simple(1.3,function()
		local npc=ents.Create("npc_clawscanner")
		npc:SetPos(selfpos+Vector(-150,0,75))
		npc:SetAngles(Angle(0,180,0))
		npc:Spawn()
		npc.OPSQUADWillDropBattery=true
		npc.HasMine=false																	--
		npc.MinesDropped=0																	--
		local timername="OPSQUADMineDroppinMotherFucker"..npc:EntIndex()                    --
		timer.Create(timername,5,0,function()	                                          	--
			if not(IsValid(npc))then timer.Destroy(timername) return end                    --
			if(npc.MinesDropped==20)then return end											--
			if not(IsValid(npc:GetTarget()))then return end                                 --
			if(npc.HasMine==false)then														--
				npc:Fire("equipmine","1",0)													--
				npc.HasMine=true															--
			elseif(npc.HasMine==true)then													--
				npc:Fire("deploymine","1",0)												--
				npc.HasMine=false															--
				npc.MinesDropped=npc.MinesDropped+1											--
			end																				--
		end)																				--
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc28=npc
	end)

	timer.Simple(1.35,function()
		local npc=ents.Create("npc_cscanner")
		npc:SetPos(selfpos+Vector(0,150,75))
		npc:SetAngles(Angle(0,90,0))
		npc:Spawn()
		npc.OPSQUADWillDropBattery=true
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc29=npc
	end)
	
	timer.Simple(1.4,function()
		local npc=ents.Create("npc_clawscanner")
		npc:SetPos(selfpos+Vector(150,0,75))
		npc:Spawn()
		npc.OPSQUADWillDropBattery=true
		npc.HasMine=false																	--
		npc.MinesDropped=0                                                                  --
		local timername="OPSQUADMineDroppinMotherFucker"..npc:EntIndex()                    --
		timer.Create(timername,5,0,function()	                                        	--
			if not(IsValid(npc))then timer.Destroy(timername) return end                    --
			if(npc.MinesDropped==20)then return end											--
			if not(IsValid(npc:GetTarget()))then return end                                 --
			if(npc.HasMine==false)then														--
				npc:Fire("equipmine","1",0)													--
				npc.HasMine=true															--
			elseif(npc.HasMine==true)then													--
				npc:Fire("deploymine","1",0)												--
				npc.HasMine=false															--
				npc.MinesDropped=npc.MinesDropped+1											--
			end																				--
		end)																				--
		npc:Activate()
		npc.HasAJackyAllegiance=true
		if(Friendly)then
			npc.JackyAllegiance="Human"
		else
			npc.JackyAllegiance="Combine"
		end
		npc:SetKeyValue("SquadName",npc.JackyAllegiance)
		local effectdata=EffectData()
		effectdata:SetEntity(npc)
		util.Effect("propspawn",effectdata)
		npc22=npc
	end)
	
	timer.Simple(1.45,function()                            --FUCK this was alot of work
		undo.Create("Combine Opposition Squad")
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
		if(IsValid(npc11))then undo.AddEntity(npc11) end
		if(IsValid(npc12))then undo.AddEntity(npc12) end
		if(IsValid(npc13))then undo.AddEntity(npc13) end
		if(IsValid(npc14))then undo.AddEntity(npc14) end
		if(IsValid(npc15))then undo.AddEntity(npc15) end
		if(IsValid(npc16))then undo.AddEntity(npc16) end
		if(IsValid(npc17))then undo.AddEntity(npc17) end
		if(IsValid(npc18))then undo.AddEntity(npc18) end
		if(IsValid(npc19))then undo.AddEntity(npc19) end
		if(IsValid(npc20))then undo.AddEntity(npc20) end
		if(IsValid(npc21))then undo.AddEntity(npc21) end
		if(IsValid(npc22))then undo.AddEntity(npc22) end
		if(IsValid(npc23))then undo.AddEntity(npc23) end
		if(IsValid(npc24))then undo.AddEntity(npc24) end
		if(IsValid(npc25))then undo.AddEntity(npc25) end
		if(IsValid(npc26))then undo.AddEntity(npc26) end
		if(IsValid(npc27))then undo.AddEntity(npc27) end
		if(IsValid(npc28))then undo.AddEntity(npc28) end
		if(IsValid(npc29))then undo.AddEntity(npc29) end
		undo.SetCustomUndoText("Undone Combine Opposition Squad")
		undo.Finish()
	end)
end




