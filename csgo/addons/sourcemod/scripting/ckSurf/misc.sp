void disableServerHibernate()
{
	Handle hServerHibernate = FindConVar("sv_hibernate_when_empty");
	g_iServerHibernationValue = GetConVarInt(hServerHibernate);
	if (g_iServerHibernationValue > 0)
	{
		PrintToServer("[%s] Disabling server hibernation.", g_szChatPrefix);
		SetConVarInt(hServerHibernate, 0, false, false);
	}
	CloseHandle(hServerHibernate);
	return;
}

void revertServerHibernateSettings()
{
	Handle hServerHibernate = FindConVar("sv_hibernate_when_empty");
	if (GetConVarInt(hServerHibernate) != g_iServerHibernationValue)
	{
		PrintToServer("[%s] Resetting Server Hibernation CVar", g_szChatPrefix, g_szChatPrefix);
		SetConVarInt(hServerHibernate, g_iServerHibernationValue, false, false);
	}
	CloseHandle(hServerHibernate);
	return;
}
void setBotQuota()
{
	// Get bot_quota value
	ConVar hBotQuota = FindConVar("bot_quota");

	// Initialize
	SetConVarInt(hBotQuota, 0, false, false);

	// Check how many bots are needed
	int count = 0;
	if (g_bMapReplay)
		count++;
	if (GetConVarBool(g_hInfoBot))
		count++;
	if (g_BonusBotCount > 0)
		count++;

	SetConVarInt(hBotQuota, count, false, false);

	CloseHandle(hBotQuota);

	return;
}

bool IsValidZonegroup(int zGrp)
{
	if (-1 < zGrp < g_mapZoneGroupCount)
		return true;
	return false;
}

/**
*	Checks if coordinates are inside a zone
* 	Return: zone id where location is in, or -1 if not inside a zone
**/
int IsInsideZone (float location[3], float extraSize = 0.0)
{
	float tmpLocation[3];
	Array_Copy(location, tmpLocation, 3);
	tmpLocation[2] += 5.0;
	int iChecker;

	for (int i = 0; i < g_mapZonesCount; i++)
	{
		iChecker = 0;
		for(int x = 0; x < 3; x++)
		{
			if((g_fZoneCorners[i][7][x] >= g_fZoneCorners[i][0][x] && (tmpLocation[x] <= (g_fZoneCorners[i][7][x] + extraSize) && tmpLocation[x] >= (g_fZoneCorners[i][0][x] - extraSize))) || 
			(g_fZoneCorners[i][0][x] >= g_fZoneCorners[i][7][x] && (tmpLocation[x] <= (g_fZoneCorners[i][0][x] + extraSize) && tmpLocation[x] >= (g_fZoneCorners[i][7][x] - extraSize))))
				iChecker++;
		}
		if(iChecker == 3)
			return i;
	}

	return -1;
}

public void loadAllClientSettings()
{
	debug_msg(" Started loadAllClientSettings ");
	for (int i = 1; i < MAXPLAYERS + 1; i++)
	{
		if (IsValidClient(i) && !IsFakeClient(i) && !g_bSettingsLoaded[i] && !g_bLoadingSettings[i])
		{
			char buffer[412];
			Format(buffer, 412, "Started Loading: %N on map: %s", i, g_szMapName);
			debug_msg(buffer);
			db_viewPersonalRecords(i, g_szSteamID[i], g_szMapName);
			g_bLoadingSettings[i] = true;
			
			break;
		}
	}
	debug_msg(" Ended loadAllClientSettings ");
	g_bServerDataLoaded = true;
}
public void getSteamIDFromClient(int client, char[] buffer, int length)
{
	// Get steamid - Points are being recalculated by an admin (pretty much going through top 20k players)
	if (client > MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(buffer, length, "%s", g_pr_szSteamID[client]);
	}
	else // Get steamid - Normal point increase
	{
		if (!GetConVarBool(g_hPointSystem) || !IsValidClient(client))
			return;
		GetClientAuthId(client, AuthId_Steam2, buffer, length, true);
	}
	return;
}

/*
Handles teleporting of players
Zonegroup: 0 = normal map, >0 bonuses.
Zone types: 1 = Start zone,  >1 Stage zones.
*/
public void teleportClient(int client, int zonegroup, int zone, bool stopTime)
{
	if (!IsValidClient(client))
		return;
	if (!IsValidZonegroup(zonegroup))
	{
		PrintToChat(client, "[%c%s%c] Zonegroup not found.", MOSSGREEN, g_szChatPrefix, WHITE);
		return;
	}

	if (g_bPracticeMode[client])
		Command_normalMode(client, 1);

	// Check for spawn locations
	if (zone == 1 && g_bGotSpawnLocation[zonegroup])
	{
		if (GetClientTeam(client) == 1 || GetClientTeam(client) == 0) // Spectating
		{
			if (stopTime)
				Client_Stop(client, 0);

			Array_Copy(g_fSpawnLocation[zonegroup], g_fTeleLocation[client], 3);

			g_specToStage[client] = true;
			g_bRespawnPosition[client] = false;

			TeamChangeActual(client, 0);
			return;
		}
		else
		{
			SetEntPropVector(client, Prop_Data, "m_vecVelocity", view_as<float>( { 0.0, 0.0, -100.0 } ));

			teleportEntitySafe(client, g_fSpawnLocation[zonegroup], g_fSpawnAngle[zonegroup], view_as<float>( { 0.0, 0.0, -100.0 } ), stopTime);

			return;
		}
	}
	else
	{
		// Check if the map has zones
		if (g_mapZonesCount > 0)
		{
			// Search for the zoneid we're teleporting to:
			int destinationZoneId = getZoneID(zonegroup, zone);

			// Check if zone was found
			if (destinationZoneId > -1)
			{
				// Check if client is spectating, or not chosen a team yet
				if (GetClientTeam(client) == 1 || GetClientTeam(client) == 0) 
				{

					if (stopTime)
						Client_Stop(client, 0);

					// Set spawn location to the destination zone:
					Array_Copy(g_mapZones[destinationZoneId][CenterPoint], g_fTeleLocation[client], 3);

					// Set specToStage flag
					g_bRespawnPosition[client] = false;
					g_specToStage[client] = true;

					// Spawn player
					TeamChangeActual(client, 0);
				}
				else // Teleport normally
				{
					// Set client speed to 0
					SetEntPropVector(client, Prop_Data, "m_vecVelocity", view_as<float>( { 0.0, 0.0, -100.0 } ));

					float fLocation[3];
					Array_Copy(g_mapZones[destinationZoneId][CenterPoint], fLocation, 3); 

					// Teleport
					teleportEntitySafe(client, fLocation, NULL_VECTOR, view_as<float>( { 0.0, 0.0, -100.0 } ), stopTime);
				}
			}
			else
				PrintToChat(client, "[%c%s%c] Destination zone not found!", MOSSGREEN, g_szChatPrefix, WHITE);
		}
		else
			PrintToChat(client, "[%c%s%c] No zones found in the map.", MOSSGREEN, g_szChatPrefix, WHITE);
	}
	return;
}

void teleportEntitySafe(int client, float fDestination[3], float fAngles[3], float fVelocity[3], bool stopTimer)
{
	if (stopTimer)
		Client_Stop(client, 1);

	int zId = setClientLocation(client, fDestination); // Set new location

	if (zId > -1 && g_bTimeractivated[client] && g_mapZones[zId][zoneType] == 2) // If teleporting to the end zone, stop timer
		Client_Stop(client, 0);

	// Teleport
	TeleportEntity(client, fDestination, fAngles, fVelocity);
}
void teleportEntitySafeBonus(int client, float fDestination[3], float fAngles[3], float fVelocity[3], bool stopTimer)
{
	if (stopTimer)
		Client_Stop(client, 1);

	int zId = setClientLocation(client, fDestination); // Set new location

	if (zId > -1 && g_bTimeractivated[client] && g_mapZones[zId][zoneType] == 2) // If teleporting to the end zone, stop timer
		Client_Stop(client, 0);
	if (zId > -1 && g_mapZones[zId][zoneType] == 3) {
		Client_Stop(client, 1);
		PrintToChat(client, "[%c%s%c] %cYour Bonus time has been stopped as your position has been restored at a stage start.", MOSSGREEN, g_szChatPrefix, WHITE, RED);
	}
	// Teleport
	TeleportEntity(client, fDestination, fAngles, fVelocity);
}
int setClientLocation(int client, float fDestination[3])
{
	int zId = IsInsideZone(fDestination);

	if (zId != g_iClientInZone[client][3]) // Ignore location changes, if teleporting to the same zone they are already in
	{
		if (g_iClientInZone[client][0] != -1) // Ignore end touch if teleporting from within a zone
			g_bIgnoreZone[client] = true;

		if (zId > -1)
		{
			g_iClientInZone[client][0] = g_mapZones[zId][zoneType];
			g_iClientInZone[client][1] = g_mapZones[zId][zoneTypeId];
			g_iClientInZone[client][2] = g_mapZones[zId][zoneGroup];
			g_iClientInZone[client][3] = zId;
		}
		else
		{
			g_iClientInZone[client][0] = -1;
			g_iClientInZone[client][1] = -1;
			g_iClientInZone[client][3] = -1;
		}
	}
	return zId;
}

stock void WriteChatLog(int client, const char[] sayOrSayTeam, const char[] msg)
{
	char name[MAX_NAME_LENGTH], steamid[32], teamName[10];

	GetClientName(client, name, MAX_NAME_LENGTH);
	GetTeamName(GetClientTeam(client), teamName, sizeof(teamName));
	GetClientAuthId(client, AuthId_Steam2, steamid, 32, true);
	LogToGame("\"%s<%i><%s><%s>\" %s \"%s\"", name, GetClientUserId(client), steamid, teamName, sayOrSayTeam, msg);
}

// PushFix by Mev, George, & Blacky
// https://forums.alliedmods.net/showthread.php?t=267131
public void SinCos(float radians, float &sine, float &cosine)
{
	sine = Sine(radians);
	cosine = Cosine(radians);
}

void DoPush(int entity, int other, float m_vecPushDir[3])
{
	if (0 < other <= MaxClients)
	{
		if (!DoesClientPassFilter(entity, other))
		{
			return;
		}

		float newVelocity[3], angRotation[3], fPushSpeed;

		fPushSpeed = GetEntPropFloat(entity, Prop_Data, "m_flSpeed");
		GetEntPropVector(entity, Prop_Data, "m_angRotation", angRotation);

		// Rotate vector according to world
		float sr, sp, sy, cr, cp, cy;
		float matrix[3][4];

		SinCos(DegToRad(angRotation[1]), sy, cy);
		SinCos(DegToRad(angRotation[0]), sp, cp);
		SinCos(DegToRad(angRotation[2]), sr, cr);

		matrix[0][0] = cp * cy;
		matrix[1][0] = cp * sy;
		matrix[2][0] = -sp;

		float crcy = cr * cy;
		float crsy = cr * sy;
		float srcy = sr * cy;
		float srsy = sr * sy;

		matrix[0][1] = sp * srcy - crsy;
		matrix[1][1] = sp * srsy + crcy;
		matrix[2][1] = sr * cp;

		matrix[0][2] = (sp * crcy + srsy);
		matrix[1][2] = (sp * crsy - srcy);
		matrix[2][2] = cr * cp;

		matrix[0][3] = angRotation[0];
		matrix[1][3] = angRotation[1];
		matrix[2][3] = angRotation[2];

		float vecAbsDir[3];
		vecAbsDir[0] = m_vecPushDir[0] * matrix[0][0] + m_vecPushDir[1] * matrix[0][1] + m_vecPushDir[2] * matrix[0][2];
		vecAbsDir[1] = m_vecPushDir[0] * matrix[1][0] + m_vecPushDir[1] * matrix[1][1] + m_vecPushDir[2] * matrix[1][2];
		vecAbsDir[2] = m_vecPushDir[0] * matrix[2][0] + m_vecPushDir[1] * matrix[2][1] + m_vecPushDir[2] * matrix[2][2];

		ScaleVector(vecAbsDir, fPushSpeed);

		// Apply the base velocity directly to abs velocity
		GetEntPropVector(other, Prop_Data, "m_vecVelocity", newVelocity);

		newVelocity[2] = newVelocity[2] + (vecAbsDir[2] * GetTickInterval());
		g_bPushing[other] = true;
		TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, newVelocity);

		// Remove the base velocity z height so abs velocity can do it and add old base velocity if there is any
		vecAbsDir[2] = 0.0;
		if (GetEntityFlags(other) & FL_BASEVELOCITY)
		{
			float vecBaseVel[3];
			GetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", vecBaseVel);
			AddVectors(vecAbsDir, vecBaseVel, vecAbsDir);
		}

		SetEntPropVector(other, Prop_Data, "m_vecBaseVelocity", vecAbsDir);
		SetEntityFlags(other, GetEntityFlags(other) | FL_BASEVELOCITY);
	}
}

void GetFilterTargetName(char[] filtername, char[] buffer, int maxlen)
{
	int filter = FindEntityByTargetname(filtername);
	if (filter != -1)
	{
		GetEntPropString(filter, Prop_Data, "m_iFilterName", buffer, maxlen);
	}
}

int FindEntityByTargetname(char[] targetname)
{
	int entity = -1;
	char sName[64];
	while ((entity = FindEntityByClassname(entity, "filter_activator_name")) != -1)
	{
		GetEntPropString(entity, Prop_Data, "m_iName", sName, 64);
		if (StrEqual(sName, targetname))
		{
			return entity;
		}
	}

	return -1;
}

bool DoesClientPassFilter(int entity, int client)
{
	char sPushFilter[64];
	GetEntPropString(entity, Prop_Data, "m_iFilterName", sPushFilter, sizeof sPushFilter);
	if (StrEqual(sPushFilter, ""))
	{
		return true;
	}
	char sFilterName[64];
	GetFilterTargetName(sPushFilter, sFilterName, sizeof sFilterName);
	char sClientName[64];
	GetEntPropString(client, Prop_Data, "m_iName", sClientName, sizeof sClientName);

	return StrEqual(sFilterName, sClientName, true);
}

//https://forums.alliedmods.net/showthread.php?t=206308
void TeamChangeActual(int client, int toteam)
{
	if (GetConVarBool(g_hForceCT)) {
		if (toteam == 0 || toteam == 2) {
			toteam = 3;
		}
	} else {
		if (toteam == 0) {  // client is auto-assigning
			toteam = GetRandomInt(2, 3);
		}
	}

	if (g_bSpectate[client])
	{
		if (g_fStartTime[client] != -1.0 && g_bTimeractivated[client] == true)
			g_fPauseTime[client] = GetGameTime() - g_fStartPauseTime[client];
		g_bSpectate[client] = false;
	}

//	if (!IsPlayerAlive(client) && toteam > 1)
//		CS_RespawnPlayer(client);

	ChangeClientTeam(client, toteam);

	return;
}

public int getZoneID(int zoneGrp, int stage)
{
	if (0 < stage < 2) // Search for map's starting zone
	{
		for (int i = 0; i < g_mapZonesCount; i++)
		{
			if (g_mapZones[i][zoneGroup] == zoneGrp && (g_mapZones[i][zoneType] == 1 || g_mapZones[i][zoneType] == 5) && g_mapZones[i][zoneTypeId] == 0)
				return i;
		}
		for (int i = 0; i < g_mapZonesCount; i++) // If no start zone with typeId 0 found, return any start zone
		{
			if (g_mapZones[i][zoneGroup] == zoneGrp && (g_mapZones[i][zoneType] == 1 || g_mapZones[i][zoneType] == 5))
				return i;
		}
	}
	else if (stage > 1) // Search for a stage
	{
		for (int i = 0; i < g_mapZonesCount; i++)
		{
			if (g_mapZones[i][zoneGroup] == zoneGrp && g_mapZones[i][zoneType] == 3 && g_mapZones[i][zoneTypeId] == (stage - 2))
			{
				return i;
			}
		}
	}
	else if (stage < 0) // Search for the end zone
	{
		for (int i = 0; i < g_mapZonesCount; i++)
		{
			if (g_mapZones[i][zoneType] == 2 && g_mapZones[i][zoneGroup] == zoneGrp)
			{
				return i;
			}
		}
	}
	return -1;
}

