--NPCSPAWNUR
--By Jackarunda

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local function ClearLoSBetween(ent,pos)
	local TrDat={}
	TrDat.start=ent:GetPos()+Vector(0,0,10)
	TrDat.endpos=pos
	TrDat.filter=ent
	local Tr=util.TraceLine(TrDat)
	if not(Tr.Hit)then
		return true
	else
		return false
	end
end

function ENT:SpawnFunction(ply, tr)

	local SpawnPos = tr.HitPos + tr.HitNormal*16
	local ent = ents.Create("ent_jack_npcspawner")
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

	self.Entity:SetModel("models/props_junk/cardboard_box001a.mdl")
	self.Entity:SetMaterial("models/mat_jack_npcmaker")

	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE ) -- Automatically switch to nocollide so NPCs don't get stuck.
	self.Entity.CollisionGroup = COLLISION_GROUP_NONE -- Allows users to switch to regular collision mode.

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(20)
	end
	
	self.Stage="Off"
	//self.Stage="Spawning" --DEBUGGING
	self.EnPeeSee="npc_zombie"
	self.Weapon="none"
	self.SpawnDelay=1
	self.MaxNPCs=15
	self.SpawnRadius=500
	self.DropWeapons=true
	self.ToggleCommand="toggle spawn "..self:EntIndex()
	self.NextSpawnTime=CurTime()+1
	self.FactionAllegiance="Default"
	self.NoCollide=false
	self.SquadBehavior=false
	
	self:SetNetworkedString("Spawner Type",self.EnPeeSee)
	self:SetDTBool(0,false) --if we're all set to spawn NPCs. We're not.
	
	self:SetMaterial("models/shiny")
	
	self:SetUseType(SIMPLE_USE)

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
	if(self.Stage=="Off")then
		self.Stage="Awaiting Config"
		--self:Reply(activator,"What NPC to spawn?")
		self:EmitSound("lolsounds/magicon.wav")
		umsg.Start("npcspawner_vgui",activator)
			umsg.Long( self:EntIndex() )
			umsg.String( self.EnPeeSee )
			umsg.String( self.Weapon )
			umsg.String(self.FactionAllegiance)
			umsg.Float( self.SpawnDelay )
			umsg.Long( self.MaxNPCs )
			umsg.Long( self.SpawnRadius )
			umsg.Bool( self.DropWeapons )
			umsg.Bool(self.NoCollide)
			umsg.Bool(self.SquadBehavior)
		umsg.End()
	else
		self.Stage="Off"
		self:SetDTBool(0,false)
		self:EmitSound("lolsounds/magicoff.mp3")
	end
end

function ENT:Think()
	if(self.Stage=="Spawning")then
		local NumberOfExisting=0
		for key,found in pairs(ents.FindByClass("npc_*"))do
			if(found.SpawnedByJackySpawner)then
				if(found.SpawnedByJackySpawner==self:EntIndex())then
					NumberOfExisting=NumberOfExisting+1
				end
			end
		end
		if(NumberOfExisting<self.MaxNPCs)then
			if(self.NextSpawnTime<CurTime())then
				local SelfPos=self:GetPos()
				local Attempts=0
				local WeSpawned=false
				local NewPos=SelfPos+VectorRand()*math.Rand(self.SpawnRadius/10,self.SpawnRadius)
				while((not(WeSpawned))and(Attempts<100))do
					if(ClearLoSBetween(self,NewPos))then
						local CheckData={}
						CheckData.start=NewPos
						CheckData.endpos=NewPos-Vector(0,0,self.SpawnRadius)
						local Check=util.TraceLine(CheckData)
						if(Check.Hit)then
							if not(Check.Entity:IsNPC())then
								self:CreateEnPeeSee(Check.HitPos)
								WeSpawned=true
							end
						else
							self:CreateEnPeeSee(NewPos)
							WeSpawned=true
						end
					else
						NewPos=SelfPos+VectorRand()*math.Rand(self.SpawnRadius/10,self.SpawnRadius)
					end
					Attempts=Attempts+1
					if(Attempts==100)then print("Jackarunda-NPC-Spawner "..self:EntIndex().." is having a hard time spawning.") end
				end
				self.NextSpawnTime=CurTime()+self.SpawnDelay
			end
		end
		local TimeLeft=self.NextSpawnTime-CurTime()
		local InverseFraction=math.Clamp(1-(TimeLeft/self.SpawnDelay),0,1)
		self:SetColor(Color(255*InverseFraction,255*InverseFraction,255*InverseFraction,255))
	end
	self:NextThink(CurTime()+0.01)
	return true
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

