CreateZoneEntity(zoneIndex)
{
	decl Float:fMiddle[3], Float:fMins[3], Float:fMaxs[3], String:sZoneName[64];

	if(g_mapZones[zoneIndex][PointA][0] == -1.0 && g_mapZones[zoneIndex][PointA][1]  == -1.0 && g_mapZones[zoneIndex][PointA][2] == -1.0 )
	{
		return;
	}

	fMins[0] = g_mapZones[zoneIndex][PointA][0];
	fMins[1] = g_mapZones[zoneIndex][PointA][1];
	fMins[2] = g_mapZones[zoneIndex][PointA][2];
	fMaxs[0] = g_mapZones[zoneIndex][PointB][0];
	fMaxs[1] = g_mapZones[zoneIndex][PointB][1];
	fMaxs[2] = g_mapZones[zoneIndex][PointB][2];
	Format(sZoneName, sizeof(sZoneName), "%s", g_mapZones[zoneIndex][ZoneName]);

	new iEnt = CreateEntityByName("trigger_multiple");
	
	if (iEnt > 0) {
		if(!IsValidEntity(iEnt)) {
			return;
		}	
		SetEntityModel(iEnt, g_sModel);
		if(IsValidEntity(iEnt))
		{ 
			// Spawnflags:	1 - only a player can trigger this by touch, makes it so a NPC cannot fire a trigger_multiple
			// 2 - Won't fire unless triggering ent's view angles are within 45 degrees of trigger's angles (in addition to any other conditions), so if you want the player to only be able to fire the entity at a 90 degree angle you would do ",angles,0 90 0," into your spawnstring.
			// 4 - Won't fire unless player is in it and pressing use button (in addition to any other conditions), you must make a bounding box,(max\mins) for this to work.
			// 8 - Won't fire unless player/NPC is in it and pressing fire button, you must make a bounding box,(max\mins) for this to work.
			// 16 - only non-player NPCs can trigger this by touch
			// 128 - Start off, has to be activated by a target_activate to be touchable/usable
			// 256 - multiple players can trigger the entity at the same time
			DispatchKeyValue(iEnt, "spawnflags", "257");
			DispatchKeyValue(iEnt, "StartDisabled", "0");

			Format(sZoneName, sizeof(sZoneName), "sm_devzone %s", sZoneName);
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
				
				new iEffects = GetEntProp(iEnt, Prop_Send, "m_fEffects");
				iEffects |= 0x020;
				SetEntProp(iEnt, Prop_Send, "m_fEffects", iEffects);
				
				
				SDKHook(iEnt, SDKHook_StartTouch,  StartTouchTrigger);
				SDKHook(iEnt, SDKHook_EndTouch, EndTouchTrigger);
			}
			else 
			{
				PrintToServer("Not able to dispatchspawn for Entity %i in SpawnTrigger", iEnt);
				LogError("Not able to dispatchspawn for Entity %i in SpawnTrigger", iEnt);
			}
		}
		else 
		{
			PrintToServer("Entity %i did not pass the validation check in SpawnTrigger", iEnt);
			LogError("Entity %i did not pass the validation check in SpawnTrigger", iEnt);
		}
	}
}

public Action:StartTouchTrigger(caller, activator)
{
	// Ignore dead players
	if(activator < 1 || activator > MaxClients || !IsClientInGame(activator) ||!IsPlayerAlive(activator))
		return;
		
	decl String:sTargetName[256], action[2];
	GetEntPropString(caller, Prop_Data, "m_iName", sTargetName, sizeof(sTargetName));
	ReplaceString(sTargetName, sizeof(sTargetName), "sm_devzone ", "");

	for(new i; i<g_mapZonesCount; i++)
	{
		if (StrEqual(g_mapZones[i][ZoneName], sTargetName))
		{
			action[0] = g_mapZones[i][zoneType];
			action[1] = g_mapZones[i][zoneTypeId];
		}
	}
	StartTouch(activator, action);
}

