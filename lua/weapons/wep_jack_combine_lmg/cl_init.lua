include('shared.lua')

language.Add("wep_jack_combine_lmg","Combine Light Machine Gun")
killicon.Add("wep_jack_combine_lmg","vgui/killicons/wep_jack_combine_lmg",Color(255,255,255,255))

SWEP.PrintName="AI Combine Light Machine Gun"
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
	pos=pos+ang:Forward()*17-ang:Up()*3+ang:Right()
	self.NiceModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),180)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Right(),-10)
	self.NiceModel:SetAngles(ang)
	self.NiceModel:SetModelScale(Vector(1,1,1))
	self.MagModel:SetModelScale(Vector(1.5,3,1.5))
	pos=pos-ang:Forward()*-1+ang:Up()*-1+ang:Right()*3
	self.MagModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),90)
	self.MagModel:SetAngles(ang)
	//render.SetColorModulation(0.75,0.75,0.75)
	self.NiceModel:DrawModel()
	if(self:GetDTBool(1))then
		self.MagModel:DrawModel()
	end
	//render.SetColorModulation(1,1,1)
	
	if(self:GetDTBool(0))then
		local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Hand"))
		self.SpareMag:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*5-ang:Up()*0.75)
		self.SpareMag:SetAngles(ang)
		self.SpareMag:SetModelScale(Vector(1.5,3,1.5))
		//render.SetColorModulation(0.75,0.75,0.75)
		self.SpareMag:DrawModel()
		//render.SetColorModulation(1,1,1)
	end
end

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	return nil
end
