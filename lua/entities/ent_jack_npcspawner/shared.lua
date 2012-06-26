
ENT.Type 			= "anim"
ENT.PrintName		= "NPC Spawner"
ENT.Author			= "Jackarunda"
ENT.Category			= "Enhanced Opposition Squad NPCs"
ENT.Information         = "This is a magical NPC spawner that you control with chat. It can spawn all the baseline HL2 NPCs at any rate and in any radius. \nType 'npc_spawner_help' in the console to get instructions on how to use it."

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

EnPeeSeeTable={
	"Downtrodden",
	"EliteCP",
	"EliteGrenadier",
	"EliteRifleman",
	"Gunhack",
	"Rebel",
	"RebelMedic",
	"SuperSoldier",
	"npc_alyx",
	"npc_antlion",
	"npc_antlionguard",
	"npc_antlion_grub",
	"npc_antlion_worker",
	"npc_barnacle",
	"npc_barney",
	"npc_breen",
	"npc_citizen",
	"npc_clawscanner",
	"npc_combinedropship",
	"npc_combinegunship",
	"npc_combine_s",
	"npc_crow",
	"npc_cscanner",
	"npc_dog",
	"npc_eli",
	"npc_fastzombie",
	"npc_fastzombie_torso",
	"npc_gman",
	"npc_headcrab",
	"npc_headcrab_black",
	"npc_headcrab_fast",
	"npc_headcrab_poison",
	"npc_helicopter",
	"npc_hunter",
	"npc_hunter",
	"npc_kleiner",
	"npc_magnusson",
	"npc_manhack",
	"npc_metropolice",
	"npc_monk",
	"npc_mossman",
	"npc_pigeon",
	"npc_poisonzombie",
	"npc_rollermine",
	"npc_seagull",
	"npc_turret_ceiling",
	"npc_turret_floor",
	"npc_turret_ground",
	"npc_vortigaunt",
	"npc_zombie",
	"npc_zombie_torso",
	"npc_zombine",
}

NPCAliases={
	-- ["alias"]={"npc_class",spawnflags,citizentype,model,spawnmethod} 
	-- spawnmethod(selfpos)=npc
	["Rebel"]			={"npc_citizen",	SF_CITIZEN_RANDOM_HEAD,	CT_REBEL,	false, false},
	["RebelMedic"]		={"npc_citizen",	SF_CITIZEN_MEDIC,		CT_REBEL,	false, false},
	["Downtrodden"]		={"npc_citizen",	false,					CT_REFUGEE,	false, false},
	
	["Gunhack"]			={"npc_manhack",	false,					false,		false, JACK_Spawn_Gunhack},
	
	["EliteCP"]			={"npc_metropolice",false,					false,		false, JACK_Spawn_EliteMetrocop},
	["EliteGrenadier"]	={"npc_combine_s",	false,					false,		false, JACK_Spawn_EliteGrenadier},
	["EliteRifleman"]	={"npc_combine_s",	false,					false,		false, JACK_Spawn_EliteRifleman},
	
	["SuperSoldier"]	={"npc_combine_s",	false,					false,		"models/Combine_Super_Soldier.mdl",	false}
}
NeedsWeaponTable={
	"npc_combine_s",
	"npc_citizen",
	"npc_barney",
	"npc_alyx",
	"npc_metropolice"
}
WeaponTable={
	"Shotgun",
	"Pistol",
	"Crowbar",
	"SMG",
	"AR2",
	"Stunstick",
	"RPG",
	"Lever_Action_Rifle",
	"Combine_Designated_Marksman_Rifle",
	"Combine_Anti_Materiel_Rifle",
	"Combine_UltraCompact_Shotgun",
	"Combine_Assault_Rifle",
	"Combine_Submachinegun",
	"Combine_Combat_Rifle",
	"Combine_Assault_Carbine",
	"Combine_UltraCompact_Submachinegun",
	"Combine_Battle_Rifle",
	"Combine_Sniping_Rifle",
	"Combine_Medium_Machine_Gun",
	"Combine_Light_Machine_Gun",
	"Combine_Machine_Pistol",
	"Combine_Combat_Pistol",
	"Combine_Heavy_Pistol",
	"Combine_Combat_Shotgun",
	"Combine_Personal_Defense_Weapon"
}
RealWeaponNameTable={
	["Shotgun"]="weapon_shotgun",
	["Pistol"]="weapon_pistol",
	["Crowbar"]="weapon_crowbar",
	["SMG"]="weapon_smg1",
	["AR2"]="weapon_ar2",
	["Stunstick"]="weapon_stunstick",
	["RPG"]="wep_jack_rocketlauncher",
	["Lever_Action_Rifle"]="weapon_annabelle",
	["Combine_Designated_Marksman_Rifle"]="wep_jack_combine_dmr",
	["Combine_Anti_Materiel_Rifle"]="wep_jack_combine_amr",
	["Combine_UltraCompact_Shotgun"]="wep_jack_combine_ucsg",
	["Combine_Assault_Rifle"]="wep_jack_combine_ar",
	["Combine_Submachinegun"]="wep_jack_combine_smg",
	["Combine_Combat_Rifle"]="wep_jack_combine_cr",
	["Combine_Assault_Carbine"]="wep_jack_combine_ac",
	["Combine_UltraCompact_Submachinegun"]="wep_jack_combine_ucsmg",
	["Combine_Battle_Rifle"]="wep_jack_combine_br",
	["Combine_Sniping_Rifle"]="wep_jack_combine_sr",
	["Combine_Medium_Machine_Gun"]="wep_jack_combine_mmg",
	["Combine_Light_Machine_Gun"]="wep_jack_combine_lmg",
	["Combine_Machine_Pistol"]="wep_jack_combine_mp",
	["Combine_Combat_Pistol"]="wep_jack_combine_cp",
	["Combine_Heavy_Pistol"]="wep_jack_combine_hp",
	["Combine_Combat_Shotgun"]="wep_jack_combine_csg",
	["Combine_Personal_Defense_Weapon"]="wep_jack_combine_pdw"
}