public Action:EndTouchTrigger(caller, activator)
{	
	// Ignore dead players
	if(activator < 1 || activator > MaxClients || !IsClientInGame(activator) || !IsPlayerAlive(activator))
		return;
		
	decl String:sTargetName[256], action[2];
	GetEntPropString(caller, Prop_Data, "m_iName", sTargetName, sizeof(sTargetName));
	ReplaceString(sTargetName, sizeof(sTargetName), "sm_devzone ", "");
	for(new i; i<g_mapZonesCount; i++)
	{
		if (StrEqual(g_mapZones[i][ZoneName], sTargetName))
		{
			action[0] = g_mapZones[i][zoneType];
			action[1] = g_mapZones[i][zoneTypeId];
		}
	}
	EndTouch(activator, action);
}

StartTouch(client, action[])
{
	// real client
	if (1 <= client <= MaxClients)
	{
		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
		if (action[0] == 1) 						// Start
		{	
			if (g_Stage[client] == 1 && g_bCheckpointMode[client])
 				Command_goToPlayerCheckpoint(client, 1);
 			else
 			{
				if (iSpeedCapType == 2) { 
	 				if (!bClientInStartZone[client]) { 
	 					bClientInStartZone[client] = true; 
	 				} 
	 				LimitSpeed(client, 0); 
	 			}

	 			

				g_bBonusTimer[client] = false;
				g_Stage[client] = 1;
				Format(g_szCurrentStage[client], 12, "%i", g_Stage[client]);
				Client_Stop(client, 0);


				lastCheckpoint[client] = 999;
			}
		} 
		else if (action[0] == 2) 					// End
		{
			if (!g_bBonusTimer[client])
				CL_OnEndTimerPress(client);	
			else 
			{
				Client_Stop(client, 0);
				g_bBonusTimer[client] = false;
			} 
			if (g_bCheckpointMode[client])
				Command_normalMode(client, 1);
			clearPlayerCheckPoints(client);
			lastCheckpoint[client] = 999;
		} 
		else if (action[0] == 5) 					// Stage
		{
			if (g_Stage[client] == (action[1]+2) && g_bCheckpointMode[client])
				Command_goToPlayerCheckpoint(client, 1);
			else
			{
				g_bValidRun[client] = false;
				if (g_bBonusTimer[client])
				{
					Client_Stop(client, 0);
					g_bBonusTimer[client] = false;
				}


				g_Stage[client] = (action[1]+2);
				Format(g_szCurrentStage[client], 12, "%i", g_Stage[client]);
				if (action[1] != lastCheckpoint[client]) 
				{
					Checkpoint(client, action[1]);
					lastCheckpoint[client] = action[1];
				}
			}
		} 
		else if (action[0] == 6) 					// Checkpoint
		{
			if (action[1] != lastCheckpoint[client]) 
			{
				Checkpoint(client, action[1]);
				lastCheckpoint[client] = action[1];
			}
		}
		else if (action[0] == 7)					// Speed
		{
			if (g_Stage[client] == 1 && g_bCheckpointMode[client])
 				Command_goToPlayerCheckpoint(client, 1);
			else
			{
				if (iSpeedCapType == 2) {
					if (!bClientInSpeedZone[client]) {
						bClientInSpeedZone[client] = true;
					}
					LimitSpeed(client, 1);
				}

				g_bBonusTimer[client] = false;
				g_Stage[client] = 1;
				Format(g_szCurrentStage[client], 12, "%i", g_Stage[client]);
				Client_Stop(client, 0);
				lastCheckpoint[client] = 999;
			}
		} 
		else if (action[0] == 3)					// BonusStart
		{
			if (g_Stage[client] == 999 && g_bCheckpointMode[client])
 				Command_goToPlayerCheckpoint(client, 1);
 			else	
 			{
				Client_Stop(client, 0);
				g_Stage[client] = 999;
				lastCheckpoint[client] = 999;
			}
		}
		else if (action[0] == 4)					// BonusEnd
		{
			if (g_bBonusTimer[client])
				CL_OnEndTimerPress(client);	
			else
				Client_Stop(client, 0);

			if (g_bCheckpointMode[client])
				Command_normalMode(client, 1);
				
			clearPlayerCheckPoints(client);
			lastCheckpoint[client] = 999;
		}
		else if (action[0] == 0)					// Stop
		{
			g_bBonusTimer[client] = false;
			Client_Stop(client, 0);
			lastCheckpoint[client] = 999;
		}
		else if (action[0] == 8)					// TeleToStart
		{
			g_bBonusTimer[client] = false;
			Client_Stop(client, 0);
			lastCheckpoint[client] = 999;
			Command_Restart(client, 1);
		}
		else if (action[0]== 9)						// Validator
		{
			g_bValidRun[client] = true;
		}
		else if (action[0]== 10)					// Checker
		{
			if (!g_bValidRun[client])
				Command_Teleport(client, 1);
		}
	}
}

