public Action:Command_normalMode(client, args)
{
	if(!IsValidClient(client))
		return Plugin_Handled;

	g_bTimeractivated[client] = false;
	g_bCheckpointMode[client] = false;
	Command_Restart(client, 1);

	PrintToChat(client, "%t", "PracticeNormal", MOSSGREEN, WHITE, MOSSGREEN);
	return Plugin_Handled;
}

public Action:Command_createPlayerCheckpoint(client, args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	if (g_binBonusStartZone[client] || g_binStartZone[client] || g_binSpeedZone[client])
	{
		PrintToChat(client, "%t", "PracticeInStartZone", MOSSGREEN, WHITE);
		return Plugin_Handled;
	}

	new Float:CheckpointTime = GetEngineTime();

	// Move old checkpoint to the undo values, if the last checkpoint was made more than a second ago
	if (g_bCreatedTeleport[client] && (CheckpointTime - g_fLastPlayerCheckpoint[client]) > 1.0)
	{
		g_fLastPlayerCheckpoint[client] = CheckpointTime;
		Array_Copy(g_fCheckpointLocation[client], g_fCheckpointLocation_undo[client], 3);
		Array_Copy(g_fCheckpointVelocity[client], g_fCheckpointVelocity_undo[client], 3);
		Array_Copy(g_fCheckpointAngle[client], g_fCheckpointAngle_undo[client], 3);
	} 

	g_bCreatedTeleport[client] = true;
	GetClientAbsOrigin(client, g_fCheckpointLocation[client]);
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", g_fCheckpointVelocity[client]);
	GetClientEyeAngles(client, g_fCheckpointAngle[client]);


	PrintToChat(client, "%t", "PracticePointCreated", MOSSGREEN, WHITE, MOSSGREEN, WHITE);

	return Plugin_Handled;
}

public Action:Command_goToPlayerCheckpoint(client, args)
{
	if(!IsValidClient(client))
		return Plugin_Handled;

	if (g_fCheckpointLocation[client][0] != 0.0 && g_fCheckpointLocation[client][1] != 0.0 && g_fCheckpointLocation[client][2] != 0.0)
	{
		if (g_bCheckpointMode[client] == false)
		{
			PrintToChat(client, "%t", "PracticeStarted", MOSSGREEN, WHITE, MOSSGREEN, WHITE, MOSSGREEN, WHITE);
			PrintToChat(client, "%t", "PracticeStarted2", MOSSGREEN, WHITE, MOSSGREEN, WHITE, MOSSGREEN, WHITE);

			g_binStartZone[client] = false;
			g_binSpeedZone[client] = false;
			g_binBonusStartZone[client] = false;
			g_bCheckpointMode[client] = true;
		}

		SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,0.0});			
		TeleportEntity(client, g_fCheckpointLocation[client], g_fCheckpointAngle[client], g_fCheckpointVelocity[client]);

		//PrintToChat(client, "[%cCK%c] %cTeleported to last Player Checkpoint.", MOSSGREEN, WHITE, LIMEGREEN);
	}
	else
		PrintToChat(client, "%t", "PracticeStartError", MOSSGREEN, WHITE, MOSSGREEN);

	return Plugin_Handled;
}

public Action:Command_undoPlayerCheckpoint(client, args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	if (g_fCheckpointLocation_undo[client][0] != 0.0 && g_fCheckpointLocation_undo[client][1] != 0.0 && g_fCheckpointLocation_undo[client][2] != 0.0)
	{	
		decl Float:tempLocation[3];
		decl Float:tempVelocity[3];
		decl Float:tempAngle[3];

		// Location
		Array_Copy(g_fCheckpointLocation_undo[client], tempLocation, 3);
		Array_Copy(g_fCheckpointLocation[client], g_fCheckpointLocation_undo[client], 3);
		Array_Copy(tempLocation, g_fCheckpointLocation[client], 3);

		// Velocity
		Array_Copy(g_fCheckpointVelocity_undo[client], tempVelocity, 3);
		Array_Copy(g_fCheckpointVelocity[client], g_fCheckpointVelocity_undo[client], 3);
		Array_Copy(tempVelocity, g_fCheckpointVelocity[client], 3);

		// Angle
		Array_Copy(g_fCheckpointAngle_undo[client], tempAngle, 3);
		Array_Copy(g_fCheckpointAngle[client], g_fCheckpointAngle_undo[client], 3);
		Array_Copy(tempAngle, g_fCheckpointAngle[client], 3);

		PrintToChat(client, "%t","PracticeUndo", MOSSGREEN, WHITE);
	}
	else
		PrintToChat(client, "%t","PracticeUndoError", MOSSGREEN, WHITE, MOSSGREEN);

	return Plugin_Handled;
}

public Action:Command_Teleport(client, args)
{
	new stageZoneId = -1;

	if (g_Stage[client] == 1)
	{
		Command_Restart(client, 1);
		return Plugin_Handled;
	}
	if (g_Stage[client] == 999)
	{
		Command_ToBonus(client, 1);
		return Plugin_Handled;
	}

	if (g_mapZonesCount > 0)
	{
		for(new i = 0; i<g_mapZonesCount;i++)
		{
			if (g_mapZones[i][zoneType] == 5 && g_mapZones[i][zoneTypeId] == (g_Stage[client]-2)) {
				stageZoneId = i;
				break;
			}
		}
		
		if (stageZoneId>=0) 
		{

			decl Float:positA[3];
			decl Float:positB[3];

			if (GetClientTeam(client) == 1 ||GetClientTeam(client) == 0) // Spectating
			{
				Array_Copy(g_mapZones[stageZoneId][PointA], positA, 3);
				Array_Copy(g_mapZones[stageZoneId][PointB], positB, 3);

				AddVectors(positA, positB, g_fTeleLocation[client]);
				g_fTeleLocation[client][0]=FloatDiv(g_fTeleLocation[client][0], 2.0);
				g_fTeleLocation[client][1]=FloatDiv(g_fTeleLocation[client][1], 2.0);
				g_fTeleLocation[client][2]=FloatDiv(g_fTeleLocation[client][2], 2.0);
				g_fCurVelVec[client][0] = 0.0;
				g_fCurVelVec[client][1] = 0.0;
				g_fCurVelVec[client][2] = 0.0;

				g_specToStage[client] = true;
				g_bRespawnPosition[client] = false;
				TeamChangeActual(client, 0);

			}
			else
			{
				Array_Copy(g_mapZones[stageZoneId][PointA], positA, 3);
				Array_Copy(g_mapZones[stageZoneId][PointB], positB, 3);

				decl Float:ZonePos[3];
				AddVectors(positA, positB, ZonePos);
				ZonePos[0]=FloatDiv(ZonePos[0], 2.0);
				ZonePos[1]=FloatDiv(ZonePos[1], 2.0);
				ZonePos[2]=FloatDiv(ZonePos[2], 2.0);
				SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,-100.0});
				TeleportEntity(client, ZonePos, NULL_VECTOR, Float:{0.0,0.0,-100.0});
			}
		} else {
			PrintToChat(client, "%t", "StageNotFound",MOSSGREEN,WHITE,g_Stage[client]);
		}
	}
	return Plugin_Handled;
}

public Action:Command_HowTo(client, args)
{
	ShowMOTDPanel(client, "ckSurf - How To Surf", "http://koti.kapsi.fi/~mukavajoni/how", MOTDPANEL_TYPE_URL)
	return Plugin_Handled;
}

public Action:Command_Zones(client, args)
{
	ZoneMenu(client);
	resetSelection(client);
	return Plugin_Handled;
}

public Action:Command_ToBonus(client, args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	new  bonusZoneId = -1;

	if (g_mapZonesCount > 0) 
	{
		for(new i = 0; i<g_mapZonesCount;i++)
		{		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
			if (g_mapZones[i][zoneType] == 3)
			{
				bonusZoneId = i;
				break;
			}
		}
		
		if (bonusZoneId>=0) 
		{
			// Zone changed
			g_binBonusStartZone[client] = true;
			g_binStartZone[client] = false;
			g_binSpeedZone[client] = false;

			// Timer settings
			g_bToBonus[client] = true;
			CreateTimer(0.4, timerAfterTele, client);

			new	Float:positA[3];
			new	Float:positB[3];
			if (GetClientTeam(client) == 1 ||GetClientTeam(client) == 0)
			{
				TeamChangeActual(client, 0);

				Array_Copy(g_mapZones[bonusZoneId][PointA], positA, 3);
				Array_Copy(g_mapZones[bonusZoneId][PointB], positB, 3);

				AddVectors(positA, positB, g_fTeleLocation[client]);
				g_fTeleLocation[client][0]=FloatDiv(g_fTeleLocation[client][0], 2.0);
				g_fTeleLocation[client][1]=FloatDiv(g_fTeleLocation[client][1], 2.0);
				g_fTeleLocation[client][2]=FloatDiv(g_fTeleLocation[client][2], 2.0);

				g_fCurVelVec[client][0] = 0.0;
				g_fCurVelVec[client][1] = 0.0;
				g_fCurVelVec[client][2] = 0.0;

				g_specToStage[client] = true;
				g_bRespawnPosition[client] = false;
			}
			else
			{
				Array_Copy(g_mapZones[bonusZoneId][PointA], positA, 3);
				Array_Copy(g_mapZones[bonusZoneId][PointB], positB, 3);

				decl Float:ZonePos[3];
				AddVectors(positA, positB, ZonePos);
				ZonePos[0]=FloatDiv(ZonePos[0], 2.0);
				ZonePos[1]=FloatDiv(ZonePos[1], 2.0);
				ZonePos[2]=FloatDiv(ZonePos[2], 2.0);
				
				SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,-100.0});
				TeleportEntity(client, ZonePos, NULL_VECTOR, Float:{0.0,0.0,-100.0});
			}
			g_bBonusTimer[client] = false;
			g_Stage[client] = 999;
		} else {
			PrintToChat(client, "%t", "BonusNotFound",MOSSGREEN,WHITE);
		}
	}
	return Plugin_Handled;
}

public Action:Command_SelectStage(client, args)
{
	if (IsValidClient(client))
		ListStages(client);
	return Plugin_Handled;
}


