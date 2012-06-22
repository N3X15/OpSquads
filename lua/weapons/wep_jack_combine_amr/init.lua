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
	if(self.Reloading)then return end
	if(IsValid(self.Owner))then
		local Enemy=self:BadGuy()
		local Act=self.Owner:GetActivity()
		if(self.Aiming)then
			self.Owner:SetSchedule(SCHED_INTERACTION_WAIT_FOR_PARTNER)
		end
		//for key,found in pairs(player.GetAll())do
		//	found:PrintMessage(HUD_PRINTCENTER,self.Owner:GetActivity())
		//end
		if(IsValid(Enemy))then
			if not(self.Aiming)then
				if(Act==ACT_IDLE)then
					self.Owner:SetSchedule(SCHED_RANGE_ATTACK1)
				end
			end
		else
			for key,found in pairs(ents.FindInSphere(self.Owner:GetPos(),10000))do
				if(math.random(1,500)==42)then --don't spot instantly
					if((found:IsPlayer())or(found:IsNPC()))then
						if(self.Owner:Disposition(found)==1)then
							if(self:CanSee(found))then
								self.Owner:UpdateEnemyMemory(found,found:GetPos())
							end
						end
					end
				end
			end
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
	local Enemy=self:BadGuy()
	if not(IsValid(Enemy))then return end
	if(self.Reloading)then return end
	if(self.Aiming)then return end
	self.Aiming=true
	local Distance=(Enemy:GetPos()-self.Owner:GetPos()):Length() --far away targets are hard to hit
	local Speed
	if(IsValid(Enemy:GetPhysicsObject()))then
		Speed=(Enemy:GetPhysicsObject():GetVelocity():Length()) --moving targets are hard to hit
	else
		Speed=(Enemy:GetVelocity():Length()) --moving targets are hard to hit
	end
	timer.Simple(0.5,function()
		if(IsValid(self))then
			if(IsValid(Enemy))then
				self:SetDTEntity(0,Enemy)
			end
		end
	end)
	timer.Simple(math.Rand(0.9,1.1)*(Distance^0.75/80)+Speed/200+1.5,function()
		if(IsValid(self))then
			if(IsValid(Enemy))then
				if((Enemy:Health()>0)or(table.HasValue(NoHealthTable,Enemy:GetClass())))then
					self:Shoot(self.Owner:GetShootPos(),self.Owner:GetAimVector())
				end
			end
			self.Aiming=false
			self:SetDTEntity(0,nil)
		end
	end)
end

function SWEP:Shoot(ShootPos,ShootDir)
	local Enemy=self:BadGuy()
	if(IsValid(Enemy))then
		WorldSound("lolsounds/combinesniper_fire.wav",ShootPos,85,math.Rand(90,110))
		WorldSound("lolsounds/combinesniper_fire.wav",ShootPos,86,math.Rand(90,110))
		WorldSound("lolsounds/combinesniper_fire_far.wav",ShootPos,160,math.Rand(90,110))

		local ShootAng=ShootDir:Angle()
		local angpos=self:GetAttachment(self:LookupAttachment("muzzle"))
		local ShootOrigin=angpos.Pos+angpos.Ang:Forward()*35+angpos.Ang:Up()*5
		
		local Kabang=EffectData()
		Kabang:SetStart(ShootOrigin)
		Kabang:SetNormal(ShootDir)
		Kabang:SetScale(2.5)
		util.Effect("effect_jack_combinemuzzle",Kabang)

		local Dist=(Enemy:GetPos()-self.Owner:GetPos()):Length()
		local EnemyPos=Enemy:LocalToWorld(Enemy:OBBCenter())+VectorRand()*math.Rand(0,Dist/350)+self:HeightCorrection()
		local Dir=(EnemyPos-ShootPos):GetNormalized()
		
		local EyeTraceData={}
		EyeTraceData.start=ShootPos
		EyeTraceData.endpos=ShootPos+Dir*99999
		EyeTraceData.filter=self.Owner
		EyeTraceData.mask=MASK_SHOT
		local EyeTrace=util.TraceLine(EyeTraceData)
		if(EyeTrace.Hit)then
			if not(self.Owner:Disposition(EyeTrace.Entity)==3)then
				util.BlastDamage(self.Weapon,self.Owner,EyeTrace.HitPos,100,75)
				WorldSound("lolsounds/shot_echo.wav",EyeTrace.HitPos,150,100)
			
				local Bewlat={}
				Bewlat.Num=1
				Bewlat.Damage=math.Rand(350,400)
				Bewlat.Force=9000
				Bewlat.Src=ShootPos
				Bewlat.Dir=Dir
				Bewlat.Spread=Vector(0,0,0)
				Bewlat.Tracer=0
				self.Owner:FireBullets(Bewlat)
				
				local Spach=EffectData()
				Spach:SetOrigin(EyeTrace.HitPos)
				Spach:SetStart(ShootOrigin)
				Spach:SetScale(20000)
				util.Effect("AirboatGunHeavyTracer",Spach)
				
				local Sploo=EffectData()
				Sploo:SetOrigin(EyeTrace.HitPos)
				Sploo:SetScale(9000)
				Sploo:SetMagnitude(9000)
				Sploo:SetRadius(50)
				Sploo:SetNormal(EyeTrace.HitNormal)
				util.Effect("AirboatGunImpact",Sploo)
			end
		end
		self:Reload()
	end
end

function SWEP:Reload()
	if(self.Reloading)then return end
	self.Reloading=true

	self.RoundsInPulseMag=15
	self.Owner:SetSchedule(SCHED_RELOAD)
	
	local TimerTable={1.05,1.5,2.025,2.6,2.9}
	
	//why do women reload faster than men -____-
	if(string.find(self.Owner:GetModel(),"female"))then
		TimerTable={0.925,1.175,1.675,2.025,2.25}
	end
	
	timer.Simple(TimerTable[1],function()
		if(IsValid(self.Owner))then
			local EmptyMag=ents.Create("ent_jack_pulsemag")
			EmptyMag:SetPos(self.Owner:GetPos()+self.Owner:GetUp()*35+self.Owner:GetAimVector()*15)
			local angul=self.Owner:GetAimVector():Angle()
			angul:RotateAroundAxis(self.Owner:GetAimVector(),90)
			EmptyMag:SetAngles(angul)
			EmptyMag:SetDTBool(1,true) --make it have the flare model
			EmptyMag:Spawn()
			EmptyMag:Activate()
			
			self.Owner:EmitSound("lolsounds/combinesniper_cartridgeout.wav")
		end
	end)

	//DTBool 0 is whether or not the cartridge appears in the user's hand
	timer.Simple(TimerTable[2],function()
		if(IsValid(self.Owner))then
			self:SetDTBool(0,true)
		end
	end)
	timer.Simple(TimerTable[3],function()
		if(IsValid(self.Owner))then
			self:SetDTBool(0,false)
			self.Owner:EmitSound("lolsounds/combinesniper_cartridgein.wav")
		end
	end)
	timer.Simple(TimerTable[4],function()
		if(IsValid(self))then
			self.Owner:EmitSound("lolsounds/combinesniper_cockback.wav")
		end
	end)
	timer.Simple(TimerTable[5],function()
		if(IsValid(self))then
			self.Reloading=false
			self.Owner:EmitSound("lolsounds/combinesniper_cockforward.wav")
		end
	end)
	
	return true
end