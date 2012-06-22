AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)

	local selfpos = tr.HitPos + tr.HitNormal * 16
	
	local HostileRoller=false
	if(ply:KeyDown(IN_USE))then HostileRoller=true end
	
	local roller=ents.Create("npc_rollermine")
	roller:SetPos(selfpos+Vector(0,0,20))
	//roller:SetKeyValue("spawnflags","65794") --256+65536=65792
	//roller:SetKeyValue("startburied","1")
	roller:SetKeyValue("uniformsightdist","1")
	roller.IsAJIRollermine=true
	roller.HasAThickMetalCasing=true
	roller:Spawn()
	roller:Activate()
	roller:SetMaterial("models/rollerbomb_sheet")
	roller:SetKeyValue("WakeSquad","1")
	roller:SetKeyValue("IgnoreUnseenEnemies","0")
	roller:SetKeyValue("SquadName","JIRollermineSquad")
	
	roller.HasAJackyAllegiance=true
	if not(HostileRoller)then
		roller.JackyAllegiance="Human"
	else
		roller.JackyAllegiance="JackarundaIndustriesMachines"
	end
	roller:SetKeyValue("SquadName",roller.JackyAllegiance)
	
	local timername="SplodeRoller"..roller:EntIndex()
	timer.Create(timername,0.1,0,function()
		if not(IsValid(roller))then timer.Destroy(timername) return end
		local Enemie=roller:GetEnemy()
		if(IsValid(Enemie))then
			if not(Enemie:Health()<=0)then
				local selfpos=roller:GetPos()
				local enempos=Enemie:GetPos()
				local dist=(selfpos-enempos):Length()
				if(dist<250)then
					local DangerClose=false
					for key,found in pairs(ents.FindInSphere(selfpos,750))do
						if((found:IsNPC())or(found:IsPlayer()))then
							if not(found==roller)then
								local klas=found:GetClass()
								local tresdat={}
								tresdat.start=selfpos+Vector(0,0,10)
								tresdat.endpos=found:GetPos()+Vector(0,0,10)
								tresdat.filter={roller,found}
								local tres=util.TraceLine(tresdat)
								if not(tres.Hit)then
									if(found.HasAJackyAllegiance)then
										if(found.JackyAllegiance==roller.JackyAllegiance)then
											DangerClose=true
										end
									elseif((roller.JackyAllegiance=="Human")and(found:IsPlayer()))then
										DangerClose=true
									end
								end
							end
						end
					end
					if not(DangerClose)then
						local tracdat={}
						tracdat.start=selfpos+Vector(0,0,10)
						tracdat.endpos=enempos+Vector(0,0,10)
						tracdat.filter={roller,Enemie}
						local trac=util.TraceLine(tracdat)
						if not(trac.Hit)then
							local Kableweh=EffectData()
							Kableweh:SetOrigin(selfpos)
							Kableweh:SetScale(4)
							util.Effect("effect_jack_rollersplode",Kableweh)
							util.BlastDamage(roller,roller,selfpos,700,500)
							roller:EmitSound("weapons/explode4.wav")
							WorldSound("BaseExplosionEffect.Sound",selfpos)
							WorldSound("ambient/explosions/explode_8.wav",selfpos,100,100)
							umsg.Start("Jacky'sRollerSplosionFlashUserMessage")
								umsg.Entity(roller)
								umsg.Vector(selfpos)
							umsg.End()
							util.ScreenShake(selfpos,99999,99999,1.5,1500)
							for i=0,5 do
								local cake=util.QuickTrace(selfpos,VectorRand()*200,roller)
								if(cake.Hit)then
									util.Decal("Scorch",cake.HitPos+cake.HitNormal,cake.HitPos-cake.HitNormal)
								end
							end
							roller:Remove()
						end
					else
						roller:Fire("turnoff","",0)
						roller:EmitSound("lolsounds/rolleralert.mp3")
					end
				else
					roller:Fire("turnon","",0)
					roller:GetPhysicsObject():Wake()
				end
			end
		else
			roller:Fire("turnon","",0)
			roller:GetPhysicsObject():Wake()
		end
	end)
	
	local timername="BeepRoller"..roller:EntIndex()
	timer.Create(timername,1.75,0,function()
		if not(IsValid(roller))then timer.Destroy(timername) return end
		local hackpos=roller:GetPos()
		if not(IsValid(roller:GetEnemy()))then
			roller:EmitSound("lolsounds/search.wav",50,100)
		end
		for key,found in pairs(ents.FindByClass("npc_*"))do
			local enemypos=found:GetPos()
			if(roller:Disposition(found)==1)then
				if not(IsValid(roller:GetEnemy()))then
					local LoSTraceData={}
					LoSTraceData.start=hackpos+Vector(0,0,10)
					LoSTraceData.endpos=enemypos+Vector(0,0,10)
					LoSTraceData.filter={found,roller}
					local LoSTrace=util.TraceLine(LoSTraceData)
					if not(LoSTrace.Hit)then
						roller:SetTarget(found)
						roller:UpdateEnemyMemory(found,enemypos)
					end
				end
			end
		end
	end)
	
	/*-
	local size=-25
	local body=roller:LookupBone("roller.MH_Control")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlBodyUpper")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlPincerTop")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size-40) end
	local body=roller:LookupBone("roller.MH_ControlPanel1")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size+100) end
	local body=roller:LookupBone("roller.MH_ControlPanel2")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size+100) end
	local body=roller:LookupBone("roller.MH_ControlPanel3")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlPanel4")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlPanel5")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlPanel6")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlExhaust")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlBodyLower")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlPincerBottom")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size+50) end
	local body=roller:LookupBone("roller.MH_ControlCamera")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size) end
	local body=roller:LookupBone("roller.MH_ControlBlade")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size+100) end
	local body=roller:LookupBone("roller.MH_ControlBlade1")
	if(body)then roller:SetNetworkedInt("InflateSize"..body,size+100) end
	-*/
	
	local effectdata=EffectData()
	effectdata:SetEntity(roller)
	util.Effect("propspawn",effectdata)
	
	timer.Simple(0.05,function()
		undo.Create("JackieRollerBomb")
			if(IsValid(roller))then undo.AddEntity(roller) end
			undo.SetCustomUndoText("Undone JI RollerMine.")
			undo.SetPlayer(ply)
		undo.Finish()
	end)
	
