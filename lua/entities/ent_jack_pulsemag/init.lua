AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	// Use the helibomb model just for the shadow (because it's about the same size)
	if(self:GetDTBool(0))then
		self.Entity:SetModel("models/Items/combine_rifle_cartridge01.mdl")
	else
		self.Entity:SetModel("models/hunter/plates/plate025.mdl")
	end
	if(self:GetDTBool(1))then
		self.Entity:SetModel("models/Items/AR2_Grenade.mdl")
	end
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(true)
	
	self.Entity:SetUseType(SIMPLE_USE)
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(1)
	end
	
	SafeRemoveEntityDelayed(self.Entity,20)

end


/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide(data, physobj)
	
	// Play sound on bounce
	if (data.Speed > 2 and data.DeltaTime > 0.1) then
		local loudness=data.Speed*0.4
		if(loudness>70)then loudness=70 end
		//self.Entity:EmitSound("lolsounds/spoonbounce.wav",loudness,100+math.random(-20,20))
	end
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage(dmginfo)

	// React physically when shot/getting blown
	self.Entity:TakePhysicsDamage(dmginfo)
end