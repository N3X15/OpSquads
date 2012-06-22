/*-----------------------------------------------------------------
	Change these values to edit behaviors
------------------------------------------------------------------*/
local DeathZombiesMakeConstantNoise=true

/*---------------------------------------------------------------
	Brand new allegiance system
	
	I pledge allegiance
	to the flag
	of the United States of America
	and to the republic
	for which it stands
	one nation
	under God
	indivisible
	with liberty and justice for all
---------------------------------------------------------------*/
local HasDefaultAllegianceTable={"npc_zombie","npc_fastzombie","npc_zombie_torso","npc_fastzombie_torso","npc_poisonzombie","npc_zombine","npc_headcrab","npc_headcrab_fast","npc_headcrab_poison","npc_headcrab_black","npc_antlion","npc_antlion_worker","npc_antlionguard","npc_vortigaunt","npc_antlion_grub","npc_barnacle","npc_pigeon","npc_seagull","npc_crow","npc_citizen","npc_alyx","npc_monk","npc_barney","npc_kleiner","npc_breen","npc_magnusson","npc_eli","npc_mossman","npc_gman","npc_combine_s","npc_metropolice","npc_hunter","npc_clawscanner","npc_combinegunship","npc_combinedropship","npc_rollermine","npc_turret_floor","npc_turret_ceiling","npc_turret_ground","npc_cscanner","npc_manhack","npc_helicopter","npc_dog"}
local DefaultAllegianceTable={
	["npc_zombie"]="Necrotic",
	["npc_fastzombie"]="Necrotic",
	["npc_zombie_torso"]="Necrotic",
	["npc_fastzombie_torso"]="Necrotic",
	["npc_poisonzombie"]="Necrotic",
	["npc_zombine"]="Necrotic",
	["npc_headcrab"]="Necrotic",
	["npc_headcrab_fast"]="Necrotic",
	["npc_headcrab_poison"]="Necrotic",
	["npc_headcrab_black"]="Necrotic",
	["npc_antlion"]="XenoCreature",
	["npc_antlion_worker"]="XenoCreature",
	["npc_antlionguard"]="XenoCreature",
	["npc_vortigaunt"]="Human",
	["npc_antlion_grub"]="XenoCreature",
	["npc_barnacle"]="Necrotic",
	["npc_pigeon"]="Inconsequential",
	["npc_seagull"]="Inconsequential",
	["npc_crow"]="Inconsequential",
	["npc_citizen"]="Human",
	["npc_alyx"]="Human",
	["npc_monk"]="Human",
	["npc_barney"]="Human",
	["npc_kleiner"]="Human",
	["npc_breen"]="Combine",
	["npc_magnusson"]="Human",
	["npc_eli"]="Human",
	["npc_mossman"]="Human",
	["npc_gman"]="Human",
	["npc_combine_s"]="Combine",
	["npc_metropolice"]="Combine",
	["npc_hunter"]="Combine",
	["npc_clawscanner"]="Combine",
	["npc_combinegunship"]="Combine",
	["npc_combinedropship"]="Combine",
	["npc_rollermine"]="Combine",
	["npc_turret_floor"]="Combine",
	["npc_turret_ceiling"]="Combine",
	["npc_turret_ground"]="Combine",
	["npc_cscanner"]="Combine",
	["npc_manhack"]="Combine",
	["npc_helicopter"]="Combine",
	["npc_dog"]="Human"
}
local HasParentRelationsTable={"npc_manhack","npc_headcrab_poison","npc_antlion","npc_rollermine"}
local ParentRelationTable={
	["npc_manhack"]={Parent="npc_metropolice",SpawnDistance=50},
	["npc_headcrab_poison"]={Parent="npc_poisonzombie",SpawnDistance=75},
	["npc_antlion"]={Parent="npc_antlionguard",SpawnDistance=400},
	["npc_rollermine"]={Parent="npc_combinedropship",SpawnDistance=25}
}
local function SetUpAllegiances(NpcOne)
	if(SERVER)then
		timer.Simple(0.1,function()
			if(IsValid(NpcOne))then
				if(NpcOne.HasAJackyAllegiance)then
					if((NpcOne.JackyAllegiance=="Human")or(NpcOne.JackyAllegiance=="Player"))then
						NpcOne:AddRelationship("player D_LI 50")
					elseif(NpcOne.JackyAllegiance=="Inconsequential")then
						NpcOne:AddRelationship("player D_NU 50")
					else
						NpcOne:AddRelationship("player D_HT 50")
					end
					for key,NpcTwo in pairs(ents.GetAll())do
						if not(NpcOne==NpcTwo)then
							if(NpcTwo.HasAJackyAllegiance)then
								if(NpcOne.JackyAllegiance==NpcTwo.JackyAllegiance)then
									NpcOne:AddEntityRelationship(NpcTwo,D_LI,50)
									NpcTwo:AddEntityRelationship(NpcOne,D_LI,50)
									//print("special set "..tostring(NpcOne).." "..tostring(NpcTwo).." like")
								else
									NpcOne:AddEntityRelationship(NpcTwo,D_HT,50)
									NpcTwo:AddEntityRelationship(NpcOne,D_HT,50)
									//print("special set "..tostring(NpcOne).." "..tostring(NpcTwo).." hate")
								end
								if((NpcOne.JackyAllegiance=="Inconsequential")or(NpcTwo.JackyAllegiance=="Inconsequential"))then
									NpcOne:AddEntityRelationship(NpcTwo,D_NU,50)
									NpcTwo:AddEntityRelationship(NpcOne,D_NU,50)
									//print("special set "..tostring(NpcOne).." "..tostring(NpcTwo).." neutral")
								end
								if(NpcOne.JackyAllegience=="Prey")then
									NpcOne:AddEntityRelationship(NpcTwo,D_FR,99)
									NpcTwo:AddEntityRelationship(NpcOne,D_HT,99)
								end
								if(NpcTwo.JackyAllegience=="Prey")then
									NpcOne:AddEntityRelationship(NpcTwo,D_HT,99)
									NpcTwo:AddEntityRelationship(NpcOne,D_FR,99)
								end
							end
						end
					end
				else
					if(table.HasValue(HasDefaultAllegianceTable,NpcOne:GetClass()))then
						NpcOne.HasAJackyAllegiance=true
						NpcOne.JackyAllegiance=DefaultAllegianceTable[NpcOne:GetClass()]
					end
					local Clayuss=NpcOne:GetClass()
					if(table.HasValue(HasParentRelationsTable,Clayuss))then --this is for when NPCs create other NPCs. So we can set the child NPCs allegiances correctly
						for key,parent in pairs(ents.FindByClass(ParentRelationTable[Clayuss].Parent))do
							local dist=(NpcOne:LocalToWorld(NpcOne:OBBCenter())-parent:LocalToWorld(parent:OBBCenter())):Length()
							if(dist<ParentRelationTable[Clayuss].SpawnDistance)then
								NpcOne.HasAJackyAllegiance=true
								NpcOne.JackyAllegiance=parent.JackyAllegiance
							end
						end
					end
					SetUpAllegiances(NpcOne)
				end
			end
		end)
	end
