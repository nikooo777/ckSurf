// timer.sp

public Action:timerAfterNoclip(Handle:timer, any:client)
{
	if (IsValidClient(client))
		Client_Stop(client, 1);
}

public Action:timerAfterTele(Handle:timer, any:client)
{
	g_bTimeractivated[client] = false;
	if (g_bToStart[client])
	{
		g_binBonusStartZone[client] = false;
		g_bToStart[client] = false;
	}
	else
	{
		if (g_bToStage[client])
		{
			g_binBonusStartZone[client] = false;
			g_binStartZone[client] = false;
			g_binSpeedZone[client] = false;
			g_bToStage[client] = false;
		}
		else
		{
			if (g_bToBonus[client])
			{
				g_binBonusStartZone[client] = true;
				g_bToBonus[client] = false;
			}
			else
			{
				if (g_bToGoto[client])
				{
					g_bToGoto[client] = false;
				}
			}
		}
	}
	return Plugin_Handled;
}

public Action:AnnounceMap(Handle:timer, any:client)
{
	if (IsValidClient(client)) 
	{
		PrintToChat(client, g_sTierString);
	}

	AnnounceTimer[client] = INVALID_HANDLE;
	return Plugin_Handled;
}

public Action:RefreshAdminMenu(Handle:timer, any:client)
{
	if (IsValidEntity(client) && !IsFakeClient(client))
		ckAdminMenu(client);

	return Plugin_Handled;
}

public Action:RefreshZoneSettings(Handle:timer, any:client)
{
	if (IsValidEntity(client) && !IsFakeClient(client))
		ZoneSettings(client);

	return Plugin_Handled;
}

public Action:SetPlayerWeapons(Handle:timer, any:client)
{
	if ((GetClientTeam(client) > 1) && IsValidClient(client))
	{			
		StripAllWeapons(client);
		if (!IsFakeClient(client))
			GivePlayerItem(client, "weapon_usp_silencer");
		if (!g_bStartWithUsp[client])
		{
			decl weapon;
			weapon = GetPlayerWeaponSlot(client, 2);
			if (weapon != -1 && !IsFakeClient(client))
				 SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);
		}
	}

	return Plugin_Handled;
}

public Action:PlayerRanksTimer(Handle:timer)
{
	for (new i = 1; i <= MaxClients; i++)
	{	
		if (!IsValidClient(i) || IsFakeClient(i))
			continue;			
		db_GetPlayerRank(i);
	}
	return Plugin_Continue;
}

//
// Recounts players time
//
public Action:UpdatePlayerProfile(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client))	
		db_updateStat(client);

	return Plugin_Handled;
}

public Action:StartTimer(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client))	
		CL_OnStartTimerPress(client);

	return Plugin_Handled;
}

public Action:AttackTimer(Handle:timer)
{
	for (new i = 1; i <= MaxClients; i++)
	{	
		if (!IsValidClient(i) || IsFakeClient(i))
			continue;	
		
		if (g_AttackCounter[i] > 0)
		{
			if (g_AttackCounter[i] < 5)
				g_AttackCounter[i] = 0;
			else
				g_AttackCounter[i] = g_AttackCounter[i]  - 5;
		}
	}
	return Plugin_Continue;
}

