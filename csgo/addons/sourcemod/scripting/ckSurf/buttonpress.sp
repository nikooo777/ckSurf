
// - Climb Button OnStartPress -
public CL_OnStartTimerPress(client)
{	
	if (!IsFakeClient(client))
	{	
		if (g_bNewReplay[client])
			return;
		if (g_bNewBonus[client])
			return;
	}
	g_Stage[g_iClientInZone[client][2]][client] = 1;
	float time;
	time = GetGameTime() - g_fLastTimeNoClipUsed[client];

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
		g_fStartTime[client] = GetGameTime();
		g_bPositionRestored[client] = false;
		g_bMissedMapBest[client] = true;
		g_bMissedBonusBest[client] = true;
		g_bTimeractivated[client] = true;

		//valid players
		if (!IsFakeClient(client))
		{
			//Get start position
			GetClientAbsOrigin(client, g_fPlayerCordsRestart[client]);
			GetClientEyeAngles(client, g_fPlayerAnglesRestart[client]);		

			//star message
			if (g_iClientInZone[client][2] == 0)
			{
				if (g_fPersonalRecord[client] > 0.0)
					g_bMissedMapBest[client] = false;
			}
			else
			{
				if (g_fPersonalRecordBonus[g_iClientInZone[client][2]][client] > 0.0)
					g_bMissedBonusBest[client] = false;

			}


			g_fLastOverlay[client] = GetGameTime()-2.5;

			if (g_bFirstButtonTouch[client])
			{
				g_bFirstButtonTouch[client]=false;
				Client_Avg(client, 0);
			}				
		}	
	}

	//sound
	PlayButtonSound(client);
	
	//start recording
	if (!IsFakeClient(client) && g_bReplayBot ||!IsFakeClient(client) && g_bBonusBot)
	{
		if (!IsPlayerAlive(client) || GetClientTeam(client) == 1)
		{
			if(g_hRecording[client] != null)
				StopRecording(client);
		}
		else
		{	
			if(g_hRecording[client] != null)
				StopRecording(client);
			StartRecording(client);
		}
	}			

	for (int i = 0; i < CPLIMIT; i++)
		g_fCheckpointTimesNew[g_iClientInZone[client][2]][client][i]=0.0;
}

