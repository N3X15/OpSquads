
/*---------------------------------------------------------
   Name: SetupWeaponHoldTypeForAI
   Desc: Mainly a Todo.. In a seperate file to clean up the init.lua
---------------------------------------------------------*/
function SWEP:SetupWeaponHoldTypeForAI(t)
	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE_RIFLE
	self.ActivityTranslateAI [ ACT_IDLE_RELAXED ] 				= ACT_IDLE_SMG1_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_SMG1_STIMULATED
	self.ActivityTranslateAI [ ACT_IDLE_AGITATED ] 				= ACT_IDLE_SMG1_STIMULATED
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SMG1
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_AR2
	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_SMG1
	self.ActivityTranslateAI [ ACT_WALK_AIM ] 					= ACT_WALK_AIM_RIFLE
	self.ActivityTranslateAI [ ACT_RUN_AIM ] 					= ACT_RUN_AIM_RIFLE
	self.ActivityTranslateAI [ ACT_GESTURE_RANGE_ATTACK1 ] 		= ACT_GESTURE_RANGE_ATTACK_AR2
	self.ActivityTranslateAI [ ACT_RELOAD_LOW ] 				= ACT_RELOAD_SMG1_LOW
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK_AR2_LOW
	self.ActivityTranslateAI [ ACT_COVER_LOW ] 					= ACT_COVER_LOW
	self.ActivityTranslateAI [ ACT_RANGE_AIM_LOW ] 				= ACT_RANGE_AIM_LOW
	self.ActivityTranslateAI [ ACT_GESTURE_RELOAD ] 			= ACT_GESTURE_RELOAD_SMG1
	self.ActivityTranslateAI [ ACT_RUN ]                        = ACT_RUN_RIFLE
	self.ActivityTranslateAI [ ACT_RUN_RELAXED ]                = ACT_RUN_RIFLE_RELAXED
	self.ActivityTranslateAI [ ACT_RUN_AGITATED ]               = ACT_RUN_RIFLE_STIMULATED
	self.ActivityTranslateAI [ ACT_RUN_STIMULATED ]             = ACT_RUN_RIFLE_STIMULATED
	self.ActivityTranslateAI [ ACT_WALK ]                       = ACT_WALK_RIFLE
	self.ActivityTranslateAI [ ACT_WALK_AGITATED ]              = ACT_WALK_RIFLE_STIMULATED
	self.ActivityTranslateAI [ ACT_WALK_STIMULATED ]            = ACT_WALK_RIFLE_STIMULATED
	self.ActivityTranslateAI [ ACT_WALK_RELAXED ]               = ACT_WALK_RIFLE_RELAXED
end