end
hook.Add("OnEntityCreated","JackyAllegianceSystem",SetUpAllegiances)

/*----------------------------------------------------------
	Damage scaling and whatnot
-----------------------------------------------------------*/
function KaWhack(ent,inflictor,attacker,amount,dmginfo)
	
	if(attacker.NeedsMoarFirePower)then
		dmginfo:ScaleDamage(3)            --for shit's sake. Aircraft mounted weaponry shreds things.
	elseif(attacker.NeedsALittleMoarFirePower)then
		dmginfo:ScaleDamage(2)
	elseif(attacker.NeedsWayTheHellMoarFirePower)then
		dmginfo:ScaleDamage(20)
	elseif(attacker.NeedsATinyBitMoarFirePower)then
		dmginfo:ScaleDamage(1.5)
	else	
		local Multiplier=1
		if(attacker.IsUsingAnHKWeapon)then Multiplier=Multiplier+0.2 end
		if(attacker.IsUsingAmericanAmmunition)then Multiplier=Multiplier+0.6 end
		if(attacker.IsUsingABeastWeapon)then Multiplier=Multiplier+5 end
		if(attacker.CanShootWellAtVitalAreas)then
			Multiplier=Multiplier+0.5
		elseif(attacker.CanShootExceptionallyWellAtVitalAreas)then
			Multiplier=Multiplier+0.7
		elseif(attacker.CanShootExtraordinarilyWellAtVitalAreas)then
			Multiplier=Multiplier+0.9 
		end
		dmginfo:ScaleDamage(Multiplier)
	end
	
	if(ent.HasHighTechJIArmor)then
		dmginfo:ScaleDamage(0.2)
	elseif(ent.HasAdvancedCombineBodyArmor)then
		dmginfo:ScaleDamage(0.3)
	elseif(ent.HasAmericanBodyArmor)then
		dmginfo:ScaleDamage(0.25)
	elseif(ent.HasAThickMetalCasing)then
		if(dmginfo:GetDamage()<750)then
			dmginfo:SetDamage(0)
		end
	end
	
	if(ent.IsDeathZombie)then
		local blarg=EffectData()
		blarg:SetOrigin(ent:GetPos()+Vector(0,0,15))
		blarg:SetScale(dmginfo:GetDamage()*10)
		if(IsValid(inflictor))then
			if(IsValid(inflictor:GetPos()))then
				blarg:SetNormal((ent:GetPos()-inflictor:GetPos()):Normalize())
			else
				blarg:SetNormal((ent:GetPos()-attacker:GetPos()):Normalize())
			end
		else
			blarg:SetNormal((ent:GetPos()-attacker:GetPos()):Normalize())
		end
		util.Effect("effect_jack_deathzombiehit",blarg)
	end
	
	if((attacker.IsDeathZombie)and not(dmginfo:GetDamageType()==DMG_BLAST))then
		dmginfo:ScaleDamage(5)
	elseif((attacker.IsDeathZombie)and(dmginfo:GetDamageType()==DMG_BLAST))then
		dmginfo:ScaleDamage(0.5)
	end
	
	if(attacker:IsNPC())then
		local Wap=attacker:GetActiveWeapon() --general damage modding
		if(IsValid(Wap))then
			if(string.find(Wap:GetClass(),"wep_jack_combine_"))then
				dmginfo:ScaleDamage(0.8)
			end
		end
	end
