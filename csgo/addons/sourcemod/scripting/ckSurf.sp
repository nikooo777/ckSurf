#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <adminmenu>
#include <cstrike>
#include <button>
#include <entity>
#include <setname>
#include <smlib>
#include <geoip>
#include <basecomm>
#include <colors>
#undef REQUIRE_EXTENSIONS
#include <clientprefs>
#undef REQUIRE_PLUGIN
#include <dhooks>
#include <sourcebans>
#include <calladmin>
#include <hgr>
#include <mapchooser>
#include <ckSurf>

#define VERSION "1.17"
#define PLUGIN_VERSION 117
#define ADMIN_LEVEL ADMFLAG_UNBAN
#define ADMIN_LEVEL2 ADMFLAG_ROOT
#define MYSQL 0
#define SQLITE 1
#define WHITE 0x01
#define DARKRED 0x02
#define PURPLE 0x03
#define GREEN 0x04
#define MOSSGREEN 0x05
#define LIMEGREEN 0x06
#define RED 0x07
#define GRAY 0x08
#define YELLOW 0x09
#define DARKGREY 0x0A
#define BLUE 0x0B
#define DARKBLUE 0x0C
#define LIGHTBLUE 0x0D
#define PINK 0x0E
#define LIGHTRED 0x0F
#define QUOTE 0x22
#define PERCENT 0x25
#define CPLIMIT 50 
#define MAX_PR_PLAYERS 20000
#define HIDE_RADAR (1 << 12)
#define HIDE_CHAT ( 1<<7 )
#define CK_BUTTON_DONTMOVE (1<<0)		
#define CK_BUTTON_TOUCH_ACTIVATES (1<<8)	
#define CK_DOOR_PTOUCH (1<<10)		
#define BM_MAGIC 0xBAADF00D
#define BINARY_FORMAT_VERSION 0x01
#define ADDITIONAL_FIELD_TELEPORTED_ORIGIN (1<<0)
#define ADDITIONAL_FIELD_TELEPORTED_ANGLES (1<<1)
#define ADDITIONAL_FIELD_TELEPORTED_VELOCITY (1<<2)
#define FRAME_INFO_SIZE 15
#define FRAME_INFO_SIZE_V1 14
#define AT_SIZE 10
#define ORIGIN_SNAPSHOT_INTERVAL 150
#define FILE_HEADER_LENGTH 74

enum FrameInfo 
{
	playerButtons = 0,
	playerImpulse,
	Float:actualVelocity[3],
	Float:predictedVelocity[3],
	Float:predictedAngles[2], 
	CSWeaponID:newWeapon,
	playerSubtype,
	playerSeed,
	additionalFields, 
	pause, 
}

enum AdditionalTeleport 
{
	Float:atOrigin[3],
	Float:atAngles[3],
	Float:atVelocity[3],
	atFlags
}

enum FileHeader 
{
	FH_binaryFormatVersion = 0,
	String:FH_Time[32],
	String:FH_Playername[32],
	FH_Checkpoints,
	FH_tickCount,
	Float:FH_initialPosition[3],
	Float:FH_initialAngles[3],
	Handle:FH_frames
}

enum VelocityOverride
{
	VelocityOvr_None = 0,
	VelocityOvr_Velocity,
	VelocityOvr_OnlyWhenNegative,
	VelocityOvr_InvertReuseVelocity
}

enum EJoinTeamReason
{
	k_OneTeamChange=0,
	k_TeamsFull=1,
	k_TTeamFull=2,
	k_CTTeamFull=3
}

enum MapZone
{
    zoneId,			// ID within the map
    zoneType,		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
    zoneTypeId,		// ID of the same type eg. Start-1, Start-2, Start-3...
	Float:PointA[3],
    Float:PointB[3],
	String:ZoneName[64],
	Vis,
	Team,
}

new String:g_szRecordString[MAXPLAYERS+1][32];

///////////////////
//Stage Variables//
///////////////////
new String:pAika[MAXPLAYERS+1][128];
new String:obsAika[128];
new String:g_szCurrentStage[MAXPLAYERS+1][12];
new String:g_szTotalStages[12];
new String:g_StageString[MAXPLAYERS+1][24];
new Float:obsTimer;
new g_Stage[MAXPLAYERS+1];
new tmpStage[MAXPLAYERS+1];


/////////////////////////
//// Spawn Locations ////
/////////////////////////
new Float:g_fSpawnLocation[3];
new Float:g_fSpawnAngle[3];

new bool:g_bGotSpawnLocation;


///////////////////
//Bonus Variables//
///////////////////
new bool:g_bBonusTimer[MAXPLAYERS+1];				// True if client is using the bonus timer
new bool:g_bTmpBonusTimer[MAXPLAYERS+1];
new String:szBonusFastest[MAX_NAME_LENGTH];			// Name of the #1 in the current maps bonus
new String:szBonusFastestTime[54];					// Fastest bonus time in 00:00:00:00 format
new Float:g_fPersonalRecordBonus[MAXPLAYERS+1]; 	// Clients personal bonus record in the current map
new String:g_szPersonalRecordBonus[MAXPLAYERS+1][32];
new Float:g_fBonusFastest;							// Fastest bonus time in the current mpa
new Float:g_fOldBonusRecordTime;					// Old record time, for prints + counting
new g_MapRankBonus[MAXPLAYERS+1]; 					// Clients personal bonus rank in the current map
new g_bMissedBonusBest[MAXPLAYERS+1];				// Has the client missed his best bonus time
new g_tmpBonusCount;
new g_iBonusCount;							 		// Amount of players that have passed the bonus in current map
new g_totalBonusCount;								// How many total bonuses there are

////////////////////////
//Checkpoint Variables//
////////////////////////
new Float:g_fCheckpointTimesRecord[MAXPLAYERS+1][20];	// Clients best run's times
new Float:g_fCheckpointTimesNew[MAXPLAYERS+1][20];		// Clients current runs times
new Float:g_fCheckpointServerRecord[20];
new Float:tmpDiff[MAXPLAYERS+1];
new lastCheckpoint[MAXPLAYERS+1];
new bool:g_bCheckpointsEnabled[MAXPLAYERS+1];
new bool:g_borg_CheckpointsEnabled[MAXPLAYERS+1];
new bool:g_bCheckpointsFound[MAXPLAYERS+1];
new bool:g_bActivateCheckpointsOnStart[MAXPLAYERS+1];
new bool:g_bCheckpointRecordFound;


///////////////////
//Advert Variable//
///////////////////
new g_Advert;										// Defines which advert to play

/////////////////////
//MapTier Bariables//
/////////////////////
new String:g_sTierString[258];
new bool:g_bTierFound;
new Handle:AnnounceTimer[MAXPLAYERS+1];

//////////////////
//Zone Variables//
//////////////////
new Handle:g_hZoneDisplayType = INVALID_HANDLE;
new g_zoneDisplayType;
new Handle:g_hZonesToDisplay = INVALID_HANDLE;
new g_zonesToDisplay;
new Handle:g_hChecker;
new Float:g_fChecker;

new Handle:g_hZoneTimer = INVALID_HANDLE;
new bool:g_bEditZoneType[MAXPLAYERS+1];
new String:g_CurrentZoneName[MAXPLAYERS+1][64];
new Float:g_Positions[MAXPLAYERS+1][2][3];
new Float:g_AvaliableScales[5]={1.0, 5.0, 10.0, 50.0, 100.0};
new beamColorT[] = {255, 0, 0, 255};
new beamColorCT[] = {0, 0, 255, 255};
new beamColorN[] = {255, 255, 0, 255};
new beamColorM[] = {0, 255, 0, 255};

new g_zoneStartColor[4];
new Handle:g_hzoneStartColor = INVALID_HANDLE;
new String:g_szzoneStartColor[24];

new g_zoneEndColor[4];
new Handle:g_hzoneEndColor = INVALID_HANDLE;
new String:g_szzoneEndColor[24];

new g_zoneBonusStartColor[4];
new Handle:g_hzoneBonusStartColor = INVALID_HANDLE;
new String:g_szzoneBonusStartColor[24];


new g_zoneBonusEndColor[4];
new Handle:g_hzoneBonusEndColor = INVALID_HANDLE;
new String:g_szzoneBonusEndColor[24];


new g_zoneStageColor[4];
new Handle:g_hzoneStageColor = INVALID_HANDLE;
new String:g_szzoneStageColor[24];


new g_zoneCheckpointColor[4];
new Handle:g_hzoneCheckpointColor = INVALID_HANDLE;
new String:g_szzoneCheckpointColor[24];


new g_zoneSpeedColor[4];
new Handle:g_hzoneSpeedColor = INVALID_HANDLE;
new String:g_szzoneSpeedColor[24];


new g_zoneTeleToStartColor[4];
new Handle:g_hzoneTeleToStartColor = INVALID_HANDLE;
new String:g_szzoneTeleToStartColor[24];


new g_zoneValidatorColor[4];
new Handle:g_hzoneValidatorColor = INVALID_HANDLE;
new String:g_szzoneValidatorColor[24];


new g_zoneCheckerColor[4];
new Handle:g_hzoneCheckerColor = INVALID_HANDLE;
new String:g_szzoneCheckerColor[24];


new g_zoneStopColor[4];
new Handle:g_hzoneStopColor = INVALID_HANDLE;
new String:g_szzoneStopColor[24];



new g_CurrentZoneTeam[MAXPLAYERS+1];
new g_CurrentZoneVis[MAXPLAYERS+1];
new g_CurrentZoneType[MAXPLAYERS+1];
new g_Editing[MAXPLAYERS+1]={0,...};
new g_ClientSelectedZone[MAXPLAYERS+1]={-1,...};
new g_BeamSprite;
new g_HaloSprite;
new g_mapZonesTypeCount[11];
new g_mapZones[128][MapZone];
new g_mapZonesCount = 0;
new g_ClientSelectedScale[MAXPLAYERS+1];
new g_ClientSelectedPoint[MAXPLAYERS+1];
new g_CurrentZoneTypeId[MAXPLAYERS+1];

// Insert Commands
new g_zoneQueryNumber;
new g_totalZoneQueries;
new g_succesfullZoneQueries;
new g_tierQueryNumber;
new g_succesfullTierQueries;
new g_totalTierQueries;

new g_totalRenames;

//////////////////////
// ckSurf Variables//
//////////////////////

