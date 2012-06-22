ENT.Type 			= "anim"
ENT.PrintName		= "Humans"
ENT.Author			= "Jackarunda"
ENT.Information     = "A ready-made opposition squad consisting of seventeen citizens, rebels and medics. These individuals are well-equipped \nwith a host of basic HL2 items and ammo. NOTE: The first few times this is spawned there will be lag while the \ngame precaches the models. Hold E to spawn with altered allegiances."
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