CreateZoneEntity(zoneIndex)
{
	float fMiddle[3], fMins[3], fMaxs[3];
	char sZoneName[64];

	if(g_mapZones[zoneIndex][PointA][0] == -1.0 && g_mapZones[zoneIndex][PointA][1]  == -1.0 && g_mapZones[zoneIndex][PointA][2] == -1.0 )
	{
		return;
	}
	
	Array_Copy(g_mapZones[zoneIndex][PointA], fMins, 3);
	Array_Copy(g_mapZones[zoneIndex][PointB], fMaxs, 3);

	Format(sZoneName, sizeof(sZoneName), "%s", g_mapZones[zoneIndex][zoneName]);

	int iEnt = CreateEntityByName("trigger_multiple");
	
	if (iEnt > 0 && IsValidEntity(iEnt)) {
		SetEntityModel(iEnt, g_sModel);
		// Spawnflags:	1 - only a player can trigger this by touch, makes it so a NPC cannot fire a trigger_multiple
		// 2 - Won't fire unless triggering ent's view angles are within 45 degrees of trigger's angles (in addition to any other conditions), so if you want the player to only be able to fire the entity at a 90 degree angle you would do ",angles,0 90 0," into your spawnstring.
		// 4 - Won't fire unless player is in it and pressing use button (in addition to any other conditions), you must make a bounding box,(max\mins) for this to work.
		// 8 - Won't fire unless player/NPC is in it and pressing fire button, you must make a bounding box,(max\mins) for this to work.
		// 16 - only non-player NPCs can trigger this by touch
		// 128 - Start off, has to be activated by a target_activate to be touchable/usable
		// 256 - multiple players can trigger the entity at the same time
		DispatchKeyValue(iEnt, "spawnflags", "257");
		DispatchKeyValue(iEnt, "StartDisabled", "0");

		Format(sZoneName, sizeof(sZoneName), "sm_ckZone %i", zoneIndex);
		DispatchKeyValue(iEnt, "targetname", sZoneName);
		DispatchKeyValue(iEnt, "wait", "0");
		
		if (DispatchSpawn(iEnt))
		{
			ActivateEntity(iEnt);
			
			GetMiddleOfABox(fMins, fMaxs, fMiddle);
			
			TeleportEntity(iEnt, fMiddle, NULL_VECTOR, NULL_VECTOR);
			
			// Have the mins always be negative
			fMins[0] = fMins[0] - fMiddle[0];
			if(fMins[0] > 0.0)
				fMins[0] *= -1.0;
			fMins[1] = fMins[1] - fMiddle[1];
			if(fMins[1] > 0.0)
				fMins[1] *= -1.0;
			fMins[2] = fMins[2] - fMiddle[2];
			if(fMins[2] > 0.0)
				fMins[2] *= -1.0;
			
			// And the maxs always be positive
			fMaxs[0] = fMaxs[0] - fMiddle[0];
			if(fMaxs[0] < 0.0)
				fMaxs[0] *= -1.0;
			fMaxs[1] = fMaxs[1] - fMiddle[1];
			if(fMaxs[1] < 0.0)
				fMaxs[1] *= -1.0;
			fMaxs[2] = fMaxs[2] - fMiddle[2];
			if(fMaxs[2] < 0.0)
				fMaxs[2] *= -1.0;
			
			SetEntPropVector(iEnt, Prop_Send, "m_vecMins", fMins);
			SetEntPropVector(iEnt, Prop_Send, "m_vecMaxs", fMaxs);
			SetEntProp(iEnt, Prop_Send, "m_nSolidType", 2);
			
			int iEffects = GetEntProp(iEnt, Prop_Send, "m_fEffects");
			iEffects |= 0x020;
			SetEntProp(iEnt, Prop_Send, "m_fEffects", iEffects);
			
			
			SDKHook(iEnt, SDKHook_StartTouch,  StartTouchTrigger);
			SDKHook(iEnt, SDKHook_EndTouch, EndTouchTrigger);
		}
		else 
		{
			
			LogError("Not able to dispatchspawn for Entity %i in SpawnTrigger", iEnt);
		}
	}
}
		// Types: Start(1), End(2), Stage(3), Checkpoint(4), Speed(5), TeleToStart(6), Validator(7), Chekcer(8), Stop(0)

public Action StartTouchTrigger(caller, activator)
{
	// Ignore dead players
	if(!IsValidClient(activator))
		return Plugin_Handled;
		
	char sTargetName[256];
	int action[3];
	GetEntPropString(caller, Prop_Data, "m_iName", sTargetName, sizeof(sTargetName));
	ReplaceString(sTargetName, sizeof(sTargetName), "sm_ckZone ", "");

	int id = StringToInt(sTargetName);

	action[0] = g_mapZones[id][zoneType];
	action[1] = g_mapZones[id][zoneTypeId];
	action[2] = g_mapZones[id][zoneGroup];

	if (action[2] == g_iClientInZone[activator][2]) // Is touching zone in right zonegroup
	{
		// Set client location 
		g_iClientInZone[activator][0] = action[0];
		g_iClientInZone[activator][1] = action[1];
		g_iClientInZone[activator][2] = action[2];
		g_iClientInZone[activator][3] = id;
		StartTouch(activator, action);
	}
	else
	{
		if (action[0] == 1 || action[0] == 5) // Ignore other than start zones in other zonegroups
		{
			// Set client location 
			g_iClientInZone[activator][0] = action[0];
			g_iClientInZone[activator][1] = action[1];
			g_iClientInZone[activator][2] = action[2];
			g_iClientInZone[activator][3] = id;
			StartTouch(activator, action);
		}
	}

	return Plugin_Handled;
}

public Action EndTouchTrigger(caller, activator)
{	
	// Ignore dead players
	if(!IsValidClient(activator))
		return Plugin_Handled;

	// Ignore if teleporting out of the zone
	if (g_bIgnoreZone[activator])
	{
		g_bIgnoreZone[activator] = false;
		return Plugin_Handled;
	}
		
	char sTargetName[256];
	int action[3];
	GetEntPropString(caller, Prop_Data, "m_iName", sTargetName, sizeof(sTargetName));
	ReplaceString(sTargetName, sizeof(sTargetName), "sm_ckZone ", "");

	int id = StringToInt(sTargetName);

	action[0] = g_mapZones[id][zoneType];
	action[1] = g_mapZones[id][zoneTypeId];
	action[2] = g_mapZones[id][zoneGroup];

	if (action[2] != g_iClientInZone[activator][2] || action[0] == 6) // Ignore end touches in other zonegroups & tele to start
		return Plugin_Handled;

	EndTouch(activator, action);
	if (!IsFakeClient(activator))
	{
		if (g_bTrailOn[activator])
		{
			refreshTrail(activator);
		}
	}
	else
	{
		if ((g_bBonusBotTrailEnabled && g_bBonusBot) || (g_bRecordBotTrailEnabled && g_bReplayBot))
			refreshTrail(activator);
	}
	// Set client location 
	g_iClientInZone[activator][0] = -1;
	g_iClientInZone[activator][1] = -1;
	g_iClientInZone[activator][2] = g_mapZones[id][zoneGroup];
	g_iClientInZone[activator][3] = -1;

//	PrintToChatAll("Called: 0: %i, 1: %i, 2: %i", action[0], action[1], action[2]);
	return Plugin_Handled;
}

