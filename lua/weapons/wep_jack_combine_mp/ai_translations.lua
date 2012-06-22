
/*---------------------------------------------------------
   Name: SetupWeaponHoldTypeForAI
   Desc: Mainly a Todo.. In a seperate file to clean up the init.lua
---------------------------------------------------------*/
function SWEP:SetupWeaponHoldTypeForAI(t)
	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE_PISTOL
	self.ActivityTranslateAI [ ACT_IDLE_RELAXED ] 				= ACT_IDLE_RELAXED
	self.ActivityTranslateAI [ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_STIMULATED
	self.ActivityTranslateAI [ ACT_IDLE_AGITATED ] 				= ACT_IDLE_STIMULATED
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_PISTOL
	self.ActivityTranslateAI [ ACT_WALK_AIM ] 					= ACT_WALK_AIM_PISTOL
	self.ActivityTranslateAI [ ACT_RUN_AIM ] 					= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI [ ACT_GESTURE_RANGE_ATTACK1 ] 		= ACT_GESTURE_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI [ ACT_RELOAD_LOW ] 				= ACT_RELOAD_PISTOL_LOW
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK_PISTOL_LOW
	self.ActivityTranslateAI [ ACT_COVER_LOW ] 					= ACT_COVER_PISTOL_LOW
	self.ActivityTranslateAI [ ACT_RANGE_AIM_LOW ] 				= ACT_RANGE_AIM_PISTOL_LOW
	self.ActivityTranslateAI [ ACT_GESTURE_RELOAD ] 			= ACT_GESTURE_RELOAD_PISTOL
	self.ActivityTranslateAI [ ACT_RUN ]                        = ACT_RUN_PISTOL
	self.ActivityTranslateAI [ ACT_RUN_RELAXED ]                = ACT_RUN_RELAXED
	self.ActivityTranslateAI [ ACT_RUN_AGITATED ]               = ACT_RUN_STIMULATED
	self.ActivityTranslateAI [ ACT_RUN_STIMULATED ]             = ACT_RUN_STIMULATED
	self.ActivityTranslateAI [ ACT_WALK ]                       = ACT_WALK_PISTOL
	self.ActivityTranslateAI [ ACT_WALK_AGITATED ]              = ACT_WALK_STIMULATED
	self.ActivityTranslateAI [ ACT_WALK_STIMULATED ]            = ACT_WALK_STIMULATED
	self.ActivityTranslateAI [ ACT_WALK_RELAXED ]               = ACT_WALK_RELAXED
end

