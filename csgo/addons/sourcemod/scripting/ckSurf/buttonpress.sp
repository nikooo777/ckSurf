
// - Climb Button OnStartPress -
public CL_OnStartTimerPress(client)
{	
	if (!IsFakeClient(client))
	{	
		if (g_bNewReplay[client])
			return;
	}			
	
	//sound
	PlayButtonSound(client);
	
	new Float:time;
	time = GetEngineTime() - g_fLastTimeNoClipUsed[client];

	//start recording
	if (!IsFakeClient(client) && g_bReplayBot)
	{
		if (!IsPlayerAlive(client) || GetClientTeam(client) == 1)
		{
			if(g_hRecording[client] != INVALID_HANDLE)
				StopRecording(client);
		}
		else
		{	
			if(g_hRecording[client] != INVALID_HANDLE)
				StopRecording(client);
			StartRecording(client);
		}
	}			
	if (!g_bSpectate[client] && !g_bNoClip[client] && time > 2.0) 
	{
		if (g_bActivateCheckpointsOnStart[client])
			g_bCheckpointsEnabled[client] = true;
		tmpDiff[client] = 9999.0;
		g_fPauseTime[client] = 0.0;
		g_fStartPauseTime[client] = 0.0;
		g_bPause[client] = false;
		SetEntityMoveType(client, MOVETYPE_WALK);
		SetEntityRenderMode(client, RENDER_NORMAL);
		g_fStartTime[client] = GetEngineTime();
		g_bMenuOpen[client] = false;		
		g_bTopMenuOpen[client] = false;	
		g_bPositionRestored[client] = false;
		g_bMissedMapBest[client] = true;
		g_bMissedBonusBest[client] = true;
		g_bTimeractivated[client] = true;		
		decl String:szTime[32];
		
		for (new i = 0; i<20; i++)
			g_fCheckpointTimesNew[client][i]=0.0;
		//valid players
		if (!IsFakeClient(client))
		{	
			//Get start position
			GetClientAbsOrigin(client, g_fPlayerCordsRestart[client]);
			GetClientEyeAngles(client, g_fPlayerAnglesRestart[client]);		

			//star message
			decl String:szProTime[32];
			decl String:szBonusTime[32];
			if (g_fPersonalRecord[client]<=0.0)
					Format(szProTime, 32, "NONE");
			else
			{
				if (!g_bBonusTimer[client])
					g_bMissedMapBest[client] = false;
				FormatTimeFloat(client, g_fPersonalRecord[client], 3, szTime, sizeof(szTime));
				Format(szProTime, 32, "%s (#%i/%i)", szTime,g_MapRank[client],g_MapTimesCount);
			}
			// Bonus
			if (g_mapZonesTypeCount[3] > 0)
			{
				if (g_fPersonalRecordBonus[client] <= 0.0)
					Format(szBonusTime, 32, "NONE");
				else
				{
					g_bMissedBonusBest[client] = false;
					FormatTimeFloat(client, g_fPersonalRecordBonus[client], 3, szTime, sizeof(szTime));
					Format(szBonusTime, 32, "%s (#%i/%i)", szTime, g_MapRankBonus[client], g_iBonusCount);
				}
			}
			g_fLastOverlay[client] = GetEngineTime()-2.5;

			if (g_bFirstButtonTouch[client])
			{
				g_bFirstButtonTouch[client]=false;
				Client_Avg(client, 0);
			}				
		}	
	}
}