StartTouch(client, action[3])
{
	// real client
	if (1 <= client <= MaxClients)
	{
		// Types: Start(1), End(2), Stage(3), Checkpoint(4), Speed(5), TeleToStart(6), Validator(7), Chekcer(8), Stop(0)
		switch (action[0])
		{
			case 0: // Stop Zone
			{
				Client_Stop(client, 1);
				lastCheckpoint[g_iClientInZone[client][2]][client] = 999;
			}
			case 1:	// Start Zone
			{	
				if (g_Stage[g_iClientInZone[client][2]][client] == 1 && g_bPracticeMode[client]) // If practice mode is on
	 				Command_goToPlayerCheckpoint(client, 1);
	 			else
	 			{
					g_Stage[g_iClientInZone[client][2]][client] = 1;

					Client_Stop(client, 1);
					// Resetting last checkpoint
					lastCheckpoint[g_iClientInZone[client][2]][client] = 1;
				}
			} 
			case 2: // End Zone
			{
				if (g_iClientInZone[client][2] == action[2])	 //  Cant end bonus timer in this zone && in the having the same timer on
					CL_OnEndTimerPress(client);	
				else 
				{
					Client_Stop(client, 1);
				}
				if (g_bPracticeMode[client]) // Go back to normal mode if checkpoint mode is on
				{
					Command_normalMode(client, 1);
					clearPlayerCheckPoints(client);
				}
				// Resetting checkpoints
				lastCheckpoint[g_iClientInZone[client][2]][client] = 999;
			}
			/*case 3: // Bonus Start Zone
			{
				if (g_Stage[g_iClientInZone[client][2]][client] == 999 && g_bPracticeMode[client])
	 				Command_goToPlayerCheckpoint(client, 1);
	 			else	
	 			{
	 				// Set Zone Group
	 				g_iClientInZone[client][2] = action[2];
					g_Stage[g_iClientInZone[client][2]][client] = 1; 

		 			// In Start Zone
					g_binBonusStartZone[client] = true;
					g_binStartZone[client] = false;
					g_binSpeedZone[client] = false;

					Client_Stop(client, 1);
					lastCheckpoint[g_iClientInZone[client][2]][client] = 1;
				}
			}
			case 4: // Bonus End Zone
			{
				if (g_iClientInZone[client][2] > 0 && g_iClientInZone[client][2] == action[2])
					CL_OnEndTimerPress(client);	
				else
				{
					Client_Stop(client, 1);
				}

				if (g_bPracticeMode[client])	// Practice mode
				{
					Command_normalMode(client, 1);
					clearPlayerCheckPoints(client);
				}
				lastCheckpoint[g_iClientInZone[client][2]][client] = 999;
			}*/
			case 3: // Stage Zone
			{
				if (g_bPracticeMode[client]) // If practice mode is on
				{
					if (action[1] > lastCheckpoint[g_iClientInZone[client][2]][client] && g_iClientInZone[client][2] == action[2] || lastCheckpoint[g_iClientInZone[client][2]][client] == 999)
					{
						Command_normalMode(client, 1);  // Temp fix. Need to track stages checkpoints were made in.
					}
					else
						Command_goToPlayerCheckpoint(client, 1);
				}
				else
				{	// Setting valid to false, in case of checkers
					g_bValidRun[client] = false;	

					// Announcing checkpoint
					if (action[1] != lastCheckpoint[g_iClientInZone[client][2]][client] && g_iClientInZone[client][2] == action[2]) 
					{
						g_Stage[g_iClientInZone[client][2]][client] = (action[1]+2);
						Checkpoint(client, action[1], g_iClientInZone[client][2]);
						lastCheckpoint[g_iClientInZone[client][2]][client] = action[1];
					}
				}
			}
			case 4: // Checkpoint Zone
			{
				if (action[1] != lastCheckpoint[g_iClientInZone[client][2]][client] && g_iClientInZone[client][2] == action[2]) 
				{
					// Announcing checkpoint in linear maps
					Checkpoint(client, action[1], g_iClientInZone[client][2]);
					lastCheckpoint[g_iClientInZone[client][2]][client] = action[1];
				}
			}
			case 5: // Speed Start Zone
			{
				if (g_Stage[g_iClientInZone[client][2]][client] == 1 && g_bPracticeMode[client]) // Practice mode
	 				Command_goToPlayerCheckpoint(client, 1);
				else
				{
					// Set Zone Group
					g_Stage[g_iClientInZone[client][2]][client] = 1;
		 		
					Client_Stop(client, 1);
					lastCheckpoint[g_iClientInZone[client][2]][client] = 1;
				}
			}
			case 6: // TeleToStart Zone
			{
				Client_Stop(client, 1);
				lastCheckpoint[g_iClientInZone[client][2]][client] = 999;
				Command_Restart(client, 1);
			}
			case 7: // Run Validator Zone
			{
				g_bValidRun[client] = true;
			}
			case 8: // Run Checker Zone
			{
				if (!g_bValidRun[client])
					Command_Teleport(client, 1);
			}
		}
	}
}

EndTouch(client, action[3])
{
	// real client
	if (1 <= client <= MaxClients)
	{
		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
		switch(action[0])
		{
			case 1: // Start Zone
			{
				if (g_bPracticeMode[client] && !g_bTimeractivated[client])
				{ // If on practice mode, but timer isn't on - start timer
					CL_OnStartTimerPress(client);
				}
				else
				{
					if (!g_bPracticeMode[client])
					{
						// NoClip check if not using prespeec cap
						if (((GetGameTime() - g_fLastTimeNoClipUsed[client]) < 5.0) && GetSpeed(client) > 500.0)
						{
							Command_Restart(client, 1);
							return;
						}

						g_Stage[g_iClientInZone[client][2]][client] = 1;
						lastCheckpoint[g_iClientInZone[client][2]][client] = 999;

						CL_OnStartTimerPress(client);

						if (bSoundEnabled)
						{
							EmitSoundToClient(client,sSoundPath);
						}

						g_bValidRun[client] = false;
					}
				}
			}
		/*	case 3: // Bonus Start Zone
			{
				if (g_bPracticeMode[client] && !g_bTimeractivated[client])
				{
					CL_OnStartTimerPress(client);
				}
				else
				{
					if (!g_bPracticeMode[client] && !g_bToStart[client] && !g_bToStage[client] && !g_bToBonus[client] && !g_bToGoto[client])
					{
						if (((GetGameTime() - g_fLastTimeNoClipUsed[client]) < 5.0) && GetSpeed(client) > 500.0)
						{
							Command_Restart(client, 1);
							return;
						}

						// Set Zone Group
	 					g_iClientInZone[client][2] = action[2];

						CL_OnStartTimerPress(client);

						// Left start zone
						g_binBonusStartZone[client] = false;
						g_binStartZone[client] = false;
						g_binSpeedZone[client] = false;

						if (bSoundEnabled)
							EmitSoundToClient(client,sSoundPath);

						g_bValidRun[client] = false;
					}
				}
			}*/
			case 5: // Speed Start Zone
			{
				if (g_bPracticeMode[client] && !g_bTimeractivated[client])
				{
					CL_OnStartTimerPress(client);
				}
				else
				{
					if (!g_bPracticeMode[client])
					{
						if (((GetGameTime() - g_fLastTimeNoClipUsed[client]) < 5.0) && GetSpeed(client) > 500.0)
						{
							Command_Restart(client, 1);
							return;
						}

						CL_OnStartTimerPress(client);

						if (bSoundEnabled)
							EmitSoundToClient(client, sSoundPath);

						g_bValidRun[client] = false;
					}
				}
			}
		}
	}
}

public InitZoneVariables() 
{
	g_mapZonesCount = 0;
	for (int i = 0; i < MAXZONES; i++) {
		g_mapZones[i][zoneId] = -1;
		g_mapZones[i][PointA] = -1.0;
		g_mapZones[i][PointB] = -1.0;
		g_mapZones[i][zoneId] = -1;
		g_mapZones[i][zoneType] = -1;
		g_mapZones[i][zoneTypeId] = -1;
		g_mapZones[i][zoneGroup] = -1;
		g_mapZones[i][zoneName] = 0;
		g_mapZones[i][Vis] = 0;
		g_mapZones[i][Team] = 0;
	}
}