new Float:g_fLastChatMessage[MAXPLAYERS+1];
new Float:g_flastClientUsp[MAXPLAYERS+1];
new bool:g_insertingInformation;
new bool:g_bValidRun[MAXPLAYERS+1];
new bool:g_bNewRecordBot;
new bool:g_bNewBonusBot;
new bool:g_bHideChat[MAXPLAYERS+1];
new bool:g_borg_HideChat[MAXPLAYERS+1];
new bool:g_bViewModel[MAXPLAYERS+1];
new bool:g_borg_ViewModel[MAXPLAYERS+1];
new g_DbType;
new Float:g_fMaxPercCompleted[MAXPLAYERS+1];
new Handle:g_hTeleport = INVALID_HANDLE;
new Handle:g_hMainMenu = INVALID_HANDLE;
new Handle:g_hAdminMenu = INVALID_HANDLE;
new Handle:g_MapList = INVALID_HANDLE;
new Handle:g_hDb = INVALID_HANDLE;
new Handle:g_hLangMenu = INVALID_HANDLE;
new Handle:g_hCookie = INVALID_HANDLE;
new Handle:g_OnLangChanged = INVALID_HANDLE;
new Handle:g_hRecording[MAXPLAYERS+1];
new Handle:g_hLoadedRecordsAdditionalTeleport = INVALID_HANDLE;
new Handle:g_hBotMimicsRecord[MAXPLAYERS+1] = {INVALID_HANDLE,...};
new Handle:g_hP2PRed[MAXPLAYERS+1] = { INVALID_HANDLE,... };
new Handle:g_hP2PGreen[MAXPLAYERS+1] = { INVALID_HANDLE,... };
new Handle:g_hRecordingAdditionalTeleport[MAXPLAYERS+1];
new Handle:g_hclimbersmenu[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hTopJumpersMenu[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:g_hWelcomeMsg = INVALID_HANDLE;
new String:g_sWelcomeMsg[512];  
new Handle:g_hReplayBotPlayerModel = INVALID_HANDLE;
new String:g_sReplayBotPlayerModel[256];  
new Handle:g_hReplayBotArmModel = INVALID_HANDLE;
new String:g_sReplayBotArmModel[256];  
new String:g_sReplayBotPlayerModel2[256];  
new String:g_sReplayBotArmModel2[256];  
new Handle:g_hPlayerModel = INVALID_HANDLE;
new String:g_sPlayerModel[256];  
new Handle:g_hArmModel = INVALID_HANDLE;
new String:g_sArmModel[256];  
new Handle:g_hcvarRestore = INVALID_HANDLE;
new bool:g_bRestore;
new Handle:g_hNoClipS = INVALID_HANDLE;
new bool:g_bNoClipS;
new Handle:g_hReplayBot = INVALID_HANDLE;
new bool:g_bReplayBot;
new Handle:g_hBonusBot = INVALID_HANDLE;
new bool:g_bBonusBot;
new Handle:g_hColoredNames = INVALID_HANDLE;
new bool:g_bColoredNames;
new Handle:g_hPauseServerside = INVALID_HANDLE;
new bool:g_bPauseServerside;
new Handle:g_hChallengePoints = INVALID_HANDLE;
new bool:g_bChallengePoints;
new Handle:g_hAutoBhopConVar = INVALID_HANDLE;
new bool:g_bAutoBhopConVar;
new bool:g_bAutoBhop;
new Handle:g_hVipClantag = INVALID_HANDLE;
new bool:g_bVipClantag;
new Handle:g_hDynamicTimelimit = INVALID_HANDLE;
new bool:g_bDynamicTimelimit;
new Handle:g_hAdminClantag = INVALID_HANDLE;
new bool:g_bAdminClantag;
new Handle:g_hConnectMsg = INVALID_HANDLE;
new bool:g_bConnectMsg;
new Handle:g_hDisconnectMsg = INVALID_HANDLE;
new bool:g_bDisconnectMsg;
new Handle:g_hRadioCommands = INVALID_HANDLE;
new bool:g_bRadioCommands;
new Handle:g_hInfoBot = INVALID_HANDLE;
new bool:g_bInfoBot;
new Handle:g_hAttackSpamProtection = INVALID_HANDLE;
new bool:g_bAttackSpamProtection;
new Handle:g_hGoToServer = INVALID_HANDLE;
new bool:g_bGoToServer;
new Handle:g_hPlayerSkinChange = INVALID_HANDLE;
new bool:g_bPlayerSkinChange;
new Handle:g_hCountry = INVALID_HANDLE;
new bool:g_bCountry;
new Handle:g_hAutoRespawn = INVALID_HANDLE;
new bool:g_bAutoRespawn;
new Handle:g_hcvarNoBlock = INVALID_HANDLE;
new bool:g_bNoBlock;
new Handle:g_hPointSystem = INVALID_HANDLE;
new bool:g_bPointSystem;
new Handle:g_hCleanWeapons = INVALID_HANDLE;
new bool:g_bCleanWeapons;
new Handle:g_hcvargodmode = INVALID_HANDLE;
new bool:g_bAutoTimer;
new Handle:g_hAutoTimer = INVALID_HANDLE;
new bool:g_bgodmode;
new Handle:g_hMapEnd = INVALID_HANDLE;
new bool:g_bMapEnd;
new Handle:g_hAutohealing_Hp = INVALID_HANDLE;
new g_Autohealing_Hp;
new Handle:g_hExtraPoints = INVALID_HANDLE;
new g_ExtraPoints;
new Handle:g_hExtraPoints2 = INVALID_HANDLE;
new g_ExtraPoints2;
new Handle:g_hReplayBotColor = INVALID_HANDLE;
new Handle:g_hBonusBotColor = INVALID_HANDLE;
new Handle:g_hAllowRoundEndCvar = INVALID_HANDLE;
new bool:g_bAllowRoundEndCvar;
new Float:g_fMapStartTime;
new Float:g_fvMeasurePos[MAXPLAYERS+1][2][3];
new Float:g_fStartTime[MAXPLAYERS+1];
new Float:g_fFinalTime[MAXPLAYERS+1];
new Float:g_fPauseTime[MAXPLAYERS+1];
new Float:g_fLastTimeNoClipUsed[MAXPLAYERS+1];
new Float:g_fLastOverlay[MAXPLAYERS+1];
new Float:g_fStartPauseTime[MAXPLAYERS+1];
new Float:g_fPlayerCordsLastPosition[MAXPLAYERS+1][3];
new Float:g_fPlayerLastTime[MAXPLAYERS+1];
new Float:g_fPlayerAnglesLastPosition[MAXPLAYERS+1][3];
new Float:g_fPlayerCordsRestart[MAXPLAYERS+1][3]; 
new Float:g_fPlayerAnglesRestart[MAXPLAYERS+1][3]; 
new Float:g_fPlayerCordsRestore[MAXPLAYERS+1][3];
new Float:g_fPlayerAnglesRestore[MAXPLAYERS+1][3];
new Float:g_fPersonalRecord[MAXPLAYERS+1];
new String:g_szPersonalRecord[MAXPLAYERS+1][32];
new Float:g_fCurrentRunTime[MAXPLAYERS+1];
new Float:g_fLastTimeButtonSound[MAXPLAYERS+1];
new Float:g_fPlayerConnectedTime[MAXPLAYERS+1];
new Float:g_fStartCommandUsed_LastTime[MAXPLAYERS+1];
new Float:g_fProfileMenuLastQuery[MAXPLAYERS+1];
new Float:g_favg_maptime;
new Float:g_fAvg_BonusTime;
new Float:g_fSpawnpointOrigin[3];
new Float:g_fSpawnpointAngle[3];
new Float:g_fLastSpeed[MAXPLAYERS+1];
new Float:g_fInitialPosition[MAXPLAYERS+1][3];
new Float:g_fInitialAngles[MAXPLAYERS+1][3];
new Float:g_fChallenge_RequestTime[MAXPLAYERS+1];
new Float:g_fSpawnPosition[MAXPLAYERS+1][3]; 
new Float:g_fLastPosition[MAXPLAYERS + 1][3];
new Float:g_fLastAngles[MAXPLAYERS + 1][3];
new Float:g_fRecordMapTime;
new Float:g_fStartButtonPos[3];
new Float:g_fEndButtonPos[3];
new Float:g_pr_finishedmaps_perc[MAX_PR_PLAYERS]; 
new bool:g_bRenaming = false;
new bool:g_bLateLoaded = false;
new bool:g_bRoundEnd;
new bool:g_bFirstEndButtonPush;
new bool:g_bMapReplay;
new bool:g_bMapBonusReplay;
new bool:g_pr_RankingRecalc_InProgress;
new bool:g_bHookMod;
new bool:g_bMapChooser;
new bool:g_bUseCPrefs;
new bool:g_bLoaded[MAXPLAYERS+1];
new bool:g_bFirstButtonTouch[MAXPLAYERS+1];
new bool:g_bClientOwnReason[MAXPLAYERS + 1];
new bool:g_pr_Calculating[MAXPLAYERS+1];
new bool:g_bChallenge_Checkpoints[MAXPLAYERS+1];
new bool:g_bTopMenuOpen[MAXPLAYERS+1]; 
new bool:g_bNoClipUsed[MAXPLAYERS+1];
new bool:g_bMenuOpen[MAXPLAYERS+1];
new bool:g_bPause[MAXPLAYERS+1];
new bool:g_bPauseWasActivated[MAXPLAYERS+1];
new bool:g_bOverlay[MAXPLAYERS+1];
new bool:g_bSpectate[MAXPLAYERS+1];
new bool:g_bTimeractivated[MAXPLAYERS+1];
new bool:g_bFirstTeamJoin[MAXPLAYERS+1];
new bool:g_bFirstSpawn[MAXPLAYERS+1];
new bool:g_bTop100Refresh;
new bool:g_bMissedMapBest[MAXPLAYERS+1];
new bool:g_bRestorePosition[MAXPLAYERS+1]; 
new bool:g_bRestorePositionMsg[MAXPLAYERS+1]; 
new bool:g_bClimbersMenuOpen[MAXPLAYERS+1];  
new bool:g_bNoClip[MAXPLAYERS+1];
new bool:g_bMapFinished[MAXPLAYERS+1]; 
new bool:g_bRespawnPosition[MAXPLAYERS+1]; 
new bool:g_bKickStatus[MAXPLAYERS+1]; 
new bool:g_bProfileRecalc[MAX_PR_PLAYERS];
new bool:g_bProfileSelected[MAXPLAYERS+1]; 
new bool:g_bManualRecalc; 
new bool:g_bSelectProfile[MAXPLAYERS+1]; 
new bool:g_bClimbersMenuwasOpen[MAXPLAYERS+1]; 
new bool:g_bChallenge_Abort[MAXPLAYERS+1];
new bool:g_bValidTeleportCall[MAXPLAYERS+1];
new bool:g_bMapRankToChat[MAXPLAYERS+1];
new bool:g_bChallenge[MAXPLAYERS+1];
new bool:g_bChallenge_Request[MAXPLAYERS+1];
new bool:g_pr_showmsg[MAXPLAYERS+1];
new bool:g_CMOpen[MAXPLAYERS+1];
new bool:g_bRecalcRankInProgess[MAXPLAYERS+1];
new bool:g_bLanguageSelected[MAXPLAYERS+1];
new bool:g_bNewReplay[MAXPLAYERS+1];
new bool:g_bNewBonus[MAXPLAYERS+1];
new bool:g_bPositionRestored[MAXPLAYERS+1];
new bool:g_bInfoPanel[MAXPLAYERS+1];
new bool:g_bEnableQuakeSounds[MAXPLAYERS+1];
new bool:g_bShowNames[MAXPLAYERS+1]; 
new bool:g_bStartWithUsp[MAXPLAYERS+1];
new bool:g_bShowTime[MAXPLAYERS+1]; 
new bool:g_bHide[MAXPLAYERS+1];   
new bool:g_bSayHook[MAXPLAYERS+1]; 
new bool:g_bShowSpecs[MAXPLAYERS+1]; 
new bool:g_bGoToClient[MAXPLAYERS+1]; 
new bool:g_bMeasurePosSet[MAXPLAYERS+1][2];
new bool:g_bAutoBhopClient[MAXPLAYERS+1];
new bool:g_borg_StartWithUsp[MAXPLAYERS+1];
new bool:g_borg_InfoPanel[MAXPLAYERS+1];
new bool:g_borg_EnableQuakeSounds[MAXPLAYERS+1];
new bool:g_borg_ShowNames[MAXPLAYERS+1]; 
new bool:g_borg_GoToClient[MAXPLAYERS+1]; 
new bool:g_borg_ShowTime[MAXPLAYERS+1]; 
new bool:g_borg_Hide[MAXPLAYERS+1]; 
new bool:g_borg_ShowSpecs[MAXPLAYERS+1]; 
new bool:g_borg_AutoBhopClient[MAXPLAYERS+1];
new bool:g_bBeam[MAXPLAYERS+1];
new bool:g_bOnGround[MAXPLAYERS+1];
new bool:g_bLegitButtons[MAXPLAYERS+1];
new bool:g_specToStage[MAXPLAYERS+1];
new Float:g_fTeleLocation[MAXPLAYERS+1][3];
new Float:g_fCurVelVec[MAXPLAYERS+1][3];

// Player checkpoints
new Float:g_fCheckpointVelocity_undo[MAXPLAYERS+1][3];
new Float:g_fCheckpointVelocity[MAXPLAYERS+1][3];
new Float:g_fCheckpointLocation[MAXPLAYERS+1][3];
new Float:g_fCheckpointLocation_undo[MAXPLAYERS+1][3];
new Float:g_fCheckpointAngle[MAXPLAYERS+1][3];
new Float:g_fCheckpointAngle_undo[MAXPLAYERS+1][3];
new Float:g_fLastPlayerCheckpoint[MAXPLAYERS+1];

new bool:g_bCreatedTeleport[MAXPLAYERS+1];
new bool:g_bCheckpointMode[MAXPLAYERS+1];

new g_unfinishedMaps[MAXPLAYERS+1];
new g_unfinishedBonuses[MAXPLAYERS+1];
new g_Beam[3];
new g_TSpawns=-1;
new g_CTSpawns=-1;
new g_ownerOffset;
new g_ragdolls = -1;
new g_Server_Tickrate;
new g_MapTimesCount;
new g_RecordBot=-1;
new g_BonusBot=-1;
new g_InfoBot=-1;
new g_ReplayBotColor[3];
new g_BonusBotColor[3];
new g_pr_Recalc_ClientID = 0;
new g_pr_Recalc_AdminID=-1; 
new g_pr_AllPlayers;
new g_pr_RankedPlayers;
new g_pr_MapCount;
new g_pr_rank_Percentage[9];
new g_pr_PointUnit;
new g_pr_TableRowCount;
new g_pr_points[MAX_PR_PLAYERS];
new g_pr_maprecords_row_counter[MAX_PR_PLAYERS];
new g_pr_maprecords_row_count[MAX_PR_PLAYERS];
new g_pr_oldpoints[MAX_PR_PLAYERS];  
new g_pr_multiplier[MAX_PR_PLAYERS]; 
new g_pr_finishedmaps[MAX_PR_PLAYERS];
new g_PlayerRank[MAXPLAYERS+1];
new g_SelectedTeam[MAXPLAYERS+1];
new g_BotMimicRecordTickCount[MAXPLAYERS+1] = {0,...};
new g_BotActiveWeapon[MAXPLAYERS+1] = {-1,...};
new g_CurrentAdditionalTeleportIndex[MAXPLAYERS+1];
new g_RecordedTicks[MAXPLAYERS+1];
new g_RecordPreviousWeapon[MAXPLAYERS+1];
new g_OriginSnapshotInterval[MAXPLAYERS+1];
new g_BotMimicTick[MAXPLAYERS+1] = {0,...};
new g_AttackCounter[MAXPLAYERS + 1];
new g_MenuLevel[MAXPLAYERS+1];
new g_Challenge_Bet[MAXPLAYERS+1];
new g_MapRank[MAXPLAYERS+1];
new g_OldMapRank[MAXPLAYERS+1];
new g_Time_Type[MAXPLAYERS+1];
new g_Sound_Type[MAXPLAYERS+1];
new g_MapRecordCount[MAXPLAYERS+1];
new g_FinishingType[MAXPLAYERS+1];
new g_Challenge_WinRatio[MAX_PR_PLAYERS];
new g_CountdownTime[MAXPLAYERS+1];
new g_Challenge_PointsRatio[MAX_PR_PLAYERS];
new g_SpecTarget[MAXPLAYERS+1];
new g_LastButton[MAXPLAYERS + 1];
new g_CurrentButton[MAXPLAYERS+1];
new g_MVPStars[MAXPLAYERS+1];
new g_AdminMenuLastPage[MAXPLAYERS+1];
new g_OptionsMenuLastPage[MAXPLAYERS+1];
new g_PlayerChatRank[MAXPLAYERS+1];
new String:g_pr_chat_coloredrank[MAXPLAYERS+1][32];
new String:g_pr_rankname[MAXPLAYERS+1][32];  
new String:g_pr_szrank[MAXPLAYERS+1][512];  
new String:g_pr_szName[MAX_PR_PLAYERS][64];  
new String:g_pr_szSteamID[MAX_PR_PLAYERS][32]; 
new String:g_szMapPrefix[2][32]; 
new String:g_szMapmakers[100][32];  
new String:g_szReplayName[128];  
new String:g_szReplayTime[128]; 
new String:g_szBonusName[128];
new String:g_szBonusTime[128];
new String:g_szChallenge_OpponentID[MAXPLAYERS+1][32]; 
new String:g_szTimeDifference[MAXPLAYERS+1][32]; 
new String:g_szFinalTime[MAXPLAYERS+1][32];
new String:g_szMapName[128];
new String:g_szMapTopName[MAXPLAYERS+1][128];
new String:g_szTimerTitle[MAXPLAYERS+1][255];
new String:g_szRecordPlayer[MAX_NAME_LENGTH];
new String:g_szProfileName[MAXPLAYERS+1][MAX_NAME_LENGTH];
new String:g_szPlayerPanelText[MAXPLAYERS+1][512];
new String:g_szProfileSteamId[MAXPLAYERS+1][32];
new String:g_szCountry[MAXPLAYERS+1][100];
new String:g_szCountryCode[MAXPLAYERS+1][16]; 
new String:g_szSteamID[MAXPLAYERS+1][32];  
new String:g_szSkillGroups[9][32];
new String:g_szServerName[64];  
new String:g_szMapPath[256]; 
new String:g_szServerIp[32];   
new String:g_szServerCountry[100]; 
new String:g_szServerCountryCode[32];  
new String:EntityList[][] = {"logic_timer", "team_round_timer", "logic_relay"};
new const String:MAPPERS_PATH[] = "configs/ckSurf/mapmakers.txt";
new const String:CK_REPLAY_PATH[] = "data/cKreplays/";
new const String:BLOCKED_LIST_PATH[] = "configs/ckSurf/hidden_chat_commands.txt";
new const String:PRO_FULL_SOUND_PATH[] = "sound/quake/holyshit.mp3";
new const String:PRO_RELATIVE_SOUND_PATH[] = "*quake/holyshit.mp3";
new const String:CP_FULL_SOUND_PATH[] = "sound/quake/wickedsick.mp3";
new const String:CP_RELATIVE_SOUND_PATH[] = "*quake/wickedsick.mp3";
new const String:UNSTOPPABLE_SOUND_PATH[] = "sound/quake/unstoppable.mp3";
new const String:UNSTOPPABLE_RELATIVE_SOUND_PATH[] = "*quake/unstoppable.mp3";
new const String:g_sModel[] = "models/props/de_train/barrel.mdl";
new String:RadioCMDS[][] = {"coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog",
	"getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin",
	"getout", "negative","enemydown","cheer","thanks","nice","compliment"};
new String:g_BlockedChatText[256][256];
new String:g_szReplay_PlayerName[MAXPLAYERS+1][64];

// Speed Cap Variables
new Handle:g_hStartPreSpeed = INVALID_HANDLE; 
new Float:g_fStartPreSpeed; 
new Handle:g_hSpeedPreSpeed = INVALID_HANDLE; 
new Float:g_fSpeedPreSpeed; 
new Handle:g_hBonusPreSpeed = INVALID_HANDLE; 
new Float:g_fBonusPreSpeed; 

new bool:g_binStartZone[MAXPLAYERS+1]; 
new bool:g_binSpeedZone[MAXPLAYERS+1];
new bool:g_binBonusStartZone[MAXPLAYERS+1];

new bool:g_bToStart[MAXPLAYERS+1];
new bool:g_bToStage[MAXPLAYERS+1];
new bool:g_bToBonus[MAXPLAYERS+1];
new bool:g_bToGoto[MAXPLAYERS+1];


new Handle:g_hSoundEnabled = INVALID_HANDLE; 
new bool:bSoundEnabled; 

new Handle:g_hSoundPath = INVALID_HANDLE; 
new String:sSoundPath[64]; 

//////////////////////
// CVARS//////////////
//////////////////////

// Teleport on spawn to start zone (or speed zone) stuff 
new Handle:g_hSpawnToStartZone = INVALID_HANDLE; 
new bool:bSpawnToStartZone; 

// Min rank to announce in chat
new Handle:g_hAnnounceRank = INVALID_HANDLE;
new g_AnnounceRank;
// Force players CT
new Handle:g_hForceCT = INVALID_HANDLE;
new bool:g_bForceCT;

// Chat spam limiter
new Handle:g_hChatSpamFilter = INVALID_HANDLE;
new Float:g_fChatSpamFilter

#include "ckSurf/misc.sp"
#include "ckSurf/admin.sp"
#include "ckSurf/commands.sp"
#include "ckSurf/hooks.sp"
#include "ckSurf/buttonpress.sp"
#include "ckSurf/sql.sp"
#include "ckSurf/timer.sp"
#include "ckSurf/replay.sp"
#include "ckSurf/surfzones.sp"

public OnLibraryAdded(const String:name[])
{
	if (StrEqual("hookgrabrope", name))
		g_bHookMod = true;
	new Handle:tmp = FindPluginByFile("mapchooser_extended.smx");
	if ((StrEqual("mapchooser", name)) ||(tmp != INVALID_HANDLE && GetPluginStatus(tmp) == Plugin_Running))
		g_bMapChooser = true;
	if (tmp != INVALID_HANDLE)
		CloseHandle(tmp);
	
	//botmimic 2
	if(StrEqual(name, "dhooks") && g_hTeleport == INVALID_HANDLE)
	{
		// Optionally setup a hook on CBaseEntity::Teleport to keep track of sudden place changes
		new Handle:hGameData = LoadGameConfigFile("sdktools.games");
		if(hGameData == INVALID_HANDLE)
			return;
		new iOffset = GameConfGetOffset(hGameData, "Teleport");
		CloseHandle(hGameData);
		if(iOffset == -1)
			return;
		
		g_hTeleport = DHookCreate(iOffset, HookType_Entity, ReturnType_Void, ThisPointer_CBaseEntity, DHooks_OnTeleport);
		if(g_hTeleport == INVALID_HANDLE)
			return;
		DHookAddParam(g_hTeleport, HookParamType_VectorPtr);
		DHookAddParam(g_hTeleport, HookParamType_ObjectPtr);
		DHookAddParam(g_hTeleport, HookParamType_VectorPtr);
		if(GetEngineVersion() == Engine_CSGO)
			DHookAddParam(g_hTeleport, HookParamType_Bool);
		
		for(new i=1;i<=MaxClients;i++)
		{
			if(IsClientInGame(i))
				OnClientPutInServer(i);
		}
	}
}

public OnClientPostAdminCheck(client)
{
	g_ClientSelectedZone[client]=-1;
	g_Editing[client]=0;
}

public OnPluginEnd()
{
	
	//remove clan tags
	for (new x = 1; x <= MaxClients; x++)
	{
		if (IsValidClient(x))
		{
			SetEntPropEnt(x, Prop_Send, "m_bSpotted", 1);
			SetEntProp(x, Prop_Send, "m_iHideHUD", 0);
			SetEntProp(x, Prop_Send, "m_iAccount", 1);			
			CS_SetClientClanTag(x, "");
			OnClientDisconnect(x);
		}
 	}


	//set server convars back to default
	ServerCommand("sm_cvar sv_enablebunnyhopping 0;sv_friction 5.2;sv_accelerate 5.5;sv_airaccelerate 10;sv_maxvelocity 2000;sv_staminajumpcost .08;sv_staminalandcost .050");
	ServerCommand("mp_respawn_on_death_ct 0;mp_respawn_on_death_t 0;mp_respawnwavetime_ct 10.0;mp_respawnwavetime_t 10.0;bot_zombie 0;mp_ignore_round_win_conditions 0");
	ServerCommand("sv_infinite_ammo 0;mp_endmatch_votenextmap 1;mp_do_warmup_period 1;mp_warmuptime 60;mp_match_can_clinch 1;mp_match_end_changelevel 0");
	ServerCommand("mp_match_restart_delay 15;mp_endmatch_votenextleveltime 20;mp_endmatch_votenextmap 1;mp_halftime 0;mp_do_warmup_period 1;mp_maxrounds 0;bot_quota 0");		
	ServerCommand("mp_startmoney 800; mp_playercashawards 1; mp_teamcashawards 1");
}

public OnLibraryRemoved(const String:name[])
{
	if (StrEqual(name, "adminmenu"))
		g_hAdminMenu = INVALID_HANDLE;
	if(StrEqual(name, "dhooks"))
		g_hTeleport = INVALID_HANDLE;
	if (StrEqual("hookgrabrope", name))
		g_bHookMod = false;
}

public OnAllPluginsLoaded()
{
	if (LibraryExists("hookgrabrope"))
		g_bHookMod = true;
}

public OnMapStart()
{
	//sv_pure 1 could lead to problems with the ckSurf models
	ServerCommand("sv_pure 0");
			
	//reload language files
	LoadTranslations("ckSurf.phrases");	

	decl String:sPath[PLATFORM_MAX_PATH];
	decl String:line[64];

	//add mapmakers list 
	for (new x = 0; x < 100; x++)
		Format(g_szMapmakers[x],sizeof(g_szMapmakers), "");	
	BuildPath(Path_SM, sPath, sizeof(sPath), "%s", MAPPERS_PATH);
	new count = 0;
	new Handle:fileHandle = OpenFile(sPath,"r");	
	while(!IsEndOfFile(fileHandle)&&ReadFileLine(fileHandle,line,sizeof(line)))
	{			
		TrimString(line);
		if ((StrContains(line,"//",true) == -1) && count < 100)
		{
			Format(g_szMapmakers[count],sizeof(g_szMapmakers), "%s", line);
			count++;
		}		
	}
	
	//add blocked chat commands list
	for (new x = 0; x < 256; x++)
		Format(g_BlockedChatText[x],sizeof(g_BlockedChatText), "");	
	BuildPath(Path_SM, sPath, sizeof(sPath), "%s", BLOCKED_LIST_PATH);
	count = 0;
	fileHandle = OpenFile(sPath,"r");	
	while(!IsEndOfFile(fileHandle)&&ReadFileLine(fileHandle,line,sizeof(line)))
	{
		TrimString(line);
		if ((StrContains(line,"//",true) == -1) && count < 256)
		{
			Format(g_BlockedChatText[count],sizeof(g_BlockedChatText), "%s", line);
			count++;
		}
	}
	if (fileHandle != INVALID_HANDLE)
		CloseHandle(fileHandle);
	//defaults
	for (new t = 1; t <= MAXPLAYERS; t++) 
	{
        g_Stage[t] = 0;
	}
	for (new k = 1; k<= MAXPLAYERS; k++) 
	{
		for (new i = 0; i<20; i++) 
		{
			g_fCheckpointTimesNew[k][i] = 0.0;
			g_fCheckpointTimesRecord[k][i] = 0.0;
		}
	}
	g_bCheckpointRecordFound = false;
	g_insertingInformation = false;
	g_bTierFound = false;
	g_bFirstEndButtonPush=true;			
	g_fMapStartTime = GetEngineTime();
	g_fRecordMapTime=9999999.0;
	g_fBonusFastest=9999999.0;
	g_fStartButtonPos = Float:{-999999.9,-999999.9,-999999.9};
	g_fEndButtonPos = Float:{-999999.9,-999999.9,-999999.9};
	g_fSpawnpointOrigin = Float:{-999999.9,-999999.9,-999999.9};
	g_fSpawnpointAngle = Float:{-999999.9,-999999.9,-999999.9};
	g_MapTimesCount = 0;
	g_RecordBot = -1;
	g_BonusBot = -1;
	g_InfoBot = -1;
	g_bAutoBhop=false;
	g_bRoundEnd=false;
	CheatFlag("bot_zombie", false, true);

	//get mapname
	new bool: fileFound;
	GetCurrentMap(g_szMapName, 128);
	Format(g_szMapPath, sizeof(g_szMapPath), "maps/%s.bsp", g_szMapName); 	
	fileFound = FileExists(g_szMapPath);

	//workshop fix
	new String:mapPieces[6][128];
	new lastPiece = ExplodeString(g_szMapName, "/", mapPieces, sizeof(mapPieces), sizeof(mapPieces[])); 
	Format(g_szMapName, sizeof(g_szMapName), "%s", mapPieces[lastPiece-1]); 
	
	//get map tag
	ExplodeString(g_szMapName, "_", g_szMapPrefix, 2, 32);

	InitZoneVariables();
	OnConfigsExecuted();

	//precache
	InitPrecache();	
	SetCashState();

	//sql queries
	if (!g_bRenaming)
	{
		db_GetMapRecord_Pro();
		db_viewBonusTotalCount();
		db_CalculatePlayerCount();
		db_viewMapProRankCount();
		db_ClearLatestRecords();
		db_GetDynamicTimelimit();
		db_selectSpawnLocations();
		db_viewRecordCheckpoints();
		db_selectMapZones();
		db_viewFastestBonus();
	}
	//timers
	CreateTimer(0.1, CKTimer1, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(1.0, CKTimer2, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(60.0, AttackTimer, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(600.0, PlayerRanksTimer, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	CreateTimer(2700.0, RestartBots, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT); // reset bots every 45minutes, testing
	g_hZoneTimer = CreateTimer(g_fChecker, BeamBoxAll, _, TIMER_REPEAT);

	
	if (g_bAutoRespawn)
		ServerCommand("mp_respawn_on_death_ct 1;mp_respawn_on_death_t 1;mp_respawnwavetime_ct 3.0;mp_respawnwavetime_t 3.0");
	else
		ServerCommand("mp_respawn_on_death_ct 0;mp_respawn_on_death_t 0");
	ServerCommand("sv_infinite_ammo 2;mp_endmatch_votenextmap 0;mp_do_warmup_period 0;mp_warmuptime 0;mp_match_can_clinch 0;mp_match_end_changelevel 1;mp_match_restart_delay 10;mp_endmatch_votenextleveltime 10;mp_endmatch_votenextmap 0;mp_halftime 0;	bot_zombie 1;mp_do_warmup_period 0;mp_maxrounds 1");	
	CheckSpawnPoints();

	//AutoBhop?
	if(StrEqual(g_szMapPrefix[0],"surf") || StrEqual(g_szMapPrefix[0],"bhop") || StrEqual(g_szMapPrefix[0],"mg", false))
		if (g_bAutoBhopConVar)
			g_bAutoBhop=true;		

	//main cfg
	CreateTimer(1.0, DelayedStuff, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE);

	//server infos
	GetServerInfo();
	
	if (g_bLateLoaded)
	{
		OnConfigsExecuted();
		OnAutoConfigsBuffered();
	}

	g_Advert = 0;
	CreateTimer(180.0, AdvertTimer, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);

}

public OnMapEnd()
{
	g_sTierString = "";
	g_RecordBot = -1;
	g_BonusBot = -1;
	db_Cleanup();
}

public OnConfigsExecuted()
{
	new String:map[128];
	new String:map2[128];
	new mapListSerial = -1;
	g_pr_MapCount=0;
	if (ReadMapList(g_MapList, 
			mapListSerial, 
			"mapcyclefile", 
			MAPLIST_FLAG_CLEARARRAY|MAPLIST_FLAG_NO_DEFAULT)
		== INVALID_HANDLE)
	{
		if (mapListSerial == -1)
		{
			SetFailState("<ckSurf> Mapcycle.txt is empty or does not exists.");
		}
	}
	for (new i = 0; i < GetArraySize(g_MapList); i++)
	{
		GetArrayString(g_MapList, i, map, sizeof(map));
		if (!StrEqual(map, "", false))
		{
			//fix workshop map name			
			new String:mapPieces[6][128];
			new lastPiece = ExplodeString(map, "/", mapPieces, sizeof(mapPieces), sizeof(mapPieces[])); 
			Format(map2, sizeof(map2), "%s", mapPieces[lastPiece-1]); 
			SetArrayString(g_MapList, i, map2);
			g_pr_MapCount++;
		}
	}	

	g_BeamSprite = PrecacheModel("sprites/laserbeam.vmt");
	g_HaloSprite = PrecacheModel("materials/sprites/halo.vmt");
	PrecacheModel(g_sModel);
	
	// Count the amount of bonuses and then set skillgroups
	db_selectBonusCount();	

	//AutoBhop?
	if(StrEqual(g_szMapPrefix[0],"surf") || StrEqual(g_szMapPrefix[0],"bhop") || StrEqual(g_szMapPrefix[0],"mg"))
		if (g_bAutoBhopConVar)
			g_bAutoBhop=true;
		
	ServerCommand("sv_pure 0");
}


public OnAutoConfigsBuffered() 
{
	//just to be sure that it's not empty
	decl String:szMap[128];  
	decl String:szPrefix[2][32];  
	GetCurrentMap(szMap, 128);
	decl String:mapPieces[6][128];
	new lastPiece = ExplodeString(szMap, "/", mapPieces, sizeof(mapPieces), sizeof(mapPieces[])); 
	Format(szMap, sizeof(szMap), "%s", mapPieces[lastPiece-1]); 
 	ExplodeString(szMap, "_", szPrefix, 2, 32);

	
	//map config
	decl String:szPath[256];
	Format(szPath, sizeof(szPath), "sourcemod/ckSurf/map_types/%s_.cfg",szPrefix[0]);
	decl String:szPath2[256];
	Format(szPath2, sizeof(szPath2), "cfg/%s",szPath);
	if (FileExists(szPath2))
		ServerCommand("exec %s", szPath);
	else
		SetFailState("<ckSurf> %s not found.", szPath2);
	
	SetServerTags();
}

public OnClientConnected(client)
	g_SelectedTeam[client]=0;

public OnClientPutInServer(client)
{
	if (!IsValidClient(client))
		return;
		
	//SDKHooks/Dhooks
	SDKHook(client, SDKHook_SetTransmit, Hook_SetTransmit);
	SDKHook(client, SDKHook_PostThinkPost, Hook_PostThinkPost); 
	SDKHook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage);	
	SDKHook(client, SDKHook_PreThink, OnPlayerThink);
	SDKHook(client, SDKHook_PreThinkPost, OnPlayerThink);
	SDKHook(client, SDKHook_Think, OnPlayerThink);
	SDKHook(client, SDKHook_PostThink, OnPlayerThink);
	SDKHook(client, SDKHook_PostThinkPost, OnPlayerThink);

	if (IsFakeClient(client))
	{
		g_hRecordingAdditionalTeleport[client] = CreateArray(_:AdditionalTeleport);
		CS_SetMVPCount(client,1);	
		return;
	}	
	else
		g_MVPStars[client] = 0;	
			
	//defaults
	SetClientDefaults(client);
	
	//client country
	GetCountry(client);		

	//client language
	if (g_bUseCPrefs && !IsFakeClient(client))
		if (AreClientCookiesCached(client) && !g_bLoaded[client])
			LoadCookies(client);
			

	if(LibraryExists("dhooks"))
		DHookEntity(g_hTeleport, false, client);	
			
	//get client data
	GetClientAuthString(client, g_szSteamID[client], 32);
	if (!g_bRenaming)
	{
		db_viewPlayerPoints(client);
		db_viewPlayerOptions(client, g_szSteamID[client]);	
	 	db_viewPersonalRecords(client,g_szSteamID[client],g_szMapName);	
		db_viewPersonalBonusRecords(client, g_szSteamID[client]); 
		db_viewCheckpoints(client, g_szSteamID[client], g_szMapName); 
	}
	// ' char fix
	FixPlayerName(client);
	
	//position restoring
	if(g_bRestore && !g_bRenaming)
		db_selectLastRun(client);		
			
	//console info
	PrintConsoleInfo(client);
	
	if (g_bLateLoaded && IsPlayerAlive(client))
		PlayerSpawn(client);

	if (g_bTierFound)
		AnnounceTimer[client] = CreateTimer(30.0, AnnounceMap, client, TIMER_FLAG_NO_MAPCHANGE);
}

public OnClientAuthorized(client)
{
	if (g_bConnectMsg && !IsFakeClient(client))
	{
		decl String:s_Country[32];
		decl String:s_clientName[32];
		decl String:s_address[32];		
		GetClientIP(client, s_address, 32);
		GetClientName(client, s_clientName, 32);
		Format(s_Country, 100, "Unknown");
		GeoipCountry(s_address, s_Country, 100);     
		if(!strcmp(s_Country, NULL_STRING))
			Format( s_Country, 100, "Unknown", s_Country );
		else				
			if( StrContains( s_Country, "United", false ) != -1 || 
				StrContains( s_Country, "Republic", false ) != -1 || 
				StrContains( s_Country, "Federation", false ) != -1 || 
				StrContains( s_Country, "Island", false ) != -1 || 
				StrContains( s_Country, "Netherlands", false ) != -1 || 
				StrContains( s_Country, "Isle", false ) != -1 || 
				StrContains( s_Country, "Bahamas", false ) != -1 || 
				StrContains( s_Country, "Maldives", false ) != -1 || 
				StrContains( s_Country, "Philippines", false ) != -1 || 
				StrContains( s_Country, "Vatican", false ) != -1 )
			{
				Format( s_Country, 100, "The %s", s_Country );
			}				
					
		if (StrEqual(s_Country, "Unknown",false) || StrEqual(s_Country, "Localhost",false))
		{	
			for (new i = 1; i <= MaxClients; i++)
			if (IsValidClient(i) && i != client)
				PrintToChat(i, "%t", "Connected1", WHITE,MOSSGREEN, s_clientName, WHITE);
		}
		else
		{
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i) && i != client)
					PrintToChat(i, "%t", "Connected2", WHITE, MOSSGREEN,s_clientName, WHITE,GREEN,s_Country);
		}
	}
}

public OnClientDisconnect(client)
{
	if (IsFakeClient(client) && g_hRecordingAdditionalTeleport[client] != INVALID_HANDLE)
		CloseHandle(g_hRecordingAdditionalTeleport[client]);

	g_binBonusStartZone[client] = false;
	g_binStartZone[client] = false;
	g_binSpeedZone[client] = false;

	g_fPlayerLastTime[client] = -1.0;
	if(g_fStartTime[client] != -1.0 && g_bTimeractivated[client])
	{
		if (g_bPause[client])
		{
			g_fPauseTime[client] = GetEngineTime() - g_fStartPauseTime[client];
			g_fPlayerLastTime[client] = GetEngineTime() - g_fStartTime[client] - g_fPauseTime[client];	
		}
		else
			g_fPlayerLastTime[client] = g_fCurrentRunTime[client];
	}

	for (new i = 0; i<20; i++)
	{
		g_fCheckpointTimesNew[client][i] = 0.0;
		g_fCheckpointTimesRecord[client][i] = 0.0;
	}
		
	SDKUnhook(client, SDKHook_SetTransmit, Hook_SetTransmit);
	SDKUnhook(client, SDKHook_PostThinkPost, Hook_PostThinkPost); 
	SDKUnhook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage);	
	SDKUnhook(client, SDKHook_PreThink, OnPlayerThink);
	SDKUnhook(client, SDKHook_PreThinkPost, OnPlayerThink);
	SDKUnhook(client, SDKHook_Think, OnPlayerThink);
	SDKUnhook(client, SDKHook_PostThink, OnPlayerThink);
	SDKUnhook(client, SDKHook_PostThinkPost, OnPlayerThink);
	
	if (client == g_RecordBot)
	{
		StopPlayerMimic(client);
		g_RecordBot = -1;
		return;
	}
	if (client == g_BonusBot)
	{
		StopPlayerMimic(client)
		g_BonusBot = -1;
		return;
	}

	tmpStage[client] = g_Stage[client];
	g_bTmpBonusTimer[client] = g_bBonusTimer[client];

	//Database	
	if (IsValidClient(client) && !g_bRenaming)
	{
		db_insertLastPosition(client,g_szMapName);
		db_updatePlayerOptions(client);
	}
	
	// Stop recording
	if(g_hRecording[client] != INVALID_HANDLE)
		StopRecording(client);

	//language
	g_bLoaded[client] = false;

	g_Stage[client] = 0;
	g_bBonusTimer[client] = false;
	g_bValidRun[client] = false;
}

public OnSettingChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{	
	if(convar == g_hGoToServer)
	{
		if(newValue[0] == '1')
			g_bGoToServer = true;
		else
			g_bGoToServer = false;
	}		
	if(convar == g_hChallengePoints)
	{
		if(newValue[0] == '1')
			g_bChallengePoints = true;
		else
			g_bChallengePoints = false;
	}
	if(convar == g_hNoClipS)
	{
		if(newValue[0] == '1')
			g_bNoClipS = true;
		else
			g_bNoClipS = false;
	}		
	if(convar == g_hReplayBot)
	{
		if(newValue[0] == '1')
		{
			g_bReplayBot = true;
			LoadReplays();
		}
		else
		{		
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))	
				{
					if (i == g_RecordBot)
					{
						StopPlayerMimic(i);
						KickClient(i);					
					}
					else 
					{
						if (!g_bBonusBot) // if both bots are off, no need to record
							if(g_hRecording[i] != INVALID_HANDLE)
								StopRecording(i);
					}				
				}
			if (g_bInfoBot && g_bBonusBot)
				ServerCommand("bot_quota 2");
			else
				if (g_bInfoBot ||g_bBonusBot)
					ServerCommand("bot_quota 1");
				else
					ServerCommand("bot_quota 0");
			g_bReplayBot = false;	
		}
	}
	if(convar == g_hBonusBot)
	{
		if (newValue[0] == '1')
		{
			g_bBonusBot = true;
			LoadReplays();
		}
		else
		{
			for(new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))
				{
					if (i == g_BonusBot)
					{
						StopPlayerMimic(i);
						KickClient(i);
					}
					else
					{
						if (!g_bReplayBot) // if both bots are off
							if(g_hRecording[i] != INVALID_HANDLE)
								StopRecording(i);
					}
				}
			if (g_bInfoBot && g_bReplayBot)
				ServerCommand("bot_quota 2");
			else
				if (g_bInfoBot ||g_bReplayBot)
					ServerCommand("bot_quota 1");
				else
					ServerCommand("bot_quota 0");
			g_bBonusBot = false;	
		}
	}
	if(convar == g_hAdminClantag)
	{
		if(newValue[0] == '1')
		{
			g_bAdminClantag = true;
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))	
					CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);						
		}
		else
		{
			g_bAdminClantag = false;
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))	
					CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);		
		}
	}	
	if(convar == g_hVipClantag)
	{
		if(newValue[0] == '1')
		{
			g_bVipClantag = true;
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))	
					CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);		
		}
		else
		{
			g_bVipClantag = false;
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))	
					CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);		
		}
	}
	if(convar == g_hAutoTimer)
	{
		if(newValue[0] == '1')
			g_bAutoTimer = true;
		else
			g_bAutoTimer = false;
	}
	if(convar == g_hColoredNames)
	{
		if(newValue[0] == '1')
			g_bColoredNames = true;
		else
			g_bColoredNames = false;
	}
	if(convar == g_hPauseServerside)
	{
		if(newValue[0] == '1')
			g_bPauseServerside = true;
		else
			g_bPauseServerside = false;
	}
	if(convar == g_hDynamicTimelimit)
	{
		if(newValue[0] == '1')
			g_bDynamicTimelimit = true;
		else
			g_bDynamicTimelimit = false;
	}	
	if(convar == g_hAutohealing_Hp)
		g_Autohealing_Hp = StringToInt(newValue[0]);	
	
	if(convar == g_hAutoRespawn)
	{
		if(newValue[0] == '1')
		{
			ServerCommand("mp_respawn_on_death_ct 1;mp_respawn_on_death_t 1;mp_respawnwavetime_ct 3.0;mp_respawnwavetime_t 3.0");
			g_bAutoRespawn = true;
		}
		else
		{
			ServerCommand("mp_respawn_on_death_ct 0;mp_respawn_on_death_t 0");
			g_bAutoRespawn = false;
		}
	}	
	if(convar == g_hRadioCommands)
	{
		if(newValue[0] == '1')
			g_bRadioCommands = true;
		else
			g_bRadioCommands = false;
	}	
	if(convar == g_hcvarRestore)
	{
		if(newValue[0] == '1')
			g_bRestore = true;			
		else
			g_bRestore = false;
	}
	if(convar == g_hMapEnd)
	{
		if(newValue[0] == '1')
			g_bMapEnd = true;			
		else
			g_bMapEnd = false;
	}
	if(convar == g_hConnectMsg)
	{
		if(newValue[0] == '1')
			g_bConnectMsg = true;			
		else
			g_bConnectMsg = false;
	}
	if(convar == g_hDisconnectMsg)
	{
		if(newValue[0] == '1')
			g_bDisconnectMsg = true;			
		else
			g_bDisconnectMsg = false;
	}
	if(convar == g_hPlayerSkinChange)
	{
		if(newValue[0] == '1')
		{
			g_bPlayerSkinChange = true;
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))	
				{					
					if (i == g_RecordBot)
					{
						SetEntPropString(i, Prop_Send, "m_szArmsModel", g_sReplayBotPlayerModel);
						SetEntityModel(i,  g_sReplayBotPlayerModel);
					}
					else
					{
						SetEntPropString(i, Prop_Send, "m_szArmsModel", g_sArmModel);
						SetEntityModel(i,  g_sPlayerModel);
					}
				}
		}
		else
			g_bPlayerSkinChange = false;
	}	
	if(convar == g_hPointSystem)
	{
		if(newValue[0] == '1')
		{
			g_bPointSystem = true;		
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))				
					CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);					
		}
		else
		{
			for (new i = 1; i <= MaxClients; i++)
				if (IsValidClient(i))
				{
					Format(g_pr_rankname[i], 32, "");
					CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);
				}
			g_bPointSystem = false;
		}
	}		
	if(convar == g_hcvarNoBlock)
	{
		if(newValue[0] == '1')
		{
			g_bNoBlock = true;
			for(new client = 1; client <= MAXPLAYERS; client++)
				if (IsValidEntity(client))
					SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
					
		}
		else
		{	
			g_bNoBlock = false;
			for(new client = 1; client <= MAXPLAYERS; client++)
				if (IsValidEntity(client))
					SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 5, 4, true);
		}
	}	
	if(convar == g_hAttackSpamProtection)
	{
		if(newValue[0] == '1')
		{
			g_bAttackSpamProtection = true;
		}
		else
		{	
			g_bAttackSpamProtection = false;
		}
	}		
	if(convar == g_hCleanWeapons)
	{
		if(newValue[0] == '1')
		{
			decl String:szclass[32];
			g_bCleanWeapons = true;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && IsPlayerAlive(i))
				{
					for(new j = 0; j < 4; j++)
					{
						new weapon = GetPlayerWeaponSlot(i, j);
						if(weapon != -1 && j != 2)
						{
							GetEdictClassname(weapon, szclass, sizeof(szclass));
							RemovePlayerItem(i, weapon);
							RemoveEdict(weapon);							
							new equipweapon = GetPlayerWeaponSlot(i, 2);
							if (equipweapon != -1)
								EquipPlayerWeapon(i, equipweapon); 
						}
					}
				}
			}
			
		}
		else
			g_bCleanWeapons = false;
	}			
	if(convar == g_hAutoBhopConVar)
	{
		if(newValue[0] == '1')		
		{		
			g_bAutoBhopConVar = true;		
			if(StrEqual(g_szMapPrefix[0],"surf") || StrEqual(g_szMapPrefix[0],"bhop") || StrEqual(g_szMapPrefix[0],"mg"))
			{
				g_bAutoBhop = true;
			}
		}
		else
		{
			g_bAutoBhopConVar = false;
			g_bAutoBhop = false;
		}
	}		
	if(convar == g_hCountry)
	{
		if(newValue[0] == '1')
		{
			g_bCountry = true;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i))
				{
					GetCountry(i);
					if (g_bPointSystem)
						CreateTimer(0.5, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		else
		{
			g_bCountry = false;
			if (g_bPointSystem)
				for (new i = 1; i <= MaxClients; i++)
					if (IsValidClient(i))				
						CreateTimer(0.5, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);		
		}
	}		
	if(convar == g_hExtraPoints)
		g_ExtraPoints = StringToInt(newValue[0]);	
	if(convar == g_hExtraPoints2)
		g_ExtraPoints2 = StringToInt(newValue[0]);
		
	
	if(convar == g_hcvargodmode)
	{
		if(newValue[0] == '1')
			g_bgodmode = true;
		else
			g_bgodmode = false;
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{	
				if (g_bgodmode)
					SetEntProp(i, Prop_Data, "m_takedamage", 0, 1);
				else
					SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
			}
		}
	}	
	if(convar == g_hInfoBot)
	{
		if(newValue[0] == '1')		
		{
			g_bInfoBot = true;
			LoadInfoBot();
		}
		else
		{
			g_bInfoBot = false;
			for (new i = 1; i <= MaxClients; i++)
			if (IsValidClient(i) && IsFakeClient(i))	
			{
				if (i == g_InfoBot)
				{
					new count = 0;
					g_InfoBot = -1;
					KickClient(i);		
					decl String:szBuffer[64];
					if(g_bMapReplay)
						count++;
					if(g_bMapBonusReplay)
						count++;
					Format(szBuffer, sizeof(szBuffer), "bot_quota %i", count); 	
					ServerCommand(szBuffer);							
				}
			}
		}
	}	
	if(convar == g_hReplayBotPlayerModel)
	{
		Format(g_sReplayBotPlayerModel,256,"%s", newValue[0]);
		PrecacheModel(newValue[0],true);
		AddFileToDownloadsTable(g_sReplayBotPlayerModel);
		if (g_RecordBot != -1)
			SetEntityModel(g_RecordBot,  newValue[0]);	
	}
	if(convar == g_hReplayBotArmModel)
	{
		Format(g_sReplayBotArmModel,256,"%s", newValue[0]);
		PrecacheModel(newValue[0],true);		
		AddFileToDownloadsTable(g_sReplayBotArmModel);
		if (g_RecordBot != -1)
				SetEntPropString(g_RecordBot, Prop_Send, "m_szArmsModel", newValue[0]);	
	}
	if(convar == g_hPlayerModel)
	{
		Format(g_sPlayerModel,256,"%s", newValue[0]);
		PrecacheModel(newValue[0],true);	
		AddFileToDownloadsTable(g_sPlayerModel);
		if (!g_bPlayerSkinChange)
			return;
		for (new i = 1; i <= MaxClients; i++)
			if (IsValidClient(i) && i != g_RecordBot)	
				SetEntityModel(i,  newValue[0]);
	}
	if(convar == g_hArmModel)
	{
		Format(g_sArmModel,256,"%s", newValue[0]);
		PrecacheModel(newValue[0],true);		
		AddFileToDownloadsTable(g_sArmModel);
		if (!g_bPlayerSkinChange)
			return;
		for (new i = 1; i <= MaxClients; i++)
			if (IsValidClient(i) && i != g_RecordBot)	
				SetEntPropString(i, Prop_Send, "m_szArmsModel", newValue[0]);
	}	
	if(convar == g_hWelcomeMsg)
		Format(g_sWelcomeMsg,512,"%s", newValue[0]);

	if(convar == g_hReplayBotColor)
	{
		decl String:color[256];
		Format(color,256,"%s", newValue[0]);
		GetRGBColor(0,color);
	}
	if (convar == g_hBonusBotColor)
	{
		decl String:color[256];
		Format(color, 256, "%s", newValue[0]);
		GetRGBColor(1, color);
	}
	if(convar == g_hAllowRoundEndCvar)
	{
		if(newValue[0] == '1')		
		{
			ServerCommand("mp_ignore_round_win_conditions 0");
			g_bAllowRoundEndCvar = true;
		}
		else
		{
			ServerCommand("mp_ignore_round_win_conditions 1;mp_maxrounds 1");
			g_bAllowRoundEndCvar = false;
		}
	}
	if(convar == g_hChecker)
	{
		g_fChecker = StringToFloat(newValue[0]);
	}
	if(convar == g_hZoneDisplayType)
	{
		g_zoneDisplayType = StringToInt(newValue[0]);
	}
	if(convar == g_hZonesToDisplay)
	{
		g_zonesToDisplay = StringToInt(newValue[0]);
	}
	if(convar == g_hzoneStartColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneStartColor);
	}
	if(convar == g_hzoneEndColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneEndColor);
	}
	if(convar == g_hzoneCheckerColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneCheckerColor);
	}
	if(convar == g_hzoneBonusStartColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneBonusStartColor);
	}
	if(convar == g_hzoneBonusEndColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneBonusEndColor);
	}
	if(convar == g_hzoneStageColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneStageColor);
	}
	if(convar == g_hzoneCheckpointColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneCheckpointColor);
	}
	if(convar == g_hzoneSpeedColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneSpeedColor);
	}
	if(convar == g_hzoneTeleToStartColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneTeleToStartColor);
	}
	if(convar == g_hzoneValidatorColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneValidatorColor);
	}
	if(convar == g_hzoneStopColor)
	{
		decl String:color[24];
		Format(color, 28, "%s", newValue[0]);
		StringRGBtoInt(color, g_zoneStopColor);
	}
	if (convar == g_hStartPreSpeed) {
		g_fStartPreSpeed = StringToFloat(newValue[0]);
	}
	if (convar == g_hSpeedPreSpeed) {
		g_fSpeedPreSpeed = StringToFloat(newValue[0]);
	}
	if (convar == g_hBonusPreSpeed){
		g_fBonusPreSpeed = StringToFloat(newValue[0]);
	}
	if (convar == g_hSpawnToStartZone) {
		if (newValue[0] == '1') {
			bSpawnToStartZone = true;
		} else {
			bSpawnToStartZone = false;
		}
	}
	if (convar == g_hSoundEnabled) {
		if (newValue[0] == '1') {
			bSoundEnabled = true;
		} else {
			bSoundEnabled = false;
		}
	}
	if (convar == g_hSoundPath) {
		strcopy(sSoundPath, sizeof(sSoundPath), newValue);
	}
	if (convar == g_hAnnounceRank) {
		g_AnnounceRank = StringToInt(newValue[0]);
	}
	if (convar == g_hForceCT) {
		g_bForceCT = IntoBool(StringToInt(newValue[0]));
	}
	if (convar == g_hChatSpamFilter) {
		g_fChatSpamFilter = StringToFloat(newValue[0]);
	}

	if(g_hZoneTimer!= INVALID_HANDLE)
	{
		KillTimer(g_hZoneTimer);
		g_hZoneTimer = INVALID_HANDLE;
	}

	g_hZoneTimer = CreateTimer(g_fChecker, BeamBoxAll, _, TIMER_REPEAT);

}

