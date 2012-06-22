AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)
	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	local HostileHacks=false
	if(ply:KeyDown(IN_USE))then HostileHacks=true end
	
	local manhack = JACK_Spawn_Gunhack(selfpos)
	
	if not(HostileHacks)then
		manhack.JackyAllegiance="Human"
	else
		manhack.JackyAllegiance="JackarundaIndustriesMachines"
	end
	manhack:SetKeyValue("SquadName",manhack.JackyAllegiance)
end

function JACK_Spawn_Gunhack(selfpos)
	
	local HeightTable={
		["npc_zombie"]=38,
		["npc_zombine"]=35,
		["npc_fastzombie"]=40,
		["npc_fastzombie_torso"]=10,
		["npc_zombie_torso"]=10,
		["npc_antlionguard"]=60,
		["npc_hunter"]=60,
		["npc_antlion"]=30,
		["npc_citizen"]=40,
		["npc_combine_s"]=40,
		["npc_poisonzombie"]=40,
		["npc_combine_s"]=45,
		["npc_breen"]=45,
		["npc_antlion_worker"]=30,
		["npc_turret_floor"]=45,
		["npc_headcrab"]=5,
		["npc_headcrab_fast"]=5,
		["npc_headcrab_black"]=5,
		["npc_headcrab_poison"]=5,
		["npc_manhack"]=2,
		["npc_metropolice"]=38,
		["player"]=45
	}
	
	local WidthTable={
		[HULL_HUMAN]=30, --hull_human
		[HULL_SMALL_CENTERED]=28, --hull_small_centered
		[HULL_WIDE_HUMAN]=34, --hull_wide_human
		[HULL_TINY]=11, --hull_tiny
		[HULL_WIDE_SHORT]=40, --hull_wide_short
		[HULL_MEDIUM]=40, --hull_medium
		[HULL_TINY_CENTERED]=16, --hull_tiny_centered
		[HULL_LARGE]=80, --hull_large
		[HULL_LARGE_CENTERED]=40, --hull_large_centered
		[HULL_MEDIUM_TALL]=40 --hull_medium_tall
	}
	
	local hack1
	
	local manhack=ents.Create("npc_manhack")
	manhack:SetPos(selfpos)
	manhack:SetAngles(Angle(0,0,0))
	manhack:SetKeyValue("spawnflags","65794") --256+65536=65792
	manhack.IsAJIViscerator=true
	manhack.IsAJIGunhack=true
	manhack.HasHighTechJIArmor=true
	manhack.InAJackyManhackSquad=true
	manhack.NextLungeTime=CurTime()
	manhack:Spawn()
	manhack:Activate()
	manhack:SetModel("models/janhack.mdl")
	manhack:SetMaxHealth(30)
	manhack:SetHealth(30)
	manhack:SetKeyValue("WakeSquad","1")
	manhack:SetKeyValue("IgnoreUnseenEnemies","0")
	manhack:SetKeyValue("SquadName","JIVisceratorSquad")
	
	manhack.GunModel=ents.Create("prop_dynamic")
	manhack.GunModel:SetModel("models/cameragun.mdl")
	manhack.GunModel:SetPos(manhack:GetPos()-manhack:GetUp()*10+manhack:GetRight()-manhack:GetForward())
	manhack.GunModel:SetAngles(Angle(0,0,180))
	manhack.GunModel:SetParent(manhack)
	manhack.GunModel:Spawn()
	manhack.GunModel:Activate()
	manhack.BarrelModel=ents.Create("prop_dynamic")
	manhack.BarrelModel:SetModel("models/props_c17/TrapPropeller_Lever.mdl")
	manhack.BarrelModel:SetColor(0,0,0,255)
	manhack.BarrelModel:SetPos(manhack:GetPos()-manhack:GetUp()*5.4+manhack:GetForward()*9.5)
	manhack.BarrelModel:SetAngles(manhack:GetAngles()+Angle(0,90,0))
	manhack.BarrelModel:SetParent(manhack.GunModel)
	manhack.BarrelModel:Spawn()
	manhack.BarrelModel:Activate()
	
	manhack.OPSQUADWillDropAR2Ammo=true
	
	manhack.RoundsInPulseMag=20

	manhack.HasAJackyAllegiance=true
	
	--if not(HostileHacks)then
	--	manhack.JackyAllegiance="Human"
	--else
	--	manhack.JackyAllegiance="JackarundaIndustriesMachines"
	--end
	--manhack:SetKeyValue("SquadName",manhack.JackyAllegiance)
	
	local timername="KeepOfftheFuckingGround"..manhack:EntIndex()
	timer.Create(timername,0.1,0,function()
		if not(IsValid(manhack))then timer.Destroy(timername) return end
		local hackpos=manhack:GetPos()
		local TraceData={}
		TraceData.start=hackpos
		TraceData.endpos=hackpos-manhack:GetUp()*25
		TraceData.filter={manhack,manhack.GunModel,manhack.BarrelModel}
		local Trace=util.TraceLine(TraceData)
		if(Trace.Hit)then
			if(IsValid(manhack:GetPhysicsObject()))then
				manhack:GetPhysicsObject():ApplyForceCenter(manhack:GetUp()*1000)
			end
		end
	end)
	
	local timername="ShootHack"..manhack:EntIndex()
	timer.Create(timername,0.05,0,function()
		if not(IsValid(manhack))then timer.Destroy(timername)
			if(IsValid(manhack.GunModel))then
				manhack.GunModel:Remove()
			end
			return
		end
		local HackPhys=manhack:GetPhysicsObject()
		if not(IsValid(HackPhys))then return end
		local Enemy=manhack:GetEnemy()
		local hackpos=manhack:GetPos()
		if(IsValid(Enemy))then
			if(manhack.NextTargetTime<CurTime())then
				if not(manhack.IsBoosting)then
					if(math.random(1,7)==2)then
						if(manhack.RoundsInPulseMag>0)then
							local traceinfo={}
							traceinfo.start=hackpos
							traceinfo.endpos=Enemy:GetPos()
							traceinfo.filter={manhack,Enemy,manhack.GunModel,manhack.BarrelModel}
							local trace=util.TraceLine(traceinfo)
							if not(trace.Hit)then
								local Direction=((Enemy:GetPos()+Vector(0,0,HeightTable[Enemy:GetClass()]))-hackpos):GetNormalized()
								manhack:EmitSound("NPC_FloorTurret.Shoot")
								local Bewlat={}
								Bewlat.Num=1
								Bewlat.Src=hackpos
								Bewlat.Dir=Direction
								manhack.GunModel:SetAngles(Direction:Angle()+Angle(0,0,180))
								Bewlat.Spread=Vector(0.0275,0.0275,0)
								Bewlat.Tracer=1
								Bewlat.TracerName="AR2Tracer"
								Bewlat.Force=50
								Bewlat.Damage=7.5
								Bewlat.Attacker=manhack
								Bewlat.Inflictor=manhack
								manhack:FireBullets(Bewlat)
								
								HackPhys:ApplyForceCenter(-Direction*750) --recoil
								
								manhack.RoundsInPulseMag=manhack.RoundsInPulseMag-1
								
								local FectDater=EffectData()
								FectDater:SetStart(manhack:GetPos()+manhack:GetForward()*10-manhack:GetUp()*10)
								FectDater:SetNormal(Direction)
								//util.Effect("AirboatMuzzleFlash",FectDater) --i'd love to use this, but Garry fucked it all to hell
								util.Effect("effect_jack_pulsemuzzle",FectDater)
								umsg.Start("Jacky'sMuzzleFlashUserMessage")
									umsg.Vector(hackpos)
									umsg.Entity(manhack)
								umsg.End()
							end
						else
							if not(manhack.Reloading)then
								local EmptyMag=ents.Create("prop_physics")
								EmptyMag:SetModel("models/Items/combine_rifle_cartridge01.mdl")
								EmptyMag:SetPos(manhack:GetPos()-manhack:GetUp()*10)
								EmptyMag:SetAngles(manhack:GetAngles())
								EmptyMag:SetMaterial("models/janhack/manhack_sheet")
								EmptyMag:Spawn()
								EmptyMag:Activate()
								EmptyMag:GetPhysicsObject():SetMass(50)
								local timername="SlagCartridgeCoolDown"..EmptyMag:EntIndex()
								timer.Create(timername,1,10,function()
									if not(IsValid(EmptyMag))then timer.Destroy(timername) return end
									local EfDat=EffectData()
									EfDat:SetOrigin(EmptyMag:GetPos())
									util.Effect("effect_jack_heatcool",EfDat)
								end)
								SafeRemoveEntityDelayed(EmptyMag,20)
								manhack:EmitSound("lolsounds/gunload.wav")
								manhack.Reloading=true
								timer.Simple(1.5,function()
									if(IsValid(manhack))then
										manhack.RoundsInPulseMag=20
										manhack.Reloading=false
									end
								end)
							end
						end
					end
				end
			end
		end
	end)
	
	local timername="BeepManhack"..manhack:EntIndex()
	timer.Create(timername,1.75,0,function()
		if not(IsValid(manhack))then timer.Destroy(timername) return end
		local hackpos=manhack:GetPos()
		if not(IsValid(manhack:GetEnemy()))then
			manhack:EmitSound("lolsounds/search.wav",65,100)
			manhack.GunModel:SetAngles(manhack:GetAngles()+Angle(0,0,180))
		end
		for key,found in pairs(ents.FindByClass("npc_*"))do
			local enemypos=found:GetPos()
			if(manhack:Disposition(found)==1)then
				if not(IsValid(manhack:GetEnemy()))then
					local LoSTraceData={}
					LoSTraceData.start=hackpos+Vector(0,0,10)
					LoSTraceData.endpos=enemypos+Vector(0,0,10)
					LoSTraceData.filter={found,manhack,manhack.GunModel,manhack.BarrelModel}
					local LoSTrace=util.TraceLine(LoSTraceData)
					if not(LoSTrace.Hit)then
						manhack:SetTarget(found)
						manhack:UpdateEnemyMemory(found,enemypos)
					end
				end
			end
		end
	end)
	
	local timername="FastManhack"..manhack:EntIndex()
	timer.Create(timername,0.05,0,function()
		if not(IsValid(manhack))then timer.Destroy(timername) return end
		local HackPhys=manhack:GetPhysicsObject()
		if not(IsValid(HackPhys))then return end
		local hackpos=manhack:GetPos()
		if(IsValid(manhack:GetEnemy()))then
			if(manhack.NextTargetTime<CurTime())then
				manhack.ChargeUpSoundPlayed=false
				local enemy=manhack:GetEnemy()
				local height=HeightTable[enemy:GetClass()]
				if not(height)then height=5 end
				local enemypos=enemy:GetPos()+Vector(0,0,height)
				local dir=(enemypos-hackpos):Normalize()
				local dist=(enemypos-hackpos):Length()
				if(true)then
					local traceinfo={}
					traceinfo.start=hackpos
					traceinfo.endpos=enemypos
					traceinfo.filter={manhack,enemy,manhack.GunModel,manhack.BarrelModel}
					local trace=util.TraceLine(traceinfo)
					if(trace.Hit)then
						manhack.NextForceTime=CurTime()+0.75
					end
					if not(trace.Hit)then
						if(dist<300)then
							HackPhys:ApplyForceCenter(-dir*1500)
						elseif(dist>750)then
							HackPhys:ApplyForceCenter(dir*1500)
						end
						manhack.IsBoosting=false
					end
					if not(trace.Hit)then
						local Vel=HackPhys:GetVelocity()
						if(dist>1750)then
							if not(manhack.TakeOffSoundPlayed)then
								manhack:EmitSound("lolsounds/take_off.wav")
								manhack.TakeOffSoundPlayed=true
							end
							manhack.IsBoosting=true
							HackPhys:ApplyForceCenter(dir*6000)
							AirVwoosh(hackpos,Vel,1)
							if not(manhack.RotorWashEntity)then MakeRotorWash(manhack) end
						else
							if(enemy:GetVelocity():Length()>700)then
								if not(manhack.TakeOffSoundPlayed)then
									manhack:EmitSound("lolsounds/take_off.wav")
									manhack.TakeOffSoundPlayed=true
								end
								HackPhys:ApplyForceCenter(dir*2000)
								AirVwoosh(hackpos,Vel,0.525)
								manhack.IsBoosting=true
								if not(manhack.RotorWashEntity)then MakeRotorWash(manhack) end
							else
								if(manhack.RotorWashEntity)then RemoveRotorWash(manhack) end
								manhack.TakeOffSoundPlayed=false
								manhack.IsBoosting=false
							end
						end
					else
						manhack.IsBoosting=false
						if(manhack.RotorWashEntity)then RemoveRotorWash(manhack) end
					end
				end
			else
				if not(manhack.ChargeUpSoundPlayed)then
					local enemy=manhack:GetEnemy()
					local height=HeightTable[enemy:GetClass()]
					if not(height)then height=5 end
					local enemypos=enemy:GetPos()+Vector(0,0,height)
					local dir=(enemypos-hackpos):Normalize()
					local dist=(enemypos-hackpos):Length()
					if(dist>1750)then
						manhack:EmitSound("lolsounds/go_charge.wav")
						manhack.ChargeUpSoundPlayed=true
					end
					local traceinfo={}
					traceinfo.start=hackpos
					traceinfo.endpos=enemypos
					traceinfo.filter={manhack,enemy,manhack.GunModel,manhack.BarrelModel}
					local trace=util.TraceLine(traceinfo)
					if(trace.Hit)then
						manhack.NextForceTime=CurTime()+0.75
					end
					if(manhack.NextForceTime<CurTime())then	
						if(dist<300)then
							HackPhys:ApplyForceCenter(-dir*1500)
						elseif(dist>750)then
							HackPhys:ApplyForceCenter(dir*1500)
						end
					end
				end
			end
		else
			manhack.NextTargetTime=CurTime()+1.75
			manhack.NextForceTime=CurTime()+0.75
			if(manhack.RotorWashEntity)then RemoveRotorWash(manhack) end
			manhack.ChargeUpSoundPlayed=false
			manhack.TakeOffSoundPlayed=false
		end
	end)
	
	manhack:Fire("unpack","",0)
	
	local size=-25
	local body=manhack:LookupBone("Manhack.MH_Control")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlBodyUpper")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlPincerTop")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size-40) end
	local body=manhack:LookupBone("Manhack.MH_ControlPanel1")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size+100) end
	local body=manhack:LookupBone("Manhack.MH_ControlPanel2")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size+100) end
	local body=manhack:LookupBone("Manhack.MH_ControlPanel3")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlPanel4")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlPanel5")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlPanel6")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlExhaust")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlBodyLower")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlPincerBottom")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size+50) end
	local body=manhack:LookupBone("Manhack.MH_ControlCamera")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size) end
	local body=manhack:LookupBone("Manhack.MH_ControlBlade")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size+100) end
	local body=manhack:LookupBone("Manhack.MH_ControlBlade1")
	if(body)then manhack:SetNetworkedInt("InflateSize"..body,size+100) end
	
	local effectdata=EffectData()
	effectdata:SetEntity(manhack)
	util.Effect("propspawn",effectdata)
	
	hack1=manhack
	
	timer.Simple(0.05,function()
		undo.Create("Manhack")
			if(IsValid(hack1))then undo.AddEntity(hack1) end
			undo.SetCustomUndoText("Undone JI Gunhack.")
			undo.SetPlayer(ply)
		undo.Finish()
	end)
	
	return hack1
