include('shared.lua')

language.Add("wep_jack_combine_smg","Combine Submachinegun")
killicon.Add("wep_jack_combine_smg","vgui/killicons/wep_jack_combine_smg",Color(255,255,255,255))

SWEP.PrintName="AI Combine Submachinegun"
SWEP.Slot=1
SWEP.SlotPos=3
SWEP.DrawAmmo=false
SWEP.DrawCrosshair=true
SWEP.ViewModelFOV=90
SWEP.ViewModelFlip=false

local GunMat=Material("models/mat_jack_combinesuperpistol")

SWEP.RenderGroup=RENDERGROUP_OPAQUE

function SWEP:DrawHUD()
end

function SWEP:TranslateFOV(current_fov)
	return current_fov
end

function SWEP:DrawWorldModel()
	//self.Weapon:DrawModel()
	
	local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
	pos=pos+ang:Forward()*10-ang:Up()*4
	self.NiceModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Right(),10)
	self.NiceModel:SetAngles(ang)
	self.NiceModel:SetModelScale(Vector(0.9,1,1))
	pos=pos-ang:Right()
	self.MagModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),90)
	self.MagModel:SetAngles(ang)
	self.MagModel:SetModelScale(Vector(0.65,1,0.65))
	self.BarrelModel:SetModelScale(Vector(1.1,1,1))
	self.Stock:SetModelScale(Vector(0.075,0.075,0.075))
	pos=pos+ang:Right()*4+ang:Up()*2
	self.BarrelModel:SetRenderOrigin(pos)
	pos=pos+ang:Right()*-15-ang:Up()*2
	self.Stock:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),90)
	self.BarrelModel:SetAngles(ang)
	ang:RotateAroundAxis(ang:Up(),180)
	self.Stock:SetAngles(ang)
	render.MaterialOverride(GunMat)
	render.SetColorModulation(0.9,0.9,0.9)
	self.NiceModel:DrawModel()
	self.BarrelModel:DrawModel()
	self.Stock:DrawModel()
	render.SetColorModulation(1,1,1)
	render.MaterialOverride(nil)
	
	if(self:GetDTBool(0))then
		local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Hand"))
		self.SpareMag:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*5-ang:Up()*0.75)
		self.SpareMag:SetAngles(ang)
		self.SpareMag:SetModelScale(Vector(0.565,1,0.65))
		render.MaterialOverride(GunMat)
		self.SpareMag:DrawModel()
		render.MaterialOverride(nil)
	end
	
	if(self:GetDTBool(1))then
		render.MaterialOverride(GunMat)
		self.MagModel:DrawModel()
		render.MaterialOverride(nil)
	end
end

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	return nil
end