public Action:CKTimer1(Handle:timer)
{
	if (g_bRoundEnd)
		return Plugin_Continue;
	decl client;
	for (client = 1; client <= MaxClients; client++)
	{		
		if (IsValidClient(client))
		{			
			if(IsPlayerAlive(client))
			{			
				//1st team join + in-game
				if (g_bFirstTeamJoin[client])		
				{
					g_bFirstTeamJoin[client] = false;
					CreateTimer(0.0, StartMsgTimer, client,TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(10.0, WelcomeMsgTimer, client,TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(70.0, HelpMsgTimer, client,TIMER_FLAG_NO_MAPCHANGE);	
				}
				CenterHudAlive(client);			
				MovementCheck(client);
			}
			else
				CenterHudDead(client);				
		
		}
	}	
	return Plugin_Continue;		
}

public Action:DelayedStuff(Handle:timer)
{
	if (FileExists("cfg/sourcemod/ckSurf/main.cfg"))
		ServerCommand("exec sourcemod/ckSurf/main.cfg");
	else
		SetFailState("<ckSurf> cfg/sourcemod/ckSurf/main.cfg not found.");

	//Bots
	LoadReplays();
	LoadInfoBot();

	return Plugin_Handled;
}

public Action:CKTimer2(Handle:timer)
{
	if (g_bRoundEnd)
		return Plugin_Continue;
		
	if (g_bMapEnd)
	{
		new Handle:hTmp;	
		hTmp = FindConVar("mp_timelimit");
		decl iTimeLimit;
		iTimeLimit = GetConVarInt(hTmp);			
		if (hTmp != INVALID_HANDLE)
			CloseHandle(hTmp);	
		if (iTimeLimit > 0)
		{
			decl timeleft;
			GetMapTimeLeft(timeleft);		
			switch(timeleft)
			{
				case 1800: PrintToChatAll("%t", "TimeleftMinutes",LIGHTRED,WHITE,timeleft/60);
				case 1200: PrintToChatAll("%t", "TimeleftMinutes",LIGHTRED,WHITE,timeleft/60);
				case 600:  PrintToChatAll("%t", "TimeleftMinutes",LIGHTRED,WHITE,timeleft/60);
				case 300:  PrintToChatAll("%t", "TimeleftMinutes",LIGHTRED,WHITE,timeleft/60);
				case 120:  PrintToChatAll("%t", "TimeleftMinutes",LIGHTRED,WHITE,timeleft/60);
				case 60:   PrintToChatAll("%t", "TimeleftSeconds",LIGHTRED,WHITE,timeleft); 
				case 30:   PrintToChatAll("%t", "TimeleftSeconds",LIGHTRED,WHITE,timeleft); 
				case 15:   PrintToChatAll("%t", "TimeleftSeconds",LIGHTRED,WHITE,timeleft); 		
				case -1:   PrintToChatAll("%t", "TimeleftCounter",LIGHTRED,WHITE,3); 	
				case -2:   PrintToChatAll("%t", "TimeleftCounter",LIGHTRED,WHITE,2); 	
				case -3:
				{
					if (!g_bRoundEnd)
					{
						g_bRoundEnd=true;			
						ServerCommand("mp_ignore_round_win_conditions 0");
						PrintToChatAll("%t", "TimeleftCounter",LIGHTRED,WHITE,1); 	
						CreateTimer(1.0, TerminateRoundTimer, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}

	//info bot name
	SetInfoBotName(g_InfoBot);

	decl i;
	for (i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || i == g_InfoBot)
			continue;

		//overlay check
		if (g_bOverlay[i] && GetEngineTime()-g_fLastOverlay[i] > 5.0)
			g_bOverlay[i] = false;


		//stop replay to prevent server crashes because of a massive recording array (max. 2h)
		if(g_hRecording[i] != INVALID_HANDLE && g_fCurrentRunTime[i] > 6720.0)
		{
			StopRecording(i);
		}	

		//Scoreboard			
		if (!g_bPause[i]) 
		{
			decl Float:fltime;
			fltime = GetEngineTime() - g_fStartTime[i] - g_fPauseTime[i] + 1.0;
			if (IsPlayerAlive(i) && g_bTimeractivated[i])
			{
				decl time; 
				time = RoundToZero(fltime);
				Client_SetScore(i,time); 								
			}
			else
			{		
				Client_SetScore(i,0);
			}
			if (!IsFakeClient(i) && !g_pr_Calculating[i])
				CreateTimer(0.0, SetClanTag, i,TIMER_FLAG_NO_MAPCHANGE);		
		}		

		if (IsPlayerAlive(i)) 
		{	
			//spec hud
			SpecListMenuAlive(i);

			//challenge check
			if (g_bChallenge_Request[i])
			{
				decl Float:time;
				time= GetEngineTime() - g_fChallenge_RequestTime[i];
				if (time>20.0)
				{
					PrintToChat(i, "%t", "ChallengeRequestExpired", RED,WHITE,YELLOW);
					g_bChallenge_Request[i] = false;
				}
			}

			//Last Cords & Angles
			GetClientAbsOrigin(i,g_fPlayerCordsLastPosition[i]);
			GetClientEyeAngles(i,g_fPlayerAnglesLastPosition[i]);
		}
		else
			SpecListMenuDead(i);
	}

	//clean weapons on ground
	decl maxEntities;
	maxEntities = GetMaxEntities();
	decl String:classx[20];
	if (g_bCleanWeapons)
	{
		decl j;
		for (j = MaxClients + 1; j < maxEntities; j++)
		{
			if (IsValidEdict(j) && (GetEntDataEnt2(j, g_ownerOffset) == -1))
			{
				GetEdictClassname(j, classx, sizeof(classx));
				if ((StrContains(classx, "weapon_") != -1) || (StrContains(classx, "item_") != -1))
				{
					AcceptEntityInput(j, "Kill");
				}
			}
		}
	}
	return Plugin_Continue;
}


//challenge start countdown
public Action:Timer_Countdown(Handle:timer, any:client)
{
	if (IsValidClient(client) && g_bChallenge[client] && !IsFakeClient(client))
	{
		PrintToChat(client,"[%cCK%c] %c%i",RED,WHITE,YELLOW,g_CountdownTime[client]);
		g_CountdownTime[client]--;
		if(g_CountdownTime[client] <= 0) 
		{
			SetEntityMoveType(client, MOVETYPE_WALK);
			PrintToChat(client, "%t", "ChallengeStarted1",RED,WHITE,YELLOW);
			PrintToChat(client, "%t", "ChallengeStarted2",RED,WHITE,YELLOW);
			PrintToChat(client, "%t", "ChallengeStarted3",RED,WHITE,YELLOW);
			return Plugin_Stop;
		}
	}
	return Plugin_Continue;
}

public Action:ReplayTimer(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client))
		SaveRecording(client,0);

	return Plugin_Handled;
}
public Action:BonusReplayTimer(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client))
		SaveRecording(client, 1);

	return Plugin_Handled;
}
public Action:CheckChallenge(Handle:timer, any:client)
{
	new bool:oppenent = false;
	decl String:szSteamId[128];
	decl String:szName[32];
	decl String:szNameTarget[32];
	if (g_bChallenge[client] && IsValidClient(client) && !IsFakeClient(client))
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && i != client)
			{			
				if (StrEqual(g_szSteamID[i],g_szChallenge_OpponentID[client]))
				{
					oppenent=true;		
					if (g_bChallenge_Abort[i] && g_bChallenge_Abort[client])
					{
						GetClientName(i,szNameTarget,32);
						GetClientName(client,szName,32);
						g_bChallenge[client]=false;
						g_bChallenge[i]=false;
						SetEntityRenderColor(client, 255,255,255,255);
						SetEntityRenderColor(i, 255,255,255,255);
						PrintToChat(client, "%t", "ChallengeAborted",RED,WHITE,GREEN,szNameTarget,WHITE);
						PrintToChat(i, "%t", "ChallengeAborted",RED,WHITE,GREEN,szName,WHITE);
						SetEntityMoveType(client, MOVETYPE_WALK);
						SetEntityMoveType(i, MOVETYPE_WALK);
					}				
				}
			}
		}
		if (!oppenent)
		{				
			SetEntityRenderColor(client, 255,255,255,255);
			g_bChallenge[client]=false;
			
			//db challenge entry
			db_insertPlayerChallenge(client);
			
			//new points
			g_pr_showmsg[client]=true;
			CreateTimer(0.5, UpdatePlayerProfile, client,TIMER_FLAG_NO_MAPCHANGE);
			
			//db opponent
			Format(szSteamId,128,"%s",g_szChallenge_OpponentID[client]);
			RecalcPlayerRank(64,szSteamId);
			
			//chat msgs
			if (IsValidClient(client))
				PrintToChat(client, "%t", "ChallengeWon",RED,WHITE,YELLOW,WHITE);
					
			return Plugin_Stop;
		}
	}
	return Plugin_Continue;
}

