public Action SayText2(UserMsg msg_id, Handle bf, int[] players, int playersNum, bool reliable, bool init)
{
	if (!reliable)return Plugin_Continue;
	char buffer[25];
	if (GetUserMessageType() == UM_Protobuf)
	{
		PbReadString(bf, "msg_name", buffer, sizeof(buffer));
		if (StrEqual(buffer, "#Cstrike_Name_Change"))
			return Plugin_Handled;
	}
	else
	{
		BfReadChar(bf);
		BfReadChar(bf);
		BfReadString(bf, buffer, sizeof(buffer));

		if (StrEqual(buffer, "#Cstrike_Name_Change"))
			return Plugin_Handled;
	}
	return Plugin_Continue;
}

//attack spam protection
public Action Event_OnFire(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client > 0 && IsClientInGame(client) && GetConVarBool(g_hAttackSpamProtection))
	{
		char weapon[64];
		GetEventString(event, "weapon", weapon, 64);
		if (StrContains(weapon, "knife", true) == -1 && g_AttackCounter[client] < 41)
		{
			if (g_AttackCounter[client] < 41)
			{
				g_AttackCounter[client]++;
				if (StrContains(weapon, "grenade", true) != -1 || StrContains(weapon, "flash", true) != -1)
				{
					g_AttackCounter[client] = g_AttackCounter[client] + 9;
					if (g_AttackCounter[client] > 41)
						g_AttackCounter[client] = 41;
				}
			}
		}
	}
}