public getZoneTeamColor(team, color[4])
{
	switch(team)
	{
		case 1:
		{
			color=beamColorM;
		}
		case 2:
		{
			color=beamColorT;
		}
		case 3:
		{
			color=beamColorCT;
		}
		default:
		{
			color=beamColorN;
		}
	}
}

public DrawBeamBox(client)
{
	int zColor[4];
	getZoneTeamColor(g_CurrentZoneTeam[client], zColor);
	TE_SendBeamBoxToClient(client, g_Positions[client][1], g_Positions[client][0], g_BeamSprite, g_HaloSprite,  0, 30, 1.0, 5.0, 5.0, 2, 1.0, zColor, 0, 1);
	CreateTimer(1.0, BeamBox, client, TIMER_REPEAT);
}

public Action:BeamBox(Handle timer, any:client)
{
	if(IsClientInGame(client))
	{
		if(g_Editing[client]==2)
		{
			int zColor[4];
			getZoneTeamColor(g_CurrentZoneTeam[client], zColor);
			TE_SendBeamBoxToClient(client, g_Positions[client][1], g_Positions[client][0], g_BeamSprite, g_HaloSprite,  0, 30, 1.0, 5.0, 5.0, 2, 1.0, zColor, 0, 1);
			return Plugin_Continue;
		}
	}
	return Plugin_Stop;
}