end

/*----------------------------------------------------------------------------------
	This creates the shit for a destroyed hack
----------------------------------------------------------------------------------*/
function Burst(npc,attacker,inflictor)
	if(npc.IsAJIRollermine)then
		local roller=npc
		local selfpos=roller:GetPos()
		local Kableweh=EffectData()
		Kableweh:SetOrigin(selfpos)
		Kableweh:SetScale(4)
		util.Effect("effect_jack_rollersplode",Kableweh)
		util.BlastDamage(roller,roller,selfpos,700,500)
		roller:EmitSound("weapons/explode4.wav")
		WorldSound("BaseExplosionEffect.Sound",selfpos)
		WorldSound("ambient/explosions/explode_8.wav",selfpos,100,100)
		umsg.Start("Jacky'sRollerSplosionFlashUserMessage")
			umsg.Entity(roller)
			umsg.Vector(selfpos)
		umsg.End()
		util.ScreenShake(selfpos,99999,99999,1.5,1500)
		for i=0,5 do
			local cake=util.QuickTrace(selfpos,VectorRand()*200,roller)
			if(cake.Hit)then
				util.Decal("Scorch",cake.HitPos+cake.HitNormal,cake.HitPos-cake.HitNormal)
			end
		end
	end
end
hook.Add("OnNPCKilled","JIRollerBombDeath",Burst)