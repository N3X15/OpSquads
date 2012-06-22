--NPCMAEKR
--By Jackarunda

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local WeaponTable={
	"Shotgun",
	"Pistol",
	"Crowbar",
	"SMG",
	"AR2",
	"Stunstick",
	"RPG",
	"Lever_Action_Rifle",
	"Combine_Designated_Marksman_Rifle",
	"Combine_Anti_Materiel_Rifle",
	"Combine_UltraCompact_Shotgun",
	"Combine_Assault_Rifle",
	"Combine_Submachinegun",
	"Combine_Combat_Rifle",
	"Combine_Assault_Carbine",
	"Combine_UltraCompact_Submachinegun",
	"Combine_Battle_Rifle",
	"Combine_Sniping_Rifle",
	"Combine_Medium_Machine_Gun",
	"Combine_Light_Machine_Gun",
	"Combine_Machine_Pistol",
	"Combine_Combat_Pistol",
	"Combine_Heavy_Pistol",
	"Combine_Combat_Shotgun",
	"Combine_Personal_Defense_Weapon"
}

local ModelTable={
	"models/Jumans/Group03/Male_01.mdl",
	"models/Jumans/Group03/male_02.mdl",
	"models/Jumans/Group03/male_03.mdl",
	"models/Jumans/Group03/Male_04.mdl",
	"models/Jumans/Group03/Male_05.mdl",
	"models/Jumans/Group03/male_06.mdl",
	"models/Jumans/Group03/male_07.mdl",
	"models/Jumans/Group03/male_08.mdl",
	"models/Jumans/Group03/male_09.mdl"
}

local MedicModelTable={
	"models/Jumans/Group03m/Male_01.mdl",
	"models/Jumans/Group03m/male_02.mdl",
	"models/Jumans/Group03m/male_03.mdl",
	"models/Jumans/Group03m/Male_04.mdl",
	"models/Jumans/Group03m/Male_05.mdl",
	"models/Jumans/Group03m/male_06.mdl",
	"models/Jumans/Group03m/male_07.mdl",
	"models/Jumans/Group03m/male_08.mdl",
	"models/Jumans/Group03m/male_09.mdl"
}

local MaxEngagementNumberTable={
	["SMG"]=1,
	["AR2"]=1,
	["Shotgun"]=2,
	["RPG"]=0,
	["Pistol"]=1,
	["Crowbar"]=2,
	["Stunstick"]=2,
	["Lever_Action_Rifle"]=0,
	["Combine_Battle_Rifle"]=1,
	["Combine_SMG"]=2,
	["Combine_Sniper_Rifle"]=0,
	["Combine_Shotgun"]=2,
	["Combine_Designated_Marksman_Rifle"]=0,
	["Combine_Anti_Materiel_Rifle"]=0,
	["Combine_UltraCompact_Shotgun"]=3,
	["Combine_Assault_Rifle"]=2,
	["Combine_Submachinegun"]=2,
	["Combine_Combat_Rifle"]=0,
	["Combine_Assault_Carbine"]=2,
	["Combine_UltraCompact_Submachinegun"]=3,
	["Combine_Battle_Rifle"]=0,
	["Combine_Sniping_Rifle"]=0,
	["Combine_Medium_Machine_Gun"]=1,
	["Combine_Light_Machine_Gun"]=1,
	["Combine_Machine_Pistol"]=2,
	["Combine_Combat_Pistol"]=1,
	["Combine_Heavy_Pistol"]=1,
	["Combine_Combat_Shotgun"]=2,
	["Combine_Personal_Defense_Weapon"]=2
}

local VectorTable={
	Vector(0,0,0),
	Vector(50,0,0),
	Vector(50,-50,0),
	Vector(0,-50,0),
	Vector(-50,-50,0),
	Vector(-50,0,0),
	Vector(-50,50,0),
	Vector(0,50,0),
	Vector(50,50,0),
	Vector(100,50,0),
	Vector(100,0,0),
	Vector(100,-50,0),
	Vector(100,-100,0),
	Vector(50,-100,0),
	Vector(0,-100,0),
	Vector(-50,-100,0),
	Vector(-100,-100,0),
	Vector(-100,-50,0),
	Vector(-100,0,0),
	Vector(-100,50,0),
	Vector(-100,100,0),
	Vector(-50,100,0),
	Vector(0,100,0),
	Vector(50,100,0),
	Vector(100,100,0)
}

