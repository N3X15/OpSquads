/*NPC AI MOD
BY: TB
File version 1.2 <- ill probably forget to change this so dont worry bout it*/

local NeedsWeaponTable={"npc_citizen","npc_alyx","npc_monk","npc_barney","npc_combine_s","npc_metropolice"}

local LongRangeWeaponTable={"wep_jack_rocketlauncher","weapon_rpg","weapon_annabelle"}

function AISetup.SetupSettings()
	if(!sql.TableExists("aisetup3")) then
		sql.Query("CREATE TABLE aisetup3(Active INTEGER NOT NULL, Reuse INTEGER NOT NULL, Turn INTEGER NOT NULL, Manh INTEGER NOT NULL, Grenades INTEGER NOT NULL, ManhA INTEGER NOT NULL, GrenadesA INTEGER NOT NULL, SquadsA INTEGER NOT NULL, Squads INTEGER NOT NULL, SquadsP INTEGER NOT NULL, SquadsJ INTEGER NOT NULL, SquadsF INTEGER NOT NULL, ChaseThink INTEGER NOT NULL);")
		sql.Query("INSERT INTO aisetup3(Active, Reuse, Turn, Manh, Grenades, ManhA, GrenadesA, SquadsA, Squads, SquadsP, SquadsJ, SquadsF, ChaseThink) VALUES(1, 1, 1, 0, 1, 1, 5, 5, 1, 1, 1500, 500, 0.3)")
	end
	return sql.QueryRow("SELECT * FROM aisetup3 LIMIT 1")
end

AISetup.Config = AISetup.SetupSettings()
function AISetup.ApplySettings(ply, cmd, args)
	if(!ply:IsAdmin()) then
		return
	end

	local Active = tonumber(ply:GetInfo("NPC2_ai_Active") or 1)
	local Reuse = tonumber(ply:GetInfo("NPC2_ai_Reuse") or 1)
	local Turn = tonumber(ply:GetInfo("NPC2_ai_Turn") or 1)
	local Manh = tonumber(ply:GetInfo("NPC2_ai_Manh") or 0)
	local Grenades = tonumber(ply:GetInfo("NPC2_ai_Grenades") or 1)
	local ManhA = tonumber(ply:GetInfo("NPC2_ai_ManhA") or 2)
	local GrenadesA = tonumber(ply:GetInfo("NPC2_ai_GrenadesA") or 5)
	local SquadsA = tonumber(ply:GetInfo("NPC2_ai_SquadsA") or 5)
	local Squads = tonumber(ply:GetInfo("NPC2_ai_Squads") or 1)
	local SquadsP = tonumber(ply:GetInfo("NPC2_ai_SquadsP") or 1)
	local SquadsJ = tonumber(ply:GetInfo("NPC2_ai_SquadsJ") or 1500)
	local SquadsF = tonumber(ply:GetInfo("NPC2_ai_SquadsF") or 500)
	local ChaseThink = tonumber(ply:GetInfo("NPC2_ai_ChaseThink") or 0.3)
	local zero=0
	sql.Query("UPDATE aisetup3 SET Active = "..Active..", Reuse = "..Reuse..", Turn = "..Turn..", Manh = "..Manh..", Grenades = "..Grenades..", ManhA = "..ManhA..", GrenadesA = "..GrenadesA..", SquadsA = "..SquadsA..", Squads = "..Squads..", SquadsP = "..SquadsP..", SquadsJ = "..SquadsJ..", SquadsF = "..SquadsF..", ChaseThink = "..ChaseThink)

	AISetup.Config = sql.QueryRow("SELECT * FROM aisetup3 LIMIT 1")
	
	
	print(ply:Nick().." Changed the AI Settings.")
end
concommand.Add("NPC2_ai_apply", AISetup.ApplySettings)

//my attempt at something faster then findinsphere
local everything={}
local amount=1

local Squads = {}
local SquadsA = 0

local donts={}
donts[0]="npc_cscanner"
donts[1]="npc_hunter"
donts[2]="npc_rollermine"
donts[3]="npc_antlion"
donts[4]="npc_antlionguard"
donts[5]="npc_antlion_worker"
donts[6]="npc_fastzombie_torso"
donts[7]="npc_headcrab_fast"
donts[8]="npc_fastzombie"
donts[9]="npc_headcrab"
donts[10]="npc_headcrab_black"
donts[11]="npc_poisonzombie"
donts[12]="npc_headcrab_poison"
donts[13]="npc_zombie"
donts[14]="npc_zombie_torso"
donts[15]="npc_zombine"
donts[16]="npc_manhack"