public Native_GetTimerStatus(Handle:plugin, numParams)
	return g_bTimeractivated[GetNativeCell(1)];

public Native_StopUpdatingOfClimbersMenu(Handle:plugin, numParams)
{
	g_bMenuOpen[GetNativeCell(1)] = true;
	if (g_hclimbersmenu[GetNativeCell(1)] != INVALID_HANDLE)
	{	
		g_hclimbersmenu[GetNativeCell(1)] = INVALID_HANDLE;
	}
	if (g_bClimbersMenuOpen[GetNativeCell(1)])
		g_bClimbersMenuwasOpen[GetNativeCell(1)]=true;
	else
		g_bClimbersMenuwasOpen[GetNativeCell(1)]=false;
	g_bClimbersMenuOpen[GetNativeCell(1)] = false;		
}

public Native_StopTimer(Handle:plugin, numParams)
	Client_Stop(GetNativeCell(1),0);

public Native_GetCurrentTime(Handle:plugin, numParams)
	return _:g_fCurrentRunTime[GetNativeCell(1)];
	
public Native_EmulateStartButtonPress(Handle:plugin, numParams)
{
	g_bLegitButtons[GetNativeCell(1)] = false;
	CL_OnStartTimerPress(GetNativeCell(1));
}
	
public Native_EmulateStopButtonPress(Handle:plugin, numParams)
{
	g_bLegitButtons[GetNativeCell(1)] = false;
	CL_OnEndTimerPress(GetNativeCell(1));
}		