// - Climb Button OnEndPress -
public CL_OnEndTimerPress(client)
{
	//Format Final Time
	if (IsFakeClient(client) && g_bTimeractivated[client])
	{
		for(new i = 1; i <= MaxClients; i++) 
		{
			if (IsValidClient(i) && !IsPlayerAlive(i))
			{			
				new SpecMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
				if (SpecMode == 4 || SpecMode == 5)
				{		
					new Target = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");	
					if (Target == client)
					{
						if (Target == g_RecordBot)
							PrintToChat(i, "%t", "ReplayFinishingMsg", MOSSGREEN,WHITE,LIMEGREEN,g_szReplayName,GRAY,LIMEGREEN,g_szReplayTime,GRAY);
						if (Target == g_BonusBot)
							PrintToChat(i, "%t", "ReplayFinishingMsg", MOSSGREEN,WHITE,LIMEGREEN,g_szReplayName,GRAY,LIMEGREEN,g_szBonusTime,GRAY);

					}
				}					
			}		
		}	
		PlayButtonSound(client);
		g_bTimeractivated[client] = false;	
		return;
	}

	if (!g_bTimeractivated[client]) 
	{
		decl Float:diff; 
		diff = GetEngineTime() - g_fLastTimeButtonSound[client];
		if (diff > 0.1)
			PlayButtonSound(client);
		g_fLastTimeButtonSound[client] = GetEngineTime();
		return;	
	}	

	//timer pos
	if (g_bFirstEndButtonPush && !IsFakeClient(client))
	{
		GetClientAbsOrigin(client,g_fEndButtonPos);
		g_bFirstEndButtonPush=false;
	}				
	
	//sound
	if (g_bTimeractivated[client])
		PlayButtonSound(client);	
	
	//decl
	new String:szName[MAX_NAME_LENGTH];	
	new String:szNameOpponent[MAX_NAME_LENGTH];	
	new String:szTime[32];
	new bool:hasRecord=false;
	new Float: difference;
	g_FinishingType[client] = -1;
	g_Sound_Type[client] = -1;
	g_bMapRankToChat[client] = true;
	if (!IsValidClient(client))
		return;	
	GetClientName(client, szName, MAX_NAME_LENGTH);
	
	//Final time
	g_fFinalTime[client] = GetEngineTime() - g_fStartTime[client] - g_fPauseTime[client];			
	g_bTimeractivated[client] = false;	
	FormatTimeFloat(client, g_fFinalTime[client], 3, szTime, sizeof(szTime));
	Format(g_szFinalTime[client], 32, "%s", szTime);
	g_bOverlay[client]=true;
	g_fLastOverlay[client] = GetEngineTime();
	PrintHintText(client,"%t", "TimerStopped", g_szFinalTime[client]);
	
	// Bonus
	new bool:FirstRecord = false;
	new bool:PBRecord = false;
	new bool:SRVRecord = false;
	new String:szDiff[54];
	new Float:diff;	

	// If used teleports
	if(g_bCheckpointMode[client])
	{
		if(g_bBonusTimer[client])
			PrintToChat(client, "[%cCK%c] %c%s %cfinished the bonus with a time of [%c%s%c] in practice mode!", MOSSGREEN, WHITE, MOSSGREEN, szName, WHITE, LIGHTBLUE, szTime, WHITE);
		else
			PrintToChat(client, "[%cCK%c] %c%s %cfinished the map with a time of [%c%s%c] in practice mode!", MOSSGREEN, WHITE, MOSSGREEN, szName, WHITE, LIGHTBLUE, szTime, WHITE);
	
		return;
	}

	if (!g_bBonusTimer[client])
	{
		CS_SetClientAssists(client, 100);

		if (g_fPersonalRecord[client] > 0.0)
		{
			hasRecord=true;
			difference = g_fPersonalRecord[client] - g_fFinalTime[client];
			FormatTimeFloat(client, difference, 3, szTime, sizeof(szTime));
		}
		else
		{	
			if (g_bCheckpointsEnabled[client])
				db_UpdateCheckpoints(client, g_szSteamID[client]);
			g_pr_finishedmaps[client]++;
		}
		new bool: newbest;
		if (hasRecord)
		{
			if (difference > 0.0)
			{
				if (g_ExtraPoints > 0)
					g_pr_multiplier[client]+=1; // Improved time, increase multip
				Format(g_szTimeDifference[client], 32, "-%s", szTime);

				if (g_bCheckpointsEnabled[client])
					db_UpdateCheckpoints(client, g_szSteamID[client]);
				newbest=true;
			}
			else
				Format(g_szTimeDifference[client], 32, "+%s", szTime);
		}
		
		//Type of time
		if (!hasRecord)
		{
			g_Time_Type[client] = 1;
			g_MapTimesCount++;
		}
		else
		{
			if (difference> 0.0)
			{
				g_Time_Type[client] = 3;
			}
			else
			{
				g_Time_Type[client] = 5;
			}
		}
		
		//NEW MAP RECORD
		if((g_fFinalTime[client] < g_fRecordMapTime))
		{
			if (g_FinishingType[client] != 3 && g_FinishingType[client] != 4 && g_FinishingType[client] != 5)
				g_FinishingType[client] = 2;
			g_fRecordMapTime = g_fFinalTime[client]; 
			Format(g_szRecordPlayer, MAX_NAME_LENGTH, "%s", szName);
			if (g_Sound_Type[client] != 1)
				g_Sound_Type[client] = 2;
				
			//save replay	
			if (g_bReplayBot && !g_bPositionRestored[client])
			{
				g_bNewReplay[client]=true;
				CreateTimer(3.0, ReplayTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			}
			db_InsertLatestRecords(g_szSteamID[client], szName, g_fFinalTime[client]);
			
			// Update Checkpoints
			if (g_bCheckpointsEnabled[client])
			{
				for (new i = 0; i < 20; i++) 
				{
					g_fCheckpointServerRecord[i] = g_fCheckpointTimesNew[client][i];
				}
			}
		} 
		
		if (newbest && g_Sound_Type[client] == -1)
			g_Sound_Type[client] = 5;
				
		//Challenge
		if (g_bChallenge[client])
		{
			SetEntityRenderColor(client, 255,255,255,255);		
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && i != client && i != g_RecordBot && i != g_BonusBot)
				{				
					if (StrEqual(g_szSteamID[i],g_szChallenge_OpponentID[client]))
					{	
						g_bChallenge[client]=false;
						g_bChallenge[i]=false;
						SetEntityRenderColor(i, 255,255,255,255);
						db_insertPlayerChallenge(client);
						GetClientName(i, szNameOpponent, MAX_NAME_LENGTH);	
						for (new k = 1; k <= MaxClients; k++)
							if (IsValidClient(k))
								PrintToChat(k, "%t", "ChallengeW", RED,WHITE,MOSSGREEN,szName,WHITE,MOSSGREEN,szNameOpponent,WHITE); 			
						if (g_Challenge_Bet[client]>0)
						{										
							new lostpoints = g_Challenge_Bet[client] * g_pr_PointUnit;
							for (new j = 1; j <= MaxClients; j++)
								if (IsValidClient(j))
									PrintToChat(j, "%t", "ChallengeL", MOSSGREEN, WHITE, PURPLE,szNameOpponent, GRAY, RED, lostpoints,GRAY);		
							CreateTimer(0.5, UpdatePlayerProfile, i,TIMER_FLAG_NO_MAPCHANGE);
							g_pr_showmsg[client] = true;
						}					
						break;
					}
				}
			}		
		}
	}
	else 
	{ // Handling bonus
		
		diff = g_fPersonalRecordBonus[client] - g_fFinalTime[client];
		FormatTimeFloat(client, diff, 3, szDiff ,sizeof(szDiff));
		if (diff > 0.0)
			Format(szDiff, sizeof(szDiff), "-%s", szDiff);
		else
			Format(szDiff, sizeof(szDiff), "+%s", szDiff);
		g_tmpBonusCount = g_iBonusCount;
		if (g_iBonusCount > 0)
		{ // If the server already has a record
			if (g_fFinalTime[client] < g_fBonusFastest)
			{	// New fastest time in current map
				g_fOldBonusRecordTime = g_fBonusFastest;
				SRVRecord = true;
				if (g_bBonusBot && !g_bPositionRestored[client])
				{
					g_bNewBonus[client]=true;
					CreateTimer(3.0, BonusReplayTimer, client,TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		else 
		{ // Has to be the new record, since it is the first completion
			if (g_bBonusBot && !g_bPositionRestored[client])
			{
				g_bNewReplay[client]=true;
				CreateTimer(3.0, BonusReplayTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			}
			SRVRecord = true;
			g_fOldBonusRecordTime = g_fBonusFastest;
		}
		if (g_fPersonalRecordBonus[client] == 0.0)  
		{ // Clients first record
			FirstRecord = true;
			g_pr_showmsg[client] = true;
			//g_PersonalBonusCompleted[client]++;
			db_insertBonus(client, g_szSteamID[client], szName, g_fFinalTime[client]);
		}
		if (diff > 0.0) 
		{ // Client's new record
			PBRecord = true;
			db_updateBonus(client, g_szSteamID[client], szName, g_fFinalTime[client]);
		}
		db_viewPersonalBonusRecords(client, g_szSteamID[client]);
		db_viewMapRankBonus(client);
	}
	//set mvp star
	g_MVPStars[client] += 1;
	CS_SetMVPCount(client,g_MVPStars[client]);		
	
	//local db update
	if (!g_bBonusTimer[client])
	{
		// New personal record
		if ((g_fFinalTime[client] < g_fPersonalRecord[client] || g_fPersonalRecord[client] <= 0.0 ))
		{
			g_pr_showmsg[client] = true;
			db_selectRecord(client);
		}
		else
		{
			// for ck_min_rank_announce
			db_currentRunRank(client);
		}
		db_deleteTmp(client);
	} 
	else //BONUS
	{ 	
		if (FirstRecord || PBRecord || SRVRecord) 
		{
			new Handle:pack;
			CreateDataTimer(1.0, PrintChatBonus, pack);
			WritePackCell(pack, FirstRecord);
			WritePackCell(pack, PBRecord);
			WritePackCell(pack, SRVRecord);
			WritePackCell(pack, client);
			WritePackString(pack, szName);
			WritePackString(pack, szTime);
			WritePackString(pack, szDiff);
		}
		else // No new records, just printing out the stats
		{ 
			PrintToChatAll("%t", "BonusFinished1",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,YELLOW,GRAY,RED,szTime,GRAY,RED,szDiff,GRAY,LIMEGREEN,g_MapRankBonus[client],GRAY,g_iBonusCount,LIMEGREEN,szBonusFastestTime,GRAY);	
		}
	}
	g_bBonusTimer[client] = false;
}

public Action:PrintChatBonus(Handle:timer, Handle:pack)
{
	new bool:FirstRecord;
	new bool:PBRecord;
	new bool:SRVRecord;
	new client;
	new String:szName[32];
	new String:szTime[32];
	new String:szDiff[32];

	new String:szRecordDiff[54];
	new Float:RecordDiff;

	ResetPack(pack);
	FirstRecord = ReadPackCell(pack);
	PBRecord = ReadPackCell(pack);
	SRVRecord = ReadPackCell(pack);
	client = ReadPackCell(pack);
	ReadPackString(pack, szName, sizeof(szName));
	ReadPackString(pack, szTime, sizeof(szTime));
	ReadPackString(pack, szDiff, sizeof(szDiff));

	if (SRVRecord) 
	{
		RecordDiff = g_fOldBonusRecordTime - g_fFinalTime[client];
		FormatTimeFloat(client, RecordDiff, 3, szRecordDiff, 54);
		Format(szRecordDiff, 54, "-%s", szRecordDiff);					
	}
	if (FirstRecord && SRVRecord)
	{
		PlayRecordSound(1);
		g_pr_showmsg[client] = true;
		PrintToChatAll("%t", "BonusFinished2",MOSSGREEN,WHITE,LIMEGREEN,szName,YELLOW);
		if (g_tmpBonusCount == 0)
			PrintToChatAll("%t", "BonusFinished3",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,YELLOW,GRAY,LIMEGREEN,szTime,GRAY,LIMEGREEN,WHITE,LIMEGREEN,szTime,WHITE);	
		else
			PrintToChatAll("%t", "BonusFinished4",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,YELLOW,GRAY,LIMEGREEN,szTime,GRAY,LIMEGREEN,szRecordDiff,GRAY,LIMEGREEN,g_MapRankBonus[client],GRAY,g_iBonusCount,LIMEGREEN,szTime,WHITE); 	
	}
	if (PBRecord && SRVRecord)
	{
		PlayRecordSound(1);
		PrintToChatAll("%t", "BonusFinished2", MOSSGREEN,WHITE,LIMEGREEN,szName,YELLOW);
		PrintToChatAll("%t", "BonusFinished5",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,YELLOW,GRAY,LIMEGREEN,szTime,GRAY,LIMEGREEN,szRecordDiff,GRAY,LIMEGREEN,g_MapRankBonus[client],GRAY,g_iBonusCount,LIMEGREEN,szTime,WHITE);  	
	}
	if (PBRecord && !SRVRecord)
	{
		PlayUnstoppableSound(client);
		PrintToChatAll("%t", "BonusFinished6",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,YELLOW,GRAY,LIMEGREEN,szTime,GRAY,LIMEGREEN,szDiff,GRAY,LIMEGREEN,g_MapRankBonus[client],GRAY,g_iBonusCount,LIMEGREEN,szBonusFastestTime,WHITE);
	}
	if (FirstRecord && !SRVRecord)
	{
		g_pr_showmsg[client] = true;
		PrintToChatAll("%t", "BonusFinished7",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,YELLOW,GRAY,LIMEGREEN,szTime,GRAY,LIMEGREEN,g_MapRankBonus[client],GRAY,g_iBonusCount,LIMEGREEN,szBonusFastestTime,WHITE);	
	}
}