// - Climb Button OnEndPress -
public CL_OnEndTimerPress(client)
{
	//Format Final Time
	if (IsFakeClient(client) && g_bTimeractivated[client])
	{
		for(int i = 1; i <= MaxClients; i++) 
		{
			if (IsValidClient(i) && !IsPlayerAlive(i))
			{			
				int SpecMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
				if (SpecMode == 4 || SpecMode == 5)
				{		
					int Target = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");	
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
		float diff; 
		diff = GetGameTime() - g_fLastTimeButtonSound[client];
		if (diff > 0.1)
			PlayButtonSound(client);
		g_fLastTimeButtonSound[client] = GetGameTime();
		return;	
	}	

	//sound
	if (g_bTimeractivated[client])
		PlayButtonSound(client);	
	
	char szName[MAX_NAME_LENGTH];	
	char szNameOpponent[MAX_NAME_LENGTH];	
	char szTime[32];
	bool hasRecord=false;
	float  difference;
	g_Sound_Type[client] = -1;
	g_bnewRecord[client] = false;
	g_bMapRankToChat[client] = true;
	if (!IsValidClient(client))
		return;	
	GetClientName(client, szName, MAX_NAME_LENGTH);
	
	//Final time
	g_fFinalTime[client] = GetGameTime() - g_fStartTime[client] - g_fPauseTime[client];	
	
	g_bTimeractivated[client] = false;
	int zGroup = g_iClientInZone[client][2];
	FormatTimeFloat(client, g_fFinalTime[client], 3, szTime, sizeof(szTime));
	Format(g_szFinalTime[client], 32, "%s", szTime);
	g_bOverlay[client]=true;
	g_fLastOverlay[client] = GetGameTime();
	PrintHintText(client,"%t", "TimerStopped", g_szFinalTime[client]);

	char szDiff[54];
	float diff;	

	// If used teleports
	if(g_bPracticeMode[client])
	{
		if(g_iClientInZone[client][2] > 0)
			PrintToChat(client, "[%cCK%c] %c%s %cfinished the bonus with a time of [%c%s%c] in practice mode!", MOSSGREEN, WHITE, MOSSGREEN, szName, WHITE, LIGHTBLUE, szTime, WHITE);
		else
			PrintToChat(client, "[%cCK%c] %c%s %cfinished the map with a time of [%c%s%c] in practice mode!", MOSSGREEN, WHITE, MOSSGREEN, szName, WHITE, LIGHTBLUE, szTime, WHITE);
	
		/* Start function call */
		Call_StartForward(g_PracticeFinishForward);

		/* Push parameters one at a time */
		Call_PushCell(client);
		Call_PushFloat(g_fFinalTime[client]);
		Call_PushString(szTime);

		/* Finish the call, get the result */
		Call_Finish();
 
		return;
	}

	if (g_iClientInZone[client][2] == 0)
	{
		CS_SetClientAssists(client, 100);

		if (g_fPersonalRecord[client] > 0.0) // client has finished the map before
		{
			hasRecord=true;
			difference = g_fPersonalRecord[client] - g_fFinalTime[client];
			FormatTimeFloat(client, difference, 3, szTime, sizeof(szTime));
		}
		else // Finishing the map for the first time
		{	
			if (g_bCheckpointsEnabled[client] && !g_bPositionRestored[client])
				db_UpdateCheckpoints(client, g_szSteamID[client], zGroup);
			g_pr_finishedmaps[client]++;
		}

		bool  newbest;
		if (hasRecord)
		{
			if (difference > 0.0) // Time is client's new record
			{
				if (g_ExtraPoints > 0)
					g_pr_multiplier[client]+=1; // Improved time, increase multip
				Format(g_szTimeDifference[client], 32, "-%s", szTime);

				if (g_bCheckpointsEnabled[client] && !g_bPositionRestored[client])
					db_UpdateCheckpoints(client, g_szSteamID[client], zGroup);
				newbest=true;
			}
			else // No new record
				Format(g_szTimeDifference[client], 32, "+%s", szTime);
		}

		// Time types: 1 = Clients first record, 3 = Clients new personal record, 5 = No new records.
		
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
		
		// Check if clients time is the fastest in the map
		if((g_fFinalTime[client] < g_fRecordMapTime)) 
		{
			g_bnewRecord[client] = true;
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
			if (g_bCheckpointsEnabled[client] && !g_bPositionRestored[client])
			{
				for (int i = 0; i < CPLIMIT; i++) 
				{
					g_fCheckpointServerRecord[zGroup][i] = g_fCheckpointTimesNew[zGroup][client][i];
				}
				g_bCheckpointRecordFound[zGroup] = true;
			}
		}
		
		if (newbest && g_Sound_Type[client] == -1)
			g_Sound_Type[client] = 5;
				
		//Challenge
		if (g_bChallenge[client])
		{
			SetEntityRenderColor(client, 255,255,255,255);		
			for (int i = 1; i <= MaxClients; i++)
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
						for (int k = 1; k <= MaxClients; k++)
							if (IsValidClient(k))
								PrintToChat(k, "%t", "ChallengeW", RED,WHITE,MOSSGREEN,szName,WHITE,MOSSGREEN,szNameOpponent,WHITE); 	

						if (g_Challenge_Bet[client]>0)
						{										
							int lostpoints = g_Challenge_Bet[client] * g_pr_PointUnit;
							for (int j = 1; j <= MaxClients; j++)
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
	else 
	{ // Handling bonus

		// Record bools init
		g_bBonusFirstRecord[client] = false;
		g_bBonusPBRecord[client] = false;
		g_bBonusSRVRecord[client] = false;

		g_OldMapRankBonus[zGroup][client] = g_MapRankBonus[zGroup][client];
	
		diff = g_fPersonalRecordBonus[zGroup][client] - g_fFinalTime[client];
		FormatTimeFloat(client, diff, 3, szDiff ,sizeof(szDiff));
		if (diff > 0.0)
			Format(g_szBonusTimeDifference[client], sizeof(szDiff), "-%s", szDiff);
		else
			Format(g_szBonusTimeDifference[client], sizeof(szDiff), "+%s", szDiff);


		g_tmpBonusCount[zGroup] = g_iBonusCount[zGroup];


		if (g_iBonusCount[zGroup] > 0)
		{ // If the server already has a record
			if (g_fFinalTime[client] < g_fBonusFastest[zGroup])
			{	// New fastest time in current map

				g_fOldBonusRecordTime[zGroup] = g_fBonusFastest[zGroup];
				g_fBonusFastest[zGroup] = g_fFinalTime[client];
				Format(g_szBonusFastest[zGroup], MAX_NAME_LENGTH, "%s", szName);
				FormatTimeFloat(1, g_fBonusFastest[zGroup], 3, g_szBonusFastestTime[zGroup], 54);

				// Update Checkpoints
				if (g_bCheckpointsEnabled[client] && !g_bPositionRestored[client])
				{
					for (int i = 0; i < CPLIMIT; i++) 
					{
						g_fCheckpointServerRecord[zGroup][i] = g_fCheckpointTimesNew[zGroup][client][i];
					}
					g_bCheckpointRecordFound[zGroup] = true;
				}

				g_bBonusSRVRecord[client] = true;
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
				g_bNewBonus[client]=true;
				CreateTimer(3.0, BonusReplayTimer, client,TIMER_FLAG_NO_MAPCHANGE);
			}

			g_fOldBonusRecordTime[zGroup] = g_fBonusFastest[zGroup];
			g_fBonusFastest[zGroup] = g_fFinalTime[client];
			Format(g_szBonusFastest[zGroup], MAX_NAME_LENGTH, "%s", szName);
			FormatTimeFloat(1, g_fBonusFastest[zGroup], 3, g_szBonusFastestTime[zGroup], 54);
			
			// Update Checkpoints
			if (g_bCheckpointsEnabled[client] && !g_bPositionRestored[client])
			{
				for (int i = 0; i < CPLIMIT; i++) 
				{
					g_fCheckpointServerRecord[zGroup][i] = g_fCheckpointTimesNew[zGroup][client][i];
				}
				g_bCheckpointRecordFound[zGroup] = true;
			}

			g_bBonusSRVRecord[client] = true;

			g_fOldBonusRecordTime[zGroup] = g_fBonusFastest[zGroup];
		}


		if (g_fPersonalRecordBonus[zGroup][client] == 0.0)  
		{ // Clients first record
			g_fPersonalRecordBonus[zGroup][client] = g_fFinalTime[client];
			FormatTimeFloat(1, g_fPersonalRecordBonus[zGroup][client], 3, g_szPersonalRecordBonus[zGroup][client], 64);

			g_bBonusFirstRecord[client] = true;
			g_pr_showmsg[client] = true;
			db_UpdateCheckpoints(client, g_szSteamID[client], zGroup);
			db_insertBonus(client, g_szSteamID[client], szName, g_fFinalTime[client], zGroup);
		}
		else if (diff > 0.0) 
		{ // client's new record
			g_fPersonalRecordBonus[zGroup][client] = g_fFinalTime[client];
			FormatTimeFloat(1, g_fPersonalRecordBonus[zGroup][client], 3, g_szPersonalRecordBonus[zGroup][client], 64);

			g_bBonusPBRecord[client] = true;
			g_pr_showmsg[client] = true;
			db_UpdateCheckpoints(client, g_szSteamID[client], zGroup);
			db_updateBonus(client, g_szSteamID[client], szName, g_fFinalTime[client], zGroup);
		}


		if (!g_bBonusSRVRecord[client] && !g_bBonusFirstRecord[client] && !g_bBonusPBRecord[client])
		{ 
			PrintToChatAll("%t", "BonusFinished1",MOSSGREEN,WHITE,LIMEGREEN,szName,GRAY,YELLOW,g_szZoneGroupName[zGroup],GRAY,RED,szTime,GRAY,RED,szDiff,GRAY,LIMEGREEN,g_MapRankBonus[zGroup][client],GRAY,g_iBonusCount[zGroup],LIMEGREEN,g_szBonusFastestTime[zGroup],GRAY);	
		}
	}

	//set mvp star
	g_MVPStars[client] += 1;
	CS_SetMVPCount(client,g_MVPStars[client]);		
}