EndTouch(client, action[])
{
	// real client
	if (1 <= client <= MaxClients)
	{
		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
		if (action[0] == 1) 						// Start
		{
			if (g_bCheckpointMode[client] && !g_bTimeractivated[client])
				CL_OnStartTimerPress(client);
			else
				if (!g_bCheckpointMode[client])
				{
					CL_OnStartTimerPress(client);
			
					if (iSpeedCapType == 1) {
						LimitSpeed(client, 0);
					} else if (iSpeedCapType == 2) {
						if (bClientInStartZone[client]) {
							LimitSpeed(client, 0);
							bClientInStartZone[client] = false;
						}
					}
					if (bSoundEnabled) {
						EmitSoundToClient(client,sSoundPath);
					}
					g_Stage[client] = 1;
					g_bValidRun[client] = false;
				}
		} 
		else if (action[0] == 7) 					// Speed
		{
			if (g_bCheckpointMode[client] && !g_bTimeractivated[client])
				CL_OnStartTimerPress(client);
			else
				if (!g_bCheckpointMode[client])
				{
					CL_OnStartTimerPress(client);
			
					if (iSpeedCapType == 1) {
						LimitSpeed(client, 1);
					} else if (iSpeedCapType == 2) {
						if (bClientInSpeedZone[client]) {
							bClientInSpeedZone[client] = false;
						}
					} 
					if (bSoundEnabled)
						EmitSoundToClient(client,sSoundPath);
					g_bValidRun[client] = false;
				}
		} 
		else if (action[0] == 3)					// BonusStart
		{

			if (g_bCheckpointMode[client] && !g_bTimeractivated[client])
				CL_OnStartTimerPress(client);
			else
				if (!g_bCheckpointMode[client])
				{
					CL_OnStartTimerPress(client);
					if (bSoundEnabled)
						EmitSoundToClient(client, sSoundPath);

					g_bValidRun[client] = false;
					g_bBonusTimer[client] = true;
				}
		}
	}
}

stock LimitSpeed(client, type) {
	if (type == 0) {
		new Float:CurVelVec[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", CurVelVec);
		if (GetVectorLength(CurVelVec) > fStartPreSpeed) // MAX SPEED
		{   
			NormalizeVector(CurVelVec, CurVelVec);
			ScaleVector(CurVelVec, fStartPreSpeed); // CAP TO
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, CurVelVec);
		}
	} else if (type == 1) {
		new Float:CurVelVec[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", CurVelVec);
		if (GetVectorLength(CurVelVec) > fSpeedPreSpeed) // MAX SPEED
		{   
			NormalizeVector(CurVelVec, CurVelVec);
			ScaleVector(CurVelVec, fSpeedPreSpeed); // CAP TO
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, CurVelVec);
		}
	}
}