function ENT:NPCSpawnerReceive(ply,text)
	if(self.Stage=="Off")then return end
	if(self.Stage=="Dormant")then
		if(text==self.ToggleCommand)then
			self.Stage="Spawning"
			timer.Simple(0.1,function()
				if(IsValid(self))then
					ply:PrintMessage(HUD_PRINTTALK,"Activating spawner "..self:EntIndex())
				end
			end)
		end
	elseif(self.Stage=="Spawning")then
		if(text==self.ToggleCommand)then
			self.Stage="Dormant"
			timer.Simple(0.1,function()
				if(IsValid(self))then
					ply:PrintMessage(HUD_PRINTTALK,"Deactivating spawner "..self:EntIndex())
				end
			end)
		end
	end
end

function ENT:CreateEnPeeSee(Position)

	local npcClass = self.EnPeeSee
	local npcName = self.EnPeeSee
	local aliased=false
	local aliasData={}
	
	if not (NPCAliases[npcName] == nil) then
		aliasData=NPCAliases[npcName]
		npcClass=aliasData[1]
		aliased=true
	end
	
	local npc = nil
	local createdFromFunction=false
	if aliased and aliasData[5]~=false then
		npc=aliasData[5](Position+Vector(0,0,10))
		createdFromFunction=true
	else
		npc=ents.Create(npcClass)
		npc:SetPos(Position+Vector(0,0,10))
	end
	
	if aliased then
		--{"npc_class",spawnflags,citizentype,model, spawnmethod}
		local citizentype=aliasData[3]
		local spawnflags=aliasData[2]
		local model=aliasData[4]
		--print("SpawnALIAS:",npcName,npcClass,citizentype,spawnflags,model)
		
		if not citizentype == false then npc:SetKeyValue("citizentype",citizentype) end
		if not spawnflags == false then npc:SetKeyValue("spawnflags",spawnflags) end
		if not model == false then npc:SetKeyValue("model",model) end
	end
	
	if npcClass == 'npc_clawscanner' then
		JACK_SetupMinedropping(npc)
	end
	
	if not(self.FactionAllegiance=="Default")then 
		npc.HasAJackyAllegiance=true
		npc.JackyAllegiance=self.FactionAllegiance 
	end
	if(table.HasValue(NeedsWeaponTable,npcClass))then 
		npc:SetKeyValue("additionalequipment",self.Weapon) 
	end
	if(self.SquadBehavior)then npc:SetKeyValue("squadname","JackySpawnerSquad"..self:EntIndex()) end
	
	npc.SpawnedByJackySpawner=self:EntIndex()
	npc:Fire("disableshadow","",0)
	npc:SetAngles(Angle(0,math.Rand(0,360,0)))
	npc:SetKeyValue("startburrowed","1")
	if not(self.DropWeapons)then npc:SetKeyValue("spawnflags","8192") end
	npc:Spawn()
	npc:Activate()
	
	npc:Fire("enableshadow","",0.7)
	npc:Fire("unburrow","",0)
	
	if(self.NoCollide)then
		constraint.NoCollide(npc,self)
		for key,found in pairs(ents.FindByClass("npc_*"))do
			if(found.SpawnedByJackySpawner)then
				if(found.SpawnedByJackySpawner==self:EntIndex())then
					constraint.NoCollide(npc,found)
				end
			end
		end
	end
	
	//local faderate=2
	//npc:SetColor(0,0,0,0)
	//local timername="FadeIn"..npc:EntIndex()
	//timer.Create(timername,0.001,300,function()
	//	if not(IsValid(npc))then timer.Destroy(timername) return end
	//	local r,g,b,a=npc:GetColor()
	//	npc:SetColor(r+faderate,g+faderate,b+faderate,a+faderate)
	//	if((a+faderate)>=255)then npc:SetColor(255,255,255,255);timer.Destroy(timername) return end
	//end)
	
	local Appear=EffectData()
	Appear:SetEntity(npc)
	util.Effect("propspawn",Appear)
	
	if(npc:GetPhysicsObject():IsPenetrating())then
		print("Jackarunda-NPC-spawner "..self:EntIndex().." removing stuck "..self.EnPeeSee.." "..npc:EntIndex())
		npc:Remove()
	end
