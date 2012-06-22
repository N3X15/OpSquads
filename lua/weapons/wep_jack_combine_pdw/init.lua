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
				self.Owner:Fire("setammoresupplieron","",0)
				if not(self.Reloading)then
					if(Act==ACT_IDLE)then
						if(self.RoundsInPulseMag<100)then
							self:Reload(true)
						end
					end
				end
			else
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
				self.Owner:Fire("setammoresupplieroff","",0)
				local enempos=Enemy:GetPos()
				local selfpos=self.Owner:GetPos()
				enempos=Vector(enempos.x,enempos.y,selfpos.z)
				local Vec=(enempos-selfpos)
				local Dist=Vec:Length()
				local Dir=Vec:GetNormalized()
				if(Dist>1000)then
					self.Owner:SetLastPosition(self.Owner:GetPos()+Dir*100)
					self.Owner:SetSchedule(SCHED_FORCED_GO_RUN)
				else
					if(Act==ACT_IDLE)then
						self.Owner:SetSchedule(SCHED_RANGE_ATTACK1)
					end
				end
			end
		else
			self.Owner:SetPlaybackRate(1.25)
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
	local wep=ents.Create("weapon_smg1")
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
	if(self.Reloading)then return end
	self:Shoot(ShootPos,ShootDir)
	timer.Simple(0.035,function()
		if(IsValid(self))then
			if(self.RoundsInPulseMag>0)then
				self:Shoot(ShootPos,ShootDir)
				timer.Simple(0.04,function()
					if(IsValid(self))then
						if(self.RoundsInPulseMag>0)then
							self:Shoot(ShootPos,ShootDir)
						end
					end
				end)
			end
		end
	end)
	//local PossibleTargets={}
	//for key,found in pairs(ents.FindInSphere(ShootPos,500))do
	//	if((found:IsNPC())or(found:IsPlayer()))then
	//		if(self.Owner:Disposition(found)==D_HT)then
	//			table.ForceInsert(PossibleTargets,found)
	//		end
	//	end
	//end
	//local NumberOfTargets=table.Count(PossibleTargets)
	//if(NumberOfTargets>1)then
	//	self.Owner:SetEnemy(PossibleTargets[math.random(1,NumberOfTargets)]) --SPRAY N PRAY
	//end
end


function SWEP:Shoot(ShootPos,ShootDir)
	if not(IsValid(self))then return end
	local Enemy=self:BadGuy()
	if(self.RoundsInPulseMag>0)then
		if not(IsValid(self.Owner))then return end
		if not(IsValid(Enemy))then return end
		
		WorldSound("NPC_FloorTurret.Shoot",ShootPos,100,100)
		WorldSound("lolsounds/shot_echo.wav",ShootPos,75,140)

		local ShootAng=ShootDir:Angle()
		local angpos=self:GetAttachment(self:LookupAttachment("muzzle"))
		local ShootOrigin=angpos.Pos+angpos.Ang:Forward()*3
		
		local Kabang=EffectData()
		Kabang:SetStart(ShootOrigin)
		Kabang:SetNormal(ShootDir)
		Kabang:SetScale(0.5)
		util.Effect("effect_jack_combinemuzzle",Kabang)

		local Dist=(Enemy:GetPos()-self.Owner:GetPos()):Length()
		local EnemyPos=Enemy:LocalToWorld(Enemy:OBBCenter())+VectorRand()*math.Rand(0,Dist/10)+self:HeightCorrection()
		local Dir=(EnemyPos-ShootPos):GetNormalized()
		
		local EyeTraceData={}
		EyeTraceData.start=ShootPos
		EyeTraceData.endpos=ShootPos+Dir*99999
		EyeTraceData.filter=self.Owner
		EyeTraceData.mask=MASK_SHOT
		local EyeTrace=util.TraceLine(EyeTraceData)
		if(EyeTrace.Hit)then
			if not(self.Owner:Disposition(EyeTrace.Entity)==3)then
				local Damage=math.Rand(1,2)
				//if(EyeTrace.HitGroup==HITGROUP_HEAD)then Damage=1 end
				
				local Bewlat={}
				Bewlat.Num=1
				Bewlat.Damage=Damage
				Bewlat.Force=100
				Bewlat.Src=ShootPos
				Bewlat.Dir=Dir
				Bewlat.Spread=Vector(0,0,0)
				Bewlat.Tracer=0
				self.Owner:FireBullets(Bewlat)
				
				local Spach=EffectData()
				Spach:SetOrigin(EyeTrace.HitPos)
				Spach:SetStart(ShootOrigin)
				Spach:SetScale(60000)
				util.Effect("AR2Tracer",Spach)
				
				local Sploo=EffectData()
				Sploo:SetOrigin(EyeTrace.HitPos)
				Sploo:SetScale(9000)
				Sploo:SetMagnitude(9000)
				Sploo:SetRadius(50)
				Sploo:SetNormal(EyeTrace.HitNormal)
				util.Effect("AR2Impact",Sploo)
				
				self.RoundsInPulseMag=self.RoundsInPulseMag-1
			end
		end
	else
		self:Reload(false)
	end
end

function SWEP:Reload(TacticalReload)
	//citizens reload at different speed depending on whether or not the reload is necessary or vuluntary,
	//so i need to keep track of that so i can time the sounds and whatnot properly
	if(self.Reloading)then return end
	self.Reloading=true

	self.RoundsInPulseMag=100
	self.Owner:SetSchedule(SCHED_RELOAD)
	
	local TimeMul=1/1.25
	
	local TimerTable={0.5*TimeMul,1*TimeMul,1.55*TimeMul,2.15*TimeMul,2.4*TimeMul}
	if not(TacticalReload)then TimerTable={1.15*TimeMul,1.6*TimeMul,2.125*TimeMul,2.8*TimeMul,3*TimeMul}
	end
	
	//why do women reload faster than men -____-
	if(string.find(self.Owner:GetModel(),"female"))then
		TimerTable={0.475*TimeMul,0.725*TimeMul,1.2*TimeMul,1.575*TimeMul,1.7*TimeMul}
		if not(TacticalReload)then TimerTable={1.025*TimeMul,1.275*TimeMul,1.775*TimeMul,2.125*TimeMul,2.25*TimeMul} end
	end
	
	timer.Simple(TimerTable[1],function()
		if(IsValid(self.Owner))then
			if not(TacticalReload)then
				local EmptyMag=ents.Create("ent_jack_pulsemag")
				EmptyMag:SetPos(self.Owner:GetPos()+self.Owner:GetUp()*25+self.Owner:GetAimVector()*20)
				local angul=self.Owner:GetAimVector():Angle()
				angul:RotateAroundAxis(self.Owner:GetAimVector(),90)
				EmptyMag:SetAngles(angul)
				EmptyMag:SetDTBool(0,true) --make it have a combine rifle cartridge mdoel instead of a rectangular prism
				EmptyMag:Spawn()
				EmptyMag:Activate()
			else
				self:SetDTBool(0,true)
			end
			self:SetDTBool(1,false)
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_magremove.wav")
		end
	end)
	
	//DTBool 1 is whether or not the mag appears on the gun
	//DTBool 0 is whether or not a mag appears in the user's hand

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
	
	return true
end