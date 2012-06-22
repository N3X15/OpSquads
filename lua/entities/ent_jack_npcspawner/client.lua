
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
local cmbSquad
local cmbWeapon
local lblWeapon
local cmbClass
local lblClass
local cmbPresets
local frmSpawner
local function SetUpDerma(spawner)
	frmSpawner = vgui.Create('DFrame')
	frmSpawner:SetSize(223, 362)
	frmSpawner:SetPos(54, 73)
	frmSpawner:SetTitle('NPC Spawner')
	frmSpawner:SetSizable(true)
	frmSpawner:SetDeleteOnClose(false)
	frmSpawner:MakePopup()

	cmdCancel = vgui.Create('DButton')
	cmdCancel:SetParent(frmSpawner)
	cmdCancel:SetSize(70, 25)
	cmdCancel:SetPos(188, 396)
	cmdCancel:SetText('Cancel')
	cmdCancel.DoClick = function() 
		frmSpawner:Close()
	end

	cmdSave = vgui.Create('DButton')
	cmdSave:SetParent(frmSpawner)
	cmdSave:SetSize(70, 25)
	cmdSave:SetPos(91, 396)
	cmdSave:SetText('Save')
	cmdSave.DoClick = function() 
		if cmbClass:GetSelectedItems() and cmbClass:GetSelectedItems()[1] then
			spawner:SetNetworkedString("Spawner Type",cmbClass:GetSelectedItems()[1]:GetValue()
		end
		if cmbWeapons:GetSelectedItems() and cmbWeapons:GetSelectedItems()[1] then
			spawner.Weapon=RealWeaponNameTable[cmbWeapons]
		end
		spawner.DropWeapons = chkDropWeapons:GetChecked()
		spawner.SpawnDelay = numSpawnDelay:GetValue()
	end

	chkShareInfo = vgui.Create('DCheckBoxLabel')
	chkShareInfo:SetParent(frmSpawner)
	chkShareInfo:SetPos(90, 372)
	chkShareInfo:SetText('NPCs share info w/alliance')
	chkShareInfo:SetValue(true)
	chkShareInfo.DoClick = function() end
	chkShareInfo:SizeToContents()

	chkNoCollideNPCs = vgui.Create('DCheckBoxLabel')
	chkNoCollideNPCs:SetParent(frmSpawner)
	chkNoCollideNPCs:SetPos(90, 350)
	chkNoCollideNPCs:SetText('NoCollide between NPCs')
	chkNoCollideNPCs.DoClick = function() end
	chkNoCollideNPCs:SizeToContents()

	chkWeaponDrop = vgui.Create('DCheckBoxLabel')
	chkWeaponDrop:SetParent(frmSpawner)
	chkWeaponDrop:SetPos(90, 329)
	chkWeaponDrop:SetText('Drop Weapons on Death')
	chkWeaponDrop:SetValue(true)
	chkWeaponDrop.DoClick = function() end
	chkWeaponDrop:SizeToContents()

	lblMaxNPCs = vgui.Create('DLabel')
	lblMaxNPCs:SetParent(frmSpawner)
	lblMaxNPCs:SetPos(90, 300)
	lblMaxNPCs:SetText('Max NPCs:')
	lblMaxNPCs:SizeToContents()

	numMaxNPCs = vgui.Create('DNumberWang')
	numMaxNPCs:SetParent(frmSpawner)
	numMaxNPCs:SetPos(148, 296)
	numMaxNPCs:SetDecimals(0)
	numMaxNPCs:SetFloatValue(0)
	numMaxNPCs:SetFraction(0)
	numMaxNPCs.OnMouseReleased = function() end
	numMaxNPCs.OnValueChanged = function() end
	numMaxNPCs:SetValue('1')
	numMaxNPCs:SetMinMax( 1, 100)

	numDelay = vgui.Create('DNumberWang')
	numDelay:SetParent(frmSpawner)
	numDelay:SetPos(148, 267)
	numDelay:SetDecimals(0)
	numDelay:SetFloatValue(0)
	numDelay:SetFraction(0)
	numDelay.OnMouseReleased = function() end
	numDelay.OnValueChanged = function() end
	numDelay:SetValue('1')
	numDelay:SetMinMax( 1, 60)

	lblDelay = vgui.Create('DLabel')
	lblDelay:SetParent(frmSpawner)
	lblDelay:SetPos(89, 271)
	lblDelay:SetText('Delay (s):')
	lblDelay:SizeToContents()

	numSpawnRadius = vgui.Create('DNumberWang')
	numSpawnRadius:SetParent(frmSpawner)
	numSpawnRadius:SetPos(148, 239)
	numSpawnRadius:SetDecimals(0)
	numSpawnRadius:SetFloatValue(0)
	numSpawnRadius:SetFraction(0)
	numSpawnRadius.OnMouseReleased = function() end
	numSpawnRadius.OnValueChanged = function() end
	numSpawnRadius:SetValue('60')
	numSpawnRadius:SetMinMax( 10, 240)

	lblSpawnRad = vgui.Create('DLabel')
	lblSpawnRad:SetParent(frmSpawner)
	lblSpawnRad:SetPos(89, 243)
	lblSpawnRad:SetText('Radius:')
	lblSpawnRad:SizeToContents()

	lblSquad = vgui.Create('DLabel')
	lblSquad:SetParent(frmSpawner)
	lblSquad:SetPos(89, 215)
	lblSquad:SetText('Squad:')
	lblSquad:SizeToContents()

	cmbSquad = vgui.Create('DMultiChoice')
	cmbSquad:SetParent(frmSpawner)
	cmbSquad:SetPos(148, 210)
	cmbSquad.OnMousePressed = function() end
	function cmbSquad:OnSelect(Index, Value, Data) end

	cmbWeapon = vgui.Create('DMultiChoice')
	cmbWeapon:SetParent(frmSpawner)
	cmbWeapon:SetPos(148, 182)
	cmbWeapon.OnMousePressed = function() end
	function cmbWeapon:OnSelect(Index, Value, Data) end

	lblWeapon = vgui.Create('DLabel')
	lblWeapon:SetParent(frmSpawner)
	lblWeapon:SetPos(89, 187)
	lblWeapon:SetText('Weapon:')
	lblWeapon:SizeToContents()

	cmbClass = vgui.Create('DMultiChoice')
	cmbClass:SetParent(frmSpawner)
	cmbClass:SetPos(148, 155)
	cmbClass.OnMousePressed = function() end
	function cmbClass:OnSelect(Index, Value, Data) end

	lblClass = vgui.Create('DLabel')
	lblClass:SetParent(frmSpawner)
	lblClass:SetPos(89, 159)
	lblClass:SetText('NPC Class:')
	lblClass:SizeToContents()

	cmbPresets = vgui.Create('DMultiChoice')
	cmbPresets:SetParent(frmSpawner)
	cmbPresets:SetPos(87, 121)
	cmbPresets.OnMousePressed = function() end
	function cmbPresets:OnSelect(Index, Value, Data) end
	
	-- Set up our shit
	for npcClass in EnPeeSeeTable do
		cmbClass:AddItem(npcClass)
	end
	
	for weaponName in WeaponTable do
		cmbWeapon:AddItem(weaponName)
	end
	
	--Combine, Human, Necrotic, XenoCreature, Demon, Players, Rogues, JackarundaIndustriesMachines, Prey or Inconsequential
	cmbSquads:AddItem("Combine")
	cmbSquads:AddItem("Human")
	cmbSquads:AddItem("Elite")
	cmbSquads:AddItem("Necrotic")
	cmbSquads:AddItem("XenoCreature")
	cmbSquads:AddItem("Demon")
	cmbSquads:AddItem("Players")
	cmbSquads:AddItem("Rogues")
	cmbSquads:AddItem("JackarundaIndustriesMachines")
	cmbSquads:AddItem("Prey")
	cmbSquads:AddItem("Inconsequential")
end