include('shared.lua')

language.Add("wep_jack_rocketlauncher","RPG")
//killicon.Add("wep_jack_rocketlauncher","HUD/killicons/weapon_rpg",Color(255,80,0,255))

SWEP.PrintName="AI SuperPistol"
SWEP.Slot=1
SWEP.SlotPos=3
SWEP.DrawAmmo=false
SWEP.DrawCrosshair=true
SWEP.ViewModelFOV=90
SWEP.ViewModelFlip=false

local GunMat=Material("models/mat_jack_combinesuperpistol")
local ClotheMat=Material("models/combine/badass_sheet")
local Sprite=Material("sprites/redglow1.vmt")

SWEP.RenderGroup=RENDERGROUP_OPAQUE

function SWEP:DrawHUD()
end

function SWEP:TranslateFOV(current_fov)
	return current_fov
end

function SWEP:DrawWorldModel()
	//self.Weapon:DrawModel()
	
	local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
	pos=pos+ang:Forward()*7+ang:Right()*1.5-ang:Up()*4
	self.NiceModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),180)
	ang:RotateAroundAxis(ang:Forward(),180)
	self.NiceModel:SetAngles(ang)
	self.NiceModel:SetModelScale(Vector(1.75,1.1,1.1))
	render.MaterialOverride(GunMat)
	render.SetColorModulation(0.8,0.8,0.8)
	self.NiceModel:DrawModel()
	render.SetColorModulation(1,1,1)
	render.MaterialOverride(nil)
	
	pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_UpperArm"))
	self.TechDeviceOne:SetRenderOrigin(pos)
	self.TechDeviceOne:SetAngles(ang)
	self.TechDeviceOne:SetModelScale(Vector(0.65,0.65,0.65))
	
	pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm"))
	self.TechDeviceTwo:SetRenderOrigin(pos)
	self.TechDeviceTwo:SetAngles(ang)
	self.TechDeviceTwo:SetModelScale(Vector(0.65,0.65,0.65))
	
	pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_Spine2"))
	pos=pos+ang:Right()*7+ang:Forward()*5
	self.AmmoTank:SetRenderOrigin(pos)
	self.AmmoTank:SetAngles(ang)
	self.AmmoTank:SetModelScale(Vector(0.8,0.8,1.2))
	render.MaterialOverride(ClotheMat)
	self.TechDeviceOne:DrawModel()
	self.TechDeviceTwo:DrawModel()
	render.MaterialOverride(GunMat)
	render.SetColorModulation(0.75,0.75,0.75)
	self.AmmoTank:DrawModel()
	render.MaterialOverride(nil)
	render.SetColorModulation(1,1,1)
	
	//self.Owner:DrawModel() --THIS WEAPON IS ABSOLUTELY INTEGRAL TO THE HYPERELTE CIVIL PROTECTION AGENT
	
	pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_Head1"))
	render.SetMaterial(Sprite)
	render.DrawSprite(pos+ang:Right()*6.5+ang:Up()*1.5+ang:Forward()*3.5,10,5,Color(100,255,200,255))
	render.DrawSprite(pos+ang:Right()*6.5-ang:Up()*1.5+ang:Forward()*3.5,10,5,Color(100,255,200,255))
	render.DrawSprite(pos+ang:Right()*6.75+ang:Up()*1.5+ang:Forward()*3.5,11,6,Color(100,255,200,255))
	render.DrawSprite(pos+ang:Right()*6.75-ang:Up()*1.5+ang:Forward()*3.5,11,6,Color(100,255,200,255))
	render.DrawSprite(pos+ang:Right()*7+ang:Up()*1.5+ang:Forward()*3.5,12,7,Color(100,255,200,255))
	render.DrawSprite(pos+ang:Right()*7-ang:Up()*1.5+ang:Forward()*3.5,12,7,Color(100,255,200,255))
	
	if(self:GetDTBool(0))then
		local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Hand"))
		self.SpareMag:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*5-ang:Up()*0.75)
		self.SpareMag:SetAngles(ang)
		self.SpareMag:SetModelScale(Vector(0.6,0.6,0.6))
		render.MaterialOverride(GunMat)
		render.SetColorModulation(0.8,0.8,0.8)
		self.SpareMag:DrawModel()
		render.SetColorModulation(1,1,1)
		render.MaterialOverride(nil)
	end
end

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	return nil
end