public void readMultiServerMapcycle()
{	
	char sPath[PLATFORM_MAX_PATH];
	char line[128];

	ClearArray(g_MapList);
	g_pr_MapCount = 0;
	BuildPath(Path_SM, sPath, sizeof(sPath), "%s", MULTI_SERVER_MAPCYCLE);
	Handle fileHandle = OpenFile(sPath, "r");

	if (fileHandle != null)
	{
		while (!IsEndOfFile(fileHandle) && ReadFileLine(fileHandle, line, sizeof(line)))
		{
			TrimString(line); // Only take the map name
			if (StrContains(line, "//", true) == -1) // Escape comments
			{
				g_pr_MapCount++;
				PushArrayString(g_MapList, line);
	 		}
		}
	}
	else
		SetFailState("[%s] %s is empty or does not exist.", g_szChatPrefix, MULTI_SERVER_MAPCYCLE);

	if (fileHandle != null)
		CloseHandle(fileHandle);

	return;
}

public void readMapycycle()
{
	char map[128];
	char map2[128];
	int mapListSerial = -1;
	g_pr_MapCount = 0;
	if (ReadMapList(g_MapList, 
			mapListSerial, 
			"mapcyclefile", 
			MAPLIST_FLAG_CLEARARRAY | MAPLIST_FLAG_NO_DEFAULT)
		 == null)
	{
		if (mapListSerial == -1)
		{
			SetFailState("[%s] mapcycle.txt is empty or does not exist.", g_szChatPrefix);
		}
	}
	for (int i = 0; i < GetArraySize(g_MapList); i++)
	{
		GetArrayString(g_MapList, i, map, sizeof(map));
		if (!StrEqual(map, "", false))
		{
			//fix workshop map name			
			char mapPieces[6][128];
			int lastPiece = ExplodeString(map, "/", mapPieces, sizeof(mapPieces), sizeof(mapPieces[]));
			Format(map2, sizeof(map2), "%s", mapPieces[lastPiece - 1]);
			SetArrayString(g_MapList, i, map2);
			g_pr_MapCount++;
		}
	}
	return;
}

public bool loadHiddenChatCommands()
{
	char sPath[PLATFORM_MAX_PATH];
	char line[64];

	//add blocked chat commands list
	for (int x = 0; x < 256; x++)
		Format(g_BlockedChatText[x], sizeof(g_BlockedChatText), "");

	BuildPath(Path_SM, sPath, sizeof(sPath), "%s", BLOCKED_LIST_PATH);
	int count = 0;
	Handle fileHandle = OpenFile(sPath, "r");
	if (fileHandle != null)
	{
		while (!IsEndOfFile(fileHandle) && ReadFileLine(fileHandle, line, sizeof(line)))
		{
			TrimString(line);
			if ((StrContains(line, "//", true) == -1) && count < 256)
			{
				Format(g_BlockedChatText[count], sizeof(g_BlockedChatText), "%s", line);
				count++;
			}
		}
	}
	else
		LogError("[%s] %s is empty or does not exist.", g_szChatPrefix, BLOCKED_LIST_PATH);

	if (fileHandle != null)
		CloseHandle(fileHandle);

	return true;
}

public bool loadCustomTitles()
{
	char sPath[PLATFORM_MAX_PATH];
	g_iCustomTitleCount = 0;
	// Load custom titles:
	for (int i = 0; i < TITLE_COUNT; i++)
	{
		Format(g_szflagTitle[i], 128, "");
		Format(g_szflagTitle_Colored[i], 128, "");
	}

	BuildPath(Path_SM, sPath, sizeof(sPath), "%s", CUSTOM_TITLE_PATH);

	Handle kv = CreateKeyValues("Custom Titles");
	FileToKeyValues(kv, sPath);

	if (!KvGotoFirstSubKey(kv))
	{
		return false;
	}

	for (int i = 0; i < TITLE_COUNT; i++)
	{
		KvGetString(kv, "title_name", g_szflagTitle_Colored[i], 128);
		KvGetString(kv, "title_name", g_szflagTitle[i], 128);
		if (!g_szflagTitle[i][0])
		{
			// Disable unused titles from all players
			if (i != (TITLE_COUNT - 1))
				sql_disableTitleFromAllbyIndex(i);
			break;
		}
		else
			g_iCustomTitleCount++;

		//addColorToString(g_szflagTitle_Colored[i], 32);
		normalizeChatString(g_szflagTitle[i], 32);

		if (!KvGotoNextKey(kv))
			break;
	}
	CloseHandle(kv);
	return true;
}


public bool loadCustomSounds()
{

	char sPath[PLATFORM_MAX_PATH];
	
	BuildPath(Path_SM, sPath, sizeof(sPath), "%s", CUSTOM_SOUND);

	Handle kv = CreateKeyValues("Custom Sounds");
	FileToKeyValues(kv, sPath);
	
	if (!KvGotoFirstSubKey(kv))
	{
		
		return false;
	}

	for (int i = 0; i < SOUND_COUNT; i++)
	{
		
		KvGetString(kv, "sound_path", g_szSoundPath[i], 128);
		KvGetString(kv, "sound_name", g_szSoundName[i], 128);
		g_iSoundCost[i] = KvGetNum(kv, "sound_cost");
		g_iSoundType[i] = KvGetNum(kv, "sound_type");
		g_iSoundPerm[i] = KvGetNum(kv, "sound_perm");
		
		
		if (!KvGotoNextKey(kv))
			break;
	}
	CloseHandle(kv);
	return true;
}

public void normalizeChatString(char[] ParseString, int size)
{
	CRemoveColors(ParseString, size);
}

public void checkChangesInTitle(int client)
{
	if (!IsValidClient(client))
		return;

	for (int i = 0; i < TITLE_COUNT; i++)
	{
		if (g_bflagTitles[client][i] != g_bflagTitles_orig[client][i])
		{
			if (g_bflagTitles[client][i])
				ClientCommand(client, "play commander\\commander_comment_0%i", GetRandomInt(1, 9));
			else
				ClientCommand(client, "play commander\\commander_comment_%i", GetRandomInt(20, 23));

			switch (i)
			{
				case 0:
				{
					g_bflagTitles_orig[client][i] = g_bflagTitles[client][i];
					if (g_bflagTitles[client][i])
						PrintToChat(client, "[%c%s%c] Congratulations! You have gained the VIP privileges!", MOSSGREEN, g_szChatPrefix, WHITE);
					else
						PrintToChat(client, "[%c%s%c] You have lost your VIP privileges!", MOSSGREEN, g_szChatPrefix, WHITE);
					break;
				}
				case 1:
				{
					g_bflagTitles_orig[client][i] = g_bflagTitles[client][i];
					if (g_bflagTitles[client][i])
						PrintToChat(client, "[%c%s%c] Congratulations! You have gained the Mapper title!", MOSSGREEN, g_szChatPrefix, WHITE);
					else
						PrintToChat(client, "[%c%s%c] You have lost your Mapper title!", MOSSGREEN, g_szChatPrefix, WHITE);
					break;
				}
				case 2:
				{
					g_bflagTitles_orig[client][i] = g_bflagTitles[client][i];
					if (g_bflagTitles[client][i])
						PrintToChat(client, "[%c%s%c] Congratulations! You have gained the Teacher title!", MOSSGREEN, g_szChatPrefix, WHITE);
					else
						PrintToChat(client, "[%c%s%c] You have lost your Teacher title!", MOSSGREEN, g_szChatPrefix, WHITE);
					break;
				}
				default:
				{
					g_bflagTitles_orig[client][i] = g_bflagTitles[client][i];
					if (g_bflagTitles[client][i])
						PrintToChat(client, "[%c%s%c] Congratulations! You have gained the custom title \"%s\"!", MOSSGREEN, g_szChatPrefix, WHITE, g_szflagTitle_Colored[i]);
					else
						PrintToChat(client, "[%c%s%c] You have lost your custom title \"%s\"!", MOSSGREEN, g_szChatPrefix, WHITE, g_szflagTitle_Colored[i]);
					break;
				}
			}
		}
	}
}

public void checkSpawnPoints()
{
	int tEnt, ctEnt;
	float f_spawnLocation[3], f_spawnAngle[3];

	if (FindEntityByClassname(ctEnt, "info_player_counterterrorist") == -1 || FindEntityByClassname(tEnt, "info_player_terrorist") == -1) // No proper zones were found, try to recreate
	{
		// Check if spawn point has been added to the database with !addspawn
		char szQuery[256];
		Format(szQuery, 256, "SELECT pos_x, pos_y, pos_z, ang_x, ang_y, ang_z FROM ck_spawnlocations WHERE mapname = '%s' AND zonegroup = 0;", g_szMapName);
		Handle query = SQL_Query(g_hDb, szQuery);
		if (query == INVALID_HANDLE)
		{
			char szError[255];
			SQL_GetError(g_hDb, szError, sizeof(szError));
			PrintToServer("Failed to query map's spawn points (error: %s)", szError);
		}
		else
		{
			if (SQL_HasResultSet(query) && SQL_FetchRow(query))
			{
				f_spawnLocation[0] = SQL_FetchFloat(query, 0);
				f_spawnLocation[1] = SQL_FetchFloat(query, 1);
				f_spawnLocation[2] = SQL_FetchFloat(query, 2);
				f_spawnAngle[0] = SQL_FetchFloat(query, 3);
				f_spawnAngle[1] = SQL_FetchFloat(query, 4);
				f_spawnAngle[2] = SQL_FetchFloat(query, 5);
			}
			CloseHandle(query);
		}

		if (f_spawnLocation[0] == 0.0 && f_spawnLocation[1] == 0.0 && f_spawnLocation[2] == 0.0) // No spawnpoint added to map with !addspawn, try to find spawns from map
		{
			PrintToServer("[%s] No valid spawns found in the map.", g_szChatPrefix);
			int zoneEnt = -1;
			zoneEnt = FindEntityByClassname(zoneEnt, "info_player_teamspawn"); // CSS/TF spawn found

			if (zoneEnt != -1)
			{
				GetEntPropVector(zoneEnt, Prop_Data, "m_angRotation", f_spawnAngle);
				GetEntPropVector(zoneEnt, Prop_Send, "m_vecOrigin", f_spawnLocation);

				PrintToServer("[%s] Found info_player_teamspawn in location %f, %f, %f", g_szChatPrefix, f_spawnLocation[0], f_spawnLocation[1], f_spawnLocation[2]);
			}
			else
			{
				zoneEnt = FindEntityByClassname(zoneEnt, "info_player_start"); // Random spawn
				if (zoneEnt != -1)
				{
					GetEntPropVector(zoneEnt, Prop_Data, "m_angRotation", f_spawnAngle);
					GetEntPropVector(zoneEnt, Prop_Send, "m_vecOrigin", f_spawnLocation);

					PrintToServer("[%s] Found info_player_start in location %f, %f, %f", g_szChatPrefix, f_spawnLocation[0], f_spawnLocation[1], f_spawnLocation[2]);
				}
				else
				{
					PrintToServer("No valid spawn points found in the map! Record bots will not work. Try adding a spawn point with !addspawn");
					return;
				}
			}
		}

		// Start creating new spawnpoints
		int pointT, pointCT, count = 0;
		while (count < 64)
		{
			pointT = CreateEntityByName("info_player_terrorist");
			ActivateEntity(pointT);
			pointCT = CreateEntityByName("info_player_counterterrorist");
			ActivateEntity(pointCT);
			if (IsValidEntity(pointT) && IsValidEntity(pointCT) && DispatchSpawn(pointT) && DispatchSpawn(pointCT))
			{
				TeleportEntity(pointT, f_spawnLocation, f_spawnAngle, NULL_VECTOR);
				TeleportEntity(pointCT, f_spawnLocation, f_spawnAngle, NULL_VECTOR);
				count++;
			}
		}

		// Remove possiblt bad spawns
		char sClassName[128];
		for (int i = 0; i < GetMaxEntities(); i++)
		{
			if (IsValidEdict(i) && IsValidEntity(i) && GetEdictClassname(i, sClassName, sizeof(sClassName)))
			{
				if (StrEqual(sClassName, "info_player_start") || StrEqual(sClassName, "info_player_teamspawn"))
				{
					RemoveEdict(i);
				}
			}
		}
	}
	else // Valid spawns were found, check that there is enough of them
	{
		int ent, spawnpoint;
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "info_player_terrorist")) != -1)
		{
			if (tEnt == 0)
			{
				GetEntPropVector(ent, Prop_Data, "m_angRotation", f_spawnAngle);
				GetEntPropVector(ent, Prop_Send, "m_vecOrigin", f_spawnLocation);
			}
			tEnt++;
		}
		while ((ent = FindEntityByClassname(ent, "info_player_counterterrorist")) != -1)
		{
			if (ctEnt == 0 && tEnt == 0)
			{
				GetEntPropVector(ent, Prop_Data, "m_angRotation", f_spawnAngle);
				GetEntPropVector(ent, Prop_Send, "m_vecOrigin", f_spawnLocation);
			}
			ctEnt++;
		}

		if (tEnt > 0 || ctEnt > 0)
		{
			if (tEnt < 64)
			{
				while (tEnt < 64)
				{
					spawnpoint = CreateEntityByName("info_player_terrorist");
					if (IsValidEntity(spawnpoint) && DispatchSpawn(spawnpoint))
					{
						ActivateEntity(spawnpoint);
						TeleportEntity(spawnpoint, f_spawnLocation, f_spawnAngle, NULL_VECTOR);
						tEnt++;
					}
				}
			}

			if (ctEnt < 64)
			{
				while (ctEnt < 64)
				{
					spawnpoint = CreateEntityByName("info_player_counterterrorist");
					if (IsValidEntity(spawnpoint) && DispatchSpawn(spawnpoint))
					{
						ActivateEntity(spawnpoint);
						TeleportEntity(spawnpoint, f_spawnLocation, f_spawnAngle, NULL_VECTOR);
						ctEnt++;
					}
				}
			}
		}
	}
}

public Action CallAdmin_OnDrawOwnReason(int client)
{
	g_bClientOwnReason[client] = true;
	return Plugin_Continue;
}

public bool checkSpam(int client)
{
	float time = GetGameTime();
	if (GetConVarFloat(g_hChatSpamFilter) == 0.0)
		return false;

	if (!IsValidClient(client) || (GetUserFlagBits(client) & ADMFLAG_ROOT) || (GetUserFlagBits(client) & ADMFLAG_GENERIC))
		return false;

	bool result = false;

	if (time - g_fLastChatMessage[client] < GetConVarFloat(g_hChatSpamFilter))
	{
		result = true;
		g_messages[client]++;
	}
	else
		g_messages[client] = 0;

	if (4 < g_messages[client] < 8)
		PrintToChat(client, "[%c%s%c] %cStop spamming or you will get kicked!", MOSSGREEN, g_szChatPrefix, WHITE, RED);
	else
		if (g_messages[client] >= 8)
	{
		KickClient(client, "Kicked for spamming.");
		return true;
	}

	g_fLastChatMessage[client] = time;
	return result;
}

stock bool IsValidClient(int client)
{
	if (client >= 1 && client <= MaxClients && IsValidEntity(client) && IsClientConnected(client) && IsClientInGame(client))
		return true;
	return false;
}

