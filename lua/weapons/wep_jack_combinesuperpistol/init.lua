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
	if(IsValid(self))then
		if(IsValid(self.Owner:GetEnemy()))then
			if(self:CanSee(self.Owner:GetEnemy()))then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function SWEP:ExtraThink()
	if(self:BadGuy())then
		if not(self.Reloading)then
			if(self.Owner:GetActivity()==SCHED_IDLE_STAND)then
				self.Owner:SetSchedule(SCHED_RANGE_ATTACK1)
			end
		end
	else
		if not(self.Reloading)then
			if(self.Owner:GetActivity()==SCHED_IDLE_STAND)then
				if(self.RoundsInPulseMag<10)then
					self:Reload(true)
				end
			end
		end
	end
end

function SWEP:BigShot(ShootPos,ShootDir)
	if(self.RoundsInPulseMag>0)then
		WorldSound("lolsounds/kabang_far.wav",ShootPos,155,math.Rand(70,90))
		WorldSound("lolsounds/kabang_close.wav",ShootPos,75,math.Rand(70,90))
		WorldSound("lolsounds/kabang_far.wav",ShootPos,160,math.Rand(70,90))
		WorldSound("lolsounds/kabang_close.wav",ShootPos,80,math.Rand(70,90))
		
		self.Owner:SetSchedule(SCHED_BIG_FLINCH)
		
		local posang=self:GetAttachment(self:LookupAttachment("muzzle"))
		
		local Kabang=EffectData()
		Kabang:SetStart(posang.Pos+posang.Ang:Forward()*3)
		Kabang:SetNormal(ShootDir)
		Kabang:SetScale(3)
		util.Effect("effect_jack_combinemuzzle",Kabang)
		
		local Enemy=self.Owner:GetEnemy()
		local Dist=(Enemy:GetPos()-self.Owner:GetPos()):Length()
		local EnemyPos=Enemy:LocalToWorld(Enemy:OBBCenter())+VectorRand()*math.Rand(0,Dist/50)+self:HeightCorrection()
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
			Bewlat.Damage=20
			Bewlat.Force=6000
			Bewlat.Src=ShootPos
			Bewlat.Dir=Dir
			Bewlat.Spread=Vector(0,0,0)
			Bewlat.Tracer=0
			self.Owner:FireBullets(Bewlat)
			
			util.BlastDamage(self.Weapon,self.Owner,EyeTrace.HitPos,120,20)
			
			local Spach=EffectData()
			Spach:SetOrigin(EyeTrace.HitPos)
			Spach:SetStart(ShootPos+Dir*30)
			Spach:SetScale(40000)
			util.Effect("AirboatGunHeavyTracer",Spach)
			local Spach=EffectData()
			Spach:SetOrigin(EyeTrace.HitPos)
			Spach:SetStart(ShootPos+Dir*30)
			Spach:SetScale(40001)
			util.Effect("AirboatGunHeavyTracer",Spach)
			
			local Sploo=EffectData()
			Sploo:SetOrigin(EyeTrace.HitPos)
			Sploo:SetScale(9000)
			Sploo:SetMagnitude(9000)
			Sploo:SetRadius(50)
			Sploo:SetNormal(EyeTrace.HitNormal)
			util.Effect("StunstickImpact",Sploo)
			local Sploo=EffectData()
			Sploo:SetOrigin(EyeTrace.HitPos)
			Sploo:SetScale(9000)
			Sploo:SetMagnitude(9000)
			Sploo:SetRadius(50)
			Sploo:SetNormal(EyeTrace.HitNormal)
			util.Effect("StunstickImpact",Sploo)
		end
		self.RoundsInPulseMag=self.RoundsInPulseMag-10
		
		if not(self.Owner.IsAFuckingBeast)then --lol
			if(IsValid(self.Weapon))then
				self.Owner:TakeDamage(5,self.Weapon,self.Weapon)
			end
		end
	else
		self:Reload(false)
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
	local wep=ents.Create("weapon_pistol")
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
	if(self:BadGuy())then
		local Distance=(self.Owner:GetEnemy():GetPos()-self.Owner:GetPos()):Length()
		if(Distance<3000)then
			self:Shoot(ShootPos,ShootDir)
		else
			self:BigShot(ShootPos,ShootDir)
		end
	end
