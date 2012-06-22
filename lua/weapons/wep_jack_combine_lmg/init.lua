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
			local Enemy=self:BadGuy()
			local Act=self.Owner:GetActivity()
			if not(IsValid(Enemy))then
				if(Act==ACT_IDLE)then
					if(self.RoundsInPulseMag<200)then
						self:Reload()
					end
				end
				self.CurrentTarget=nil
			else
				if((Act==ACT_IDLE)or(Act==ACT_IDLE_RELAXED)or(ACT==SCHED_PATROL_RUN))then
					self.Owner:SetSchedule(SCHED_RANGE_ATTACK1)
				end
				if((self.NextForceFireTime<CurTime())and(Act==ACT_RANGE_ATTACK1))then
					self:Shoot(self.Owner:GetShootPos(),self.Owner:GetAimVector())
					self.NextForceFireTime=CurTime()+0.075
				end
				if not(Enemy==self.CurrentTarget)then --if we either changed target or acquired a new target
					if(self.CurrentTarget==nil)then
						self.NextShootTime=CurTime()+2
					else
						self.NextShootTime=CurTime()+0.1
					end
					self.CurrentTarget=Enemy
				end
			end
		else
			self.Owner:SetPlaybackRate(0.4)
		end
	end
end

/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire secondary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Secondary(ShootPos,ShootDir)
	//the fuck are you doing, son?
end

function SWEP:OnDrop()
	local wep=ents.Create("weapon_ar2")
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
	//lol nope :D
end


function SWEP:Shoot(ShootPos,ShootDir)
	if(self.NextShootTime>CurTime())then return end
	if(self.Reloading)then return end
	local Enemy=self:BadGuy()
	if not(IsValid(Enemy))then return end
	if(self.RoundsInPulseMag>0)then
		WorldSound("lolsounds/combinebr_close.wav",ShootPos,50,math.Rand(90,110))
		WorldSound("Weapon_AR2.NPC_Single",ShootPos,100,100)

		local ShootAng=ShootDir:Angle()
		local angpos=self:GetAttachment(self:LookupAttachment("muzzle"))
		local ShootOrigin=angpos.Pos+angpos.Ang:Forward()*19+angpos.Ang:Up()*5
		
		local Kabang=EffectData()
		Kabang:SetStart(ShootOrigin)
		Kabang:SetNormal(ShootDir)
		Kabang:SetScale(0.7)
		util.Effect("effect_jack_combinemuzzle",Kabang)

		local Dist=(Enemy:GetPos()-self.Owner:GetPos()):Length()
		local EnemyPos=Enemy:LocalToWorld(Enemy:OBBCenter())+VectorRand()*math.Rand(0,Dist/25)+self:HeightCorrection()
		local Dir=(EnemyPos-ShootPos):GetNormalized()
		
		local EyeTraceData={}
		EyeTraceData.start=ShootPos
		EyeTraceData.endpos=ShootPos+Dir*99999
		EyeTraceData.filter=self.Owner
		EyeTraceData.mask=MASK_SHOT
		local EyeTrace=util.TraceLine(EyeTraceData)
		if(EyeTrace.Hit)then
			local Bewlat={}
			Bewlat.Num=1
			Bewlat.Damage=math.Rand(10,20)
			Bewlat.Force=1000
			Bewlat.Src=ShootPos
			Bewlat.Dir=Dir
			Bewlat.Spread=Vector(0,0,0)
			Bewlat.Tracer=0
			self.Owner:FireBullets(Bewlat)
			
			local Spach=EffectData()
			Spach:SetOrigin(EyeTrace.HitPos)
			Spach:SetStart(ShootOrigin)
			Spach:SetScale(20000)
			util.Effect("AR2Tracer",Spach)
			
			local Sploo=EffectData()
			Sploo:SetOrigin(EyeTrace.HitPos)
			Sploo:SetScale(9000)
			Sploo:SetMagnitude(9000)
			Sploo:SetRadius(50)
			Sploo:SetNormal(EyeTrace.HitNormal)
			util.Effect("AR2Impact",Sploo)
		end
		self.RoundsInPulseMag=self.RoundsInPulseMag-1
	else
		self:Reload()
	end
end

function SWEP:Reload()
	if(self.Reloading)then return end
	self.Reloading=true

	self.RoundsInPulseMag=200
	self.Owner:SetSchedule(SCHED_RELOAD)
	
	//print(tostring(self.Owner:GetActivity()).." "..tostring(self.Owner:SequenceDuration()))
	
	local AddTime=0
	if not(self.Owner:GetActivity()==ACT_IDLE)then AddTime=0.5 end
	
	local TimeMul=2.4
	
	AddTime=AddTime*TimeMul

	local TimerTable={0.5*TimeMul,1*TimeMul,1.55*TimeMul,2.15*TimeMul,2.4*TimeMul}
	
	//why do women reload faster than men -____-
	if(string.find(self.Owner:GetModel(),"female"))then
		TimerTable={0.475*TimeMul,0.725*TimeMul,1.2*TimeMul,1.575*TimeMul,1.7*TimeMul}
	end
	
	timer.Simple(TimerTable[1]+AddTime,function()
		if(IsValid(self.Owner))then
			if(AddTime==0.5*TimeMul)then
				local EmptyMag=ents.Create("ent_jack_pulsemag")
				EmptyMag:SetPos(self.Owner:GetPos()+self.Owner:GetUp()*25+self.Owner:GetAimVector()*20)
				local angul=self.Owner:GetAimVector():Angle()
				angul:RotateAroundAxis(self.Owner:GetAimVector(),90)
				EmptyMag:SetAngles(angul)
				EmptyMag:SetDTBool(0,true) --make it have a combine rifle cartridge mdoel instead of a rectangular prism
				EmptyMag:SetDTBool(2,true) --make it extra large
				EmptyMag:Spawn()
				EmptyMag:Activate()
			else
				self:SetDTBool(0,true)
			end
			self:SetDTBool(1,false)
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_magremove.wav",100,90)
		end
	end)

	//DTBool 0 is whether or not a mag appears in the user's hand

	timer.Simple(TimerTable[2]+AddTime,function()
		if(IsValid(self.Owner))then
			self:SetDTBool(0,true)
		end
	end)
	timer.Simple(TimerTable[3]+AddTime,function()
		if(IsValid(self.Owner))then
			self:SetDTBool(0,false)
			self:SetDTBool(1,true)
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_maginsert.wav",100,90)
		end
	end)
	timer.Simple(TimerTable[4]+AddTime,function()
		if(IsValid(self))then
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_cockback.wav",100,90)
		end
	end)
	timer.Simple(TimerTable[5]+AddTime,function()
		if(IsValid(self))then
			self.Reloading=false
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_cockforward.wav",100,90)
		end
	end)
	
	return true
end