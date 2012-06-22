include('shared.lua')

language.Add("wep_jack_combine_hp","Combine Heavy Pistol")
killicon.Add("wep_jack_combine_hp","vgui/killicons/wep_jack_combine_hp",Color(255,255,255,255))

SWEP.PrintName="AI Combine Heavy Pistol"
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
	pos=pos+ang:Forward()*5-ang:Up()*3+ang:Right()*1.25
	self.NiceModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),180)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Right(),-5)
	self.NiceModel:SetAngles(ang)
	self.NiceModel:SetModelScale(Vector(1,1,1))
	pos=pos+ang:Forward()*-5+ang:Right()*-0.15
	self.BarrelModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),3)
	self.BarrelModel:SetAngles(ang)
	self.BarrelModel:SetModelScale(Vector(1,1,1))
	render.SetColorModulation(0.8,0.8,0.8)
	render.MaterialOverride(GunMat)
	self.NiceModel:DrawModel()
	self.BarrelModel:DrawModel()
	render.MaterialOverride(nil)
	
	if(self:GetDTBool(0))then
		local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Hand"))
		self.SpareMag:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*5-ang:Up()*0.75)
		self.SpareMag:SetAngles(ang)
		self.SpareMag:SetModelScale(Vector(0.6,0.6,0.6))
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