// - PlayerSpawn -
public Action Event_OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client))
	{
		bool inBonus = false;
		if (g_iClientInZone[client][2] > 0) 
		{
			inBonus = true;	
		}
		g_SpecTarget[client] = -1;
		g_bPause[client] = false;
		g_bFirstTimerStart[client] = true;
		SetEntityMoveType(client, MOVETYPE_WALK);
		SetEntityRenderMode(client, RENDER_NORMAL);

		//strip weapons
		if (IsValidClient(client) && (GetClientTeam(client) > 1))
		{
			StripAllWeapons(client);
			if (!IsFakeClient(client))
			{
				GivePlayerItem(client, "weapon_usp_silencer");
			}
			if (!g_bStartWithUsp[client])
			{
				int weapon = GetPlayerWeaponSlot(client, 2);
				if (weapon != -1 && !IsFakeClient(client))
					GivePlayerItem(client, "weapon_glock");
			}
		}

		//NoBlock
		if (GetConVarBool(g_hCvarNoBlock))
			SetEntData(client, FindSendPropInfo("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
		else
			SetEntData(client, FindSendPropInfo("CBaseEntity", "m_CollisionGroup"), 5, 4, true);

		//botmimic2
		if (g_hBotMimicsRecord[client] != null && IsFakeClient(client))
		{
			g_BotMimicTick[client] = 0;
			g_CurrentAdditionalTeleportIndex[client] = 0;
		}

		if (IsFakeClient(client))
		{
			if (client == g_InfoBot)
				CS_SetClientClanTag(client, "");
			else if (client == g_RecordBot)
				CS_SetClientClanTag(client, "MAP REPLAY");
			else if (client == g_BonusBot)
				CS_SetClientClanTag(client, "BONUS REPLAY");
			return Plugin_Continue;
		}

		//change player skin
		if (GetConVarBool(g_hPlayerSkinChange) && (GetClientTeam(client) > 1))
		{
			char szBuffer[256];
			GetConVarString(g_hArmModel, szBuffer, 256);
			SetEntPropString(client, Prop_Send, "m_szArmsModel", szBuffer);

			GetConVarString(g_hPlayerModel, szBuffer, 256);
			SetEntityModel(client, szBuffer);
		}

		//1st spawn & t/ct
		if (g_bFirstSpawn[client] && (GetClientTeam(client) > 1))
		{
			float fLocation[3];
			GetClientAbsOrigin(client, fLocation);
			if (setClientLocation(client, fLocation) == -1)
			{
				g_iClientInZone[client][2] = 0;
				g_bIgnoreZone[client] = false;
			}

			StartRecording(client);
			CreateTimer(1.5, CenterMsgTimer, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
			g_bFirstSpawn[client] = false;
		}

		//get start pos for challenge
		GetClientAbsOrigin(client, g_fSpawnPosition[client]);

		//restore position
		if (!g_specToStage[client])
		{

			if ((GetClientTeam(client) > 1))
			{
				if (g_bRestorePosition[client])
				{
					g_bPositionRestored[client] = true;
					if (inBonus)
					{
						teleportEntitySafeBonus(client, g_fPlayerCordsRestore[client], g_fPlayerAnglesRestore[client], NULL_VECTOR, false);
					}
					else
					{
						teleportEntitySafe(client, g_fPlayerCordsRestore[client], g_fPlayerAnglesRestore[client], NULL_VECTOR, false);
					}
					g_bRestorePosition[client] = false;
				}
				else
				{
					if (g_bRespawnPosition[client])
					{
						if (inBonus)
						{
							teleportEntitySafeBonus(client, g_fPlayerCordsRestore[client], g_fPlayerAnglesRestore[client], NULL_VECTOR, false);
						}
						else
						{
							teleportEntitySafe(client, g_fPlayerCordsRestore[client], g_fPlayerAnglesRestore[client], NULL_VECTOR, false);
						}
						g_bRespawnPosition[client] = false;
					}
					else
					{
						g_bTimeractivated[client] = false;
						g_fStartTime[client] = -1.0;
						g_fCurrentRunTime[client] = -1.0;

						// Spawn client to the start zone.
						if (GetConVarBool(g_hSpawnToStartZone))
							Command_Restart(client, 1);	
					}
				}
			}
		}
		else
		{
			Array_Copy(g_fTeleLocation[client], g_fPlayerCordsRestore[client], 3);
			Array_Copy(NULL_VECTOR, g_fPlayerAnglesRestore[client], 3);
			SetEntPropVector(client, Prop_Data, "m_vecVelocity", view_as<float>( { 0.0, 0.0, -100.0 } ));
			teleportEntitySafe(client, g_fTeleLocation[client], NULL_VECTOR, view_as<float>( { 0.0, 0.0, -100.0 } ), false);
			g_specToStage[client] = false;
		}

		//hide radar
		RequestFrame(HideHud, GetClientSerial(client));

		//set clantag
		RequestFrame(SetClanTag, GetClientSerial(client));

		//set speclist
		Format(g_szPlayerPanelText[client], 512, "");

		//get speed & origin
		g_fLastSpeed[client] = GetSpeed(client);
	}
	else if (IsValidClient(client) && IsFakeClient(client)) 
	{
		SetEntData(client, FindSendPropInfo("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
	}
	return Plugin_Continue;
}

public void PlayerSpawn(int client)
{

}

public Action Say_Hook(int client, const char[] command, int argc)
{
	// Call Admin - Own Reason
	if (g_bClientOwnReason[client])
	{
		g_bClientOwnReason[client] = false;
		return Plugin_Continue;
	}

	// read chat message and normalize it
	char sText[1024];
	GetCmdArgString(sText, sizeof(sText));
	StripQuotes(sText);
	TrimString(sText);

	// skip if invalid client
	if (!IsValidClient(client))
		return Plugin_Continue;

	// forward and abort if renaming zones
	if (g_ClientRenamingZone[client])
	{
		Admin_renameZone(client, sText);
		return Plugin_Handled;
	}

	// skip if chat processing is disabled
	if (!GetConVarBool(g_henableChatProcessing))
		return Plugin_Continue;

	// abort if message is empty
	if (!sText[0])
		return Plugin_Handled;

	// heuristic help messages
	// @TODO make this dynamic by replicating setup in DB.
	if (StrContains(sText, "how", false) >= 0)
	{
		if (StrContains(sText, "spec", false) >= 0)
		{
			PrintToChatAll("%t", "SpecHelp", MOSSGREEN, g_szChatPrefix, WHITE, MOSSGREEN, WHITE, MOSSGREEN, WHITE, MOSSGREEN);
			PrintToChat(client, "[%c%s%c] %cDoes this answer your question?", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW);
			return Plugin_Handled;
		}
		if (StrContains(sText, "noclip", false) >= 0)
		{
			PrintToChatAll("%t", "NCHelp", MOSSGREEN, g_szChatPrefix, WHITE, MOSSGREEN, WHITE, MOSSGREEN, WHITE, MOSSGREEN);
			PrintToChat(client, "[%c%s%c] %cDoes this answer your question?", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW);
			return Plugin_Handled;
		}
	}

	// abort if client is gagged (muted)
	if (BaseComm_IsClientGagged(client))
		return Plugin_Handled;

	// lowercase commands if first character is uppercase
	if ((sText[0] == '/' || sText[0] == '!') && IsCharUpper(sText[1]))
	{
		for (int i = 0; i <= strlen(sText); ++i)
		{
			if ((sText[i] == ' '))
				break; // only lowercase command (no arguments)
			sText[i] = CharToLower(sText[i]);
		}
		FakeClientCommand(client, "say %s", sText);
		return Plugin_Handled;
	}

	// abort if client invoked hidden chat command (hidden_chat_commands.txt)
	char commandlookup[128][128];
	ExplodeString(sText, " ", commandlookup, 1, 128);
	for (int i = 0; i < sizeof(g_BlockedChatText); i++)
		if (StrEqual(g_BlockedChatText[i], commandlookup[0], false))
			return Plugin_Handled;

	// check spam (warns/kicks spamming players), should be after blocked commands (for !r, etc.)
	if (checkSpam(client))
		return Plugin_Handled;

	// final normalize (remove colors)
	normalizeChatString(sText, 1024);

	// skip if chat trigger
	if ((IsChatTrigger() && sText[0] == '/') || (sText[0] == '@'))
		return Plugin_Continue;

	// get player name and normalize it
	char szName[64];
	Format(szName, sizeof(szName), "%N", client);
	normalizeChatString(szName, 64);

	// log the chat of the player to the server so that tools such as HLSW/HLSTATX see it and also it remains logged in the log file
	WriteChatLog(client, "say", sText);
	PrintToServer("%s: %s", szName, sText);

	// build final message string with colors, ranks, etc.
	char sTextFinal[1024];
	bool bHasSpecialRank = StrEqual(g_pr_rankname[client], "ADMIN", false) && GetConVarBool(g_hAdminClantag);
	bool bUseChatRank = GetConVarBool(g_hPointSystem) || bHasSpecialRank;
	bool bUseCountry = GetConVarBool(g_hCountry);

	// get colored chat rank
	char szChatRank[64];
	Format(szChatRank, 64, "%s", g_pr_chat_coloredrank[client]);

	// color player name based on rank if enabled
	if (GetConVarBool(g_hPointSystem) && GetConVarBool(g_hColoredNames))
		Format(szName, sizeof(szName), "%s%s", g_pr_rankColor[client], szName);

	// build: country code
	if (bUseCountry)
	{
		Format(sTextFinal, sizeof(sTextFinal), "{green}%s{default}", g_szCountryCode[client]);
		if (!bUseChatRank)
			Format(sTextFinal, sizeof(sTextFinal), "[%s]", sTextFinal);
	}

	// build: rank
	if (bUseChatRank)
		Format(sTextFinal, sizeof(sTextFinal), "%s {default}%s{default}", sTextFinal, szChatRank);

	// build: spec/death inserts
	if (GetClientTeam(client) == CS_TEAM_SPECTATOR)
		Format(sTextFinal, sizeof(sTextFinal), "%s {default}%s", sTextFinal, "*SPEC*");
	else if (!IsPlayerAlive(client))
		Format(sTextFinal, sizeof(sTextFinal), "%s {default}%s", sTextFinal, "*DEAD*");

	// build: player name & message
	if (GetClientTeam(client) == CS_TEAM_SPECTATOR)
		Format(sTextFinal, sizeof(sTextFinal), "%s {grey}%s{default}: %s", sTextFinal, szName, sText);
	else
		Format(sTextFinal, sizeof(sTextFinal), "%s {default}%s{default}: %s", sTextFinal, szName, sText);

	// print message to chat
	CPrintToChatAll("%s", sTextFinal);

	// print message to player consoles
	normalizeChatString(sTextFinal, sizeof(sTextFinal));
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		PrintToConsole(i, "%s", sTextFinal);
	}

	// all done :)
	return Plugin_Handled;
}

public Action Event_OnPlayerTeamJoin(Event event, const char[] name, bool dontBroadcast)
{
	if(!g_hAnnouncePlayers.BoolValue)
	{
		if(!GetEventBool(event, "silent"))
		{
			event.BroadcastDisabled = true;
		}
	}
	return Plugin_Continue;
}

public Action Event_OnPlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (!IsValidClient(client) || IsFakeClient(client))
		return Plugin_Continue;
	int team = GetEventInt(event, "team");
	if (team == 1)
	{	
		SpecListMenuDead(client);
		if (!g_bFirstSpawn[client])
		{
			GetClientAbsOrigin(client, g_fPlayerCordsRestore[client]);
			GetClientEyeAngles(client, g_fPlayerAnglesRestore[client]);
			g_bRespawnPosition[client] = true;
		}
		if (g_bTimeractivated[client])
		{
			g_fStartPauseTime[client] = GetGameTime();
			if (g_fPauseTime[client] > 0.0)
				g_fStartPauseTime[client] = g_fStartPauseTime[client] - g_fPauseTime[client];
		}
		g_bSpectate[client] = true;
		g_bPause[client] = false;
	}
	return Plugin_Continue;
}

public Action Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	if (GetConVarBool(g_hDisconnectMsg))
	{
		char szName[64];
		char disconnectReason[64];
		int clientid = GetEventInt(event, "userid");
		int client = GetClientOfUserId(clientid);
		if (!IsValidClient(client) || IsFakeClient(client))
			return Plugin_Handled;
		GetEventString(event, "name", szName, sizeof(szName));
		GetEventString(event, "reason", disconnectReason, sizeof(disconnectReason));
		for (int i = 1; i <= MaxClients; i++)
			if (IsValidClient(i) && i != client && !IsFakeClient(i))
				PrintToChat(i, "%t", "Disconnected1", WHITE, MOSSGREEN, szName, WHITE, disconnectReason);
		return Plugin_Handled;
	}
	else
	{
		SetEventBroadcast(event, true);
		return Plugin_Handled;
	}
}

public Action Hook_SetTransmit(int entity, int client)
{
	if (client != entity && (0 < entity <= MaxClients) && IsValidClient(client))
	{
		if (g_bChallenge[client] && !g_bHide[client])
		{
			if (!StrEqual(g_szSteamID[entity], g_szChallenge_OpponentID[client], false))
				return Plugin_Handled;
		}
		else
			if (g_bHide[client] && entity != g_SpecTarget[client])
				return Plugin_Handled;
			else
				if (entity == g_InfoBot && entity != g_SpecTarget[client])
					return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action Event_OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (IsValidClient(client))
	{
		if (!IsFakeClient(client))
		{
			if (g_hRecording[client] != null)
			{
				StopRecording(client);
			}
			Client_Surrender(client, 0);
			RequestFrame(RemoveRagdoll, GetClientSerial(client));
		}
		else
			if (g_hBotMimicsRecord[client] != null)
			{
				g_BotMimicTick[client] = 0;
				g_CurrentAdditionalTeleportIndex[client] = 0;
				if (GetClientTeam(client) >= CS_TEAM_T)
					RequestFrame(RespawnBot, GetClientSerial(client));
			}
	}
	return Plugin_Continue;
}

public Action CS_OnTerminateRound(float &delay, CSRoundEndReason &reason)
{
	if (reason == CSRoundEnd_GameStart)
		return Plugin_Handled;
	int timeleft;
	GetMapTimeLeft(timeleft);
	if (timeleft >= -1 && !GetConVarBool(g_hAllowRoundEndCvar))
		return Plugin_Handled;
	return Plugin_Continue;
}

public Action Event_OnRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	g_bRoundEnd = true;
	return Plugin_Continue;
}

public void OnPlayerThink(int entity)
{
	SetEntPropEnt(entity, Prop_Send, "m_bSpotted", 0);
}

// OnRoundRestart
public Action Event_OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	int iEnt;
	for (int i = 0; i < sizeof(EntityList); i++)
	{
		while ((iEnt = FindEntityByClassname(iEnt, EntityList[i])) != -1)
		{
			AcceptEntityInput(iEnt, "Disable");
			AcceptEntityInput(iEnt, "Kill");
		}
	}

	// PushFix by Mev, George, & Blacky
	// https://forums.alliedmods.net/showthread.php?t=267131
	iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "trigger_push")) != -1)
	{
		SDKHook(iEnt, SDKHook_Touch, OnTouchPushTrigger);
	}

	RefreshZones();

	g_bRoundEnd = false;
	return Plugin_Continue;
}

