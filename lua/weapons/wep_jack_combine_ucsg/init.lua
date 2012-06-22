AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include("ai_translations.lua")

SWEP.Weight=5
SWEP.AutoSwitchTo=false
SWEP.AutoSwitchFrom=false

function SWEP:HeightCorrection()
	local NeedsHeightCorrectionTable={"npc_headcrab_black","npc_headcrab_poison","npc_pigeon","npc_crow","npc_seagull","npc_zombie","npc_zombine","player","npc_citizen","npc_hunter","npc_combine_s"}
	local HeightCorrectionTable={
		["npc_pigeon"]=-6,
		["npc_crow"]=-6,
		["npc_seagull"]=-6,
		["npc_zombie"]=10,
		["npc_zombine"]=7,
		["player"]=17,
		["npc_citizen"]=17,
		["npc_hunter"]=20,
		["npc_combine_s"]=10,
		["npc_headcrab_black"]=-5,
		["npc_headcrab_poison"]=-5
	}
	local Enemy=self.Owner:GetEnemy()
	local Class=Enemy:GetClass()
	if(table.HasValue(NeedsHeightCorrectionTable,Class))then
		return Vector(0,0,HeightCorrectionTable[Class])
	else
		return Vector(0,0,0)
	end
end

local NPCSizeTable={
	[HULL_HUMAN]=35,
	[HULL_SMALL_CENTERED]=50,
	[HULL_WIDE_HUMAN]=60,
	[HULL_TINY]=32,
	[HULL_WIDE_SHORT]=100,
	[HULL_MEDIUM]=75,
	[HULL_TINY_CENTERED]=30,
	[HULL_LARGE]=75,
	[HULL_LARGE_CENTERED]=80,
	[HULL_MEDIUM_TALL]=55
}

local NoHealthTable={"npc_rollermine","npc_turret_floor","npc_combinedrophship","npc_combinegunship","npc_helicopter"}

function SWEP:CanSee(Ent)
	local TressDet={}
	TressDet.start=self.Owner:GetShootPos()
	TressDet.endpos=Ent:LocalToWorld(Ent:OBBCenter())
	TressDet.filter={self.Owner,Ent}
	TressDet.mask=MASK_SHOT
	local Tress=util.TraceLine(TressDet)
	if(Tress.Hit)then
		return false
	else
		return true
	end
end

function SWEP:BadGuy()
	if(IsValid(self.Owner))then
		local Dude=self.Owner:GetEnemy()
		if(IsValid(Dude))then
			if(self:CanSee(Dude))then
				return Dude
			else
				return nil
			end
		else
			return nil
		end
	else
		return nil
	end
end

function SWEP:ExtraThink()
	if(IsValid(self.Owner))then
		if not(self.Reloading)then
			if(self.RunningAway)then return end
			local Act=self.Owner:GetActivity()
			local Enemy=self:BadGuy()
			if(IsValid(Enemy))then
				if(self.NextPrioritizeTime<CurTime())then
					local Dist=200
					local Enem=nil
					for key,found in pairs(ents.FindInSphere(self.Owner:GetPos(),200))do
						if(self.Owner:Disposition(found)==D_HT)then
							if(self:CanSee(found))then
								local CurrentDist=(self.Owner:GetPos()-found:GetPos()):Length()
								if(CurrentDist<Dist)then
									Dist=CurrentDist
									Enem=found
								end
							end
						end
					end
					if(IsValid(Enem))then self.Owner:SetEnemy(found) end
					self.NextPrioritizeTime=CurTime()+1
				end
				if((Act==ACT_COWER)or(Act==ACT_IDLE))then
					self.Owner:SetSchedule(SCHED_RANGE_ATTACK1)
				end
				if((Enemy:Health()>0)or(table.HasValue(NoHealthTable,Enemy:GetClass())))then
					local SelfPos=self.Owner:GetPos()
					local EnemyPos=Enemy:GetPos()
					EnemyPos=Vector(EnemyPos.x,EnemyPos.y,SelfPos.z)
					local Vec=(SelfPos-EnemyPos)
					local Dist=Vec:Length()
					local Dir=Vec:GetNormalized()
					local StandoffDist=35
					if(Enemy:IsNPC())then StandoffDist=NPCSizeTable[Enemy:GetHullType()] end  --specifically, how close we should get before we rape. WE GET RIGHT UP IN THEIR FACE
					if(Dist>400)then
						self.Owner:SetLastPosition(SelfPos-Dir*200)
						self.Owner:SetSchedule(SCHED_FORCED_GO_RUN)
					elseif(Dist>StandoffDist*1.75)then
						if(Enemy:IsPlayer())then
							self.Owner:SetLastPosition(EnemyPos+Dir*35)
						else
							self.Owner:SetLastPosition(EnemyPos+Dir*StandoffDist)
						end
						self.Owner:SetSchedule(SCHED_FORCED_GO_RUN)
					end
				end
			elseif(Act==ACT_COWER)then
				self.Owner:SetSchedule(SCHED_RUN_RANDOM)
			end
		end
	end
