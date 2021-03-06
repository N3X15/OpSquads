include('shared.lua')

language.Add("wep_jack_combine_ucsg","Combine Ultra-Compact Shotgun")
killicon.Add("wep_jack_combine_ucsg","vgui/killicons/wep_jack_combine_ucsg",Color(255,255,255,255))

SWEP.PrintName="AI Combine UltraCompact Shotgun"
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
	pos=pos+ang:Forward()*11-ang:Up()*1.5+ang:Right()*0.5
	self.NiceModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),177)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Right(),-15)
	self.NiceModel:SetAngles(ang)
	self.NiceModel:SetModelScale(Vector(0.55,1,1))
	self.BarrelModel:SetModelScale(Vector(1,0.7,0.7))
	self.HeatSinkModel:SetModelScale(Vector(0.2,0.15,0.055))
	pos=pos-ang:Forward()*7+ang:Up()*1+ang:Right()*0
	self.BarrelModel:SetRenderOrigin(pos)
	pos=pos+ang:Forward()*7+ang:Up()*-2
	self.MagModel:SetRenderOrigin(pos)
	pos=pos+ang:Forward()*-6-ang:Up()*1.25
	self.HeatSinkModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Right(),14)
	ang:RotateAroundAxis(ang:Up(),-5)
	self.BarrelModel:SetAngles(ang)
	ang:RotateAroundAxis(ang:Up(),-52)
	ang:RotateAroundAxis(ang:Right(),-3)
	self.MagModel:SetAngles(ang)
	ang:RotateAroundAxis(ang:Up(),145)
	self.HeatSinkModel:SetAngles(ang)
	render.SetColorModulation(0.8,0.8,0.8)
	render.MaterialOverride(GunMat)
	self.NiceModel:DrawModel()
	self.HeatSinkModel:DrawModel()
	if(self:GetDTBool(1))then
		self.MagModel:DrawModel()
	end
	render.MaterialOverride(nil)
	self.BarrelModel:DrawModel()
	
	if(self:GetDTBool(0))then
		local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Hand"))
		self.SpareMag:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*5-ang:Up()*0.75)
		self.SpareMag:SetAngles(ang)
		render.MaterialOverride(GunMat)
		self.SpareMag:DrawModel()
		render.MaterialOverride(nil)
	end
	render.SetColorModulation(1,1,1)
end

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	return nil
end