public ListStages(client)
{
		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
	new Handle:sMenu = CreateMenu(MenuHandler_SelectStage);
	SetMenuTitle(sMenu, "Stage selector");
	new amount = 0, String:StageName[64], String:ZoneInfo[12];

	decl StageIds[128];
	for (new k = 0; k < 128 ;k++)
		StageIds[k] = -1;

	if (g_mapZonesCount > 0)
	{
		for(new i = 0; i<=g_mapZonesCount;i++)
		{
			if (g_mapZones[i][zoneType] == 5)
			{
				StageIds[i] = 1;
				amount++;
			}
		}
		if (amount == 0)
		{
			AddMenuItem(sMenu, "", "The map is linear.", ITEMDRAW_DISABLED);
		} 
		else 
		{
			amount = 0;
			for(new t=0; t<128; t++) 
			{
				if (StageIds[t]>=0)
				{
					amount++;
					Format(StageName, sizeof(StageName), "Stage %i", (amount+1));
					Format(ZoneInfo, sizeof(ZoneInfo), "%i", t);
					AddMenuItem(sMenu, ZoneInfo, StageName);
				}
			}
		}
	} 
	else 
	{
		AddMenuItem(sMenu, "", "No stages are available.", ITEMDRAW_DISABLED);
	}
	
	SetMenuExitButton(sMenu, true);
	DisplayMenu(sMenu, client, MENU_TIME_FOREVER);
}

public MenuHandler_SelectStage(Handle:tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			decl Float:posA[3];
			decl Float:posB[3];
			new String:aID[64];
			GetMenuItem(tMenu, item, aID, sizeof(aID));
			new id = StringToInt(aID);

			Array_Copy(g_mapZones[id][PointA], posA, 3);
			Array_Copy(g_mapZones[id][PointB], posB, 3);
			
			decl Float:ZonePos[3];
			AddVectors(posA, posB, ZonePos);
			ZonePos[0]=FloatDiv(ZonePos[0], 2.0);
			ZonePos[1]=FloatDiv(ZonePos[1], 2.0);
			ZonePos[2]=FloatDiv(ZonePos[2], 2.0);

			g_bToStage[client] = true;
			CreateTimer(1.0, timerAfterTele, client);

			SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,-100.0});
			TeleportEntity(client, ZonePos, NULL_VECTOR, Float:{0.0,0.0,-100.0});
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public Action:Command_ToStage(client, args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;
	if(args < 1)
	{
		PrintToChat(client, "Usage: !s <stage number>");
		return Plugin_Handled;
	}

	new String:arg1[3];
	GetCmdArg(1, arg1, sizeof(arg1));
	new StageId = StringToInt(arg1);

	if (StageId == 1) {
		Command_Restart(client, 1);
		return Plugin_Handled;
	}
	new stageZoneId = -1;

	if (g_mapZonesCount > 0)
	{
		for(new i = 0; i<g_mapZonesCount;i++)
		{
			if (g_mapZones[i][zoneType] == 5 && g_mapZones[i][zoneTypeId] == (StageId - 2)) {
				stageZoneId = i;
				break;
			}
		}
		
		if (stageZoneId>=0)
		{
			g_bToStage[client] = true;
			CreateTimer(1.0, timerAfterTele, client);

			new	Float:positA[3];
			new	Float:positB[3];
			if (GetClientTeam(client) == 1 ||GetClientTeam(client) == 0)
			{
				TeamChangeActual(client, 0);

				Array_Copy(g_mapZones[stageZoneId][PointA], positA, 3);
				Array_Copy(g_mapZones[stageZoneId][PointB], positB, 3);

				AddVectors(positA, positB, g_fTeleLocation[client]);
				g_fTeleLocation[client][0]=FloatDiv(g_fTeleLocation[client][0], 2.0);
				g_fTeleLocation[client][1]=FloatDiv(g_fTeleLocation[client][1], 2.0);
				g_fTeleLocation[client][2]=FloatDiv(g_fTeleLocation[client][2], 2.0);

				g_fCurVelVec[client][0] = 0.0;
				g_fCurVelVec[client][1] = 0.0;
				g_fCurVelVec[client][2] = 0.0;
				g_specToStage[client] = true;
				g_bRespawnPosition[client] = false;
			}
			else
			{
				Array_Copy(g_mapZones[stageZoneId][PointA], positA, 3);
				Array_Copy(g_mapZones[stageZoneId][PointB], positB, 3);

				decl Float:ZonePos[3];
				AddVectors(positA, positB, ZonePos);
				ZonePos[0]=FloatDiv(ZonePos[0], 2.0);
				ZonePos[1]=FloatDiv(ZonePos[1], 2.0);
				ZonePos[2]=FloatDiv(ZonePos[2], 2.0);

				SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,-100.0});
				TeleportEntity(client, ZonePos, NULL_VECTOR, Float:{0.0,0.0,-100.0});
			}
			g_bBonusTimer[client] = false;
			g_Stage[client] = StageId;
		} else {
			PrintToChat(client, "%t", "StageNotFound",MOSSGREEN,WHITE,StageId);
		}
	}
	return Plugin_Handled;
}

public Action:Command_Restart(client, args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	if (g_bCheckpointMode[client])
		Command_normalMode(client ,1);

	if (g_bGotSpawnLocation)
	{
		g_bToStart[client] = true;
		CreateTimer(0.4, timerAfterTele, client);

		if (GetClientTeam(client) == 1 ||GetClientTeam(client) == 0) // spectating
		{
			g_specToStage[client] = true;
			g_bRespawnPosition[client] = false;
			Array_Copy(g_fSpawnLocation, g_fTeleLocation[client], 3);
			TeamChangeActual(client, 0);
			return Plugin_Handled;
		}
		else 
		{
			SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,-100.0});
			TeleportEntity(client, g_fSpawnLocation, g_fSpawnAngle, Float:{0.0,0.0,-100.0});
			return Plugin_Handled;
		}
	}

	new startZoneId = -1;
	if (g_mapZonesCount > 0) 
	{
		for(new i = 0; i<g_mapZonesCount;i++)
		{
			if (g_mapZones[i][zoneType] == 1 || g_mapZones[i][zoneType] == 7)
			{
				startZoneId = i;
				break;
			}
		}
		
		if (startZoneId>-1) 
		{
			if (g_mapZones[startZoneId][zoneType] == 1)
			{
				g_binStartZone[client] = true;
				g_binSpeedZone[client] = false;
				g_binBonusStartZone[client] = false;
			}
			else
				if (g_mapZones[startZoneId][zoneType] == 7)
				{
					g_binStartZone[client] = false;
					g_binSpeedZone[client] = true;
					g_binBonusStartZone[client] = false;
				}

			g_bToStart[client] = true;
			CreateTimer(0.4, timerAfterTele, client);

			new	Float:positA[3];
			new	Float:positB[3];
			if (GetClientTeam(client) == 1 ||GetClientTeam(client) == 0)
			{
				Array_Copy(g_mapZones[startZoneId][PointA], positA, 3);
				Array_Copy(g_mapZones[startZoneId][PointB], positB, 3);

				AddVectors(positA, positB, g_fTeleLocation[client]);
				g_fTeleLocation[client][0]=FloatDiv(g_fTeleLocation[client][0], 2.0);
				g_fTeleLocation[client][1]=FloatDiv(g_fTeleLocation[client][1], 2.0);
				g_fTeleLocation[client][2]=FloatDiv(g_fTeleLocation[client][2], 2.0);

				g_bRespawnPosition[client] = false;
				g_specToStage[client] = true;
				TeamChangeActual(client, 0);
			}
			else
			{
				decl Float:ZonePos[3];

				Array_Copy(g_mapZones[startZoneId][PointA], positA, 3);
				Array_Copy(g_mapZones[startZoneId][PointB], positB, 3);

				AddVectors(positA, positB, ZonePos);
				ZonePos[0]=FloatDiv(ZonePos[0], 2.0);
				ZonePos[1]=FloatDiv(ZonePos[1], 2.0);
				ZonePos[2]=FloatDiv(ZonePos[2], 2.0);
						
				SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,-100.0});
				TeleportEntity(client, ZonePos, NULL_VECTOR, Float:{0.0,0.0,-100.0});
			}
			g_bBonusTimer[client] = false;
			g_Stage[client] = 1;
		} else {
			PrintToChat(client, "%t", "StartNotFound",MOSSGREEN,WHITE);
		}
	}
	return Plugin_Handled;
}

public Action:Client_HideChat(client, args)
{
	HideChat(client);
	if (g_bHideChat[client])
		PrintToChat(client, "%t", "HideChat1",MOSSGREEN, WHITE);
	else
		PrintToChat(client, "%t", "HideChat2",MOSSGREEN, WHITE);
	return Plugin_Handled;
}

public HideChat(client)
{
	if (!g_bHideChat[client])
	{
		g_bHideChat[client]=true;
		SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD")|HIDE_RADAR|HIDE_CHAT);
	}
	else
	{
		g_bHideChat[client]=false;
		SetEntProp(client, Prop_Send, "m_iHideHUD", HIDE_RADAR);
	}
}

public Action:ToggleCheckpoints(client, args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	if (g_bCheckpointsEnabled[client])
	{
		g_bCheckpointsEnabled[client] = false;
		if (g_bActivateCheckpointsOnStart[client])
			g_bActivateCheckpointsOnStart[client] = false;
		PrintToChat(client, "%t", "ToogleCheckpoints1",MOSSGREEN, WHITE);
	}
	else
	{
		if (g_bTimeractivated[client])
		{
			PrintToChat(client, "%t", "ToggleCheckpoints3",MOSSGREEN, WHITE);
			g_bActivateCheckpointsOnStart[client] = true;
		}
		else 
		{
			g_bCheckpointsEnabled[client] = true;
			PrintToChat(client, "%t", "ToggleCheckpoints2",MOSSGREEN, WHITE);
		}
	}
	return Plugin_Handled;
}

public Action:Client_HideWeapon(client, args)
{
	HideViewModel(client);
	if (g_bViewModel[client])
		PrintToChat(client, "%t", "HideViewModel2",MOSSGREEN, WHITE);
	else
		PrintToChat(client, "%t", "HideViewModel1",MOSSGREEN, WHITE);
	return Plugin_Handled;
}

public HideViewModel(client)
{
	if (!g_bViewModel[client])
	{
		g_bViewModel[client]=true;
		Client_SetDrawViewModel(client,true);
	}
	else
	{
		g_bViewModel[client]=false;
		Client_SetDrawViewModel(client,false);
	}
}
public Action:Client_Wr(client, args)
{
	if (IsValidClient(client))
	{
		if (g_fRecordMapTime == 9999999.0)
			PrintToChat(client, "%t", "NoRecordTop", MOSSGREEN,WHITE);
		else
			PrintMapRecords(client);
	}
	return Plugin_Handled;
}

