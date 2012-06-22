function JACK_SetupAmazingHunter(npc)
	local timername="AmazingHunter"..npc:EntIndex()
	timer.Create(timername,0.5,0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		local CurrentEnemy=npc:GetEnemy()
		if(IsValid(CurrentEnemy))then
			if not(table.HasValue(npc.SpottedEnemies,CurrentEnemy))then
				table.ForceInsert(npc.SpottedEnemies,CurrentEnemy)
			end
		end
		table.foreach(npc.SpottedEnemies,function(key,creature)
			if(IsValid(creature))then
				if not(creature:Health()>0)then
					table.remove(npc.SpottedEnemies,key)
				end
			else
				table.remove(npc.SpottedEnemies,key)
			end
		end)
		for key,target in pairs(ents.GetAll())do --amazing tracking abilities
			if((target:IsNPC())or(target:IsPlayer()))then
				if(table.HasValue(npc.SpottedEnemies,target))then
					if((target:Health()>0)and not(npc:GetEnemy()==target))then
						npc:UpdateEnemyMemory(target,target:GetPos())
					end
				end
			end
		end
		for key,found in pairs(ents.GetAll())do --fucking eagle eyes
			if((found:IsNPC())or(found:IsPlayer()))then
				if(npc:Disposition(found)==1)then
					if not(IsValid(npc:GetEnemy()))then
						local enemypos=found:GetPos()
						local LoSTraceData={}
						LoSTraceData.start=npc:GetPos()+Vector(0,0,10)
						LoSTraceData.endpos=enemypos+Vector(0,0,10)
						LoSTraceData.filter={found,npc}
						local LoSTrace=util.TraceLine(LoSTraceData)
						if not(LoSTrace.Hit)then
							if(found:Health()>0)then
								npc:UpdateEnemyMemory(found,enemypos)
							end
						end
					end
				end
			end
		end
	end)
end

function JACK_SetupIntelligentGunfighter(npc)
	local timername="OPSQUADIntelligentGunfighter"..npc:EntIndex()	--										
	timer.Create(timername,1,0,function()	        	--
		if not(IsValid(npc))then timer.Destroy(timername) return end
		if not(IsValid(npc:GetEnemy()))then return end
		local NumberOfCreeps=0
		for key,found in pairs(ents.FindInSphere(npc:GetPos(),100))do
			if((found:IsNPC())or(found:IsPlayer()))then
				if(npc:Disposition(found)==1)then
					NumberOfCreeps=NumberOfCreeps+1
				end
			end
		end
		if(NumberOfCreeps>0)then
			local selfpos=npc:GetPos()
			local newpos=selfpos+((selfpos-npc:GetEnemy():GetPos()):GetNormalized())*500
			local checkdat={}
			checkdat.start=selfpos
			checkdat.endpos=newpos
			checkdat.filter=npc
			local check=util.TraceLine(checkdat)
			if(check.Hit)then
				newpos=selfpos+VectorRand()*750
			end
			npc:SetLastPosition(newpos)
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end
	end)
end

function JACK_SetupAutomedic(npc)
	npc.NextHealTime=CurTime()
	local timername="AutoMedic"..npc:EntIndex()
	timer.Create(timername,0.75,0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		local Helth=npc:Health()
		local MexHalth=npc:GetMaxHealth()
		if(not(IsValid(npc:GetEnemy()))and(Helth<MexHalth))then
			if(npc.NextHealTime<CurTime())then
				npc:SetHealth(Helth+1)
				npc:EmitSound("lolsounds/cyborgheal.wav",60,100)
				npc:SetSequence(16)
			end
		else
			npc.NextHealTime=CurTime()+5
		end
	end)
end

function JACK_SetupRunthink(npc)
	local timername="RunThinkFunction"..npc:EntIndex() --why the fuck. Do I have to manually hook a SWEP's think function.
	timer.Create(timername,0.5,0,function()
		if not(IsValid(npc))then timer.Destroy(timername) return end
		if not(IsValid(npc:GetActiveWeapon()))then timer.Destroy(timername) return end
		npc:GetActiveWeapon():ExtraThink()
	end)
end