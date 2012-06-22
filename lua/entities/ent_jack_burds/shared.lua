ENT.Type 			= "anim"
ENT.PrintName		= "Pigeons"
ENT.Author			= "Jackarunda"
ENT.Information     = "A squad of 10 pigeons. They make great cannon fodder and/or target practice. Every NPC will drop what he's \ndoing in order to kill them because no one likes pigeons. Hold E to spawn the juggernaut pigeon."
ENT.Category		= "NPC Opposition Squads"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

//if(CLIENT)then
//	function MakeItSmaller()
//		for key,found in pairs(ents.GetAll())do
//			if(found.NeedsToBeMadeSmaller)then
//				found:SetModelScale(Vector(0.5,0.5,0.5))
//			end
//		end
//	end
//	hook.Add("Think","Jacky'sSmallerThings",MakeItSmaller)
//end