public Action:Command_Tier(client, args)
{
	if (IsValidClient(client)) 
	{
		if(g_bTierFound) 
		{
			PrintToChat(client, g_sTierString);
		}
	}
}

public Action:Client_Avg(client, args)
{
	if(!IsValidClient(client))
		return Plugin_Handled;	
	
	decl String:szProTime[32];
	FormatTimeFloat(client, g_favg_maptime, 3, szProTime, sizeof(szProTime));

	if (g_MapTimesCount==0)
		Format(szProTime,32,"00:00:00");

	PrintToChat(client, "%t", "AvgTime", MOSSGREEN,WHITE,GRAY,DARKBLUE,WHITE,szProTime,g_MapTimesCount);

	if (g_mapZonesTypeCount[3] > 0)
	{
		decl String:szBonusTime[32];
		FormatTimeFloat(client, g_fAvg_BonusTime, 3, szBonusTime, sizeof(szBonusTime));

		if (g_iBonusCount==0)
			Format(szBonusTime,32,"00:00:00");
		PrintToChat(client, "%t", "AvgTimeBonus", MOSSGREEN,WHITE,GRAY,YELLOW,WHITE,szBonusTime,g_iBonusCount);
	}

	return Plugin_Handled;
}

public Action:Client_Flashlight(client, args)
{
	if (IsValidClient(client) && IsPlayerAlive(client)) 
		SetEntProp(client, Prop_Send, "m_fEffects", GetEntProp(client, Prop_Send, "m_fEffects") ^ 4);
	return Plugin_Handled;
}

public Action:Client_Challenge(client, args)
{
	if (!g_bChallenge[client] && !g_bChallenge_Request[client])
	{
		if(IsPlayerAlive(client))
		{
			if (g_bNoBlock)
			{
				new Handle:menu2 = CreateMenu(ChallengeMenuHandler2);
				g_bMenuOpen[client]=true;
				decl String:tmp[64];
				if (g_bPointSystem)
					Format(tmp, 64, "ckSurf - Challenge: Player Bet?\nYour Points: %i", g_pr_points[client]);
				else
					Format(tmp, 64, "ckSurf - Challenge: Player Bet?\nPlayer point system disabled", g_pr_points[client]);
				SetMenuTitle(menu2, tmp);		
				AddMenuItem(menu2, "0", "No bet");			
				if (g_bPointSystem)
				{
					Format(tmp, 64, "%i", g_pr_PointUnit*50);
					if (g_pr_PointUnit*5  <= g_pr_points[client])
						AddMenuItem(menu2, tmp, tmp);	
					Format(tmp, 64, "%i", (g_pr_PointUnit*100));
					if ((g_pr_PointUnit*10)  <= g_pr_points[client])
						AddMenuItem(menu2, tmp, tmp);		
					Format(tmp, 64, "%i", (g_pr_PointUnit*250));
					if ((g_pr_PointUnit*25)  <= g_pr_points[client])
						AddMenuItem(menu2, tmp, tmp);		
					Format(tmp, 64, "%i", (g_pr_PointUnit*500));
					if ((g_pr_PointUnit*50)  <= g_pr_points[client])
						AddMenuItem(menu2, tmp, tmp);	
				}
				SetMenuOptionFlags(menu2, MENUFLAG_BUTTON_EXIT);
				DisplayMenu(menu2, client, MENU_TIME_FOREVER);
			}
			else
				PrintToChat(client, "%t", "ChallengeFailed1",RED,WHITE);
		}
		else
			PrintToChat(client, "%t", "ChallengeFailed2",RED,WHITE);
	}
	else
		PrintToChat(client, "%t", "ChallengeFailed3",RED,WHITE);
	return Plugin_Handled;
}


public ChallengeMenuHandler2(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		new value = StringToInt(info);
		if (value == g_pr_PointUnit*50)		
			g_Challenge_Bet[param1] = 50;
		else
			if (value == (g_pr_PointUnit*100))	
				g_Challenge_Bet[param1] = 100;
			else
				if (value == (g_pr_PointUnit*250))	
					g_Challenge_Bet[param1] = 250;		
				else
					if (value == (g_pr_PointUnit*500))	
						g_Challenge_Bet[param1] = 500;		
					else
						g_Challenge_Bet[param1] = 0;		
		decl String:szPlayerName[MAX_NAME_LENGTH];	
		new Handle:menu2 = CreateMenu(ChallengeMenuHandler3);
		SetMenuTitle(menu2, "ckSurf - Challenge: Select your Opponent");
		new playerCount=0;
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && IsPlayerAlive(i) && i != param1 && !IsFakeClient(i))
			{
				GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
				AddMenuItem(menu2, szPlayerName, szPlayerName);	
				playerCount++;
			}
		}
		if (playerCount>0)
		{
			g_bMenuOpen[param1]=true;
			SetMenuOptionFlags(menu2, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu2, param1, MENU_TIME_FOREVER);		
		}
		else
		{
			PrintToChat(param1, "%t", "ChallengeFailed4",MOSSGREEN,WHITE);
		}
		
	}
	else
	if(action == MenuAction_Cancel)
	{
		g_bMenuOpen[param1]=false;	
	}
	else if (action == MenuAction_End)
	{	
		CloseHandle(menu);
	}
}

public ChallengeMenuHandler3(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		decl String:info[32];
		decl String:szPlayerName[MAX_NAME_LENGTH];
		decl String:szTargetName[MAX_NAME_LENGTH];
		GetClientName(param1, szPlayerName, MAX_NAME_LENGTH);
		GetMenuItem(menu, param2, info, sizeof(info));
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && IsPlayerAlive(i) && i != param1)
			{
				GetClientName(i, szTargetName, MAX_NAME_LENGTH);	
				
				if(StrEqual(info,szTargetName))
				{
					if (!g_bChallenge[i])
					{
						if ((g_pr_PointUnit*g_Challenge_Bet[param1]) <= g_pr_points[i])
						{
							//id of challenger
							decl String:szSteamId[32];
							GetClientAuthString(i, szSteamId, 32);	
							Format(g_szChallenge_OpponentID[param1], 32, szSteamId);					
							decl String:cp[16];
							if (g_bChallenge_Checkpoints[param1])
								Format(cp, 16, " allowed");
							else
								Format(cp, 16, " forbidden");
							new value = g_pr_PointUnit * g_Challenge_Bet[param1];
							PrintToChat(param1, "%t", "Challenge1", RED,WHITE, YELLOW, szTargetName, value,cp);					
							//target msg
							EmitSoundToClient(i,"buttons/button15.wav",i);
							PrintToChat(i, "%t", "Challenge2", RED,WHITE, YELLOW, szPlayerName, GREEN, WHITE, value,cp);
							g_fChallenge_RequestTime[param1] = GetEngineTime();
							g_bChallenge_Request[param1]=true;
						}
						else
						{
							PrintToChat(param1, "%t", "ChallengeFailed5", RED,WHITE, szTargetName, g_pr_points[i]);
						}
					}
					else
						PrintToChat(param1, "%t", "ChallengeFailed6", RED,WHITE, szTargetName);
				}
			}
		}
	}
	else
	if(action == MenuAction_Cancel)
	{
		g_bMenuOpen[param1]=false;	
	}
	else if (action == MenuAction_End)
	{	
		CloseHandle(menu);
	}
}

public Action:Client_Language(client, args)
{
	if (!IsValidClient(client))
			return Plugin_Handled;
	StopClimbersMenu(client);
	DisplayMenu(g_hLangMenu, client, MENU_TIME_FOREVER);	
	return Plugin_Handled;
}


public Action:Client_Abort(client, args)
{
	if (g_bChallenge[client])
	{
		if (g_bChallenge_Abort[client])
		{
			g_bChallenge_Abort[client]=false;
			PrintToChat(client, "[%cCK%c] You have disagreed to abort the challenge.",RED,WHITE);
		}
		else
		{
			g_bChallenge_Abort[client]=true;
			PrintToChat(client, "[%cCK%c] You have agreed to abort the challenge. Waiting for your opponent..",RED,WHITE, GREEN);
		}
	}
	return Plugin_Handled;
}

