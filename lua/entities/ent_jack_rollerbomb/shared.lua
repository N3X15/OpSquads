ENT.Type 			= "anim"
ENT.PrintName		= "Roller Mine"
ENT.Author			= "Jackarunda"
ENT.Information     = "This is a Combine rollermine taken and modified by JI. It can detect and pursue at greater distances \nthan a standard rollermine, is friendly toward humans, and has its shock core replaced with a simple HE \nwarhead. It will attempt to approach enemies and detonate. It will not detonate if it can see friendlies \nwithin its blast radius and will emit a warning sound to try to clear the area. Hold E to spawn with \naltered allegiances."
ENT.Category		= "Enhanced Opposition Squad NPCs"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

if(CLIENT)then
	/*------------------------------------------------------------
		Jackarunda's epic win environment-lighting splodeflashes
	------------------------------------------------------------*/
	function SplodeFlash(data)
		local vector=data:ReadVector()
		local entity=data:ReadEntity()
		local index
		if(entity:IsNPC())then
			index=data:ReadEntity():EntIndex()
		else
			index=data:ReadEntity():EntIndex()+1
		end
		local dlight=DynamicLight(index)
		if(dlight)then
			dlight.Pos=vector
			dlight.r=255
			dlight.g=200
			dlight.b=175
			dlight.Brightness=5
			dlight.Size=2000
			dlight.Decay=5000
			dlight.DieTime=CurTime()+0.05
			dlight.Style=0
		end
	end
	usermessage.Hook("Jacky'sRollerSplosionFlashUserMessage",SplodeFlash)
end