public void PrintConsoleInfo(int client)
{

	if (g_hSkillGroups == null)
	{
		CreateTimer(5.0, reloadConsoleInfo, GetClientSerial(client));
		return;
	}

	int iConsoleTimeleft;
	GetMapTimeLeft(iConsoleTimeleft);
	int mins, secs;
	char finalOutput[1024];
	mins = iConsoleTimeleft / 60;
	secs = iConsoleTimeleft % 60;
	Format(finalOutput, 1024, "%d:%02d", mins, secs);
	float fltickrate = 1.0 / GetTickInterval();

	if (!IsValidClient(client) || IsFakeClient(client))
		return;

	PrintToConsole(client, "-----------------------------------------------------------------------------------------------------------");
	PrintToConsole(client, "This server is running ckSurf v%s - Author: Elzi - Server tickrate: %i", PLUGIN_VERSION, RoundToNearest(fltickrate));
	PrintToConsole(client, "This version of ckSurf has been modfied by: jonitaikaponi, nikooo777, connorjan, blackhawk74, ");
	PrintToConsole(client, "zAfLu, Squallkins, marcowmadeira, 2called-chaos, 1DJ, Maxximou5, peace-maker.");
	if (iConsoleTimeleft > 0)
		PrintToConsole(client, "iConsoleTimeleft on %s: %s", g_szMapName, finalOutput);
	PrintToConsole(client, "Menu formatting is optimized for 1920x1080!");
	PrintToConsole(client, " ");
	PrintToConsole(client, "Client Commands:");
	PrintToConsole(client, "!r, !stages, !s, !bonus, !b, !teleport, !stuck, !tele");
	PrintToConsole(client, "!help, !help2, !menu, !options, !profile, !compare,");
	PrintToConsole(client, "!maptop, !top, !start, !stop, !pause, !challenge, !surrender, !goto, !spec, !avg,");
	PrintToConsole(client, "!showsettings, !latest, !measure, !ranks, !flashlight, !language, !usp, !wr");
	PrintToConsole(client, " ");
	PrintToConsole(client, "Options Menu Contains:");
	PrintToConsole(client, "!hide, !hidespecs, !hidechat, !hideweapon");
	PrintToConsole(client, "!info, !bhop, !disablegoto");
	PrintToConsole(client, " ");
	PrintToConsole(client, "Practice Mode:");
	PrintToConsole(client, "Create checkpoints with !cp / !checkpoint");
	PrintToConsole(client, "Start practice mode with !tele / !prac");
	PrintToConsole(client, "Undo failed checkpoints with !undo");
	PrintToConsole(client, "Get back to normal mode with !n / !normal");
	PrintToConsole(client, "");
	PrintToConsole(client, "Live scoreboard:");
	PrintToConsole(client, "Kills: Time in seconds");
	PrintToConsole(client, "Assists: Number of % finished on current map");
	PrintToConsole(client, "Score: How many players are lower ranked than the player. Higher number means higher rank");
	PrintToConsole(client, "MVP Stars: Number of finished map runs on the current map");
	PrintToConsole(client, " ");
	PrintToConsole(client, "Practice Mode:");
	PrintToConsole(client, "Create checkpoints with !cp / !checkpoint");
	PrintToConsole(client, "Start practice mode with !tele / !prac");
	PrintToConsole(client, "Undo failed checkpoints with !undo");
	PrintToConsole(client, "Get back to normal mode with !n / !normal");
	PrintToConsole(client, "");
	PrintToConsole(client, "Skill groups:");
	char ChatLine[512];
	int i, RankValue[SkillGroup];
	for (i = 0; i < GetArraySize(g_hSkillGroups); i++)
	{
		GetArrayArray(g_hSkillGroups, i, RankValue[0]);

		if (i != 0 && i % 5 == 0)
		{
			PrintToConsole(client, ChatLine);
			Format(ChatLine, 512, "");	
		}

		Format(ChatLine, 512, "%s%s (%ip)   ", ChatLine, RankValue[RankName], RankValue[PointReq]);
	}
	PrintToConsole(client, ChatLine);
	PrintToConsole(client, "");
	PrintToConsole(client, "-----------------------------------------------------------------------------------------------------------");
	PrintToConsole(client, " ");
	return;
}

stock void FakePrecacheSound(const char[] szPath)
{
    char szPathStar[PLATFORM_MAX_PATH];
    Format(szPathStar, sizeof(szPathStar), "*%s", szPath); 
    AddToStringTable(FindStringTable("soundprecache"), szPathStar);
}

stock void AddSoundToDownloadsTable(const char[] szPath)
{
    char szPathStar[PLATFORM_MAX_PATH];
    Format(szPathStar, sizeof(szPathStar), "sound/%s", szPath);
    AddFileToDownloadsTable(szPathStar);
}

public Action BlockRadio(int client, const char[] command, int args)
{
	if (!GetConVarBool(g_hRadioCommands) && IsValidClient(client))
	{
		PrintToChat(client, "%t", "RadioCommandsDisabled", LIMEGREEN, g_szChatPrefix, WHITE);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public void StringToUpper(char[] input)
{
	for (int i = 0; ; i++)
	{
		if (input[i] == '\0')
			return;
		input[i] = CharToUpper(input[i]);
	}
}

public void GetCountry(int client)
{
	if (client != 0)
	{
		if (!IsFakeClient(client))
		{
			char IP[16];
			char code2[3];
			GetClientIP(client, IP, 16);

			//COUNTRY
			GeoipCountry(IP, g_szCountry[client], 100);
			if (!strcmp(g_szCountry[client], NULL_STRING))
				Format(g_szCountry[client], 100, "Unknown", g_szCountry[client]);
			else
				if (StrContains(g_szCountry[client], "United", false) != -1 || 
				StrContains(g_szCountry[client], "Republic", false) != -1 || 
				StrContains(g_szCountry[client], "Federation", false) != -1 || 
				StrContains(g_szCountry[client], "Island", false) != -1 || 
				StrContains(g_szCountry[client], "Netherlands", false) != -1 || 
				StrContains(g_szCountry[client], "Isle", false) != -1 || 
				StrContains(g_szCountry[client], "Bahamas", false) != -1 || 
				StrContains(g_szCountry[client], "Maldives", false) != -1 || 
				StrContains(g_szCountry[client], "Philippines", false) != -1 || 
				StrContains(g_szCountry[client], "Vatican", false) != -1)
			{
				Format(g_szCountry[client], 100, "The %s", g_szCountry[client]);
			}
			//CODE
			if (GeoipCode2(IP, code2))
			{
				Format(g_szCountryCode[client], 16, "%s", code2);
			}
			else
				Format(g_szCountryCode[client], 16, "??");
		}
	}
}

stock void StripAllWeapons(int client)
{
	int iEnt;
	for (int i = 0; i <= 5; i++)
	{
		if (i != 2)
			while ((iEnt = GetPlayerWeaponSlot(client, i)) != -1)
		{
			RemovePlayerItem(client, iEnt);
			RemoveEdict(iEnt);
		}
	}
	if (GetPlayerWeaponSlot(client, 2) == -1)
		GivePlayerItem(client, "weapon_knife");
}

public void MovementCheck(int client)
{
	MoveType mt;
	mt = GetEntityMoveType(client);
	if (mt == MOVETYPE_FLYGRAVITY)
	{
		Client_Stop(client, 1);
	}
}

public void PlayButtonSound(int client)
{
	if (!GetConVarBool(g_hSoundEnabled))
		return;

	// Players button sound
	if (!IsFakeClient(client))
	{
		char buffer[255];
		GetConVarString(g_hSoundPath, buffer, 255);
		Format(buffer, sizeof(buffer), "play %s", buffer);
		ClientCommand(client, buffer);
	}

	// Spectators button sound
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && !IsPlayerAlive(i))
		{
			int SpecMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
			if (SpecMode == 4 || SpecMode == 5)
			{
				int Target = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
				if (Target == client)
				{
					char szsound[255];
					GetConVarString(g_hSoundPath, szsound, 256);
					Format(szsound, sizeof(szsound), "play %s", szsound);
					ClientCommand(i, szsound);
				}
			}
		}
	}
}

public void FixPlayerName(int client)
{
	char szName[64];
	char szOldName[64];
	GetClientName(client, szName, 64);
	Format(szOldName, 64, "%s ", szName);
	ReplaceChar("'", "`", szName);
	if (!(StrEqual(szOldName, szName)))
	{
		SetClientInfo(client, "name", szName);
		SetEntPropString(client, Prop_Data, "m_szNetname", szName);
		SetClientName(client, szName);
	}
}

public void LimitSpeed(int client)
{
	// Dont limits speed if in practice mode, or if there is no end zone in current zonegroup
	if (!IsValidClient(client) || !IsPlayerAlive(client) || IsFakeClient(client) || g_bPracticeMode[client] || g_mapZonesTypeCount[g_iClientInZone[client][2]][2] == 0)
		return;

	float speedCap = 0.0, CurVelVec[3];

	if (g_iClientInZone[client][0] == 1 && g_iClientInZone[client][2] > 0)
		speedCap = GetConVarFloat(g_hBonusPreSpeed);
	else
		if (g_iClientInZone[client][0] == 1)
			speedCap = GetConVarFloat(g_hStartPreSpeed);
		else
			if (g_iClientInZone[client][0] == 5)
			{
				if (!g_bNoClipUsed[client])
					speedCap = GetConVarFloat(g_hSpeedPreSpeed);
				else
					speedCap = GetConVarFloat(g_hStartPreSpeed); // If noclipping, top speed at normal start zone speed
			}

	if (speedCap == 0.0)
		return;

	GetEntPropVector(client, Prop_Data, "m_vecVelocity", CurVelVec);

	if (CurVelVec[0] == 0.0)
		CurVelVec[0] = 1.0;
	if (CurVelVec[1] == 0.0)
		CurVelVec[1] = 1.0;
	if (CurVelVec[2] == 0.0)
		CurVelVec[2] = 1.0;

	float currentspeed = SquareRoot(Pow(CurVelVec[0], 2.0) + Pow(CurVelVec[1], 2.0) + Pow(CurVelVec[2], 2.0));

	if (currentspeed > speedCap)
	{
		NormalizeVector(CurVelVec, CurVelVec);
		ScaleVector(CurVelVec, speedCap);
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, CurVelVec);
	}
}

public void changeTrailColor(int client)
{
	if (!IsValidClient(client))
		return;

	if (g_iTrailColor[client] < (sizeof(RGB_COLOR_NAMES) - 1))
		g_iTrailColor[client]++;
	else
		g_iTrailColor[client] = 0;
	return;
}

public void refreshTrailClient(int client)
{
	if (!IsValidClient(client) || !g_bTrailOn[client])
		return;

	int ent = GetPlayerWeaponSlot(client, 2);

	if (!IsValidEntity(ent))
		ent = client;

	g_bTrailApplied[client] = true;

	if (!IsFakeClient(client))
	{
		for (int i = 1; i < MAXPLAYERS + 1; i++)
		{
			if (i == client)
			{
				int ownTrailColor[4];
				Array_Copy(RGB_COLORS[g_iTrailColor[client]], ownTrailColor, 4);
				ownTrailColor[3] = 50;
				TE_SetupBeamFollow(ent, 
					g_BeamSprite, 
					0, 
					BEAMLIFE, 
					4.0, 
					1.0, 
					1, 
					ownTrailColor);
				TE_SendToClient(i);
			}
			else
			{
				if (IsValidClient(i) && !g_bHide[i])
				{
					TE_SetupBeamFollow(ent, 
						g_BeamSprite, 
						0, 
						BEAMLIFE, 
						4.0, 
						1.0, 
						1, 
						RGB_COLORS[g_iTrailColor[client]]);
					TE_SendToClient(i);
				}
			}
		}
	}
}

void refreshTrailBot(int bot)
{

	if (!IsValidClient(bot))
		return;

	int ent = GetPlayerWeaponSlot(bot, 2);
	if (!IsValidEntity(ent))
		ent = bot;

	if ((GetConVarBool(g_hBonusBotTrail) && GetConVarBool(g_hBonusBot)) && bot == g_BonusBot)
	{
		for (int i = 1; i < MAXPLAYERS+1; i++)
		{
			if (IsValidClient(i) && ((g_iClientInZone[i][2] == g_iClientInZone[bot][2] && g_Stage[g_iClientInZone[i][2]][i] == g_Stage[g_iClientInZone[bot][2]][bot]) || g_bSpectate[i]))
			{
				TE_SetupBeamFollow(ent, 
					g_BeamSprite, 
					0, 
					BEAMLIFE, 
					4.0, 
					1.0, 
					1, 
					g_BonusBotTrailColor);
   				TE_SendToClient(i);
			}
		}
	}
	else if ((GetConVarBool(g_hRecordBotTrail) && GetConVarBool(g_hReplayBot)) && bot == g_RecordBot)
	{
		for (int i = 1; i < MAXPLAYERS+1; i++)
		{
			if (IsValidClient(i) && ((g_iClientInZone[i][2] == g_iClientInZone[bot][2] && g_Stage[g_iClientInZone[i][2]][i] == g_Stage[g_iClientInZone[bot][2]][bot]) || g_bSpectate[i]))
			{
				TE_SetupBeamFollow(ent, 
					g_BeamSprite, 
					0, 
					BEAMLIFE, 
					4.0, 
					1.0, 
					1, 
					g_ReplayBotTrailColor);
   				TE_SendToClient(i);
			}
		}
	}
}

public void toggleTrail(int client)
{
	if (!IsValidClient(client))
		return;

	if (!g_bTrailOn[client])
	{
		PrintToChat(client, "[%c%s%c] Player trail %cenabled", MOSSGREEN, g_szChatPrefix, WHITE, MOSSGREEN);
		g_bTrailOn[client] = true;

		if (!g_bTrailApplied[client])
			refreshTrailClient(client);
	}
	else
	{
		PrintToChat(client, "[%c%s%c] Player trail %cdisabled", MOSSGREEN, g_szChatPrefix, WHITE, RED);
		g_bTrailOn[client] = false;
	}
}

public bool Base_TraceFilter(int entity, int contentsMask, any data)
{
	if (entity != data)
		return (false);

	return (true);
}

public void checkTrailStatus(int client, float speed)
{
	if (!IsFakeClient(client))
	{
		if (speed < 5.0 && g_bOnGround[client]) // Not moving
		{
			g_bNoClipUsed[client] = false;
			if (!g_bClientStopped[client]) // Get start time
			{
				g_fClientLastMovement[client] = GetGameTime();
				g_bClientStopped[client] = true;
			}
			else if (GetGameTime() - g_fClientLastMovement[client] >= BEAMLIFE) // Trail has died, refresh
			{
				g_bTrailApplied[client] = false;
				g_fClientLastMovement[client] = GetGameTime();
				refreshTrailClient(client);
			}
		}
		else
		{
			if (!IsFakeClient(client))
				g_bClientStopped[client] = false;
		}
	}
}