public Plugin:myinfo =
{
	name = "ckSurf",
	author = "Elzi",
	description = "#clan.kieli's Surf Plugin",
	version = VERSION,
	url = ""
};

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	RegPluginLibrary("ckSurf");
	CreateNative("ckSurf_GetTimerStatus", Native_GetTimerStatus);
	CreateNative("ckSurf_StopUpdatingOfClimbersMenu", Native_StopUpdatingOfClimbersMenu);
	CreateNative("ckSurf_StopTimer", Native_StopTimer);
	CreateNative("ckSurf_EmulateStartButtonPress", Native_EmulateStartButtonPress);
	CreateNative("ckSurf_EmulateStopButtonPress", Native_EmulateStopButtonPress);
	CreateNative("ckSurf_GetCurrentTime", Native_GetCurrentTime);
	MarkNativeAsOptional("HGR_IsHooking");
	MarkNativeAsOptional("HGR_IsGrabbing");
	MarkNativeAsOptional("HGR_IsBeingGrabbed");
	MarkNativeAsOptional("HGR_IsRoping");
	MarkNativeAsOptional("HGR_IsPushing");
	MarkNativeAsOptional("HasEndOfMapVoteFinished");
	MarkNativeAsOptional("EndOfMapVoteEnabled");	
	g_OnLangChanged = CreateGlobalForward("GeoLang_OnLanguageChanged", ET_Ignore, Param_Cell, Param_Cell);
	g_bLateLoaded = late;
	return APLRes_Success;
}