public Action:Client_Accept(client, args)
{
	decl String:szSteamId[32];
	decl String:szCP[32];
	GetClientAuthString(client, szSteamId, 32);		
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && i != client && g_bChallenge_Request[i])
		{
			if(StrEqual(szSteamId,g_szChallenge_OpponentID[i]))
			{		
				GetClientAuthString(i, g_szChallenge_OpponentID[client], 32);
				g_bChallenge_Request[i]=false;
				g_bChallenge[i]=true;
				g_bChallenge[client]=true;
				g_bChallenge_Abort[client]=false;
				g_bChallenge_Abort[i]=false;
				g_Challenge_Bet[client] = g_Challenge_Bet[i];
				g_bChallenge_Checkpoints[client] = g_bChallenge_Checkpoints[i];
				TeleportEntity(client, g_fSpawnPosition[i],NULL_VECTOR, Float:{0.0,0.0,-100.0});
				TeleportEntity(i, g_fSpawnPosition[i],NULL_VECTOR, Float:{0.0,0.0,-100.0});
				SetEntityMoveType(i, MOVETYPE_NONE);
				SetEntityMoveType(client, MOVETYPE_NONE);
				g_CountdownTime[i] = 10;
				g_CountdownTime[client] = 10;
				CreateTimer(1.0, Timer_Countdown, i, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(1.0, Timer_Countdown, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				PrintToChat(client, "%t", "Challenge3",RED,WHITE, YELLOW);
				PrintToChat(i, "%t", "Challenge3",RED,WHITE, YELLOW);			
				decl String:szPlayer1[MAX_NAME_LENGTH];			
				decl String:szPlayer2[MAX_NAME_LENGTH];
				GetClientName(i, szPlayer1, MAX_NAME_LENGTH);
				GetClientName(client, szPlayer2, MAX_NAME_LENGTH);
				
				if (g_bChallenge_Checkpoints[i])
					Format(szCP, sizeof(szCP), "Allowed"); 
				else
					Format(szCP, sizeof(szCP), "Forbidden");
				new points = g_Challenge_Bet[i]*2*g_pr_PointUnit;
				PrintToChatAll("[%cCK%c] Challenge: %c%s%c vs. %c%s%c",RED,WHITE,MOSSGREEN,szPlayer1,WHITE,MOSSGREEN,szPlayer2,WHITE);
				PrintToChatAll("[%cCK%c] Checkpoints: %c%s%c, Pot: %c%ip",RED,WHITE,GRAY,szCP,WHITE,GRAY,points);
		
				new r1 = GetRandomInt(55, 255);
				new r2 = GetRandomInt(55, 255);
				new r3 = GetRandomInt(0, 55);
				new r4 = GetRandomInt(0, 255);
				SetEntityRenderColor(i, r1, r2, r3, r4);
				SetEntityRenderColor(client, r1, r2, r3, r4);
				g_bTimeractivated[client] = false;
				g_bTimeractivated[i] = false;
				CreateTimer(1.0, CheckChallenge, i, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(1.0, CheckChallenge, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	return Plugin_Handled;
}

public Action:Client_Usp(client, args)
{
	if(!IsValidClient(client) || !IsPlayerAlive(client))
		return Plugin_Handled;

	if ((GetEngineTime() - g_flastClientUsp[client]) < 10.0)
		return Plugin_Handled;
	
	g_flastClientUsp[client] = GetEngineTime();

	if(Client_HasWeapon(client, "weapon_hkp2000"))
	{			
		new weapon = Client_GetWeapon(client, "weapon_hkp2000");
		FakeClientCommand(client, "use %s", weapon);
		InstantSwitch(client, weapon);
	}
	else
		GivePlayerItem(client, "weapon_usp_silencer");
	return Plugin_Handled;
}

InstantSwitch(client, weapon, timer = 0) 
{
	if (weapon==-1)
		return;

	new Float:GameTime = GetGameTime();

	if (!timer) 
	{
		SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);
		SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", GameTime);
	}

	SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GameTime);
	new ViewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
	SetEntProp(ViewModel, Prop_Send, "m_nSequence", 0);
}

public Action:Client_Surrender (client, args)
{
	decl String:szSteamIdOpponent[32];
	decl String:szNameOpponent[MAX_NAME_LENGTH];	
	decl String:szName[MAX_NAME_LENGTH];	
	if (g_bChallenge[client])
	{
		GetClientName(client, szName, MAX_NAME_LENGTH);
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && i != client)
			{	
				GetClientAuthString(i, szSteamIdOpponent, 32);		
				if (StrEqual(szSteamIdOpponent,g_szChallenge_OpponentID[client]))
				{
					GetClientName(i, szNameOpponent, MAX_NAME_LENGTH);	
					g_bChallenge[i]=false;
					g_bChallenge[client]=false;
					db_insertPlayerChallenge(i);
					SetEntityRenderColor(i, 255,255,255,255);
					SetEntityRenderColor(client, 255,255,255,255);
					
					//msg
					for (new j = 1; j <= MaxClients; j++)
					{
						if (IsValidClient(j) && IsValidEntity(j))
						{						
							PrintToChat(j, "%t", "Challenge4",RED,WHITE,MOSSGREEN,szNameOpponent, WHITE,MOSSGREEN,szName,WHITE);
						}
					}	
					//win ratio
					SetEntityMoveType(client, MOVETYPE_WALK);
					SetEntityMoveType(i, MOVETYPE_WALK);
					
					if (g_Challenge_Bet[client] > 0)
					{
						g_pr_showmsg[i] = true;
						PrintToChat(i, "%t", "Rc_PlayerRankStart", MOSSGREEN,WHITE,GRAY);
						PrintToChat(client, "%t", "Rc_PlayerRankStart", MOSSGREEN,WHITE,GRAY);
						new lostpoints = g_Challenge_Bet[client] * g_pr_PointUnit;
						for (new j = 1; j <= MaxClients; j++)
							if (IsValidClient(j) && IsValidEntity(j))
								PrintToChat(j, "[%cCK%c] %c%s%c has lost %c%i %cpoints!", MOSSGREEN, WHITE, PURPLE,szName, GRAY, RED, lostpoints,GRAY);
					}
					//db update
					CreateTimer(0.0, UpdatePlayerProfile, i,TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(0.5, UpdatePlayerProfile, client,TIMER_FLAG_NO_MAPCHANGE);
					i = MaxClients+1;
				}
			}
		}		
	}
	return Plugin_Handled;
}

public Action:Command_ext_Menu(client, const String:command[], argc) 
{
	StopClimbersMenu(client);
	return Plugin_Handled;
}

public StopClimbersMenu(client)
{
	g_bMenuOpen[client] = true;
	if (g_hclimbersmenu[client] != INVALID_HANDLE)
	{	
		g_hclimbersmenu[client] = INVALID_HANDLE;
	}
	if (g_bClimbersMenuOpen[client])
		g_bClimbersMenuwasOpen[client]=true;
	else
		g_bClimbersMenuwasOpen[client]=false;
	g_bClimbersMenuOpen[client] = false;	
}

//https://forums.alliedmods.net/showthread.php?t=206308
public Action:Command_JoinTeam(client, const String:command[], argc)
{ 
	if(!IsValidClient(client) || argc < 1)
		return Plugin_Handled;		
	decl String:arg[4];
	GetCmdArg(1, arg, sizeof(arg));
	new toteam = StringToInt(arg);	

	TeamChangeActual(client, toteam);
	return Plugin_Handled;
}

//https://forums.alliedmods.net/showthread.php?t=206308
TeamChangeActual(client, toteam)
{
	if (g_bForceCT) {
		if (toteam == 0 || toteam == 2) {
			toteam = 3;
		}
	} else {
		if (toteam == 0) { // Client is auto-assigning
			toteam = GetRandomInt(2, 3);
		}
	}
	
	if(g_bSpectate[client])
	{
		if(g_fStartTime[client] != -1.0 && g_bTimeractivated[client] == true)
			g_fPauseTime[client] = GetEngineTime() - g_fStartPauseTime[client];
		g_bSpectate[client] = false;
	}	
	ChangeClientTeam(client, toteam);
	return;
}


public Action:Client_OptionMenu(client, args)
{
	OptionMenu(client);
	return Plugin_Handled;
}

public Action:NoClip(client, args)
{
	if (!IsValidClient(client))					
		return Plugin_Handled;	

	Action_NoClip(client);	
	
	return Plugin_Handled;
}

public Action:UnNoClip(client, args)
{
	if (g_bNoClip[client] == true)
		Action_UnNoClip(client);
	return Plugin_Handled;
}

public Action:Client_Top(client, args)
{	
	TopMenu(client);
	return Plugin_Handled;
}

public Action:Client_MapTop(client, args)
{	
	if (args==0)
	{
		PrintToChat(client, "%t", "MapTopFail",MOSSGREEN,WHITE);
		return Plugin_Handled;
	}
	decl String:szArg[128];   
	GetCmdArg(1, szArg, 128);
	db_selectMapTopClimbers(client,szArg);
	return Plugin_Handled;
}


public Action:Client_Spec(client, args)
{	
	SpecPlayer(client, args);
	return Plugin_Handled;
}

// Measure-Plugin by DaFox
//https://forums.alliedmods.net/showthread.php?t=88830?t=88830
public Action:Command_Menu(client,args) 
{
	StopClimbersMenu(client);
	DisplayMenu(g_hMainMenu,client,MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public Handler_MainMenu(Handle:menu,MenuAction:action,param1,param2) 
{
	if(action == MenuAction_Select) 
	{
		switch(param2) 
		{
			case 0: {	//Point 1 (Red)
				GetPos(param1,0);
			}
			case 1: {	//Point 2 (Green)
				GetPos(param1,1);
			}
			case 2: {	//Find Distance
				if(g_bMeasurePosSet[param1][0] && g_bMeasurePosSet[param1][1]) 
				{
					new Float:vDist = GetVectorDistance(g_fvMeasurePos[param1][0],g_fvMeasurePos[param1][1]);
					new Float:vHightDist = (g_fvMeasurePos[param1][0][2] - g_fvMeasurePos[param1][1][2]);
					PrintToChat(param1, "%t", "Measure1",MOSSGREEN,WHITE,vDist,vHightDist);					
					Beam(param1,g_fvMeasurePos[param1][0],g_fvMeasurePos[param1][1],4.0,2.0,0,0,255);
				}
				else 
					PrintToChat(param1, "%t", "Measure2",MOSSGREEN,WHITE);
			}
			case 3: {	//Reset
				ResetPos(param1);
			}
		}
		DisplayMenu(g_hMainMenu,param1,MENU_TIME_FOREVER);
	}
	else if(action == MenuAction_Cancel) 
	{
		g_bMenuOpen[param1] = false;
		ResetPos(param1);
	}
}


public SpecPlayer(client,args)
{
	decl String:szPlayerName[MAX_NAME_LENGTH];
	decl String:szPlayerName2[128];
	decl String:szOrgTargetName[MAX_NAME_LENGTH];
	decl String:szTargetName[MAX_NAME_LENGTH];
	decl String:szArg[MAX_NAME_LENGTH];
	Format(szTargetName, MAX_NAME_LENGTH, ""); 
	Format(szOrgTargetName, MAX_NAME_LENGTH, ""); 
	
	if (args==0)
	{		
		new Handle:menu = CreateMenu(SpecMenuHandler);
		
		if(g_bSpectate[client])
			SetMenuTitle(menu, "ckSurf - Spec menu (press 'm' to rejoin a team!)");	
		else
			SetMenuTitle(menu, "ckSurf - Spec menu");	
		new playerCount=0;
		
		//add replay bots
		if (g_RecordBot != -1)
		{
			if (g_RecordBot != -1 && IsValidClient(g_RecordBot) && IsPlayerAlive(g_RecordBot))
			{
				Format(szPlayerName2, 128, "Map record replay (%s)",g_szReplayTime);
				AddMenuItem(menu, "MAP RECORD REPLAY", szPlayerName2);
				playerCount++;
			}   	
		}
		if (g_BonusBot != -1)
		{
			if (g_BonusBot != -1 && IsValidClient(g_BonusBot) && IsPlayerAlive(g_BonusBot))
			{
				Format(szPlayerName2, 128, "Bonus record replay (%s)",g_szBonusTime);
				AddMenuItem(menu, "BONUS RECORD REPLAY", szPlayerName2);
				playerCount++;
			}   	
		}

		
		new count = 0;
		//add players
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && IsPlayerAlive(i) && i != client && !IsFakeClient(i))
			{
				if (count==0)
				{
					new bestrank = 99999999;
					for (new x = 1; x <= MaxClients; x++)
					{
						if (IsValidClient(x) && IsPlayerAlive(x) && x != client && !IsFakeClient(x) && g_PlayerRank[x] > 0)
							if (g_PlayerRank[x] <= bestrank)
								bestrank = g_PlayerRank[x];					
					}
					decl String:szMenu[128];
					Format (szMenu,128,"Highest ranked player (#%i)",bestrank);
					AddMenuItem(menu, "brp123123xcxc", szMenu);
					AddMenuItem(menu, "", "",ITEMDRAW_SPACER);					
				}
				GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
				Format(szPlayerName2, 128, "%s (%s)",szPlayerName, g_pr_rankname[i]);
				AddMenuItem(menu, szPlayerName, szPlayerName2);
				playerCount++;		
				count++;
			}
		}
		
		if (playerCount>0 || g_RecordBot != -1 || g_BonusBot != -1)
		{
			g_bMenuOpen[client]=true;
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, client, MENU_TIME_FOREVER);		
		}		
		else
			PrintToChat(client, "%t", "ChallengeFailed4",MOSSGREEN,WHITE);
			
	}
	else 
	{
		for (new i = 1; i < 20; i++)
		{
			GetCmdArg(i, szArg, MAX_NAME_LENGTH);
			if (!StrEqual(szArg, "", false))
			{
				if (i==1)
					Format(szTargetName, MAX_NAME_LENGTH, "%s", szArg); 
				else
					Format(szTargetName, MAX_NAME_LENGTH, "%s %s", szTargetName, szArg); 
			}
		}	
		Format(szOrgTargetName, MAX_NAME_LENGTH, "%s", szTargetName); 
		StringToUpper(szTargetName);	
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && IsPlayerAlive(i) && i != client )
			{
				GetClientName(i, szPlayerName, MAX_NAME_LENGTH);		
				StringToUpper(szPlayerName);
				if ((StrContains(szPlayerName, szTargetName) != -1))
				{
					ChangeClientTeam(client, 1);
					SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", i);  
					SetEntProp(client, Prop_Send, "m_iObserverMode", 4);
					return;
				}
			}
		}	
		PrintToChat(client, "%t", "PlayerNotFound",MOSSGREEN,WHITE, szOrgTargetName);	
	}
}

public SpecMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		decl String:info[32];
		decl String:szPlayerName[MAX_NAME_LENGTH];
		GetMenuItem(menu, param2, info, sizeof(info));
	
		if(StrEqual(info,"brp123123xcxc"))
		{
			new playerid;
			new count = 0;
			new bestrank = 99999999;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && IsPlayerAlive(i) && i != param1 && !IsFakeClient(i))
				{
					if (g_PlayerRank[i] <= bestrank)
					{
						bestrank = g_PlayerRank[i];
						playerid = i;
						count++;
					}
				}						
			}
			if (count==0)
				PrintToChat(param1, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
			else
			{
				ChangeClientTeam(param1, 1);
				SetEntPropEnt(param1, Prop_Send, "m_hObserverTarget", playerid);  
				SetEntProp(param1, Prop_Send, "m_iObserverMode", 4);						
			}
		}
		else
		{		
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && IsPlayerAlive(i) && i != param1)
				{
					GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
					if (i == g_RecordBot)
						Format(szPlayerName, MAX_NAME_LENGTH, "MAP RECORD REPLAY"); 
					if (i == g_BonusBot)
						Format(szPlayerName, MAX_NAME_LENGTH, "BONUS RECORD REPLAY")			
					if(StrEqual(info,szPlayerName))
					{
						ChangeClientTeam(param1, 1);
						SetEntPropEnt(param1, Prop_Send, "m_hObserverTarget", i);  
						SetEntProp(param1, Prop_Send, "m_iObserverMode", 4);			
					}
				}			
			}
		}		
	}
	else
	if(action == MenuAction_Cancel)
	{
		g_bMenuOpen[param1]=false;	
	}
	else if (action == MenuAction_End)
	{	
		CloseHandle(menu);
	}
}

public CompareMenu(client,args)
{
	decl String:szArg[MAX_NAME_LENGTH];
	decl String:szPlayerName[MAX_NAME_LENGTH];	
	if (args == 0)
	{
		Format(szPlayerName, MAX_NAME_LENGTH, "");
		new Handle:menu = CreateMenu(CompareSelectMenuHandler);
		SetMenuTitle(menu, "ckSurf - Compare menu");		
		new playerCount=0;
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && IsPlayerAlive(i) && i != client && !IsFakeClient(i))
			{
				GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
				AddMenuItem(menu, szPlayerName, szPlayerName);	
				playerCount++;
			}
		}
		if (playerCount>0)
		{
			g_bMenuOpen[client]=true;
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, client, MENU_TIME_FOREVER);	
		}	
		else
			PrintToChat(client,"[%cCK%c] No valid players found",MOSSGREEN,WHITE);
		return;
	}
	else
	{	
		for (new i = 1; i < 20; i++)
		{
			GetCmdArg(i, szArg, MAX_NAME_LENGTH);
			if (!StrEqual(szArg, "", false))
			{
				if (i==1)
					Format(szPlayerName, MAX_NAME_LENGTH, "%s", szArg); 
				else
					Format(szPlayerName, MAX_NAME_LENGTH, "%s %s",  szPlayerName, szArg); 
			}
		}
		//player ingame? new name?
		if (!StrEqual(szPlayerName,"",false))
		{
			new id = -1;
			decl String:szName[MAX_NAME_LENGTH];
			decl String:szName2[MAX_NAME_LENGTH];		
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && i!=client)
				{
					GetClientName(i, szName, MAX_NAME_LENGTH);		
					StringToUpper(szName);
					Format(szName2, MAX_NAME_LENGTH, "%s", szPlayerName); 
					if ((StrContains(szName, szName2) != -1))
					{
						id=i;
						continue;
					}
				}
			}
			if (id != -1)
				db_viewPlayerRank2(client, g_szSteamID[id]);
			else
				db_viewPlayerAll2(client, szPlayerName);
		}	
	}
}

public CompareSelectMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		decl String:info[32];
		decl String:szPlayerName[MAX_NAME_LENGTH];
		GetMenuItem(menu, param2, info, sizeof(info));
		
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && i != param1)
			{
				GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
				if(StrEqual(info,szPlayerName))
				{
					db_viewPlayerRank2(param1, g_szSteamID[param1]);
				}
			}
		}
		CompareMenu(param1,0);
	}
	else
	if(action == MenuAction_Cancel)
	{
		if (IsValidClient(param1))
			g_bMenuOpen[param1]=false;	
	}
	else if (action == MenuAction_End)
	{	
		if (IsValidClient(param1))
			g_bSelectProfile[param1]=false;
		CloseHandle(menu);
	}
}

public ProfileMenu(client,args)
{
	//spam protection
	new Float:diff = GetEngineTime() - g_fProfileMenuLastQuery[client];
	if (diff < 0.5)
	{
		StopClimbersMenu(client);
		g_bSelectProfile[client]=false;
		return;
	}
	g_fProfileMenuLastQuery[client] = GetEngineTime();
	
	decl String:szArg[MAX_NAME_LENGTH];
	//no argument
	if (args == 0)
	{
		decl String:szPlayerName[MAX_NAME_LENGTH];	
		new Handle:menu = CreateMenu(ProfileSelectMenuHandler);
		SetMenuTitle(menu, "ckSurf - Profile menu");		
		GetClientName(client, szPlayerName, MAX_NAME_LENGTH);	
		AddMenuItem(menu, szPlayerName, szPlayerName);	
		new playerCount=1;
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && i != client && !IsFakeClient(i))
			{
				GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
				AddMenuItem(menu, szPlayerName, szPlayerName);	
				playerCount++;
			}
		}
		g_bMenuOpen[client]=true;
		g_bSelectProfile[client]=true;
		SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
		DisplayMenu(menu, client, MENU_TIME_FOREVER);		
		return;
	}
	//get name
	else 
	{
		if (args != -1)
		{
			g_bSelectProfile[client]=false;
			Format(g_szProfileName[client], MAX_NAME_LENGTH, "");
			for (new i = 1; i < 20; i++)
			{
				GetCmdArg(i, szArg, MAX_NAME_LENGTH);
				if (!StrEqual(szArg, "", false))
				{
					if (i==1)
						Format( g_szProfileName[client], MAX_NAME_LENGTH, "%s", szArg); 
					else
						Format( g_szProfileName[client], MAX_NAME_LENGTH, "%s %s",  g_szProfileName[client], szArg); 
				}
			}
		}
	}
	//player ingame? new name?
	if (args != 0 && !StrEqual(g_szProfileName[client],"",false))
	{
		new bool:bPlayerFound=false;
		decl String:szSteamId2[32];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szName2[MAX_NAME_LENGTH];		
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				GetClientName(i, szName, MAX_NAME_LENGTH);		
				StringToUpper(szName);
				Format(szName2, MAX_NAME_LENGTH, "%s", g_szProfileName[client]); 
				if ((StrContains(szName, szName2) != -1))
				{
					bPlayerFound=true;
					GetClientAuthString(i, szSteamId2, 32);
					continue;
				}
			}
		}
		if (bPlayerFound)
			db_viewPlayerRank(client, szSteamId2);
		else
			db_viewPlayerProfile1(client, g_szProfileName[client]);
	}
}

public ProfileSelectMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		decl String:info[32];
		decl String:szPlayerName[MAX_NAME_LENGTH];
		GetMenuItem(menu, param2, info, sizeof(info));
		
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
				if(StrEqual(info,szPlayerName))
				{
					Format(g_szProfileName[param1], MAX_NAME_LENGTH, "%s", szPlayerName); 
					decl String:szSteamId[32];
					GetClientAuthString(i, szSteamId, 32);	
					db_viewPlayerRank(param1, szSteamId);
				}
			}
		}
	}
	else
	if(action == MenuAction_Cancel)
	{
		if (IsValidClient(param1))
			g_bMenuOpen[param1]=false;	
	}
	else if (action == MenuAction_End)
	{	
		if (IsValidClient(param1))
			g_bSelectProfile[param1]=false;
		CloseHandle(menu);
	}
}

public Action:Client_AutoBhop(client, args) 
{ 	
	AutoBhop(client);
	if (g_bAutoBhop)
	{
		if (!g_bAutoBhopClient[client])
			PrintToChat(client, "%t", "AutoBhop2",MOSSGREEN,WHITE);
		else
			PrintToChat(client, "%t", "AutoBhop1",MOSSGREEN,WHITE);
	}
	return Plugin_Handled;
} 

public AutoBhop(client)
{
	if (!g_bAutoBhop)
		PrintToChat(client, "%t", "AutoBhop3",MOSSGREEN,WHITE);
	if (!g_bAutoBhopClient[client])
		g_bAutoBhopClient[client] = true; 
	else
		g_bAutoBhopClient[client] = false; 
}