local function HaveSchizophrenia(npc)
	if(math.random(1,15)==6)then
		npc:Fire("speakidleresponse","",0)
	end
end

local function ClearLoSBetween(npc1,npc2)
	local TrDat={}
	TrDat.start=npc1:GetPos()+Vector(0,0,50)
	TrDat.endpos=npc2:GetPos()+Vector(0,0,20)
	TrDat.filter={npc1,npc2}
	local Tr=util.TraceLine(TrDat)
	if not(Tr.Hit)then
		return true
	else
		return false
	end
end

function ENT:SpawnFunction(ply, tr)

	local SpawnPos = tr.HitPos + tr.HitNormal*16
	local ent = ents.Create("ent_jack_npcmaker")
	ent:SetPos(SpawnPos)
	ent:SetNetworkedEntity("Owenur",ply)
	ent:Spawn()
	ent:Activate()
	
	local effectdata=EffectData()
	effectdata:SetEntity(ent)
	util.Effect("propspawn",effectdata)
	
	return ent

end

function ENT:Initialize()

	self.Entity:SetModel("models/props_c17/oildrum001.mdl")
	self.Entity:SetMaterial("models/mat_jack_npcmaker")

	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
	self.Entity:SetSolid(SOLID_VPHYSICS)

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(20)
	end
	
	self.Stage="Off"
	self.PersonType="Citizen"
	self.Specialization="None"
	self.AmmoSupply="pistol"
	self.Weapon="Pistol"
	self.NumberOfPeeps=1
	self.Allegiance="Human"
	
	self.FlipOutSeverity=0
	
	self.Broken=false
	
	self:SetUseType(SIMPLE_USE)
	
	self.NextTurnTime=CurTime()

	self:Fire("enableshadow","",0)

end

function ENT:PhysicsCollide(data, physobj)
	// Play sound on bounce --heh, KABOOM
	if(data.DeltaTime>0.2)then
		if(data.Speed>300)then
			self.Entity:EmitSound("SolidMetal.ImpactHard")
		elseif(data.Speed>100)then
			self.Entity:EmitSound("SolidMetal.ImpactSoft")
		end
	end
end

function ENT:OnTakeDamage(dmginfo)

	self.Entity:TakePhysicsDamage(dmginfo)
	
end

function ENT:TriggerInput(iname,value)
end

function ENT:Use(activator,caller)
	if(self.Broken)then return end
	if(self.Stage=="Flipping Out")then return end
	if(self.NextTurnTime<CurTime())then
		if not(self.Stage=="Off")then
			self.Stage="Off"
			self.PersonType="Citizen"
			self.Specialization="None"
			self.AmmoSupply="Pistol"
			self.Weapon="Pistol"
			self.NumberOfPeeps=1
			self.Allegiance="Human"
			self:EmitSound("lolsounds/magicoff.mp3")
		elseif(self.Stage=="Off")then
			self.Stage="Awaiting Type"
			self.Entity:EmitSound("lolsounds/magicon.wav")
			self:Reply(caller,"What type of person?")
		end
		self.NextTurnTime=CurTime()+0.5
	end
end

function ENT:Think()
	if(self.Stage=="Flipping Out")then
		self:GetPhysicsObject():AddAngleVelocity(VectorRand()*self.FlipOutSeverity)
		self.FlipOutSeverity=self.FlipOutSeverity+300
	end
	self:NextThink(CurTime()+0.01)
end

function ENT:OnRemove()
end

function ENT:IsCloseEnough(playa)
	local dist=(playa:GetPos()-self:GetPos()):Length()
	if(dist<200)then
		return true
	else
		return false
	end
end

function ENT:Reply(playah,message)
	if(self.Broken)then return end
	timer.Simple(0.2,function()
		if(IsValid(self))then
			if(self:IsCloseEnough(playah))then
				if not(self.Stage=="Off")then
					playah:PrintMessage(HUD_PRINTTALK,message)
				end
			end
		end
	end)
