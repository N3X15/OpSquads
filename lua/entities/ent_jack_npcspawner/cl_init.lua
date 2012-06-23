
include('shared.lua')

function ENT:Initialize()

	self.TextDisplayAngle=self:GetAngles()
	self.TextDisplayAngle:RotateAroundAxis(self.TextDisplayAngle:Forward(),90)
	
	self.NextAngleIncrementTime=CurTime()

end

function ENT:Draw()

	self.Entity:DrawModel()

	if(self:GetDTBool(0))then
		local Text=self:GetNetworkedString("Spawner Type") --THIS IS EXPENSIVE
		local SecondText=tostring(self:EntIndex())
		
		local CenterOffset=string.len(Text)*2

		cam.Start3D2D(self:GetPos()+Vector(0,0,25)-self.TextDisplayAngle:Forward()*CenterOffset,self.TextDisplayAngle,0.75)
			draw.DrawText(Text,"Default",0,0,Color(math.Rand(200,255),math.Rand(200,255),math.Rand(200,255),150))
			draw.DrawText(SecondText,"Default",CenterOffset,-9,Color(math.Rand(200,255),math.Rand(200,255),math.Rand(200,255),150))
		cam.End3D2D()
		
		local SecondAngle=self.TextDisplayAngle
		SecondAngle:RotateAroundAxis(SecondAngle:Forward(),180)
		SecondAngle:RotateAroundAxis(SecondAngle:Up(),180)
		cam.Start3D2D(self:GetPos()+Vector(0,0,25)-self.TextDisplayAngle:Forward()*CenterOffset,SecondAngle,0.75)
			draw.DrawText(Text,"Default",0,0,Color(math.Rand(200,255),math.Rand(200,255),math.Rand(200,255),150))
			draw.DrawText(SecondText,"Default",CenterOffset,-9,Color(math.Rand(200,255),math.Rand(200,255),math.Rand(200,255),150))
		cam.End3D2D()
		
		if(self.NextAngleIncrementTime<CurTime())then
			local NewYaw=self.TextDisplayAngle.y+1
			if(NewYaw>360)then NewYaw=0 end
			
			self.TextDisplayAngle=Angle(self.TextDisplayAngle.p,NewYaw,self.TextDisplayAngle.r)
			self.NextAngleIncrementTime=CurTime()+0.01
		end
	end

end

function ENT:OnRemove()

end


local selNPCClass="npc_civilian"
local selWeapon = "weapon_pistol"
local selSquad = "Human"