end

/*----------------------------------------------------------------------------------
	This creates the shit for a destroyed hack
----------------------------------------------------------------------------------*/
function Bust(npc,attacker,inflictor)
	if(npc.IsAJIGunhack)then
	
		local gib=ents.Create("prop_physics")
		gib:SetModel("models/Items/BoxMRounds.mdl")
		gib:SetPos(npc:GetPos()-npc:GetUp()*5)
		gib:SetAngles(Angle(0,0,180))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		gib:SetColor(0,0,0,0)
		local cameragun=ents.Create("prop_dynamic")
		cameragun:SetModel("models/cameragun.mdl")
		cameragun:SetPos(gib:GetPos()+gib:GetUp()*7)
		cameragun:SetAngles(gib:GetAngles())
		cameragun:SetParent(gib)
		cameragun:Spawn()
		cameragun:Activate()
		cameragun:SetColor(190,190,190,255)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))

		local gib=ents.Create("prop_physics")
		gib:SetModel("models/props_c17/TrapPropeller_Lever.mdl")
		gib:SetColor(0,0,0,255)
		gib:SetPos(npc:GetPos()+VectorRand()*math.Rand(2,20))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))
		
		local gib=ents.Create("prop_physics")
		gib:SetModel("models/Gibs/manhack_gib06.mdl")
		gib:SetMaterial("models/janhack/manhackgib_sheet")
		gib:SetPos(npc:GetPos()+VectorRand()*math.Rand(2,20))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))
		
		local gib=ents.Create("prop_physics")
		gib:SetModel("models/Gibs/manhack_gib06.mdl")
		gib:SetMaterial("models/janhack/manhackgib_sheet")
		gib:SetPos(npc:GetPos()+VectorRand()*math.Rand(2,20))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))
		
		local gib=ents.Create("prop_physics")
		gib:SetModel("models/Gibs/manhack_gib05.mdl")
		gib:SetMaterial("models/janhack/manhackgib_sheet")
		gib:SetPos(npc:GetPos()+VectorRand()*math.Rand(2,20))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))
		
		local gib=ents.Create("prop_physics")
		gib:SetModel("models/Gibs/manhack_gib05.mdl")
		gib:SetMaterial("models/janhack/manhackgib_sheet")
		gib:SetPos(npc:GetPos()+VectorRand()*math.Rand(2,20))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))
		
		local gib=ents.Create("prop_physics")
		gib:SetModel("models/Gibs/manhack_gib04.mdl")
		gib:SetMaterial("models/janhack/manhackgib_sheet")
		gib:SetPos(npc:GetPos()+VectorRand()*math.Rand(2,20))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))
		
		local gib=ents.Create("prop_physics")
		gib:SetModel("models/Gibs/manhack_gib03.mdl")
		gib:SetMaterial("models/janhack/manhackgib_sheet")
		gib:SetPos(npc:GetPos()+VectorRand()*math.Rand(2,20))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))
		
		local gib=ents.Create("prop_physics")
		gib:SetModel("models/Gibs/manhack_gib01.mdl")
		gib:SetMaterial("models/janhack/manhackgib_sheet")
		gib:SetPos(npc:GetPos()+VectorRand()*math.Rand(2,20))
		gib:Spawn()
		gib:Activate()
		gib:GetPhysicsObject():SetMass(10)
		SafeRemoveEntityDelayed(gib,math.Rand(10,20))

	end
end
hook.Add("OnNPCKilled","JIGunhackDeath",Bust)

function ThrustSmoke(position,direction)
	local Smoak=EffectData()
	Smoak:SetOrigin(position)
	Smoak:SetStart(VectorRand())
	Smoak:SetNormal(-direction)
	util.Effect("effect_jack_thrustsmoke",Smoak)
end

function AirVwoosh(position,velocity,size)
	local Vwoosh=EffectData()
	Vwoosh:SetOrigin(position+velocity*0.2)
	Vwoosh:SetScale(size)
	util.Effect("effect_jack_airdestruction",Vwoosh)
end

function MakeRotorWash(npc)
	npc.RotorWashEntity=ents.Create("env_rotorwash_emitter")
	npc.RotorWashEntity:SetPos(npc:GetPos())
	npc.RotorWashEntity:SetParent(npc)
	npc.RotorWashEntity:Activate()
end

function RemoveRotorWash(npc)
	npc.RotorWashEntity:Remove()
	npc.RotorWashEntity=nil
end