end

function ENT:NPCMakerReceive(ply,text)
	if(self.Broken)then return end
	if(self.Stage=="Flipping Out")then return end
	if(self:IsCloseEnough(ply))then
		local WordTable=string.Explode(" ",text)
		local FirstWord=WordTable[1]
		local SecondWord=WordTable[2]
		local ThirdWord=WordTable[3]
		local FourthWord=WordTable[4]
		local FifthWord=WordTable[5]
		if(self.Stage=="Off")then return end
		if(self.Stage=="Awaiting Type")then
			if not(FirstWord)then return end
			if((FirstWord=="Citizen")or(FirstWord=="Refugee")or(FirstWord=="Rebel")or(FirstWord=="Elite"))then
				self.PersonType=FirstWord
				self.Stage="Awaiting Specialization"
				self:Reply(ply,"Any specialization?")
			end
		elseif(self.Stage=="Awaiting Specialization")then
			if not(FirstWord)then return end
			if((FirstWord=="Medic")or(FirstWord=="Resupplier")or(FirstWord=="None"))then
				self.Specialization=FirstWord
				if(self.Specialization=="Resupplier")then
					self.Stage="Awaiting Supply Type"
					self:Reply(ply,"What munition to supply?")
				else
					self.Stage="Awaiting Weapon"
					self:Reply(ply,"Which weapon?")
				end
			end
		elseif(self.Stage=="Awaiting Supply Type")then
			if not(FirstWord)then return end
			if((FirstWord=="Pistol")or(FirstWord=="SMG")or(FirstWord=="SMG_Grenade")or(FirstWord=="AR2")or(FirstWord=="Shotgun")or(FirstWord=="RPG")or(FirstWord=="Grenade")or(FirstWord=="Crossbow_Bolt")or(FirstWord==".357_Magnum"))then
				self.AmmoSupply=FirstWord
				self.Stage="Awaiting Weapon"
				self:Reply(ply,"Which weapon?")
			end
		elseif(self.Stage=="Awaiting Weapon")then
			if not(FirstWord)then return end
			if(table.HasValue(WeaponTable,FirstWord))then
				self.Weapon=FirstWord
				self.Stage="Awaiting Number"
				self:Reply(ply,"How many people?")
			end
		elseif(self.Stage=="Awaiting Number")then
			if not(FirstWord)then return end
			if not(tonumber(FirstWord))then return end
			self.NumberOfPeeps=tonumber(FirstWord)
			if(self.NumberOfPeeps>25)then 
				self:Reply(ply,"Too many. Limiting to 25.")
				self.NumberOfPeeps=25
			elseif(self.NumberOfPeeps<1)then
				self:Reply(ply,"lol what the fuck are you doing")
				self.NumberOfPeeps=1
			end
			self.Stage="Awaiting Allegiance"
			self:Reply(ply,"Which faction allegiance?")
		elseif(self.Stage=="Awaiting Allegiance")then
			if not(FirstWord)then return end
			self.Allegiance=FirstWord
			
			self.Stage="Flipping Out"
			self.Owner=ply
			self:Reply(ply,"Coming right up!")
			timer.Simple(2,function()
				if(IsValid(self))then
					if not(self.Stage=="Off")then
						timer.Simple(0.1,function()
							undo.Create("JackyPerson")
							for i=1,self.NumberOfPeeps do
								self:CreatePerson(self:GetPos()+VectorTable[i])
							end
							undo.SetPlayer(self.Owner)
							undo.SetCustomUndoText("Undone custom person.")
							if(self.NumberOfPeeps>1)then undo.SetCustomUndoText("Undone custom people.") end
							undo.SetCustomUndoText("Undone custom person.")
							undo.Finish()
							self:Remove()
						end)
						self.Stage="Off"
						WorldSound("ambient/explosions/explode_9.wav",self:GetPos(),100,100)
						local Sploo=EffectData()
						Sploo:SetOrigin(self:GetPos())
						Sploo:SetScale(0.4*self.NumberOfPeeps^0.5)
						Sploo:SetStart(Vector(0,0,0))
						util.Effect("effect_jack_appear",Sploo)
						self:EmitSound("lolsounds/pop.wav",80,100)
					end
				end
			end)
		end
	end
