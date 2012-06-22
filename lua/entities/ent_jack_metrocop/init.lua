AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local Friendly=false
	if(ply:KeyDown(IN_USE))then
		Friendly=true
	end
	
	local selfpos = tr.HitPos + tr.HitNormal * 16

	local npc=ents.Create("npc_metropolice")
	npc:SetPos(selfpos)
	npc:SetKeyValue("additionalequipment","weapon_pistol")
	npc:SetKeyValue("pistolstartsdrawn","false")
	npc:SetKeyValue("manhacks","2")
	npc.HasAJackyAllegiance=true
	if(Friendly)then
		npc.JackyAllegiance="Human"
	else
		npc.JackyAllegiance="Combine"
	end
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	npc:Spawn()
	npc:Fire("EnableManhackToss","1",0)
	npc:Activate()
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)
	
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)

	undo.Create("JackyMetrocop")
		undo.AddEntity(npc)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone Metropolice")
	undo.Finish()

end