public void SetClientDefaults(int client)
{
	float GameTime = GetGameTime();
	g_fLastCommandBack[client] = GameTime;
	g_ClientSelectedZone[client] = -1;
	g_Editing[client] = 0;
	//g_testb = 0;
	g_bClientRestarting[client] = false;
	g_fClientRestarting[client] = GameTime;
	g_fErrorMessage[client] = GameTime;
	g_bPushing[client] = false;

	g_bLoadingSettings[client] = false;
	g_bSettingsLoaded[client] = false;	

	g_bClientStopped[client] = false;
	g_bTrailApplied[client] = false;
	g_fClientLastMovement[client] = GameTime;
	g_fLastDifferenceTime[client] = 0.0;
	g_bTrailOn[client] = false;

	g_bHasTitle[client] = false;
	g_iTitleInUse[client] = -1;

	g_flastClientUsp[client] = GameTime;

	g_ClientRenamingZone[client] = false;

	g_bNewReplay[client] = false;
	g_bNewBonus[client] = false;

	g_bFirstTimerStart[client] = true;
	g_pr_Calculating[client] = false;

	g_bTimeractivated[client] = false;
	g_specToStage[client] = false;
	g_bSpectate[client] = false;
	if (!g_bLateLoaded)
		g_bFirstTeamJoin[client] = true;
	g_bFirstSpawn[client] = true;
	g_bRecalcRankInProgess[client] = false;
	g_bPause[client] = false;
	g_bPositionRestored[client] = false;
	g_bRestorePositionMsg[client] = false;
	g_bRestorePosition[client] = false;
	g_bRespawnPosition[client] = false;
	g_bNoClip[client] = false;
	g_bChallenge[client] = false;
	g_bOverlay[client] = false;
	g_bChallenge_Request[client] = false;
	g_bClientOwnReason[client] = false;
	g_AdminMenuLastPage[client] = 0;
	g_OptionsMenuLastPage[client] = 0;
	g_MenuLevel[client] = -1;
	g_AttackCounter[client] = 0;
	g_SpecTarget[client] = -1;
	g_pr_points[client] = 0;
	g_fCurrentRunTime[client] = -1.0;
	g_fPlayerCordsLastPosition[client] = view_as<float>( { 0.0, 0.0, 0.0 } );
	g_fLastChatMessage[client] = GetGameTime();
	g_fLastTimeNoClipUsed[client] = -1.0;
	g_bNoclipWithoutR[client] = false;
	g_fStartTime[client] = -1.0;
	g_fPlayerLastTime[client] = -1.0;
	g_fLastTimePracUsed[client] = -1.0;
	g_fPauseTime[client] = 0.0;
	g_MapRank[client] = 99999;
	g_OldMapRank[client] = 99999;
	g_PlayerRank[client] = 99999;
	g_fProfileMenuLastQuery[client] = GameTime;
	Format(g_szPlayerPanelText[client], 512, "");
	Format(g_pr_rankname[client], 128, "");
	g_PlayerChatRank[client] = -1;
	g_bValidRun[client] = false;
	g_fMaxPercCompleted[client] = 0.0;
	Format(g_szLastSRDifference[client], 64, "");
	Format(g_szLastPBDifference[client], 64, "");

	Format(g_szPersonalRecord[client], 64, "");

	// Player Checkpoints
	for (int x = 0; x < 3; x++)
	{
		g_fCheckpointLocation[client][x] = 0.0;
		g_fCheckpointVelocity[client][x] = 0.0;
		g_fCheckpointAngle[client][x] = 0.0;

		g_fCheckpointLocation_undo[client][x] = 0.0;
		g_fCheckpointVelocity_undo[client][x] = 0.0;
		g_fCheckpointAngle_undo[client][x] = 0.0;
	}

	for (int x = 0; x < MAXZONEGROUPS; x++)
	{
		Format(g_szPersonalRecordBonus[x][client], 64, "N/A");
		g_bCheckpointsFound[x][client] = false;
		g_MapRankBonus[x][client] = 9999999;
		g_Stage[x][client] = 0;
		for (int i = 0; i < CPLIMIT; i++)
		{
			g_fCheckpointTimesNew[x][client][i] = 0.0;
			g_fCheckpointTimesRecord[x][client][i] = 0.0;
		}
	}

	for (int i = 0; i < TITLE_COUNT; i++)
	{
		g_bflagTitles[client][i] = false;
		g_bflagTitles_orig[client][i] = false;
	}

	g_fLastPlayerCheckpoint[client] = GameTime;
	g_bCreatedTeleport[client] = false;
	g_bPracticeMode[client] = false;

	// client options
	g_bInfoPanel[client] = true;
	g_bShowNames[client] = true;
	g_bGoToClient[client] = true;
	g_bShowTime[client] = false;
	g_bHide[client] = false;
	g_bStartWithUsp[client] = false;
	g_bShowSpecs[client] = true;
	g_bAutoBhopClient[client] = true;
	g_bHideChat[client] = false;
	g_bViewModel[client] = true;
	g_bCheckpointsEnabled[client] = true;
	g_bEnableQuakeSounds[client] = true;
	g_orgSrSoundId[client] = 0; 
  	g_orgBrSoundId[client] = 1; 
  	g_orgBeatSoundId[client] = 2; 
}

public void clearPlayerCheckPoints(int client)
{
	for (int x = 0; x < 3; x++)
	{
		g_fCheckpointLocation[client][x] = 0.0;
		g_fCheckpointVelocity[client][x] = 0.0;
		g_fCheckpointAngle[client][x] = 0.0;

		g_fCheckpointLocation_undo[client][x] = 0.0;
		g_fCheckpointVelocity_undo[client][x] = 0.0;
		g_fCheckpointAngle_undo[client][x] = 0.0;
	}
	g_fLastPlayerCheckpoint[client] = GetGameTime();
	g_bCreatedTeleport[client] = false;
}

// - Get Runtime -
public void GetcurrentRunTime(int client)
{
	g_fCurrentRunTime[client] = GetGameTime() - g_fStartTime[client] - g_fPauseTime[client];
}

public float GetSpeed(int client)
{
	float fVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", fVelocity);
	float speed = SquareRoot(Pow(fVelocity[0], 2.0) + Pow(fVelocity[1], 2.0));
	return speed;
}

public void SetCashState()
{
	ServerCommand("mp_startmoney 0; mp_playercashawards 0; mp_teamcashawards 0");
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
			SetEntProp(i, Prop_Send, "m_iAccount", 0);
	}
}

public void PlayRecordSound(int iRecordtype, int client)
{
	char buffer[255];
	if (iRecordtype == 0)
	{
		for (int i = 1; i <= GetMaxClients(); i++)
		{
			if (IsValidClient(i) && !IsFakeClient(i) && g_bEnableQuakeSounds[i] == true)
			{
				Format(buffer, sizeof(buffer), "play *%s", g_szSoundPath[g_SrSoundId[client]]);
				ClientCommand(i, buffer);
			}
		}
	}
	else if (iRecordtype == 1)
	{
		for (int i = 1; i <= GetMaxClients(); i++)
		{
			if (IsValidClient(i) && !IsFakeClient(i) && g_bEnableQuakeSounds[i] == true)
			{
				Format(buffer, sizeof(buffer), "play *%s", g_szSoundPath[g_BrSoundId[client]]);
				ClientCommand(i, buffer);
			}
		}
	}
	else if  (iRecordtype == 2)
	{
		Format(buffer, sizeof(buffer), "play *%s", g_szSoundPath[g_BeatSoundId[client]]);
		if (!IsFakeClient(client) && g_bEnableQuakeSounds[client])
			ClientCommand(client, buffer);
		//spec stop sound
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && !IsPlayerAlive(i))
			{
				int SpecMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
				if (SpecMode == 4 || SpecMode == 5)
				{
					int Target = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
					if (Target == client && g_bEnableQuakeSounds[i])
						ClientCommand(i, buffer);
				}
			}
		}
	}
	
}

public void InitPrecache()
{
	
	g_iCustomSoundCount = 0;
	for (int i = 0; i < sizeof(g_szSoundPath); i++)
	{
		char path[128];
		Format(path, 128, g_szSoundPath[i]);
		
		if(path[0] != EOS)
		{
			g_iCustomSoundCount++;
  			char abspath[128];
  			Format(abspath, 128, "%s", g_szSoundPath[i]);
  			AddSoundToDownloadsTable(abspath);
			FakePrecacheSound(abspath);
  		}
	}
	
	char szBuffer[256];
	// Replay Player Model
	GetConVarString(g_hReplayBotPlayerModel, szBuffer, 256);
	AddFileToDownloadsTable(szBuffer);
	PrecacheModel(szBuffer, true);
	// Replay Arm Model
	GetConVarString(g_hReplayBotArmModel, szBuffer, 256);
	AddFileToDownloadsTable(szBuffer);
	PrecacheModel(szBuffer, true);
	// Player Arm Model
	GetConVarString(g_hArmModel, szBuffer, 256);
	AddFileToDownloadsTable(szBuffer);
	PrecacheModel(szBuffer, true);
	// Player Model
	GetConVarString(g_hPlayerModel, szBuffer, 256);
	AddFileToDownloadsTable(szBuffer);
	PrecacheModel(szBuffer, true);

	g_BeamSprite = PrecacheModel("materials/sprites/laserbeam.vmt", true);
	g_HaloSprite = PrecacheModel("materials/sprites/halo.vmt", true);
	PrecacheModel(ZONE_MODEL);
}

// thx to V952 https://forums.alliedmods.net/showthread.php?t=212886
stock int TraceClientViewEntity(int client)
{
	float m_vecOrigin[3];
	float m_angRotation[3];
	GetClientEyePosition(client, m_vecOrigin);
	GetClientEyeAngles(client, m_angRotation);
	Handle tr = TR_TraceRayFilterEx(m_vecOrigin, m_angRotation, MASK_VISIBLE, RayType_Infinite, TRDontHitSelf, client);
	int pEntity = -1;
	if (TR_DidHit(tr))
	{
		pEntity = TR_GetEntityIndex(tr);
		CloseHandle(tr);
		return pEntity;
	}
	CloseHandle(tr);
	return -1;
}

// thx to V952 https://forums.alliedmods.net/showthread.php?t=212886
public bool TRDontHitSelf(int entity, int mask, any data)
{
	if (entity == data)
		return false;
	return true;
}

public void PrintMapRecords(int client)
{
	if (g_fRecordMapTime != 9999999.0)
	{
		PrintToChat(client, "%t", "MapRecord", MOSSGREEN, g_szChatPrefix, WHITE, DARKBLUE, WHITE, g_szRecordMapTime, g_szRecordPlayer);
	}
	for (int i = 1; i <= g_mapZoneGroupCount; i++)
	{
		if (g_fBonusFastest[i] != 9999999.0) // BONUS
		{
			PrintToChat(client, "%t", "BonusRecord", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, g_szZoneGroupName[i], WHITE, g_szBonusFastestTime[i], g_szBonusFastest[i]);
		}
	}
}

stock void MapFinishedMsgs(int client, int rankThisRun = 0)
{
	if (IsValidClient(client))
	{
		char szName[MAX_NAME_LENGTH];
		GetClientName(client, szName, MAX_NAME_LENGTH);
		int count = g_MapTimesCount;

		if (rankThisRun == 0)
			rankThisRun = g_MapRank[client];

		// Check that ck_chat_record_type matches and ck_min_rank_announce matches	
		if ((GetConVarInt(g_hAnnounceRecord) == 0 || 
			(GetConVarInt(g_hAnnounceRecord) == 1 && g_bMapPBRecord[client] || g_bMapSRVRecord[client] || g_bMapFirstRecord[client]) ||
			(GetConVarInt(g_hAnnounceRecord) == 2 && g_bMapSRVRecord[client])) &&
			(rankThisRun <= GetConVarInt(g_hAnnounceRank) || GetConVarInt(g_hAnnounceRank) == 0))
		{
			bool sent = false;
			for (int i = 1; i <= GetMaxClients(); i++)
			{
				if (IsValidClient(i) && !IsFakeClient(i))
				{
					if (g_bMapFirstRecord[client]) // 1st time finishing
					{
						PrintToChat(i, "%t", "MapFinished1", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, DARKBLUE, GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, WHITE, LIMEGREEN, g_MapRank[client], WHITE, count, LIMEGREEN, g_szRecordMapTime, WHITE);
						PrintToConsole(i, "%s finished the map with a time of (%s). [rank #%i/%i | record %s]", szName, g_szFinalTime[client], g_MapRank[client], count, g_szRecordMapTime);
					}
					else
						if (g_bMapPBRecord[client]) // Own record
						{
							PlayRecordSound(2, client);
							PrintToChat(i, "%t", "MapFinished3", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, DARKBLUE, GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, GREEN, g_szTimeDifference[client], GRAY, WHITE, LIMEGREEN, g_MapRank[client], WHITE, count, LIMEGREEN, g_szRecordMapTime, WHITE);
							PrintToConsole(i, "%s finished the map with a time of (%s). Improving their best time by (%s).  [rank #%i/%i | record %s]", szName, g_szFinalTime[client], g_szTimeDifference[client], g_MapRank[client], count, g_szRecordMapTime);
						}
						else
							if (!g_bMapSRVRecord[client] && !g_bMapFirstRecord[client] && !g_bMapPBRecord[client])
							{
								PrintToChat(i, "%t", "MapFinished5", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, DARKBLUE, GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, RED, g_szTimeDifference[client], GRAY, WHITE, LIMEGREEN, g_MapRank[client], WHITE, count, LIMEGREEN, g_szRecordMapTime, WHITE);
								PrintToConsole(i, "%s finished the map with a time of (%s). Missing their best time by (%s).  [rank #%i/%i | record %s]", szName, g_szFinalTime[client], g_szTimeDifference[client], g_MapRank[client], count, g_szRecordMapTime);
							}
					
					if (g_bMapSRVRecord[client])
					{
						
						PrintToChat(i, "%t", "NewMapRecord", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, DARKBLUE);
						PrintToConsole(i, "[%s] %s scored a new MAP RECORD", g_szChatPrefix, szName);
						if(!sent)
						{
							PlayRecordSound(0, client);
							char FancyMsg[64]; 
							Format(FancyMsg, 64, "[%s] %s has beaten the MAP RECORD", g_szChatPrefix, szName);
							LchatSR(FancyMsg);
							//Integration for Discord Module:
							/* Start function call */
							Call_StartForward(g_MapRecordForward);
	
							/* Push parameters one at a time */
							Call_PushCell(client);
							Call_PushFloat(g_fFinalTime[client]);
							Call_PushString(g_szFinalTime[client]);
							Call_PushString(g_szMapName);
							Call_PushString(g_szServerNameBrowser);
	
							/* Finish the call, get the result */
							Call_Finish();
							sent = true;
						}
						
						
						
					}
				}
			}
		} else 
		{ // Print to own chat only
			if (IsValidClient(client) && !IsFakeClient(client))
			{
				if (g_bMapFirstRecord[client])
				{
					PrintToChat(client, "%t", "MapFinished1", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, DARKBLUE, GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, WHITE, LIMEGREEN, g_MapRank[client], WHITE, count, LIMEGREEN, g_szRecordMapTime, WHITE);
					PrintToConsole(client, "%s finished the map with a time of (%s). [rank #%i/%i | record %s]", szName, g_szFinalTime[client], g_MapRank[client], count, g_szRecordMapTime);
				}
				else
				{
					if (g_bMapPBRecord[client])
					{
						PlayRecordSound(2, client);
						PrintToChat(client, "%t", "MapFinished3", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, DARKBLUE, GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, GREEN, g_szTimeDifference[client], GRAY, WHITE, LIMEGREEN, g_MapRank[client], WHITE, count, LIMEGREEN, g_szRecordMapTime, WHITE);
						PrintToConsole(client, "%s finished the map with a time of (%s). Improving their best time by (%s).  [rank #%i/%i | record %s]", szName, g_szFinalTime[client], g_szTimeDifference[client], g_MapRank[client], count, g_szRecordMapTime);
					}
					else
					{
						if (!g_bMapSRVRecord[client] && !g_bMapFirstRecord[client] && !g_bMapPBRecord[client])
						{
							PrintToChat(client, "%t", "MapFinished5", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, DARKBLUE, GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, RED, g_szTimeDifference[client], GRAY, WHITE, LIMEGREEN, g_MapRank[client], WHITE, count, LIMEGREEN, g_szRecordMapTime, WHITE);
							PrintToConsole(client, "%s finished the map with a time of (%s). Missing their best time by (%s).  [rank #%i/%i | record %s]", szName, g_szFinalTime[client], g_szTimeDifference[client], g_MapRank[client], count, g_szRecordMapTime);
						}
					}
				}
			}
		}

		if (g_MapRank[client] == 99999 && IsValidClient(client))
			PrintToChat(client, "[%c%s%c] %cFailed to save your data correctly! Please contact an admin.", MOSSGREEN, g_szChatPrefix, WHITE, DARKRED, RED, DARKRED);

		RequestFrame(UpdatePlayerProfile, GetClientSerial(client));

		if (g_bMapFirstRecord[client] || g_bMapPBRecord[client] || g_bMapSRVRecord[client])
			CheckMapRanks(client);

		/* Start function call */
		Call_StartForward(g_MapFinishForward);

		/* Push parameters one at a time */
		Call_PushCell(client);
		Call_PushFloat(g_fFinalTime[client]);
		Call_PushString(g_szFinalTime[client]);
		Call_PushCell(g_MapRank[client]);
		Call_PushCell(count);

		/* Finish the call, get the result */
		Call_Finish();

	}
	//recalc avg
	db_CalcAvgRunTime();

	return;
}