end

function ENT:CreatePerson(Position)
	local npc=ents.Create("npc_citizen")
	npc:SetPos(Position)
	npc:SetKeyValue("SquadName","InstantHumanOpposition")
	npc.InAJackyHumanSquad=true
	if(self.PersonType=="Citizen")then
		npc:SetKeyValue("citizentype","1")
		npc:SetKeyValue("Expression Type","Random")
		npc:SetBloodColor(BLOOD_COLOR_RED)
	elseif(self.PersonType=="Refugee")then
		npc:SetKeyValue("citizentype","2")
		npc:SetKeyValue("Expression Type","Random")
		npc:SetBloodColor(BLOOD_COLOR_RED)
	elseif(self.PersonType=="Rebel")then
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("Expression Type","Random")
		npc:SetBloodColor(BLOOD_COLOR_RED)
	elseif(self.PersonType=="Elite")then
		npc:SetKeyValue("citizentype","3")
		npc:SetKeyValue("expressiontype","3")
		npc:SetMaxHealth(40)
		npc:SetHealth(40)
		npc:CapabilitiesAdd(CAP_NO_HIT_SQUADMATES)
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
		npc.SpottedEnemies={}
		npc.CanShootExceptionallyWellAtVitalAreas=true
		npc.IsUsingAmericanAmmunition=true
		npc.HasAmericanBodyArmor=true
		npc:SetBloodColor(-1)
	end
	if(self.Specialization=="Medic")then
		npc.OPSQUADWillDropHealthVial=true
		if(self.PersonType=="Elite")then
			npc:SetKeyValue("spawnflags","131328")
			npc.OPSQUADWillDropHealthKit=true
		else
			npc:SetKeyValue("spawnflags",SF_CITIZEN_MEDIC)
		end
	elseif(self.Specialization=="Resupplier")then
		if(self.PersonType=="Elite")then
			npc:SetKeyValue("spawnflags","524544")
		else
			npc:SetKeyValue("spawnflags",SF_CITIZEN_AMMORESUPPLIER)
		end
		if(self.AmmoSupply=="Pistol")then
			npc:SetKeyValue("ammosupply","pistol")
			npc:SetKeyValue("ammoamount","18")
			npc.OPSQUADWillDropPistolAmmo=true
		elseif(self.AmmoSupply=="SMG")then
			npc:SetKeyValue("ammosupply","SMG1")
			npc:SetKeyValue("ammoamount","45")
			npc.OPSQUADWillDropSMGAmmo=true
		elseif(self.AmmoSupply=="SMG_Grenade")then
			npc:SetKeyValue("ammosupply","SMG1_Grenade")
			npc:SetKeyValue("ammoamount","1")
			npc.OPSQUADWillDropSMGGrenade=true
		elseif(self.AmmoSupply=="AR2")then
			npc:SetKeyValue("ammosupply","ar2")
			npc:SetKeyValue("ammoamount","30")
			npc.OPSQUADWillDropIonBalls=true
			npc.OPSQUADWillDropAR2Ammo=true
		elseif(self.AmmoSupply=="Shotgun")then
			npc:SetKeyValue("ammosupply","Buckshot")
			npc:SetKeyValue("ammoamount","6")
			npc.OPSQUADWillDropShotgunAmmo=true
		elseif(self.AmmoSupply=="RPG")then
			npc:SetKeyValue("ammosupply","RPG_Round")
			npc:SetKeyValue("ammoamount","1")
			npc.OPSQUADWillDropRPGRound=true
		elseif(self.AmmoSupply=="Crossbow_Bolt")then
			npc:SetKeyValue("ammosupply","XBowBolt")
			npc:SetKeyValue("ammoamount","1")
		elseif(self.AmmoSupply=="Grenade")then
			npc:SetKeyValue("ammosupply","Grenade")
			npc:SetKeyValue("ammoamount","1")
			npc.OPSQUADWillDropGrenades=true
		end
	end
	if(self.Weapon=="Pistol")then
		npc:SetKeyValue("additionalequipment","weapon_pistol")
		npc.OPSQUADWillDropPistolAmmo=true
	elseif(self.Weapon=="Shotgun")then
		npc:SetKeyValue("additionalequipment","weapon_shotgun")
		npc.OPSQUADWillDropShotgunAmmo=true
	elseif(self.Weapon=="SMG")then
		npc:SetKeyValue("additionalequipment","weapon_smg1")
		npc.OPSQUADWillDropSMGAmmo=true
	elseif(self.Weapon=="AR2")then
		npc:SetKeyValue("additionalequipment","weapon_ar2")
		npc.OPSQUADWillDropAR2Ammo=true
		npc.OPSQUADWillDropIonBalls=true
	elseif(self.Weapon=="Crowbar")then
		npc:SetKeyValue("additionalequipment","weapon_crowbar")
		npc:SetName("matt")
	elseif(self.Weapon=="Stunstick")then
		npc:SetKeyValue("additionalequipment","weapon_stunstick")
	elseif(self.Weapon=="RPG")then
		npc:SetKeyValue("additionalequipment","wep_jack_rocketlauncher")
		npc.OPSQUADWillDropRPGRound=true
		if(self.PersonType=="Elite")then
			npc.IsTrainedWithRocketLaunchers=true
		end
	elseif(self.Weapon=="Lever_Action_Rifle")then
		npc:SetKeyValue("additionalequipment","weapon_annabelle")
		npc.OPSQUADWillDropRevolverAmmo=true
		npc.IsUsingABeastWeapon=true
	elseif(self.Weapon=="Combine_Battle_Rifle")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_br")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_UltraCompact_Submachinegun")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_ucsmg")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Sniping_Rifle")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_sr")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_UltraCompact_Shotgun")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_ucsg")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Designated_Marksman_Rifle")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_dmr")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Anti_Materiel_Rifle")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_amr")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Assault_Carbine")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_ac")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Assault_Rifle")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_ar")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Submachinegun")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_smg")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Combat_Rifle")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_cr")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Medium_Machine_Gun")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_mmg")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Light_Machine_Gun")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_lmg")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Machine_Pistol")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_mp")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Combat_Pistol")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_cp")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Heavy_Pistol")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_hp")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Combat_Shotgun")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_csg")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="Combine_Personal_Defense_Weapon")then
		npc:SetKeyValue("additionalequipment","wep_jack_combine_pdw")
		npc.OPSQUADWillDropAR2Ammo=true
	elseif(self.Weapon=="None")then
		//do nothing
	end
	npc.HasAJackyAllegiance=true
	npc.JackyAllegiance=self.Allegiance
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	npc:Spawn()
	npc:Activate()
	npc:Fire("disableweaponpickup","",0)
	if not(self.PersonType=="Elite")then
		npc:Fire("startpatrolling","",20)
	end
	if(self.Specialization=="Resupplier")then
		npc:Fire("setammoresupplieron","",0)
	elseif(self.Specialization=="Medic")then
		npc:Fire("setmedicon","",0)
	end
	if(self.PersonType=="Elite")then
		if(self.Specialization=="Medic")then
			npc:SetModel(MedicModelTable[math.random(1,9)])
		else
			npc:SetModel(ModelTable[math.random(1,9)])
		end
		npc:Fire("setammoresupplieroff","",0)
		npc.NextGiveTime=CurTime()+5
		MilitaryPhysique(npc)
		npc:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
		npc:AddRelationship("npc_turret_floor D_FR 90")
		local timername="AmazingHunter"..npc:EntIndex()
		timer.Create(timername,0.5,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local CurrentEnemy=npc:GetEnemy()
			if(IsValid(CurrentEnemy))then
				if not(table.HasValue(npc.SpottedEnemies,CurrentEnemy))then
					table.ForceInsert(npc.SpottedEnemies,CurrentEnemy)
				end
			end
			table.foreach(npc.SpottedEnemies,function(key,creature)
				if(IsValid(creature))then
					if not(creature:Health()>0)then
						table.remove(npc.SpottedEnemies,key)
					end
				else
					table.remove(npc.SpottedEnemies,key)
				end
			end)
			for key,target in pairs(ents.GetAll())do --amazing tracking abilities
				if((target:IsNPC())or(target:IsPlayer()))then
					if(table.HasValue(npc.SpottedEnemies,target))then
						if((target:Health()>0)and not(npc:GetEnemy()==target))then
							npc:UpdateEnemyMemory(target,target:GetPos())
						end
					end
				end
			end
			for key,found in pairs(ents.GetAll())do --fucking eagle eyes
				if((found:IsNPC())or(found:IsPlayer()))then
					if(npc:Disposition(found)==2)then
						if not(IsValid(npc:GetEnemy()))then
							local enemypos=found:GetPos()
							if(ClearLoSBetween)then
								if(found:Health()>0)then
									npc:UpdateEnemyMemory(found,enemypos)
								end
							end
						end
					end
				end
			end
		end)
		local timername="PrioritizeYouRetardedJackass"..npc:EntIndex()
		timer.Create(timername,1,0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			local current=npc:GetEnemy()
			if(IsValid(current))then
				npc:Fire("setammoresupplieroff","",0)
				for key,target in pairs(ents.FindByClass("npc_*"))do
					local tclass=target:GetClass()
					if((tclass=="npc_headcrab")or(tclass=="npc_headcrab_black")or(tclass=="npc_headcrab_poison")or(tclass=="npc_headcrab_fast"))then
						if(ClearLoSBetween(npc,target))then
							if not(target==current)then
								npc:SetEnemy(target)
								npc:SetTarget(target)
							end
						end
					end
				end
			else
				if(npc.NextGiveTime<CurTime())then
					if not(Hostile)then
						npc:Fire("setammoresupplieron","",0)
					end
				end
				HaveSchizophrenia(npc)
			end
		end)
		local Wap=self.Weapon
		if(true)then
			local timername="OPSQUADIntelligentGunfighter"..npc:EntIndex()	--										
			timer.Create(timername,1,0,function()	        	--
				if not(IsValid(npc))then timer.Destroy(timername) return end
				if not(IsValid(npc:GetEnemy()))then return end
				local NumberOfCreeps=0
				for key,found in pairs(ents.FindInSphere(npc:GetPos(),100))do
					if((found:IsNPC())or(found:IsPlayer()))then
						if(npc:Disposition(found)==2)then
							NumberOfCreeps=NumberOfCreeps+1
						end
					end
				end
				if(NumberOfCreeps>MaxEngagementNumberTable[Wap])then
					local selfpos=npc:GetPos()
					local newpos=selfpos+((selfpos-npc:GetEnemy():GetPos()):GetNormalized())*500
					local checkdat={}
					checkdat.start=selfpos
					checkdat.endpos=newpos
					checkdat.filter=npc
					local check=util.TraceLine(checkdat)
					if(check.Hit)then
						newpos=selfpos+VectorRand()*750
					end
					npc:SetLastPosition(newpos)
					npc:SetSchedule(SCHED_FORCED_GO_RUN)
				end
			end)
		end
		local Weapon=self.Weapon
		local timername="OPSQUADStickTogether"..npc:EntIndex()
		timer.Create(timername,math.Rand(10,20),0,function()
			if not(IsValid(npc))then timer.Destroy(timername) return end
			if(IsValid(npc:GetEnemy()))then return end
			local dudes=ents.FindByClass("npc_citizen")
			local NumberOfDudes=table.Count(dudes)
			local dude=dudes[math.random(1,NumberOfDudes)]
			if(IsValid(dude))then
				local dir=(dude:GetPos()-npc:GetPos()):GetNormalized()
				local newpos=npc:GetPos()+dir*490
				npc:SetLastPosition(newpos)
				npc:SetSchedule(SCHED_FORCED_GO)
			end
		end)
	end
	npc:SetColor(Color(0,0,0,255))
	timer.Simple(2,function()
		if(IsValid(npc))then
			local timername="ScorchUndoTimer"..npc:EntIndex()
			timer.Create(timername,0.001,127,function()
				if not(IsValid(npc))then timer.Destroy(timername) return end
				local Calr=npc:GetColor()
				npc:SetColor(Color(Calr.r+2,Calr.g+2,Calr.b+2,255))
			end)
		end
	end)
	undo.AddEntity(npc)
