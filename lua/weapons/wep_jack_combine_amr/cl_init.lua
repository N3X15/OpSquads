include('shared.lua')

language.Add("wep_jack_combine_amr","Combine Anti-Materiel Rifle")
killicon.Add("wep_jack_combine_amr","vgui/killicons/wep_jack_combine_amr",Color(255,255,255,255))

SWEP.PrintName="AI Combine Anti-Materiel Rifle"
SWEP.Slot=1
SWEP.SlotPos=3
SWEP.DrawAmmo=false
SWEP.DrawCrosshair=true
SWEP.ViewModelFOV=90
SWEP.ViewModelFlip=false
SWEP.RenderGroup=RENDERGROUP_OPAQUE

local GunMat=Material("models/mat_jack_combinesuperpistol")
local lolmat=Material("trails/laser.vmt")
local derpmat=Material("sprites/jackconfetti")

function SWEP:HeightCorrection(Enemy)
	local NeedsHeightCorrectionTable={"npc_headcrab_black","npc_headcrab_poison","npc_pigeon","npc_crow","npc_seagull","npc_zombie","npc_zombine","player","npc_citizen","npc_hunter","npc_combine_s"}
	local HeightCorrectionTable={
		["npc_pigeon"]=-6,
		["npc_crow"]=-6,
		["npc_seagull"]=-6,
		["npc_zombie"]=10,
		["npc_zombine"]=7,
		["player"]=17,
		["npc_citizen"]=17,
		["npc_hunter"]=20,
		["npc_combine_s"]=10,
		["npc_headcrab_black"]=-5,
		["npc_headcrab_poison"]=-5
	}
	local Class=Enemy:GetClass()
	if(table.HasValue(NeedsHeightCorrectionTable,Class))then
		return Vector(0,0,HeightCorrectionTable[Class])
	else
		return Vector(0,0,0)
	end
end

function SWEP:DrawHUD()
end

function SWEP:TranslateFOV(current_fov)
	return current_fov
end

function SWEP:DrawWorldModel()
	//self.Weapon:DrawModel()
	
	local DeadFucker=self:GetDTEntity(0)
	
	local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
	pos=pos+ang:Forward()*17-ang:Up()*3+ang:Right()*1
	if((IsValid(DeadFucker))and not(string.find(self.Owner:GetModel(),"female")))then --what the fuck is up with this
		pos=pos-ang:Right()*2
	end
	self.NiceModel:SetRenderOrigin(pos)
	ang:RotateAroundAxis(ang:Up(),180)
	if((IsValid(DeadFucker))and not(string.find(self.Owner:GetModel(),"female")))then --what the fuck is up with this
		ang:RotateAroundAxis(ang:Up(),15)
	end
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Right(),-10)
	self.NiceModel:SetAngles(ang)
	self.NiceModel:SetModelScale(Vector(1.175,1,1))
	render.SetColorModulation(0.8,0.8,0.8)
	self.NiceModel:DrawModel()
	render.SetColorModulation(1,1,1)
	
	if(self:GetDTBool(0))then
		local pos,ang=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_L_Hand"))
		self.SpareMag:SetRenderOrigin(pos+ang:Forward()*3+ang:Right()*5-ang:Up()*0.75)
		self.SpareMag:SetAngles(ang)
		//self.SpareMag:SetModelScale(Vector(0.8,0.8,0.8))
		render.MaterialOverride(GunMat)
		self.SpareMag:DrawModel()
		render.MaterialOverride(nil)
	end
end

local function DrawLazahBeem()
	for key,found in pairs(ents.FindByClass("wep_jack_combine_amr"))do
		local DeadFucker=found:GetDTEntity(0)
		if(IsValid(DeadFucker))then
			local posang=found:GetAttachment(found:LookupAttachment("muzzle"))
			local Nupos=posang.Pos+posang.Ang:Right()*1.75+posang.Ang:Up()*4.25
			local DeadFuckerPos=DeadFucker:LocalToWorld(DeadFucker:OBBCenter())+found:HeightCorrection(DeadFucker)
			local Vec=(DeadFuckerPos-Nupos):GetNormalized()
			local ToTrace={}
			ToTrace.start=Nupos
			ToTrace.endpos=Nupos+Vec*99999
			ToTrace.filter=found.Owner
			ToTrace.mask=MASK_SHOT
			local To=util.TraceLine(ToTrace)
			if(To.Hit)then
				render.SetMaterial(lolmat)
				local Flicker=math.Rand(0.9,1.1)
				render.DrawBeam(Nupos,To.HitPos+To.HitNormal,2*Flicker,0,0,Color(0,175,255,100*Flicker))
				render.SetMaterial(derpmat)
				render.DrawSprite(To.HitPos+To.HitNormal,5*Flicker,5*Flicker,Color(100,200,255,175*Flicker))
			end
		end
	end
end
hook.Add("PostDrawTranslucentRenderables","JackySniperLaserDraw",DrawLazahBeem)

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	return nil
end
