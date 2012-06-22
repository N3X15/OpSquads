AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include("ai_translations.lua")

SWEP.Weight=5
SWEP.AutoSwitchTo=false
SWEP.AutoSwitchFrom=false

function SWEP:HeightCorrection()
	local NeedsHeightCorrectionTable={"npc_pigeon","npc_crow","npc_seagull","npc_zombie","npc_zombine","player","npc_citizen","npc_hunter","npc_combine_s"}
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
		if(self.Reloading)then return end
		local Enemy=self:BadGuy()
		local Act=self.Owner:GetActivity()
		if not(IsValid(Enemy))then
			if(Act==ACT_IDLE)then
				if(self.RoundsInPulseMag<10)then
					self:Reload(true)
				end
			end
			for key,found in pairs(ents.FindInSphere(self.Owner:GetPos(),4000))do
				if(math.random(1,500)==42)then --don't spot instantly
					if((found:IsPlayer())or(found:IsNPC()))then
						if(self.Owner:Disposition(found)==D_HT)then
							if(self:CanSee(found))then
								self.Owner:UpdateEnemyMemory(found,found:GetPos())
							end
						end
					end
				end
			end
		else
			if(self.Aiming)then self.Owner:SetSchedule(SCHED_INTERACTION_WAIT_FOR_PARTNER) return end
			if((Act==ACT_IDLE)or(Act==ACT_IDLE_RELAXED))then self.Owner:SetSchedule(SCHED_RANGE_ATTACK1) end
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
	if(not(self.Reloading)and not(self.Aiming))then
		local Enemy=self:BadGuy()
		if(IsValid(Enemy))then
			local Time=(self.Owner:GetPos()-Enemy:GetPos()):Length()/3000+Enemy:GetPhysicsObject():GetVelocity():Length()/500+0.5
			self.Aiming=true
			timer.Simple(Time,function()
				if(IsValid(self))then
					self.Aiming=false
					if(IsValid(self:BadGuy()))then
						self:Shoot(ShootPos,ShootDir)
					end
				end
			end)
		end
	end
end

function SWEP:Shoot(ShootPos,ShootDir)
	if(self.Reloading)then return end
	local Enemy=self:BadGuy()
	if not(IsValid(Enemy))then return end
	if(self.RoundsInPulseMag>0)then
		WorldSound("lolsounds/combinebr_close.wav",ShootPos,85,math.Rand(90,110))
		
		WorldSound("Weapon_AR2.NPC_Single",ShootPos,100,100)

		local ShootAng=ShootDir:Angle()
		local angpos=self:GetAttachment(self:LookupAttachment("muzzle"))
		local ShootOrigin=angpos.Pos+angpos.Ang:Forward()*25+angpos.Ang:Up()*5
		
		local Kabang=EffectData()
		Kabang:SetStart(ShootOrigin)
		Kabang:SetNormal(ShootDir)
		Kabang:SetScale(1.25)
		util.Effect("effect_jack_combinemuzzle",Kabang)

		local Dist=(Enemy:GetPos()-self.Owner:GetPos()):Length()
		local EnemyPos=Enemy:LocalToWorld(Enemy:OBBCenter())+VectorRand()*math.Rand(0,Dist/75)+self:HeightCorrection()
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
			Bewlat.Damage=math.Rand(50,60)
			Bewlat.Force=2000
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
		self:Reload(false)
	end
end

function SWEP:Reload(TacticalReload)
	if(self.Reloading)then return end
	self.Reloading=true

	self.RoundsInPulseMag=10
	self.Owner:SetSchedule(SCHED_RELOAD)
	
	//print(tostring(self.Owner:GetActivity()).." "..tostring(self.Owner:SequenceDuration()))
	
	local AddTime=0
	if not(self.Owner:GetActivity()==ACT_IDLE)then AddTime=0.5 end

	local TimerTable={0.5,1,1.55,2.15,2.4}
	
	//why do women reload faster than men -____-
	if(string.find(self.Owner:GetModel(),"female"))then
		TimerTable={0.475,0.725,1.2,1.575,1.7}
	end
	
	timer.Simple(TimerTable[1]+AddTime,function()
		if(IsValid(self.Owner))then
			if(AddTime==0.5)then
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
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_magremove.wav")
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
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_maginsert.wav")
		end
	end)
	timer.Simple(TimerTable[4]+AddTime,function()
		if(IsValid(self))then
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_cockback.wav")
		end
	end)
	timer.Simple(TimerTable[5]+AddTime,function()
		if(IsValid(self))then
			self.Reloading=false
			self.Owner:EmitSound("lolsounds/combine_smg_ar_br_cockforward.wav")
		end
	end)
	
	return true
end