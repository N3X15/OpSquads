if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

SWEP.Author="Jackarunda"
SWEP.Contact=""
SWEP.Purpose=""
SWEP.Instructions=""
SWEP.Category="AI Weapons"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel="models/weapons/v_pistol.mdl"
SWEP.WorldModel="models/weapons/w_357.mdl" --w_IRifle if you want combine muzzle flash

SWEP.Primary.ClipSize		= 9000
SWEP.Primary.DefaultClip	= 9000
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

/*---------------------------------------------------------
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType("pistol")
	if(SERVER)then
		self:SetNPCMinBurst(9000)
		self:SetNPCMaxBurst(9000)
		self:SetNPCFireRate(0.25)
	end
	
	self:SetDTBool(0,false)
	
	self.RoundsInPulseMag=0
	
	if(CLIENT)then
		self.NiceModel=ClientsideModel("models/weapons/w_pistol.mdl")
		self.NiceModel:SetPos(self.Owner:GetPos())
		self.NiceModel:SetNoDraw(true)
		
		self.SpareMag=ClientsideModel("models/hunter/plates/plate025.mdl")
		self.SpareMag:SetPos(self.Owner:GetPos())
		self.SpareMag:SetNoDraw(true)
		
		self.AmmoTank=ClientsideModel("models/props_junk/PropaneCanister001a.mdl")
		self.AmmoTank:SetPos(self.Owner:GetPos())
		self.AmmoTank:SetNoDraw(true)
		
		self.TechDeviceOne=ClientsideModel("models/props_junk/watermelon01.mdl")
		self.TechDeviceOne:SetPos(self.Owner:GetPos())
		self.TechDeviceOne:SetNoDraw(true)
		
		self.TechDeviceTwo=ClientsideModel("models/props_junk/watermelon01.mdl")
		self.TechDeviceTwo:SetPos(self.Owner:GetPos())
		self.TechDeviceTwo:SetNoDraw(true)
	end
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
end

/*------------------------------------
    Reload
------------------------------------*/
//function SWEP:Reload()
//	return true
//end 

/*---------------------------------------------------------
   Name: GetCapabilities
   Desc: For NPCs, returns what they should try to do with it.
---------------------------------------------------------*/
function SWEP:GetCapabilities()
	return CAP_WEAPON_RANGE_ATTACK1
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end