public InitZoneVariables() 
{
	g_mapZonesCount = 0;
	for (new i = 0; i<128; i++) {
		g_mapZones[i][zoneId] = -1;
		g_mapZones[i][PointA] = -1.0;
		g_mapZones[i][PointB] = -1.0;
		g_mapZones[i][zoneId] = -1;
		g_mapZones[i][zoneType] = -1;
		g_mapZones[i][zoneTypeId] = -1;
		g_mapZones[i][ZoneName] = 0;
		g_mapZones[i][Vis] = 0;
		g_mapZones[i][Team] = 0;
	}
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
			posA[0] = g_mapZones[id][PointA][0];
			posA[1] = g_mapZones[id][PointA][1];
			posA[2] = g_mapZones[id][PointA][2];
			posB[0] = g_mapZones[id][PointB][0];
			posB[1] = g_mapZones[id][PointB][1];
			posB[2] = g_mapZones[id][PointB][2];
			
			new Float:ZonePos[3];
			AddVectors(posA, posB, ZonePos);
			ZonePos[0]=FloatDiv(ZonePos[0], 2.0);
			ZonePos[1]=FloatDiv(ZonePos[1], 2.0);
			ZonePos[2]=FloatDiv(ZonePos[2], 2.0);
			CreateTimer(0.1, TimerCallStop, client);
			TeleportEntity(client, ZonePos, NULL_VECTOR, NULL_VECTOR);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
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
	new zColor[4];
	getZoneTeamColor(g_CurrentZoneTeam[client], zColor);
	TE_SendBeamBoxToClient(client, g_Positions[client][1], g_Positions[client][0], g_BeamSprite, g_HaloSprite,  0, 30, 1.0, 5.0, 5.0, 2, 1.0, zColor, 0);
	CreateTimer(1.0, BeamBox, client, TIMER_REPEAT);
}

public Action:BeamBox(Handle:timer, any:client)
{
	if(IsClientInGame(client))
	{
		if(g_Editing[client]==2)
		{
			new zColor[4];
			getZoneTeamColor(g_CurrentZoneTeam[client], zColor);
			TE_SendBeamBoxToClient(client, g_Positions[client][1], g_Positions[client][0], g_BeamSprite, g_HaloSprite,  0, 30, 1.0, 5.0, 5.0, 2, 1.0, zColor, 0);
			return Plugin_Continue;
		}
	}
	return Plugin_Stop;
}

public Action:BeamBoxAll(Handle:timer, any:data)
{
	decl Float:posA[3], Float:posB[3], zColor[4], beamTeam, beamVis, String:nombre[64];
	for(new i=0;i<g_mapZonesCount;++i)
	{
		posA[0] = g_mapZones[i][PointA][0];
		posA[1] = g_mapZones[i][PointA][1];
		posA[2] = g_mapZones[i][PointA][2];
		posB[0] = g_mapZones[i][PointB][0];
		posB[1] = g_mapZones[i][PointB][1];
		posB[2] = g_mapZones[i][PointB][2];
		beamTeam = g_mapZones[i][Vis];
		beamVis = g_mapZones[i][Team];
		Format(nombre, 64, "%s", g_mapZones[i][ZoneName]);

		for (new p = 1; p <= MaxClients; p++) 
		{
			if(IsClientInGame(p))
			{
				if(g_ClientSelectedZone[p]!=i && (beamVis==1 || GetClientTeam(p)==beamVis))
				{
					getZoneTeamColor(beamTeam, zColor);
					TE_SendBeamBoxToClient(p, posA, posB, g_BeamSprite, g_HaloSprite,  0, 30, g_fChecker, 5.0, 5.0, 2, 1.0, zColor, 0);
				}
			}
		}
	}	
	return Plugin_Continue;
}

public BeamBox_OnPlayerRunCmd(client)
{	
	if(g_Editing[client]==1 || g_Editing[client]==3)
	{
		new Float:pos[3], Float:ang[3], zColor[4];
		getZoneTeamColor(g_CurrentZoneTeam[client], zColor);
		if(g_Editing[client]==1)
		{
			GetClientEyePosition(client, pos);
			GetClientEyeAngles(client, ang);
			TR_TraceRayFilter(pos, ang, MASK_PLAYERSOLID, RayType_Infinite, TraceRayDontHitSelf, client);
			TR_GetEndPosition(g_Positions[client][1]);
		}
		TE_SendBeamBoxToClient(client, g_Positions[client][1], g_Positions[client][0], g_BeamSprite, g_HaloSprite,  0, 30, 0.1, 5.0, 5.0, 2, 1.0, zColor, 0);
	}
}