public Action:LoadReplaysTimer(Handle:timer)
{
	if (g_bReplayBot)
		LoadReplays();

	return Plugin_Handled;
}

public Action:SetClanTag(Handle:timer, any:client)
{
	if (!IsValidClient(client) || IsFakeClient(client) || g_pr_Calculating[client])
		return Plugin_Handled;

	if (!g_bCountry && !g_bPointSystem && !g_bAdminClantag && !g_bVipClantag)
	{
		CS_SetClientClanTag(client, ""); 	
		return Plugin_Handled;
	}
	
	decl String:old_pr_rankname[32];  
	decl String:tag[32];  
	decl bool:oldrank;
	oldrank=false;
	if (!StrEqual(g_pr_rankname[client], "", false))
	{
		oldrank=true;
		Format(old_pr_rankname, 32, "%s", g_pr_rankname[client]); 
	}		
	SetPlayerRank(client);
		
	if (g_bCountry)
	{
		Format(tag, 32, "%s | %s",g_szCountryCode[client],g_pr_rankname[client]);	
		CS_SetClientClanTag(client, tag); 	
	}
	else
	{
		if (g_bPointSystem || ((StrEqual(g_pr_rankname[client], "ADMIN", false)) && g_bAdminClantag) || ((StrEqual(g_pr_rankname[client], "VIP", false)) && g_bVipClantag))
			CS_SetClientClanTag(client, g_pr_rankname[client]); 	
	}
	
	//new rank
	if (oldrank && g_bPointSystem)
		if (!StrEqual(g_pr_rankname[client], old_pr_rankname, false) && IsValidClient(client))
			CPrintToChat(client,"%t","SkillGroup", MOSSGREEN, WHITE, GRAY,GRAY, g_pr_chat_coloredrank[client]);

	return Plugin_Handled;
}

