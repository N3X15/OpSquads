AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	--We need to init physics properties even though this entity isn't physically simulated
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:DrawShadow( false )
	self.Entity:SetNoDraw(true)
	
	self.Entity:SetCollisionBounds( Vector( -20, -20, -10 ), Vector( 20, 20, 10 ) )
	self.Entity:PhysicsInitBox( Vector( -20, -20, -10 ), Vector( 20, 20, 10 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableCollisions( false )		
	end

	self.Entity:SetNotSolid( true )
	
	--remove this ent after awhile
	self.Entity:Fire("kill","",0.25)
	
	self.StartTime=CurTime()
	self.Pos=self:GetPos()

end

function ENT:Think()

	local bloodsdispatched=0
	while bloodsdispatched<20 do
		local tracedata = {}
		tracedata.start = self.Pos+Vector(0,0,20)
		tracedata.endpos = self.Pos+VectorRand()*200
		tracedata.filter = self
		local tr = util.TraceLine(tracedata)
		if(tr.Hit)then
			util.Decal("Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end
		bloodsdispatched=bloodsdispatched+1
	end
end