public Action:BeamBoxAll(Handle timer, any:data)
{
	float posA[3], posB[3];
	int zColor[4], tzColor[4], beamTeam, beamVis, zType, zGrp;
	bool draw;

	if (g_zoneDisplayType < 1)
	{
		return Plugin_Handled;
	}

	for(int i=0;i<g_mapZonesCount;++i)
	{
		posA[0] = g_mapZones[i][PointA][0];
		posA[1] = g_mapZones[i][PointA][1];
		posA[2] = g_mapZones[i][PointA][2];
		posB[0] = g_mapZones[i][PointB][0];
		posB[1] = g_mapZones[i][PointB][1];
		posB[2] = g_mapZones[i][PointB][2];
		zType = g_mapZones[i][zoneType];
		beamVis = g_mapZones[i][Vis];
		beamTeam = g_mapZones[i][Team];
		zGrp = g_mapZones[i][zoneGroup];

		draw = false;

		// Types: Start(1), End(2), Stage(3), Checkpoint(4), Speed(5), TeleToStart(6), Validator(7), Chekcer(8), Stop(0)
		if(0 < beamVis < 4)
		{
			draw = true;
		}
		else
		{
			if (g_zonesToDisplay == 1 && ((0 < zType < 3)||zType == 5))
			{
				draw = true;
			}
			else
			{
				if (g_zonesToDisplay == 2 && ((0 < zType < 4 ) ||zType == 5))
				{
					draw = true;
				}
				else
				{
					if (g_zonesToDisplay == 3)
					{
						draw = true;
					}
				}
			}
		}

		if (draw)
		{
			getZoneDisplayColor(zType, zColor, zGrp);
			getZoneTeamColor(beamTeam, tzColor);
			for (int p = 1; p <= MaxClients; p++) 
			{
				if(IsValidClient(p))
				{
					if (beamVis == 2 || beamVis == 3)
					{
						if (GetClientTeam(p) == beamVis && g_ClientSelectedZone[p]!=i)
						{
							TE_SendBeamBoxToClient(p, posA, posB, g_BeamSprite, g_HaloSprite,  0, 30, g_fChecker, 5.0, 5.0, 2, 1.0, tzColor, 0, 0);
						}
					}
					else
					{
						if(g_ClientSelectedZone[p]!=i)
							TE_SendBeamBoxToClient(p, posA, posB, g_BeamSprite, g_HaloSprite,  0, 30, g_fChecker, 5.0, 5.0, 2, 1.0, zColor, 0, 0);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public getZoneDisplayColor(type, zColor[4], zGrp)
{
	// Types: Start(1), End(2), Stage(3), Checkpoint(4), Speed(5), TeleToStart(6), Validator(7), Chekcer(8), Stop(0)
	switch (type)
	{
		case 1: {

			if (zGrp > 0)
				zColor = g_zoneBonusStartColor;
			else
				zColor = g_zoneStartColor;
		}
		case 2: {
			if (zGrp > 0)
				zColor = g_zoneBonusEndColor;
			else
				zColor = g_zoneEndColor;
		}
		case 3: {
			zColor = g_zoneStageColor;
		}
		case 4: {
			zColor = g_zoneCheckpointColor;
		}
		case 5: {
			zColor = g_zoneSpeedColor;
		}
		case 6: {
			zColor = g_zoneTeleToStartColor;
		}
		case 7: {
			zColor = g_zoneValidatorColor;
		}
		case 8: {
			zColor = g_zoneCheckerColor;
		}
		case 0: {
			zColor = g_zoneStopColor;
		}
		default: zColor = beamColorT;
	}
}

public BeamBox_OnPlayerRunCmd(client)
{	
	if(g_Editing[client]==1 || g_Editing[client]==3 ||g_Editing[client]==10|| g_Editing[client]==11)
	{
		float pos[3], ang[3];
		int zColor[4];
		getZoneTeamColor(g_CurrentZoneTeam[client], zColor);
		if(g_Editing[client]==1)
		{
			GetClientEyePosition(client, pos);
			GetClientEyeAngles(client, ang);
			TR_TraceRayFilter(pos, ang, MASK_PLAYERSOLID, RayType_Infinite, TraceRayDontHitSelf, client);
			TR_GetEndPosition(g_Positions[client][1]);
		}

		if(g_Editing[client]==10 ||g_Editing[client]==11)
		{
			GetClientEyePosition(client, pos);
			GetClientEyeAngles(client, ang);
			TR_TraceRayFilter(pos, ang, MASK_PLAYERSOLID, RayType_Infinite, TraceRayDontHitSelf, client);
			if (g_Editing[client]==10)
			{
				TR_GetEndPosition(g_fBonusStartPos[client][1]);
				TE_SendBeamBoxToClient(client, g_fBonusStartPos[client][1], g_fBonusStartPos[client][0], g_BeamSprite, g_HaloSprite,  0, 30, 0.1, 5.0, 5.0, 2, 1.0, zColor, 0, 1);
			}
			else
			{
				TR_GetEndPosition(g_fBonusEndPos[client][1]);
				TE_SendBeamBoxToClient(client, g_fBonusEndPos[client][1], g_fBonusEndPos[client][0], g_BeamSprite, g_HaloSprite,  0, 30, 0.1, 5.0, 5.0, 2, 1.0, zColor, 0, 1);
			}
		}
		else
			TE_SendBeamBoxToClient(client, g_Positions[client][1], g_Positions[client][0], g_BeamSprite, g_HaloSprite,  0, 30, 0.1, 5.0, 5.0, 2, 1.0, zColor, 0, 1);
	}
}

stock TE_SendBeamBoxToClient(client, Float:uppercorner[3], const Float:bottomcorner[3], ModelIndex, HaloIndex, StartFrame, FrameRate, Float:Life, Float:Width, Float:EndWidth, FadeLength, Float:Amplitude, const Color[4], Speed, type)
{
	//0 = Do not display zones, 1 = Display the lower edges of zones, 2 = Display whole zone
	if (!IsValidClient(client) || g_zoneDisplayType < 1)
		return;

	if (g_zoneDisplayType > 1 || type == 1)
	{
		// Create the additional corners of the box
		float tc1[3];
		AddVectors(tc1, uppercorner, tc1);
		tc1[0] = bottomcorner[0];
		
		float tc2[3];
		AddVectors(tc2, uppercorner, tc2);
		tc2[1] = bottomcorner[1];
		
		float tc3[3];
		AddVectors(tc3, uppercorner, tc3);
		tc3[2] = bottomcorner[2];

		float tc4[3];
		AddVectors(tc4, bottomcorner, tc4);
		tc4[0] = uppercorner[0];
		
		float tc5[3];
		AddVectors(tc5, bottomcorner, tc5);
		tc5[1] = uppercorner[1];
		
		float tc6[3];
		AddVectors(tc6, bottomcorner, tc6);
		tc6[2] = uppercorner[2];

		// Draw all the edges
		TE_SetupBeamPoints(uppercorner, tc1, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(uppercorner, tc2, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(uppercorner, tc3, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc6, tc1, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc6, tc2, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc6, bottomcorner, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc4, bottomcorner, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc5, bottomcorner, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc5, tc1, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc5, tc3, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc4, tc3, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
		TE_SetupBeamPoints(tc4, tc2, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
		TE_SendToClient(client);
	}
	else
		if (g_zoneDisplayType == 1)
		{
			float corner1[3], corner2[3], corner3[3], corner4[3], extraCorner[3];

			if (bottomcorner[2] < uppercorner[2]) { //  Get the corner, that has the lowest y-value
				Array_Copy(bottomcorner, corner1, 3);
				Array_Copy(uppercorner, extraCorner, 3);
			}
			else {
				Array_Copy(uppercorner, corner1, 3);
				Array_Copy(bottomcorner, extraCorner, 3);
			}

			// Get the point on the other side of the square
			Array_Copy(extraCorner, corner2, 3);
			corner2[2] = corner1[2];

			// Move along the x-axis
			Array_Copy(corner1, corner3, 3);
			corner3[0] = extraCorner[0];

			 // Move along the z-axis
			Array_Copy(corner1, corner4, 3);
			corner4[1] = extraCorner[1];

			// lift a bit higher, so not under ground
			corner1[2] += 5.0;
			corner2[2] += 5.0;
			corner3[2] += 5.0;
			corner4[2] += 5.0;

			TE_SetupBeamPoints(corner1, corner3, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
			TE_SendToClient(client);
			TE_SetupBeamPoints(corner1, corner4, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
			TE_SendToClient(client);
			TE_SetupBeamPoints(corner3, corner2, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
			TE_SendToClient(client);
			TE_SetupBeamPoints(corner4, corner2, ModelIndex, HaloIndex, StartFrame, FrameRate, Life, Width, EndWidth, FadeLength, Amplitude, Color, Speed);
			TE_SendToClient(client);
		}
}

//
// !zones menu starts here
//
public ZoneMenu(client)
{
	resetSelection(client);
	Menu ckZoneMenu = CreateMenu(Handle_ZoneMenu);
	SetMenuTitle(ckZoneMenu, "Zones");
	AddMenuItem(ckZoneMenu, "", "Create a Zone");
	AddMenuItem(ckZoneMenu, "", "Edit Zones");
	AddMenuItem(ckZoneMenu, "", "Save Zones");
	AddMenuItem(ckZoneMenu, "", "Edit Zone Global Settings");
	AddMenuItem(ckZoneMenu, "", "Reload Zones");
	AddMenuItem(ckZoneMenu, "", "Delete Zones");
	SetMenuExitBackButton(ckZoneMenu, true);
	DisplayMenu(ckZoneMenu, client, MENU_TIME_FOREVER);
}



public Handle_ZoneMenu(Handle tMenu, MenuAction:action, int client, int item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(item)
			{
				case 0:
				{
					SelectZoneGroup(client);
				}
				case 1:
				{ 
					EditZoneGroup(client);
				}
				case 2:
				{
					db_saveZones();
					resetSelection(client);
					ZoneMenu(client);
				}
				case 3:
				{
					ZoneSettings(client);
				}
				case 4:
				{
					db_selectMapZones();
					PrintToChat(client, "Zones are reloaded");
					resetSelection(client);
					ZoneMenu(client);
				}
				case 5:
				{
					ClearZonesMenu(client);
				}
			}
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}
public EditZoneGroup(client) 
{
	Menu editZoneGroupMenu = CreateMenu(h_editZoneGroupMenu);
	SetMenuTitle(editZoneGroupMenu, "Which zones do you want to edit?");
	AddMenuItem(editZoneGroupMenu, "1", "Normal map zones");
	AddMenuItem(editZoneGroupMenu, "2", "Bonus zones");
	AddMenuItem(editZoneGroupMenu, "3", "Misc zones");

	SetMenuExitBackButton(editZoneGroupMenu, true);
	DisplayMenu(editZoneGroupMenu, client, MENU_TIME_FOREVER);
}

public h_editZoneGroupMenu(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(item)
			{
				case 0: // Normal map zones
				{
					g_CurrentZoneGroup[client] = 0;
					ListZones(client, true);
				}
				case 1: // Bonus Zones
				{
					ListBonusGroups(client);
				}
				case 2: // Misc zones
				{
					g_CurrentZoneGroup[client] = 0;
					ListZones(client, false);
				}
			}
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			ZoneMenu(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}

}

public ListBonusGroups(client)
{
	Menu h_bonusGroupListing = CreateMenu(Handler_bonusGroupListing);
	SetMenuTitle(h_bonusGroupListing, "Available Bonuses");
	
	char listGroupName[256], ZoneId[64], Id[64];
	if (g_mapZoneGroupCount > 1)
	{// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
		for(int i=1;i<g_mapZoneGroupCount;++i)
		{
			Format(ZoneId, sizeof(ZoneId), "%s", g_szZoneGroupName[i]);
			IntToString(i, Id, sizeof(Id));
			Format(listGroupName, sizeof(listGroupName), ZoneId);
			AddMenuItem(h_bonusGroupListing, Id, ZoneId);
		}
	}
	else
	{
		AddMenuItem(h_bonusGroupListing, "", "No Bonuses are available", ITEMDRAW_DISABLED);
	}
	SetMenuExitBackButton(h_bonusGroupListing, true);
	DisplayMenu(h_bonusGroupListing, client, MENU_TIME_FOREVER);
}

public Handler_bonusGroupListing(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char aID[64];
			GetMenuItem(tMenu, item, aID, sizeof(aID));
			g_CurrentZoneGroup[client] = StringToInt(aID);
			ListBonusSettings(client)
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			EditZoneGroup(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

/// TODO:
public ListBonusSettings(client)
{
	Menu h_ListBonusSettings = CreateMenu(Handler_ListBonusSettings);
	SetMenuTitle(h_ListBonusSettings, "Settings for %s", g_szZoneGroupName[g_CurrentZoneGroup[client]]);
	
	AddMenuItem(h_ListBonusSettings, "1", "Create a new zone");
	AddMenuItem(h_ListBonusSettings, "2", "List Zones in this group");
	AddMenuItem(h_ListBonusSettings, "3", "Rename Bonus");
	AddMenuItem(h_ListBonusSettings, "4", "Delete this group");

	SetMenuExitBackButton(h_ListBonusSettings, true);
	DisplayMenu(h_ListBonusSettings, client, MENU_TIME_FOREVER);
}

public Handler_ListBonusSettings(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch (item)
			{
				case 0: SelectBonusZoneType(client);
				case 1: listZonesInGroup(client);
				case 2: renameBonusGroup(client);
				case 3: checkForMissclick(client);
			}
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			ListBonusGroups(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public checkForMissclick(client)
{
	Menu h_checkForMissclick = CreateMenu(Handle_checkForMissclick);
	SetMenuTitle(h_checkForMissclick, "Delete all zones in %s?", g_szZoneGroupName[g_CurrentZoneGroup[client]]);
	
	AddMenuItem(h_checkForMissclick, "1", "NO");
	AddMenuItem(h_checkForMissclick, "2", "NO");
	AddMenuItem(h_checkForMissclick, "3", "YES");
	AddMenuItem(h_checkForMissclick, "4", "NO");

	SetMenuExitBackButton(h_checkForMissclick, true);
	DisplayMenu(h_checkForMissclick, client, MENU_TIME_FOREVER);
}

public Handle_checkForMissclick(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch (item)
			{
				case 0: ListBonusSettings(client);
				case 1: ListBonusSettings(client);
				case 2: db_deleteZonesInGroup(client);
				case 3: ListBonusSettings(client);
			}
		}
		case MenuAction_Cancel:
		{
			ListBonusSettings(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public listZonesInGroup(client)
{
	Menu h_listBonusZones = CreateMenu(Handler_listBonusZones);
	if (g_mapZoneCountinGroup[g_CurrentZoneGroup[client]] > 0)
	{// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
		char listZoneName[256], ZoneId[64], Id[64];
		for(int i=0;i<g_mapZonesCount;++i)
		{
			if (g_mapZones[i][zoneGroup] == g_CurrentZoneGroup[client])
			{
				Format(ZoneId, sizeof(ZoneId), "%s-%i", g_szZoneDefaultNames[g_mapZones[i][zoneType]], g_mapZones[i][zoneTypeId]);
				IntToString(i, Id, sizeof(Id));
				Format(listZoneName, sizeof(listZoneName), ZoneId);
				AddMenuItem(h_listBonusZones, Id, ZoneId);
			}
		}
	}
	else
	{
		AddMenuItem(h_listBonusZones, "", "No zones are available", ITEMDRAW_DISABLED);
	}

	SetMenuExitBackButton(h_listBonusZones, true);
	DisplayMenu(h_listBonusZones, client, MENU_TIME_FOREVER);
}

public Handler_listBonusZones(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char aID[64];
			GetMenuItem(tMenu, item, aID, sizeof(aID));	
			g_ClientSelectedZone[client] = StringToInt(aID);
			DrawBeamBox(client);
			g_Editing[client]=2;
			if(g_ClientSelectedZone[client]!= -1)
			{
				GetClientSelectedZone(client, g_CurrentZoneTeam[client], g_CurrentZoneVis[client]);
			}
			EditorMenu(client);
		}
		case MenuAction_Cancel:
		{
			ListBonusSettings(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}


public renameBonusGroup(client)
{
	if (!IsValidClient(client))
		return;
	
	PrintToChat(client, "[%cCK%c] Please write the bonus name in chat or use %c!cancel%c to stop.", MOSSGREEN, WHITE, MOSSGREEN, WHITE);
	g_ClientRenamingZone[client] = true;
}
// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
public SelectBonusZoneType(client)
{
	Menu h_selectBonusZoneType = CreateMenu(Handler_selectBonusZoneType);
	SetMenuTitle(h_selectBonusZoneType, "Select Bonus Zone Type");
	AddMenuItem(h_selectBonusZoneType, "1", "Start");
	AddMenuItem(h_selectBonusZoneType, "2", "End");
	AddMenuItem(h_selectBonusZoneType, "3", "Stage");
	AddMenuItem(h_selectBonusZoneType, "4", "Checkpoint");
	SetMenuExitBackButton(h_selectBonusZoneType, true);
	DisplayMenu(h_selectBonusZoneType, client, MENU_TIME_FOREVER);
}

public Handler_selectBonusZoneType(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char aID[12];
			GetMenuItem(tMenu, item, aID, sizeof(aID));
			g_CurrentZoneType[client] = StringToInt(aID);
			if (g_bEditZoneType[client]) {
				db_selectzoneTypeIds(g_CurrentZoneType[client], client, g_CurrentZoneGroup[client]);
			}
			else	
				EditorMenu(client);
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			SelectZoneGroup(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}


public SelectZoneGroup(client)
{
	Menu newZoneGroupMenu = CreateMenu(h_newZoneGroupMenu);
	SetMenuTitle(newZoneGroupMenu, "Which zones do you want to create?");
	AddMenuItem(newZoneGroupMenu, "1", "Normal map zones");
	AddMenuItem(newZoneGroupMenu, "2", "Bonus zones");
	AddMenuItem(newZoneGroupMenu, "3", "Misc zones");

	SetMenuExitBackButton(newZoneGroupMenu, true);
	DisplayMenu(newZoneGroupMenu, client, MENU_TIME_FOREVER);
}

public h_newZoneGroupMenu(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(item)
			{
				case 0: // Normal map zones
				{
					g_CurrentZoneGroup[client] = 0;
					SelectNormalZoneType(client);
				}
				case 1: // Bonus Zones
				{
					g_CurrentZoneGroup[client] = -1;
					StartBonusZoneCreation(client);
				}
				case 2: // Misc zones
				{
					g_CurrentZoneGroup[client] = 0;
					SelectMiscZoneType(client);
				}
			}
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			ZoneMenu(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public StartBonusZoneCreation(client)
{
	Menu CreateBonusFirst = CreateMenu(H_CreateBonusFirst);
	SetMenuTitle(CreateBonusFirst, "Create the Bonus Start Zone:");
	if (g_Editing[client]==0)
		AddMenuItem(CreateBonusFirst, "1", "Start Drawing");
	else
	{
		AddMenuItem(CreateBonusFirst, "1", "Restart Drawing");
		AddMenuItem(CreateBonusFirst, "2", "Save Bonus Start Zone");
	}
	SetMenuExitBackButton(CreateBonusFirst, true);
	DisplayMenu(CreateBonusFirst, client, MENU_TIME_FOREVER);
}

public H_CreateBonusFirst(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(item)
			{
				case 0:
				{
					// Start
					g_Editing[client]=10;
					float pos[3], ang[3];
					GetClientEyePosition(client, pos);
					GetClientEyeAngles(client, ang);
					TR_TraceRayFilter(pos, ang, MASK_PLAYERSOLID, RayType_Infinite, TraceRayDontHitSelf, client);
					TR_GetEndPosition(g_fBonusStartPos[client][0]);
					StartBonusZoneCreation(client);
				}
				case 1: 
				{
					if (!IsValidClient(client))
						return;
					
					g_Editing[client]=2;
					PrintToChat(client, "[%cCK%c] Bonus Start Zone Created", MOSSGREEN, WHITE);
					EndBonusZoneCreation(client);
				}
			}
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			SelectZoneGroup(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public EndBonusZoneCreation(client)
{
	Menu CreateBonusSecond = CreateMenu(H_CreateBonusSecond);
	SetMenuTitle(CreateBonusSecond, "Create the Bonus End Zone:");
	if (g_Editing[client]==2)
		AddMenuItem(CreateBonusSecond, "1", "Start Drawing");
	else
	{
		AddMenuItem(CreateBonusSecond, "1", "Restart Drawing");
		AddMenuItem(CreateBonusSecond, "2", "Save Bonus End Zone");
	}
	
	SetMenuExitBackButton(CreateBonusSecond, true);
	DisplayMenu(CreateBonusSecond, client, MENU_TIME_FOREVER);
}

public H_CreateBonusSecond(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(item)
			{
				case 0:
				{
					// Start
					g_Editing[client]=11;
					float pos[3], ang[3];
					GetClientEyePosition(client, pos);
					GetClientEyeAngles(client, ang);
					TR_TraceRayFilter(pos, ang, MASK_PLAYERSOLID, RayType_Infinite, TraceRayDontHitSelf, client);
					TR_GetEndPosition(g_fBonusEndPos[client][0]);
					EndBonusZoneCreation(client);
				}
				case 1:
				{
					g_Editing[client]=2;
					SaveBonusZones(client);
					ZoneMenu(client);
				}
			}
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			SelectZoneGroup(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public SaveBonusZones(client)
{
	if ((g_fBonusEndPos[client][0][0] != -1.0 && g_fBonusEndPos[client][0][1] != -1.0 && g_fBonusEndPos[client][0][2] != -1.0) || (g_fBonusStartPos[client][1][0] != -1.0 && g_fBonusStartPos[client][1][1] != -1.0 && g_fBonusStartPos[client][1][2] != -1.0))
	{
		int id2 = g_mapZonesCount+1;
		db_insertZone(g_mapZonesCount, 1, 0, g_fBonusStartPos[client][0][0], g_fBonusStartPos[client][0][1], g_fBonusStartPos[client][0][2], g_fBonusStartPos[client][1][0], g_fBonusStartPos[client][1][1], g_fBonusStartPos[client][1][2], 0, 0, g_mapZoneGroupCount);
		db_insertZone(id2, 2, 0, g_fBonusEndPos[client][0][0], g_fBonusEndPos[client][0][1], g_fBonusEndPos[client][0][2], g_fBonusEndPos[client][1][0], g_fBonusEndPos[client][1][1], g_fBonusEndPos[client][1][2], 0, 0, g_mapZoneGroupCount);
		PrintToChat(client, "[%cCK%c] Bonus Saved!", MOSSGREEN, WHITE);
	}
	else
		PrintToChat(client, "[%cCK%c] Failed to Save Bonus, error in coordinates", MOSSGREEN, WHITE);
	
	resetSelection(client);
	ZoneMenu(client);
	db_selectMapZones();
}

public SelectNormalZoneType(client)
{
	Menu SelectNormalZoneMenu = CreateMenu(Handle_SelectNormalZoneType);
	SetMenuTitle(SelectNormalZoneMenu, "Select Zone Type");
	AddMenuItem(SelectNormalZoneMenu, "1", "Start");
	AddMenuItem(SelectNormalZoneMenu, "2", "End");
	if (g_mapZonesTypeCount[g_CurrentZoneGroup[client]][3] == 0 && g_mapZonesTypeCount[g_CurrentZoneGroup[client]][4] == 0)
	{
		AddMenuItem(SelectNormalZoneMenu, "3", "Stage");
		AddMenuItem(SelectNormalZoneMenu, "4", "Checkpoint");
	}
	else if (g_mapZonesTypeCount[g_CurrentZoneGroup[client]][3] > 0 && g_mapZonesTypeCount[g_CurrentZoneGroup[client]][4] == 0)
	{
		AddMenuItem(SelectNormalZoneMenu, "3", "Stage");
		AddMenuItem(SelectNormalZoneMenu, "3", "Stage Checkpoint");
	}
	else if (g_mapZonesTypeCount[g_CurrentZoneGroup[client]][3] == 0 && g_mapZonesTypeCount[g_CurrentZoneGroup[client]][4] > 0)
		AddMenuItem(SelectNormalZoneMenu, "4", "Checkpoint");

	AddMenuItem(SelectNormalZoneMenu, "5", "Start Speed");

	SetMenuExitBackButton(SelectNormalZoneMenu, true);
	DisplayMenu(SelectNormalZoneMenu, client, MENU_TIME_FOREVER);
}

public Handle_SelectNormalZoneType(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char aID[12];
			GetMenuItem(tMenu, item, aID, sizeof(aID));
			g_CurrentZoneType[client] = StringToInt(aID);
			if (g_bEditZoneType[client]) {
				db_selectzoneTypeIds(g_CurrentZoneType[client], client, 0);
			}
			else	
				EditorMenu(client);
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			SelectZoneGroup(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public ZoneSettings(client)
{
	Menu ZoneSettingMenu = CreateMenu(Handle_ZoneSettingMenu);
	SetMenuTitle(ZoneSettingMenu, "Global Zone Settings");
	if (g_zoneDisplayType > 1)
	{
		AddMenuItem(ZoneSettingMenu, "1", "Visible: All sides");
	}
	else
		if (g_zoneDisplayType == 1)
		{
			AddMenuItem(ZoneSettingMenu, "1", "Visible: Lower edges");
		}
		else
			if (g_zoneDisplayType < 1)
			{
				AddMenuItem(ZoneSettingMenu, "1", "Visible: Nothing");
			}
	switch(g_zonesToDisplay)
	{
		case 1:
			AddMenuItem(ZoneSettingMenu, "2", "Draw Zones: Start & End");
		case 2:
			AddMenuItem(ZoneSettingMenu, "2", "Draw Zones: Start, End, Stage, Bonus");
		case 3:
			AddMenuItem(ZoneSettingMenu, "2", "DrawZones: All zones");
	}
	SetMenuExitBackButton(ZoneSettingMenu, true);
	DisplayMenu(ZoneSettingMenu, client, MENU_TIME_FOREVER);
}

public Handle_ZoneSettingMenu(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{

		case MenuAction_Select:
		{
			switch(item)
			{
				case 0:
				{
					if (g_zoneDisplayType < 2)
						g_zoneDisplayType++;
					else
						g_zoneDisplayType = 0;
				}
				case 1:
				{
					if (g_zonesToDisplay < 3)
						g_zonesToDisplay++;
					else
						g_zonesToDisplay = 1;
				}
			}
			CreateTimer(0.1, RefreshZoneSettings, client,TIMER_FLAG_NO_MAPCHANGE);
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			ZoneMenu(client);
		}
		case MenuAction_End:
		{
			if (tMenu != null)
				CloseHandle(tMenu);
		}
	}
}

public SelectMiscZoneType(client)
{
	Menu SelectZoneMenu = CreateMenu(Handle_SelectMiscZoneType);
	SetMenuTitle(SelectZoneMenu, "Select Misc Zone Type");
	AddMenuItem(SelectZoneMenu, "6", "TeleToStart");
	AddMenuItem(SelectZoneMenu, "7", "Validator");
	AddMenuItem(SelectZoneMenu, "8", "Checker");
	AddMenuItem(SelectZoneMenu, "0", "Stop");
	SetMenuExitBackButton(SelectZoneMenu, true);
	DisplayMenu(SelectZoneMenu, client, MENU_TIME_FOREVER);
}

public Handle_SelectMiscZoneType(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char aID[12];
			GetMenuItem(tMenu, item, aID, sizeof(aID));
			g_CurrentZoneType[client] = StringToInt(aID);
			if (g_bEditZoneType[client]) {
				db_selectzoneTypeIds(g_CurrentZoneType[client], client, 0);
			}
			else	
				EditorMenu(client);
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			SelectZoneGroup(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}
		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)

public Handle_EditZoneTypeId(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char selection[12];
			GetMenuItem(tMenu, item, selection, sizeof(selection));
			g_CurrentZoneTypeId[client] = StringToInt(selection);	
			EditorMenu(client);
		}
		case MenuAction_Cancel:
		{
			SelectNormalZoneType(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public ListZones(client, bool mapzones)
{
	Menu ZoneList = CreateMenu(MenuHandler_ZoneModify);
	SetMenuTitle(ZoneList, "Available Zones");
	
	char listZoneName[256], ZoneId[64], Id[64];
	if (g_mapZonesCount > 0)
	{// Types: Start(1), End(2), Stage(3), Checkpoint(4), Speed(5), TeleToStart(6), Validator(7), Chekcer(8), Stop(0)
		if (mapzones)
		{
			for(int i=0;i<g_mapZonesCount;++i)
			{
				if (g_mapZones[i][zoneGroup] == 0 && 0 < g_mapZones[i][zoneType] < 6 )
				{
					Format(ZoneId, sizeof(ZoneId), "%s-%i", g_szZoneDefaultNames[g_mapZones[i][zoneType]], g_mapZones[i][zoneTypeId]);
					IntToString(i, Id, sizeof(Id));
					Format(listZoneName, sizeof(listZoneName), ZoneId);
					AddMenuItem(ZoneList, Id, ZoneId);
				}
			}
		}
		else
		{
			for(int i=0;i<g_mapZonesCount;++i)
			{
				if (g_mapZones[i][zoneGroup] == 0 && (g_mapZones[i][zoneType] == 0 || g_mapZones[i][zoneType] > 5))
				{
					Format(ZoneId, sizeof(ZoneId), "%s-%i", g_szZoneDefaultNames[g_mapZones[i][zoneType]], g_mapZones[i][zoneTypeId]);
					IntToString(i, Id, sizeof(Id));
					Format(listZoneName, sizeof(listZoneName), ZoneId);
					AddMenuItem(ZoneList, Id, ZoneId);
				}
			}		
		}
	}
	else
	{
		AddMenuItem(ZoneList, "", "No zones are available", ITEMDRAW_DISABLED);
	}
	SetMenuExitBackButton(ZoneList, true);
	DisplayMenu(ZoneList, client, MENU_TIME_FOREVER);
}

public MenuHandler_ZoneModify(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char aID[64];
			GetMenuItem(tMenu, item, aID, sizeof(aID));
			g_ClientSelectedZone[client] = StringToInt(aID);
			DrawBeamBox(client);
			g_Editing[client]=2;
			if(g_ClientSelectedZone[client]!= -1)
			{
				GetClientSelectedZone(client, g_CurrentZoneTeam[client], g_CurrentZoneVis[client]);
			}
			EditorMenu(client);
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			ZoneMenu(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public EditorMenu(client)
{
	if(g_Editing[client]==3)
	{	
		DrawBeamBox(client);
		g_Editing[client]=2;
	}

	Menu editMenu = CreateMenu(MenuHandler_Editor);

	if(g_ClientSelectedZone[client] != -1)
		SetMenuTitle(editMenu, "Editing Zone: %s", g_mapZones[g_ClientSelectedZone[client]][zoneName]);
	else
		SetMenuTitle(editMenu, "Creating a New %s Zone", g_szZoneDefaultNames[g_CurrentZoneType[client]]);
		
	if(g_Editing[client]==0)
		AddMenuItem(editMenu, "", "Start Drawing the Zone");
	else
		AddMenuItem(editMenu, "", "Restart the Zone Drawing");
		
	if(g_Editing[client]>0)
	{
		AddMenuItem(editMenu, "", "Set zone type");
		if(g_Editing[client]==2)
			AddMenuItem(editMenu, "", "Continue Editing");
		else
			AddMenuItem(editMenu, "", "Pause Editing");
		AddMenuItem(editMenu, "", "Delete Zone");
		AddMenuItem(editMenu, "", "Save Zone");
		switch(g_CurrentZoneTeam[client])
		{
			case 0:
			{
				AddMenuItem(editMenu, "", "Set Zone Yellow");
			}
			case 1:
			{
				AddMenuItem(editMenu, "", "Set Zone Green");
			}
			case 2:
			{
				AddMenuItem(editMenu, "", "Set Zone Red");
			}
			case 3:
			{
				AddMenuItem(editMenu, "", "Set Zone Blue");
			}
		}
		AddMenuItem(editMenu, "", "Go to Zone");
		AddMenuItem(editMenu, "", "Strech Zone");
		switch(g_CurrentZoneVis[client])
		{
			case 0:
			{
				AddMenuItem(editMenu, "", "Visibility: No One");
			}
			case 1:
			{
				AddMenuItem(editMenu, "", "Visibility: All");
			}
			case 2:
			{
				AddMenuItem(editMenu, "", "Visibility: T");
			}
			case 3:
			{
				AddMenuItem(editMenu, "", "Visibility: CT");
			}
		}
	}
	SetMenuExitBackButton(editMenu, true);
	DisplayMenu(editMenu, client, MENU_TIME_FOREVER);
}

public MenuHandler_Editor(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(item)
			{
				case 0:
				{
					// Start
					g_Editing[client]=1;
					float pos[3], ang[3];
					GetClientEyePosition(client, pos);
					GetClientEyeAngles(client, ang);
					TR_TraceRayFilter(pos, ang, MASK_PLAYERSOLID, RayType_Infinite, TraceRayDontHitSelf, client);
					TR_GetEndPosition(g_Positions[client][0]);
					EditorMenu(client);
				}
				case 1:
				{
					g_bEditZoneType[client] = true;
					SelectNormalZoneType(client);
				}
				case 2:
				{	
					// Pause
					if(g_Editing[client]==2)
					{
						g_Editing[client]=1;
					}else{
						DrawBeamBox(client);
						g_Editing[client]=2;
					}
					EditorMenu(client);
				}
				case 3:
				{
					// Delete
					if(g_ClientSelectedZone[client] != -1) 
					{
						db_deleteZone(g_mapZones[g_ClientSelectedZone[client]][zoneId]);
					}
					resetSelection(client);
					ZoneMenu(client);
				}
				case 4:
				{
					// Save
					if(g_ClientSelectedZone[client] != -1)
					{
						if (!g_bEditZoneType[client])
							db_updateZone(g_mapZones[g_ClientSelectedZone[client]][zoneId], g_mapZones[g_ClientSelectedZone[client]][zoneType], g_mapZones[g_ClientSelectedZone[client]][zoneTypeId], g_Positions[client][0], g_Positions[client][1], g_CurrentZoneVis[client], g_CurrentZoneTeam[client], g_CurrentZoneGroup[client]);
						else 
							db_updateZone(g_mapZones[g_ClientSelectedZone[client]][zoneId], g_CurrentZoneType[client], g_CurrentZoneTypeId[client], g_Positions[client][0], g_Positions[client][1], g_CurrentZoneVis[client], g_CurrentZoneTeam[client], g_CurrentZoneGroup[client]);
						g_bEditZoneType[client] = false;
					}
					else
					{
						db_insertZone(g_mapZonesCount, g_CurrentZoneType[client], g_mapZonesTypeCount[g_CurrentZoneGroup[client]][g_CurrentZoneType[client]], g_Positions[client][0][0], g_Positions[client][0][1], g_Positions[client][0][2], g_Positions[client][1][0], g_Positions[client][1][1], g_Positions[client][1][2], 0, 0, g_CurrentZoneGroup[client]);
						g_bEditZoneType[client] = false;
					}
					PrintToChat(client, "Zone saved");
					resetSelection(client);
					ZoneMenu(client);
					db_selectMapZones();
				}
				case 5:
				{
					// Set team
					++g_CurrentZoneTeam[client];
					if(g_CurrentZoneTeam[client] == 4)
						g_CurrentZoneTeam[client]=0;
					EditorMenu(client);
				}
				case 6:
				{
					// Teleport
					float ZonePos[3];
					ckSurf_StopTimer(client);
					AddVectors(g_Positions[client][0], g_Positions[client][1], ZonePos);
					ZonePos[0]=FloatDiv(ZonePos[0], 2.0);
					ZonePos[1]=FloatDiv(ZonePos[1], 2.0);
					ZonePos[2]=FloatDiv(ZonePos[2], 2.0);

					TeleportEntity(client, ZonePos, NULL_VECTOR, NULL_VECTOR);
					EditorMenu(client);
				}
				case 7:
				{
					// Scaling
					ScaleMenu(client);
				}
				case 8:
				{
					++g_CurrentZoneVis[client];
					switch(g_CurrentZoneVis[client])
					{
						case 1:
						{
							PrintToChat(client, "%t", "ZoneVisAll",MOSSGREEN,WHITE);
						}
						case 2:
						{
							PrintToChat(client, "%t", "ZoneVisT",MOSSGREEN,WHITE);
						}
						case 3:
						{
							PrintToChat(client, "%t", "ZoneVisCT",MOSSGREEN,WHITE);
						}
						case 4:
						{
							g_CurrentZoneVis[client]=0;
							PrintToChat(client, "%t", "ZoneVisInv",MOSSGREEN,WHITE);
						}
					}
					EditorMenu(client);
				}
			}
		}
		case MenuAction_Cancel:
		{
			resetSelection(client);
			ZoneMenu(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public resetSelection(client)
{
	g_CurrentZoneGroup[client]=-1;
	g_CurrentZoneTeam[client]=0;
	g_CurrentZoneVis[client]=0;
	g_ClientSelectedZone[client]=-1;
	g_Editing[client]=0;
	g_CurrentZoneTypeId[client]=-1;
	g_CurrentZoneType[client]=-1;

	float resetArray[] = {-1.0, -1.0, -1.0}
	Array_Copy(resetArray, g_Positions[client][0], 3);
	Array_Copy(resetArray, g_Positions[client][1], 3);
	Array_Copy(resetArray, g_fBonusEndPos[client][0], 3);
	Array_Copy(resetArray, g_fBonusEndPos[client][1], 3);
	Array_Copy(resetArray, g_fBonusStartPos[client][0], 3);
	Array_Copy(resetArray, g_fBonusStartPos[client][1], 3);
}

public ScaleMenu(client)
{
	g_Editing[client]=3;
	Menu ckScaleMenu = CreateMenu(MenuHandler_Scale);
	SetMenuTitle(ckScaleMenu, "Strech Zone");
	if(g_ClientSelectedPoint[client]==1)
		AddMenuItem(ckScaleMenu, "", "Point B");
	else
		AddMenuItem(ckScaleMenu, "", "Point A");
	AddMenuItem(ckScaleMenu, "", "+ Width");
	AddMenuItem(ckScaleMenu, "", "- Width");
	AddMenuItem(ckScaleMenu, "", "+ Height");
	AddMenuItem(ckScaleMenu, "", "- Height");
	AddMenuItem(ckScaleMenu, "", "+ Length");
	AddMenuItem(ckScaleMenu, "", "- Length");
	char ScaleSize[128];
	Format(ScaleSize, sizeof(ScaleSize), "Scale Size %f", g_AvaliableScales[g_ClientSelectedScale[client]]);
	AddMenuItem(ckScaleMenu, "", ScaleSize);
	SetMenuExitBackButton(ckScaleMenu, true);
	DisplayMenu(ckScaleMenu, client, MENU_TIME_FOREVER);
}

public MenuHandler_Scale(Handle tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(item)
			{
				case 0:
				{
					if(g_ClientSelectedPoint[client]==1)
						g_ClientSelectedPoint[client]=0;
					else
						g_ClientSelectedPoint[client]=1;
				}
				case 1:
				{
					g_Positions[client][g_ClientSelectedPoint[client]][0]=FloatAdd(g_Positions[client][g_ClientSelectedPoint[client]][0], g_AvaliableScales[g_ClientSelectedScale[client]]);
				}
				case 2:
				{
					g_Positions[client][g_ClientSelectedPoint[client]][0]=FloatSub(g_Positions[client][g_ClientSelectedPoint[client]][0], g_AvaliableScales[g_ClientSelectedScale[client]]);
				}
				case 3:
				{
					g_Positions[client][g_ClientSelectedPoint[client]][1]=FloatAdd(g_Positions[client][g_ClientSelectedPoint[client]][1], g_AvaliableScales[g_ClientSelectedScale[client]]);
				}
				case 4:
				{
					g_Positions[client][g_ClientSelectedPoint[client]][1]=FloatSub(g_Positions[client][g_ClientSelectedPoint[client]][1], g_AvaliableScales[g_ClientSelectedScale[client]]);
				}
				case 5:
				{
					g_Positions[client][g_ClientSelectedPoint[client]][2]=FloatAdd(g_Positions[client][g_ClientSelectedPoint[client]][2], g_AvaliableScales[g_ClientSelectedScale[client]]);
				}
				case 6:
				{
					g_Positions[client][g_ClientSelectedPoint[client]][2]=FloatSub(g_Positions[client][g_ClientSelectedPoint[client]][2], g_AvaliableScales[g_ClientSelectedScale[client]]);
				}
				case 7:
				{
					++g_ClientSelectedScale[client];
					if(g_ClientSelectedScale[client]==5)
						g_ClientSelectedScale[client]=0;
				}
			}
			ScaleMenu(client);
		}
		case MenuAction_Cancel:
		{
			EditorMenu(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public GetClientSelectedZone(int client, &team, &vis)
{
	if(g_ClientSelectedZone[client] != -1)
	{
		Format(g_CurrentZoneName[client], 32, "%s", g_mapZones[g_ClientSelectedZone[client]][zoneName]);
		Array_Copy(g_mapZones[g_ClientSelectedZone[client]][PointA], g_Positions[client][0], 3);
		Array_Copy(g_mapZones[g_ClientSelectedZone[client]][PointB], g_Positions[client][1], 3);
		team = g_mapZones[g_ClientSelectedZone[client]][Team];
		vis = g_mapZones[g_ClientSelectedZone[client]][Vis];
	}
}

public ClearZonesMenu(int client)
{
	Handle hClearZonesMenu = CreateMenu(MenuHandler_ClearZones);
	SetMenuTitle(hClearZonesMenu, "Are you sure, you want to clear all zones on this map?");
	AddMenuItem(hClearZonesMenu, "","NO GO BACK!");
	AddMenuItem(hClearZonesMenu, "","NO GO BACK!");
	AddMenuItem(hClearZonesMenu, "","YES! DO IT!");
	DisplayMenu(hClearZonesMenu, client, 20);
}

public MenuHandler_ClearZones(Handle tMenu, MenuAction:action, int client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(item==2)
			{
				for (int i = 0; i < MAXZONES; i++) {
					g_mapZones[i][zoneId] = -1;
					g_mapZones[i][PointA] = -1.0;
					g_mapZones[i][PointB] = -1.0;
					g_mapZones[i][zoneId] = -1;
					g_mapZones[i][zoneType] = -1;
					g_mapZones[i][zoneTypeId] = -1;
					g_mapZones[i][zoneName] = 0;
					g_mapZones[i][Vis] = 0;
					g_mapZones[i][Team] = 0;
				}
				g_mapZonesCount = 0;
				db_deleteMapZones();
				PrintToChat(client, "Zones cleared");
				RemoveZones();
			}
			resetSelection(client);
			ZoneMenu(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}


stock GetMiddleOfABox(const Float:vec1[3], const Float:vec2[3], Float:buffer[3])
{
	float mid[3];
	MakeVectorFromPoints(vec1, vec2, mid);
	mid[0] = mid[0] / 2.0;
	mid[1] = mid[1] / 2.0;
	mid[2] = mid[2] / 2.0;
	AddVectors(vec1, mid, buffer);
}

stock RefreshZones()
{
	RemoveZones();
	for(int i = 0; i< g_mapZonesCount; i++)
	{
		CreateZoneEntity(i);
	}
}

stock RemoveZones()
{
	// First remove any old zone triggers
	int iEnts = GetMaxEntities();
	char sClassName[64];
	for(int i=MaxClients;i<iEnts;i++)
	{
		if(IsValidEntity(i)
		&& IsValidEdict(i)
		&& GetEdictClassname(i, sClassName, sizeof(sClassName))
		&& StrContains(sClassName, "trigger_multiple") != -1
		&& GetEntPropString(i, Prop_Data, "m_iName", sClassName, sizeof(sClassName))
		&& StrContains(sClassName, "sm_ckZone") != -1)
		{
			SDKUnhook(i, SDKHook_StartTouch, StartTouchTrigger);
			SDKUnhook(i, SDKHook_EndTouch, EndTouchTrigger);
			AcceptEntityInput(i, "Kill");
		}
	}
}