// PushFix by Mev, George, & Blacky
// https://forums.alliedmods.net/showthread.php?t=267131
public Action OnTouchPushTrigger(int entity, int other)
{
	if (IsValidClient(other) && GetConVarBool(g_hTriggerPushFixEnable) == true)
	{
		if (IsValidEntity(entity))
		{
			float m_vecPushDir[3];
			GetEntPropVector(entity, Prop_Data, "m_vecPushDir", m_vecPushDir);
			if (m_vecPushDir[2] == 0.0)
				return Plugin_Continue;
			else
				DoPush(entity, other, m_vecPushDir);
		}
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

// PlayerHurt 
public Action Event_OnPlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	if (!GetConVarBool(g_hCvarGodMode) && GetConVarInt(g_hAutohealing_Hp) > 0)
	{
		int client = GetClientOfUserId(event.GetInt("userid"));
		int remainingHeatlh = GetEventInt(event, "health");
		if (remainingHeatlh > 0)
		{
			if ((remainingHeatlh + GetConVarInt(g_hAutohealing_Hp)) > 100)
				SetEntData(client, FindSendPropInfo("CBasePlayer", "m_iHealth"), 100);
			else
				SetEntData(client, FindSendPropInfo("CBasePlayer", "m_iHealth"), remainingHeatlh + GetConVarInt(g_hAutohealing_Hp));
		}
	}
	return Plugin_Continue;
}

// PlayerDamage (if godmode 0)
public Action Hook_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (GetConVarBool(g_hCvarGodMode))
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

//thx to TnTSCS (player slap stops timer)
//https://forums.alliedmods.net/showthread.php?t=233966
public Action OnLogAction(Handle source, Identity ident, int client, int target, const char[] message)
{
	if ((1 > target > MaxClients))
		return Plugin_Continue;
	if (IsValidClient(target) && IsPlayerAlive(target) && g_bTimeractivated[target] && !IsFakeClient(target))
	{
		char logtag[PLATFORM_MAX_PATH];
		if (ident == Identity_Plugin)
			GetPluginFilename(source, logtag, sizeof(logtag));
		else
			Format(logtag, sizeof(logtag), "OTHER");

		if ((strcmp("playercommands.smx", logtag, false) == 0) || (strcmp("slap.smx", logtag, false) == 0))
			Client_Stop(target, 0);
	}
	return Plugin_Continue;
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{

	if (g_bRoundEnd || !IsValidClient(client))
		return Plugin_Continue;

	if (IsPlayerAlive(client))
	{
		g_bLastOnGround[client] = g_bOnGround[client];
		if (GetEntityFlags(client) & FL_ONGROUND)
			g_bOnGround[client] = true;
		else
			g_bOnGround[client] = false;

		float newVelocity[3];
		// Slope Boost Fix by Mev, & Blacky
		// https://forums.alliedmods.net/showthread.php?t=266888
		//if (GetConVarBool(g_hSlopeFixEnable) == true)
		if (GetConVarBool(g_hSlopeFixEnable) == true && !IsFakeClient(client))
		{			
			g_vLast[client][0] = g_vCurrent[client][0];
			g_vLast[client][1] = g_vCurrent[client][1];
			g_vLast[client][2] = g_vCurrent[client][2];
			g_vCurrent[client][0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
			g_vCurrent[client][1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
			g_vCurrent[client][2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");

			// Check if player landed on the ground
			if (g_bOnGround[client] == true && g_bLastOnGround[client] == false)
			{
				// Set up and do tracehull to find out if the player landed on a slope
				float vPos[3];
				GetEntPropVector(client, Prop_Data, "m_vecOrigin", vPos);

				float vMins[3];
				GetEntPropVector(client, Prop_Send, "m_vecMins", vMins);

				float vMaxs[3];
				GetEntPropVector(client, Prop_Send, "m_vecMaxs", vMaxs);

				float vEndPos[3];
				vEndPos[0] = vPos[0];
				vEndPos[1] = vPos[1];
				vEndPos[2] = vPos[2] - FindConVar("sv_maxvelocity").FloatValue;

				TR_TraceHullFilter(vPos, vEndPos, vMins, vMaxs, MASK_PLAYERSOLID_BRUSHONLY, TraceRayDontHitSelf, client);

				if (TR_DidHit())
				{
					// Gets the normal vector of the surface under the player
					float vPlane[3], vLast[3];
					TR_GetPlaneNormal(INVALID_HANDLE, vPlane);

					// Make sure it's not flat ground and not a surf ramp (1.0 = flat ground, < 0.7 = surf ramp)
					if (0.7 <= vPlane[2] < 1.0)
					{
						/*
						Copy the ClipVelocity function from sdk2013 
						(https://mxr.alliedmods.net/hl2sdk-sdk2013/source/game/shared/gamemovement.cpp#3145)
						With some minor changes to make it actually work
						*/
						vLast[0] = g_vLast[client][0];
						vLast[1] = g_vLast[client][1];
						vLast[2] = g_vLast[client][2];
						vLast[2] -= (FindConVar("sv_gravity").FloatValue * GetTickInterval() * 0.5);

						float fBackOff = GetVectorDotProduct(vLast, vPlane);

						float change, vVel[3];
						for (int i; i < 2; i++)
						{
							change = vPlane[i] * fBackOff;
							vVel[i] = vLast[i] - change;
						}

						float fAdjust = GetVectorDotProduct(vVel, vPlane);
						if (fAdjust < 0.0)
						{
							for (int i; i < 2; i++)
							{
								vVel[i] -= (vPlane[i] * fAdjust);
							}
						}

						vVel[2] = 0.0;
						vLast[2] = 0.0;

						// Make sure the player is going down a ramp by checking if they actually will gain speed from the boost
						if (GetVectorLength(vVel) > GetVectorLength(vLast))
						{
							// Teleport the player, also adds basevelocity
							if (GetEntityFlags(client) & FL_BASEVELOCITY)
							{
								float vBase[3];
								GetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", vBase);

								AddVectors(vVel, vBase, vVel);
							}
							g_bFixingRamp[client] = true;
							Array_Copy(vVel, newVelocity, 3);
							TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
						}
					}
				}
			}
		}

		if (newVelocity[0] == 0.0 && newVelocity[1] == 0.0 && newVelocity[2] == 0.0)
		{
			RecordReplay(client, buttons, subtype, seed, impulse, weapon, angles, vel);
			if (IsFakeClient(client))
				PlayReplay(client, buttons, subtype, seed, impulse, weapon, angles, vel);
		}
		else
		{
			RecordReplay(client, buttons, subtype, seed, impulse, weapon, angles, newVelocity);
			if (IsFakeClient(client))
				PlayReplay(client, buttons, subtype, seed, impulse, weapon, angles, newVelocity);
		}

		float speed, origin[3], ang[3];
		GetClientAbsOrigin(client, origin);
		GetClientEyeAngles(client, ang);

		speed = GetSpeed(client);

		checkTrailStatus(client, speed);

		//menu refreshing
		CheckRun(client);

		AutoBhopFunction(client, buttons);
		NoClipCheck(client);
		AttackProtection(client, buttons);

		// If in start zone, cap speed
		LimitSpeed(client);

		g_fLastSpeed[client] = speed;
		g_LastButton[client] = buttons;

		BeamBox_OnPlayerRunCmd(client);
	}

	return Plugin_Continue;
}

//dhooks
public MRESReturn DHooks_OnTeleport(int client, Handle hParams)
{

	if (!IsValidClient(client))
		return MRES_Ignored;

	if (g_bPushing[client])
	{
		g_bPushing[client] = false;
		return MRES_Ignored;
	}

	if (g_bFixingRamp[client])
	{
		g_bFixingRamp[client] = false;
		return MRES_Ignored;
	}

	// This one is currently mimicing something.
	if (g_hBotMimicsRecord[client] != null)
	{
		// We didn't allow that teleporting. STOP THAT.
		if (!g_bValidTeleportCall[client])
			return MRES_Supercede;
		g_bValidTeleportCall[client] = false;
		return MRES_Ignored;
	}

	// Don't care if he's not recording.
	if (g_hRecording[client] == null)
		return MRES_Ignored;

	bool bOriginNull = DHookIsNullParam(hParams, 1);
	bool bAnglesNull = DHookIsNullParam(hParams, 2);
	bool bVelocityNull = DHookIsNullParam(hParams, 3);

	float origin[3], angles[3], velocity[3];

	if (!bOriginNull)
		DHookGetParamVector(hParams, 1, origin);

	if (!bAnglesNull)
	{
		for (int i = 0; i < 3; i++)
			angles[i] = DHookGetParamObjectPtrVar(hParams, 2, i * 4, ObjectValueType_Float);
	}

	if (!bVelocityNull)
		DHookGetParamVector(hParams, 3, velocity);

	if (bOriginNull && bAnglesNull && bVelocityNull)
		return MRES_Ignored;

	int iAT[AT_SIZE];
	Array_Copy(origin, iAT[atOrigin], 3);
	Array_Copy(angles, iAT[atAngles], 3);
	Array_Copy(velocity, iAT[atVelocity], 3);

	// Remember, 
	if (!bOriginNull)
		iAT[atFlags] |= ADDITIONAL_FIELD_TELEPORTED_ORIGIN;
	if (!bAnglesNull)
		iAT[atFlags] |= ADDITIONAL_FIELD_TELEPORTED_ANGLES;
	if (!bVelocityNull)
		iAT[atFlags] |= ADDITIONAL_FIELD_TELEPORTED_VELOCITY;

	if (g_hRecordingAdditionalTeleport[client] != null)
		PushArrayArray(g_hRecordingAdditionalTeleport[client], iAT, AT_SIZE);

	return MRES_Ignored;
}

public void Hook_PostThinkPost(int entity)
{
	SetEntProp(entity, Prop_Send, "m_bInBuyZone", 0);
}
