AISetup={}
AISetup.Version=1.2

AddCSLuaFile("autorun/sh_NpcAI.lua")
AddCSLuaFile("NPCAI/cl_Init.lua")

if(SERVER) then
	include("NPCAI/sv_Init.lua")
else
	include("NPCAI/cl_Init.lua")
end