public Action:TerminateRoundTimer(Handle:timer)
{
	CS_TerminateRound(1.0, CSRoundEnd_CTWin, true);
	return Plugin_Handled;
}

public Action:WelcomeMsgTimer(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client) && !StrEqual(g_sWelcomeMsg,""))
		CPrintToChat(client, "%s", g_sWelcomeMsg);

	return Plugin_Handled;
}

public Action:HelpMsgTimer(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client))
		PrintToChat(client, "%t", "HelpMsg", MOSSGREEN,WHITE,GREEN,WHITE);

	return Plugin_Handled;
}


public Action:AdvertTimer(Handle:timer)
{
	g_Advert++;
	if ((g_Advert % 2)== 0) 
	{
		if (g_mapZonesTypeCount[3] > 0)
		{
			PrintToChatAll("%t", "AdvertBonus",MOSSGREEN,WHITE,MOSSGREEN,WHITE,MOSSGREEN);
		}
		else if (g_mapZonesTypeCount[5] > 0)
		{
			PrintToChatAll("%t", "AdvertStage",MOSSGREEN,WHITE,MOSSGREEN,WHITE,MOSSGREEN,WHITE,MOSSGREEN);
		}
	}
	else 
	{
		if (g_mapZonesTypeCount[5] > 0)
		{
			PrintToChatAll("%t", "AdvertStage",MOSSGREEN,WHITE,MOSSGREEN,WHITE,MOSSGREEN,WHITE,MOSSGREEN);
		}
		else if (g_mapZonesTypeCount[3] > 0)
		{
			PrintToChatAll("%t", "AdvertBonus",MOSSGREEN,WHITE,MOSSGREEN,WHITE,MOSSGREEN);
		}
	}
	return Plugin_Continue;
}

public Action:StartMsgTimer(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client))
	{
		
		/* No other languages yet, so dont advert.
		if (!g_bLanguageSelected[client])
			PrintToChat(client, "%t", "LanguageSwitch", MOSSGREEN,WHITE,GRAY,WHITE);
		*/
		PrintMapRecords(client);	
	}
	return Plugin_Handled;
}

public Action:CenterMsgTimer(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client))
	{
		if (g_bRestorePositionMsg[client])
		{
			g_bOverlay[client]=true;
			g_fLastOverlay[client] = GetEngineTime();
			PrintHintText(client,"%t", "PositionRestored");
		}
		g_bRestorePositionMsg[client]=false;
	}

	return Plugin_Handled;
}

public Action:RemoveRagdoll(Handle:timer, any:victim)
{
    if (IsValidEntity(victim) && !IsPlayerAlive(victim))
    {
	decl player_ragdoll;
	player_ragdoll = GetEntDataEnt2(victim, g_ragdolls);
	if (player_ragdoll != -1)
		RemoveEdict(player_ragdoll);
    }
    return Plugin_Handled;
}

public Action:HideRadar(Handle:timer, any:client)
{
	if (IsValidClient(client) && !IsFakeClient(client))
	{
		SetEntPropEnt(client, Prop_Send, "m_bSpotted", 0);
		SetEntProp(client, Prop_Send, "m_iHideHUD", HIDE_RADAR);	
	}
	return Plugin_Handled;
}

public Action:LoadPlayerSettings(Handle:timer)
{
	for(new c=1;c<=MaxClients;c++)
	{
		if(IsValidClient(c))
			OnClientPutInServer(c);
	}
	return Plugin_Handled;
}


