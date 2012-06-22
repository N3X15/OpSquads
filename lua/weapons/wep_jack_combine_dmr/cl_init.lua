include('shared.lua')

language.Add("wep_jack_combine_dmr","Combine Designated Marksman Rifle")
killicon.Add("wep_jack_combine_dmr","vgui/killicons/wep_jack_combine_dmr",Color(255,255,255,255))

SWEP.PrintName="AI Combine Designated Marksman Rifle"
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
	pos=pos+ang:Forward()*18-ang:Up()*4+ang:Right()
	self.NiceModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),180)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Right(),-10)
	self.NiceModel:SetAngles(ang)
	self.NiceModel:SetModelScale(Vector(1.1,0.8,0.8))
	self.BarrelModel:SetModelScale(Vector(3.5,0.7,0.7))
	self.OpticModel:SetModelScale(Vector(0.3,0.15,0.15))
	pos=pos-ang:Forward()*5+ang:Up()*2.75+ang:Right()*0.2
	self.BarrelModel:SetRenderOrigin(pos)
	pos=pos+ang:Up()*2.75+ang:Forward()*13
	self.OpticModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Right(),1)
	self.BarrelModel:SetAngles(ang)
	//ang:RotateAroundAxis(ang:Right(),-90)
	self.OpticModel:SetAngles(ang)
	render.SetColorModulation(0.75,0.75,0.75)
	self.NiceModel:DrawModel()
	self.BarrelModel:DrawModel()
	render.SetColorModulation(0.3,0.3,0.3)
	self.OpticModel:DrawModel()
	render.SetColorModulation(1,1,1)
	
	if(self:GetDTBool(0))then
		local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Hand"))
		self.SpareMag:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*5-ang:Up()*0.75)
		self.SpareMag:SetAngles(ang)
		self.SpareMag:SetModelScale(Vector(1,1,1))
		render.SetColorModulation(0.75,0.75,0.75)
		self.SpareMag:DrawModel()
		render.SetColorModulation(1,1,1)
	end
end

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	return nil
end