end

function MilitaryPhysique(npc)
	local Tummy=npc:LookupBone("ValveBiped.Bip01_Spine")
	if(Tummy)then npc:SetNetworkedInt("InflateSize"..Tummy,-21) end
	local Chest=npc:LookupBone("ValveBiped.Bip01_Spine2")
	if(Chest)then npc:SetNetworkedInt("InflateSize"..Chest,6) end
	local LeftUpperArm=npc:LookupBone("ValveBiped.Bip01_L_UpperArm")
	if(LeftUpperArm)then npc:SetNetworkedInt("InflateSize"..LeftUpperArm,7) end
	local RightUpperArm=npc:LookupBone("ValveBiped.Bip01_R_UpperArm")
	if(RightUpperArm)then npc:SetNetworkedInt("InflateSize"..RightUpperArm,7) end
	local LeftForeArm=npc:LookupBone("ValveBiped.Bip01_L_ForeArm")
	if(LeftForeArm)then npc:SetNetworkedInt("InflateSize"..LeftForeArm,5) end
	local RightForeArm=npc:LookupBone("ValveBiped.Bip01_R_ForeArm")
	if(RightForeArm)then npc:SetNetworkedInt("InflateSize"..RightForeArm,5) end
	local LeftCalf=npc:LookupBone("ValveBiped.Bip01_L_Calf")
	if(LeftCalf)then npc:SetNetworkedInt("InflateSize"..LeftCalf,15) end
	local RightCalf=npc:LookupBone("ValveBiped.Bip01_R_Calf")
	if(RightCalf)then npc:SetNetworkedInt("InflateSize"..RightCalf,15) end
	//local Neck=npc:LookupBone("ValveBiped.Bip01_Neck1")
	//if(Neck)then npc:SetNetworkedInt("InflateSize"..Neck,-50) end
