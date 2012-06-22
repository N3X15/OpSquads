AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)

	//if (!tr.Hit) then return end
	
	local Friendly=false
	if(ply:KeyDown(IN_USE))then
		Friendly=true
	end
	
	local selfpos = tr.HitPos + tr.HitNormal * 16

	local npc=ents.Create("npc_clawscanner")
	npc:SetPos(selfpos)
	npc:SetAngles(Angle(0,180,0))
	npc:Spawn();npc:SetKeyValue("SquadName","InstantCombineOpposition")
	npc.InAJackyCombineSquad=true
	npc.OPSQUADWillDropBattery=true
	
	JACK_SetupMinedropping(npc)
	
	npc:Activate()
	npc.HasAJackyAllegiance=true
	if(Friendly)then
		npc.JackyAllegiance="Human"
	else
		npc.JackyAllegiance="Combine"
	end
	npc:SetKeyValue("SquadName",npc.JackyAllegiance)
	local effectdata=EffectData()
	effectdata:SetEntity(npc)
	util.Effect("propspawn",effectdata)

	undo.Create("JackySynthScanner")
		undo.AddEntity(npc)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone Synth Scanner")
	undo.Finish()

end


function JACK_SetupMinedropping(npc)
	npc.HasMine=false																	--
	npc.MinesDropped=0																	--
	local timername="OPSQUADMineDroppinMotherFucker"..npc:EntIndex()                    --
	timer.Create(timername,5,0,function()	                                          	--
		if not(IsValid(npc))then timer.Destroy(timername) return end                    --
		if(npc.MinesDropped==50)then return end											--
		if not(IsValid(npc:GetTarget()))then return end                                 --
		if(npc.HasMine==false)then														--
			npc:Fire("equipmine","1",0)													--
			npc.HasMine=true															--
		elseif(npc.HasMine==true)then													--
			npc:Fire("deploymine","1",0)												--
			npc.HasMine=false															--
			npc.MinesDropped=npc.MinesDropped+1											--
		end																				--
	end)																				--
end