public Action:Client_Hide(client, args) 
{ 	
	HideMethod(client);
	if (!g_bHide[client])
		PrintToChat(client, "%t", "Hide1",MOSSGREEN,WHITE);
	else
		PrintToChat(client, "%t", "Hide2",MOSSGREEN,WHITE);
	return Plugin_Handled;
} 

public HideMethod(client)
{
	if (!g_bHide[client])
		g_bHide[client] = true; 
	else
		g_bHide[client] = false; 
}

public Action:Client_Latest(client, args)
{
	db_ViewLatestRecords(client);
	return Plugin_Handled;
}

public Action:Client_Showsettings(client, args)
{
	ShowSrvSettings(client);
	return Plugin_Handled;
}

public Action:Client_Help(client, args)
{
	HelpPanel(client);
	return Plugin_Handled;
}

public Action:Client_Ranks(client, args)
{
	if (IsValidClient(client))
		PrintToChat(client, "[%cCK%c] %c%s (0p)  %c%s%c (%ip)   %c%s%c (%ip)   %c%s%c (%ip)   %c%s%c (%ip)   %c%s%c (%ip)   %c%s%c (%ip)   %c%s%c (%ip)   %c%s%c (%ip)",
		MOSSGREEN,WHITE, WHITE, g_szSkillGroups[0],WHITE,g_szSkillGroups[1],WHITE,g_pr_rank_Percentage[1], GRAY, g_szSkillGroups[2],GRAY,g_pr_rank_Percentage[2],LIGHTBLUE, 
		g_szSkillGroups[3],LIGHTBLUE,g_pr_rank_Percentage[3],BLUE, g_szSkillGroups[4],BLUE,g_pr_rank_Percentage[4],DARKBLUE,g_szSkillGroups[5],DARKBLUE,g_pr_rank_Percentage[5],
		PINK,g_szSkillGroups[6],PINK,g_pr_rank_Percentage[6],LIGHTRED,g_szSkillGroups[7],LIGHTRED,g_pr_rank_Percentage[7],DARKRED,g_szSkillGroups[8],DARKRED,g_pr_rank_Percentage[8]);
	return Plugin_Handled;
}

public Action:Client_Profile(client, args)
{
	ProfileMenu(client,args);
	return Plugin_Handled;
}

public Action:Client_Compare(client, args)
{
	CompareMenu(client,args);
	return Plugin_Handled;
}

public Action:Client_RankingSystem(client, args)
{
	PrintToChat(client,"[%cCK%c]%c Loading html page.. (requires cl_disablehtmlmotd 0)", MOSSGREEN,WHITE,LIMEGREEN);
	ShowMOTDPanel(client, "ckSurf - Ranking System" ,"http://koti.kapsi.fi/~mukavajoni/ranking/index.html", MOTDPANEL_TYPE_URL);
	return Plugin_Handled;
}

public Action:Client_Pause(client, args) 
{
	if (GetClientTeam(client) == 1) return Plugin_Handled;
	PauseMethod(client);	
	if (g_bPause[client]==false)
		PrintToChat(client, "%t", "Pause2",MOSSGREEN, WHITE, RED, WHITE);
	else
		PrintToChat(client, "%t", "Pause3",MOSSGREEN, WHITE);
	return Plugin_Handled;
}

public PauseMethod(client)
{
	if (GetClientTeam(client) == 1) return;
	if (g_bPause[client]==false && IsValidEntity(client))
	{
		if (g_bPauseServerside==false && client != g_RecordBot && client != g_BonusBot) 
		{
			PrintToChat(client, "%t", "Pause1",MOSSGREEN, WHITE,RED,WHITE);
			return;
		}
		g_bPause[client]=true;		
		new Float:fVel[3];
		fVel[0] = 0.000000;
		fVel[1] = 0.000000;
		fVel[2] = 0.000000;
		SetEntPropVector(client, Prop_Data, "m_vecVelocity", fVel);
		SetEntityMoveType(client, MOVETYPE_NONE);
		//Timer enabled?
		if(g_bTimeractivated[client] == true)
		{
			g_fStartPauseTime[client] = GetEngineTime();
			if (g_fPauseTime[client] > 0.0)
				g_fStartPauseTime[client] = g_fStartPauseTime[client] - g_fPauseTime[client];	
		}
		SetEntityRenderMode(client, RENDER_NONE);
		SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
	}
	else
	{
		if(g_fStartTime[client] != -1.0 && g_bTimeractivated[client] == true)
		{
			g_fPauseTime[client] = GetEngineTime() - g_fStartPauseTime[client];
		}
		g_bNoClip[client]=false;
		g_bPause[client]=false;
		if (!g_bRoundEnd)
			SetEntityMoveType(client, MOVETYPE_WALK);
		SetEntityRenderMode(client, RENDER_NORMAL);
		if (g_bNoBlock)
			SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
		else
			SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 5, true);

		TeleportEntity(client, NULL_VECTOR,NULL_VECTOR, Float:{0.0,0.0,-100.0});
	}
}

public Action:Client_HideSpecs(client, args) 
{
	HideSpecs(client);
	if (g_bShowSpecs[client] == true)
		PrintToChat(client, "%t", "HideSpecs1",MOSSGREEN, WHITE);
	else
		PrintToChat(client, "%t", "HideSpecs2",MOSSGREEN, WHITE);
	return Plugin_Handled;
}

public HideSpecs(client)
{
	if (g_bShowSpecs[client] == true)
		g_bShowSpecs[client] = false;
	else
		g_bShowSpecs[client] = true;
}

public Action:Client_Showtime(client, args) 
{
	ShowTime(client);
	if (g_bShowTime[client])
		PrintToChat(client, "%t", "Showtime1",MOSSGREEN, WHITE);
	else
		PrintToChat(client, "%t", "Showtime2",MOSSGREEN, WHITE);
	return Plugin_Handled;
}

public ShowTime(client)
{
	if (g_bShowTime[client])
		g_bShowTime[client] = false;
	else
		g_bShowTime[client] = true;
}
	
public GoToMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		decl String:info[32];
		decl String:szPlayerName[MAX_NAME_LENGTH];
		GetMenuItem(menu, param2, info, sizeof(info));
		for (new i = 1; i <= MaxClients; i++)
		{	
			if (IsValidClient(i) && IsPlayerAlive(i) && i != param1)
			{
				GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
				if(StrEqual(info,szPlayerName))
				{
					GotoMethod(param1,i);
				}
				else
				{
					if (i == MaxClients)
					{
						PrintToChat(param1, "%t", "Goto4", MOSSGREEN,WHITE, szPlayerName);
						Client_GoTo(param1,0);
					}
				}
			}
		}
	}
	else
	if(action == MenuAction_Cancel)
	{
		g_bMenuOpen[param1]=false;	
	}
	else if (action == MenuAction_End)
	{	
		CloseHandle(menu);
	}
}

public GotoMethod(client, i)
{	
	if (!IsValidClient(client) || IsFakeClient(client))
		return;
	decl String:szTargetName[MAX_NAME_LENGTH];
	GetClientName(i, szTargetName, MAX_NAME_LENGTH);	
	if (GetEntityFlags(i) & FL_ONGROUND)
	{
		new ducked = GetEntProp(i, Prop_Send, "m_bDucked");
		new ducking = GetEntProp(i, Prop_Send, "m_bDucking");
		if (!(GetClientButtons(client) & IN_DUCK) && ducked == 0 && ducking == 0)
		{
			g_bToGoto[client] = true;
			Client_Stop(client, 1);
			CreateTimer(1.0, timerAfterTele, client);
			if (GetClientTeam(client) == 1 ||GetClientTeam(client) == 0)
			{
				new Float:position[3];
				new Float:angles[3];
				GetClientAbsOrigin(i,position);
				GetClientEyeAngles(i,angles);

				AddVectors(position, angles, g_fTeleLocation[client]);
				g_fTeleLocation[client][0]=FloatDiv(g_fTeleLocation[client][0], 2.0);
				g_fTeleLocation[client][1]=FloatDiv(g_fTeleLocation[client][1], 2.0);
				g_fTeleLocation[client][2]=FloatDiv(g_fTeleLocation[client][2], 2.0);
				

				g_fCurVelVec[client][0] = 0.0;
				g_fCurVelVec[client][1] = 0.0;
				g_fCurVelVec[client][2] = 0.0;

				g_bRespawnPosition[client] = false;
				g_specToStage[client] = true;
				TeamChangeActual(client, 0);
			}
			else
			{
				new Float:position[3];
				new Float:angles[3];
				GetClientAbsOrigin(i,position);
				GetClientEyeAngles(i,angles);

				TeleportEntity(client, position,angles, Float:{0.0,0.0,-100.0});
				decl String:szClientName[MAX_NAME_LENGTH];
				GetClientName(client, szClientName, MAX_NAME_LENGTH);	
				PrintToChat(i, "%t", "Goto5", MOSSGREEN,WHITE, szClientName);
			}

		}
		else
		{
			PrintToChat(client, "%t", "Goto6", MOSSGREEN,WHITE, szTargetName);
			Client_GoTo(client,0);
		}
	}
	else
	{
		PrintToChat(client, "%t", "Goto7", MOSSGREEN,WHITE, szTargetName);
		Client_GoTo(client,0);
	}
}



public Action:Client_GoTo(client, args) 
{
	if (!g_bGoToServer)
		PrintToChat(client, "%t", "Goto1",MOSSGREEN,WHITE,RED,WHITE);
	else
	if (!g_bNoBlock)
		PrintToChat(client, "%t", "Goto2",MOSSGREEN,WHITE);
	else
	if (g_bTimeractivated[client])
		PrintToChat(client, "%t", "Goto3",MOSSGREEN,WHITE, GREEN,WHITE);
	else
	{
		decl String:szPlayerName[MAX_NAME_LENGTH];
		decl String:szOrgTargetName[MAX_NAME_LENGTH];
		decl String:szTargetName[MAX_NAME_LENGTH];
		decl String:szArg[MAX_NAME_LENGTH];
		if (args==0)
		{
			new Handle:menu = CreateMenu(GoToMenuHandler);
			SetMenuTitle(menu, "ckSurf - Goto menu");
			new playerCount=0;
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && IsPlayerAlive(i) && i != client && !IsFakeClient(i))
				{
					GetClientName(i, szPlayerName, MAX_NAME_LENGTH);	
					AddMenuItem(menu, szPlayerName, szPlayerName);	
					playerCount++;
				}
			}
			if (playerCount>0)
			{
				g_bMenuOpen[client]=true;
				SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
				DisplayMenu(menu, client, MENU_TIME_FOREVER);		
			}
			else
			{
				CloseHandle(menu);
				PrintToChat(client, "%t", "ChallengeFailed4",MOSSGREEN,WHITE);
			}
		}
		else 
		{
			for (new i = 1; i < 20; i++)
			{
				GetCmdArg(i, szArg, MAX_NAME_LENGTH);
				if (!StrEqual(szArg, "", false))
				{
					if (i==1)
						Format(szTargetName, MAX_NAME_LENGTH, "%s", szArg); 
					else
						Format(szTargetName, MAX_NAME_LENGTH, "%s %s", szTargetName, szArg); 
				}
			}	
			Format(szOrgTargetName, MAX_NAME_LENGTH, "%s", szTargetName); 
			StringToUpper(szTargetName);	
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && IsPlayerAlive(i) && i != client )
				{
					GetClientName(i, szPlayerName, MAX_NAME_LENGTH);		
					StringToUpper(szPlayerName);
					if ((StrContains(szPlayerName, szTargetName) != -1))
					{
						GotoMethod(client,i);
						return Plugin_Handled;
					}
				}
			}	
			PrintToChat(client, "%t", "PlayerNotFound",MOSSGREEN,WHITE, szOrgTargetName);	
		}
	}
	return Plugin_Handled;
}
		
