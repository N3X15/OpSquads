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

SWEP.NeedsJackyDrivenGlobalThink=true

SWEP.ViewModel="models/weapons/v_pistol.mdl"
SWEP.WorldModel="models/weapons/w_357.mdl" ----w_IRifle if you want combine muzzle flash

SWEP.Primary.ClipSize		= 9000
SWEP.Primary.DefaultClip	= 9000
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

/*---------------------------------------------------------
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType("ar2")
	if(SERVER)then
		self:SetNPCMinBurst(1000) --this all has no meaning because I control the firing anyways
		self:SetNPCMaxBurst(1000)
		self:SetNPCFireRate(0.1) --amount of time between bursts in seconds
	end
	
	//DTBool 1 is whether or not the mag appears on the gun
	//DTBool 0 is whether or not a mag appears in the user's hand
	//DTEntity 0 is the individual we're currently targetting
	self:SetDTBool(0,false)
	self:SetDTBool(1,true)
	self:SetDTEntity(0,nil)

	self.Reloading=false
	self.Aiming=false
	
	if(CLIENT)then
		self.NiceModel=ClientsideModel("models/weapons/w_combinesniper_e2.mdl")
		self.NiceModel:SetPos(self.Owner:GetPos())
		self.NiceModel:SetNoDraw(true)
		
		self.SpareMag=ClientsideModel("models/Items/Flare.mdl")
		self.SpareMag:SetPos(self.Owner:GetPos())
		self.SpareMag:SetNoDraw(true)
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
