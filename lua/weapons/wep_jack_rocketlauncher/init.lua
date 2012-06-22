AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
include("ai_translations.lua")

SWEP.Weight=5
SWEP.AutoSwitchTo=false
SWEP.AutoSwitchFrom=false 

/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire secondary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Secondary(ShootPos,ShootDir)
	//the fuck are you doing, son?
end

function SWEP:OnDrop()
	local rpg=ents.Create("weapon_rpg")
	rpg:SetPos(self:GetPos())
	rpg:SetAngles(self:GetAngles())
	self:Remove()
	rpg:Spawn()
	rpg:Activate()
end

/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire primary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Primary(ShootPos,ShootDir)
	if(self.Owner.IsTrainedWithRocketLaunchers)then --we do these simple safety checks
		local Enemy=self.Owner:GetEnemy()
		local enemypos=Enemy:GetPos()
		for key,enpeesee in pairs(ents.FindInSphere(enemypos,200))do
			if(enpeesee:IsNPC())then
				if(enpeesee:GetClass()=="npc_citizen")then --MOVE!!
					local WarningTable={"vo/npc/male01/getdown02.wav","vo/npc/male01/headsup01.wav","vo/npc/male01/headsup02.wav","vo/npc/male01/watchout.wav"}
					self.Owner:EmitSound(WarningTable[math.random(1,4)])
					return
				end
			end
		end
	end
	if(self.NextFireTime<CurTime())then
		self.Reloading=false
		local GoDirection=ShootDir
		if(self.Owner.IsTrainedWithRocketLaunchers)then --he knows to shoot at an enemy's feet, and to adjust for the drop of the rocket.
			local dist=(self.Owner:GetEnemy():GetPos()-self.Owner:GetPos()):Length()
			local DropCompensation=dist^2.022*0.000027
			local Inaccuracy=VectorRand()*math.Rand(0,40)
			local MovingTargetTravelTimeCompensation=(self.Owner:GetEnemy():GetVelocity())*(dist/1650)
			GoDirection=(self.Owner:GetEnemy():GetPos()+Vector(0,0,DropCompensation)+MovingTargetTravelTimeCompensation+Inaccuracy-ShootPos):GetNormalized()
		end
		self.Owner:EmitSound("weapons/rpg/rocketfire1.wav")
		local rockit=ents.Create("ent_jack_rocket")
		rockit:SetPos(ShootPos)
		rockit:SetOwner(self.Owner)
		rockit:SetAngles(GoDirection:Angle())
		rockit.Owner=self.Owner
		rockit:Spawn()
		rockit:Activate()
		self.NextFireTime=CurTime()+5
		self.Owner:StopMoving()
	else
		if not(self.Reloading)then
			if(self.Owner.IsTrainedWithRocketLaunchers)then
				local chance=math.random(1,3)
				if(chance==1)then
					self.Owner:EmitSound("vo/npc/male01/gottareload01.wav")
				elseif(chance==2)then
					self.Owner:EmitSound("vo/npc/male01/coverwhilereload01.wav")
				elseif(chance==3)then
					self.Owner:EmitSound("vo/npc/male01/coverwhilereload02.wav")
				end
			end
			self.Reloading=true
		end
	end
end