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
		self:SetNPCMinBurst(1)
		self:SetNPCMaxBurst(30)
		self:SetNPCFireRate(0.2) --amount of time between bursts in seconds
	end
	
	//DTBool 1 is whether or not the mag appears on the gun
	//DTBool 0 is whether or not a mag appears in the user's hand
	self:SetDTBool(0,false)
	self:SetDTBool(1,true)
	
	self.RoundsInPulseMag=30
	self.Reloading=false
	
	if(CLIENT)then
		self.NiceModel=ClientsideModel("models/weapons/w_IRifle.mdl")
		self.NiceModel:SetPos(self.Owner:GetPos())
		self.NiceModel:SetNoDraw(true)
		
		self.BarrelModel=ClientsideModel("models/props_combine/headcrabcannister01a_skybox.mdl")
		self.BarrelModel:SetPos(self.Owner:GetPos())
		self.BarrelModel:SetNoDraw(true)
		self.SecondBarrelModel=ClientsideModel("models/props_combine/headcrabcannister01a_skybox.mdl")
		self.SecondBarrelModel:SetPos(self.Owner:GetPos())
		self.SecondBarrelModel:SetNoDraw(true)
		
		self.SpareMag=ClientsideModel("models/Items/combine_rifle_cartridge01.mdl")
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