function OnEntityCreated2( spawned )

if spawned:IsNPC() && spawned:IsValid() then
if(tonumber(AISetup.Config["Manh"]) == 1) then
if spawned:GetClass()=="npc_metropolice" then
//spawned:SetKeyValue("manhacks" , tonumber(AISetup.Config["Manh"]))//gives the metro police manhacks
end
end

if(tonumber(AISetup.Config["Grenades"]) == 1) then
if spawned:GetClass()=="npc_combine_s" then
//spawned:SetKeyValue("NumGrenades" , tonumber(AISetup.Config["GrenadesA"]))    // gives the combine grenades and ar2 combine balls to shoot
end
end

spawned.wep=nil
spawned.distance=1500
spawned.division=500
spawned.Squad=nil
spawned.IsM=false
spawned.IsL=false
spawned.times=1
spawned.hits=0
spawned.blocked=false
spawned.cansquad=true
if spawned:GetClass()=="npc_fastzombie"||spawned:GetClass()=="npc_antlion" || spawned:GetClass()=="npc_antlion_worker" then
spawned.walkover=155
else
spawned.walkover=17
end
for h,l in pairs(donts) do
if spawned:GetClass()==l then
spawned.cansquad=false
end
end

if(tonumber(AISetup.Config["Reuse"]) == 1) then
local found=false
for i=0, amount do
if found==false then
local e=everything[i]
if e==nil||e:IsValid()==false then
everything[i]=spawned
found=true
end
if e!=nil && i==amount then
if e:IsValid() then
amount=amount+1
everything[amount]=spawned
found=true
end
end
end
end
else
amount=amount+1
everything[amount]=spawned
end
	end
end

function MoveToPosition(object, x, y, z, movement)
	if((table.HasValue(NeedsWeaponTable,object:GetClass()))and not(IsValid(object:GetActiveWeapon())))then return end
	if(IsValid(object:GetActiveWeapon()))then
		if(table.HasValue(LongRangeWeaponTable,object:GetActiveWeapon():GetClass()))then return end
		if(string.find(object:GetActiveWeapon():GetClass(),"wep_jack_combine_"))then return end
	end
	object:SetLastPosition( Vector(x, y, z))
	object:SetSchedule( movement )
end

function Move(v, enemy, finalpos)
//Gather where our npc should move in chunks of 500 or based on a number i gave them  
//They can only move in a distance of 500 or less at a time
local divx=math.abs(v:GetPos().x-enemy:GetPos().x)
local divy=math.abs(v:GetPos().y-enemy:GetPos().y)
local perc=v.division/finalpos
xstep=divx*perc
ystep=divy*perc          
local action=SCHED_FORCED_GO_RUN
//Make sure were in the right plane
local px=1
local py=1
if (enemy:GetPos().x-v:GetPos().x)<0 && xstep!=nil then
xstep=xstep*-1
px=px*-1
end
if (enemy:GetPos().y-v:GetPos().y)<0 && ystep!=nil then
ystep= ystep*-1
py=py*-1
end
if xstep!=nil && ystep!=nil then

//Set the Coordinate where the npc will be going
local cordx=v:GetPos().x+xstep
local cordy=v:GetPos().y+ystep
local tracedata = {}
tracedata.start = Vector(v:GetPos().x, v:GetPos().y, v:GetPos().z+v.walkover)
tracedata.endpos = Vector(cordx,cordy,v:GetPos().z+v.walkover)
tracedata.filter = v
tracedata.mins = v:OBBMins()
tracedata.maxs = v:OBBMaxs()
local trace = util.TraceHull(tracedata)
local search = trace.Entity
if search!=NULL || search:IsWorld() || v.blocked==true then
v.blocked=true
local move = v:OBBMaxs()*v.times
local right1 = v:GetRight().x*move
local right2 = v:GetRight().y*move
local left1 = v:GetRight().x*move*-1
local left2 = v:GetRight().y*move*-1
if v.blocked==true then
local tracedata2 = {}
tracedata2.start = Vector(v:GetPos().x+right1.x, v:GetPos().y+right2.y, v:GetPos().z+v.walkover)
tracedata2.endpos = Vector(enemy:GetPos().x, enemy:GetPos().y, v:GetPos().z+v.walkover)
tracedata2.filter = enemy
tracedata2.mins = v:OBBMins()
tracedata2.maxs = v:OBBMaxs()
local trace2 = util.TraceHull(tracedata2)
local search2 = trace2.Entity