public OnPluginStart()
{
	//Get Server Tickate
	new Float:fltickrate = 1.0 / GetTickInterval( );
	if (fltickrate > 65)
		if (fltickrate < 103)
			g_Server_Tickrate = 102;
		else
			g_Server_Tickrate = 128;
	else
		g_Server_Tickrate= 64;
	
	//language file
	LoadTranslations("ckSurf.phrases");	
	
	// https://forums.alliedmods.net/showthread.php?p=1436866
	// GeoIP Language Selection by GoD-Tony
	Init_GeoLang();
	if (LibraryExists("clientprefs"))
	{
		g_hCookie = RegClientCookie("GeoLanguage", "The client's preferred language.", CookieAccess_Protected);
		SetCookieMenuItem(CookieMenu_GeoLanguage, 0, "Language");
		g_bUseCPrefs = true;
	}
	
	CreateConVar("ckSurf_version", VERSION, "ckSurf Version.", FCVAR_DONTRECORD|FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

	g_hConnectMsg = CreateConVar("ck_connect_msg", "1", "on/off - Enables a player connect message with country", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bConnectMsg     = GetConVarBool(g_hConnectMsg);
	HookConVarChange(g_hConnectMsg, OnSettingChanged);	

	g_hDisconnectMsg = CreateConVar("ck_disconnect_msg", "1", "on/off - Enables a player disconnect message in chat", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bDisconnectMsg = GetConVarBool(g_hDisconnectMsg);
	HookConVarChange(g_hDisconnectMsg, OnSettingChanged);	

	g_hMapEnd = CreateConVar("ck_map_end", "1", "on/off - Allows map changes after the timelimit has run out (mp_timelimit must be greater than 0)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bMapEnd     = GetConVarBool(g_hMapEnd);
	HookConVarChange(g_hMapEnd, OnSettingChanged);
	
	g_hColoredNames = CreateConVar("ck_colored_chatnames", "0", "on/off Colors players names based on their rank in chat.", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bColoredNames = GetConVarBool(g_hColoredNames);
	HookConVarChange(g_hColoredNames, OnSettingChanged);

	g_hReplayBot = CreateConVar("ck_replay_bot", "1", "on/off - Bots mimic the local map record", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bReplayBot     = GetConVarBool(g_hReplayBot);
	HookConVarChange(g_hReplayBot, OnSettingChanged);	

	g_hBonusBot = CreateConVar("ck_bonus_bot", "1", "on/off - Bots mimic the local bonus record", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bBonusBot		= GetConVarBool(g_hBonusBot);
	HookConVarChange(g_hBonusBot, OnSettingChanged);

	g_hInfoBot	  = CreateConVar("ck_info_bot", "0", "on/off - provides information about nextmap and timeleft in his player name", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bInfoBot     = GetConVarBool(g_hInfoBot);
	HookConVarChange(g_hInfoBot, OnSettingChanged);		
	
	g_hNoClipS = CreateConVar("ck_noclip", "1", "on/off - Allows players to use noclip when they have finished the map", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bNoClipS     = GetConVarBool(g_hNoClipS);
	HookConVarChange(g_hNoClipS, OnSettingChanged);	

	g_hVipClantag = 	CreateConVar("ck_vip_clantag", "1", "on/off - VIP clan tag (necessary flag: a)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bVipClantag     = GetConVarBool(g_hVipClantag);
	HookConVarChange(g_hVipClantag, OnSettingChanged);	
	
	g_hAdminClantag = 	CreateConVar("ck_admin_clantag", "1", "on/off - Admin clan tag (necessary flag: b - z)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAdminClantag     = GetConVarBool(g_hAdminClantag);
	HookConVarChange(g_hAdminClantag, OnSettingChanged);	
	
	g_hAutoTimer = CreateConVar("ck_auto_timer", "0", "on/off - Timer automatically starts when a player joins a team, dies or uses !start/!r", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAutoTimer     = GetConVarBool(g_hAutoTimer);
	HookConVarChange(g_hAutoTimer, OnSettingChanged);

	g_hGoToServer = CreateConVar("ck_goto", "1", "on/off - Allows players to use the !goto command", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bGoToServer     = GetConVarBool(g_hGoToServer);
	HookConVarChange(g_hGoToServer, OnSettingChanged);	
	
	g_hcvargodmode = CreateConVar("ck_godmode", "1", "on/off - unlimited hp", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bgodmode     = GetConVarBool(g_hcvargodmode);
	HookConVarChange(g_hcvargodmode, OnSettingChanged);

	g_hPauseServerside    = CreateConVar("ck_pause", "1", "on/off - Allows players to use the !pause command", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bPauseServerside    = GetConVarBool(g_hPauseServerside);
	HookConVarChange(g_hPauseServerside, OnSettingChanged);
	
	g_hcvarRestore    = CreateConVar("ck_restore", "1", "on/off - Restoring of time and last position after reconnect", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bRestore        = GetConVarBool(g_hcvarRestore);
	HookConVarChange(g_hcvarRestore, OnSettingChanged);
	
	g_hcvarNoBlock    = CreateConVar("ck_noblock", "1", "on/off - Player no blocking", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bNoBlock        = GetConVarBool(g_hcvarNoBlock);
	HookConVarChange(g_hcvarNoBlock, OnSettingChanged);

	g_hAttackSpamProtection    = CreateConVar("ck_attack_spam_protection", "1", "on/off - max 40 shots; +5 new/extra shots per minute; 1 he/flash counts like 9 shots", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAttackSpamProtection       = GetConVarBool(g_hAttackSpamProtection);
	HookConVarChange(g_hAttackSpamProtection, OnSettingChanged);
	
	g_hAutoRespawn = CreateConVar("ck_autorespawn", "1", "on/off - Auto respawn", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAutoRespawn     = GetConVarBool(g_hAutoRespawn);
	HookConVarChange(g_hAutoRespawn, OnSettingChanged);	

	g_hRadioCommands = CreateConVar("ck_use_radio", "0", "on/off - Allows players to use radio commands", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bRadioCommands     = GetConVarBool(g_hRadioCommands);
	HookConVarChange(g_hRadioCommands, OnSettingChanged);	
	
	g_hAutohealing_Hp 	= CreateConVar("ck_autoheal", "50", "Sets HP amount for autohealing (requires ck_godmode 0)", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 100.0);
	g_Autohealing_Hp     = GetConVarInt(g_hAutohealing_Hp);
	HookConVarChange(g_hAutohealing_Hp, OnSettingChanged);	
	
	g_hCleanWeapons 	= CreateConVar("ck_clean_weapons", "1", "on/off - Removes all weapons on the ground", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bCleanWeapons     = GetConVarBool(g_hCleanWeapons);
	HookConVarChange(g_hCleanWeapons, OnSettingChanged);
	
	g_hCountry 	= CreateConVar("ck_country_tag", "1", "on/off - Country clan tag", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bCountry     = GetConVarBool(g_hCountry);
	HookConVarChange(g_hCountry, OnSettingChanged);
	
	g_hChallengePoints 	= CreateConVar("ck_challenge_points", "1", "on/off - Allows players to bet points on their challenges", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bChallengePoints     = GetConVarBool(g_hChallengePoints);
	HookConVarChange(g_hChallengePoints, OnSettingChanged);
		
	g_hAutoBhopConVar 	= CreateConVar("ck_auto_bhop", "1", "on/off - AutoBhop on surf_ maps", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAutoBhopConVar     = GetConVarBool(g_hAutoBhopConVar);
	HookConVarChange(g_hAutoBhopConVar, OnSettingChanged);
	
	g_hDynamicTimelimit 	= CreateConVar("ck_dynamic_timelimit", "0", "on/off - Sets a suitable timelimit by calculating the average run time (This method requires ck_map_end 1, greater than 5 map times and a default timelimit in your server config for maps with less than 5 times", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bDynamicTimelimit     = GetConVarBool(g_hDynamicTimelimit);
	HookConVarChange(g_hDynamicTimelimit, OnSettingChanged);	

	g_hExtraPoints   = CreateConVar("ck_ranking_extra_points_improvements", "15.0", "Gives players x extra points for improving their time.", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 100.0);
	g_ExtraPoints    = GetConVarInt(g_hExtraPoints);
	HookConVarChange(g_hExtraPoints, OnSettingChanged);	

	g_hExtraPoints2   = CreateConVar("ck_ranking_extra_points_firsttime", "50.0", "Gives players x extra points for finishing a map for the first time.", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 100.0);
	g_ExtraPoints2    = GetConVarInt(g_hExtraPoints2);
	HookConVarChange(g_hExtraPoints2, OnSettingChanged);	
	
	g_hPointSystem    = CreateConVar("ck_point_system", "1", "on/off - Player point system", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bPointSystem    = GetConVarBool(g_hPointSystem);
	HookConVarChange(g_hPointSystem, OnSettingChanged);
	
	g_hPlayerSkinChange 	= CreateConVar("ck_custom_models", "1", "on/off - Allows ckSurf to change the models of players and bots", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bPlayerSkinChange     = GetConVarBool(g_hPlayerSkinChange);
	HookConVarChange(g_hPlayerSkinChange, OnSettingChanged);

	g_hReplayBotPlayerModel   = CreateConVar("ck_replay_bot_skin", "models/player/tm_professional_var1.mdl", "Replay pro bot skin", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hReplayBotPlayerModel,g_sReplayBotPlayerModel,256);
	HookConVarChange(g_hReplayBotPlayerModel, OnSettingChanged);	
	
	g_hReplayBotArmModel   = CreateConVar("ck_replay_bot_arm_skin", "models/weapons/t_arms_professional.mdl", "Replay pro bot arm skin", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hReplayBotArmModel,g_sReplayBotArmModel,256);
	HookConVarChange(g_hReplayBotArmModel, OnSettingChanged);	
	
	g_hPlayerModel   = CreateConVar("ck_player_skin", "models/player/ctm_sas_varianta.mdl", "Player skin", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hPlayerModel,g_sPlayerModel,256);
	HookConVarChange(g_hPlayerModel, OnSettingChanged);	
	
	g_hArmModel   = CreateConVar("ck_player_arm_skin", "models/weapons/ct_arms_sas.mdl", "Player arm skin", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hArmModel,g_sArmModel,256);
	HookConVarChange(g_hArmModel, OnSettingChanged);

	
	g_hWelcomeMsg   = CreateConVar("ck_welcome_msg", " {yellow}>>{default} {grey}Welcome! This server is using {lime}ckSurf","Welcome message (supported color tags: {default}, {darkred}, {green}, {lightgreen}, {blue} {olive}, {lime}, {red}, {purple}, {grey}, {yellow}, {lightblue}, {steelblue}, {darkblue}, {pink}, {lightred})", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hWelcomeMsg,g_sWelcomeMsg,512);
	HookConVarChange(g_hWelcomeMsg, OnSettingChanged);

	g_hReplayBotColor   = CreateConVar("ck_replay_bot_color", "52 91 248","The default replay bot color - Format: \"red green blue\" from 0 - 255.", FCVAR_PLUGIN|FCVAR_NOTIFY);
	HookConVarChange(g_hReplayBotColor, OnSettingChanged);	
	decl String:szRBotColor[256];
	GetConVarString(g_hReplayBotColor,szRBotColor,256);
	GetRGBColor(0,szRBotColor);

	g_hBonusBotColor   = CreateConVar("ck_bonus_bot_color", "255 255 20","The bonus replay bot color - Format: \"red green blue\" from 0 - 255.", FCVAR_PLUGIN|FCVAR_NOTIFY);
	HookConVarChange(g_hBonusBotColor, OnSettingChanged);	
	szRBotColor = "";
	GetConVarString(g_hBonusBotColor,szRBotColor,256);
	GetRGBColor(1,szRBotColor);

	g_hChecker = CreateConVar("ck_zone_checker", "5.0", "The duration in seconds when the beams around zones are refreshed.", FCVAR_PLUGIN|FCVAR_NOTIFY);
	g_fChecker = GetConVarFloat(g_hChecker);
	HookConVarChange(g_hChecker, OnSettingChanged);

	g_hZoneDisplayType = CreateConVar("ck_zone_drawstyle", "1", "0 = Do not display zones, 1 = display the lower edges of zones, 2 = display whole zones", FCVAR_PLUGIN|FCVAR_NOTIFY);
	g_zoneDisplayType = GetConVarInt(g_hZoneDisplayType);
	HookConVarChange(g_hZoneDisplayType, OnSettingChanged);

	g_hZonesToDisplay = CreateConVar("ck_zone_drawzones", "1", "Which zones are visible for players. 1 = draw start & end zones, 2 = draw start, end, stage and bonus zones, 3 = draw all zones.", FCVAR_PLUGIN|FCVAR_NOTIFY);
	g_zonesToDisplay = GetConVarInt(g_hZonesToDisplay);
	HookConVarChange(g_hZonesToDisplay, OnSettingChanged);

	g_hzoneStartColor = CreateConVar("ck_zone_startcolor", "000 255 000", "The color of START zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneStartColor, g_szzoneStartColor, 24);
	StringRGBtoInt(g_szzoneStartColor, g_zoneStartColor);
	HookConVarChange(g_hzoneStartColor, OnSettingChanged);

	g_hzoneEndColor = CreateConVar("ck_zone_endcolor", "255 000 000", "The color of END zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneEndColor, g_szzoneEndColor, 24);
	StringRGBtoInt(g_szzoneEndColor, g_zoneEndColor);
	HookConVarChange(g_hzoneEndColor, OnSettingChanged);

	g_hzoneCheckerColor = CreateConVar("ck_zone_checkercolor", "255 255 000", "The color of CHECKER zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneCheckerColor, g_szzoneCheckerColor, 24);
	StringRGBtoInt(g_szzoneCheckerColor, g_zoneCheckerColor);
	HookConVarChange(g_hzoneCheckerColor, OnSettingChanged);

	g_hzoneBonusStartColor = CreateConVar("ck_zone_bonusstartcolor", "000 255 255", "The color of BONUS START zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneBonusStartColor, g_szzoneBonusStartColor, 24);
	StringRGBtoInt(g_szzoneBonusStartColor, g_zoneBonusStartColor);
	HookConVarChange(g_hzoneBonusStartColor, OnSettingChanged);

	g_hzoneBonusEndColor = CreateConVar("ck_zone_bonusendcolor", "255 000 255", "The color of BONUS END zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneBonusEndColor, g_szzoneBonusEndColor, 24);
	StringRGBtoInt(g_szzoneBonusEndColor, g_zoneBonusEndColor);
	HookConVarChange(g_hzoneBonusEndColor, OnSettingChanged);

	g_hzoneStageColor = CreateConVar("ck_zone_stagecolor", "000 000 255", "The color of STAGE zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneStageColor, g_szzoneStageColor, 24);
	StringRGBtoInt(g_szzoneStageColor, g_zoneStageColor);
	HookConVarChange(g_hzoneStageColor, OnSettingChanged);

	g_hzoneCheckpointColor = CreateConVar("ck_zone_checkpointcolor", "000 000 255", "The color of CHECKPOINT zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneCheckpointColor, g_szzoneCheckpointColor, 24);
	StringRGBtoInt(g_szzoneCheckpointColor, g_zoneCheckpointColor);
	HookConVarChange(g_hzoneCheckpointColor, OnSettingChanged);

	g_hzoneSpeedColor = CreateConVar("ck_zone_speedcolor", "255 000 000", "The color of SPEED zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneSpeedColor, g_szzoneSpeedColor, 24);
	StringRGBtoInt(g_szzoneSpeedColor, g_zoneSpeedColor);
	HookConVarChange(g_hzoneSpeedColor, OnSettingChanged);

	g_hzoneTeleToStartColor = CreateConVar("ck_zone_teletostartcolor", "255 255 000", "The color of TELETOSTART zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneTeleToStartColor, g_szzoneTeleToStartColor, 24);
	StringRGBtoInt(g_szzoneTeleToStartColor, g_zoneTeleToStartColor);
	HookConVarChange(g_hzoneTeleToStartColor, OnSettingChanged);

	g_hzoneValidatorColor = CreateConVar("ck_zone_validatorcolor", "255 255 255", "The color of VALIDATOR zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneValidatorColor, g_szzoneValidatorColor, 24);
	StringRGBtoInt(g_szzoneValidatorColor, g_zoneValidatorColor);
	HookConVarChange(g_hzoneValidatorColor, OnSettingChanged);

	g_hzoneStopColor = CreateConVar("ck_zone_stopcolor", "000 000 000", "The color of CHECKER zones \"red green blue\" from 0 - 255", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hzoneStopColor, g_szzoneStopColor, 24);
	StringRGBtoInt(g_szzoneStopColor, g_zoneStopColor);
	HookConVarChange(g_hzoneStopColor, OnSettingChanged);

	g_hStartPreSpeed = CreateConVar("ck_pre_start_speed", "320.0", "The maximum prespeed for start zones. 0.0 = No cap", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 3500.0);
	g_fStartPreSpeed = GetConVarFloat(g_hStartPreSpeed);
	HookConVarChange(g_hStartPreSpeed, OnSettingChanged);
	
	g_hSpeedPreSpeed = CreateConVar("ck_pre_speed_speed", "3000.0", "The maximum prespeed for speed start zones. 0.0 = No cap", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 3500.0);
	g_fSpeedPreSpeed = GetConVarFloat(g_hSpeedPreSpeed);
	HookConVarChange(g_hSpeedPreSpeed, OnSettingChanged);

	g_hBonusPreSpeed = CreateConVar("ck_pre_bonus_speed", "320.0", "The maximum prespeed for bonus start zones. 0.0 = No cap", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 3500.0);
	g_fBonusPreSpeed = GetConVarFloat(g_hBonusPreSpeed);
	HookConVarChange(g_hBonusPreSpeed, OnSettingChanged);
	
	g_hSpawnToStartZone = CreateConVar("ck_spawn_to_start_zone", "1.0", "1 = Automatically spawn to the start zone when the client joins the team.", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	bSpawnToStartZone = GetConVarBool(g_hSpawnToStartZone);
	HookConVarChange(g_hSpawnToStartZone, OnSettingChanged);	
	
	g_hSoundEnabled = CreateConVar("ck_startzone_sound_enabled", "1.0", "Enable the sound after leaving the start zone.", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	bSoundEnabled = GetConVarBool(g_hSoundEnabled);
	HookConVarChange(g_hSoundEnabled, OnSettingChanged);	
	
	g_hSoundPath = CreateConVar("ck_startzone_sound_path", "buttons/button3.wav", "The path to the sound file that plays after the client leaves the start zone..", FCVAR_PLUGIN|FCVAR_NOTIFY);
	GetConVarString(g_hSoundPath, sSoundPath, sizeof(sSoundPath));
	HookConVarChange(g_hSoundPath, OnSettingChanged);

	g_hAnnounceRank = CreateConVar("ck_min_rank_announce", "0.0", "Higher ranks than this won't be announced to the everyone on the server. 0 = Announce all records.", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0);
	g_AnnounceRank = GetConVarInt(g_hAnnounceRank);
	HookConVarChange(g_hAnnounceRank, OnSettingChanged);

	g_hForceCT = CreateConVar("ck_force_players_ct", "0.0", "Forces all players to join the CT team.", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bForceCT = GetConVarBool(g_hForceCT);
	HookConVarChange(g_hForceCT, OnSettingChanged);

	g_hChatSpamFilter = CreateConVar("ck_chat_spam_protection", "0.5", "The amount in seconds when a player can send a new message in chat. 0.0 = No filter.", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0);
	g_fChatSpamFilter = GetConVarFloat(g_hChatSpamFilter);
	HookConVarChange(g_hChatSpamFilter, OnSettingChanged);

	g_hAllowRoundEndCvar = CreateConVar("ck_round_end", "0", "on/off - Allows to end the current round", FCVAR_PLUGIN|FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_bAllowRoundEndCvar     = GetConVarBool(g_hAllowRoundEndCvar);
	HookConVarChange(g_hAllowRoundEndCvar, OnSettingChanged);

	db_setupDatabase();
	
	//client commands
	RegConsoleCmd("sm_usp", Client_Usp, "[ckSurf] spawns a usp silencer");
	RegConsoleCmd("sm_avg", Client_Avg, "[ckSurf] prints in chat the average time of the current map");
	RegConsoleCmd("sm_accept", Client_Accept, "[ckSurf] allows you to accept a challenge request");
	RegConsoleCmd("sm_hidechat", Client_HideChat, "[ckSurf] hides your ingame chat");
	RegConsoleCmd("sm_hideweapon", Client_HideWeapon, "[ckSurf] hides your weapon model");
	RegConsoleCmd("sm_goto", Client_GoTo, "[ckSurf] teleports you to a selected player");
	RegConsoleCmd("sm_language", Client_Language, "[ckSurf] select your language");
	RegConsoleCmd("sm_sound", Client_QuakeSounds,"[ckSurf] on/off quake sounds");
	RegConsoleCmd("sm_surrender", Client_Surrender, "[ckSurf] surrender your current challenge");
	RegConsoleCmd("sm_bhop", Client_AutoBhop,"[ckSurf] on/off autobhop");
	RegConsoleCmd("sm_help2", Client_RankingSystem,"[ckSurf] Explanation of the ckSurf ranking system");
	RegConsoleCmd("sm_flashlight", Client_Flashlight,"[ckSurf] on/off flashlight");
	RegConsoleCmd("sm_maptop", Client_MapTop,"[ckSurf] displays local map top for a given map");
	RegConsoleCmd("sm_hidespecs", Client_HideSpecs, "[ckSurf] hides spectators from menu/panel");
	RegConsoleCmd("sm_compare", Client_Compare, "[ckSurf] compare your challenge results");
	RegConsoleCmd("sm_wr", Client_Wr, "[ckSurf] prints records in chat");
	RegConsoleCmd("sm_measure",Command_Menu, "[ckSurf] allows you to measure the distance between 2 points");
	RegConsoleCmd("sm_abort", Client_Abort, "[ckSurf] abort your current challenge");
	RegConsoleCmd("sm_spec", Client_Spec, "[ckSurf] chooses a player who you want to spectate and switch you to spectators");
	RegConsoleCmd("sm_watch", Client_Spec, "[ckSurf] chooses a player who you want to spectate and switch you to spectators");
	RegConsoleCmd("sm_spectate", Client_Spec, "[ckSurf] chooses a player who you want to spectate and switch you to spectators");
	RegConsoleCmd("sm_challenge", Client_Challenge, "[ckSurf] allows you to start a race against others");
	RegConsoleCmd("sm_helpmenu", Client_Help, "[ckSurf] help menu which displays all ckSurf commands");
	RegConsoleCmd("sm_help", Client_Help, "[ckSurf] help menu which displays all ckSurf commands");
	RegConsoleCmd("sm_profile", Client_Profile, "[ckSurf] opens a player profile");
	RegConsoleCmd("sm_rank", Client_Profile, "[ckSurf] opens a player profile");
	RegConsoleCmd("sm_options", Client_OptionMenu, "[ckSurf] opens options menu");
	RegConsoleCmd("sm_top", Client_Top, "[ckSurf] displays top rankings (Top 100 Players, Top 50 overall)");
	RegConsoleCmd("sm_topclimbers", Client_Top, "[ckSurf] displays top rankings (Top 100 Players, Top 50 overall)");
	RegConsoleCmd("sm_stop", Client_Stop, "[ckSurf] stops your timer");
	RegConsoleCmd("sm_ranks", Client_Ranks, "[ckSurf] prints in chat the available player ranks");
	RegConsoleCmd("sm_pause", Client_Pause,"[ckSurf] on/off pause (timer on hold and movement frozen)");
	RegConsoleCmd("sm_showsettings", Client_Showsettings,"[ckSurf] shows ckSurf server settings");
	RegConsoleCmd("sm_latest", Client_Latest,"[ckSurf] shows latest map records");
	RegConsoleCmd("sm_showtime", Client_Showtime,"[ckSurf] on/off - timer text in panel/menu");	
	RegConsoleCmd("sm_hide", Client_Hide, "[ckSurf] on/off - hides other players");
	RegConsoleCmd("sm_togglecheckpoints", ToggleCheckpoints, "[ckSurf] on/off - Enable player checkpoints");
	RegConsoleCmd("+noclip", NoClip, "[ckSurf] Player noclip on");
	RegConsoleCmd("-noclip", UnNoClip, "[ckSurf] Player noclip off");

	// Teleportation commands
	RegConsoleCmd("sm_stages", Command_SelectStage, "[ckSurf] Opens up the stage selector");
	RegConsoleCmd("sm_r", Command_Restart, "[ckSurf] Teleports player back to the start");
	RegConsoleCmd("sm_restart", Command_Restart, "[ckSurf] Teleports player back to the start");
	RegConsoleCmd("sm_start", Command_Restart, "[ckSurf] Teleports player back to the start");
	RegConsoleCmd("sm_play", Command_Teleport, "[ckSurf] Teleports player back to the start");
	RegConsoleCmd("sm_spawn", Command_Teleport, "[ckSurf] Teleports player back to the start");
	RegConsoleCmd("sm_b", Command_ToBonus, "[ckSurf] Teleports player back to the start");
	RegConsoleCmd("sm_bonus", Command_ToBonus, "[ckSurf] Teleports player back to the start");
	RegConsoleCmd("sm_s", Command_ToStage, "[ckSurf] Teleports player to the selected stage");
	RegConsoleCmd("sm_stage", Command_ToStage, "[ckSurf] Teleports player to the selected stage");
	
	// MISC
	RegConsoleCmd("sm_tier", Command_Tier, "[ckSurf] Prints information on the current map");
	RegConsoleCmd("sm_mapinfo", Command_Tier, "[ckSurf] Prints information on the current map");
	RegConsoleCmd("sm_mi", Command_Tier, "[ckSurf] Prints information on the current map");
	RegConsoleCmd("sm_m", Command_Tier, "[ckSurf] Prints information on the current map");
	RegConsoleCmd("sm_difficulty", Command_Tier, "[ckSurf] Prints information on the current map");
	RegConsoleCmd("sm_howto", Command_HowTo, "[ckSurf] Displays a youtube video on how to surf");

	// Teleport to the start of the stage
	RegConsoleCmd("sm_stuck", Command_Teleport, "[ckSurf] Teleports player back to the start of the stage");
	RegConsoleCmd("sm_back", Command_Teleport, "[ckSurf] Teleports player back to the start of the stage");

	// Player Checkpoints
	RegConsoleCmd("sm_teleport", Command_goToPlayerCheckpoint, "[ckSurf] Teleports player to his last checkpoint");
	RegConsoleCmd("sm_tele", Command_goToPlayerCheckpoint, "[ckSurf] Teleports player to his last checkpoint");
	RegConsoleCmd("sm_prac", Command_goToPlayerCheckpoint, "[ckSurf] Teleports player to his last checkpoint");
	RegConsoleCmd("sm_practice", Command_goToPlayerCheckpoint, "[ckSurf] Teleports player to his last checkpoint");

	RegConsoleCmd("sm_cp", Command_createPlayerCheckpoint, "[ckSurf] Creates a checkpoint, where the player can teleport back to");
	RegConsoleCmd("sm_checkpoint", Command_createPlayerCheckpoint, "[ckSurf] Creates a checkpoint, where the player can teleport back to");
	RegConsoleCmd("sm_undo", Command_undoPlayerCheckpoint, "[ckSurf] Undoes the players last checkpoint.");
	RegConsoleCmd("sm_normal", Command_normalMode, "[ckSurf] Switches player back to normal mode.")
	RegConsoleCmd("sm_n", Command_normalMode, "[ckSurf] Switches player back to normal mode.")

	RegAdminCmd("sm_ckadmin", Admin_ckPanel, ADMIN_LEVEL, "[ckSurf] Displays the ckSurf menu panel");
	RegAdminCmd("sm_refreshprofile", Admin_RefreshProfile, ADMIN_LEVEL, "[ckSurf] Recalculates player profile for given steam id");
	RegAdminCmd("sm_resetchallenges", Admin_DropChallenges, ADMIN_LEVEL2, "[ckSurf] Resets all player challenges (drops table challenges) - requires z flag");
	RegAdminCmd("sm_resettimes", Admin_DropAllMapRecords, ADMIN_LEVEL2, "[ckSurf] Resets all player times (drops table playertimes) - requires z flag");
	RegAdminCmd("sm_resetranks", Admin_DropPlayerRanks, ADMIN_LEVEL2, "[ckSurf] Resets the all player points  (drops table playerrank - requires z flag)");
	RegAdminCmd("sm_resetmaptimes", Admin_ResetMapRecords, ADMIN_LEVEL2, "[ckSurf] Resets player times for given map - requires z flag");
	RegAdminCmd("sm_resetplayerchallenges", Admin_ResetChallenges, ADMIN_LEVEL2, "[ckSurf] Resets (won) challenges for given steamid - requires z flag");
	RegAdminCmd("sm_resetplayertimes", Admin_ResetRecords, ADMIN_LEVEL2, "[ckSurf] Resets pro map times (+extrapoints) for given steamid with or without given map - requires z flag");
	RegAdminCmd("sm_resetplayermaptime", Admin_ResetMapRecord, ADMIN_LEVEL2, "[ckSurf] Resets pro map time for given steamid and map - requires z flag");
	RegAdminCmd("sm_deleteproreplay", Admin_DeleteMapReplay, ADMIN_LEVEL2, "[ckSurf] Deletes pro replay for a given map - requires z flag");
	RegAdminCmd("sm_resetextrapoints", Admin_ResetExtraPoints, ADMIN_LEVEL2, "[ckSurf] Resets given extra points for all players with or without given steamid");	
	RegAdminCmd("sm_deletebonus", Admin_DeleteBonus, ADMIN_LEVEL2, "[ckSurf] Reset bonus times on  current map");
	RegAdminCmd("sm_deletecheckpoints", Admin_DeleteCheckpoints, ADMIN_LEVEL2, "[ckSurf] Reset checkpoints on the current map");
	RegAdminCmd("sm_insertmaptiers", Admin_InsertMapTiers, ADMIN_LEVEL2, "[ckSurf] Insert premade maptier information into the database (ONLY RUN THIS ONCE)");
	RegAdminCmd("sm_insertmapzones", Admin_InsertMapZones, ADMIN_LEVEL2, "[ckSurf] Insert premade map zones into the database (ONLY RUN THIS ONCE)");
	RegAdminCmd("sm_zones", Command_Zones, ADMIN_LEVEL2);

	RegAdminCmd("sm_addmaptier", Admin_insertMapTier, ADMIN_LEVEL, "[ckSurf] Changes maps tier");
	RegAdminCmd("sm_amt", Admin_insertMapTier, ADMIN_LEVEL, "[ckSurf] Changes maps tier");
	RegAdminCmd("sm_addspawn", Admin_insertSpawnLocation, ADMIN_LEVEL, "[ckSurf] Changes the position !r takes players to");
	RegAdminCmd("sm_delspawn", Admin_deleteSpawnLocation, ADMIN_LEVEL, "[ckSurf] Removes custom !r position");
	RegAdminCmd("sm_clearassists", Admin_ClearAssists, ADMIN_LEVEL, "[ckSurf] Clears assist points (map progress) from all players");

	//chat command listener
	AddCommandListener(Say_Hook, "say");
	AddCommandListener(Say_Hook, "say_team");

	//exec ckSurf.cfg
	AutoExecConfig(true, "ckSurf");
	
	//mic
	g_ownerOffset = FindSendPropOffs("CBaseCombatWeapon", "m_hOwnerEntity");
	g_ragdolls = FindSendPropOffs("CCSPlayer","m_hRagdoll");
		
	//Credits: Measure by DaFox
	//https://forums.alliedmods.net/showthread.php?t=88830
	g_hMainMenu = CreateMenu(Handler_MainMenu);
	SetMenuTitle(g_hMainMenu,"ckSurf - Measure");
	AddMenuItem(g_hMainMenu,"","Point 1 (Red)");
	AddMenuItem(g_hMainMenu,"","Point 2 (Green)");
	AddMenuItem(g_hMainMenu,"","Find Distance");
	AddMenuItem(g_hMainMenu,"","Reset");
	
	//add to admin menu
	new Handle:topmenu;
	if (LibraryExists("adminmenu") && ((topmenu = GetAdminTopMenu()) != INVALID_HANDLE))
		OnAdminMenuReady(topmenu);
	
	//hooks
	HookEvent("player_spawn", Event_OnPlayerSpawn, EventHookMode_Post);
	HookEvent("player_death", Event_OnPlayerDeath);
	HookEvent("round_start",Event_OnRoundStart,EventHookMode_PostNoCopy);
	HookEvent("round_end", Event_OnRoundEnd, EventHookMode_Pre);
	HookEvent("player_hurt", Event_OnPlayerHurt);
	HookEvent("player_jump", Event_OnJump, EventHookMode_Pre);
	HookEvent("weapon_fire",  Event_OnFire, EventHookMode_Pre);
	HookEvent("player_team", Event_OnPlayerTeam, EventHookMode_Post);
	HookEvent("jointeam_failed", Event_JoinTeamFailed, EventHookMode_Pre);
	HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre); 

	//mapcycle array
	new arraySize = ByteCountToCells(PLATFORM_MAX_PATH);
	g_MapList = CreateArray(arraySize);	
		
	//add command listeners	
	AddCommandListener(Command_JoinTeam, "jointeam");
	AddCommandListener(Command_ext_Menu, "radio1");
	AddCommandListener(Command_ext_Menu, "radio2");
	AddCommandListener(Command_ext_Menu, "radio3");
	AddCommandListener(Command_ext_Menu, "sm_nominate");
	AddCommandListener(Command_ext_Menu, "sm_admin");
	AddCommandListener(Command_ext_Menu, "sm_votekick");
	AddCommandListener(Command_ext_Menu, "sm_voteban");
	AddCommandListener(Command_ext_Menu, "sm_votemenu");
	AddCommandListener(Command_ext_Menu, "sm_revote");

	//hook radio commands
	for(new g; g < sizeof(RadioCMDS); g++)
		AddCommandListener(BlockRadio, RadioCMDS[g]);

	//button sound hook
	AddNormalSoundHook(NormalSHook_callback);
	
	//nav files
	CreateNavFiles();
	
	// Botmimic 2
	// https://forums.alliedmods.net/showthread.php?t=180114
	// Optionally setup a hook on CBaseEntity::Teleport to keep track of sudden place changes
	CheatFlag("bot_zombie", false, true);
	CheatFlag("bot_mimic", false, true);
	g_hLoadedRecordsAdditionalTeleport = CreateTrie();
	new Handle:hGameData = LoadGameConfigFile("sdktools.games");
	if(hGameData == INVALID_HANDLE) 
	{
		SetFailState("GameConfigFile sdkhooks.games was not found.");
		return;
	}
	new iOffset = GameConfGetOffset(hGameData, "Teleport");
	CloseHandle(hGameData);
	if(iOffset == -1)
		return;
	
	if(LibraryExists("dhooks"))
	{
		g_hTeleport = DHookCreate(iOffset, HookType_Entity, ReturnType_Void, ThisPointer_CBaseEntity, DHooks_OnTeleport);
		if(g_hTeleport == INVALID_HANDLE)
			return;
		DHookAddParam(g_hTeleport, HookParamType_VectorPtr);
		DHookAddParam(g_hTeleport, HookParamType_ObjectPtr);
		DHookAddParam(g_hTeleport, HookParamType_VectorPtr);
		DHookAddParam(g_hTeleport, HookParamType_Bool);
	}
		 		
	if(g_bLateLoaded) 
	{ 
		//OnPluginPauseChange(false);	
		CreateTimer(3.0, LoadPlayerSettings, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE);
	}	
}