end

function SWEP:Shoot(ShootPos,ShootDir)
	if(self.RoundsInPulseMag>0)then
		WorldSound("lolsounds/kabang_far.wav",ShootPos,160,math.Rand(90,110))
		WorldSound("lolsounds/kabang_close.wav",ShootPos,80,math.Rand(90,110))
		
		self.Owner:SetSchedule(SCHED_SMALL_FLINCH)
		
		local posang=self:GetAttachment(self:LookupAttachment("muzzle"))
		
		local Kabang=EffectData()
		Kabang:SetStart(posang.Pos+posang.Ang:Forward()*3)
		Kabang:SetNormal(ShootDir)
		Kabang:SetScale(1)
		util.Effect("effect_jack_combinemuzzle",Kabang)
		
		local Enemy=self.Owner:GetEnemy()
		local Dist=(Enemy:GetPos()-self.Owner:GetPos()):Length()
		local EnemyPos=Enemy:LocalToWorld(Enemy:OBBCenter())+VectorRand()*math.Rand(0,Dist/35)+self:HeightCorrection()
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
			Bewlat.Damage=7.5
			Bewlat.Force=3000
			Bewlat.Src=ShootPos
			Bewlat.Dir=Dir
			Bewlat.Spread=Vector(0,0,0)
			Bewlat.Tracer=0
			self.Owner:FireBullets(Bewlat)
			
			util.BlastDamage(self.Weapon,self.Owner,EyeTrace.HitPos,60,7.5)
			
			local Spach=EffectData()
			Spach:SetOrigin(EyeTrace.HitPos)
			Spach:SetStart(ShootPos+Dir*30)
			Spach:SetScale(20000)
			util.Effect("AirboatGunHeavyTracer",Spach)
			
			local Sploo=EffectData()
			Sploo:SetOrigin(EyeTrace.HitPos)
			Sploo:SetScale(9000)
			Sploo:SetMagnitude(9000)
			Sploo:SetRadius(50)
			Sploo:SetNormal(EyeTrace.HitNormal)
			util.Effect("StunstickImpact",Sploo)
		end
		self.RoundsInPulseMag=self.RoundsInPulseMag-1
		
		if not(self.Owner.IsAFuckingBeast)then --lol
			if((IsValid(self.Weapon))and(IsValid(self.Owner)))then
				self.Owner:TakeDamage(5,self.Weapon,self.Weapon)
			end
		end
	else
		self:Reload(false)
	end
end

function SWEP:Reload(TacticalReload)
	if(self.Reloading)then return end
	self.Reloading=true

	self.Owner:EmitSound("lolsounds/superpistol_reload.wav")
	self.RoundsInPulseMag=10
	self.Owner:SetSchedule(SCHED_RELOAD)
	
	timer.Simple(0.3,function()
		if(IsValid(self.Owner))then
			if not(TacticalReload)then
				local EmptyMag=ents.Create("ent_jack_pulsemag")
				EmptyMag:SetPos(self.Owner:GetPos()+self.Owner:GetUp()*52+self.Owner:GetAimVector()*21+self.Owner:GetRight()*3)
				local angul=self.Owner:GetAimVector():Angle()
				angul:RotateAroundAxis(self.Owner:GetAimVector(),90)
				EmptyMag:SetAngles(angul)
				EmptyMag:Spawn()
				EmptyMag:Activate()
			else
				self:SetDTBool(0,true)
			end
		end
	end)
	
	local Delay=0.45
	if(TacticalReload)then Delay=0.9 end
	timer.Simple(Delay,function()
		if(IsValid(self.Owner))then
			self:SetDTBool(0,true)
			timer.Simple(0.4,function()
				if(IsValid(self.Owner))then
					self:SetDTBool(0,false)
				end
			end)
		end
	end)
	
	timer.Simple(1.5,function()
		if(IsValid(self))then
			self.Reloading=false
		end
	end)
	
	return true
end