local tracedata3 = {}
tracedata3.start = Vector(v:GetPos().x+left1.x, v:GetPos().y+left2.y , v:GetPos().z+v.walkover)
tracedata3.endpos = Vector(enemy:GetPos().x, enemy:GetPos().y, v:GetPos().z+v.walkover)
tracedata3.filter = enemy
tracedata3.mins = v:OBBMins()
tracedata3.maxs = v:OBBMaxs()
local trace3 = util.TraceHull(tracedata3)
local search3 = trace3.Entity

if search2==NULL then
MoveToPosition(v, v:GetPos().x+right1.x, v:GetPos().y+right2.y, v:GetPos().z, action)
v.blocked=false
v.times=1
return
end
if search3==NULL then
MoveToPosition(v, v:GetPos().x+left1.x, v:GetPos().y+left2.y, v:GetPos().z, action)
v.blocked=false
v.times=1
return
end
v.times=v.times+1
end
else
end

if v:GetClass()!="npc_manhack" &&   v:GetClass()!="npc_cscanner" then
if v.blocked==false then
MoveToPosition(v, cordx, cordy, v:GetPos().z, action)
end
else 
MoveToPosition(v, cordx, cordy, enemy:GetPos().z+5, action)
end

end
end

local function ClearLineOfSightBetween(EntOne,EntTwo)
	local tressdeta={}
	tressdeta.start=EntOne:GetPos()+Vector(0,0,10)
	tressdeta.endpos=EntTwo:GetPos()+Vector(0,0,10)
	tressdeta.filter={EntTwo,EntOne}
	local tress=util.TraceLine(tressdeta)
	if(tress.Hit)then
		return false
	else
		return true
	end
end

//wow these functions suck. Redone partially by Jackarunda 2012
function EntityTakeDamage2( ent, inflictor, attacker, amount )
	if((attacker:IsPlayer())and(ent:IsNPC())and not(inflictor:GetClass()=="ent_jack_injury"))then
		if not(ent.NumberOfJackyPlayerHits)then ent.NumberOfJackyPlayerHits=0 end
		ent.NumberOfJackyPlayerHits=ent.NumberOfJackyPlayerHits+1
		timer.Simple(30,function()
			if(IsValid(ent))then
				ent.NumberOfJackyPlayerHits=ent.NumberOfJackyPlayerHits-1
			end
		end)
		if(ent.NumberOfJackyPlayerHits>3)then
			if(ClearLineOfSightBetween(attacker,ent))then
				ent:AddEntityRelationship(attacker,D_HT,50)
				ent:UpdateEnemyMemory(attacker,attacker:GetPos())
				ent:SetEnemy(attacker)
			end
		end
	end
	if(ent:IsNPC())then
		if(ClearLineOfSightBetween(attacker,ent))then
			ent:UpdateEnemyMemory(attacker,attacker:GetPos())
		end
	end
	if(ent:IsPlayer())then
		timer.Simple(0.1,function()
			if((IsValid(ent))and(IsValid(attacker)))then
				if not(ent:Alive())then --after you kill him once, reset. No eternal grudges
					if(attacker.HasAJackyAllegiance)then
						if(attacker.JackyAllegiance=="Human")then
							attacker:AddEntityRelationship(ent,D_LI,50)
						end
					end
				end
			end
		end)
	end
end

function AISetup.AdminReloadPlayer(ply)
	if(!ply or !ply:IsValid()) then
		return
	end
	for k,v in pairs(AISetup.Config) do
		local stuff = k
		ply:ConCommand("NPC2_ai_"..stuff.." "..v.."\n")
	end
end

function AISetup.AdminReload()
	if(ply) then
		AISetup.AdminReloadPlayer(ply)
	else
		for k,v in pairs(player.GetAll()) do
			AISetup.AdminReloadPlayer(v)
		end
	end