stock TE_SendBeamBoxToClient(client, Float:uppercorner[3], const Float:bottomcorner[3], ModelIndex, HaloIndex, StartFrame, FrameRate, Float:Life, Float:Width, Float:EndWidth, FadeLength, Float:Amplitude, const Color[4], Speed)
{
	// Create the additional corners of the box
	new Float:tc1[3];
	AddVectors(tc1, uppercorner, tc1);
	tc1[0] = bottomcorner[0];
	
	new Float:tc2[3];
	AddVectors(tc2, uppercorner, tc2);
	tc2[1] = bottomcorner[1];
	
	new Float:tc3[3];
	AddVectors(tc3, uppercorner, tc3);
	tc3[2] = bottomcorner[2];
	
	new Float:tc4[3];
	AddVectors(tc4, bottomcorner, tc4);
	tc4[0] = uppercorner[0];
	
	new Float:tc5[3];
	AddVectors(tc5, bottomcorner, tc5);
	tc5[1] = uppercorner[1];
	
	new Float:tc6[3];
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

public ZoneMenu(client)
{
	resetSelection(client);
	new Handle:Menu = CreateMenu(Handle_ZoneMenu);
	SetMenuTitle(Menu, "Zones");
	AddMenuItem(Menu, "", "Create Zone");
	AddMenuItem(Menu, "", "Edit Zones");
	AddMenuItem(Menu, "", "Save Zones");
	AddMenuItem(Menu, "", "Reload Zones");
	AddMenuItem(Menu, "", "Clear Zones");
	SetMenuExitBackButton(Menu, true);
	ckSurf_StopUpdatingOfClimbersMenu(client);
	DisplayMenu(Menu, client, MENU_TIME_FOREVER);
}

public Handle_ZoneMenu(Handle:tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			switch(item)
			{
				case 0:
				{
					SelectZoneType(client);
				}
				case 1:
				{ 
					ListZones(client);
				}
				case 2:
				{
					db_saveZones();
					resetSelection(client);
					ZoneMenu(client);
				}
				case 3:
				{
					db_selectMapZones();
					PrintToChat(client, "Zones are reloaded");
					resetSelection(client);
					ZoneMenu(client);
				}
				case 4:
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

public SelectZoneType(client)
{
	new Handle:SelectZoneMenu = CreateMenu(Handle_SelectZoneType);
	SetMenuTitle(SelectZoneMenu, "Select Zone Type");
	AddMenuItem(SelectZoneMenu, "1", "Start");
	AddMenuItem(SelectZoneMenu, "2", "End");
	AddMenuItem(SelectZoneMenu, "3", "Bonus Start");
	AddMenuItem(SelectZoneMenu, "4", "Bonus End");
	if (g_mapZonesTypeCount[5] == 0 && g_mapZonesTypeCount[6] == 0)
	{
		AddMenuItem(SelectZoneMenu, "5", "Stage");
		AddMenuItem(SelectZoneMenu, "6", "Checkpoint");
	}
	else if (g_mapZonesTypeCount[5] > 0 && g_mapZonesTypeCount[6] == 0)
		AddMenuItem(SelectZoneMenu, "5", "Stage");
	else if (g_mapZonesTypeCount[5] == 0 && g_mapZonesTypeCount[6] > 0)
		AddMenuItem(SelectZoneMenu, "6", "Checkpoint");

	AddMenuItem(SelectZoneMenu, "7", "Start Speed");
	AddMenuItem(SelectZoneMenu, "8", "TeleToStart");
	AddMenuItem(SelectZoneMenu, "9", "Validator");
	AddMenuItem(SelectZoneMenu, "10", "Checker");
	AddMenuItem(SelectZoneMenu, "0", "Stop");
	SetMenuExitBackButton(SelectZoneMenu, true);
	ckSurf_StopUpdatingOfClimbersMenu(client);
	DisplayMenu(SelectZoneMenu, client, MENU_TIME_FOREVER);
}
		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)

public Handle_EditZoneTypeId(Handle:tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			new String:selection[12];
			GetMenuItem(tMenu, item, selection, sizeof(selection));
			g_CurrentZoneTypeId[client] = StringToInt(selection);	
			EditorMenu(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public Handle_SelectZoneType(Handle:tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			decl String:aID[12];
			GetMenuItem(tMenu, item, aID, sizeof(aID));
			g_CurrentZoneType[client] = StringToInt(aID);
			if (g_bEditZoneType[client]) {
				db_selectzoneTypeIds(g_CurrentZoneType[client], client);
			}
			else	
				EditorMenu(client);
		}
		case MenuAction_End:
		{
			CloseHandle(tMenu);
		}
	}
}

public ListZones(client)
{
	new Handle:Menu = CreateMenu(MenuHandler_ZoneModify);
	SetMenuTitle(Menu, "Available Zones");
	
	decl String:listZoneName[256], String:ZoneId[64], String:Id[64];
	if (g_mapZonesCount > 0)
	{
		for(new i=0;i<g_mapZonesCount;++i)
		{
			Format(ZoneId, sizeof(ZoneId), "%s", g_mapZones[i][ZoneName]);
			IntToString(i, Id, sizeof(Id));
			Format(listZoneName, sizeof(listZoneName), ZoneId);
			AddMenuItem(Menu, Id, ZoneId);
		}
	}else{
		AddMenuItem(Menu, "", "No zones are available", ITEMDRAW_DISABLED);
	}
	SetMenuExitBackButton(Menu, true);
	ckSurf_StopUpdatingOfClimbersMenu(client);
	DisplayMenu(Menu, client, MENU_TIME_FOREVER);
}

public EditorMenu(client)
{
	if(g_Editing[client]==3)
	{	
		DrawBeamBox(client);
		g_Editing[client]=2;
	}
	new Handle:Menu = CreateMenu(MenuHandler_Editor);
	if(g_ClientSelectedZone[client] != -1)
		SetMenuTitle(Menu, "Editing Zone: %s", g_mapZones[g_ClientSelectedZone[client]][ZoneName]);
	else
		SetMenuTitle(Menu, "Creating New Zone");
		
	if(g_Editing[client]==0)
		AddMenuItem(Menu, "", "Start Drawing Zone");
	else
		AddMenuItem(Menu, "", "Restart Zone Drawing");
		
	if(g_Editing[client]>0)
	{
		AddMenuItem(Menu, "", "Set zone type");
		if(g_Editing[client]==2)
			AddMenuItem(Menu, "", "Continue Editing");
		else
			AddMenuItem(Menu, "", "Pause Editing");
		AddMenuItem(Menu, "", "Cancel Zone");
		AddMenuItem(Menu, "", "Save Zone");
		switch(g_CurrentZoneTeam[client])
		{
			case 0:
			{
				AddMenuItem(Menu, "", "Set Zone Yellow");
			}
			case 1:
			{
				AddMenuItem(Menu, "", "Set Zone Green");
			}
			case 2:
			{
				AddMenuItem(Menu, "", "Set Zone Red");
			}
			case 3:
			{
				AddMenuItem(Menu, "", "Set Zone Blue");
			}
		}
		AddMenuItem(Menu, "", "Go to Zone");
		AddMenuItem(Menu, "", "Strech Zone");
		switch(g_CurrentZoneVis[client])
		{
			case 0:
			{
				AddMenuItem(Menu, "", "Visibility: No One");
			}
			case 1:
			{
				AddMenuItem(Menu, "", "Visibility: All");
			}
			case 2:
			{
				AddMenuItem(Menu, "", "Visibility: T");
			}
			case 3:
			{
				AddMenuItem(Menu, "", "Visibility: CT");
			}
		}
	}
	SetMenuExitBackButton(Menu, true);
	ckSurf_StopUpdatingOfClimbersMenu(client);
	DisplayMenu(Menu, client, MENU_TIME_FOREVER);
}

public MenuHandler_Editor(Handle:tMenu, MenuAction:action, client, item)
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
					new Float:pos[3], Float:ang[3];
					GetClientEyePosition(client, pos);
					GetClientEyeAngles(client, ang);
					TR_TraceRayFilter(pos, ang, MASK_PLAYERSOLID, RayType_Infinite, TraceRayDontHitSelf, client);
					TR_GetEndPosition(g_Positions[client][0]);
					EditorMenu(client);
				}
				case 1:
				{
					g_bEditZoneType[client] = true;
					SelectZoneType(client);
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
					g_Editing[client]=2;
					if(g_ClientSelectedZone[client] != -1)
					{
						if (!g_bEditZoneType[client])
							db_updateZone(g_mapZones[g_ClientSelectedZone[client]][zoneId], g_mapZones[g_ClientSelectedZone[client]][zoneType], g_mapZones[g_ClientSelectedZone[client]][zoneTypeId], g_Positions[client][0], g_Positions[client][1], g_CurrentZoneVis[client], g_CurrentZoneTeam[client]);
						else 
							db_updateZone(g_mapZones[g_ClientSelectedZone[client]][zoneId], g_CurrentZoneType[client], g_CurrentZoneTypeId[client], g_Positions[client][0], g_Positions[client][1], g_CurrentZoneVis[client], g_CurrentZoneTeam[client]);
						g_bEditZoneType[client] = false;
					}
					else
					{
						db_insertZone(g_mapZonesCount, g_CurrentZoneType[client], g_mapZonesTypeCount[g_CurrentZoneType[client]], g_Positions[client][0][0], g_Positions[client][0][1], g_Positions[client][0][2], g_Positions[client][1][0], g_Positions[client][1][1], g_Positions[client][1][2], 0, 0);
						g_bEditZoneType[client] = false;
					}
					PrintToChat(client, "Zone saved");
					resetSelection(client);
					ZoneMenu(client);
					RefreshZones();
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
					new Float:ZonePos[3];
					ckSurf_StopTimer(client);
					AddVectors(g_Positions[client][0], g_Positions[client][1], ZonePos);
					ZonePos[0]=FloatDiv(ZonePos[0], 2.0);
					ZonePos[1]=FloatDiv(ZonePos[1], 2.0);
					ZonePos[2]=FloatDiv(ZonePos[2], 2.0);
					CreateTimer(0.1, TimerCallStop, client);
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
	g_CurrentZoneTeam[client]=0;
	g_CurrentZoneVis[client]=0;
	g_ClientSelectedZone[client]=-1;
	g_Editing[client]=0;
	g_CurrentZoneTypeId[client]=-1;
	g_CurrentZoneType[client]=-1;
	for (new i = 0; i < MAXPLAYERS+1; i++)
	{
		g_Positions[i][0][0] = 0.0;
		g_Positions[i][0][1] = 0.0;
		g_Positions[i][0][2] = 0.0;
		g_Positions[i][1][0] = 0.0;
		g_Positions[i][1][1] = 0.0;
		g_Positions[i][1][2] = 0.0;
	}
}

public ScaleMenu(client)
{
	g_Editing[client]=3;
	new Handle:Menu = CreateMenu(MenuHandler_Scale);
	SetMenuTitle(Menu, "Strech Zone");
	if(g_ClientSelectedPoint[client]==1)
		AddMenuItem(Menu, "", "Point B");
	else
		AddMenuItem(Menu, "", "Point A");
	AddMenuItem(Menu, "", "+ Width");
	AddMenuItem(Menu, "", "- Width");
	AddMenuItem(Menu, "", "+ Height");
	AddMenuItem(Menu, "", "- Height");
	AddMenuItem(Menu, "", "+ Length");
	AddMenuItem(Menu, "", "- Length");
	decl String:ScaleSize[128];
	Format(ScaleSize, sizeof(ScaleSize), "Scale Size %f", g_AvaliableScales[g_ClientSelectedScale[client]]);
	AddMenuItem(Menu, "", ScaleSize);
	SetMenuExitBackButton(Menu, true);
	ckSurf_StopUpdatingOfClimbersMenu(client);
	DisplayMenu(Menu, client, MENU_TIME_FOREVER);
}

public MenuHandler_Scale(Handle:tMenu, MenuAction:action, client, item)
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

public MenuHandler_ZoneModify(Handle:tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			new String:aID[64];
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

public GetClientSelectedZone(client, &team, &vis)
{
	if(g_ClientSelectedZone[client] != -1)
	{
		Format(g_CurrentZoneName[client], 32, "%s", g_mapZones[g_ClientSelectedZone[client]][ZoneName]);
		g_Positions[client][0][0] = g_mapZones[g_ClientSelectedZone[client]][PointA][0];
		g_Positions[client][0][1] = g_mapZones[g_ClientSelectedZone[client]][PointA][1];
		g_Positions[client][0][2] = g_mapZones[g_ClientSelectedZone[client]][PointA][2];
		g_Positions[client][1][0] = g_mapZones[g_ClientSelectedZone[client]][PointB][0];
		g_Positions[client][1][1] = g_mapZones[g_ClientSelectedZone[client]][PointB][1];
		g_Positions[client][1][2] = g_mapZones[g_ClientSelectedZone[client]][PointB][2];
		team = g_mapZones[g_ClientSelectedZone[client]][Team];
		vis = g_mapZones[g_ClientSelectedZone[client]][Vis];
	}
}

public ClearZonesMenu(client)
{
	new Handle:Menu = CreateMenu(MenuHandler_ClearZones);
	SetMenuTitle(Menu, "Are you sure, you want to clear all zones on this map?");
	AddMenuItem(Menu, "","NO GO BACK!");
	AddMenuItem(Menu, "","NO GO BACK!");
	AddMenuItem(Menu, "","YES! DO IT!");
	ckSurf_StopUpdatingOfClimbersMenu(client);
	DisplayMenu(Menu, client, 20);
}

public MenuHandler_ClearZones(Handle:tMenu, MenuAction:action, client, item)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(item==2)
			{
				for (new i = 0; i<128; i++) {
					g_mapZones[i][zoneId] = -1;
					g_mapZones[i][PointA] = -1.0;
					g_mapZones[i][PointB] = -1.0;
					g_mapZones[i][zoneId] = -1;
					g_mapZones[i][zoneType] = -1;
					g_mapZones[i][zoneTypeId] = -1;
					g_mapZones[i][ZoneName] = 0;
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
	new Float:mid[3];
	MakeVectorFromPoints(vec1, vec2, mid);
	mid[0] = mid[0] / 2.0;
	mid[1] = mid[1] / 2.0;
	mid[2] = mid[2] / 2.0;
	AddVectors(vec1, mid, buffer);
}

stock RefreshZones()
{
	RemoveZones();
	for(new i = 0; i< g_mapZonesCount; i++)
	{
		CreateZoneEntity(i);
	}
}

stock RemoveZones()
{
	// First remove any old zone triggers
	new iEnts = GetMaxEntities();
	decl String:sClassName[64];
	for(new i=MaxClients;i<iEnts;i++)
	{
		if(IsValidEntity(i)
		&& IsValidEdict(i)
		&& GetEdictClassname(i, sClassName, sizeof(sClassName))
		&& StrContains(sClassName, "trigger_multiple") != -1
		&& GetEntPropString(i, Prop_Data, "m_iName", sClassName, sizeof(sClassName))
		&& StrContains(sClassName, "sm_devzone") != -1)
		{
			SDKUnhook(i, SDKHook_StartTouch, StartTouchTrigger);
			SDKUnhook(i, SDKHook_EndTouch, EndTouchTrigger);
			AcceptEntityInput(i, "Kill");
		}
	}
}
