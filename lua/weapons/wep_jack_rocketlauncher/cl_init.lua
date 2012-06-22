include('shared.lua')

language.Add("wep_jack_rocketlauncher","RPG")
//killicon.Add("wep_jack_rocketlauncher","HUD/killicons/weapon_rpg",Color(255,80,0,255))

SWEP.PrintName="AI Rocket Launcher"
SWEP.Slot=1
SWEP.SlotPos=3
SWEP.DrawAmmo=false
SWEP.DrawCrosshair=true
SWEP.ViewModelFOV=90
SWEP.ViewModelFlip=false

SWEP.RenderGroup=RENDERGROUP_OPAQUE

function SWEP:DrawHUD()
end

function SWEP:TranslateFOV(current_fov)
	return current_fov
end

function SWEP:DrawWorldModel()
	self.Weapon:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	return nil
end
