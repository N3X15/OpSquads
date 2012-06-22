include('shared.lua')

//killicon.Add("ent_jack_rocket","HUD/killicons/weapon_rpg",Color(255,80,0,255))

function ENT:Initialize()
end

function ENT:Draw()
	self.Entity:DrawModel()
end