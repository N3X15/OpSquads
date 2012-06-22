
/*---------------------------------------------------------
   Name: SetupWeaponHoldTypeForAI
   Desc: Mainly a Todo.. In a seperate file to clean up the init.lua
---------------------------------------------------------*/
function SWEP:SetupWeaponHoldTypeForAI(t)
	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE_RPG
	self.ActivityTranslateAI [ ACT_IDLE_RELAXED ] 				= ACT_IDLE_RPG_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_RPG_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_AGITATED ] 				= ACT_IDLE_RPG_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_RPG
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_RPG
	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_GESTURE_RELOAD
	self.ActivityTranslateAI [ ACT_WALK_AIM ] 					= ACT_WALK_RPG
	self.ActivityTranslateAI [ ACT_RUN_AIM ] 					= ACT_RUN_RPG
	self.ActivityTranslateAI [ ACT_GESTURE_RANGE_ATTACK1 ] 		= ACT_GESTURE_RANGE_ATTACK1
	self.ActivityTranslateAI [ ACT_RELOAD_LOW ] 				= ACT_RELOAD_LOW
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK1_LOW
	self.ActivityTranslateAI [ ACT_COVER_LOW ] 					= ACT_COVER_LOW_RPG
	self.ActivityTranslateAI [ ACT_RANGE_AIM_LOW ] 				= ACT_RANGE_AIM_LOW
	self.ActivityTranslateAI [ ACT_GESTURE_RELOAD ] 			= ACT_GESTURE_RELOAD
end