end

function NPCMaker(ply,text)
	for key,found in pairs(ents.FindByClass("ent_jack_npcmaker"))do
		found:NPCMakerReceive(ply,text)
	end
end
hook.Add("PlayerSay","JackyNPCMaker",NPCMaker)

function GiveNPCMakerHelp()
	print("\n\nFirst of all, you need to turn on the NPCMaker and stand near it when speaking so it can hear you. \nOptions for person type are Citizen, Refugee, Rebel and Elite. \nOptions for specialization are Medic, Resupplier and None. \nOptions for ammosupply are Pistol, SMG, AR2, Shotgun, Grenade, SMG_Grenade, Crossbow_Bolt and .357_Magnum. \nOptions for weapon are Pistol, SMG, AR2, Shotgun, Crowbar, Lever_Action_Rifle, RPG, Stunstick, Combine_Assault_Carbine, \nCombine_Anti_Materiel_Rifle, Combine_Assault_Rifle, Combine_Battle_Rifle, Combine_Combat_Pistol, Combine_Combat_Rifle, \nCombine_Combat_Shotgun, Combine_Designated_Marksman_Rifle, Combine_Heavy_Pistol, Combine_Light_Machine_Gun, Combine_Medium_Machine_Gun, \nCombine_Machine_Pistol, Combine_Personal_Defense_Weapon, Combine_Submachinegun, Combine_Sniping_Rifle, Combine_UltraCompact_Submachinegun, \n and None. \nThen you tell it how many of these people to create. Lastly, you specify what faction allegiance the individuals will have.\nTechnically any individual can have any faction name, and all individuals with the same faction name will work together.\nBut, if you want them to work with existing factions you should use one of these names:\nCombine, Human, Necrotic, XenoCreature, Demon, Players, Rogues, JackarundaIndustriesMachines, Prey or Inconsequential.\nInconsequential causes them to be viewed as neutral by everyone. Prey causes them to fear everyone and be hated by everyone.")
end
concommand.Add("npc_maker_help",GiveNPCMakerHelp)