end

function NPCSpawner(ply,text)
	for key,found in pairs(ents.FindByClass("ent_jack_npcspawner"))do
		found:NPCSpawnerReceive(ply,text)
	end
end
hook.Add("PlayerSay","JackyNPCspawner",NPCSpawner)

function GiveNPCSpawnerHelp()
	local words = "\nSimply look at the spawner you want to fuck with and hit +use (E for most people)."
	words=words+"\nNext, fill out the form.  Many NPCs are named by class, but custom NPCs and Rebels need special handling, so they're at the top with capitalized names."
	words=words+"\nOnce you're ready, just type \'toggle spawn [spawner id]\' in chat to toggle the spawner on or off."
	words=words+"\nYou can also use \'spawnertoggle [spawnerid]\' in console to do the same thing."
	words=words+"\nEnjoy."
	print(words)
end
function SetupNPCSpawner(player,command,args)
	print("\nSetting up spawner #"..args[1])
	local eid=args[1]
	local npcClass=args[2]
	local weapon=args[3]
	local squad=args[4]
	local spawnDelay=args[5]
	local maxNPCs=args[6]
	local radius=args[7]
	local dropWeapon=args[8]
	local noCollide=args[9]
	local shareInfo=args[10]
	
	print("npcClass",npcClass)
	print("weapon",weapon)
	print("squad",squad)
	print("shareinfo",shareInfo)
	print("nocollide",noCollide)
	print("dropWeapon",dropWeapon)
	
	spawner = ents.GetByIndex(tonumber(eid))
	spawner.EnPeeSee=npcClass
	spawner:SetNetworkedString("Spawner Type",npcClass)
	spawner.Weapon=weapon
	spawner.SpawnDelay=tonumber(spawnDelay)
	spawner.MaxNPCs=tonumber(maxNPCs)
	spawner.SpawnRadius=tonumber(radius)
	spawner.DropWeapons = dropWeapon=='y'
	spawner.NoCollide = noCollide=='y'
	spawner.SquadBehavior = shareInfo=='y'
	spawner.FactionAllegiance=squad
	
	spawner.Stage="Dormant"
	spawner:Reply(player,"Spawner is now dormant. Awaiting signal message: '"..spawner.ToggleCommand.."' to toggle spawning.")
	spawner:SetDTBool(0,true)
end

function ToggleSpawner(ply,command,args) 
	for _,arg in pairs(args) do
		spawner = ents.GetByIndex(tonumber(arg))
		
		if spawner == nil then MsgN("Nope.  Can't find a spawner by that ID."); return end
		
		if(spawner.Stage=="Dormant")then
			spawner.Stage="Spawning"
			timer.Simple(0.1,function()
				if(IsValid(spawner))then
					ply:PrintMessage(HUD_PRINTTALK,"Activating spawner "..spawner:EntIndex())
				end
			end)
		elseif(spawner.Stage=="Spawning")then
			spawner.Stage="Dormant"
			timer.Simple(0.1,function()
				if(IsValid(spawner))then
					ply:PrintMessage(HUD_PRINTTALK,"Deactivating spawner "..spawner:EntIndex())
				end
			end)
		end
	end
end


concommand.Add("npc_spawner_help",GiveNPCSpawnerHelp)
concommand.Add("npc_spawner_init",SetupNPCSpawner)
concommand.Add("spawnertoggle",ToggleSpawner)