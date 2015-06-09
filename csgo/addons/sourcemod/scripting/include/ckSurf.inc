#if defined _CKSurf_included
 #endinput
#endif
#define _CKSurf_included

/* Natives */
native bool:ckSurf_GetTimerStatus(client); // check if timer enabled
native ckSurf_StopTimer(client); // stop timer
native ckSurf_StopUpdatingOfClimbersMenu(client); // stops refreshing of the timer panel/menu
native ckSurf_EmulateStartButtonPress(client); // stop button alternative (global records disabled)
native ckSurf_EmulateStopButtonPress(client); // start button alternative (global records disabled)
native Float:ckSurf_GetCurrentTime(client); //current run time
native ckSurf_setStage(client, stage);
native ckSurf_setBonus(client, bonus);
native ckSurf_Checkpoint(client, zone);

public SharedPlugin:__pl_ckSurf =
{
	name = "ckSurf",
	file = "ckSurf.smx",
	#if defined REQUIRE_PLUGIN
	required = 1,
	#else
	required = 0,
	#endif
};

public __pl_ckSurf_SetNTVOptional()
{
	MarkNativeAsOptional("ckSurf_GetTimerStatus");
	MarkNativeAsOptional("ckSurf_StopTimer");
	MarkNativeAsOptional("ckSurf_StopUpdatingOfClimbersMenu");
	MarkNativeAsOptional("ckSurf_EmulateStartButtonPress");	
	MarkNativeAsOptional("ckSurf_EmulateStopButtonPress");
	MarkNativeAsOptional("ckSurf_GetCurrentTime");
	MarkNativeAsOptional("ckSurf_setStage");
	MarkNativeAsOptional("ckSurf_setBonus");
	MarkNativeAsOptional("ckSurf_Checkpoint");
}