end

function PlayerInitialSpawn2( ply )
amount=amount+1
everything[amount]=ply
AISetup.AdminReload(ply)

SquadsA =SquadsA +1
Squads[SquadsA]=ply
ply.Squad=Squads[SquadsA]
ply.IsL =true 
Squads[SquadsA].L=ply
ply.Squad=SquadsA
Squads[SquadsA].A=1
Squads[SquadsA].A2=1
Squads[SquadsA].M={}
Squads[SquadsA].M[Squads[SquadsA].A]=ply

end

function Removed(npc)
if(tonumber(AISetup.Config["Squads"]) == 1) then
if npc:IsNPC() then
if npc.Squad!=nil then
if not(Squads[npc.Squad].A2)then return end
Squads[npc.Squad].A2=Squads[npc.Squad].A2-1
end
if npc.IsL then
local found=false
for i,e in pairs(Squads[npc.Squad].M) do
if e:IsValid() then
if e!=npc then
if found==true then
Squads[e.Squad].A=Squads[e.Squad].A+1
Squads[e.Squad].A2=Squads[e.Squad].A2+1
Squads[e.Squad].M[Squads[e.Squad].A]=e
end
if found==false then
Squads[npc.Squad]=e
Squads[npc.Squad].L=e
Squads[e.Squad].A=1
Squads[e.Squad].A2=1
Squads[e.Squad].M={}
Squads[e.Squad].M[Squads[e.Squad].A]=e
e.IsL=true
e.IsM=false
found=true
end
end
end
end
end
end
end
end

local cooldown=0
function AddToSquad(activator, object)
if CurTime()>=cooldown then
if object:IsValid() && object:IsNPC() && activator:IsPlayer() then
if object.Squad==nil then
if(tonumber(AISetup.Config["SquadsP"]) == 1) && Squads[activator.Squad].A2<tonumber(AISetup.Config["SquadsA"]) && object:Disposition(activator)!=1 then
object.Squad=activator.Squad
Squads[activator.Squad].A=Squads[activator.Squad].A +1
Squads[activator.Squad].A2=Squads[activator.Squad].A2+1
object.IsM = true
Squads[activator.Squad].M[Squads[activator.Squad].A]=object
activator:ChatPrint("NPC has joined your squad.")
end
else
if Squads[object.Squad].L==activator then
object.Squad=nil
Squads[activator.Squad].A2=Squads[activator.Squad].A2-1
object.IsM = false
activator:ChatPrint("NPC has left your squad.")
end
end
end
cooldown=CurTime()+2
end
end

//hook.Add( "PlayerUse", "addtosquad123", AddToSquad )
hook.Add( "OnEntityCreated", "npcspawn123", OnEntityCreated2 )
hook.Add( "EntityTakeDamage", "npcdmg123", EntityTakeDamage2 )
hook.Add( "PlayerInitialSpawn", "addplayer123", PlayerInitialSpawn2 )
hook.Add( "EntityRemoved", "Removed123", Removed )