stock void PrintChatBonus(int client, int zGroup, int rank = 0)
{
	if (!IsValidClient(client))
		return;

	float RecordDiff;
	char szRecordDiff[54], szName[MAX_NAME_LENGTH];

	if (rank == 0)
		rank = g_MapRankBonus[zGroup][client];

	GetClientName(client, szName, MAX_NAME_LENGTH);
	if ((GetConVarInt(g_hAnnounceRecord) == 0 ||
		(GetConVarInt(g_hAnnounceRecord) == 1 && g_bBonusSRVRecord[client] || g_bBonusPBRecord[client] || g_bBonusFirstRecord[client]) ||
		(GetConVarInt(g_hAnnounceRecord) == 2 && g_bBonusSRVRecord[client])) &&
		(rank <= GetConVarInt(g_hAnnounceRank) || GetConVarInt(g_hAnnounceRank) == 0))
	{
		if (g_bBonusSRVRecord[client])
		{
			PlayRecordSound(1, client);
			
			RecordDiff = g_fOldBonusRecordTime[zGroup] - g_fFinalTime[client];
			FormatTimeFloat(client, RecordDiff, 3, szRecordDiff, 54);
			Format(szRecordDiff, 54, "-%s", szRecordDiff);
		}
		if (g_bBonusFirstRecord[client] && g_bBonusSRVRecord[client])
		{
			PrintToChatAll("%t", "BonusFinished2", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, YELLOW, g_szZoneGroupName[zGroup]);
			char FancyMsg[64]; 
			Format(FancyMsg, 64, "[%s] %s has beaten the %s RECORD", g_szChatPrefix, szName, g_szZoneGroupName[zGroup]);
			LchatBR(FancyMsg);
			
			//Integration for Discord Module:
			/* Start function call */
			Call_StartForward(g_BonusRecordForward);
				
			/* Push parameters one at a time */
			Call_PushCell(client);
			Call_PushFloat(g_fFinalTime[client]);
			Call_PushString(g_szFinalTime[client]);
			Call_PushString(g_szMapName);
			Call_PushString(g_szServerNameBrowser);
			Call_PushString(g_szZoneGroupName[zGroup]);
			/* Finish the call, get the result */
			Call_Finish();
			
			
			if (g_tmpBonusCount[zGroup] == 0)
				PrintToChatAll("%t", "BonusFinished3", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, WHITE, LIMEGREEN, g_szFinalTime[client], WHITE);
			else
				PrintToChatAll("%t", "BonusFinished4", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, szRecordDiff, GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szFinalTime[client], WHITE);
		}
		if (g_bBonusPBRecord[client] && g_bBonusSRVRecord[client])
		{
			PrintToChatAll("%t", "BonusFinished2", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, YELLOW, g_szZoneGroupName[zGroup]);
			char FancyMsg[64]; 
			Format(FancyMsg, 64, "[%s] %s has beaten the %s RECORD", g_szChatPrefix, szName, g_szZoneGroupName[zGroup]);
			LchatBR(FancyMsg);
			
			//Integration for Discord Module:
			/* Start function call */
			Call_StartForward(g_BonusRecordForward);
				
			/* Push parameters one at a time */
			Call_PushCell(client);
			Call_PushFloat(g_fFinalTime[client]); 
			Call_PushString(g_szFinalTime[client]);
			Call_PushString(g_szMapName);
			Call_PushString(g_szServerNameBrowser);
			Call_PushString(g_szZoneGroupName[zGroup]);
			/* Finish the call, get the result */
			Call_Finish();
			
			
			PrintToChatAll("%t", "BonusFinished5", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, szRecordDiff, GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szFinalTime[client], WHITE);
		}
		if (g_bBonusPBRecord[client] && !g_bBonusSRVRecord[client])
		{
			PlayRecordSound(2, client);
			PrintToChatAll("%t", "BonusFinished6", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, g_szBonusTimeDifference[client], GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szBonusFastestTime[zGroup], WHITE);
		}
		if (g_bBonusFirstRecord[client] && !g_bBonusSRVRecord[client])
		{
			PrintToChatAll("%t", "BonusFinished7", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szBonusFastestTime[zGroup], WHITE);
		}
		if (!g_bBonusSRVRecord[client] && !g_bBonusFirstRecord[client] && !g_bBonusPBRecord[client])
		{
 			PrintToChatAll("%t", "BonusFinished1", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, RED, g_szFinalTime[client], GRAY, RED, g_szBonusTimeDifference[client], GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szBonusFastestTime[zGroup], GRAY);
		}
	}
	else
	{
		if (g_bBonusSRVRecord[client])
		{
			PlayRecordSound(1, client);
			RecordDiff = g_fOldBonusRecordTime[zGroup] - g_fFinalTime[client];
			FormatTimeFloat(client, RecordDiff, 3, szRecordDiff, 54);
			Format(szRecordDiff, 54, "-%s", szRecordDiff);
		}
		if (g_bBonusFirstRecord[client] && g_bBonusSRVRecord[client])
		{
			PrintToChat(client, "%t", "BonusFinished2", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, YELLOW, g_szZoneGroupName[zGroup]);
			if (g_tmpBonusCount[zGroup] == 0)
				PrintToChat(client, "%t", "BonusFinished3", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, WHITE, LIMEGREEN, g_szFinalTime[client], WHITE);
			else
				PrintToChat(client, "%t", "BonusFinished4", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, szRecordDiff, GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szFinalTime[client], WHITE);
		}
		if (g_bBonusPBRecord[client] && g_bBonusSRVRecord[client])
		{
			PrintToChat(client, "%t", "BonusFinished2", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, YELLOW, g_szZoneGroupName[zGroup]);
			PrintToChat(client, "%t", "BonusFinished5", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, szRecordDiff, GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szFinalTime[client], WHITE);
		}
		if (g_bBonusPBRecord[client] && !g_bBonusSRVRecord[client])
		{
			PlayRecordSound(2 , client);
			PrintToChat(client, "%t", "BonusFinished6", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, g_szBonusTimeDifference[client], GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szBonusFastestTime[zGroup], WHITE);
		}
		if (g_bBonusFirstRecord[client] && !g_bBonusSRVRecord[client])
		{
			PrintToChat(client, "%t", "BonusFinished7", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, LIMEGREEN, g_szFinalTime[client], GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szBonusFastestTime[zGroup], WHITE);
		}
		if (!g_bBonusSRVRecord[client] && !g_bBonusFirstRecord[client] && !g_bBonusPBRecord[client])
		{
			if (IsValidClient(client))
	 			PrintToChat(client, "%t", "BonusFinished1", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN, szName, GRAY, YELLOW, g_szZoneGroupName[zGroup], GRAY, RED, g_szFinalTime[client], GRAY, RED, g_szBonusTimeDifference[client], GRAY, LIMEGREEN, g_MapRankBonus[zGroup][client], GRAY, g_iBonusCount[zGroup], LIMEGREEN, g_szBonusFastestTime[zGroup], GRAY);
		}

	}

	/* Start function call */
	Call_StartForward(g_BonusFinishForward);

	/* Push parameters one at a time */
	Call_PushCell(client);
	Call_PushFloat(g_fFinalTime[client]);
	Call_PushString(g_szFinalTime[client]);
	Call_PushCell(rank);
	Call_PushCell(g_iBonusCount[zGroup]);
	Call_PushCell(zGroup);

	/* Finish the call, get the result */
	Call_Finish();

	CheckBonusRanks(client, zGroup);
	db_CalcAvgRunTimeBonus();

	if (rank == 9999999 && IsValidClient(client))
		PrintToChat(client, "[%c%s%c] %cFailed to save your data correctly! Please contact an admin.", MOSSGREEN, g_szChatPrefix, WHITE, DARKRED, RED, DARKRED);

	return;
}

void LchatSR(const char[] message)
{		
		
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
			continue;
		}
		ClearSyncHud(i, g_hHudSync);
		SetHudTextParams(-1.0, 0.13, 10.0, 107, 244, 66, 255, 2, 0.1, 0.1, 0.1);
		ShowSyncHudText(i, g_hHudSync, "%s", message);
	
	}
}
void LchatBR(const char[] message)
{		
		
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
			continue;
		}
		ClearSyncHud(i, g_hHudSync);
		SetHudTextParams(-1.0, 0.13, 10.0, 200, 2, 255, 255, 2, 0.1, 0.1, 0.1);
		ShowSyncHudText(i, g_hHudSync, "%s", message);
	}
}

public void CheckMapRanks(int client)
{
	// if client has risen in rank,
	if (g_OldMapRank[client] > g_MapRank[client])
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && !IsFakeClient(i) && i != client)
			{  //if clients rank used to be bigger than i's, 2nd: clients new rank is at least as big as i's
				if (g_OldMapRank[client] > g_MapRank[i] && g_MapRank[client] <= g_MapRank[i])
					g_MapRank[i]++;
			}
		}
	}
}

public void CheckBonusRanks(int client, int zGroup)
{
	// if client has risen in rank,
	if (g_OldMapRankBonus[zGroup][client] > g_MapRankBonus[zGroup][client])
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && !IsFakeClient(i) && i != client)
			{  //if clients rank used to be bigger than i's, 2nd: clients new rank is at least as big as i's
				if (g_OldMapRankBonus[zGroup][client] > g_MapRankBonus[zGroup][i] && g_MapRankBonus[zGroup][client] <= g_MapRankBonus[zGroup][i])
					g_MapRankBonus[zGroup][i]++;
			}
		}
	}
}

public void ReplaceChar(char[] sSplitChar, char[] sReplace, char sString[64])
{
	StrCat(sString, sizeof(sString), " ");
	char sBuffer[16][256];
	ExplodeString(sString, sSplitChar, sBuffer, sizeof(sBuffer), sizeof(sBuffer[]));
	strcopy(sString, sizeof(sString), "");
	for (int i = 0; i < sizeof(sBuffer); i++)
	{
		if (strcmp(sBuffer[i], "") == 0)
			continue;
		if (i != 0)
		{
			char sTmpStr[256];
			Format(sTmpStr, sizeof(sTmpStr), "%s%s", sReplace, sBuffer[i]);
			StrCat(sString, sizeof(sString), sTmpStr);
		}
		else
		{
			StrCat(sString, sizeof(sString), sBuffer[i]);
		}
	}
}

public void FormatTimeFloat(int client, float time, int type, char[] string, int length)
{
	char szMilli[16];
	char szSeconds[16];
	char szMinutes[16];
	char szHours[16];
	char szMilli2[16];
	char szSeconds2[16];
	char szMinutes2[16];
	int imilli;
	int imilli2;
	int iseconds;
	int iminutes;
	int ihours;
	time = FloatAbs(time);
	imilli = RoundToZero(time * 100);
	imilli2 = RoundToZero(time * 10);
	imilli = imilli % 100;
	imilli2 = imilli2 % 10;
	iseconds = RoundToZero(time);
	iseconds = iseconds % 60;
	iminutes = RoundToZero(time / 60);
	iminutes = iminutes % 60;
	ihours = RoundToZero((time / 60) / 60);

	if (imilli < 10)
		Format(szMilli, 16, "0%dms", imilli);
	else
		Format(szMilli, 16, "%dms", imilli);
	if (iseconds < 10)
		Format(szSeconds, 16, "0%ds", iseconds);
	else
		Format(szSeconds, 16, "%ds", iseconds);
	if (iminutes < 10)
		Format(szMinutes, 16, "0%dm", iminutes);
	else
		Format(szMinutes, 16, "%dm", iminutes);

	Format(szMilli2, 16, "%d", imilli2);
	if (iseconds < 10)
		Format(szSeconds2, 16, "0%d", iseconds);
	else
		Format(szSeconds2, 16, "%d", iseconds);
	if (iminutes < 10)
		Format(szMinutes2, 16, "0%d", iminutes);
	else
		Format(szMinutes2, 16, "%d", iminutes);
	//Time: 00m 00s 00ms
	if (type == 0)
	{
		Format(szHours, 16, "%dm", iminutes);
		if (ihours > 0)
		{
			Format(szHours, 16, "%d", ihours);
			Format(string, length, "%s:%s:%s.%s", szHours, szMinutes2, szSeconds2, szMilli2);
		}
		else
		{
			Format(string, length, "%s:%s.%s", szMinutes2, szSeconds2, szMilli2);
		}
	}
	//00m 00s 00ms
	if (type == 1)
	{
		Format(szHours, 16, "%dm", iminutes);
		if (ihours > 0)
		{
			Format(szHours, 16, "%dh", ihours);
			Format(string, length, "%s %s %s %s", szHours, szMinutes, szSeconds, szMilli);
		}
		else
			Format(string, length, "%s %s %s", szMinutes, szSeconds, szMilli);
	}
	else
		//00h 00m 00s 00ms
	if (type == 2)
	{
		imilli = RoundToZero(time * 1000);
		imilli = imilli % 1000;
		if (imilli < 10)
			Format(szMilli, 16, "00%dms", imilli);
		else
			if (imilli < 100)
				Format(szMilli, 16, "0%dms", imilli);
			else
				Format(szMilli, 16, "%dms", imilli);
		Format(szHours, 16, "%dh", ihours);
		Format(string, 32, "%s %s %s %s", szHours, szMinutes, szSeconds, szMilli);
	}
	else
		//00:00:00
	if (type == 3)
	{
		if (imilli < 10)
			Format(szMilli, 16, "0%d", imilli);
		else
			Format(szMilli, 16, "%d", imilli);
		if (iseconds < 10)
			Format(szSeconds, 16, "0%d", iseconds);
		else
			Format(szSeconds, 16, "%d", iseconds);
		if (iminutes < 10)
			Format(szMinutes, 16, "0%d", iminutes);
		else
			Format(szMinutes, 16, "%d", iminutes);
		if (ihours > 0)
		{
			Format(szHours, 16, "%d", ihours);
			Format(string, length, "%s:%s:%s:%s", szHours, szMinutes, szSeconds, szMilli);
		}
		else
			Format(string, length, "%s:%s:%s", szMinutes, szSeconds, szMilli);
	}
	//Time: 00:00:00
	if (type == 4)
	{
		if (imilli < 10)
			Format(szMilli, 16, "0%d", imilli);
		else
			Format(szMilli, 16, "%d", imilli);
		if (iseconds < 10)
			Format(szSeconds, 16, "0%d", iseconds);
		else
			Format(szSeconds, 16, "%d", iseconds);
		if (iminutes < 10)
			Format(szMinutes, 16, "0%d", iminutes);
		else
			Format(szMinutes, 16, "%d", iminutes);
		if (ihours > 0)
		{
			Format(szHours, 16, "%d", ihours);
			Format(string, length, "Time: %s:%s:%s", szHours, szMinutes, szSeconds);
		}
		else
			Format(string, length, "Time: %s:%s", szMinutes, szSeconds);
	}
	// goes to  00:00
	if (type == 5)
	{
		if (imilli < 10)
			Format(szMilli, 16, "0%d", imilli);
		else
			Format(szMilli, 16, "%d", imilli);
		if (iseconds < 10)
			Format(szSeconds, 16, "0%d", iseconds);
		else
			Format(szSeconds, 16, "%d", iseconds);
		if (iminutes < 10)
			Format(szMinutes, 16, "0%d", iminutes);
		else
			Format(szMinutes, 16, "%d", iminutes);
		if (ihours > 0)
		{

			Format(szHours, 16, "%d", ihours);
			Format(string, length, "%s:%s:%s:%s", szHours, szMinutes, szSeconds, szMilli);
		}
		else
			if (iminutes > 0)
				Format(string, length, "%s:%s:%s", szMinutes, szSeconds, szMilli);
			else
				Format(string, length, "%s:%ss", szSeconds, szMilli);
	}
}

public void SetSkillGroups()
{
	//Map Points	
	int mapcount;
	if (g_pr_MapCount < 1)
		mapcount = 1;
	else
		mapcount = g_pr_MapCount;

	g_pr_PointUnit = 1;
	float MaxPoints = (float(mapcount) * 700.0) + (float(g_totalBonusCount) * 400.0);

	// Load rank cfg
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), SKILLGROUP_PATH);
	if (FileExists(sPath))
	{
		Handle hKeyValues = CreateKeyValues("ckSurf.SkillGroups");
		if (FileToKeyValues(hKeyValues, sPath) && KvGotoFirstSubKey(hKeyValues))
		{
			int RankValue[SkillGroup];

			if (g_hSkillGroups == null)
				g_hSkillGroups = CreateArray(sizeof(RankValue));
			else
				ClearArray(g_hSkillGroups);

			char sRankName[128], sRankNameColored[128],sNameColor[32]; //color string size is "enough"
			float fPercentage;
			int points;
			do
			{
				// Get section as Rankname
				KvGetString(hKeyValues, "name", sRankName, 128);
				KvGetString(hKeyValues, "name", sRankNameColored, 128);
				KvGetString(hKeyValues, "rankColor", sNameColor, 32);

				// Get percentage
				fPercentage = KvGetFloat(hKeyValues, "percentage");

				// Calculate required points for the rank
				if (fPercentage < 0.0)
					points = 0;
				else
					points = RoundToCeil(MaxPoints * fPercentage);

				RankValue[PointReq] = points;

				// Replace colors on name
				//addColorToString(sRankNameColored, 128);

				// Get player name color
				//I cringe reading this...

				// Remove colors from then non-colored rank name
				normalizeChatString(sRankName, 128);

				Format(RankValue[RankName], 128, "%s", sRankName);
				Format(RankValue[RankNameColored], 128, "%s", sRankNameColored);
				Format(RankValue[NameColor], 32 ,"%s",sNameColor);

				PushArrayArray(g_hSkillGroups, RankValue[0]);

			} while (KvGotoNextKey(hKeyValues));
		}
		if (hKeyValues != null)
			CloseHandle(hKeyValues);
	}
	else
		SetFailState("[%s] %s not found.", g_szChatPrefix, SKILLGROUP_PATH);

}

