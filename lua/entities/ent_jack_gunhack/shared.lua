ENT.Type 			= "anim"
ENT.PrintName		= "Gunhack"
ENT.Author			= "Jackarunda"
ENT.Information     = "A Jackarunda Industries Mk.1 Mod 1 Viscerator. The Mod 1 variant has less armor \nand less speed/agility than the Mod 0 (see Manhacks). The Mod 1s have a small, lightweight, low-powered Combine pulse weapon mounted \nto their frame, complete with a Combine ammo source that must reload itself periodically. This Viscerator's blades are \ndesigned purely for stable flight and recoil control and are not suited for attacking targets with. The Mk.1 Mod 1 software also \ntries to keep the hacks at a safe distance while they bring down their target. This hack also lacks the bursting \ncharge that its melee-oriented cousins posses, and while it always aims for center mass, it tends to always be \nabove its targets and aren't 100% accurate, so incidental headshots aren't uncommon. Hold E while clicking to spawn as hostile."
ENT.Category		= "Enhanced Opposition Squad NPCs"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

if(CLIENT)then
	/*------------------------------------------------------------
		Jackarunda's epic win environment-lighting muzzleflashes
	------------------------------------------------------------*/
	function MuzzoFlash(data)
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
			dlight.r=190
			dlight.g=225
			dlight.b=255
			dlight.Brightness=1.5
			dlight.Size=200
			dlight.Decay=600
			dlight.DieTime=CurTime()+0.03
			dlight.Style=0
		end
	end
	usermessage.Hook("Jacky'sMuzzleFlashUserMessage",MuzzoFlash)
end