end
hook.Add("EntityTakeDamage","OpSquadDamageScaling",KaWhack)

/*-----------------------------------------------------------------
	This is the stuff that makes the deathzombies epic
-----------------------------------------------------------------*/
function EmitShit()
	for key,found in pairs(ents.FindByClass("npc_*"))do
		if not(IsValid(found))then return end
		if not(found.IsDeathZombie)then return end
		local chance=math.random(1,3)
		if(chance==1)then
			local tracedata = {}
			local FFFUUU=found:GetPos()+Vector(math.Rand(-10,10),math.Rand(-10,10),20)
			tracedata.start = FFFUUU
			tracedata.endpos = FFFUUU+Vector(0,0,-250)
			tracedata.filter = found
			local tr = util.TraceLine(tracedata)
			if(tr.Hit)then
				util.Decal("Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			end
		end
		
		if(DeathZombiesMakeConstantNoise)then
			local snog=math.random(1,10)
			if(snog==6)then
				local before=found:Health()
				if(CLIENT)then return end
				if(IsValid(found))then found:TakeDamage(1,worldspawn) end
				found:SetHealth(before)
			end
		end
	end
end
hook.Add("Think","DeathZombiesDripShit",EmitShit)

function ScaleDeathZombieDamage(npc,hitgroup,dmginfo)
	if((npc.IsDeathZombie)and(hitgroup==HITGROUP_HEAD))then
		dmginfo:ScaleDamage(0.1)
	end
end
hook.Add("ScaleNPCDamage","NoHeadshotsForYou",ScaleDeathZombieDamage)

function ScaleHyperEliteCombineHeadshotDamage(npc,hitgroup,dmginfo)
	if((npc.HasAnAdvancedCombineHelmet)and(hitgroup==HITGROUP_HEAD))then
		dmginfo:ScaleDamage(0.1)
		local dtype=dmginfo:GetDamageType()
		if((dtype==DMG_BULLET)or(dtype==DMG_BUCKSHOT)or(dtype==4098)or(dtype==8194)or(dtype==536875008)or(dtype==536879104)or(dtype==134217792))then
			npc:EmitSound("lolsounds/ricochet"..math.random(1,2)..".wav",75,100)
			local Bewlat={}
			Bewlat.Num=1
			Bewlat.Src=npc:GetPos()+Vector(0,0,60)
			Bewlat.Dir=VectorRand()
			Bewlat.Spread=Vector(0,0,0)
			Bewlat.Tracer=1
			Bewlat.TracerName="Tracer"
			Bewlat.Force=20
			Bewlat.Damage=2
			Bewlat.Attacker=dmginfo:GetAttacker()
			Bewlat.Inflictor=dmginfo:GetInflictor()
			npc:FireBullets(Bewlat)
		end
	elseif((npc.HasAmericanBodyArmor)and(hitgroup==HITGROUP_HEAD))then
		dmginfo:ScaleDamage(1)
	end
end
hook.Add("ScaleNPCDamage","NoHeadshotsForYouOnCombine",ScaleHyperEliteCombineHeadshotDamage)

function DeathZombieDeath(ent,attacker,inflictor)
	if not(ent.IsDeathZombie)then return end
	
	local explo=ents.Create("env_explosion")
	explo:SetOwner(ent)
	explo:SetPos(ent:GetPos()+Vector(0,0,20))
	explo:SetKeyValue("iMagnitude","50")
	explo:Spawn()
	explo:Activate()
	explo:Fire("Explode","",0)
	
	local smoke=EffectData()
		smoke:SetOrigin(ent:GetPos())
	util.Effect("effect_jack_bloodsplosion",smoke)
	
	ent:EmitSound("lolsounds/spluck.wav",500,100)
	
	local bloodsikins=EffectData()
		bloodsikins:SetOrigin(ent:GetPos())
	util.Effect("effect_mad_gnomatron10",bloodsikins)
	
	local blood=ents.Create("ent_jack_blood")
	blood:SetPos(ent:GetPos()+Vector(0,0,20))
	blood:Spawn()
	blood:Activate()
	
	local blood=ents.Create("ent_jack_blood")
	blood:SetPos(ent:GetPos()+Vector(0,0,20))
	blood:Spawn()
	blood:Activate()
	
	local blood=ents.Create("ent_jack_blood")
	blood:SetPos(ent:GetPos()+Vector(0,0,20))
	blood:Spawn()
	blood:Activate()
	
	local blood=ents.Create("ent_jack_blood")
	blood:SetPos(ent:GetPos()+Vector(0,0,20))
	blood:Spawn()
	blood:Activate()
	
	local blood=ents.Create("ent_jack_blood")
	blood:SetPos(ent:GetPos()+Vector(0,0,20))
	blood:Spawn()
	blood:Activate()
end
hook.Add("OnNPCKilled","DeathZombieDeath",DeathZombieDeath)

function ObliterateBody(ent,ragdoll)
	if((ent.IsDeathZombie)or(ent.IsJIViscerator))then --also remove JI Viscerators on death
		SafeRemoveEntity(ragdoll)
	end
	if(ent.IsACavernGuard)then --this just makes cavern guards' skin not revert to normal when they die
		ragdoll:SetMaterial("valvescavernbreed")
	elseif(ent.HasBadassCyclopsSkin)then
		ragdoll:SetMaterial("models/combine/cyclops")
	elseif(ent.HasBadassCombineSoldierSkin)then
		ragdoll:SetMaterial("models/combine/soldier")
	elseif(ent.HasBadassMetrocopSkin)then
		ragdoll:SetMaterial("models/combine/badass_sheet")
	end
end
hook.Add("CreateEntityRagdoll","DeathZombiesLeaveNoCorpses",ObliterateBody)

/*-----------------------------------------------------------------------
	This will make the NPCs in my OpSquads drop things.
	and it makes sure the timers are destroyed when someone dies
	and it makes the NPCs in my squads impervious to being damaged by their own ragdolls
-----------------------------------------------------------------------*/
function OpSquadDrop(NPC,killer,weapon)
	local pos=NPC:GetPos()
	if(NPC.OPSQUADWillDropIonBalls)then  				 --commented out because they already drop them
		local bawl=ents.Create("item_ammo_ar2_altfire")
		bawl:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		bawl:Spawn()
		bawl:Activate()
		timer.Simple(0.1,function()
			if(IsValid(bawl))then
				if(IsValid(bawl:GetPhysicsObject()))then
					bawl:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	elseif(NPC.OPSQUADWillDropGrenades)then
		local gernade=ents.Create("weapon_frag")
		gernade:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		gernade:Spawn()
		gernade:Activate()
		timer.Simple(0.1,function()
			if(IsValid(gernade))then
				if(IsValid(gernade:GetPhysicsObject()))then
					gernade:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	elseif(NPC.OPSQUADWillDropSMGGrenade)then
		local gernade=ents.Create("item_ammo_smg1_grenade")
		gernade:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		gernade:Spawn()
		gernade:Activate()
		timer.Simple(0.1,function()
			if(IsValid(gernade))then
				if(IsValid(gernade:GetPhysicsObject()))then
					gernade:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	end
	if(NPC.OPSQUADWillDropBattery)then
		local batt=ents.Create("item_battery")
		batt:SetPos(pos+Vector(0,0,2.5))
		batt:Spawn()
		batt:Activate()
	elseif(NPC.OPSQUADWillDropShotgunAmmo)then
		local box=ents.Create("item_box_buckshot")
		box:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		box:Spawn()
		box:Activate()
		timer.Simple(0.1,function()
			if(IsValid(box))then
				if(IsValid(box:GetPhysicsObject()))then
					box:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	elseif(NPC.OPSQUADMineDroppinMotherFucker)then
		if(timer.IsTimer("OPSQUADMineDroppinMotherFucker"..NPC:EntIndex()))then
			timer.Destroy("OPSQUADMineDroppinMotherFucker"..NPC:EntIndex())
		end
	elseif(NPC.OPSQUADStrider)then
		if(timer.IsTimer("OPSQUADWarspaceCannoneer"..NPC:EntIndex()))then
			timer.Destroy("OPSQUADWarspaceCannoneer"..NPC:EntIndex())
		end
		if(timer.IsTimer("OPSQUADRandomCroucher"..NPC:EntIndex()))then
			timer.Destroy("OPSQUADRandomCroucher"..NPC:EntIndex())
		end
	elseif(NPC.OPSQUADGunship)then
		if(timer.IsTimer("OPSQUADWarspaceCannoneer"..NPC:EntIndex()))then
			timer.Destroy("OPSQUADWarspaceCannoneer"..NPC:EntIndex())
		end
	elseif(NPC.OPSQUADWillDropAlphaGland)then
		local gland=ents.Create("weapon_bugbait")
		gland:SetPos(pos+Vector(0,0,55))
		gland:Spawn()
		gland:Activate()
		timer.Simple(0.1,function()
			if(IsValid(gland))then
				if(IsValid(gland:GetPhysicsObject()))then
					gland:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	elseif(NPC.OPSQUADWillDropRPGRound)then
		local rocket=ents.Create("item_rpg_round")
		rocket:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		rocket:Spawn()
		rocket:Activate()
		timer.Simple(0.1,function()
			if(IsValid(rocket))then
				if(IsValid(rocket:GetPhysicsObject()))then
					rocket:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	elseif(NPC.OPSQUADWillDropPistolAmmo)then
		local box=ents.Create("item_ammo_pistol")
		box:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		box:Spawn()
		box:Activate()
		timer.Simple(0.1,function()
			if(IsValid(box))then
				if(IsValid(box:GetPhysicsObject()))then
					box:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	elseif(NPC.OPSQUADWillDropSMGAmmo)then
		local box=ents.Create("item_ammo_smg1")
		box:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		box:Spawn()
		box:Activate()
		timer.Simple(0.1,function()
			if(IsValid(box))then
				if(IsValid(box:GetPhysicsObject()))then
					box:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	elseif(NPC.OPSQUADWillDropAR2Ammo)then
		local mag=ents.Create("item_ammo_ar2")
		mag:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		mag:Spawn()
		mag:Activate()
		timer.Simple(0.1,function()
			if(IsValid(mag))then
				if(IsValid(mag:GetPhysicsObject()))then
					mag:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	elseif(NPC.OPSQUADWillDropRevolverAmmo)then
		local mag=ents.Create("item_ammo_357")
		mag:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		mag:Spawn()
		mag:Activate()
		timer.Simple(0.1,function()
			if(IsValid(mag))then
				if(IsValid(mag:GetPhysicsObject()))then
					mag:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	end
	if(NPC.OPSQUADWillDropHealthVial)then
		local vial=ents.Create("item_healthvial")
		vial:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		vial:Spawn()
		vial:Activate()
		timer.Simple(0.1,function()
			if(IsValid(vial))then
				if(IsValid(vial:GetPhysicsObject()))then
					vial:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	end
	if(NPC.OPSQUADWillDropHealthKit)then
		local vial=ents.Create("item_healthkit")
		vial:SetPos(pos+Vector(0,0,30)+VectorRand()*math.Rand(1,8))
		vial:Spawn()
		vial:Activate()
		timer.Simple(0.1,function()
			if(IsValid(vial))then
				if(IsValid(vial:GetPhysicsObject()))then
					vial:GetPhysicsObject():SetVelocity(Vector(0,0,0))
				end
			end
		end)
	end
	if(NPC.OPSQUADWillDropCombineTech)then
		local batteriesgiven=0
		while(batteriesgiven<4)do
			local ent=ents.Create("item_battery")
			ent:SetPos(pos)
			ent:Spawn()
			ent:Activate()
			ent:GetPhysicsObject():SetVelocity(NPC:GetVelocity())
			batteriesgiven=batteriesgiven+1
		end
		local ar2ammogiven=0
		while(ar2ammogiven<6)do
			local ent=ents.Create("item_ammo_ar2")
			ent:SetPos(pos)
			ent:Spawn()
			ent:Activate()
			ent:GetPhysicsObject():SetVelocity(NPC:GetVelocity())
			ar2ammogiven=ar2ammogiven+1
		end
	end
	if(timer.IsTimer("JackyBleedingOnEntity"..NPC:EntIndex()))then
		timer.Destroy("JackyBleedingOnEntity"..NPC:EntIndex())
	end
end
hook.Add("OnNPCKilled","Jacky'sOpSquadDrop",OpSquadDrop)

//function MakeBodyInSquad(ent,ragdoll)
//	if(ent.InAJackyAntlionSquad)then
//		ragdoll.InAJackyAntlionSquad=true
//	elseif(ent.InAJackyCombineSquad)then
//		ragdoll.InAJackyCombineSquad=true
//	elseif(ent.InAJackyHumanSquad)then
//		ragdoll.InAJackyHumanSquad=true
//	elseif(ent.InaJackyZombieSquad)then
//		ragdoll.InAJackyZombieSquad=true
//	end
//end
//hook.Add("CreateEntityRagdoll","YouDontDieByTouchingABody",MakeBodyInSquad)


/*------------------------------------------------------------------
	Keep the fucking squads from killing themselves
	also, make the turrets destructible
	also, it makes the combine dropships destructible
	also, it attempts to integrate any npc-created npcs into the squad
	and it puts the hunter and strider together d'aww :3
------------------------------------------------------------------*/
function FriendlyFire(ent,inflictor,attacker,amount,dmginfo)
	if((ent.HasAJackyAllegiance)and(attacker.HasAJackyAllegiance))then
		if(ent.JackyAllegiance==attacker.JackyAllegiance)then
			if not((attacker:GetClass()=="npc_zombine")and(attacker==ent))then
				dmginfo:ScaleDamage(0.1)
			end
		end
		
		for key,found in pairs(ents.FindByClass("npc_*"))do
			if((found.OPSQUADNeedsAStrider)and not(found.OPSQUADHasAStrider))then
				local hunter=found
				for key,finded in pairs(ents.FindByClass("npc_strider"))do
					if((finded.OPSQUADNeedsAHunter)and not(finded.OPSQUADHasAHunter))then
						local name="HasAHunterProtecting"..finded:EntIndex()
						finded:SetName(name)
						found:Fire("followstrider",name,0)
						finded.OPSQUADHasAHunter=true
						found.OPSQUADHasAStrider=true
					end
				end
			end
		end
		
		if((ent.HasAJackyAllegiance)and(ent:GetClass()=="npc_turret_floor"))then
			ent.Damage=ent.Damage+dmginfo:GetDamage()
	//		ent.Sploding=false    --same here as below
			if((ent.Damage>2000)and not(ent.Sploding))then
				ent.Sploding=true
				ent:Fire("selfdestruct","",0)
			end
		end
		
		if((ent.HasAJackyAllegiance)and(ent:GetClass()=="npc_helicopter"))then
			ent.Damage=ent.Damage+dmginfo:GetDamage()
	//		ent.Sploding=false    --same here as below
			if(ent.Damage>750)then
				ent:Fire("selfdestruct","",0)
			end
		end
	end	
	if((attacker.HasAJackyAllegiance)and((attacker:GetClass()=="npc_strider")or(attacker:GetClass()=="npc_combinegunship")or(attacker:GetClass()=="npc_helicopter")))then
		if((ent:GetClass()=="npc_strider")or(ent:GetClass()=="npc_helicopter")or(ent:GetClass()=="npc_combinegunship")or(ent:GetClass()=="npc_combinedropship"))then
			if(math.random(1,4)==2)then
				util.BlastDamage(inflictor,GetWorldEntity(),ent:GetPos(),300,50)
			end
		end
	end
	if((ent.HasAJackyAllegiance)and(ent:GetClass()=="npc_combinedropship"))then
		ent.Damage=ent.Damage+dmginfo:GetDamage()
		if((ent.Damage>700)and not(ent.Sploding))then
			ent.Sploding=true
			local attackwhore=dmginfo:GetAttacker()
			local explo=ents.Create("env_explosion")
			explo:SetOwner(attackwhore)
			explo:SetPos(ent:GetPos()+VectorRand()*math.Rand(0,200))
			explo:SetKeyValue("iMagnitude","100")
			explo:Spawn()
			explo:Activate()
			explo:Fire("Explode","",0)
			timer.Simple(1,function()
				if(IsValid(ent))then
					local explo=ents.Create("env_explosion")
					explo:SetOwner(attackwhore)
					explo:SetPos(ent:GetPos()+VectorRand()*math.Rand(0,200))
					explo:SetKeyValue("iMagnitude","100")
					explo:Spawn()
					explo:Activate()
					explo:Fire("Explode","",0)
					local explo=ents.Create("env_explosion")
					explo:SetOwner(attackwhore)
					explo:SetPos(ent:GetPos()+VectorRand()*math.Rand(0,200))
					explo:SetKeyValue("iMagnitude","100")
					explo:Spawn()
					explo:Activate()
					explo:Fire("Explode","",0)
				end
			end)
			timer.Simple(1.5,function()
				if(IsValid(ent))then
					local explosions=0
					while(explosions<7)do
						local explo=ents.Create("env_explosion")
						explo:SetOwner(attackwhore)
						explo:SetPos(ent:GetPos()+VectorRand()*math.Rand(0,200))
						explo:SetKeyValue("iMagnitude","100")
						explo:Spawn()
						explo:Activate()
						explo:Fire("Explode","",0)
						explosions=explosions+1
					end
					WorldSound("lolsounds/gunship_explode2.wav",ent:GetPos(),50,100)
					SafeRemoveEntity(ent)
				end
			end)
		end
	end
end
hook.Add("EntityTakeDamage","Jacky'sOpSquadsFriendlyFire",FriendlyFire)

/*--------------------------------------------------------------------
	This makes the bugbait work... a little...
--------------------------------------------------------------------*/
function AntlionControlSecondary(found,key)
	if not(IsValid(found))then return end
	if not(found:Alive())then return end
	if not(found:GetActiveWeapon())then return end
	if not(IsValid(found:GetActiveWeapon()))then return end
	if(found:GetActiveWeapon():GetClass()=="weapon_bugbait")then
		if(key==IN_ATTACK2)then
			for key,antlion in pairs(ents.FindInSphere(found:GetPos(),1000))do
				if(antlion:GetClass()=="npc_antlion")or(antlion:GetClass()=="npc_antlion_worker")then
					if(CLIENT)then return end
					if(IsValid(antlion))then antlion:AddEntityRelationship(found,D_LI,90) end
					if(IsValid(antlion))then antlion.IsAnUnderControlAntlion=true end
				end
			end
		end
	end
end
hook.Add("KeyPress","Jacky'sBugBaitFixSecondary",AntlionControlSecondary)

function AntlionControlPrimary(found,key)
	if not(IsValid(found))then return end
	if not(found:Alive())then return end
	if not(found:GetActiveWeapon())then return end
	if not(IsValid(found:GetActiveWeapon()))then return end
	if(found:GetActiveWeapon():GetClass()=="weapon_bugbait")then
		if(key==IN_ATTACK)then
			local traceres=found:GetEyeTraceNoCursor()
			if not(traceres.Hit)then return end
			if not(IsValid(traceres.Entity))then return end
			local target=traceres.Entity
			if((target:IsNPC())or(target:IsPlayer()))then
				for key,ourantlion in pairs(ents.FindByClass("npc_*"))do
					if((ourantlion:GetClass()=="npc_antlion")or(ourantlion:GetClass()=="npc_antlion_worker"))then
						if not(ourantlion.IsAnUnderControlAntlion)then return end
						if(CLIENT)then return end
						ourantlion:AddEntityRelationship(target,D_HT,95)
						if(target.InAJackyAntlionSquad)then
							target.InAJackyAntlionSquad=false
						end
					end
				end
			end
		end
	end
end
hook.Add("KeyPress","Jacky'sBugBaitFixPrimary",AntlionControlPrimary)

/*---------------------------------------------------------------------------
	So that NPC SWEPs can have think functions
---------------------------------------------------------------------------*/
if(SERVER)then
	local function JackyGlobalThink()
		for key,found in pairs(ents.FindByClass("wep_jack_*"))do
			if(found.NeedsJackyDrivenGlobalThink)then
				found:ExtraThink()
			end
		end
	end
	hook.Add("Think","JackyGlobalSWEPThinkFunction",JackyGlobalThink)
end