local function ShowDerma(data)
	local cmdCancel
	local cmdSave
	local chkShareInfo
	local chkNoCollideNPCs
	local chkWeaponDrop
	local lblMaxNPCs
	local numMaxNPCs
	local numDelay
	local lblDelay
	local numSpawnRadius
	local lblSpawnRad
	local lblSquad
	local _cmbSquad
	local cmbWeapon
	local lblWeapon
	local cmbClass
	local lblClass
	local cmbPresets
	local frmSpawner
	
		
	--eid,npcClass,weapon,squad,spawnDelay,maxNPCs,radius,dropWeapon,noCollide,shareInfo
	local eid = data:ReadLong()
	frmSpawner = vgui.Create('DFrame')
	frmSpawner:SetSize(223, 362)
	frmSpawner:SetPos(54, 73)
	frmSpawner:SetTitle('NPC Spawner #'..tostring(eid))
	frmSpawner:SetSizable(true)
	frmSpawner:SetDeleteOnClose(false)
	frmSpawner:MakePopup()

	cmdCancel = vgui.Create('DButton')
	cmdCancel:SetParent(frmSpawner)
	cmdCancel:SetSize(70, 25)
	cmdCancel:SetPos(60, 396-90)
	cmdCancel:SetText('Cancel')
	cmdCancel.DoClick = function() 
		frmSpawner:Close()
	end

	cmdSave = vgui.Create('DButton')
	cmdSave:SetParent(frmSpawner)
	cmdSave:SetSize(70, 25)
	cmdSave:SetPos(5, 396-90)
	cmdSave:SetText('Save')
	cmdSave.DoClick = function() 
		local npcClass="npc_civilian"
		local weapon = "weapon_pistol"
		local squad = "Human"
		local spawnDelay = 5
		local maxNPCs = 1
		local radius = 60
		local dropWeapon = false
		local noCollide = false
		local shareInfo = true
		
		npcClass=selNPCClass
		weapon=tostring(RealWeaponNameTable[selWeapon])
		squad=selSquad
		
		dropWeapon = chkWeaponDrop:GetChecked() and 'y' or 'n'
		noCollide = chkNoCollideNPCs:GetChecked() and 'y' or 'n'
		shareInfo = chkShareInfo:GetChecked() and 'y' or 'n'
		
		spawnDelay = numDelay:GetValue()
		maxNPCs=numMaxNPCs:GetValue()
		radius=numSpawnRadius:GetValue()
		
		RunConsoleCommand("npc_spawner_init",eid,npcClass,weapon,squad,spawnDelay,maxNPCs,radius,dropWeapon,noCollide,shareInfo)
		
		frmSpawner:Close()
	end

	chkShareInfo = vgui.Create('DCheckBoxLabel')
	chkShareInfo:SetParent(frmSpawner)
	chkShareInfo:SetPos(5, 372-90)
	chkShareInfo:SetText('NPCs share info w/alliance')
	chkShareInfo:SetValue(true)
	chkShareInfo.DoClick = function() end
	chkShareInfo:SizeToContents()

	chkNoCollideNPCs = vgui.Create('DCheckBoxLabel')
	chkNoCollideNPCs:SetParent(frmSpawner)
	chkNoCollideNPCs:SetPos(5, 350-90)
	chkNoCollideNPCs:SetText('NoCollide between NPCs')
	chkNoCollideNPCs.DoClick = function() end
	chkNoCollideNPCs:SizeToContents()

	chkWeaponDrop = vgui.Create('DCheckBoxLabel')
	chkWeaponDrop:SetParent(frmSpawner)
	chkWeaponDrop:SetPos(5, 329-90)
	chkWeaponDrop:SetText('Drop Weapons on Death')
	chkWeaponDrop:SetValue(true)
	chkWeaponDrop.DoClick = function() end
	chkWeaponDrop:SizeToContents()

	lblMaxNPCs = vgui.Create('DLabel')
	lblMaxNPCs:SetParent(frmSpawner)
	lblMaxNPCs:SetPos(5, 300-90)
	lblMaxNPCs:SetText('Max NPCs:')
	lblMaxNPCs:SizeToContents()

	numMaxNPCs = vgui.Create('DNumberWang')
	numMaxNPCs:SetParent(frmSpawner)
	numMaxNPCs:SetPos(60, 296-90)
	numMaxNPCs:SetDecimals(0)
	numMaxNPCs:SetFloatValue(0)
	numMaxNPCs:SetFraction(0)
	numMaxNPCs.OnMouseReleased = function() end
	numMaxNPCs.OnValueChanged = function() end
	numMaxNPCs:SetValue('1')
	numMaxNPCs:SetMinMax( 1, 100)

	numDelay = vgui.Create('DNumberWang')
	numDelay:SetParent(frmSpawner)
	numDelay:SetPos(60, 267-90)
	numDelay:SetDecimals(0)
	numDelay:SetFloatValue(0)
	numDelay:SetFraction(0)
	numDelay.OnMouseReleased = function() end
	numDelay.OnValueChanged = function() end
	numDelay:SetValue('1')
	numDelay:SetMinMax( 1, 60)

	lblDelay = vgui.Create('DLabel')
	lblDelay:SetParent(frmSpawner)
	lblDelay:SetPos(5, 271-90)
	lblDelay:SetText('Delay (s):')
	lblDelay:SizeToContents()

	numSpawnRadius = vgui.Create('DNumberWang')
	numSpawnRadius:SetParent(frmSpawner)
	numSpawnRadius:SetPos(60, 239-90)
	numSpawnRadius:SetDecimals(0)
	numSpawnRadius:SetFloatValue(0)
	numSpawnRadius:SetFraction(0)
	numSpawnRadius.OnMouseReleased = function() end
	numSpawnRadius.OnValueChanged = function() end
	numSpawnRadius:SetValue('60')
	numSpawnRadius:SetMinMax( 10, 240)

	lblSpawnRad = vgui.Create('DLabel')
	lblSpawnRad:SetParent(frmSpawner)
	lblSpawnRad:SetPos(5, 243-90)
	lblSpawnRad:SetText('Radius:')
	lblSpawnRad:SizeToContents()

	lblSquad = vgui.Create('DLabel')
	lblSquad:SetParent(frmSpawner)
	lblSquad:SetPos(5, 215-90)
	lblSquad:SetText('Squad:')
	lblSquad:SizeToContents()

	_cmbSquad = vgui.Create('DComboBox')
	_cmbSquad:SetParent(frmSpawner)
	_cmbSquad:SetPos(60, 210-90)
	_cmbSquad:SetWide(150)
	function _cmbSquad:OnSelect(Index, value, Data) 
		selSquad=value
	end

	cmbWeapon = vgui.Create('DComboBox')
	cmbWeapon:SetParent(frmSpawner)
	cmbWeapon:SetPos(60, 182-90)
	cmbWeapon:SetWide(150)
	function cmbWeapon:OnSelect(Index, value, Data) 
		selWeapon=value
	end

	lblWeapon = vgui.Create('DLabel')
	lblWeapon:SetParent(frmSpawner)
	lblWeapon:SetPos(5, 187-90)
	lblWeapon:SetText('Weapon:')
	lblWeapon:SizeToContents()

	cmbClass = vgui.Create('DComboBox')
	cmbClass:SetParent(frmSpawner)
	cmbClass:SetPos(60, 155-90)
	cmbClass:SetWide(150)
	function cmbClass:OnSelect(Index, value, Data) 
		selNPCClass=value
	end

	lblClass = vgui.Create('DLabel')
	lblClass:SetParent(frmSpawner)
	lblClass:SetPos(5, 159-90)
	lblClass:SetText('NPC Class:')
	lblClass:SizeToContents()

	cmbPresets = vgui.Create('DComboBox')
	cmbPresets:SetParent(frmSpawner)
	cmbPresets:SetPos(5, 121-90)
	cmbPresets:SetWide(150)
	function cmbPresets:OnSelect(Index, value, Data) end
	
	
	
	-- Set up our shit
	--npcClass,weapon,squad,spawnDelay,maxNPCs,radius,dropWeapon,noCollide,shareInfo
	local npcClass_orig=data:ReadString()
	local weapon_orig=data:ReadString()
	local squad_orig=data:ReadString()
	
	numDelay:SetValue( data:ReadFloat() )
	numMaxNPCs:SetValue( data:ReadLong() )
	numSpawnRadius:SetValue( data:ReadLong() )
	
	chkWeaponDrop:SetValue( data:ReadBool() )
	chkNoCollideNPCs:SetValue( data:ReadBool() )
	chkShareInfo:SetValue( data:ReadBool() )
	
	for k,npcClass in pairs(EnPeeSeeTable) do
		--print(k,npcClass)
		cmbClass:AddChoice(npcClass)
		if npcClass == npcClass_orig then
			cmbClass:ChooseOptionID(k)
		end
	end
	
	for weapName,weapClass in pairs(RealWeaponNameTable) do
		if weapClass == weapon_orig then
			weapon_orig=weapName
			break
		end
	end
	cmbWeapon:AddChoice('None')
	cmbWeapon:ChooseOptionID(1) -- Default to None
	for k,weaponName in pairs(WeaponTable) do
		cmbWeapon:AddChoice(weaponName)
		if weaponName == weapon_orig then
			cmbWeapon:ChooseOptionID(k+1)
		end
	end
	
	--Combine, Human, Necrotic, XenoCreature, Demon, Players, Rogues, JackarundaIndustriesMachines, Prey or Inconsequential
	local Squads={
		"Default",
		"Combine",
		"Human",
		"Elite",
		"Necrotic",
		"XenoCreature",
		"Demon",
		"Players",
		"Rogues",
		"JackarundaIndustriesMachines",
		"Prey",
		"Inconsequential"
	}
	for k,squad in pairs(Squads) do
		_cmbSquad:AddChoice(squad)
		if squad == squad_orig then
			_cmbSquad:ChooseOptionID(k)
		end
	end
	
	
end
usermessage.Hook( "npcspawner_vgui", ShowDerma )