public Action:Client_QuakeSounds(client, args) 
{
	QuakeSounds(client);
	if (g_bEnableQuakeSounds[client])
		PrintToChat(client, "%t", "QuakeSounds1", MOSSGREEN,WHITE);
	else
		PrintToChat(client, "%t", "QuakeSounds2", MOSSGREEN,WHITE);
	return Plugin_Handled;
}

public QuakeSounds(client)
{
	if (g_bEnableQuakeSounds[client])
		g_bEnableQuakeSounds[client] = false;
	else
		g_bEnableQuakeSounds[client] = true;
}

public Action:Client_Stop(client, args)
{
	if (g_bTimeractivated[client])
	{
		g_bClimbersMenuOpen[client]=false;
		PlayerPanel(client);
		g_bTimeractivated[client] = false;	
		g_fStartTime[client] = -1.0;
		g_fCurrentRunTime[client] = -1.0;		
	}
	return Plugin_Handled;
}

public Action_NoClip(client)
{    
	if(IsValidClient(client) && !IsFakeClient(client) && IsPlayerAlive(client))
	{
		g_fLastTimeNoClipUsed[client] = GetGameTime();
		new team = GetClientTeam(client);
		if (team==2 || team==3)
		{
			new MoveType:mt = GetEntityMoveType(client);   
			if(mt == MOVETYPE_WALK)
			{
				if (g_bTimeractivated[client])
				{
					g_bTimeractivated[client] = false;
					g_fStartTime[client] = -1.0;
					g_fCurrentRunTime[client] = -1.0;
				}				
				SetEntityMoveType(client, MOVETYPE_NOCLIP);
				SetEntityRenderMode(client , RENDER_NONE); 
				SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
				g_bNoClip[client] = true;
			}
		}
	}
	return;
}  

public Action_UnNoClip(client)
{    
	if(IsValidClient(client) && !IsFakeClient(client) && IsPlayerAlive(client))
	{
		g_fLastTimeNoClipUsed[client] = GetGameTime();
		CreateTimer(5.0, timerAfterNoclip, client, TIMER_FLAG_NO_MAPCHANGE);
		new team = GetClientTeam(client);
		if (team==2 || team==3)
		{
			new MoveType:mt = GetEntityMoveType(client);   
			if(mt == MOVETYPE_NOCLIP)
			{
				SetEntityMoveType(client, MOVETYPE_WALK);
				SetEntityRenderMode(client, RENDER_NORMAL);
				if(g_bNoBlock)
					SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
				else
					SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 5, 4, true);
				g_bNoClip[client] = false;			
			}
		}
	}
	return;
}  

public TopMenu(client)
{
	g_MenuLevel[client]=-1;
	g_bTopMenuOpen[client]=true;
	new Handle:topmenu = CreateMenu(TopMenuHandler);
	SetMenuTitle(topmenu, "ckSurf - Top Menu");
	if (g_bPointSystem)
		AddMenuItem(topmenu, "Top 100 Players", "Top 100 Players");
	AddMenuItem(topmenu, "Top 5 Challengers", "Top 5 Challengers");
	AddMenuItem(topmenu, "Map Top", "Map Top");	
	SetMenuOptionFlags(topmenu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(topmenu, client, MENU_TIME_FOREVER);
}

public TopMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		if(g_bPointSystem)
		{
			switch(param2)
			{
				case 0: db_selectTopPlayers(param1);
				case 1: db_selectTopChallengers(param1);
				case 2: db_selectTopClimbers(param1,g_szMapName); 
			}
		}
		else
		{
			switch(param2)
			{
				case 0: db_selectTopChallengers(param1);
				case 1: db_selectTopProRecordHolders(param1);
				case 2: db_selectTopClimbers(param1,g_szMapName);
			}
		}
	}
	else
		if(action == MenuAction_Cancel)
			g_bTopMenuOpen[param1]=false;	
		else 
			if (action == MenuAction_End)
				CloseHandle(menu);
}

public HelpPanel(client)
{
	PrintConsoleInfo(client);
	g_bMenuOpen[client] = true;
	g_bClimbersMenuOpen[client]=false;
	new Handle:panel = CreatePanel();
	decl String:title[64];
	Format(title, 64, "ckSurf Help (1/4) - v%s\nby Elzi",VERSION);
	DrawPanelText(panel, title);
	DrawPanelText(panel, " ");
	DrawPanelText(panel, "!help - opens this menu");
	DrawPanelText(panel, "!help2 - explanation of the ranking system");
	DrawPanelText(panel, "!menu - checkpoint menu");
	DrawPanelText(panel, "!options - player options menu");	
	DrawPanelText(panel, "!top - top menu");
	DrawPanelText(panel, "!latest - prints in console the last map records");
	DrawPanelText(panel, "!profile/!ranks - opens your profile");
	DrawPanelText(panel, " ");
	DrawPanelItem(panel, "next page");
	DrawPanelItem(panel, "exit");
	SendPanelToClient(panel, client, HelpPanelHandler, 10000);
	CloseHandle(panel);
}

public HelpPanelHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		if(param2==1)
			HelpPanel2(param1);
		else
			g_bMenuOpen[param1] = false;
	}
}

public HelpPanel2(client)
{
	new Handle:panel = CreatePanel();
	decl String:szTmp[64];
	Format(szTmp, 64, "ckSurf Help (2/4) - v%s\nby Elzi",VERSION);
	DrawPanelText(panel, szTmp);
	DrawPanelText(panel, " ");
	DrawPanelText(panel, "!start/!r - go back to start");
	DrawPanelText(panel, "!stop - stops the timer");
	DrawPanelText(panel, "!pause - on/off pause");	
	DrawPanelText(panel, "!usp - spawns a usp silencer");
	DrawPanelText(panel, "!challenge - allows you to start a race against others");	
	DrawPanelText(panel, "!spec [<name>] - select a player you want to watch");	
	DrawPanelText(panel, "!goto [<name>] - teleports you to a given player");
	DrawPanelText(panel, "!compare [<name>] - compare your challenge results with a given player");
	DrawPanelText(panel, "!showsettings - shows ckSurf plugin settings");
	DrawPanelText(panel, " ");
	DrawPanelItem(panel, "previous page");
	DrawPanelItem(panel, "next page");
	DrawPanelItem(panel, "exit");
	SendPanelToClient(panel, client, HelpPanel2Handler, 10000);
	CloseHandle(panel);
}

public HelpPanel2Handler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		if(param2==1)
			HelpPanel(param1);
		else
			if(param2==2)
				HelpPanel3(param1);
			else
				g_bMenuOpen[param1] = false;
	}
}

public HelpPanel3(client)
{
	new Handle:panel = CreatePanel();
	decl String:szTmp[64];
	Format(szTmp, 64, "ckSurf Help (3/4) - v%s\nby Elzi",VERSION);
	DrawPanelText(panel, szTmp);
	DrawPanelText(panel, " ");	
	DrawPanelText(panel, "!maptop <mapname> - displays map top for a given map");
	DrawPanelText(panel, "!flashlight - on/off flashlight");
	DrawPanelText(panel, "!ranks - prints in chat the available ranks");
	DrawPanelText(panel, "!measure - allows you to measure the distance between 2 points");
	DrawPanelText(panel, "!language - opens the language menu");
	DrawPanelText(panel, "!wr - prints in chat the record of the current map");
	DrawPanelText(panel, "!avg - prints in chat the average map time");
	DrawPanelText(panel, "!stuck / !back - teleports player back to the start of the stage. Does not stop timer");
	DrawPanelText(panel, "!avg - !");
	DrawPanelText(panel, " ");
	DrawPanelItem(panel, "previous page");
	DrawPanelItem(panel, "exit");
	SendPanelToClient(panel, client, HelpPanel3Handler, 10000);
	CloseHandle(panel);
}
public HelpPanel3Handler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		if(param2==1)
			HelpPanel2(param1);
		else
			if(param2==2)
				HelpPanel4(param1);
			else
				g_bMenuOpen[param1] = false;
	}
}

public HelpPanel4(client)
{
	new Handle:panel = CreatePanel();
	decl String:szTmp[64];
	Format(szTmp, 64, "ckSurf Help (4/4) - v%s\nby Elzi",VERSION);
	DrawPanelText(panel, szTmp);
	DrawPanelText(panel, " ");	
	DrawPanelText(panel, "!cp - Creates a checkpoint to use in practice mode.");
	DrawPanelText(panel, "!tele / !teleport / !practice / !prac - Starts practice mode");
	DrawPanelText(panel, "!undo - Undoes your latest checkpoint");
	DrawPanelText(panel, " ");
	DrawPanelItem(panel, "previous page");
	DrawPanelItem(panel, "exit");
	SendPanelToClient(panel, client, HelpPanel4Handler, 10000);
	CloseHandle(panel);
}

public HelpPanel4Handler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		if(param2==1)
			HelpPanel2(param1);
		else
			g_bMenuOpen[param1] = false;
	}
}