public void SetPlayerRank(int client)
{
	if (IsFakeClient(client))
		return;

	if (g_hSkillGroups == null)
	{
		CreateTimer(5.0, reloadRank, GetClientSerial(client));
		return;
	}

	int RankValue[SkillGroup];
	int index = GetSkillgroupFromPoints(g_pr_points[client]);

	if (g_iTitleInUse[client] == -1)
	{
		// Player is not using a title
		if (GetConVarBool(g_hPointSystem))
		{
			GetArrayArray(g_hSkillGroups, index, RankValue[0]);

			Format(g_pr_rankname[client], 128, "[%s]", RankValue[RankName]);
			Format(g_pr_chat_coloredrank[client], 128, "[%s%c]", RankValue[RankNameColored], WHITE);
			Format(g_pr_rankColor[client],32,"%s", RankValue[NameColor]);
		}
	}
	else
	{
		Format(g_pr_rankname[client], 128, "[%s]", g_szflagTitle[g_iTitleInUse[client]]);
		Format(g_pr_chat_coloredrank[client], 128, "[%s%c]", g_szflagTitle_Colored[g_iTitleInUse[client]], WHITE);
	}

	// Admin Clantag
	if (GetConVarBool(g_hAdminClantag))
	{ if (GetUserFlagBits(client) & ADMFLAG_ROOT || GetUserFlagBits(client) & ADMFLAG_GENERIC)
		{
			Format(g_pr_chat_coloredrank[client], 128, "%s %cADMIN%c", g_pr_chat_coloredrank[client], LIMEGREEN, WHITE);
			Format(g_pr_rankname[client], 128, "ADMIN");
			return;
		}
	}
}

public int GetSkillgroupFromPoints(int points)
{
	int size = GetArraySize(g_hSkillGroups);
	for (int i = 0; i < size; i++)
	{
		int RankValue[SkillGroup];
		GetArrayArray(g_hSkillGroups, i, RankValue[0]);

		if (i == (size-1)) // Last rank
		{
			if (points >= RankValue[PointReq])
			{
				return i;
			}
		}
		else if (i == 0) // First rank
		{
			if (points <= RankValue[PointReq])
			{
				return i;
			}
		}
		else // Mid ranks
		{
			int RankValueNext[SkillGroup];
			GetArrayArray(g_hSkillGroups, (i+1), RankValueNext[0]);
			if (points > RankValue[PointReq] && points <= RankValueNext[PointReq])
			{
				return i;
			}
		}
	}
	// Return 0 if not found
	return 0;
}

//http://pastebin.com/YdUWS93H
public bool CheatFlag(const char[] voice_inputfromfile, bool isCommand, bool remove)
{
	if (remove)
	{
		if (!isCommand)
		{
			Handle hConVar = FindConVar(voice_inputfromfile);
			if (hConVar != null)
			{
				int flags = GetConVarFlags(hConVar);
				SetConVarFlags(hConVar, flags &= ~FCVAR_CHEAT);
				return true;
			}
			else
				return false;
		}
		else
		{
			int flags = GetCommandFlags(voice_inputfromfile);
			if (SetCommandFlags(voice_inputfromfile, flags &= ~FCVAR_CHEAT))
				return true;
			else
				return false;
		}
	}
	else
	{
		if (!isCommand)
		{
			Handle hConVar = FindConVar(voice_inputfromfile);
			if (hConVar != null)
			{
				int flags = GetConVarFlags(hConVar);
				SetConVarFlags(hConVar, flags & FCVAR_CHEAT);
				return true;
			}
			else
				return false;

		} else
		{
			int flags = GetCommandFlags(voice_inputfromfile);
			if (SetCommandFlags(voice_inputfromfile, flags & FCVAR_CHEAT))
				return true;
			else
				return false;

		}
	}
}

public void StringRGBtoInt(char color[24], intColor[4])
{
	char sPart[4][24];
	ExplodeString(color, " ", sPart, sizeof(sPart), sizeof(sPart[]));
	intColor[0] = StringToInt(sPart[0]);
	intColor[1] = StringToInt(sPart[1]);
	intColor[2] = StringToInt(sPart[2]);
	intColor[3] = 255;
}

public void GetRGBColor(int bot, char color[256])
{
	char sPart[4][24];
	ExplodeString(color, " ", sPart, sizeof(sPart), sizeof(sPart[]));

	if (bot == 0)
	{
		g_ReplayBotColor[0] = StringToInt(sPart[0]);
		g_ReplayBotColor[1] = StringToInt(sPart[1]);
		g_ReplayBotColor[2] = StringToInt(sPart[2]);
	}
	else
		if (bot == 1)
	{
		g_BonusBotColor[0] = StringToInt(sPart[0]);
		g_BonusBotColor[1] = StringToInt(sPart[1]);
		g_BonusBotColor[2] = StringToInt(sPart[2]);
	}

	if (bot == 0 && g_RecordBot != -1 && IsValidClient(g_RecordBot))
		SetEntityRenderColor(g_RecordBot, g_ReplayBotColor[0], g_ReplayBotColor[1], g_ReplayBotColor[2], 50);
	else
		if (bot == 1 && g_BonusBot != -1 && IsValidClient(g_BonusBot))
		SetEntityRenderColor(g_BonusBot, g_BonusBotColor[0], g_BonusBotColor[1], g_BonusBotColor[2], 50);

}

public void SpecList(int client)
{
	if (!IsValidClient(client) || IsFakeClient(client) || GetClientMenu(client) != MenuSource_None)
		return;

	if (!StrEqual(g_szPlayerPanelText[client], ""))
	{
		Handle panel = CreatePanel();
		DrawPanelText(panel, g_szPlayerPanelText[client]);
		SendPanelToClient(panel, client, PanelHandler, 1);
		CloseHandle(panel);
	}
}

public int PanelHandler(Handle menu, MenuAction action, int param1, int param2)
{
}

public bool TraceRayDontHitSelf(int entity, int mask, any data)
{
	return entity != data && !(0 < entity <= MaxClients);
}

stock int BooltoInt(bool status)
{
	return (status) ? 1:0;
}

public void PlayQuakeSound_Spec(int client, char[] buffer)
{
	int SpecMode;
	for (int x = 1; x <= MaxClients; x++)
	{
		if (IsValidClient(x) && !IsPlayerAlive(x))
		{
			SpecMode = GetEntProp(x, Prop_Send, "m_iObserverMode");
			if (SpecMode == 4 || SpecMode == 5)
			{
				int Target = GetEntPropEnt(x, Prop_Send, "m_hObserverTarget");
				if (Target == client)
					if (g_bEnableQuakeSounds[x])
					ClientCommand(x, buffer);
			}
		}
	}
}

public void AttackProtection(int client, int &buttons)
{
	if (GetConVarBool(g_hAttackSpamProtection))
	{
		char classnamex[64];
		GetClientWeapon(client, classnamex, 64);
		if (StrContains(classnamex, "knife", true) == -1 && g_AttackCounter[client] >= 40)
		{
			if (buttons & IN_ATTACK)
			{
				int ent;
				ent = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
				if (IsValidEntity(ent))
					SetEntPropFloat(ent, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + 2.0);
			}
		}
	}
}

public void CheckRun(int client)
{
	if (!IsValidClient(client) || IsFakeClient(client))
		return;

	if (g_bTimeractivated[client])
	{
		if (g_fCurrentRunTime[client] > g_fPersonalRecord[client] && !g_bMissedMapBest[client] && !g_bPause[client] && g_iClientInZone[client][2] == 0)
		{
			g_bMissedMapBest[client] = true;
			if (g_fPersonalRecord[client] > 0.0)
				PrintToChat(client, "%t", "MissedMapBest", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, DARKBLUE, g_szPersonalRecord[client], GRAY);
			EmitSoundToClient(client, "buttons/button18.wav", client);
		}
		else
		{
			if (g_fCurrentRunTime[client] > g_fPersonalRecordBonus[g_iClientInZone[client][2]][client] && g_iClientInZone[client][2] > 0 && !g_bPause[client] && !g_bMissedBonusBest[client])
			{
				if (g_fPersonalRecordBonus[g_iClientInZone[client][2]][client] > 0.0)
				{
					g_bMissedBonusBest[client] = true;
					PrintToChat(client, "[%c%s%c] %cYou have missed your best bonus time of (%c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, YELLOW, g_szPersonalRecordBonus[g_iClientInZone[client][2]][client], GRAY);
					EmitSoundToClient(client, "buttons/button18.wav", client);
				}
			}
		}
	}
}

public void NoClipCheck(int client)
{
	MoveType mt;
	mt = GetEntityMoveType(client);
	if (!(g_bOnGround[client]))
	{
		if (mt == MOVETYPE_NOCLIP)
			g_bNoClipUsed[client] = true;
	}
	if (mt == MOVETYPE_NOCLIP && (g_bTimeractivated[client]))
	{
		Client_Stop(client, 1);
	}
}

public void AutoBhopFunction(int client, int &buttons)
{
	if (!IsValidClient(client))
		return;
	if (g_bAutoBhop && g_bAutoBhopClient[client])
	{
		if (buttons & IN_JUMP)
			if (!(g_bOnGround[client]))
			if (!(GetEntityMoveType(client) & MOVETYPE_LADDER))
			if (GetEntProp(client, Prop_Data, "m_nWaterLevel") <= 1)
			buttons &= ~IN_JUMP;

	}
}

public void SpecListMenuDead(int client) // What Spectators see
{
	char szTick[32];
	Format(szTick, 32, "%i", g_Server_Tickrate);
	int ObservedUser;
	ObservedUser = -1;
	char sSpecs[512];
	Format(sSpecs, 512, "");
	int SpecMode;
	ObservedUser = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
	SpecMode = GetEntProp(client, Prop_Send, "m_iObserverMode");

	if (SpecMode == 4 || SpecMode == 5)
	{
		g_SpecTarget[client] = ObservedUser;
		int count;
		count = 0;
		//Speclist
		if (1 <= ObservedUser <= MaxClients)
		{
			int x;
			char szTime2[32];
			char szProBest[32];
			char szPlayerRank[64];
			Format(szPlayerRank, 32, "");
			char szStage[32];

			for (x = 1; x <= MaxClients; x++)
			{
				if (IsValidClient(x) && !IsFakeClient(client) && !IsPlayerAlive(x) && GetClientTeam(x) >= 1 && GetClientTeam(x) <= 3)
				{

					SpecMode = GetEntProp(x, Prop_Send, "m_iObserverMode");
					if (SpecMode == 4 || SpecMode == 5)
					{
						int ObservedUser2;
						ObservedUser2 = GetEntPropEnt(x, Prop_Send, "m_hObserverTarget");
						if (ObservedUser == ObservedUser2)
						{
						//if (!SR_IsClientStealthed(x)) 
             			//	{ 
							count++;
							//strip backslashes from names (causes lags and crashes?)
							char cleanName[MAX_NAME_LENGTH];
							Format(cleanName, sizeof(cleanName),"%N",x);
							ReplaceString(cleanName,sizeof(cleanName),"\\","",false);
							ReplaceString(cleanName,sizeof(cleanName),"#","",false);
							if (count < 6)
								Format(sSpecs, 512, "%s%s\n", sSpecs, cleanName);
						//	}
						}
						if (count == 6)
							Format(sSpecs, 512, "%s...", sSpecs);
					}
				}
			}

			//rank
			if (GetConVarBool(g_hPointSystem))
			{
				if (g_pr_points[ObservedUser] != 0)
				{
					char szRank[32];
					if (g_PlayerRank[ObservedUser] > g_pr_RankedPlayers)
						Format(szRank, 32, "-");
					else
						Format(szRank, 32, "%i", g_PlayerRank[ObservedUser]);
					Format(szPlayerRank, 32, "Rank: #%s/%i", szRank, g_pr_RankedPlayers);
				}
				else
					Format(szPlayerRank, 32, "Rank: NA / %i", g_pr_RankedPlayers);
			}
			if (g_fPersonalRecord[ObservedUser] > 0.0)
			{
				FormatTimeFloat(client, g_fPersonalRecord[ObservedUser], 3, szTime2, sizeof(szTime2));
				Format(szProBest, 32, "%s (#%i/%i)", szTime2, g_MapRank[ObservedUser], g_MapTimesCount);
			}
			else
				Format(szProBest, 32, "None");

			if (g_bhasStages) //  There are stages
				Format(szStage, 32, "%i / %i", g_Stage[g_iClientInZone[ObservedUser][2]][ObservedUser], (g_mapZonesTypeCount[g_iClientInZone[ObservedUser][2]][3] + 1));
			else
				Format(szStage, 32, "Linear map");

			if (g_Stage[g_iClientInZone[client][2]][ObservedUser] == 999) // if player is in stage 999
				Format(szStage, 32, "Bonus");

			if (!StrEqual(sSpecs, ""))
			{
				char szName[MAX_NAME_LENGTH];
				GetClientName(ObservedUser, szName, MAX_NAME_LENGTH);
				if (g_bTimeractivated[ObservedUser])
				{
					char szTime[32];
					float Time;
					Time = GetGameTime() - g_fStartTime[ObservedUser] - g_fPauseTime[ObservedUser];
					FormatTimeFloat(client, Time, 4, szTime, sizeof(szTime));
					if (!g_bPause[ObservedUser])
					{
						if (!IsFakeClient(ObservedUser))
						{
							Format(g_szPlayerPanelText[client], 512, "Specs (%i):\n%s\n  \n%s\n%s\nRecord: %s\n\nStage: %s\n", count, sSpecs, szTime, szPlayerRank, szProBest, szStage);
							if (!g_bShowSpecs[client])
								Format(g_szPlayerPanelText[client], 512, "Specs (%i)\n \n%s\n%s\nRecord: %s\n\nStage: %s\n", count, szTime, szPlayerRank, szProBest, szStage);
						}
						else
						{
							if (ObservedUser == g_RecordBot)
								Format(g_szPlayerPanelText[client], 512, "[Map Record Replay]\n%s\nTickrate: %s\nSpecs: %i\n\nStage: %s\n", szTime, szTick, count, szStage);
							else
								if (ObservedUser == g_BonusBot)
									Format(g_szPlayerPanelText[client], 512, "[%s Record Replay]\n%s\nTickrate: %s\nSpecs: %i\n\nStage: %s\n", g_szZoneGroupName[g_iClientInZone[g_BonusBot][2]], szTime, szTick, count, szStage);

						}
					}
					else
					{
						if (ObservedUser == g_RecordBot)
							Format(g_szPlayerPanelText[client], 512, "[Map Record Replay]\nTime: PAUSED\nTickrate: %s\nSpecs: %i\n\nStage: %s\n", szTick, count, szStage);
						else
							if (ObservedUser == g_BonusBot)
								Format(g_szPlayerPanelText[client], 512, "[%s Record Replay]\nTime: PAUSED\nTickrate: %s\nSpecs: %i\n\nStage: Bonus\n", g_szZoneGroupName[g_iClientInZone[g_BonusBot][2]], szTick, count);
					}
				}
				else
				{
					if (ObservedUser != g_RecordBot)
					{
						Format(g_szPlayerPanelText[client], 512, "%Specs (%i):\n%s\n \n%s\nRecord: %s\n", count, sSpecs, szPlayerRank, szProBest);
						if (!g_bShowSpecs[client])
							Format(g_szPlayerPanelText[client], 512, "Specs (%i)\n \n%s\nRecord: %s\n", count, szPlayerRank, szProBest);
					}
				}

				if (!g_bShowTime[client] && g_bShowSpecs[client])
				{
					if (ObservedUser != g_RecordBot && ObservedUser != g_BonusBot)
						Format(g_szPlayerPanelText[client], 512, "%Specs (%i):\n%s\n \n%s\nRecord: %s\n\nStage: %s\n", count, sSpecs, szPlayerRank, szProBest, szStage);
					else
					{
						if (ObservedUser == g_RecordBot)
							Format(g_szPlayerPanelText[client], 512, "Record replay of\n%s\n \nTickrate: %s\nSpecs (%i):\n%s\n\nStage: %s\n", g_szReplayName, szTick, count, sSpecs, szStage);
						else
							if (ObservedUser == g_BonusBot)
							Format(g_szPlayerPanelText[client], 512, "Bonus replay of\n%s\n \nTickrate: %s\nSpecs (%i):\n%s\n\nStage: Bonus\n", g_szBonusName, szTick, count, sSpecs);

					}
				}
				if (!g_bShowTime[client] && !g_bShowSpecs[client])
				{
					if (ObservedUser != g_RecordBot)
						Format(g_szPlayerPanelText[client], 512, "%s\nRecord: %s\n\nStage: %s\n", szPlayerRank, szProBest, szStage);
					else
					{
						if (ObservedUser == g_RecordBot)
							Format(g_szPlayerPanelText[client], 512, "Record replay of\n%s\n \nTickrate: %s\n\nStage: %s\n", g_szReplayName, szTick, szStage);
						else
							if (ObservedUser == g_BonusBot)
							Format(g_szPlayerPanelText[client], 512, "Bonus replay of\n%s\n \nTickrate: %s\n\nStage: Bonus\n", g_szBonusName, szTick, szStage);

					}
				}
				SpecList(client);
			}
		}
	}
	else
		g_SpecTarget[client] = -1;
}

public void SpecListMenuAlive(int client) // What player sees
{
	if (IsFakeClient(client) || !g_bShowSpecs[client] || GetClientMenu(client) != MenuSource_None)
		return;

	//Spec list for players
	Format(g_szPlayerPanelText[client], 512, "");
	char sSpecs[512];
	int SpecMode;
	Format(sSpecs, 512, "");
	int count;
	count = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && !IsFakeClient(client) && !IsPlayerAlive(i) && !g_bFirstTeamJoin[i] && g_bSpectate[i])
		{
			SpecMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
			if (SpecMode == 4 || SpecMode == 5)
			{
				int Target;
				Target = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
				if (Target == client)
				{
					//if (!SR_IsClientStealthed(i))  
                		//{ 
						count++;
						if (count < 6)
							{
							char cleanName[MAX_NAME_LENGTH];
							Format(cleanName, sizeof(cleanName),"%N", i);
							ReplaceString(cleanName,sizeof(cleanName),"\\","",false);
							ReplaceString(cleanName,sizeof(cleanName),"#","",false);
							Format(sSpecs, 512, "%s%s\n", sSpecs, cleanName);
							//Format(sSpecs, 512, "%s%N\n", sSpecs, i);
							}
						//}
				}
				if (count == 6)
					Format(sSpecs, 512, "%s...", sSpecs);
			}
		}
	}
	if (count > 0)
	{
		if (g_bShowSpecs[client])
			Format(g_szPlayerPanelText[client], 512, "Specs (%i):\n%s ", count, sSpecs);

		SpecList(client);
	}
	else
		Format(g_szPlayerPanelText[client], 512, "");
}