local nextthink=0
 hook.Add("Think","NPCAI",
function() 
if CurTime()>=nextthink then
if(tonumber(AISetup.Config["Active"]) == 1) then
for k, v in pairs(ents.FindByClass("npc_*")) do
if v:IsNPC()&& v:IsValid() && v:GetClass()!="npc_rollermine"  then //this script makes rollermines buggy this fixs it


local friend=0
local finalpos=0
local enemy
if(tonumber(AISetup.Config["Squads"]) == 1) then
if v.Squad==nil && v.cansquad==true then
for i,e in pairs(everything) do
if e:IsValid() then
if e:IsNPC()&&e!=v then
if  v:Disposition(e)!=1 then
friend=math.abs(v:GetPos().x-e:GetPos().x)+math.abs(v:GetPos().y-e:GetPos().y)+math.abs(v:GetPos().z-e:GetPos().z) 
if friend<=tonumber(AISetup.Config["SquadsJ"]) then
if e.Squad==nil && v.Squad==nil then
SquadsA =SquadsA +1
Squads[SquadsA]=v 
v.Squad=Squads[SquadsA]
v.IsL =true 
Squads[SquadsA].L=v
v.Squad=SquadsA
Squads[SquadsA].A=1
Squads[SquadsA].A2=1
Squads[SquadsA].M={}
Squads[SquadsA].M[Squads[SquadsA].A]=v
end

if e.IsL && v.Squad==nil && Squads[e.Squad].A2<tonumber(AISetup.Config["SquadsA"]) then
v.Squad=e.Squad
Squads[e.Squad].A=Squads[e.Squad].A +1
Squads[e.Squad].A2=Squads[e.Squad].A2+1
v.IsM = true
Squads[e.Squad].M[Squads[e.Squad].A]=v
finalpos=friend
end

end
end
end
end
end
end

if v.IsM==true then

if v.wep!="squad" then
v.wep="squad"
v.distance=tonumber(AISetup.Config["SquadsF"])
v.division=500
end
if Squads[v.Squad].L!=nil then
enemy = Squads[v.Squad].L
end
if enemy!=nil then
finalpos=math.abs(v:GetPos().x-enemy:GetPos().x)+math.abs(v:GetPos().y-enemy:GetPos().y)+math.abs(v:GetPos().z-enemy:GetPos().z) 
if finalpos >= v.distance then
Move(v, enemy, finalpos)
end
end

end
end

if v:GetEnemy()!=nil && !v.IsM then

if v.wep==nil && !v.IsM then
if v:GetActiveWeapon():IsValid() then
v.wep=v:GetActiveWeapon():GetClass()
	if v.wep=="weapon_crowbar" || v.wep=="weapon_stunstick" then //add npc melee weapons here for them to work
	v.distance=200
	v.division=200
	v.wep="melee"
	end
	
	if v.wep=="weapon_shotgun" then //add npc short range weapons here for them to work
	v.distance=400
	v.division=200
	end

if v.wep=="weapon_rpg" then //add npc long range weapons here for them to work
v.distance=1600
v.division=350
end

if v.wep=="wep_jack_rocketlauncher" then //add npc long range weapons here for them to work
v.distance=1000
v.division=350
end

if v.wep=="weapon_annabelle" then //add npc long range weapons here for them to work
v.distance=1600
v.division=350
end

end
	if !v:GetActiveWeapon():IsValid() then //NPC's without a weapon
		if v:IsValid() then
		if v:GetClass()=="npc_fastzombie"  then
		v.wep="melee"
		v.distance=450
		v.division=200
		else
		if v:GetClass()=="npc_antlion" then
		v.wep="melee"
		v.distance=600
		v.division=200
		else
		if v:GetClass()=="npc_hunter" then
		v.wep="hunter"
		v.distance=1200
		v.division=200
		else
if v:GetClass()=="npc_antlionguard" then
v.wep="melee"
v.distance=750
v.division=200
else
		if v:GetClass()=="npc_antlion_worker" then
		v.wep="hunter"
		v.distance=1200
		v.division=200
		else
		v.wep="melee"
		v.distance=200
		v.division=200
		end
		end 
		end
		end
		end
end
	end
end

local enemy2
enemy=v:GetEnemy()
local pos1=v:GetPos()  
local pos2=enemy:GetPos()  
local x=pos1.x-pos2.x
local y=pos1.y-pos2.y
local z=pos1.z-pos2.z 
//Distance From the enemy
finalpos=math.abs(x)+math.abs(y)+math.abs(z)
        
//Checks if they should change to a closer target within recognize range
for i,e in pairs(everything) do
	if e:IsValid() then
		if e:IsPlayer()&&!GetConVar( "ai_ignoreplayers" ):GetBool()||e:IsNPC() then	
	if e!=enemy && e!=v then

				if v:Disposition(e)==1 then
				enemy2=math.abs(v:GetPos().x-e:GetPos().x)+math.abs(v:GetPos().y-e:GetPos().y)+math.abs(v:GetPos().z-e:GetPos().z) 
					if enemy2<finalpos then
					enemy=e
					finalpos=enemy2
					end
				end
			end
		end
	end
end

//If their enemy is outside there recognize range follow them
if finalpos >= v.distance then
Move(v, enemy, finalpos)
end


end
end
end
end
nextthink=CurTime()+tonumber(AISetup.Config["ChaseThink"])
end
end)
Msg("NPCAI mod has been started\n")