public ShowSrvSettings(client)
{
	PrintToConsole(client, " ");
	PrintToConsole(client, "-----------------");
	PrintToConsole(client, "ckSurf settings");
	PrintToConsole(client, "-----------------");
	PrintToConsole(client, "ck_admin_clantag %b", g_bAdminClantag);
	PrintToConsole(client, "ck_attack_spam_protection %b", g_bAttackSpamProtection);
	PrintToConsole(client, "ck_auto_bhop %i (bhop_ & surf_ maps)", g_bAutoBhopConVar);
	PrintToConsole(client, "ck_auto_timer %i", g_bAutoTimer);
	PrintToConsole(client, "ck_autoheal %i (requires ck_godmode 0)", g_Autohealing_Hp);
	PrintToConsole(client, "ck_autorespawn %b", g_bAutoRespawn);
	PrintToConsole(client, "ck_challenge_points %b", g_bChallengePoints);
	PrintToConsole(client, "ck_clean_weapons %b", g_bCleanWeapons);
	PrintToConsole(client, "ck_connect_msg %b", g_bConnectMsg);
	PrintToConsole(client, "ck_country_tag %b", g_bCountry);
	PrintToConsole(client, "ck_custom_models %b", g_bPlayerSkinChange);	
	PrintToConsole(client, "ck_dynamic_timelimit %b (requires ck_map_end 1)", g_bDynamicTimelimit);
	PrintToConsole(client, "ck_godmode %b", g_bgodmode);
	PrintToConsole(client, "ck_goto %b", g_bGoToServer);
	PrintToConsole(client, "ck_info_bot %b", g_bInfoBot);
	PrintToConsole(client, "ck_noclip %b", g_bNoClipS);
	PrintToConsole(client, "ck_map_end %b", g_bMapEnd);
	PrintToConsole(client, "ck_noblock %b", g_bNoBlock);
	PrintToConsole(client, "ck_pause %b", g_bPauseServerside);
	PrintToConsole(client, "ck_point_system %b", g_bPointSystem);
	PrintToConsole(client, "ck_ranking_extra_points_firsttime %i", g_ExtraPoints2);
	PrintToConsole(client, "ck_ranking_extra_points_improvements %i", g_ExtraPoints);
	PrintToConsole(client, "ck_round_end %b", g_bAllowRoundEndCvar);
	PrintToConsole(client, "ck_replay_bot %b", g_bReplayBot);
	PrintToConsole(client, "ck_restore %b", g_bRestore);
	PrintToConsole(client, "ck_use_radio %b", g_bRadioCommands);
	PrintToConsole(client, "ck_vip_clantag %b", g_bVipClantag);
	PrintToConsole(client, "---------------");
	PrintToConsole(client, "Server settings");
	PrintToConsole(client, "---------------");
	new Handle:hTmp;	
	hTmp = FindConVar("sv_airaccelerate");
	new Float: flAA = GetConVarFloat(hTmp);			
	hTmp = FindConVar("sv_accelerate");
	new Float: flA = GetConVarFloat(hTmp);	
	hTmp = FindConVar("sv_friction");
	new Float: flFriction = GetConVarFloat(hTmp);	
	hTmp = FindConVar("sv_gravity");
	new Float: flGravity = GetConVarFloat(hTmp);	
	hTmp = FindConVar("sv_enablebunnyhopping");
	new iBhop = GetConVarInt(hTmp);	
	hTmp = FindConVar("sv_maxspeed");
	new Float: flMaxSpeed = GetConVarFloat(hTmp);	
	hTmp = FindConVar("sv_maxvelocity");
	new Float: flMaxVel = GetConVarFloat(hTmp);	
	hTmp = FindConVar("sv_staminalandcost");
	new Float: flStamLand = GetConVarFloat(hTmp);	
	hTmp = FindConVar("sv_staminajumpcost");
	new Float: flStamJump = GetConVarFloat(hTmp);		
	hTmp = FindConVar("sv_wateraccelerate");
	new Float: flWaterA = GetConVarFloat(hTmp);
	if (hTmp != INVALID_HANDLE)
		CloseHandle(hTmp);		
	PrintToConsole(client, "sv_accelerate %.1f", flA);	
	PrintToConsole(client, "sv_airaccelerate %.1f", flAA);
	PrintToConsole(client, "sv_friction %.1f", flFriction);
	PrintToConsole(client, "sv_gravity %.1f", flGravity);
	PrintToConsole(client, "sv_enablebunnyhopping %i", iBhop);
	PrintToConsole(client, "sv_maxspeed %.1f", flMaxSpeed);
	PrintToConsole(client, "sv_maxvelocity %.1f", flMaxVel);
	PrintToConsole(client, "sv_staminalandcost %.2f", flStamLand);
	PrintToConsole(client, "sv_staminajumpcost %.2f", flStamJump);
	PrintToConsole(client, "sv_wateraccelerate %.1f", flWaterA);
	PrintToConsole(client, "-------------------------------------");		
	PrintToChat(client, "[%cCK%c] See console for output!", MOSSGREEN,WHITE);	
}

public OptionMenu(client)
{
	g_bMenuOpen[client] = true;
	new Handle:optionmenu = CreateMenu(OptionMenuHandler);
	SetMenuTitle(optionmenu, "ckSurf - Options Menu");			
	if (g_bHide[client])
		AddMenuItem(optionmenu, "Hide Players  -  Enabled", "Hide other players  -  Enabled");
	else
		AddMenuItem(optionmenu, "Hide Players  -  Disabled", "Hide other players  -  Disabled");			
	if (g_bEnableQuakeSounds[client])
		AddMenuItem(optionmenu, "Quake sounds - Enabled", "Quake sounds - Enabled");
	else
		AddMenuItem(optionmenu, "Quake sounds - Disabled", "Quake sounds - Disabled");
	if (g_bShowTime[client])
		AddMenuItem(optionmenu, "Show Timer  -  Enabled", "Show timer text  -  Enabled");
	else
		AddMenuItem(optionmenu, "Show Timer  -  Disabled", "Show timer text  -  Disabled");			
	if (g_bShowSpecs[client])
		AddMenuItem(optionmenu, "Spectator list  -  Enabled", "Spectator list  -  Enabled");
	else
		AddMenuItem(optionmenu, "Spectator list  -  Disabled", "Spectator list  -  Disabled");	
	if (g_bInfoPanel[client])
		AddMenuItem(optionmenu, "Speed/Stage panel  -  Enabled", "Speed/Stage panel  -  Enabled");
	else
		AddMenuItem(optionmenu, "Speed/Stage panel  -  Disabled", "Speed/Stage panel  -  Disabled");					
	if (g_bStartWithUsp[client])
		AddMenuItem(optionmenu, "Active start weapon  -  Usp", "Start weapon  -  USP");
	else
		AddMenuItem(optionmenu, "Active start weapon  -  Knife", "Start weapon  -  Knife");
	if (g_bGoToClient[client])
		AddMenuItem(optionmenu, "Goto  -  Enabled", "Goto me  -  Enabled");
	else
		AddMenuItem(optionmenu, "Goto  -  Disabled", "Goto me  -  Disabled");	
	if (g_bAutoBhop)
	{
		if (g_bAutoBhopClient[client])
			AddMenuItem(optionmenu, "AutoBhop  -  Enabled", "AutoBhop  -  Enabled");
		else
			AddMenuItem(optionmenu, "AutoBhop  -  Disabled", "AutoBhop  -  Disabled");	
	}
	if (g_bHideChat[client])
		AddMenuItem(optionmenu, "Hide Chat - Hidden", "Hide Chat - Hidden");
	else 
		AddMenuItem(optionmenu, "Hide Chat - Visible", "Hide Chat - Visible");

	if (g_bViewModel[client])
		AddMenuItem(optionmenu, "Hide Weapon - Visible", "Hide Weapon - Visible");
	else 
		AddMenuItem(optionmenu, "Hide Weapon - Hidden", "Hide Weapon - Hidden");

	if (g_bCheckpointsEnabled[client])
		AddMenuItem(optionmenu, "Checkpoints - Enabled", "Checkpoints - Enabled");
	else 
		AddMenuItem(optionmenu, "Checkpoints - Disabled", "Checkpoints - Disabled");

	SetMenuOptionFlags(optionmenu, MENUFLAG_BUTTON_EXIT);
	if (g_OptionsMenuLastPage[client] < 6)
		DisplayMenuAtItem(optionmenu, client, 0, MENU_TIME_FOREVER);
	else
		if (g_OptionsMenuLastPage[client] < 12)
			DisplayMenuAtItem(optionmenu, client, 6, MENU_TIME_FOREVER);
		else
			if (g_OptionsMenuLastPage[client] < 18)
				DisplayMenuAtItem(optionmenu, client, 12, MENU_TIME_FOREVER);
}


public SwitchStartWeapon(client)
{
	if (g_bStartWithUsp[client])
		g_bStartWithUsp[client] = false;
	else
		g_bStartWithUsp[client] = true;
}

public Action:Client_DisableGoTo(client, args)  
{
	DisableGoTo(client);
	if (g_bGoToClient[client])
		PrintToChat(client, "%t", "DisableGoto1",MOSSGREEN, WHITE);
	else
		PrintToChat(client, "%t", "DisableGoto2",MOSSGREEN, WHITE);
	return Plugin_Handled;
}


public DisableGoTo(client)
{
	if (g_bGoToClient[client])
		g_bGoToClient[client]=false;
	else
		g_bGoToClient[client]=true;
}

public Action:Client_InfoPanel(client, args) 
{
	InfoPanel(client);
	if (g_bInfoPanel[client] == true)
		PrintToChat(client, "%t", "Info1", MOSSGREEN,WHITE);
	else
		PrintToChat(client, "%t", "Info2", MOSSGREEN,WHITE);	
	return Plugin_Handled;
}

public InfoPanel(client)
{
	if (g_bInfoPanel[client])
		g_bInfoPanel[client] = false;
	else
		g_bInfoPanel[client] = true;	
}


public OptionMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{
	if(action == MenuAction_Select)
	{
		switch(param2)
		{	
			case 0: HideMethod(param1);
			case 1: QuakeSounds(param1);
			case 2: ShowTime(param1);
			case 3: HideSpecs(param1);
			case 4: InfoPanel(param1);	
			case 5: SwitchStartWeapon(param1);
			case 6: DisableGoTo(param1);
			case 7: AutoBhop(param1);
			case 8: HideChat(param1);
			case 9: HideViewModel(param1);
			case 10: ToggleCheckpoints(param1, 1);
		}
		g_OptionsMenuLastPage[param1] = param2;
		OptionMenu(param1);					
	}
	else
		if(action == MenuAction_Cancel)
		{
			if (param2!=9)
				g_bMenuOpen[param1]=false;	
		}
		else 
			if (action == MenuAction_End)
			{	
				CloseHandle(menu);
			}
}