public void LoadInfoBot()
{
	if (!GetConVarBool(g_hInfoBot))
		return;

	g_InfoBot = -1;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsFakeClient(i) || IsClientSourceTV(i) || i == g_RecordBot || i == g_BonusBot)
			continue;
		g_InfoBot = i;
		break;
	}
	if (IsValidClient(g_InfoBot))
	{
		Format(g_pr_rankname[g_InfoBot], 128, "BOT");
		CS_SetClientClanTag(g_InfoBot, "");
		SetEntProp(g_InfoBot, Prop_Send, "m_iAddonBits", 0);
		SetEntProp(g_InfoBot, Prop_Send, "m_iPrimaryAddon", 0);
		SetEntProp(g_InfoBot, Prop_Send, "m_iSecondaryAddon", 0);
		SetEntProp(g_InfoBot, Prop_Send, "m_iObserverMode", 1);
		SetInfoBotName(g_InfoBot);
	}
	else
	{
		setBotQuota();
		CreateTimer(0.5, RefreshInfoBot, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public void CreateNavFile()
{
	// check if source file exists
	char SourceFile[128];
	Format(SourceFile, sizeof(SourceFile), "maps/replay_bot.nav");
	if (!FileExists(SourceFile))
	{
		LogError("<ckSurf> Failed to create .nav files. Reason: %s doesn't exist!", SourceFile);
		return;
	}

	// build nav file path
	char DestFile[128];
	Format(DestFile, 128, "maps/%s.nav", g_szMapName);

	// copy if doesn't exist and reload via changelevel
	if(!FileExists(DestFile))
	{
		File_Copy(SourceFile, DestFile);
		ForceChangeLevel(g_szMapName, ".nav file generate");
	}
}

public Action RefreshInfoBot(Handle timer)
{
	LoadInfoBot();
}

public void SetInfoBotName(int ent)
{
	char szBuffer[64];
	char sNextMap[128];
	if (!IsValidClient(g_InfoBot) || !GetConVarBool(g_hInfoBot))
		return;
	if (g_bMapChooser && EndOfMapVoteEnabled() && !HasEndOfMapVoteFinished())
		Format(sNextMap, sizeof(sNextMap), "Next Map: Pending Vote");
	else
	{
		GetNextMap(sNextMap, sizeof(sNextMap));
		char mapPieces[6][128];
		int lastPiece = ExplodeString(sNextMap, "/", mapPieces, sizeof(mapPieces), sizeof(mapPieces[]));
		Format(sNextMap, sizeof(sNextMap), "Next Map: %s", mapPieces[lastPiece - 1]);
	}
	int iInfoBotTimeleft;
	GetMapTimeLeft(iInfoBotTimeleft);
	float ftime = float(iInfoBotTimeleft);
	char szTime[32];
	FormatTimeFloat(g_InfoBot, ftime, 4, szTime, sizeof(szTime));
	Handle hTmp;
	hTmp = FindConVar("mp_timelimit");
	int iTimeLimit = GetConVarInt(hTmp);
	if (hTmp != null)
		CloseHandle(hTmp);
	if (GetConVarBool(g_hMapEnd) && iTimeLimit > 0)
		Format(szBuffer, sizeof(szBuffer), "%s left.", sNextMap, szTime);
	else
		Format(szBuffer, sizeof(szBuffer), "No Time Limit");
	CS_SetClientClanTag(g_InfoBot, szTime);	
	SetClientName(g_InfoBot, sNextMap);
	Client_SetScore(g_InfoBot, 0);
	CS_SetClientContributionScore(g_InfoBot, 2);	
}

public void CenterHudDead(int client)
{
	char szTick[32];
	char obsAika[128];
	float obsTimer;
	Format(szTick, 32, "%i", g_Server_Tickrate);
	int ObservedUser;
	ObservedUser = -1;
	int SpecMode;
	ObservedUser = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
	SpecMode = GetEntProp(client, Prop_Send, "m_iObserverMode");
	if (SpecMode == 4 || SpecMode == 5)
	{
		g_SpecTarget[client] = ObservedUser;
		//keys
		char sResult[256];
		int Buttons;
		if (g_bInfoPanel[client] && IsValidClient(ObservedUser))
		{
			Buttons = g_LastButton[ObservedUser];
			if (Buttons & IN_MOVELEFT)
				Format(sResult, sizeof(sResult), "<font color='#00CC00'>A</font>");
			else
				Format(sResult, sizeof(sResult), "_");
			if (Buttons & IN_FORWARD)
				Format(sResult, sizeof(sResult), "%s <font color='#00CC00'>W</font>", sResult);
			else
				Format(sResult, sizeof(sResult), "%s _", sResult);
			if (Buttons & IN_BACK)
				Format(sResult, sizeof(sResult), "%s <font color='#00CC00'>S</font>", sResult);
			else
				Format(sResult, sizeof(sResult), "%s _", sResult);
			if (Buttons & IN_MOVERIGHT)
				Format(sResult, sizeof(sResult), "%s <font color='#00CC00'>D</font>", sResult);
			else
				Format(sResult, sizeof(sResult), "%s _", sResult);
			if (Buttons & IN_DUCK)
				Format(sResult, sizeof(sResult), "%s - <font color='#00CC00'>DUCK</font>", sResult);
			else
				Format(sResult, sizeof(sResult), "%s - _", sResult);
			if (Buttons & IN_JUMP)
				Format(sResult, sizeof(sResult), "%s <font color='#00CC00'>JUMP</font>", sResult);
			else
				Format(sResult, sizeof(sResult), "%s _", sResult);

			if (g_bTimeractivated[ObservedUser]) {
				obsTimer = GetGameTime() - g_fStartTime[ObservedUser] - g_fPauseTime[ObservedUser];
				FormatTimeFloat(client, obsTimer, 3, obsAika, sizeof(obsAika));
			} else {
				obsAika = "<font color='#FF0000'>Stopped</font>";
			}
			char timerText[32] = "";
			if (g_iClientInZone[ObservedUser][2] > 0)
				Format(timerText, 32, "[%s] ", g_szZoneGroupName[g_iClientInZone[ObservedUser][2]]);
			if (g_bPracticeMode[ObservedUser])
				Format(timerText, 32, "[Practice] ");

			PrintHintText(client, "<font face=''><font color='#75D1FF'>%sTimer:</font> %s\n<font color='#75D1FF'>Speed:</font> %.1f u/s\n%s", timerText, obsAika, g_fLastSpeed[ObservedUser], sResult);
		}
	}
	else
		g_SpecTarget[client] = -1;
}

public void CenterHudAlive(int client)
{
	if (!IsValidClient(client))
		return;
	
	char pAika[54], timerText[32], StageString[64];
	
	if (g_bInfoPanel[client])
	{
		if (!g_bhasStages) // map is linear
		{
			Format(StageString, 64, "Linear\t");
		}
		else // map has stages
		{
			if (g_Stage[g_iClientInZone[client][2]][client] > 9)
				Format(StageString, 64, "%i / %i\t", g_Stage[g_iClientInZone[client][2]][client], (g_mapZonesTypeCount[g_iClientInZone[client][2]][3] + 1)); // less \t's to make lines align
			else
				Format(StageString, 64, "%i / %i\t\t", g_Stage[g_iClientInZone[client][2]][client], (g_mapZonesTypeCount[g_iClientInZone[client][2]][3] + 1));
			if(g_mapZonesTypeCount[g_iClientInZone[client][2]][3] >8)
				Format(StageString, 64, "%i / %i\t", g_Stage[g_iClientInZone[client][2]][client], (g_mapZonesTypeCount[g_iClientInZone[client][2]][3] + 1)); // less \t's to make lines align
		}
		
		if (g_bTimeractivated[client] && !g_bPause[client])
		{
			FormatTimeFloat(client, g_fCurrentRunTime[client], 3, pAika, 128);
			if (g_bMissedMapBest[client] && g_fPersonalRecord[client] > 0.0) // missed best personal time
			{
				Format(pAika, 128, "<font color='#00ff87'>%s</font>", pAika);
			}
			else if (g_fPersonalRecord[client] < 0.1) // hasn't finished the map yet
			{
				Format(pAika, 128, "<font color='#00ff87'>%s</font>", pAika);
			}
			else
			{
				Format(pAika, 128, "<font color='#00ff87'>%s</font>", pAika); // hasn't missed best personal time yet
			}
		}
		
		if (g_bPracticeMode[client])
			Format(timerText, 32, "[PRAC]: ");
		else
			Format(timerText, 32, "");
		
		// Set Checkpoint back to normal
		if (GetGameTime() - g_fLastDifferenceTime[client] > 5.0)
		{
			if (g_iClientInZone[client][2] == 0)
			{
				if (g_fRecordMapTime != 9999999.0)
				{
					Format(g_szLastSRDifference[client], 64, "\t\t<font color='#00c3ff'>SR:</font> %s", g_szRecordMapTime);
					if (g_fPersonalRecord[client] > 0.0)
					{
						Format(g_szLastPBDifference[client], 64, "%s", g_szPersonalRecord[client]);
					}
					else
					{
						Format(g_szLastPBDifference[client], 64, "N/A");
					}
				}
				else
				{
					Format(g_szLastSRDifference[client], 64, "\t\t<font color='#00c3ff'>SR:</font> N/A");
					Format(g_szLastPBDifference[client], 64, "N/A");
				}
			}
			else
			{
				Format(g_szLastPBDifference[client], 64, "%s", g_szPersonalRecordBonus[g_iClientInZone[client][2]][client]);
				Format(g_szLastSRDifference[client], 64, "\t\t<font color='#00c3ff'>SR:</font> %s", g_szBonusFastestTime[g_iClientInZone[client][2]]);
			}
		}
		
		
		
		char szRank[128];
		char szRank2[64];
		//Need two strigns, because formmating is differnt on each for some strange reason, i ccant be bothered to look into...
		if (g_iClientInZone[client][2] > 0) // if in bonus stage, get bonus times
		{
			if (g_fPersonalRecordBonus[g_iClientInZone[client][2]][client] > 0.0)
				{
				Format(szRank, 128, "\tRank: %i / %i", g_MapRankBonus[g_iClientInZone[client][2]][client], g_iBonusCount[g_iClientInZone[client][2]]);
				Format(szRank2, 128, "\t<font color='#70a83b'>Rank:</font> %i / %i", g_MapRankBonus[g_iClientInZone[client][2]][client], g_iBonusCount[g_iClientInZone[client][2]]);
				}
			else
				if (g_iBonusCount[g_iClientInZone[client][2]] > 0)
					{
					Format(szRank, 128, "\t\tRank: N/A / %i", g_iBonusCount[g_iClientInZone[client][2]]);
					Format(szRank2, 128, "\t<font color='#70a83b'>Rank:</font> N/A / %i", g_iBonusCount[g_iClientInZone[client][2]]);
					}
				else
					{
					Format(szRank, 128, "\t\tRank: N/A");
					Format(szRank2, 128, "\t<font color='#70a83b'>Rank:</font> N/A / %i", g_iBonusCount[g_iClientInZone[client][2]]);
					}
		}
		else // if in normal map, get normal times
		{
			if (g_fPersonalRecord[client] > 0.0)
			{
				Format(szRank, 128, "\tRank: %i / %i", g_MapRank[client], g_MapTimesCount);
				Format(szRank2, 128, "\t<font color='#70a83b'>Rank:</font> %i / %i", g_MapRank[client], g_MapTimesCount);
			}
			else
				if (g_MapTimesCount > 0)
				{
					Format(szRank, 128, "\t\tRank: N/A / %i", g_MapTimesCount);
					Format(szRank2, 128, "\t<font color='#70a83b'>Rank:</font> N/A / %i", g_MapTimesCount);
				}
				else
				{
					Format(szRank, 128, "\t\tRank: N/A");
					Format(szRank2, 128, "\t<font color='#70a83b'>Rank:</font> N/A");
				}
		}
		
		int speed = RoundToNearest(g_fLastSpeed[client]);
		int colourLookup = RoundToFloor(speed / 233.33);
		if (colourLookup > 15)
		{
			colourLookup = 15;
		}
		char colourName[8];
		switch (colourLookup)
		{
		//Just a random colour array pulled from https://www.google.com.au/search?q=%23FF0000
		
		case 0: Format(colourName, sizeof(colourName), "d7e8b7");
		case 1: Format(colourName, sizeof(colourName),  "ade544");
		case 2: Format(colourName, sizeof(colourName),  "59e543");
		case 3: Format(colourName, sizeof(colourName),  "21e05a");
		case 4: Format(colourName, sizeof(colourName),  "0fe2ae");
		case 5: Format(colourName, sizeof(colourName),  "20c3cc");
		case 6: Format(colourName, sizeof(colourName),  "20a6cc");
		case 7: Format(colourName, sizeof(colourName),  "2078cc");
		case 8: Format(colourName, sizeof(colourName),  "203ccc");
		case 9: Format(colourName, sizeof(colourName),  "3f20cc");
		case 10: Format(colourName, sizeof(colourName),  "6420cc");
		case 11: Format(colourName, sizeof(colourName),  "9520cc");
		case 12: Format(colourName, sizeof(colourName),  "c920cc");
		case 13: Format(colourName, sizeof(colourName),  "cc2087");
		case 14: Format(colourName, sizeof(colourName),  "cc205f");
		case 15: Format(colourName, sizeof(colourName),  "e05d00");
		}
		
		char szPB[64];
		char szSR[64];
		char szSpeed[64];
		char szAdvert[64];
		char szStage[64];
		char szTier[64];
		
		Format(szPB, 64, "<font color='#ffbb00'>PB:</font> %s", g_szLastPBDifference[client]);
		Format(szSR, 64, "%s", g_szLastSRDifference[client]);
		Format(szSpeed, 64, "Speed: <font color='#%s'>%i</font>", colourName, speed);
		Format(szAdvert, 64, "<font color='#45f74e'>%s</font>", g_szServerName);
		Format(szStage, 64, "<font color='#a8603c'>Stage:</font> %s", StageString);
		Format(szTier, 64, "%s", g_sJustTier);
		
		int dispVersion;
		
		switch(g_iAnimate)
			{
				case 0:dispVersion = 0;
				case 1:dispVersion = 1;
				case 2:dispVersion = 2;
			}
		switch(g_iAdvert)
			{
				case 0:Format(szAdvert, 64, "<font color='#45f74e'>%s</font>", g_szServerName);
				case 1:Format(szAdvert, 64, "<font color='#1c9ddd'>%s", g_szAdvert1);
				case 2:Format(szAdvert, 64, "<font color='#e814d9'>%s", g_szAdvert2);
				case 3:Format(szAdvert, 64, "<font color='#dda218'>Map: %s", g_szMapName);
			}

		if (IsValidEntity(client) && 1 <= client <= MaxClients && !g_bOverlay[client])
		{
			if (g_bTimeractivated[client])
			{
				if (g_bPause[client])
				{
					PrintHintText(client, "<font face=''>%s<font color='#FF0000'>Paused</font> %s\n<font color='#d639cb'>PB:<font color='#ffffff'> %s%s\nStage:%sSpeed: %i</font>", timerText, g_szLastSRDifference[client], g_szLastPBDifference[client], szRank, StageString, RoundToNearest(g_fLastSpeed[client]));
				}
				else
				{	
					
					//DEBUG					
					//PrintToConsole(client, "%s%s %s\nPB: %s%s\nStage: %sSpeed: <font color='#%s'>%i</font>", timerText, pAika, g_szLastSRDifference[client], g_szLastPBDifference[client], szRank, StageString, colourName, speed);
					PrintHintText(client, "<font face='' size='21'>%s%s %s\n<font color='#ffbb00'>PB:</font> %s%s\nStage: %s%s", timerText, pAika, g_szLastSRDifference[client], g_szLastPBDifference[client], szRank, StageString, szSpeed);
				}
			}
			else
				{
					if (!g_hCustomHud.BoolValue)
						PrintHintText(client, "<font face='' size='21'><font color='#FF0000'>Stopped</font>%s %s\n<font color='#ffbb00'>PB:</font> %s%s\nStage: %s%s", pAika, g_szLastSRDifference[client], g_szLastPBDifference[client], szRank, StageString, szSpeed);
					else
						{
						//SR Text: 
						//PB TEXT: szPB
						//RANK TEXT: szRank
						//SERVER TEXT: g_szServerName1..3
						//STAGE TEXT: szStage
						//MAP TEXT: szMapName
						//SPEED TEXT: szSpeed
						//TIER TEXT: szTier
					
						switch(dispVersion)
							{
								case 0: PrintHintText(client, "<font face=''size='21'>%s<font color='#FF0000'>Stopped</font>%s\n%s%s\n%s",timerText, szSR, szStage, szSpeed, szAdvert);
								case 1: PrintHintText(client, "<font face=''size='21'>%s<font color='#FF0000'>Stopped</font>\t\t%s\n%s\t\t%s\n%s",timerText, szPB, szTier, szSpeed, szAdvert);
								case 2: PrintHintText(client, "<font face=''size='21'>%s<font color='#FF0000'>Stopped</font>\t%s\n%s%s\n%s",timerText, szRank2, szStage, szSpeed, szAdvert);
							}	
						}
				}
		}
	}
}



public void Checkpoint(int client, int zone, int zonegroup)
{
	if (!IsValidClient(client) || g_bPositionRestored[client] || IsFakeClient(client) || zone >= CPLIMIT)
		return;

	float time = g_fCurrentRunTime[client];
	float percent = -1.0;
	int totalPoints = 0;
	char szPercnt[24];
	char szSpecMessage[512];

	if (g_bhasStages) // If staged map
		totalPoints = g_mapZonesTypeCount[zonegroup][3];
	else
		if (g_mapZonesTypeCount[zonegroup][4] > 0) // If Linear Map and checkpoints
		totalPoints = g_mapZonesTypeCount[zonegroup][4];

	// Count percent of completion
	percent = (float(zone + 1) / float(totalPoints + 1));
	percent = percent * 100.0;
	Format(szPercnt, 24, "%1.f%%", percent);

	if (g_bTimeractivated[client] && !g_bPracticeMode[client]) {
		if (g_fMaxPercCompleted[client] < 1.0) // First time a checkpoint is reached
			g_fMaxPercCompleted[client] = percent;
		else
			if (g_fMaxPercCompleted[client] < percent) // The furthest checkpoint reached
			g_fMaxPercCompleted[client] = percent;
	}

	g_fCheckpointTimesNew[zonegroup][client][zone] = time;

	// Server record difference
	char sz_srDiff[128];
	char sz_srDiff_colorless[128];

	if (g_bCheckpointRecordFound[zonegroup] && g_fCheckpointServerRecord[zonegroup][zone] > 0.1 && g_bTimeractivated[client])
	{
		float f_srDiff = (g_fCheckpointServerRecord[zonegroup][zone] - time);

		FormatTimeFloat(client, f_srDiff, 5, sz_srDiff, 128);

		if (f_srDiff > 0)
		{
			Format(sz_srDiff_colorless, 128, "-%s", sz_srDiff);
			Format(sz_srDiff, 128, " %c%cSR: %c-%s%c", YELLOW, PURPLE, GREEN, sz_srDiff, YELLOW);
			if (zonegroup > 0)
				Format(g_szLastSRDifference[client], 64, "SR: <font color='#99ff99'>%s</font>", sz_srDiff_colorless);
			else
				Format(g_szLastSRDifference[client], 64, "\t\tSR: <font color='#99ff99'>%s</font>", sz_srDiff_colorless);

		}
		else
		{
			Format(sz_srDiff_colorless, 128, "+%s", sz_srDiff);
			Format(sz_srDiff, 128, " %c%cSR: %c+%s%c", YELLOW, PURPLE, RED, sz_srDiff, YELLOW);
			if (zonegroup > 0)
				Format(g_szLastSRDifference[client], 64, "SR: <font color='#FF9999'>%s</font>", sz_srDiff_colorless);
			else
				Format(g_szLastSRDifference[client], 64, "\t\tSR: <font color='#FF9999'>%s</font>", sz_srDiff_colorless);
		}
		g_fLastDifferenceTime[client] = GetGameTime();
	}
	else
		Format(sz_srDiff, 128, "");

	// Get client name for spectators
	char szName[MAX_NAME_LENGTH];
	GetClientName(client, szName, MAX_NAME_LENGTH);

	// Has completed the map before
	if (g_bCheckpointsFound[zonegroup][client] && g_bTimeractivated[client] && !g_bPracticeMode[client] && g_fCheckpointTimesRecord[zonegroup][client][zone] > 0.1)
	{
		// Set percent of completion to assist
		if (CS_GetMVPCount(client) < 1)
			CS_SetClientAssists(client, RoundToFloor(g_fMaxPercCompleted[client]));
		else
			CS_SetClientAssists(client, 100);

		// Own record difference
		float diff = (g_fCheckpointTimesRecord[zonegroup][client][zone] - time);
		char szDiff[32];
		char szDiff_colorless[32];

		FormatTimeFloat(client, diff, 5, szDiff, 32);

		// MOVE TO PB variable
		if (diff > 0)
		{
			Format(szDiff_colorless, 32, "-%s", szDiff);
			Format(szDiff, sizeof(szDiff), " %c-%s", GREEN, szDiff);
			if (zonegroup > 0)
				Format(g_szLastPBDifference[client], 64, "<font color='#99ff99'>%s</font>\t", szDiff_colorless);
			else
				Format(g_szLastPBDifference[client], 64, "<font color='#99ff99'>%s</font>\t", szDiff_colorless);
		}
		else
		{
			Format(szDiff_colorless, 32, "+%s", szDiff);
			Format(szDiff, sizeof(szDiff), " %c+%s", RED, szDiff);
			if (zonegroup > 0)
				Format(g_szLastPBDifference[client], 64, "<font color='#FF9999'>%s</font>\t", szDiff_colorless);
			else
				Format(g_szLastPBDifference[client], 64, "<font color='#FF9999'>%s</font>\t", szDiff_colorless);
		}
		g_fLastDifferenceTime[client] = GetGameTime();

		if (g_fCheckpointTimesRecord[zonegroup][client][zone] <= 0.0)
			Format(szDiff, 128, "");

		// First checkpoint
		if (tmpDiff[client] == 9999.0)
		{
			//"#format"	"{1:c},{2:c},{3:c},{4:s},{5:c},{6:c},{7:s},{8:c}, {9:s}"
			//"en"		"[{1}CK{2}] {3}CP: {4} {5}compared to your best run. ({6}{7}{8}).{9}"
			if (g_bCheckpointsEnabled[client])
				PrintToChat(client, "%t", "Checkpoint1", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, szDiff, YELLOW, WHITE, szPercnt, YELLOW, sz_srDiff);
			Format(szSpecMessage, sizeof(szSpecMessage), "%t", "Checkpoint1-spec", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, szDiff, YELLOW, WHITE, szName, YELLOW, WHITE, szPercnt, YELLOW, sz_srDiff);
			CheckpointToSpec(client, szSpecMessage);
		}
		else
		{
			// Other checkpoints have catchup messages
			float catchUp = diff - tmpDiff[client];
			char szCatchUp[128];

			FormatTimeFloat(client, catchUp, 5, szCatchUp, 128);

			if (catchUp > 0)
				Format(szCatchUp, 128, " %c-%s", GREEN, szCatchUp);
			else
				Format(szCatchUp, 128, " %c+%s", RED, szCatchUp);

			// Formatting CatchUp message
			if (diff > 0) // If player is faster than his record
			{
				if (catchUp > 0) // If player grew lead from last checkpoint
					Format(szCatchUp, 128, "%t:%s", "GrewCheckpoint", szCatchUp);
				else // Player lost lead from last checkpoint
					Format(szCatchUp, 128, "%t:%s", "LostCheckpoint", szCatchUp);
			}
			else // If player is slower than his record
			{
				if (catchUp > 0) // Caught up players best time
					Format(szCatchUp, 128, "%t:%s", "CaughtCheckpoint", szCatchUp);
				else // Fell behind
					Format(szCatchUp, 128, "%t:%s", "FellCheckpoint", szCatchUp);
			}

			//"#format"	"{1:c},{2:c},{3:c},{4:s},{5:c},{6:s},{7:c},{8:c},{9:s},{10:c},{11:s}"
			//"en"		"[{1}CK{2}] {3}CP: {4} {5}compared to your PB. {6} {7}({8}{9}{10}).{11}"
			if (g_bCheckpointsEnabled[client])
				PrintToChat(client, "%t", "Checkpoint2", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, szDiff, YELLOW, szCatchUp, YELLOW, WHITE, szPercnt, YELLOW, sz_srDiff);
			Format(szSpecMessage, sizeof(szSpecMessage), "%t", "Checkpoint2-spec", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, szDiff, YELLOW, WHITE, szName, YELLOW, szCatchUp, YELLOW, WHITE, szPercnt, YELLOW, sz_srDiff);
			CheckpointToSpec(client, szSpecMessage);
		}
		// Saving difference time for next checkpoint
		tmpDiff[client] = diff;
	}
	else // if first run 
		if (g_bTimeractivated[client] && !g_bPracticeMode[client])
		{
			// Set percent of completion to assist
			if (CS_GetMVPCount(client) < 1)
				CS_SetClientAssists(client, RoundToFloor(g_fMaxPercCompleted[client]));
			else
				CS_SetClientAssists(client, 100);

			char szTime[32];
			FormatTimeFloat(client, time, 3, szTime, 32);

			// "#format" "{1:c},{2:c},{3:c},{4:c},{5:s},{6:c},{7:c},{8:s},{9:s}"
			// "en"		 "[{1}CK{2}]{3} CP: Completed{4} {5} {6}of the map in {7}{8}.{9}"
			if (percent > -1.0)
			{
				if (g_bCheckpointsEnabled[client])
					PrintToChat(client, "%t", "Checkpoint3", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, WHITE, szPercnt, YELLOW, WHITE, szTime, sz_srDiff);
				Format(szSpecMessage, sizeof(szSpecMessage), "%t", "Checkpoint3-spec", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, WHITE, szName, YELLOW, WHITE, szPercnt, YELLOW, WHITE, szTime, sz_srDiff);
				CheckpointToSpec(client, szSpecMessage);
			}
		}
		else
		{
			if (g_bCheckpointsEnabled[client])
				PrintToChat(client, "%t", "Checkpoint4", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, WHITE, (1 + zone));
			Format(szSpecMessage, sizeof(szSpecMessage), "%t", "Checkpoint4-spec", MOSSGREEN, g_szChatPrefix, WHITE, YELLOW, WHITE, szName, YELLOW, WHITE, (1 + zone));
			CheckpointToSpec(client, szSpecMessage);
		}
}

public void CheckpointToSpec(int client, char[] buffer)
{
	int SpecMode;
	for (int x = 1; x <= MaxClients; x++)
	{
		if (IsValidClient(x) && !IsPlayerAlive(x))
		{
			SpecMode = GetEntProp(x, Prop_Send, "m_iObserverMode");
			if (SpecMode == 4 || SpecMode == 5)
			{
				int Target = GetEntPropEnt(x, Prop_Send, "m_hObserverTarget");
				if (Target == client)
					PrintToChat(x, "%s", buffer);
			}
		}
	}
}

void resetZone(int zoneIndex)
{
	g_mapZones[zoneIndex][zoneId] = -1;
	g_mapZones[zoneIndex][PointA] = -1.0;
	g_mapZones[zoneIndex][PointB] = -1.0;
	g_mapZones[zoneIndex][zoneType] = -1;
	g_mapZones[zoneIndex][zoneTypeId] = -1;
	g_mapZones[zoneIndex][zoneName] = 0;
	g_mapZones[zoneIndex][Vis] = 0;
	g_mapZones[zoneIndex][Team] = 0;
	g_mapZones[zoneIndex][zoneGroup] = 0;
}

void SetPlayerVisible(int client)
{
	int iAlpha = GetConVarInt(g_hCvarPlayerOpacity);
	SetEntityOpacity(client, iAlpha);

	// Render weapons opaque too.
	int iWeapon = -1, iIndex;
	while((iWeapon = Client_GetNextWeapon(client, iIndex)) != -1)
		SetEntityOpacity(iWeapon, iAlpha);
}

void SetPlayerInvisible(int client)
{
	SetEntityRenderMode(client, RENDER_NONE);
}

void SetEntityOpacity(int ent, int iAlpha)
{
	if (iAlpha == 255)
	{
		SetEntityRenderMode(ent, RENDER_NORMAL);
	}
	// else if (iAlpha == 0)
	// {
	// 	SetEntityRenderMode(ent, RENDER_NONE);
	// }
	else
	{
		SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
		Entity_SetRenderColor(ent, -1, -1, -1, iAlpha);
	}
}

void debug_msg(char[] msg)
{
if(g_hDebugMode.BoolValue)
	LogMessage(msg);
}