end

//OH FOR FUCK'S SAKE
//local function PrioritizeYouRetardedJackass(victim,inflictor,attacker,amount,dmginfo)
//	if((victim:IsNPC())and(IsValid(victim:GetActiveWeapon())))then
//		if(victim:GetActiveWeapon():GetClass()=="wep_jack_combineshotgun")then
//			if not(victim:Disposition(attacker)==D_LI)then
//				victim:SetEnemy(attacker)
//			end
//		end
//	end
//end
//hook.Add("EntityTakeDamage","JackysCombineShotgunPrioritization",PrioritizeYouRetardedJackass)

/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire secondary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Secondary(ShootPos,ShootDir)
	//the fuck are you doing, son?
end

function SWEP:OnDrop()
	local wep=ents.Create("weapon_shotgun")
	wep:SetPos(self:GetPos())
	wep:SetAngles(self:GetAngles())
	self:Remove()
	wep:Spawn()
	wep:Activate()
end

/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire primary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Primary(ShootPos,ShootDir)
 if((not(self.Reloading))and not(self.RunningAway))then self:Shoot(ShootPos,ShootDir) end
end

function SWEP:Shoot(ShootPos,ShootDir)
	local Enemy=self:BadGuy()
	if not(IsValid(Enemy))then return end
	if((Enemy:Health()>0)or(table.HasValue(NoHealthTable,Enemy:GetClass())))then
		WorldSound("weapons/explode3.wav",ShootPos,100,130)
		WorldSound("Weapon_AR2.NPC_Single",ShootPos,100,100)
		WorldSound("Weapon_Shotgun.NPC_Single",ShootPos,100,100)

		local ShootAng=ShootDir:Angle()
		local angpos=self:GetAttachment(self:LookupAttachment("muzzle"))
		local ShootOrigin=angpos.Pos+angpos.Ang:Forward()*25+angpos.Ang:Up()*5
		
		local Kabang=EffectData()
		Kabang:SetStart(ShootOrigin)
		Kabang:SetNormal(ShootDir)
		Kabang:SetScale(1.75)
		util.Effect("effect_jack_combinemuzzle",Kabang)

		local Dist=(Enemy:GetPos()-self.Owner:GetPos()):Length()
		local EnemyPos=Enemy:LocalToWorld(Enemy:OBBCenter())
		local Dir=(EnemyPos-ShootPos):GetNormalized()
		
		util.BlastDamage(self.Weapon,self.Owner,EnemyPos,10,1)
		
		for i=0,40 do
			local RandomEndPos=EnemyPos+VectorRand()*math.Rand(0,Dist)
			local NewDir=(RandomEndPos-ShootPos):GetNormalized()
		
			local EyeTraceData={}
			EyeTraceData.start=ShootPos
			EyeTraceData.endpos=ShootPos+NewDir*99999
			EyeTraceData.filter=self.Owner
			EyeTraceData.mask=MASK_SHOT
			local EyeTrace=util.TraceLine(EyeTraceData)
			if(EyeTrace.Hit)then
				if not(self.Owner:Disposition(EyeTrace.Entity)==3)then
					local TravelDistance=(RandomEndPos-ShootPos):Length()
					local Damage=(math.Rand(30,40)/Dist^3)*300000
					//print(tostring(TravelDistance).." "..tostring(Damage))
				
					local Bewlat={}
					Bewlat.Num=1
					Bewlat.Damage=Damage
					Bewlat.Force=Damage*500
					Bewlat.Src=ShootPos
					Bewlat.Dir=NewDir
					Bewlat.Spread=Vector(0,0,0)
					Bewlat.Tracer=0
					self.Owner:FireBullets(Bewlat)
					
					local Spach=EffectData()
					Spach:SetOrigin(EyeTrace.HitPos)
					Spach:SetStart(ShootOrigin)
					Spach:SetScale(5000)
					util.Effect("AR2Tracer",Spach)
					
					local Sploo=EffectData()
					Sploo:SetOrigin(EyeTrace.HitPos)
					Sploo:SetScale(9000)
					Sploo:SetMagnitude(9000)
					Sploo:SetRadius(50)
					Sploo:SetNormal(EyeTrace.HitNormal)
					util.Effect("AR2Impact",Sploo)
				end
			end
		end
		local NewPos=self.Owner:GetPos()-self.Owner:GetForward()*300
		self.Owner:SetLastPosition(NewPos)
		self.Owner:SetSchedule(SCHED_FORCED_GO_RUN)
		self.RunningAway=true
		timer.Simple(1,function()
			if(IsValid(self))then
				self.RunningAway=false
				self:Reload()
			end
		end)
	end
end

function SWEP:Reload()
	if(self.Reloading)then return end
	self.Reloading=true

	local timetostart=1
	timer.Simple(0.9,function()
		if(IsValid(self))then
			if((self.Owner:GetActivity()==ACT_TRANSITION)or(self.Owner:GetActivity()==ACT_RANGE_ATTACK1))then timetostart=3.5 end
		end
	end)
	timer.Simple(timetostart,function()
		if(IsValid(self))then
			self.Owner:SetSchedule(SCHED_RELOAD)

			local TimerTable={0.225,0.475,0.925,1.925,2.025}
			
			timer.Simple(TimerTable[1],function()
				if(IsValid(self.Owner))then
					local EmptyMag=ents.Create("ent_jack_pulsemag")
					EmptyMag:SetPos(self.Owner:GetPos()+self.Owner:GetUp()*40+self.Owner:GetAimVector()*20)
					local angul=self.Owner:GetAimVector():Angle()
					angul:RotateAroundAxis(self.Owner:GetAimVector(),90)
					EmptyMag:SetAngles(angul)
					EmptyMag:SetDTBool(1,true) --make it have a cylidrical model
					EmptyMag:Spawn()
					EmptyMag:Activate()
					
					self:SetDTBool(1,false)
					self.Owner:EmitSound("lolsounds/combine_smg_ar_br_magremove.wav")
				end
			end)

			//DTBool 0 is whether or not a mag appears in the user's hand
			//DTBool 1 is whether or not a mag appears on the weapon

			timer.Simple(TimerTable[2],function()
				if(IsValid(self.Owner))then
					self:SetDTBool(0,true)
				end
			end)
			timer.Simple(TimerTable[3],function()
				if(IsValid(self.Owner))then
					self:SetDTBool(0,false)
					self:SetDTBool(1,true)
					self.Owner:EmitSound("lolsounds/combine_smg_ar_br_maginsert.wav")
					timer.Simple(0.2,function()
						if(IsValid(self))then
							self.Owner:EmitSound("lolsounds/combine_smg_ar_br_cockforward.wav",100,130)
						end
					end)
				end
			end)
			timer.Simple(TimerTable[4],function()
				if(IsValid(self))then
					self.Owner:EmitSound("lolsounds/combine_smg_ar_br_cockback.wav")
				end
			end)
			timer.Simple(TimerTable[5],function()
				if(IsValid(self))then
					self.Reloading=false
					self.Owner:EmitSound("lolsounds/combine_smg_ar_br_cockforward.wav")
				end
			end)
		end
	end)
	return true
end