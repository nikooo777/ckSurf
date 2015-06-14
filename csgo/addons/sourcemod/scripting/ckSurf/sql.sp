/////////////////////////
// PREPARED STATEMENTS //
////////////////////////

//TABLE CHALLENGE
new String:sql_createChallenges[] 				= "CREATE TABLE IF NOT EXISTS challenges (steamid VARCHAR(32), steamid2 VARCHAR(32), bet INT(12), map VARCHAR(32), date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(steamid,steamid2,date));";
new String:sql_insertChallenges[] 				= "INSERT INTO challenges (steamid, steamid2, bet, map) VALUES('%s', '%s','%i','%s');";
new String:sql_selectChallenges2[] 				= "SELECT steamid, steamid2, bet, map, date FROM challenges where steamid = '%s' OR steamid2 ='%s' ORDER BY date DESC";
new String:sql_selectChallenges[] 				= "SELECT steamid, steamid2, bet, map FROM challenges where steamid = '%s' OR steamid2 ='%s'";
new String:sql_selectChallengesCompare[] 		= "SELECT steamid, steamid2, bet FROM challenges where (steamid = '%s' AND steamid2 ='%s') OR (steamid = '%s' AND steamid2 ='%s')";
new String:sql_deleteChallenges[] 				= "DELETE from challenges where steamid = '%s'";

//TABLE ZONES
new String:sql_createZones[]					= "CREATE TABLE IF NOT EXISTS zones (mapname VARCHAR(54) NOT NULL, zoneid INT(12) DEFAULT '-1', zonetype INT(12) DEFAULT '-1', zonetypeid INT(12) DEFAULT '-1', pointa_x FLOAT DEFAULT '-1.0', pointa_y FLOAT DEFAULT '-1.0', pointa_z FLOAT DEFAULT '-1.0', pointb_x FLOAT DEFAULT '-1.0', pointb_y FLOAT DEFAULT '-1.0', pointb_z FLOAT DEFAULT '-1.0', vis INT(12) DEFAULT '0', team INT(12) DEFAULT '0', PRIMARY KEY(mapname, zoneid));";
new String:sql_insertZones[]					= "INSERT INTO zones (mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team) VALUES ('%s', '%i', '%i', '%i', '%f', '%f', '%f', '%f', '%f', '%f', '%i', '%i')";
new String:sql_updateZone[]						= "UPDATE zones SET zonetype = '%i', zonetypeid = '%i', pointa_x = '%f', pointa_y ='%f', pointa_z = '%f', pointb_x = '%f', pointb_y = '%f', pointb_z = '%f', vis = '%i', team = '%i'  WHERE zoneid = '%i' AND mapname = '%s'";
new String:sql_selectzoneTypeIds[]				= "SELECT zonetypeid FROM zones WHERE mapname='%s' AND zonetype='%i'";
new String:sql_selectMapZones[]					= "SELECT * FROM zones WHERE mapname = '%s' ORDER BY zonetypeid ASC";
new String:sql_selectTotalBonusCount[]			= "SELECT * FROM zones WHERE zoneType = 3 GROUP BY mapname;";
new String:sql_deleteMapZones[]					= "DELETE FROM zones WHERE mapname = '%s'";
new String:sql_deleteZone[]						= "DELETE FROM zones WHERE mapname = '%s' AND zoneid = '%i'";
new String:sql_deleteAllZones[]					= "DELETE FROM zones";

//TABLE MAPTIER
new String:sql_createMapTier[]					= "CREATE TABLE IF NOT EXISTS maptier (mapname VARCHAR(54) NOT NULL, tier INT(12) NOT NULL, PRIMARY KEY(mapname));";
new String:sql_selectMapTier[]					= "SELECT * FROM maptier WHERE mapname = '%s'";
new String:sql_deleteAllMapTiers[]				= "DELETE FROM maptier";

//TABLE BONUS
new String:sql_createBonus[]					= "CREATE TABLE IF NOT EXISTS bonus (steamid VARCHAR(32), name VARCHAR(32), mapname VARCHAR(32), runtime FLOAT NOT NULL DEFAULT '-1.0', PRIMARY KEY(steamid, mapname));";
new String:sql_insertBonus[]					= "INSERT INTO bonus (steamid, name, mapname, runtime) VALUES ('%s', '%s', '%s', '%f')";	
new String:sql_updateBonus[]					= "UPDATE bonus SET runtime = '%f', name = '%s' WHERE steamid = '%s' AND mapname = '%s'";
new String:sql_selectBonusCount[]				= "SELECT count(*) FROM bonus WHERE mapname = '%s'";
new String:sql_selectPersonalBonusRecords[] 	= "SELECT runtime FROM bonus WHERE steamid = '%s' AND mapname = '%s' AND runtime > '0.0'"; 
new String:sql_selectPlayerRankBonus[] 			= "SELECT count(*) FROM bonus WHERE runtime <= (SELECT runtime FROM bonus WHERE steamid = '%s' AND mapname= '%s' AND runtime > 0.0) AND mapname = '%s'";
new String:sql_selectFastestBonus[]				= "SELECT MIN(runtime), name FROM bonus WHERE mapname = '%s'";
new String:sql_selectPersonalBonusCompleted[]	= "SELECT count(*) FROM bonus WHERE steamid = '%s'";
new String:sql_deleteBonus[]					= "DELETE FROM bonus WHERE mapname = '%s'";

//TABLE CHECKPOINTS
new String:sql_createCheckpoints[] 				= "CREATE TABLE IF NOT EXISTS checkpoints (steamid VARCHAR(32), mapname VARCHAR(32), cp1 FLOAT DEFAULT '0.0', cp2 FLOAT DEFAULT '0.0', cp3 FLOAT DEFAULT '0.0', cp4 FLOAT DEFAULT '0.0', cp5 FLOAT DEFAULT '0.0', cp6 FLOAT DEFAULT '0.0', cp7 FLOAT DEFAULT '0.0', cp8 FLOAT DEFAULT '0.0', cp9 FLOAT DEFAULT '0.0', cp10 FLOAT DEFAULT '0.0', cp11 FLOAT DEFAULT '0.0', cp12 FLOAT DEFAULT '0.0', cp13 FLOAT DEFAULT '0.0', cp14 FLOAT DEFAULT '0.0', cp15 FLOAT DEFAULT '0.0', cp16 FLOAT DEFAULT '0.0', cp17  FLOAT DEFAULT '0.0', cp18 FLOAT DEFAULT '0.0', cp19 FLOAT DEFAULT '0.0', cp20  FLOAT DEFAULT '0.0', PRIMARY KEY(steamid, mapname));";
new String:sql_updateCheckpoints[] 				= "UPDATE checkpoints SET cp1='%f', cp2='%f', cp3='%f', cp4='%f', cp5='%f', cp6='%f', cp7='%f', cp8='%f', cp9='%f', cp10='%f', cp11='%f', cp12='%f', cp13='%f', cp14='%f', cp15='%f', cp16='%f', cp17='%f', cp18='%f', cp19='%f', cp20='%f' WHERE steamid='%s' AND mapname='%s'";
new String:sql_insertCheckpoints[] 				= "INSERT INTO checkpoints VALUES ('%s', '%s', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f')";
new String:sql_selectCheckpoints[] 				= "SELECT * FROM checkpoints WHERE steamid='%s' AND mapname='%s'";
new String:sql_deleteCheckpoints[]				= "DELETE FROM checkpoints WHERE mapname = '%s'";

//TABLE LATEST 15 LOCAL RECORDS
new String:sql_createLatestRecords[] 			= "CREATE TABLE IF NOT EXISTS LatestRecords (steamid VARCHAR(32), name VARCHAR(32), runtime FLOAT NOT NULL DEFAULT '-1.0', map VARCHAR(32), date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(steamid,map,date));";
new String:sql_insertLatestRecords[] 			= "INSERT INTO LatestRecords (steamid, name, runtime, map) VALUES('%s','%s','%f','%s');";
new String:sql_selectLatestRecords[] 			= "SELECT name, runtime, teleports, map, date FROM LatestRecords ORDER BY date DESC LIMIT 50";

//TABLE PLAYEROPTIONS
new String:sql_createPlayerOptions[] 			= "CREATE TABLE IF NOT EXISTS playeroptions2 (steamid VARCHAR(32), speedmeter INT(12) DEFAULT '0', quake_sounds INT(12) DEFAULT '1', autobhop INT(12) DEFAULT '0', shownames INT(12) DEFAULT '1', goto INT(12) DEFAULT '1', showtime INT(12) DEFAULT '1', hideplayers INT(12) DEFAULT '0', showspecs INT(12) DEFAULT '1', knife VARCHAR(32) DEFAULT 'weapon_knife', new1 INT(12) DEFAULT '0', new2 INT(12) DEFAULT '0', new3 INT(12) DEFAULT '0', PRIMARY KEY(steamid));";
new String:sql_insertPlayerOptions[] 			= "INSERT INTO playeroptions2 (steamid, speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3) VALUES('%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%s', '%i', '%i', '%i');";
new String:sql_selectPlayerOptions[] 			= "SELECT speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3 FROM playeroptions2 where steamid = '%s'";
new String:sql_updatePlayerOptions[]			= "UPDATE playeroptions2 SET speedmeter ='%i', quake_sounds ='%i', autobhop ='%i', shownames ='%i', goto ='%i', showtime ='%i', hideplayers ='%i', showspecs ='%i', knife ='%s', new1 = '%i', new2 = '%i', new3 = '%i' where steamid = '%s'";

//TABLE PLAYERRANK
new String:sql_createPlayerRank[]				= "CREATE TABLE IF NOT EXISTS playerrank (steamid VARCHAR(32), name VARCHAR(32), country VARCHAR(32), points INT(12)  DEFAULT '0', winratio INT(12)  DEFAULT '0', pointsratio INT(12)  DEFAULT '0',finishedmaps INT(12) DEFAULT '0', multiplier INT(12) DEFAULT '0', finishedmapspro INT(12) DEFAULT '0', PRIMARY KEY(steamid));";
new String:sql_insertPlayerRank[] 				= "INSERT INTO playerrank (steamid, name, country) VALUES('%s', '%s', '%s');";
new String:sql_updatePlayerRankPoints[]			= "UPDATE playerrank SET name ='%s', points ='%i', finishedmapspro='%i',winratio = '%i',pointsratio = '%i' where steamid='%s'";
new String:sql_updatePlayerRankPoints2[]		= "UPDATE playerrank SET name ='%s', points ='%i', finishedmapspro='%i',winratio = '%i',pointsratio = '%i', country ='%s' where steamid='%s'";
new String:sql_updatePlayerRank[]				= "UPDATE playerrank SET finishedmaps ='%i', finishedmapspro='%i', multiplier ='%i'  where steamid='%s'";
new String:sql_selectPlayerRankAll[] 			= "SELECT name, steamid FROM playerrank where name like '%c%s%c'";
new String:sql_selectPlayerRankAll2[] 			= "SELECT name, steamid FROM playerrank where name = '%s'";
new String:sql_selectPlayerName[] 				= "SELECT name FROM playerrank where steamid = '%s'";
new String:sql_UpdateLastSeenMySQL[]			= "UPDATE playerrank SET lastseen = NOW() where steamid = '%s';";
new String:sql_UpdateLastSeenSQLite[]			= "UPDATE playerrank SET lastseen = date('now') where steamid = '%s';";
new String:sql_selectTopPlayers[]				= "SELECT name, points, finishedmapspro, steamid FROM playerrank ORDER BY points DESC LIMIT 100";
new String:sql_selectTopChallengers[]			= "SELECT name, winratio, pointsratio, steamid FROM playerrank ORDER BY pointsratio DESC LIMIT 5";
new String:sql_selectRankedPlayer[]				= "SELECT steamid, name, points, finishedmapspro, multiplier, country, lastseen from playerrank where steamid='%s'";
new String:sql_selectRankedPlayersRank[]		= "SELECT name FROM playerrank WHERE points >= (SELECT points FROM playerrank WHERE steamid = '%s') ORDER BY points";
new String:sql_selectRankedPlayers[]			= "SELECT steamid, name from playerrank where points > 0 ORDER BY points DESC";
new String:sql_CountRankedPlayers[] 			= "SELECT COUNT(steamid) FROM playerrank";
new String:sql_CountRankedPlayers2[] 			= "SELECT COUNT(steamid) FROM playerrank where points > 0";

//TABLE PLAYERTIMES
new String:sql_createPlayertimes[] 				= "CREATE TABLE IF NOT EXISTS playertimes (steamid VARCHAR(32), mapname VARCHAR(32), name VARCHAR(32), runtimepro FLOAT NOT NULL DEFAULT '-1.0', PRIMARY KEY(steamid,mapname));";
new String:sql_insertPlayer[] 					= "INSERT INTO playertimes (steamid, mapname, name) VALUES('%s', '%s', '%s');";
new String:sql_insertPlayerTime[] 				= "INSERT INTO playertimes (steamid, mapname, name,runtimepro) VALUES('%s', '%s', '%s', '%f');";
new String:sql_updateRecordPro[]				= "UPDATE playertimes SET name = '%s', runtimepro = '%f' WHERE steamid = '%s' AND mapname = '%s';"; 
new String:sql_CountFinishedMaps[] 				= "SELECT mapname FROM playertimes where steamid='%s' AND runtimepro > -1.0";
new String:sql_selectPlayer[] 					= "SELECT steamid FROM playertimes WHERE steamid = '%s' AND mapname = '%s';";
new String:sql_selectMapRecord[] 				= "SELECT mapname, steamid, name, runtimepro FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0;";
new String:sql_selectRecord[] 					= "SELECT steamid, runtimepro FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro  > -1.0";
new String:sql_selectMapRecordPro[] 			= "SELECT db2.runtimepro, db1.name, db1.steamid, db2.steamid FROM playertimes as db2 INNER JOIN playerrank as db1 on db1.steamid = db2.steamid WHERE db2.mapname = '%s' AND db2.runtimepro  > -1.0 ORDER BY db2.runtimepro ASC LIMIT 1"; 
new String:sql_selectPersonalRecords[] 			= "SELECT db2.mapname, db2.steamid, db1.name, db2.runtimepro, db1.steamid  FROM playertimes as db2 INNER JOIN playerrank as db1 on db1.steamid = db2.steamid WHERE db2.steamid = '%s' AND db2.mapname = '%s' AND db2.runtimepro > 0.0"; 
new String:sql_selectPersonalAllRecords[] 		= "SELECT db1.name, db2.steamid, db2.mapname, db2.runtimepro as overall, db1.steamid FROM playertimes as db2 INNER JOIN playerrank as db1 on db2.steamid = db1.steamid WHERE db2.steamid = '%s' AND db2.runtimepro > -1.0 ORDER BY mapname ASC;";
new String:sql_selectProClimbers[] 				= "SELECT db1.name, db2.runtimepro, db2.steamid, db1.steamid FROM playertimes as db2 INNER JOIN playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname = '%s' AND db2.runtimepro > -1.0 ORDER BY db2.runtimepro ASC LIMIT 20";
new String:sql_selectTopClimbers2[] 			= "SELECT db2.steamid, db1.name, db2.runtimepro as overall, db1.steamid, db2.mapname FROM playertimes as db2 INNER JOIN playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname LIKE '%c%s%c' AND db2.runtimepro > -1.0 ORDER BY overall ASC LIMIT 100;";
new String:sql_selectTopClimbers[] 				= "SELECT db2.steamid, db1.name, db2.runtimepro as overall, db1.steamid, db2.mapname FROM playertimes as db2 INNER JOIN playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname = '%s' AND db2.runtimepro > -1.0 ORDER BY overall ASC LIMIT 100;";
new String:sql_selectPlayerProCount[] 			= "SELECT name FROM playertimes WHERE mapname = '%s' AND runtimepro  > -1.0;";
new String:sql_selectPlayerRankProTime[] 		= "SELECT name,mapname FROM playertimes WHERE runtimepro <= (SELECT runtimepro FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";
new String:sql_selectMapRecordHolders[] 		= "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM playertimes s INNER JOIN (SELECT mapname, MIN(runtimepro) AS runtimepro FROM playertimes where runtimepro > -1.0 GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtimepro = x.runtimepro) y GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid LIMIT 5;";
new String:sql_selectMapRecordCount[] 			= "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM playertimes s INNER JOIN (SELECT mapname, MIN(runtimepro) AS runtimepro FROM playertimes where runtimepro > -1.0  GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtimepro = x.runtimepro) y where y.steamid = '%s' GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid;";

//TABLE PLAYERTMP
new String:sql_createPlayertmp[] 				= "CREATE TABLE IF NOT EXISTS playertmp (steamid VARCHAR(32), mapname VARCHAR(32), cords1 FLOAT NOT NULL DEFAULT '-1.0', cords2 FLOAT NOT NULL DEFAULT '-1.0', cords3 FLOAT NOT NULL DEFAULT '-1.0', angle1 FLOAT NOT NULL DEFAULT '-1.0',angle2 FLOAT NOT NULL DEFAULT '-1.0',angle3 FLOAT NOT NULL DEFAULT '-1.0', EncTickrate INT(12) DEFAULT '-1.0', runtimeTmp FLOAT NOT NULL DEFAULT '-1.0', PRIMARY KEY(steamid,mapname));";
new String:sql_insertPlayerTmp[]  				= "INSERT INTO playertmp (cords1, cords2, cords3, angle1,angle2,angle3,runtimeTmp,steamid,mapname,EncTickrate,BonusTimer,Stage) VALUES ('%f','%f','%f','%f','%f','%f','%f','%s', '%s', '%i', %i, %i);";
new String:sql_updatePlayerTmp[] 				= "UPDATE playertmp SET cords1 = '%f', cords2 = '%f', cords3 = '%f', angle1 = '%f', angle2 = '%f', angle3 = '%f', runtimeTmp = '%f', mapname ='%s', EncTickrate='%i', BonusTimer = %i, Stage = %i where steamid = '%s';";
new String:sql_deletePlayerTmp[] 				= "DELETE FROM playertmp where steamid = '%s';";
new String:sql_selectPlayerTmp[] 				= "SELECT cords1,cords2,cords3, angle1, angle2, angle3,runtimeTmp, EncTickrate, BonusTimer, Stage FROM playertmp WHERE steamid = '%s' AND mapname = '%s';";

// TABLE MAP BUTTONS
new String:sql_createMapButtons[] 				= "CREATE TABLE IF NOT EXISTS MapButtons (mapname VARCHAR(32), cords1Start FLOAT NOT NULL DEFAULT '-1.0', cords2Start FLOAT NOT NULL DEFAULT '-1.0', cords3Start FLOAT NOT NULL DEFAULT '-1.0', cords1End FLOAT NOT NULL DEFAULT '-1.0', cords2End FLOAT NOT NULL DEFAULT '-1.0', cords3End FLOAT NOT NULL DEFAULT '-1.0', ang_start FLOAT NOT NULL DEFAULT '-1.0', ang_end FLOAT NOT NULL DEFAULT '-1.0', PRIMARY KEY(mapname));";
new String:sql_deleteMapButtons[] 				= "DELETE FROM MapButtons where mapname= '%s';";
new String:sql_insertMapButtons[] 				= "INSERT INTO MapButtons (mapname, cords1Start, cords2Start,cords3Start,cords1End,cords2End,cords3End,ang_start,ang_end) VALUES('%s', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f');";
new String:sql_selectMapButtons[] 				= "SELECT cords1Start,cords2Start,cords3Start,cords1End,cords2End,cords3End,ang_start,ang_end FROM MapButtons WHERE mapname = '%s';";
new String:sql_updateMapButtonsStart[] 			= "UPDATE MapButtons SET cords1Start ='%f', cords2Start ='%f', cords3Start ='%f', ang_start = '%f' WHERE mapname = '%s';";
new String:sql_updateMapButtonsEnd[]			= "UPDATE MapButtons SET cords1End ='%f', cords2End ='%f', cords3End ='%f', ang_end = '%f' WHERE mapname = '%s';";

// ADMIN 
new String:sqlite_dropMap[] 					= "DROP TABLE MapButtons; VACCUM";
new String:sql_dropMap[] 						= "DROP TABLE MapButtons;";
new String:sqlite_dropChallenges[] 				= "DROP TABLE challenges; VACCUM";
new String:sql_dropChallenges[] 				= "DROP TABLE challenges;";
new String:sqlite_dropPlayer[] 					= "DROP TABLE playertimes; VACCUM";
new String:sql_dropPlayer[] 					= "DROP TABLE playertimes;";
new String:sql_dropPlayerRank[] 				= "DROP TABLE playerrank;";
new String:sqlite_dropPlayerRank[] 				= "DROP TABLE playerrank; VACCUM";
new String:sql_resetRecords[] 					= "DELETE FROM playertimes WHERE steamid = '%s'";
new String:sql_resetRecords2[] 					= "DELETE FROM playertimes WHERE steamid = '%s' AND mapname LIKE '%s';";
new String:sql_resetRecordPro[] 				= "UPDATE playertimes SET runtimepro = '-1.0' WHERE steamid = '%s' AND mapname LIKE '%s';";
new String:sql_resetMapRecords[] 				= "DELETE FROM playertimes WHERE mapname = '%s'";






////////////////////////
//// DATABASE SETUP/////
////////////////////////

public db_setupDatabase()
{
	decl String:szError[255];
	g_hDb = SQL_Connect("cksurf", false, szError, 255);
        
	if(g_hDb == INVALID_HANDLE)
	{
		SetFailState("[ckSurf] Unable to connect to database (%s)",szError);
		return;
	}
        
	decl String:szIdent[8];
	SQL_ReadDriver(g_hDb, szIdent, 8);
        
	if(strcmp(szIdent, "mysql", false) == 0)
	{
		g_DbType = MYSQL;
	}
	else 
		if(strcmp(szIdent, "sqlite", false) == 0)
			g_DbType = SQLITE;
		else
		{
			LogError("[ckSurf] Invalid Database-Type");
			return;
		}
		
	SQL_FastQuery(g_hDb,"SET NAMES  'utf8'");
	db_createTables();
	
}

public db_createTables()
{
	SQL_LockDatabase(g_hDb);        
	SQL_FastQuery(g_hDb, sql_createPlayertmp);
	SQL_FastQuery(g_hDb, sql_createPlayertimes);
	SQL_FastQuery(g_hDb, sql_createPlayerRank);
	SQL_FastQuery(g_hDb, sql_createChallenges);
	SQL_FastQuery(g_hDb, sql_createMapButtons);
	SQL_FastQuery(g_hDb, sql_createPlayerOptions);
	SQL_FastQuery(g_hDb, sql_createLatestRecords);
	SQL_FastQuery(g_hDb, sql_createBonus);
	SQL_FastQuery(g_hDb, sql_createCheckpoints);
	SQL_FastQuery(g_hDb, sql_createZones);
	SQL_FastQuery(g_hDb, sql_createMapTier);
	SQL_FastQuery(g_hDb, "ALTER TABLE playerrank ADD lastseen DATE"); //added in 1.54
	SQL_FastQuery(g_hDb, "ALTER TABLE playertmp ADD EncTickrate INT");	//added in 1.55
	SQL_FastQuery(g_hDb, "ALTER TABLE playertmp ADD BonusTimer INT"); //Bonus
	SQL_FastQuery(g_hDb, "ALTER TABLE playertmp ADD Stage INT"); // Stage

	// Remove unused columns, if coming from KZTimer
	SQL_FastQuery(g_hDb, "ALTER TABLE challenges DROP COLUMN cp_allowed");
	SQL_FastQuery(g_hDb, "ALTER TABLE latestrecords DROP COLUMN teleports");
	SQL_FastQuery(g_hDb, "ALTER TABLE playeroptions2 DROP COLUMN colorchat");
	SQL_FastQuery(g_hDb, "ALTER TABLE playeroptions2 DROP COLUMN climbersmenu_sounds");
	SQL_FastQuery(g_hDb, "ALTER TABLE playeroptions2 DROP COLUMN strafesync");
	SQL_FastQuery(g_hDb, "ALTER TABLE playeroptions2 DROP COLUMN cpmessage");
	SQL_FastQuery(g_hDb, "ALTER TABLE playeroptions2 DROP COLUMN adv_menu");
	SQL_FastQuery(g_hDb, "ALTER TABLE playeroptions2 DROP COLUMN jumppenalty");
	SQL_FastQuery(g_hDb, "ALTER TABLE playerrank DROP COLUMN finishedmapstp");
	SQL_FastQuery(g_hDb, "ALTER TABLE playertimes DROP COLUMN teleports");
	SQL_FastQuery(g_hDb, "ALTER TABLE playertimes DROP COLUMN runtime");
	SQL_FastQuery(g_hDb, "ALTER TABLE playertimes DROP COLUMN teleports_pro");
	SQL_FastQuery(g_hDb, "ALTER TABLE playertmp DROP COLUMN teleports");
	SQL_FastQuery(g_hDb, "ALTER TABLE playertmp DROP COLUMN	checkpoints");
	SQL_FastQuery(g_hDb, "ALTER TABLE LatestRecords DROP COLUMN	teleports");

	SQL_FastQuery(g_hDb, "DROP TABLE playerjumpstats3");

	SQL_UnlockDatabase(g_hDb);
}




/////////////////////
//// PLAYER RANK ////
/////////////////////


public db_viewMapRankProCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;  
	g_OldMapRank[client] = g_MapRank[client];
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl)){
		g_MapRank[client] = SQL_GetRowCount(hndl); 
	}
	if (g_bMapRankToChat[client]){
		MapFinishedMsgs(client, 1);		
	}
}

public db_viewMapProRankCount()
{
	decl String:szQuery[512];
	Format(szQuery, 512, sql_selectPlayerProCount, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectPlayerProCountCallback, szQuery,DBPrio_Low);
}
public sql_selectPlayerProCountCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_MapTimesCount = SQL_GetRowCount(hndl);
	else
		g_MapTimesCount = 0;
}

public db_viewMapRankPro(client)
{
	decl String:szQuery[512];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 512, sql_selectPlayerRankProTime, g_szSteamID[client], g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, db_viewMapRankProCallback, szQuery, client,DBPrio_Low);
}

public db_updateStat(client) 
{
	decl String:szQuery[512];
	Format(szQuery, 512, sql_updatePlayerRank, g_pr_finishedmaps[client], g_pr_finishedmaps[client],g_pr_multiplier[client],g_szSteamID[client]);
	SQL_TQuery(g_hDb, SQL_UpdateStatCallback, szQuery, client, DBPrio_Low);
	
}

public SQL_UpdateStatCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	CalculatePlayerRank(client);
}


public sql_updatePlayerRankPointsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if (client>MAXPLAYERS &&  g_pr_RankingRecalc_InProgress  || client>MAXPLAYERS && g_bProfileRecalc[client])
	{		
		if (g_bProfileRecalc[client] && !g_pr_RankingRecalc_InProgress)
		{
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i))
				{
					if(StrEqual(g_szSteamID[i],g_pr_szSteamID[client]))
						CalculatePlayerRank(i);
				}
			}
		}
		g_bProfileRecalc[client] = false;
		if (g_pr_RankingRecalc_InProgress)
		{
			//console info
			if (IsValidClient(g_pr_Recalc_AdminID) && g_bManualRecalc)
				PrintToConsole(g_pr_Recalc_AdminID, "%i/%i",g_pr_Recalc_ClientID,g_pr_TableRowCount); 
			new x = 66+g_pr_Recalc_ClientID;
			if(StrContains(g_pr_szSteamID[x],"STEAM",false)!=-1)  
			{
				ContinueRecalc(x);
			}
			else
			{
				for (new i = 1; i <= MaxClients; i++)
				if (1 <= i <= MaxClients && IsValidEntity(i) && IsValidClient(i))
				{
					if (g_bManualRecalc)
						PrintToChat(i, "%t", "PrUpdateFinished", MOSSGREEN, WHITE, LIMEGREEN);
					if (g_bTop100Refresh)
						PrintToChat(i, "%t", "Top100Refreshed", MOSSGREEN, WHITE, LIMEGREEN);
				}
				g_bTop100Refresh = false;
				g_bManualRecalc = false;
				g_pr_RankingRecalc_InProgress = false;
				
				if (IsValidClient(g_pr_Recalc_AdminID))
					CreateTimer(0.1, RefreshAdminMenu, g_pr_Recalc_AdminID,TIMER_FLAG_NO_MAPCHANGE);
			}		
			g_pr_Recalc_ClientID++;		
		}		
	}
	else
	{
		if(g_pr_showmsg[client] == true){
		}
		else {
		}
		
		g_pr_Calculating[client] = false;
		if (g_bRecalcRankInProgess[client] && client <= MAXPLAYERS)
		{
			ProfileMenu(client, -1);
			if (IsValidClient(client))
				PrintToChat(client, "%t", "Rc_PlayerRankFinished", MOSSGREEN,WHITE,GRAY,PURPLE,g_pr_points[client],GRAY);	
			g_bRecalcRankInProgess[client]=false;
		}
		if (IsValidClient(client) && g_pr_showmsg[client])
		{	
			decl String:szName[MAX_NAME_LENGTH];	
			GetClientName(client, szName, MAX_NAME_LENGTH);	
			new diff = g_pr_points[client] - g_pr_oldpoints[client];	
			if (diff > 0)
			{
				for (new i = 1; i <= MaxClients; i++)
					if (IsValidClient(i))
						PrintToChat(i, "%t", "EarnedPoints", MOSSGREEN, WHITE, PURPLE,szName, GRAY, PURPLE, diff,GRAY,PURPLE, g_pr_points[client], GRAY);
			}
			g_pr_showmsg[client]=false;
			db_CalculatePlayersCountGreater0();
		}	
		db_GetPlayerRank(client);
		CreateTimer(1.0, SetClanTag, client,TIMER_FLAG_NO_MAPCHANGE);			
	}
}

public sql_CountFinishedMapsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl String:szQuery[1024];   
	decl String:szSteamId[32];
	decl String:MapName[128];
	decl String:MapName2[128];
	new finished_Pro=0;
	
	if (client>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else
	{
		if (IsValidClient(client))
			GetClientAuthString(client, szSteamId, 32);
		else
			return;
	}

	if(SQL_HasResultSet(hndl))
	{	
		while (SQL_FetchRow(hndl))
		{
			//"SELECT mapname FROM playertimes where steamid='%s' AND runtimepro > -1.0";

			SQL_FetchString(hndl, 0, MapName, 128);	
			for (new i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, MapName2, sizeof(MapName2));
				if (StrEqual(MapName2, MapName, false))
				{
					finished_Pro++;
					continue;
				}
			}			
		}

		g_pr_finishedmaps[client]=finished_Pro;
		g_pr_finishedmaps_perc[client]= (float(finished_Pro) / float(g_pr_MapCount)) * 100.0;	
		g_pr_points[client]+= (finished_Pro * g_ExtraPoints2 * 2);

		Format(szQuery, 1024, sql_selectPersonalAllRecords, szSteamId, szSteamId);  
		if ((StrContains(szSteamId, "STEAM_") != -1))
			SQL_TQuery(g_hDb, sql_selectPersonalAllRecordsCallback, szQuery, client, DBPrio_Low);			
	}	
}

public sql_selectPersonalAllRecordsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	decl String:szQuery[1024];  
	new client = data;
	decl String:szSteamId[32];
	if (client>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else
	{
		if (IsValidClient(client))
			GetClientAuthString(client, szSteamId, 32);
		else
			return;
	}
	decl String:szMapName[128];
	if(SQL_HasResultSet(hndl))
	{	
		g_pr_maprecords_row_counter[client]=0;
		g_pr_maprecords_row_count[client] = SQL_GetRowCount(hndl);
		while (SQL_FetchRow(hndl))
		{		
			// "SELECT db1.name, db2.steamid, db2.mapname, db2.runtimepro as overall, db1.steamid FROM playertimes as db2 INNER JOIN playerrank as db1 on db2.steamid = db1.steamid WHERE db2.steamid = '%s' AND db2.runtimepro > -1.0 ORDER BY mapname ASC;";

			SQL_FetchString(hndl, 2, szMapName, 128);			
			Format(szQuery, 1024, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
			SQL_TQuery(g_hDb, sql_selectPlayerRankCallback, szQuery, client, DBPrio_Low);								
		}	
	}
	if (g_pr_maprecords_row_count[client]==0)
	{
		db_updatePoints(client);		
	}	
}

public 	sql_selectPlayerRankCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	decl String:szMapName[128];
	new client = data;
	decl String:szQuery[255];  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		//"SELECT name,mapname FROM playertimes WHERE runtimepro <= (SELECT runtimepro FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";

		SQL_FetchString(hndl, 1, szMapName, 128);	
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackCell(pack, rank);
		WritePackString(pack, szMapName);
		Format(szQuery, 255, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, sql_selectPlayerRankCallback2, szQuery, pack, DBPrio_Low);
	}
}

public sql_selectPlayerRankCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new Handle:pack = data;
	ResetPack(pack);
	new client = ReadPackCell(pack);
	new rank = ReadPackCell(pack);
	decl String:szMap[64];
	ReadPackString(pack, szMap, 64);	
	CloseHandle(pack);
	decl String:szMapName2[128];

	if (hndl == INVALID_HANDLE)
		return;

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new count = SQL_GetRowCount(hndl);
		for (new i = 0; i < GetArraySize(g_MapList); i++)
		{
			GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));	
			if (StrEqual(szMapName2, szMap, false))
			{
				new Float: percentage = 1.0+(1.0/float (count)) - (float (rank) / float (count));
				g_pr_points[client]+= RoundToCeil(200.0 * percentage);					
				switch(rank) 
				{
					case 1: g_pr_points[client]+= 400;
					case 2: g_pr_points[client]+= 300;
					case 3: g_pr_points[client]+= 200;
					case 4: g_pr_points[client]+= 190;
					case 5: g_pr_points[client]+= 180;
					case 6: g_pr_points[client]+= 170;
					case 7: g_pr_points[client]+= 160;
					case 8: g_pr_points[client]+= 150;
					case 9: g_pr_points[client]+= 140;
					case 10: g_pr_points[client]+= 130;
					case 11: g_pr_points[client]+= 120;
					case 12: g_pr_points[client]+= 110;
					case 13: g_pr_points[client]+= 100;
					case 14: g_pr_points[client]+= 90;
					case 15: g_pr_points[client]+= 80;
					case 16: g_pr_points[client]+= 60;
					case 17: g_pr_points[client]+= 40;
					case 18: g_pr_points[client]+= 20;
					case 19: g_pr_points[client]+= 10;
					case 20: g_pr_points[client]+= 5;
				}	
				break;
			}				
		}
	}
	g_pr_maprecords_row_counter[client]++;
	if (g_pr_maprecords_row_counter[client]==g_pr_maprecords_row_count[client])
	{
		db_updatePoints(client);		
	}
}

public db_updatePoints(client)
{
	decl String:szQuery[512];
	decl String:szName[MAX_NAME_LENGTH];	
	decl String:szSteamId[32];	
	if (client>MAXPLAYERS && g_pr_RankingRecalc_InProgress || client>MAXPLAYERS && g_bProfileRecalc[client])
	{
		Format(szQuery, 512, sql_updatePlayerRankPoints, g_pr_szName[client], g_pr_points[client],g_pr_finishedmaps[client],g_Challenge_WinRatio[client],g_Challenge_PointsRatio[client], g_pr_szSteamID[client]); 
		SQL_TQuery(g_hDb, sql_updatePlayerRankPointsCallback, szQuery, client, DBPrio_Low);
	}
	else
	{
		if (IsValidClient(client))
		{
			GetClientName(client, szName, MAX_NAME_LENGTH);	
			GetClientAuthString(client, szSteamId, 32);		
			Format(szQuery, 512, sql_updatePlayerRankPoints2, szName, g_pr_points[client], g_pr_finishedmaps[client],g_Challenge_WinRatio[client],g_Challenge_PointsRatio[client],g_szCountry[client], szSteamId); 
			SQL_TQuery(g_hDb, sql_updatePlayerRankPointsCallback, szQuery, client, DBPrio_Low);
		}
	}	
}

public RecalcPlayerRank(client, String:steamid[128])
{
	new i = 66;
	while (g_bProfileRecalc[i] == true)
		i++;
	if (!g_bProfileRecalc[i])
	{
		decl String:szQuery[255];
		decl String:szsteamid[128*2+1];
		SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);    
		Format(g_pr_szSteamID[i], 32, "%s", steamid); 	
		Format(szQuery, 255, sql_selectPlayerName, szsteamid); 
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, i);	
		WritePackCell(pack, client);		
		SQL_TQuery(g_hDb, sql_selectPlayerNameCallback, szQuery, pack);	    
	}
}


public CalculatePlayerRank(client)
{
	decl String:szQuery[255];      
	decl String:szSteamId[32];
	g_pr_oldpoints[client] = g_pr_points[client];
	g_pr_points[client] = 0;
				
	if (client>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else
	{
	
		if (!g_bPointSystem || !IsValidClient(client)) 
			return;
		GetClientAuthString(client, szSteamId, 32);
	}	
	Format(szQuery, 255, sql_selectRankedPlayer, szSteamId);  
	SQL_TQuery(g_hDb, sql_selectRankedPlayerCallback, szQuery,client, DBPrio_Low);	
}

public sql_selectRankedPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl String:szSteamId[32];
	if (client>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else
	{
		if (IsValidClient(client))
			GetClientAuthString(client, szSteamId, 32);
		else 
			return;
	}
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{		
		//"SELECT steamid, name, points, finishedmapspro, multiplier, country, lastseen from playerrank where steamid='%s'";

		if (client <= MAXPLAYERS && IsValidClient(client))
		{
			new Float: diff = GetEngineTime() - g_fMapStartTime;
			if (GetClientTime(client) < diff)
				db_UpdateLastSeen(client);
		}
		g_pr_multiplier[client] = SQL_FetchInt(hndl, 4);
		if (g_pr_multiplier[client] < 0)
			g_pr_multiplier[client] = g_pr_multiplier[client] * -1;
		g_pr_points[client]+=  g_ExtraPoints * g_pr_multiplier[client];			
		//challenges
		if (IsValidClient(client))
			g_pr_Calculating[client] = true;

		//get challenge results
		decl String:szQuery[512];      
		Format(szQuery, 512, sql_selectChallenges, szSteamId,szSteamId);
		SQL_TQuery(g_hDb, sql_selectChallengesCallbackCalc, szQuery, client,DBPrio_Low);	
	}
	else
	{
		if (client <= MaxClients)
		{
			g_pr_Calculating[client] = false;
			g_pr_AllPlayers++;			
			//insert
			decl String:szQuery[255];
			decl String:szUName[MAX_NAME_LENGTH];
			GetClientName(client, szUName, MAX_NAME_LENGTH);
			decl String:szName[MAX_NAME_LENGTH*2+1];      
			SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
			Format(szQuery, 255, sql_insertPlayerRank, szSteamId, szName,g_szCountry[client]); 
			SQL_TQuery(g_hDb, SQL_InsertPlayerCallBack, szQuery, client, DBPrio_Low);
			g_pr_multiplier[client] = 0;
			g_pr_finishedmaps[client] = 0;
			g_pr_finishedmaps_perc[client] = 0.0;
		}
	}
}

public db_viewPlayerPoints(client)
{
	g_pr_multiplier[client] = 0;
	g_pr_finishedmaps[client] = 0;
	g_pr_finishedmaps_perc[client] = 0.0;
	g_pr_points[client] = 0;
	decl String:szQuery[255];      
	if (!IsValidClient(client))
		return;
	Format(szQuery, 255, sql_selectRankedPlayer, g_szSteamID[client]);     
	SQL_TQuery(g_hDb, db_viewPlayerPointsCallback, szQuery,client,DBPrio_Low);	
}

public db_viewPlayerPointsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
		
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{		
		g_pr_points[client]=SQL_FetchInt(hndl, 2);	
		g_pr_finishedmaps[client] = SQL_FetchInt(hndl, 3);	
		g_pr_multiplier[client] = SQL_FetchInt(hndl, 4);
		if (g_pr_multiplier[client] < 0)
			g_pr_multiplier[client] = -1 * g_pr_multiplier[client];
		g_pr_finishedmaps_perc[client]= (float(g_pr_finishedmaps[client]) / float(g_pr_MapCount)) * 100.0;	
		if (IsValidClient(client))
			db_GetPlayerRank(client);
	}
	else
	{
		if (IsValidClient(client))
		{
			//insert	
			decl String:szQuery[512];
			decl String:szUName[MAX_NAME_LENGTH];
			if (IsValidClient(client))
				GetClientName(client, szUName, MAX_NAME_LENGTH);
			else
				return;			
			decl String:szName[MAX_NAME_LENGTH*2+1];      
			SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);	
			Format(szQuery, 512, sql_insertPlayerRank, g_szSteamID[client], szName,g_szCountry[client]); 
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
			db_GetPlayerRank(client);
		}
	}
}

public db_resetPlayerRecords(client, String:steamid[128])
{
	decl String:szQuery[255];    
	decl String:szsteamid[128*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);   	
	Format(szQuery, 255, sql_resetRecords, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	        
	PrintToConsole(client, "map times of %s cleared.", szsteamid);
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);	
	SQL_TQuery(g_hDb, SQL_CheckCallback3, "UPDATE playerrank SET multiplier ='0'", pack);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			if(StrEqual(g_szSteamID[i],szsteamid))
			{
				Format(g_szPersonalRecord[i], 32, "NONE");
				g_fPersonalRecord[i] = 0.0;
				g_MapRank[i] = 99999;
			}
		}
	}
}

public db_dropPlayerRanks(client)
{
	SQL_LockDatabase(g_hDb);
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropPlayerRank);
	else
		SQL_FastQuery(g_hDb, sqlite_dropPlayerRank);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "playerranks table dropped. Please restart your server!");
}

public db_dropPlayer(client)
{
	SQL_TQuery(g_hDb, sql_selectMutliplierCallback, "UPDATE playerrank SET multiplier ='0'", client);
	SQL_LockDatabase(g_hDb);
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropPlayer);
	else
		SQL_FastQuery(g_hDb, sqlite_dropPlayer);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "playertimes table dropped. Please restart your server!");
}

public db_viewPlayerRank(client, String:szSteamId[32])
{
	decl String:szQuery[512];  
	Format(g_pr_szrank[client], 512, "");	
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback, szQuery, client,DBPrio_Low);
}

public SQL_ViewRankedPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{	
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szCountry[100];
		decl String:szLastSeen[100];
		decl String:szSteamId[32];
		new finishedmapspro;
		new points;
		g_MapRecordCount[client] = 0;	
		
		//get the result
		SQL_FetchString(hndl, 0, szSteamId, 32);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
		points = SQL_FetchInt(hndl, 2);
		finishedmapspro = SQL_FetchInt(hndl, 3);
		SQL_FetchString(hndl, 5, szCountry, 100);
		SQL_FetchString(hndl, 6, szLastSeen, 100);
		new Handle:pack_pr = CreateDataPack();	
		WritePackString(pack_pr, szName);
		WritePackString(pack_pr, szSteamId);	
		WritePackCell(pack_pr, client);		
		WritePackCell(pack_pr, points);
		WritePackCell(pack_pr, finishedmapspro);
		WritePackString(pack_pr, szCountry);	
		WritePackString(pack_pr, szLastSeen);	
		Format(szQuery, 512, sql_selectRankedPlayersRank, szSteamId);
		SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback2, szQuery, pack_pr,DBPrio_Low);
	}
}

public db_GetPlayerRank(client)
{
	decl String:szQuery[512];
	Format(szQuery, 512, sql_selectRankedPlayersRank, g_szSteamID[client]);
	SQL_TQuery(g_hDb, sql_selectRankedPlayersRankCallback, szQuery, client,DBPrio_Low);		
}

public sql_selectRankedPlayersRankCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_PlayerRank[client] = SQL_GetRowCount(hndl);
		// Sort players by rank in scoreboard
		if (g_pr_AllPlayers < g_PlayerRank[client])
			CS_SetClientContributionScore(client, 0);
		else
			CS_SetClientContributionScore(client, (g_pr_AllPlayers - SQL_GetRowCount(hndl)));
	}
}

public SQL_ViewRankedPlayerCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		decl String:szSteamId[32];
		decl String:szName[MAX_NAME_LENGTH];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack_pr = data;
		WritePackCell(pack_pr, rank);
		ResetPack(pack_pr);	        
		ReadPackString(pack_pr, szName, MAX_NAME_LENGTH);
		ReadPackString(pack_pr, szSteamId, 32);	
		Format(szQuery, 512, sql_selectMapRecordCount, szSteamId);
		SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback4, szQuery, pack_pr,DBPrio_Low);	
	}
}

public SQL_ViewRankedPlayerCallback4(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	decl String:szQuery[512];
	decl String:szSteamId[32];
	decl String:szName[MAX_NAME_LENGTH];
	new Handle:pack_pr = data;
	ResetPack(pack_pr);       
	ReadPackString(pack_pr, szName, MAX_NAME_LENGTH);
	ReadPackString(pack_pr, szSteamId, 32);		
	new client = ReadPackCell(pack_pr);  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl)) 
		g_MapRecordCount[client] = SQL_FetchInt(hndl, 1);	//pack full?
	Format(szQuery, 512, sql_selectChallenges, szSteamId,szSteamId);
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback5, szQuery, pack_pr,DBPrio_Low);		
}

public SQL_ViewRankedPlayerCallback5(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	decl String:szChallengesPoints[32];
	Format(szChallengesPoints, 32, "0p");
	decl String:szChallengesWinRatio[32];
	Format(szChallengesWinRatio, 32, "0");
	new Handle:pack_pr = data;
	decl String:szName[MAX_NAME_LENGTH];
	decl String:szSteamId[32];
	decl String:szSteamIdChallenge[32];
	decl String:szCountry[100];
	decl String:szLastSeen[100];
	decl String:szNextRank[32];
	decl String:szSkillGroup[32];
	ResetPack(pack_pr);     
	ReadPackString(pack_pr, szName, MAX_NAME_LENGTH);
	ReadPackString(pack_pr, szSteamId, 32);
	new client = ReadPackCell(pack_pr);       
	new points = ReadPackCell(pack_pr);
	new finishedmapspro = ReadPackCell(pack_pr);  
	ReadPackString(pack_pr, szCountry, 100);	
	ReadPackString(pack_pr, szLastSeen, 100);	
	if (StrEqual(szLastSeen,""))
		Format(szLastSeen, 100, "Unknown");
	new rank = ReadPackCell(pack_pr);
	new prorecords = g_MapRecordCount[client];
	Format(g_szProfileSteamId[client], 32, "%s", szSteamId);
	Format(g_szProfileName[client], MAX_NAME_LENGTH, "%s", szName);
	new bool:master=false;
	new RankDifference;		   
	CloseHandle(pack_pr);	
	new bet;

	if (StrEqual(szSteamId, g_szSteamID[client]))
		g_PlayerRank[client] = rank;
		
	//get challenge results
	new challenges = 0;
	new challengeswon = 0;  
	new challengespoints = 0;  
	if(SQL_HasResultSet(hndl))
	{	
		challenges= SQL_GetRowCount(hndl);
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szSteamIdChallenge, 32);
			bet = SQL_FetchInt(hndl, 2);
			if (StrEqual(szSteamIdChallenge,szSteamId))
			{
				challengespoints+= bet;
				challengeswon++;
			}
			else
			{
				challengespoints-= bet;
				challengeswon--;
			}
		}
	}
	
	if (!g_bChallengePoints)
		challengespoints = 0;
	
	if (challengespoints>0)
		Format(szChallengesPoints, 32, "+%ip",challengespoints);   
	else
		if (challengespoints <= 0 && g_bChallengePoints)
			Format(szChallengesPoints, 32, "%ip",challengespoints);	
		else
			if (challengespoints <= 0 && !g_bChallengePoints)
				Format(szChallengesPoints, 32, "0p (disabled)"); 		
	
	
	if (challengeswon>0)
		Format(szChallengesWinRatio, 32, "+%i",challengeswon);   
	else
		if (challengeswon<0)
			Format(szChallengesWinRatio, 32, "%i",challengeswon); 
	
	if (finishedmapspro > g_pr_MapCount)	
		finishedmapspro=g_pr_MapCount;
		
	if (points < g_pr_rank_Percentage[1])
	{
		Format(szSkillGroup, 32, "%s",g_szSkillGroups[0]);
		RankDifference = g_pr_rank_Percentage[1] - points;
		Format(szNextRank, 32, " (%s)",g_szSkillGroups[1]);
	}
	else
	if (g_pr_rank_Percentage[1] <= points && points < g_pr_rank_Percentage[2])
	{
		Format(szSkillGroup, 32, "%s",g_szSkillGroups[1]);
		RankDifference = g_pr_rank_Percentage[2] - points;
		Format(szNextRank, 32, " (%s)",g_szSkillGroups[2]);
	}
	else
	if (g_pr_rank_Percentage[2] <= points && points < g_pr_rank_Percentage[3])
	{
		Format(szSkillGroup, 32, "%s",g_szSkillGroups[2]);
		RankDifference = g_pr_rank_Percentage[3] - points;
		Format(szNextRank, 32, " (%s)",g_szSkillGroups[3]);
	}		   
	else
	if (g_pr_rank_Percentage[3] <= points && points < g_pr_rank_Percentage[4])
	{
		Format(szSkillGroup, 32, "%s",g_szSkillGroups[3]);
		RankDifference = g_pr_rank_Percentage[4] - points;
		Format(szNextRank, 32, " (%s)",g_szSkillGroups[4]);
	}                      
	else
	if (g_pr_rank_Percentage[4] <= points && points < g_pr_rank_Percentage[5])
	{
	   Format(szSkillGroup, 32, "%s",g_szSkillGroups[4]);
	   RankDifference = g_pr_rank_Percentage[5] - points;
	   Format(szNextRank, 32, " (%s)",g_szSkillGroups[5]);
	}                      
	else
	if (g_pr_rank_Percentage[5] <= points && points < g_pr_rank_Percentage[6])
	{
	   Format(szSkillGroup, 32, "%s",g_szSkillGroups[5]);
	   RankDifference = g_pr_rank_Percentage[6] - points;
	   Format(szNextRank, 32, " (%s)",g_szSkillGroups[6]);
	}
	else
	if (g_pr_rank_Percentage[6] <= points && points < g_pr_rank_Percentage[7])
	{
		Format(szSkillGroup, 32, "%s",g_szSkillGroups[6]);
		RankDifference = g_pr_rank_Percentage[7] - points;
		Format(szNextRank, 32, " (%s)",g_szSkillGroups[7]);
	}
	else
	if (g_pr_rank_Percentage[7] <= points && points < g_pr_rank_Percentage[8])
	{
		Format(szSkillGroup, 32, "%s",g_szSkillGroups[7]);    
		RankDifference = g_pr_rank_Percentage[8] - points;
		Format(szNextRank, 32, " (%s)",g_szSkillGroups[8]);
	}
	else
	if (points >= g_pr_rank_Percentage[8])
	{
		Format(szSkillGroup, 32, "%s",g_szSkillGroups[8]);    
		RankDifference = 0;
		Format(szNextRank, 32, "");
		master=true;
	}  
	
	decl String: szRank[32];
	if (rank > g_pr_RankedPlayers || points == 0)
		Format(szRank,32,"-");
	else
		Format(szRank,32,"%i", rank);
	
	decl String:szRanking[255];
	Format(szRanking, 255, "");			
	if (master==false)
	{	
		if (g_bPointSystem)
			Format(szRanking, 255,"Rank: %s/%i (%i)\nPoints: %ip (%s)\nNext skill group in: %ip%s\n", szRank,g_pr_RankedPlayers, g_pr_AllPlayers,points,szSkillGroup,RankDifference,szNextRank);
		Format(g_pr_szrank[client], 512, "Rank: %s/%i (%i)\nPoints: %ip (%s)\nNext skill group in: %ip%s\nMaps completed: %i/%i (records: %i)\nPlayed challenges: %i\n╘W/L Ratio: %s\n╘W/L Points ratio: %s\n ", szRank,g_pr_RankedPlayers, g_pr_AllPlayers,points,szSkillGroup,RankDifference,szNextRank,finishedmapspro,g_pr_MapCount,prorecords,challenges,szChallengesWinRatio,szChallengesPoints);                    	
	}
	else
	{
		if (g_bPointSystem)
			Format(szRanking, 255,"Rank: %s/%i (%i)\nPoints: %ip (%s)\n", szRank,g_pr_RankedPlayers, g_pr_AllPlayers,points,szSkillGroup);
		Format(g_pr_szrank[client], 512, "Rank: %s/%i (%i)\nPoints: %ip (%s)\nMaps completed: %i/%i (records: %i)\nPlayed challenges: %i\n╘ W/L Ratio: %s\n╘ W/L points ratio: %s\n ", szRank,g_pr_RankedPlayers, g_pr_AllPlayers,points,szSkillGroup,finishedmapspro,g_pr_MapCount,prorecords,challenges,szChallengesWinRatio,szChallengesPoints);                    
		
	}
	new String:szID[32][2];
	ExplodeString(szSteamId,"_",szID,2,32);
	decl String:szTitle[1024];
	if (g_bCountry)
		Format(szTitle, 1024, "Player: %s\nSteamID: %s\nNationality: %s \nLast seen: %s\n \n%s\n",  szName,szID[1],szCountry,szLastSeen,g_pr_szrank[client]);		
	else
		Format(szTitle, 1024, "Player: %s\nSteamID: %s\nLast seen: %s\n \n%s\n",  szName,szID[1],szLastSeen,g_pr_szrank[client]);				
			
	new Handle:menu = CreateMenu(ProfileMenuHandler);
	SetMenuTitle(menu, szTitle);
	AddMenuItem(menu, "Current map time", "Current map time");
	AddMenuItem(menu, "Challenge history", "Challenge history");
	AddMenuItem(menu, "Finished maps", "Finished maps");
	if (IsValidClient(client))
	{
		if(StrEqual(szSteamId,g_szSteamID[client]))
		{
			AddMenuItem(menu, "Unfinished maps", "Unfinished maps");
			if (g_bPointSystem)
				AddMenuItem(menu, "Refresh my profile", "Refresh my profile");
		}
	}	
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
	g_bProfileSelected[client] = true;
	g_bClimbersMenuOpen[client]=false;
	g_bMenuOpen[client]=true;
}

public db_viewPlayerRank2(client, String:szSteamId[32])
{
	decl String:szQuery[512];  
	Format(g_pr_szrank[client], 512, "");	
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayer2Callback, szQuery, client,DBPrio_Low);
}

public SQL_ViewRankedPlayer2Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{	
		if (!IsValidClient(client))
			return;	
		
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamIdTarget[32];	
		SQL_FetchString(hndl, 0, szSteamIdTarget, 32);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
				
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szName);
		Format(szQuery, 512, sql_selectChallengesCompare, g_szSteamID[client],szSteamIdTarget,szSteamIdTarget,g_szSteamID[client]);
		SQL_TQuery(g_hDb, sql_selectChallengesCompareCallback, szQuery, pack,DBPrio_Low);
	}
}

public db_viewPlayerAll2(client, String:szPlayerName[MAX_NAME_LENGTH])
{
	decl String:szQuery[512];
	decl String:szName[MAX_NAME_LENGTH*2+1];
	SQL_QuoteString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);      
	Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT,szName,PERCENT);
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, szPlayerName);
	SQL_TQuery(g_hDb, SQL_ViewPlayerAll2Callback, szQuery, pack,DBPrio_Low);
}

public SQL_ViewPlayerAll2Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{  

	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	decl String:szName[MAX_NAME_LENGTH]; 
	new Handle:pack = data;	
	ResetPack(pack);
	new client = ReadPackCell(pack);      
	ReadPackString(pack, szName, MAX_NAME_LENGTH);
	decl String:szSteamId2[32];
	if (!IsValidClient(client))	
	{
		CloseHandle(pack);
		return;
	}
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{   	
		SQL_FetchString(hndl, 1, szSteamId2, 32);	
		if (!StrEqual(szSteamId2,g_szSteamID[client]))
			db_viewPlayerRank2(client,szSteamId2);
	}
	else
		PrintToChat(client, "%t", "PlayerNotFound", MOSSGREEN,WHITE, szName);
	CloseHandle(pack);
}



public db_viewPlayerAll(client, String:szPlayerName[MAX_NAME_LENGTH])
{
	decl String:szQuery[512];
	decl String:szName[MAX_NAME_LENGTH*2+1];
	SQL_QuoteString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);      
	Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT,szName,PERCENT);
	SQL_TQuery(g_hDb, SQL_ViewPlayerAllCallback, szQuery, client,DBPrio_Low);
}


public SQL_ViewPlayerAllCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{    
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{           
		SQL_FetchString(hndl, 1, g_szProfileSteamId[client], 32);
		db_viewPlayerRank(client,g_szProfileSteamId[client]);
	}
	else
		if(IsClientInGame(client))
			PrintToChat(client, "%t", "PlayerNotFound", MOSSGREEN,WHITE, g_szProfileName[client]);
}

public ContinueRecalc(client)
{
	//ON RECALC ALL
	if (client > MAXPLAYERS)
		CalculatePlayerRank(client); 
	else
	{
		//ON CONNECT
		if (!IsValidClient(client) || IsFakeClient(client))
			return;
		new Float: diff = GetEngineTime() - g_fMapStartTime + 1.5;
		if (GetClientTime(client) < diff)
		{
			CalculatePlayerRank(client); 	
		}
		else
		{
			db_viewPlayerPoints(client);
		}
	}
}	














///////////////////////////
//// CHALLENGES ///////////
///////////////////////////

public db_selectTopChallengers(client)
{
	decl String:szQuery[128];       
	Format(szQuery, 128, sql_selectTopChallengers);   
	SQL_TQuery(g_hDb, sql_selectTopChallengersCallback, szQuery, client,DBPrio_Low);
}

public sql_selectTopChallengersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
	new client = data;
	decl String:szValue[128];
	decl String:szName[MAX_NAME_LENGTH];
	decl String:szWinRatio[32];
	decl String:szSteamID[32];
	decl String:szPointsRatio[32];
	new winratio;
	new pointsratio;
	new Handle:menu = CreateMenu(TopChallengeHandler1);
	SetMenuPagination(menu, 5); 
	SetMenuTitle(menu, "Top 5 Challengers\n#   W/L P.-Ratio    Player (W/L ratio)");     
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{	
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			winratio = SQL_FetchInt(hndl, 1); 
			if (!g_bChallengePoints)
				pointsratio = 0;
			else
				pointsratio = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);			
			if (winratio>=0)
				Format(szWinRatio, 32, "+%i",winratio);
			else
				Format(szWinRatio, 32, "%i",winratio);
			
			if (pointsratio>=0)
				Format(szPointsRatio, 32, "+%ip",pointsratio);
			else
				Format(szPointsRatio, 32, "%ip",pointsratio);
			


			
			if (pointsratio  < 10)
				Format(szValue, 128, "       %s         » %s (%s)", szPointsRatio, szName,szWinRatio);
			else
				if (pointsratio  < 100)
					Format(szValue, 128, "       %s       » %s (%s)", szPointsRatio, szName,szWinRatio);		
				else
					if (pointsratio  < 1000)
						Format(szValue, 128, "       %s     » %s (%s)", szPointsRatio, szName,szWinRatio);		
					else
						if (pointsratio  < 10000)
							Format(szValue, 128, "       %s   » %s (%s)", szPointsRatio, szName,szWinRatio);	
						else
							Format(szValue, 128, "       %s » %s (%s)", szPointsRatio, szName,szWinRatio);	
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
			TopMenu(client);
		}
		else
		{
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, client, MENU_TIME_FOREVER);
		}
	}
	else
	{
		PrintToChat(client, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
		TopMenu(client);
	}
}

public sql_selectChallengesCallbackCalc(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl String:szQuery[512];   
	decl String:szSteamId[32];	
	decl String:szSteamIdChallenge[32];	
	
	if (client>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else
	{
		if (IsValidClient(client))
			GetClientAuthString(client, szSteamId, 32);
		else
			return;
	}
	new bet;
	if(SQL_HasResultSet(hndl))
	{	
		//"SELECT steamid, steamid2, bet, map FROM challenges where steamid = '%s' OR steamid2 ='%s'";

		g_Challenge_WinRatio[client] = 0;
		g_Challenge_PointsRatio[client] = 0;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szSteamIdChallenge, 32);
			bet = SQL_FetchInt(hndl, 2);
			if (StrEqual(szSteamIdChallenge,szSteamId))
			{
				g_Challenge_WinRatio[client]++;
				g_Challenge_PointsRatio[client]+= bet;
			}
			else
			{
				g_Challenge_WinRatio[client]--;
				g_Challenge_PointsRatio[client]-= bet;
			}
		}
	}	
	if (g_bChallengePoints)
		g_pr_points[client]+= g_Challenge_PointsRatio[client];
	Format(szQuery, 512, sql_selectPersonalBonusCompleted, szSteamId); 
	SQL_TQuery(g_hDb, sql_CountFinishedBonusCallback, szQuery, client, DBPrio_Low);
}

public db_resetPlayerResetChallenges(client, String:steamid[128])
{
	decl String:szQuery[255];
	decl String:szsteamid[128*2+1];
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);        
	Format(szQuery, 255, sql_deleteChallenges, szsteamid);       
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);	    
	SQL_TQuery(g_hDb, SQL_CheckCallback4, szQuery, pack);	     	
	PrintToConsole(client, "won challenges cleared (%s)", szsteamid);
}

public db_dropChallenges(client)
{
	SQL_TQuery(g_hDb, SQL_CheckCallback, "UPDATE playerrank SET winratio = '0',pointsratio = '0'", client);
	SQL_LockDatabase(g_hDb);
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropChallenges);
	else
		SQL_FastQuery(g_hDb, sqlite_dropChallenges);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "challenge table dropped. Please restart your server!");
}

public TopChallengeHandler1(Handle:menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1]=3;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public TopTpHoldersHandler1(Handle:menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1]=10;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}
public TopProHoldersHandler1(Handle:menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1]=11;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public db_viewChallengeHistory(client, String:szSteamId[32])
{
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sql_selectChallenges2, szSteamId, szSteamId);  
	if ((StrContains(szSteamId, "STEAM_") != -1) && IsClientInGame(client))
	{
		new Handle:pack = CreateDataPack();			
		WritePackString(pack, szSteamId);
		WritePackString(pack, g_szProfileName[client]);
		WritePackCell(pack, client);		
		SQL_TQuery(g_hDb, sql_selectChallengesCallback, szQuery, pack,DBPrio_Low);
	}
	else
		if (IsClientInGame(client))
			PrintToChat(client,"[%cCK%c] Invalid SteamID found.",RED,WHITE);
	ProfileMenu(client, -1);
}

public sql_selectChallengesCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	//decl.
	new bet, cp_allowed = 0, client;
	new bHeader=false;
	decl String:szMapName[32];
	decl String:szSteamId[32];
	decl String:szSteamId2[32];	
	decl String:szSteamIdTarget[32];
	decl String:szNameTarget[32];	
	decl String:szDate[64];	
	
	//get pack data
	new Handle:pack = data;
	ResetPack(pack);
	ReadPackString(pack, szSteamIdTarget, 32);
	ReadPackString(pack, szNameTarget, 32);
	client = ReadPackCell(pack);
	CloseHandle(pack);
	
	if(SQL_HasResultSet(hndl))
	{	
		//fetch rows
		while (SQL_FetchRow(hndl))
		{
			//get row data
			SQL_FetchString(hndl, 0, szSteamId, 32);
			SQL_FetchString(hndl, 1, szSteamId2, 32);
			bet = SQL_FetchInt(hndl, 2);
			SQL_FetchString(hndl, 3, szMapName, 32);					
			SQL_FetchString(hndl, 4, szDate, 64);	
			
			//header
			if (!bHeader)
			{
				PrintToConsole(client," ");
				PrintToConsole(client,"-------------");
				PrintToConsole(client,"Challenge history");
				PrintToConsole(client,"Player: %s", szNameTarget);
				PrintToConsole(client,"SteamID: %s", szSteamIdTarget);
				PrintToConsole(client,"-------------");
				PrintToConsole(client," ");
				bHeader=true;
				PrintToChat(client, "%t", "ConsoleOutput", LIMEGREEN,WHITE); 	
			}
			
			//won/loss?
			new WinnerTarget=0;
			if (StrEqual(szSteamId,szSteamIdTarget))
				WinnerTarget=1;
			
			//create pack
			new Handle:pack2 = CreateDataPack();		
			WritePackCell(pack2, client);		
			WritePackCell(pack2, WinnerTarget);	
			WritePackString(pack2, szNameTarget);
			WritePackString(pack2, szSteamId);
			WritePackString(pack2, szSteamId2);
			WritePackString(pack2, szMapName);	
			WritePackString(pack2, szDate);	
			WritePackCell(pack2, bet);		
			WritePackCell(pack2, cp_allowed);		
			
			//Query
			decl String:szQuery[512];
			if (WinnerTarget==1)
				Format(szQuery, 512, "select name from playerrank where steamid = '%s'", szSteamId2);
			else
				Format(szQuery, 512, "select name from playerrank where steamid = '%s'", szSteamId);
			SQL_TQuery(g_hDb, sql_selectChallengesCallback2, szQuery, pack2,DBPrio_Low);						
		}
	}
	if(!bHeader)
	{
		ProfileMenu(client, -1);
		PrintToChat(client, "[%cCK%c] No challenges found.",MOSSGREEN,WHITE);
	}
}

public sql_selectChallengesCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	//decl.
	decl String:szNameTarget[32];
	decl String:szNameOpponent[32];
	decl String:szSteamId[32];
	decl String:szCps[32];
	decl String:szResult[32];
	decl String:szSteamId2[32];
	decl String:szMapName[32];
	decl String:szDate[64];
	new client, bet, WinnerTarget, cp_allowed;
	
	//get pack data
	new Handle:pack = data;
	ResetPack(pack);	
	client = ReadPackCell(pack);
	WinnerTarget = ReadPackCell(pack);
	ReadPackString(pack, szNameTarget, 32);
	ReadPackString(pack, szSteamId, 32);
	ReadPackString(pack, szSteamId2, 32);
	ReadPackString(pack, szMapName, 32);
	ReadPackString(pack, szDate, 64);	
	bet = ReadPackCell(pack);
	cp_allowed = ReadPackCell(pack);
	CloseHandle(pack);
	
	//default name=steamid
	if (WinnerTarget==1)
		Format(szNameOpponent, 32, "%s", szSteamId2);
	else
		Format(szNameOpponent, 32, "%s", szSteamId);
	
	//query result
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		SQL_FetchString(hndl, 0, szNameOpponent, 32);
	
	//format..
	if (WinnerTarget==1)
		Format(szResult, 32, "WIN");
	else
		Format(szResult, 32, "LOSS");
	
	if (cp_allowed==1)
		Format(szCps, 32, "yes");
	else
		Format(szCps, 32, "no");
		
	//console msg
	if (IsClientInGame(client))
		PrintToConsole(client,"(%s) %s vs. %s, map: %s, bet: %i, result: %s", szDate, szNameTarget, szNameOpponent, szMapName, bet, szCps, szResult);
}

public sql_selectChallengesCompareCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new winratio=0;
	new challenges= SQL_GetRowCount(hndl);
	new pointratio=0;
	decl String:szWinRatio[32];
	decl String:szPointsRatio[32];
	decl String:szName[MAX_NAME_LENGTH];
	new Handle:pack = data;
	ResetPack(pack);
	new client = ReadPackCell(pack);      
	if (!IsValidClient(client))
		return;
	ReadPackString(pack, szName, MAX_NAME_LENGTH);
	CloseHandle(pack);	
	if(SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			decl String:szID[32];
			new bet;
			SQL_FetchString(hndl, 0, szID, 32);
			bet = SQL_FetchInt(hndl,2);
			if (StrEqual(szID, g_szSteamID[client]))
			{
				winratio++;
				pointratio+= bet;
			}
			else
			{
				winratio--;
				pointratio-= bet;	
			}
		}
		if (winratio>0)
			Format(szWinRatio, 32, "+%i",winratio);
		else
			Format(szWinRatio, 32, "%i",winratio);
			
		if (pointratio>0)
			Format(szPointsRatio, 32, "+%ip",pointratio);
		else
			Format(szPointsRatio, 32, "%ip",pointratio);			
		
		if (winratio>0)
		{
			if (pointratio>0)
				PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, GREEN,szWinRatio,GRAY,GREEN,szPointsRatio,GRAY);
			else
					if (pointratio<0)
						PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, GREEN,szWinRatio,GRAY,RED,szPointsRatio,GRAY);
					else
						PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, GREEN,szWinRatio,GRAY,YELLOW,szPointsRatio,GRAY);	
		}
		else
		{
			if (winratio<0)
			{
				if (pointratio>0)
					PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, RED,szWinRatio,GRAY,GREEN,szPointsRatio,GRAY);
				else
					if (pointratio<0)
						PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, RED,szWinRatio,GRAY,RED,szPointsRatio,GRAY);
					else
						PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, RED,szWinRatio,GRAY,YELLOW,szPointsRatio,GRAY);	
		
			}
			else
			{
				if (pointratio>0)
					PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, YELLOW,szWinRatio,GRAY,GREEN,szPointsRatio,GRAY);
				else
					if (pointratio<0)
						PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, YELLOW,szWinRatio,GRAY,RED,szPointsRatio,GRAY);
					else
						PrintToChat(client,"[%cCK%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN,WHITE,GRAY,PURPLE,challenges,GRAY,PURPLE, szName,GRAY, YELLOW,szWinRatio,GRAY,YELLOW,szPointsRatio,GRAY);	
			}
		}	
	}
	else
		PrintToChat(client,"[%cCK%c] No challenges againgst %s found", szName);
}

public db_insertPlayerChallenge(client)
{
	if (!IsValidClient(client))
		return;
	decl String:szQuery[255];
	new points;
	points = g_Challenge_Bet[client] * g_pr_PointUnit;

	Format(szQuery, 255, sql_insertChallenges, g_szSteamID[client], g_szChallenge_OpponentID[client],points,g_szMapName);
	SQL_TQuery(g_hDb, sql_insertChallengesCallback, szQuery,client,DBPrio_Low);
}

public sql_insertChallengesCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
}	
















///////////////////
// PLAYERTIMES ////
///////////////////

public db_resetPlayerMapRecord(client, String:steamid[128], String:szMapName[128])
{
	decl String:szQuery[255];      
	decl String:szsteamid[128*2+1];
	
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetRecordPro, szsteamid, szMapName);   
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);	    
	SQL_TQuery(g_hDb, SQL_CheckCallback3, szQuery,pack);	    
	PrintToConsole(client, "map time of %s on %s cleared.", steamid, szMapName);
    
	if (StrEqual(szMapName,g_szMapName))
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if(StrEqual(g_szSteamID[i],szsteamid))
				{
					Format(g_szPersonalRecord[i], 32, "NONE");
					g_fPersonalRecord[i] = 0.0;
					g_MapRank[i] = 99999;
				}
			}
		}
	} 
}

public db_resetPlayerRecords2(client, String:steamid[128], String:szMapName[128])
{
	decl String:szQuery[255];      
	decl String:szsteamid[128*2+1];
	
	SQL_QuoteString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetRecords2, szsteamid, szMapName); 
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);		
	SQL_TQuery(g_hDb, SQL_CheckCallback3, szQuery, pack);	    
	PrintToConsole(client, "map times of %s on %s cleared.", steamid, szMapName);
    
	if (StrEqual(szMapName,g_szMapName))
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if(StrEqual(g_szSteamID[i],szsteamid))
				{
					Format(g_szPersonalRecord[i], 32, "NONE");
					g_fPersonalRecord[i] = 0.0;
					g_MapRank[i] = 99999;
				}
			}
		}
	}
}

public db_GetMapRecord_Pro()
{
	decl String:szQuery[512];      
	Format(szQuery, 512, sql_selectMapRecordPro, g_szMapName);      
	SQL_TQuery(g_hDb, sql_selectMapRecordProCallback, szQuery,DBPrio_Low);
}

public sql_selectMapRecordProCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if (SQL_FetchFloat(hndl, 0) > -1.0)
		{
			g_fRecordMapTime = SQL_FetchFloat(hndl, 0);
			SQL_FetchString(hndl, 1, g_szRecordPlayer, MAX_NAME_LENGTH);	
		}
		else
			g_fRecordMapTime = 9999999.0;
	}
	else
		g_fRecordMapTime = 9999999.0;
}


public sql_selectTopClimbersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new Handle:pack = data;
	ResetPack(pack);
	new client = ReadPackCell(pack);
	decl String:szMap[128];
	ReadPackString(pack, szMap, 128);	
	CloseHandle(pack);
	decl String:szFirstMap[128];
	decl String:szValue[128];
	decl String:szName[64];
	new Float:time;
	decl String:szSteamID[32];
	new String:lineBuf[256];
	new Handle:stringArray = CreateArray(100);
	new Handle:menu;
	if (StrEqual(szMap,g_szMapName))
		menu = CreateMenu(MapMenuHandler1);
	else
		menu = CreateMenu(MapTopMenuHandler2);		
	SetMenuPagination(menu, 5);
	new bool:bduplicat = false;
	decl String:title[256];
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			bduplicat = false;
			SQL_FetchString(hndl, 0, szSteamID, 32);
			SQL_FetchString(hndl, 1, szName, 64);
			time = SQL_FetchFloat(hndl, 2); 
			SQL_FetchString(hndl, 4, szMap, 128);
			if (i == 1 || (i > 1 && StrEqual(szFirstMap,szMap)))
			{
				new stringArraySize = GetArraySize(stringArray);
				for(new x = 0; x < stringArraySize; x++)
				{
					GetArrayString(stringArray, x, lineBuf, sizeof(lineBuf));
					if (StrEqual(lineBuf, szName, false))
						bduplicat=true;		
				}
				if (bduplicat==false && i < 51)
				{	
					decl String:szTime[32];
					FormatTimeFloat(client, time, 3,szTime,sizeof(szTime));
					if (time<3600.0)
						Format(szTime, 32, "   %s", szTime);			
					if (i == 100)
						Format(szValue, 128, "[%i.] %s |    » %s", i, szTime, szName);
					if (i >= 10)
						Format(szValue, 128, "[%i.] %s |    » %s", i, szTime, szName);
					else
						Format(szValue, 128, "[0%i.] %s |    » %s", i, szTime, szName);
					AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
					PushArrayString(stringArray, szName);
					if (i == 1)
						Format(szFirstMap, 128, "%s",szMap);
					i++;
				}
			}
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoTopRecords", MOSSGREEN,WHITE, szMap);
		}
	}
	else
		PrintToChat(client, "%t", "NoTopRecords", MOSSGREEN,WHITE, szMap);
	Format(g_szMapTopName[client], 128, "%s",szFirstMap);	
	StopClimbersMenu(client);
	Format(title, 256, "Top 50 Times on %s \n    Rank    Time               Player", szFirstMap);
	SetMenuTitle(menu, title);     
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
	CloseHandle(stringArray);
}

public sql_selectProClimbersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl String:szValue[128];
	decl String:szSteamID[32];
	decl String:szName[64];
	decl String:szTime[32];
	new Float:time;
	new Handle:menu = CreateMenu(MapMenuHandler3);
	SetMenuPagination(menu, 5);
	SetMenuTitle(menu, "Top 20 Map Times (local)\n    Rank   Time              Player");     
	if(SQL_HasResultSet(hndl))
		
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 0, szName, 64);
			time = SQL_FetchFloat(hndl, 1);		
			SQL_FetchString(hndl, 2, szSteamID, 32);
			FormatTimeFloat(client, time, 3,szTime,sizeof(szTime));			
			if (time<3600.0)
				Format(szTime, 32, "  %s", szTime);
			if (i < 10)
				Format(szValue, 128, "[0%i.] %s    » %s", i, szTime, szName);
			else
				Format(szValue, 128, "[%i.] %s    » %s", i, szTime, szName);
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoMapRecords",MOSSGREEN,WHITE, g_szMapName);
		}
	}     
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public db_selectTopClimbers(client, String:mapname[128])
{
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sql_selectTopClimbers, mapname);  
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, mapname);
	SQL_TQuery(g_hDb, sql_selectTopClimbersCallback, szQuery, pack,DBPrio_Low);
}

public db_selectMapTopClimbers(client, String:mapname[128])
{
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sql_selectTopClimbers2, PERCENT,mapname,PERCENT);
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, mapname);
	SQL_TQuery(g_hDb, sql_selectTopClimbersCallback, szQuery, pack,DBPrio_Low);
}

public db_selectProClimbers(client)
{
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sql_selectProClimbers, g_szMapName);   		
	SQL_TQuery(g_hDb, sql_selectProClimbersCallback, szQuery, client,DBPrio_Low);
}

public db_updateRecordPro(client)
{
	decl String:szQuery[1024];
	decl String:szUName[MAX_NAME_LENGTH];
	if (IsValidClient(client))
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	else
		return;   
	decl String:szName[MAX_NAME_LENGTH*2+1];
	SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	Format(szQuery, 1024, sql_updateRecordPro, szUName, g_fFinalTime[client], g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback, szQuery,client,DBPrio_Low);
	FormatTimeFloat(client, g_fFinalTime[client], 3, g_szPersonalRecord[client], 32);
	g_fPersonalRecord[client] = g_fFinalTime[client];
}

public SQL_UpdateRecordProCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	g_bMapRankToChat[client]=true;
	db_viewMapRankPro(client);
}

public db_selectRecord(client)
{
	decl String:szQuery[255];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 255, sql_selectRecord, g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, sql_selectRecordCallback, szQuery, client,DBPrio_Low);
}

public sql_selectRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl String:szQuery[512];
	if (!IsValidClient(client))
		return;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{ 
		Format(szQuery, 512, sql_selectMapRecord, g_szSteamID[client], g_szMapName);
		if (!IsFakeClient(client))
			SQL_TQuery(g_hDb, SQL_UpdateRecordCallback, szQuery, client,DBPrio_Low);		
	}
	else
	{ 
		decl String:szName[MAX_NAME_LENGTH];
		GetClientName(client, szName, MAX_NAME_LENGTH);
		Format(szQuery, 512, sql_insertPlayerTime, g_szSteamID[client], g_szMapName, szName, g_fFinalTime[client]);
		FormatTimeFloat(client, g_fFinalTime[client], 3, g_szPersonalRecord[client], 32);
		g_fPersonalRecord[client] = g_fFinalTime[client];
		SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback, szQuery,client,DBPrio_Low);	
	}
}

public SQL_UpdateRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data) 
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new Float:time;
		time = SQL_FetchFloat(hndl, 3);
		if((g_fFinalTime[client] <= time || time <= 0.0)) 
		{
			db_updateRecordPro(client);
		}
	}    
	else
	{ 
		db_updateRecordPro(client);	
	}
}

public db_viewRecord(client, String:szSteamId[32], String:szMapName[128])
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectPersonalRecords, szSteamId, szMapName);  
	SQL_TQuery(g_hDb, SQL_ViewRecordCallback, szQuery, client,DBPrio_Low);
}



public SQL_ViewRecordCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;	
	g_bClimbersMenuOpen[client]=false;
	g_bMenuOpen[client] = true;	
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		decl String:szQuery[512];
		decl String:szMapName[128];
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamId[32];
		new Float:timepro;

		//get the result
		SQL_FetchString(hndl, 0, szMapName, 128);
		SQL_FetchString(hndl, 1, szSteamId, MAX_NAME_LENGTH);
		SQL_FetchString(hndl, 2, szName, MAX_NAME_LENGTH);
		timepro = SQL_FetchFloat(hndl, 3);      
		new Handle:pack1 = CreateDataPack();		
		WritePackString(pack1, szMapName);
		WritePackString(pack1, szSteamId);	
		WritePackString(pack1, szName);	
		WritePackCell(pack1, client);
		WritePackFloat(pack1, timepro);

		Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback2, szQuery, pack1,DBPrio_Low);
	}
	else
	{ 
		new Handle:panel = CreatePanel();
		DrawPanelText(panel, "Current map time");
		DrawPanelText(panel, " ");
		DrawPanelText(panel, "No record found on this map.");
		DrawPanelItem(panel, "exit");
		SendPanelToClient(panel, client, MenuHandler2, 300);
		CloseHandle(panel);
	}
}

public SQL_ViewRecordCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
	decl String:szQuery[512];
	new rank = SQL_GetRowCount(hndl);
	new Handle:pack2 = data;
	WritePackCell(pack2, rank);
	ResetPack(pack2);	
	decl String:szMapName[128];
	ReadPackString(pack2, szMapName, 128);
	decl String:szSteamId[32];
	ReadPackString(pack2, szSteamId, 32);
	decl String:szName[MAX_NAME_LENGTH];
	ReadPackString(pack2, szName, MAX_NAME_LENGTH);
	Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
	SQL_TQuery(g_hDb, SQL_ViewRecordCallback3, szQuery, pack2,DBPrio_Low);
	}
}


public SQL_ViewRecordCallback3(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new count1 = SQL_GetRowCount(hndl);
		new Handle:pack3 = data;
		ResetPack(pack3);		
		decl String:szMapName[128];
		ReadPackString(pack3, szMapName, 128);
		decl String:szSteamId[32];
		ReadPackString(pack3, szSteamId, 32);
		decl String:szName[MAX_NAME_LENGTH];
		ReadPackString(pack3, szName, MAX_NAME_LENGTH);	
		new client = ReadPackCell(pack3);
		new Float:timepro = ReadPackFloat(pack3);
		new rank = ReadPackCell(pack3);
		g_bClimbersMenuOpen[client]=false;
		g_bMenuOpen[client] = true;	
		
		if (timepro != -1.0)
		{               
				new Handle:panel = CreatePanel();
				decl String:szVrName[256];
				decl String:szVrTime[256];
				Format(szVrName, 256, "Map time of %s", szName);
				DrawPanelText(panel, szVrName);
				Format(szVrName, 256, "on %s", g_szMapName);
				DrawPanelText(panel, " ");		
				decl String:szVrRank[32];
				
				FormatTimeFloat(client, timepro, 3,szVrTime,sizeof(szVrTime));
				Format(szVrTime, 256, "Time: %s", szVrTime);

				Format(szVrRank, 32, "Rank: %i of %i", rank,count1);
				DrawPanelText(panel, "Pro time:");
				DrawPanelText(panel, szVrTime);
				DrawPanelText(panel, szVrRank);
				DrawPanelText(panel, " ");
				DrawPanelItem(panel, "Exit");
				CloseHandle(pack3);
				SendPanelToClient(panel, client, RecordPanelHandler, 300);
				CloseHandle(panel);
			}
			else
				if (timepro != 0.000000)
				{
					WritePackCell(pack3, count1);
					decl String:szQuery[512];
					Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
					SQL_TQuery(g_hDb, SQL_ViewRecordCallback4, szQuery, pack3,DBPrio_Low);
                }
        }
}

public SQL_ViewRecordCallback4(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{

		decl String:szQuery[512];
		new rankPro = SQL_GetRowCount(hndl);
		new Handle:pack4 = data;
		WritePackCell(pack4, rankPro);
		ResetPack(pack4);
		decl String:szMapName[128];
		ReadPackString(pack4, szMapName, 128);
		Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback5, szQuery, pack4,DBPrio_Low);
	}
}

public SQL_ViewRecordCallback5(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new countPro = SQL_GetRowCount(hndl);           
		//retrieve all values
		new Handle:pack5 = data;
		ResetPack(pack5);            
		decl String:szMapName[128];
		ReadPackString(pack5, szMapName, 128);
		decl String:szSteamId[32];
		ReadPackString(pack5, szSteamId, 32);
		decl String:szName[MAX_NAME_LENGTH];
		ReadPackString(pack5, szName, MAX_NAME_LENGTH);	
		new client = ReadPackCell(pack5);
		new Float:timepro = ReadPackFloat(pack5);
		new rank = ReadPackCell(pack5);                  
		new count1 = ReadPackCell(pack5);        
		new rankPro = ReadPackCell(pack5);                 
		g_bClimbersMenuOpen[client]=false;
		g_bMenuOpen[client] = true;			
		if (timepro != -1.0)
		{				
			new Handle:panel = CreatePanel();
			decl String:szVrName[256];
			Format(szVrName, 256, "Map time of %s", szName);
			DrawPanelText(panel, szVrName);
			Format(szVrName, 256, "on %s", g_szMapName);
			DrawPanelText(panel, " ");
			
			decl String:szVrRank[32];
			decl String:szVrRankPro[32];      
			decl String:szVrTimePro[256];
			FormatTimeFloat(client, timepro, 3,szVrTimePro,sizeof(szVrTimePro));
			Format(szVrTimePro, 256, "Time: %s", szVrTimePro);
			
			Format(szVrRank, 32, "Rank: %i of %i", rank,count1); 
			Format(szVrRankPro, 32, "Rank: %i of %i", rankPro,countPro); 
					          
			DrawPanelText(panel, szVrRank);
			DrawPanelText(panel, " ");
			DrawPanelText(panel, "Pro time:");
			DrawPanelText(panel, szVrTimePro);
			DrawPanelText(panel, szVrRankPro);
			DrawPanelText(panel, " ");
			DrawPanelItem(panel, "exit");
			SendPanelToClient(panel, client, RecordPanelHandler, 300);
			CloseHandle(panel);
		}
		CloseHandle(pack5);
	}
	
}

public db_viewAllRecords(client, String:szSteamId[32])
{
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sql_selectPersonalAllRecords, szSteamId, szSteamId);  
	if ((StrContains(szSteamId, "STEAM_") != -1))
		SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback, szQuery, client,DBPrio_Low);
	else
		if (IsClientInGame(client))
			PrintToChat(client,"[%cCK%c] Invalid SteamID found.",RED,WHITE);
	ProfileMenu(client, -1);
}


public SQL_ViewAllRecordsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	new bHeader=false;
	decl String:szUncMaps[1024];
	new mapcount=0;
	decl String:szName[MAX_NAME_LENGTH];
	decl String:szSteamId[32];
	if(SQL_HasResultSet(hndl))
	{	
		new Float:time;
		decl String:szMapName[128];		
		decl String:szMapName2[128];
		decl String:szRecord_type[4];
		decl String:szQuery[1024];
		Format(szUncMaps,sizeof(szUncMaps),"");
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 1, szSteamId, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 2, szMapName, 128);	
			
			time = SQL_FetchFloat(hndl, 3);
				
			Format(szRecord_type, 4, "PRO");	
			new mapfound=false;
			
			//map in rotation?
			for (new i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));
				if (StrEqual(szMapName2, szMapName, false))
				{
					if (!bHeader)
					{
						PrintToConsole(client," ");
						PrintToConsole(client,"-------------");
						PrintToConsole(client,"Finished Maps");
						PrintToConsole(client,"Player: %s", szName);
						PrintToConsole(client,"SteamID: %s", szSteamId);
						PrintToConsole(client,"-------------");
						PrintToConsole(client," ");
						bHeader=true;
						PrintToChat(client, "%t", "ConsoleOutput", LIMEGREEN,WHITE); 	
					}
					new Handle:pack = CreateDataPack();			
					WritePackString(pack, szName);
					WritePackString(pack, szSteamId);
					WritePackString(pack, szMapName);			
					WritePackString(pack, szRecord_type);		
					WritePackFloat(pack, time);
					WritePackCell(pack, client);

					Format(szQuery, 1024, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
					SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback2, szQuery, pack,DBPrio_Low);
					mapfound=true;
					continue;
				}
			}
			if (!mapfound)
			{
				mapcount++;
				if (!mapfound && mapcount==1)
				{
					Format(szUncMaps,sizeof(szUncMaps),"%s (Pro)",szMapName);
				}
				else
				{
					if (!mapfound && mapcount>1)
					{
						Format(szUncMaps,sizeof(szUncMaps),"%s, %s (Pro)",szUncMaps, szMapName);
					}
				}
			}
		}
	}
	if (!StrEqual(szUncMaps,""))
	{		
		if(!bHeader)
		{
			PrintToChat(client, "%t", "ConsoleOutput", LIMEGREEN,WHITE); 
			PrintToConsole(client," ");
			PrintToConsole(client,"-------------");
			PrintToConsole(client,"Finished Maps");
			PrintToConsole(client,"Player: %s", szName);
			PrintToConsole(client,"SteamID: %s", szSteamId);
			PrintToConsole(client,"-------------");
			PrintToConsole(client," ");		
		}
		PrintToConsole(client, "Times on maps which are not in the mapcycle.txt (TP and Pro records still count but you don't get points): %s", szUncMaps);
	}
	if(!bHeader && StrEqual(szUncMaps,""))
	{
		ProfileMenu(client, -1);
		PrintToChat(client, "%t", "PlayerHasNoMapRecords", LIMEGREEN,WHITE,g_szProfileName[client]);
	}
}

public SQL_ViewAllRecordsCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szQuery[512];
		new rank = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		WritePackCell(pack, rank);
		ResetPack(pack);
		decl String:szName[MAX_NAME_LENGTH];
		ReadPackString(pack, szName, MAX_NAME_LENGTH);
		decl String:szSteamId[32];
		ReadPackString(pack, szSteamId, 32);
		decl String:szMapName[128];
		ReadPackString(pack, szMapName, 128);
		decl String:szRecord_type[4];
		ReadPackString(pack, szRecord_type, 4);	
		Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback3, szQuery, pack,DBPrio_Low);		
	}
}

public SQL_ViewAllRecordsCallback3(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new count = SQL_GetRowCount(hndl);
		new Handle:pack = data;
		ResetPack(pack);
		
		decl String:szName[MAX_NAME_LENGTH];
		ReadPackString(pack, szName, MAX_NAME_LENGTH);
		decl String:szSteamId[32];
		ReadPackString(pack, szSteamId, 32);
		decl String:szMapName[128];
		ReadPackString(pack, szMapName, 128);	
		decl String:szRecord_type[4];
		decl String:szTime[32];
		ReadPackString(pack, szRecord_type, 4);				
		new Float:time = ReadPackFloat(pack);	
		new client = ReadPackCell(pack);
		new rank = ReadPackCell(pack);
		
		CloseHandle(pack);
		FormatTimeFloat(client,time,3,szTime,sizeof(szTime));
		if (IsValidClient(client))
			PrintToConsole(client,"%s, Time: %s (%s), Rank: %i/%i", szMapName, szTime, szRecord_type, rank,count);
	}
}	


public db_selectPlayer(client)
{
	decl String:szQuery[255];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 255, sql_selectPlayer, g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, SQL_SelectPlayerCallback, szQuery, client,DBPrio_Low);
}

public SQL_SelectPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl) && IsValidClient(client))
	{
	}
	else
		db_insertPlayer(client);
}

public db_insertPlayer(client)
{
	decl String:szQuery[255];
	decl String:szUName[MAX_NAME_LENGTH];
	if (IsValidClient(client))
	{
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	}
	else
		return;	
	decl String:szName[MAX_NAME_LENGTH*2+1];      
	SQL_QuoteString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	Format(szQuery, 255, sql_insertPlayer, g_szSteamID[client], g_szMapName, szName); 
	SQL_TQuery(g_hDb, SQL_InsertPlayerCallback, szQuery,client,DBPrio_Low);
}

public SQL_InsertPlayerCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
}	

public db_viewPersonalRecords(client, String:szSteamId[32], String:szMapName[128])
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectPersonalRecords, szSteamId, szMapName);
	SQL_TQuery(g_hDb, SQL_selectPersonalRecordsCallback, szQuery, client,DBPrio_Low);
}
	

public SQL_selectPersonalRecordsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	g_fPersonalRecord[client] = 0.0;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalRecord[client] = SQL_FetchFloat(hndl, 3); 
		
		if (g_fPersonalRecord[client]>0.0)
		{
			FormatTimeFloat(client, g_fPersonalRecord[client], 3, g_szPersonalRecord[client], 32);
			db_viewMapRankPro(client);
		}
		else
		{
			Format(g_szPersonalRecord[client], 32, "NONE");
			g_fPersonalRecord[client] = 0.0;
		}
	}
}              












///////////////////////
//// PLAYER TEMP //////
///////////////////////

public db_deleteTmp(client)
{
	decl String:szQuery[256];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 256, sql_deletePlayerTmp, g_szSteamID[client]); 
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client,DBPrio_Low);
}

public db_selectLastRun(client)
{
	decl String:szQuery[512];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 512, sql_selectPlayerTmp, g_szSteamID[client], g_szMapName);     
	SQL_TQuery(g_hDb, SQL_LastRunCallback, szQuery, client,DBPrio_Low);
}

public SQL_LastRunCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
	new client = data;	
	g_bTimeractivated[client] = false;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl) && IsValidClient(client))
	{
		//Get last psition
		g_fPlayerCordsRestore[client][0] = SQL_FetchFloat(hndl, 0);
		g_fPlayerCordsRestore[client][1] = SQL_FetchFloat(hndl, 1);
		g_fPlayerCordsRestore[client][2] = SQL_FetchFloat(hndl, 2);
		g_fPlayerAnglesRestore[client][0] = SQL_FetchFloat(hndl, 3);
		g_fPlayerAnglesRestore[client][1] = SQL_FetchFloat(hndl, 4);
		g_fPlayerAnglesRestore[client][2] = SQL_FetchFloat(hndl, 5);		
	
		decl tmpBool;
		tmpBool = SQL_FetchInt(hndl, 8);
		if (tmpBool == 1)
			g_bBonusTimer[client] = true;
		else
			g_bBonusTimer[client] = false;
			
		g_Stage[client] = SQL_FetchInt(hndl, 9);
		
		//Set new start time	
		new Float: fl_time = SQL_FetchFloat(hndl, 6);
		new tickrate = RoundFloat(float(SQL_FetchInt(hndl, 7)) / 5.0 / 11.0);		
		if (tickrate == g_Server_Tickrate)
		{
			if (fl_time > 0.0)
			{
				g_fStartTime[client] = GetEngineTime() - fl_time;  
				g_bTimeractivated[client] = true;
				
			}
				
			if (SQL_FetchFloat(hndl, 0) == -1.0 && SQL_FetchFloat(hndl, 1) == -1.0 && SQL_FetchFloat(hndl, 2) == -1.0) 
			{
				g_bRestorePosition[client] = false;
				g_bRestorePositionMsg[client] = false;
			}
			else
			{
				if (g_bLateLoaded && IsPlayerAlive(client) && !g_specToStage[client])
				{
					g_bPositionRestored[client] = true;
					TeleportEntity(client, g_fPlayerCordsRestore[client],g_fPlayerAnglesRestore[client],NULL_VECTOR);
					g_bRestorePosition[client]  = false;
				}
				else
				{
					g_bRestorePosition[client] = true;
					g_bRestorePositionMsg[client]=true;
				}
				
			}
		}
	}
	else
	{
		g_bTimeractivated[client] = false;
	}
}














////////////////////////
//// MAP BUTTONS ///////
////////////////////////


public db_selectMapButtons()
{
	decl String:szQuery[1024];       
	Format(szQuery, 1024, sql_selectMapButtons, g_szMapName);
	SQL_TQuery(g_hDb, sql_ViewMapButtonsCallback, szQuery,DBPrio_Low);
}

public sql_ViewMapButtonsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new Float:StartCords[3];
		new Float:CordsSprite[3];
		new Float:EndCords[3];
		new Float:Angs[3];
		new Float: angstart;
		new Float: angend;
		Angs[0]=0.0;
		Angs[2]=0.0;
		StartCords[0] = SQL_FetchFloat(hndl, 0);
		StartCords[1] = SQL_FetchFloat(hndl, 1);
		StartCords[2] = SQL_FetchFloat(hndl, 2);
		EndCords[0] = SQL_FetchFloat(hndl, 3);
		EndCords[1] = SQL_FetchFloat(hndl, 4);
		EndCords[2] = SQL_FetchFloat(hndl, 5);	
		angstart = SQL_FetchFloat(hndl, 6);	
		angend = SQL_FetchFloat(hndl, 7);

		new Float:angstartbutton = angstart+180.0;
		new Float:angendbutton = angend+180.0;
		
		//STARTBUTTON
		if (StartCords[0] != -1.0 && StartCords[1] != -1.0 && StartCords[2] != -1.0)
		{
			new ent = CreateEntityByName("prop_physics_override");
			if (ent != -1)
			{  
				Angs[1]=angstartbutton;
				DispatchKeyValue(ent, "model", "models/props/switch001.mdl");
				DispatchKeyValue(ent, "spawnflags", "264");
				DispatchKeyValue(ent, "targetname","climb_startbuttonx");
				DispatchSpawn(ent);   
				TeleportEntity(ent, StartCords, Angs, NULL_VECTOR);
				g_fStartButtonPos = StartCords;
				SDKHook(ent, SDKHook_UsePost, OnUsePost);		
			}
			if (angstart != -1.0)
			{
				Angs[1]=angstart;
				new spritestart = CreateEntityByName("env_sprite"); 
				if(spritestart != -1) 
				{ 
					DispatchKeyValue(spritestart, "classname", "env_sprite");
					DispatchKeyValue(spritestart, "spawnflags", "1");
					DispatchKeyValue(spritestart, "scale", "0.2");
					DispatchKeyValue(spritestart, "model", "materials/models/props/startcksurf.vmt"); 
					DispatchKeyValue(spritestart, "targetname", "starttimersign");
					DispatchKeyValue(spritestart, "rendermode", "1");
					DispatchKeyValue(spritestart, "framerate", "0");
					DispatchKeyValue(spritestart, "HDRColorScale", "1.0");
					DispatchKeyValue(spritestart, "rendercolor", "255 255 255");
					DispatchKeyValue(spritestart, "renderamt", "255");
					DispatchSpawn(spritestart);
					CordsSprite = StartCords;
					CordsSprite[2]+=95;
					TeleportEntity(spritestart, CordsSprite, Angs, NULL_VECTOR);
				}	
			}		
		}
		//ENDBUTTON
		if (EndCords[0] != -1.0 && EndCords[1] != -1.0 && EndCords[2] != -1.0)
		{		
			new ent2 = CreateEntityByName("prop_physics_override");
			if (ent2 != -1)
			{  
				Angs[1]=angendbutton;
				DispatchKeyValue(ent2, "model", "models/props/switch001.mdl");
				DispatchKeyValue(ent2, "spawnflags", "264");
				DispatchKeyValue(ent2, "targetname","climb_endbuttonx");
				DispatchSpawn(ent2);   
				TeleportEntity(ent2, EndCords, Angs, NULL_VECTOR);
				g_fEndButtonPos = EndCords;
				SDKHook(ent2, SDKHook_UsePost, OnUsePost);		
			}
			if (angend != -1.0)
			{
				Angs[1]=angend;
				new spritestop = CreateEntityByName("env_sprite");
				if(spritestop != -1) 
				{ 
					DispatchKeyValue(spritestop, "classname", "env_sprite");
					DispatchKeyValue(spritestop, "spawnflags", "1");
					DispatchKeyValue(spritestop, "scale", "0.2");
					DispatchKeyValue(spritestop, "model", "materials/models/props/stopcksurf.vmt"); 
					DispatchKeyValue(spritestop, "targetname", "stoptimersign");
					DispatchKeyValue(spritestop, "rendermode", "1");
					DispatchKeyValue(spritestop, "framerate", "0");
					DispatchKeyValue(spritestop, "HDRColorScale", "1.0");
					DispatchKeyValue(spritestop, "rendercolor", "255 255 255");
					DispatchKeyValue(spritestop, "renderamt", "255");	
					DispatchSpawn(spritestop);
					CordsSprite = EndCords;
					CordsSprite[2]+=95;
					TeleportEntity(spritestop, CordsSprite, Angs, NULL_VECTOR);
				}	
			}	
		}
	}
}


public db_updateMapButtons(Float:loc0, Float:loc1, Float:loc2, Float:ang0, index)
{
	decl String:szQuery[255];
	new Handle:pack = CreateDataPack();
	WritePackFloat(pack, loc0);
	WritePackFloat(pack, loc1);
	WritePackFloat(pack, loc2);
	WritePackFloat(pack, ang0);
	WritePackCell(pack, index);
	Format(szQuery, 255, sql_selectMapButtons, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectMapButtonsCallback, szQuery, pack,DBPrio_Low);
}

public SQL_selectMapButtonsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	decl String:szQuery[512];
	new Handle:pack = data;
	ResetPack(pack);
	new Float:loc0 = ReadPackFloat(pack);
	new Float:loc1 = ReadPackFloat(pack);
	new Float:loc2 = ReadPackFloat(pack);
	new Float:ang0 = ReadPackFloat(pack);
	new index = ReadPackCell(pack);
	CloseHandle(pack);
	
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if (index==0)
			Format(szQuery, 512, sql_updateMapButtonsStart, loc0,loc1,loc2,ang0, g_szMapName);
		else
			Format(szQuery, 512, sql_updateMapButtonsEnd, loc0,loc1,loc2,ang0, g_szMapName);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
	}
	else
	{
		if (index==0)
			Format(szQuery, 512, sql_insertMapButtons, g_szMapName,loc0,loc1,loc2,-1.0,-1.0,-1.0,ang0,-1.0);
		else
			Format(szQuery, 512, sql_insertMapButtons, g_szMapName,-1.0,-1.0,-1.0,loc0,loc1,loc2,-1.0,ang0);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
	}
}


public db_deleteMapButtons(String:szMapName[128])
{
	decl String:szQuery[256];
	Format(szQuery, 256, sql_deleteMapButtons, g_szMapName); 
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
}
















///////////////////////
//// Checkpoints //////
///////////////////////

public db_viewCheckpoints(client, String:szSteamID[32], String:szMapName[128])
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectCheckpoints, szSteamID, szMapName);
	SQL_TQuery(g_hDb, SQL_selectCheckpointsCallback, szQuery, client, DBPrio_Low);
}

public SQL_selectCheckpointsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
	new client = data;
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new k = 2;
		for (new i = 0; i < 20; i++) {
			g_fCheckpointTimesRecord[client][i] = SQL_FetchFloat(hndl, k);
			k++;
		}
	}
}

public db_UpdateCheckpoints(client, String:szSteamID[32])
{
	decl Float:total, Float:current;
	for (new i = 0; i < 20; i++) {
		total += g_fCheckpointTimesRecord[client][i];
		current += g_fCheckpointTimesNew[client][i];
	}
	
	if (total > 1.0 && current > 1.0)
	{
		decl String:szQuery[1024];
		Format(szQuery, 1024, sql_updateCheckpoints, g_fCheckpointTimesNew[client][0], g_fCheckpointTimesNew[client][1], g_fCheckpointTimesNew[client][2], g_fCheckpointTimesNew[client][3], g_fCheckpointTimesNew[client][4], g_fCheckpointTimesNew[client][5], g_fCheckpointTimesNew[client][6], g_fCheckpointTimesNew[client][7], g_fCheckpointTimesNew[client][8], g_fCheckpointTimesNew[client][9], g_fCheckpointTimesNew[client][10], g_fCheckpointTimesNew[client][11], g_fCheckpointTimesNew[client][12], g_fCheckpointTimesNew[client][13], g_fCheckpointTimesNew[client][14], g_fCheckpointTimesNew[client][15], g_fCheckpointTimesNew[client][16], g_fCheckpointTimesNew[client][17], g_fCheckpointTimesNew[client][18], g_fCheckpointTimesNew[client][19], szSteamID, g_szMapName);
		SQL_TQuery(g_hDb, SQL_updateCheckpointsCallback, szQuery, client, DBPrio_Low);
	}
	else 
		if (current > 1.0)
		{
			decl String:szQuery[1024];
			Format(szQuery, 1024, sql_insertCheckpoints, szSteamID, g_szMapName, g_fCheckpointTimesNew[client][0], g_fCheckpointTimesNew[client][1], g_fCheckpointTimesNew[client][2], g_fCheckpointTimesNew[client][3], g_fCheckpointTimesNew[client][4], g_fCheckpointTimesNew[client][5], g_fCheckpointTimesNew[client][6], g_fCheckpointTimesNew[client][7], g_fCheckpointTimesNew[client][8], g_fCheckpointTimesNew[client][9], g_fCheckpointTimesNew[client][10], g_fCheckpointTimesNew[client][11], g_fCheckpointTimesNew[client][12], g_fCheckpointTimesNew[client][13], g_fCheckpointTimesNew[client][14], g_fCheckpointTimesNew[client][15], g_fCheckpointTimesNew[client][16], g_fCheckpointTimesNew[client][17], g_fCheckpointTimesNew[client][18], g_fCheckpointTimesNew[client][19]);
			SQL_TQuery(g_hDb, SQL_insertCheckpointsCallback, szQuery, client, DBPrio_Low);
		}
}

public SQL_updateCheckpointsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
	new client = data;
	db_viewCheckpoints(client, g_szSteamID[client], g_szMapName);
}

public SQL_insertCheckpointsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
	new client = data;
	db_viewCheckpoints(client, g_szSteamID[client], g_szMapName);
}

public db_deleteCheckpoints()
{
	decl String:szQuery[258];
	Format(szQuery, 258, sql_deleteCheckpoints, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteCheckpointsCallback, szQuery, 1, DBPrio_Low);
}

public SQL_deleteCheckpointsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
}















//////////////////////
//// MapTier /////////
//////////////////////

public db_selectMapTier()
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectMapTier, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectMapTierCallback, szQuery, 1, DBPrio_Low);
}

public db_deleteAllMaptiers(client)
{
	decl String:szQuery[128];
	Format(szQuery, 128, sql_deleteAllMapTiers);
	SQL_TQuery(g_hDb, SQL_deleteAllMapTiersCallback, szQuery, client, DBPrio_Low);
}

public SQL_deleteAllMapTiersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
	new client = data;
	Admin_InsertMapTierstoDatabase(client);
}


public SQL_selectMapTierCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		new tier = 0;
		tier = SQL_FetchInt(hndl, 1);
		if (tier == 0)
		{
				g_bTierFound = false;
		}
		else 
		{
			g_bTierFound = true;
			Format(g_sTierString, sizeof(g_sTierString), " %cMap: %c%s %c| ", GREEN, LIMEGREEN, g_szMapName, GREEN);
			switch(tier) {
				case 1: Format(g_sTierString, sizeof(g_sTierString), "%s%cTier %i %c| ", g_sTierString, GRAY, tier, GREEN);
				case 2: Format(g_sTierString, sizeof(g_sTierString), "%s%cTier %i %c| ", g_sTierString, LIGHTBLUE, tier, GREEN);
				case 3: Format(g_sTierString, sizeof(g_sTierString), "%s%cTier %i %c| ", g_sTierString, BLUE, tier, GREEN);
				case 4: Format(g_sTierString, sizeof(g_sTierString), "%s%cTier %i %c| ", g_sTierString, DARKBLUE, tier, GREEN);
				case 5: Format(g_sTierString, sizeof(g_sTierString), "%s%cTier %i %c| ", g_sTierString, RED, tier, GREEN);
				case 6: Format(g_sTierString, sizeof(g_sTierString), "%s%cTier %i %c| ", g_sTierString, DARKRED, tier, GREEN);
				default: Format(g_sTierString, sizeof(g_sTierString), "%s%cTier %i %c| ", g_sTierString, GRAY, tier, GREEN);
			}
			if (g_mapZonesTypeCount[3]>0)
			{
				if (g_mapZonesTypeCount[5] > 0)
					Format(g_sTierString, sizeof(g_sTierString), "%s%c%i Stages %c| ", g_sTierString, MOSSGREEN, (g_mapZonesTypeCount[5]+1), GREEN);
				else
					Format(g_sTierString, sizeof(g_sTierString), "%s%cLinear %c| ", g_sTierString, LIMEGREEN, GREEN);

				Format(g_sTierString, sizeof(g_sTierString), "%s%cBonus", g_sTierString, YELLOW);
			}
			else
			{
				if (g_mapZonesTypeCount[5] > 0)
					Format(g_sTierString, sizeof(g_sTierString), "%s%c%i Stages", g_sTierString, MOSSGREEN, (g_mapZonesTypeCount[5]+1));
				else
					Format(g_sTierString, sizeof(g_sTierString), "%s%cLinear", g_sTierString, LIMEGREEN);
			}
		}
	}
	else 
		g_bTierFound = false;
}
















/////////////////////
//// SQL Bonus //////
/////////////////////


public db_viewMapRankBonus(client)
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectPlayerRankBonus, g_szSteamID[client], g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, db_viewMapRankBonusCallback, szQuery, client, DBPrio_Low);
}

public db_viewMapRankBonusCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_MapRankBonus[client] = SQL_FetchInt(hndl, 0);
	}	
	else
	{
		PrintToServer("ERROR getting rank: %s", error); 
		g_MapRankBonus[client] = 9999999;
	}	
	if (g_MapRankBonus[client] == 0)
	{
		g_MapRankBonus[client] = 9999999;
	}
	db_viewBonusTotalCount();
} 

public db_viewMapRankBonus2(client)
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectPlayerRankBonus, g_szSteamID[client], g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, db_viewMapRankBonusCallback2, szQuery, client, DBPrio_Low);
}


public db_viewMapRankBonusCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_MapRankBonus[client] = SQL_FetchInt(hndl, 0);
	}	
	else
	{
		PrintToServer("ERROR getting rank: %s", error); 
		g_MapRankBonus[client] = 9999999;
	}	
	if (g_MapRankBonus[client] == 0)
	{
		g_MapRankBonus[client] = 9999999;
	}
} 


public sql_CountFinishedBonusCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl bonuses;
	decl String:szQuery[512];   
	decl String:szSteamId[32];	
	if (client>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else
	{
		if (IsValidClient(client))
			GetClientAuthString(client, szSteamId, 32);
		else
			return;
	}
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{	
		bonuses = SQL_FetchInt(hndl, 0);
		g_pr_points[client]+=(bonuses * 150); // BONUS
	}
	Format(szQuery, 512, sql_CountFinishedMaps, szSteamId);  
	SQL_TQuery(g_hDb, sql_CountFinishedMapsCallback, szQuery, client, DBPrio_Low);
}

public	db_viewPersonalBonusRecords(client, String:szSteamId[32])
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectPersonalBonusRecords, szSteamId, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectPersonalBonusRecordsCallback, szQuery, client, DBPrio_Low);
}

public db_viewFastestBonus()
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectFastestBonus, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectFastestBonusCallback, szQuery, 1, DBPrio_High);
}

public db_deleteBonus()
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_deleteBonus, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteBonusCallback, szQuery, 1, DBPrio_Low);
}
public db_viewBonusTotalCount()
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectBonusCount, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectBonusTotalCountCallback, szQuery, 1, DBPrio_Low);
}
	
public db_insertBonus(client, String:szSteamId[32], String:szName[32], Float:FinalTime)
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_insertBonus, szSteamId, szName, g_szMapName, FinalTime);
	SQL_TQuery(g_hDb, SQL_insertBonusCallback, szQuery, client, DBPrio_Low);
}

public db_updateBonus(client, String:szSteamId[32], String:szName[32], Float:FinalTime)
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_updateBonus, FinalTime, szName, szSteamId, g_szMapName);
	SQL_TQuery(g_hDb, SQL_updateBonusCallback, szQuery, client, DBPrio_Low);
}


public SQL_updateBonusCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	for (new i = 1; i<=MAXPLAYERS; i++)
	{
		if (IsValidClient(i) && g_fPersonalRecordBonus[i] > 0.0)
			db_viewMapRankBonus2(i);
	}
	CalculatePlayerRank(client);
}

public SQL_deleteBonusCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
}

public SQL_insertBonusCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	for (new i = 1; i<=MAXPLAYERS; i++)
	{
		if (IsValidClient(i) && g_fPersonalRecordBonus[i]>0.0)
			db_viewMapRankBonus2(i);
	}
	CalculatePlayerRank(client);
}	

public SQL_selectFastestBonusCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, szBonusFastest, 54);
		g_fBonusFastest = SQL_FetchFloat(hndl, 0);
		FormatTimeFloat(1, g_fBonusFastest, 3, szBonusFastestTime, sizeof(szBonusFastestTime));
	} 
	else 
	{
		PrintToServer("Error getting fastest time: %s", error);
		g_fBonusFastest = 9999999.0;
	}
	
	if (g_fBonusFastest == 0.0)
		g_fBonusFastest = 9999999.0;
}

public SQL_selectBonusTotalCountCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_iBonusCount = SQL_FetchInt(hndl, 0);
	} 
	else
	{
		g_iBonusCount = 0;
	}
	db_viewFastestBonus();
}

public SQL_selectPersonalBonusRecordsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	g_fPersonalRecordBonus[client] = 0.0;
	
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalRecordBonus[client] = SQL_FetchFloat(hndl, 0);
		
		if (g_fPersonalRecordBonus[client] > 0.0) 
		{
			//g_bFinishedBonus[client] = true;
			FormatTimeFloat(client, g_fPersonalRecordBonus[client], 3, g_szPersonalRecordBonus[client], 32);
			db_viewMapRankBonus(client);
		}
		else
		{
			g_fPersonalRecordBonus[client] = 0.0;
		}
	}
}


public db_selectBonusCount()
{
	decl String:szQuery[258];
	Format(szQuery, 258, sql_selectTotalBonusCount);
	SQL_TQuery(g_hDb, SQL_selectBonusCountCallback, szQuery, 1, DBPrio_Low);
}

public SQL_selectBonusCountCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		new String:mapName[128];
		new String:mapName2[128]
		g_totalBonusCount = 0;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, mapName2, 128); 
			for (new i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, mapName, 128);
				if (StrEqual(mapName, mapName2, false))
					g_totalBonusCount++;
			}
		}
	}
	else
	{
		g_totalBonusCount = 0;
	}
}














////////////////////////////
//// SQL Zones /////////////
////////////////////////////

public db_deleteAllZones(client)
{
	decl String:szQuery[128];
	Format(szQuery, 128, sql_deleteAllZones);
	PrintToChatAll("db_deleteAllZones");
	SQL_TQuery(g_hDb, SQL_deleteAllZonesCallback, szQuery, client, DBPrio_Low);
}

public SQL_deleteAllZonesCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	PrintToChatAll("Callback");
	new client = data;
	Admin_InsertZonestoDatabase(client);
}

public db_insertZone(zoneid, zonetype, zonetypeid, Float:pointax, Float:pointay, Float:pointaz, Float:pointbx, Float:pointby, Float:pointbz, vis, team)
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_insertZones, g_szMapName, zoneid, zonetype, zonetypeid, pointax, pointay, pointaz, pointbx, pointby, pointbz, vis, team);
	SQL_TQuery(g_hDb, SQL_insertZonesCallback, szQuery, 1, DBPrio_Low);
}

public SQL_insertZonesCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	db_selectMapZones();
}

public db_saveZones()
{
	decl String:szQuery[258];
	Format(szQuery, 258, sql_deleteMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_saveZonesCallBack, szQuery, 1, DBPrio_Low);
}

public SQL_saveZonesCallBack(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	for(new i = 0; i < g_mapZonesCount; i++)
	{
		if (g_mapZones[i][PointA][0] != -1.0 && g_mapZones[i][PointA][1]  != -1.0 && g_mapZones[i][PointA][2] != -1.0 )
			db_insertZone(g_mapZones[i][zoneId], g_mapZones[i][zoneType], g_mapZones[i][zoneTypeId], g_mapZones[i][PointA][0], g_mapZones[i][PointA][1], g_mapZones[i][PointA][2], g_mapZones[i][PointB][0], g_mapZones[i][PointB][1], g_mapZones[i][PointB][2], g_mapZones[i][Vis], g_mapZones[i][Team]);
	}
	db_selectMapZones();
}

public db_updateZone(zoneid, zonetype, zonetypeid, Float:Point1[], Float:Point2[], vis, team)
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_updateZone, zonetype, zonetypeid, Point1[0], Point1[1], Point1[2], Point2[0], Point2[1], Point2[2], vis, team, zoneid, g_szMapName);
	SQL_TQuery(g_hDb, SQL_updateZoneCallback, szQuery, 1, DBPrio_Low);
}

public SQL_updateZoneCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	db_selectMapZones();
}

public db_selectzoneTypeIds(zonetype, client)
{
	decl String:szQuery[1024];
	Format(szQuery, 1024, sql_selectzoneTypeIds, g_szMapName, zonetype);
	SQL_TQuery(g_hDb, SQL_selectzoneTypeIdsCallback, szQuery, client, DBPrio_Low);
}

public SQL_selectzoneTypeIdsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		new client = data;
		new availableids[128] = {0, ...}, i;
		while (SQL_FetchRow(hndl))
		{
			i = SQL_FetchInt(hndl, 0);
			if (i < 128)
				availableids[i] = 1;
		}

		new Handle:TypeMenu = CreateMenu(Handle_EditZoneTypeId);
		decl String:MenuNum[24], String:MenuInfo[6], String:MenuItemName[24];
		new x = 0;
		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
		switch (g_CurrentZoneType[client]) {
			case 0: Format(MenuItemName, 24, "Stop");
			case 1: Format(MenuItemName, 24, "Start");
			case 2: Format(MenuItemName, 24, "End");
			case 3: Format(MenuItemName, 24, "BonusStart");
			case 4: Format(MenuItemName, 24, "BonusEnd");
			case 5:{
					Format(MenuItemName, 24, "Stage");
					x = 2;
			}
			case 6: Format(MenuItemName, 24, "Checkpoint");
			case 7: Format(MenuItemName, 24, "Speed");
			case 8: Format(MenuItemName, 24, "TeleToStart");
			case 9: Format(MenuItemName, 24, "Validator");
			case 10: Format(MenuItemName, 24, "Checker");
			default: Format(MenuItemName, 24, "Unknown");
		}

		for (new k = 0; k<30; k++)
		{
			if (availableids[k] == 0)
			{
				Format(MenuNum, sizeof(MenuNum), "%s-%i", MenuItemName, (k+x));
				Format(MenuInfo, sizeof(MenuInfo), "%i", k);
				AddMenuItem(TypeMenu, MenuInfo, MenuNum);
			}
		}

		SetMenuExitBackButton(TypeMenu, true);
		ckSurf_StopUpdatingOfClimbersMenu(client);
		DisplayMenu(TypeMenu, client, MENU_TIME_FOREVER);
	}
}


public db_selectMapZones()
{
	decl String:szQuery[258];
	Format(szQuery, 258, sql_selectMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectMapZonesCallback, szQuery, 1, DBPrio_Low);
}

public SQL_selectMapZonesCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
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

		for(new k = 0; k<10; k++)
			g_mapZonesTypeCount[k] = 0;
		
		while (SQL_FetchRow(hndl))
		{
			g_mapZones[g_mapZonesCount][zoneId] = SQL_FetchInt(hndl, 1);
			g_mapZones[g_mapZonesCount][zoneType] = SQL_FetchInt(hndl, 2);
			g_mapZones[g_mapZonesCount][zoneTypeId] = SQL_FetchInt(hndl, 3);
			g_mapZones[g_mapZonesCount][PointA][0] = SQL_FetchFloat(hndl, 4);
			g_mapZones[g_mapZonesCount][PointA][1] = SQL_FetchFloat(hndl, 5);
			g_mapZones[g_mapZonesCount][PointA][2] = SQL_FetchFloat(hndl, 6);	
			g_mapZones[g_mapZonesCount][PointB][0] = SQL_FetchFloat(hndl, 7);
			g_mapZones[g_mapZonesCount][PointB][1] = SQL_FetchFloat(hndl, 8);
			g_mapZones[g_mapZonesCount][PointB][2] = SQL_FetchFloat(hndl, 9);

			switch(g_mapZones[g_mapZonesCount][zoneType]) 
			{
				case 1:	{
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "Start-%i", g_mapZones[g_mapZonesCount][zoneTypeId]); 
							g_mapZonesTypeCount[1]++;
						} 
				case 2: {
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "End-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							g_mapZonesTypeCount[2]++;
						}
				case 3:	{
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "BonusStart-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							g_mapZonesTypeCount[3]++;
						} 
				case 4: {
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "BonusEnd-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							g_mapZonesTypeCount[4]++;
						} 
				case 5: {
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "Stage-%i", (2+g_mapZones[g_mapZonesCount][zoneTypeId]));
							g_mapZonesTypeCount[5]++;
						}	
				case 6:	{
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "Checkpoint-%i", (1+g_mapZones[g_mapZonesCount][zoneTypeId]));
							g_mapZonesTypeCount[6]++;
						} 
				case 7:	{
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "Speed-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							g_mapZonesTypeCount[7]++;
						} 
				case 0: {
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "Stop-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							g_mapZonesTypeCount[0]++;
						}
				case 8: {
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "TeleToStart-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							g_mapZonesTypeCount[8]++;
						}
				case 9: {
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "Validator-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							g_mapZonesTypeCount[9]++;
						}
				case 10:
						{
							Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "Checker-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							g_mapZonesTypeCount[10]++;
						}
				case -1: LogError("ZoneId out of sync");
				default: Format(g_mapZones[g_mapZonesCount][ZoneName], 32, "Unknown", g_mapZones[g_mapZonesCount][zoneTypeId]);
			}
			if (g_mapZones[g_mapZonesCount][zoneType] == 5)
			g_mapZones[g_mapZonesCount][Vis] = SQL_FetchInt(hndl, 10);
			g_mapZones[g_mapZonesCount][Team] = SQL_FetchInt(hndl, 11);
			g_mapZonesCount++;
		}
		Format(g_szTotalStages, 12, "%i", (g_mapZonesTypeCount[5]+1));
		RefreshZones();
	}
	db_selectMapTier();
}

public db_deleteMapZones()
{
	decl String:szQuery[258];
	Format(szQuery, 258, sql_deleteMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteMapZonesCallback, szQuery, 1, DBPrio_Low);
}

public SQL_deleteMapZonesCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
}

public db_deleteZone(zoneid)
{
	decl String:szQuery[258];
	Format(szQuery, 258, sql_deleteZone, g_szMapName, zoneid);
	SQL_TQuery(g_hDb, SQL_deleteZoneCallback, szQuery, 1, DBPrio_Low);
}

public SQL_deleteZoneCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{	
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	RefreshZones();
}














///////////////////////
//// MISC /////////////
///////////////////////


public db_insertLastPosition(client, String:szMapName[128])
{	 
	if(g_bRestore && !g_bRoundEnd && (StrContains(g_szSteamID[client], "STEAM_") != -1) && g_bTimeractivated[client])
	{
		new Handle:pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szMapName);
		WritePackString(pack, g_szSteamID[client]);
		decl String:szQuery[512]; 
		Format(szQuery, 512, "SELECT * FROM playertmp WHERE steamid = '%s'",g_szSteamID[client]);
		SQL_TQuery(g_hDb,db_insertLastPositionCallback,szQuery,pack,DBPrio_Low);
	}
}

public db_insertLastPositionCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	decl String:szQuery[1024]; 
	decl String:szMapName[128]; 
	decl String:szSteamID[32]; 
	new Handle:pack = data;
	ResetPack(pack);
	new client = ReadPackCell(pack);      
	ReadPackString(pack, szMapName, 128);	
	ReadPackString(pack, szSteamID, 32);	
	CloseHandle(pack);		
	if (1 <= client <= MaxClients)
	{
		if (!g_bTimeractivated[client])
			g_fPlayerLastTime[client] = -1.0;
		new tickrate = g_Server_Tickrate * 5 * 11;
		if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			if (g_bTmpBonusTimer[client])
				Format(szQuery, 1024, sql_updatePlayerTmp, g_fPlayerCordsLastPosition[client][0],g_fPlayerCordsLastPosition[client][1],g_fPlayerCordsLastPosition[client][2],g_fPlayerAnglesLastPosition[client][0],g_fPlayerAnglesLastPosition[client][1],g_fPlayerAnglesLastPosition[client][2], g_fPlayerLastTime[client], szMapName, tickrate, 1, tmpStage[client],szSteamID);
			else
				Format(szQuery, 1024, sql_updatePlayerTmp, g_fPlayerCordsLastPosition[client][0],g_fPlayerCordsLastPosition[client][1],g_fPlayerCordsLastPosition[client][2],g_fPlayerAnglesLastPosition[client][0],g_fPlayerAnglesLastPosition[client][1],g_fPlayerAnglesLastPosition[client][2], g_fPlayerLastTime[client], szMapName, tickrate, 0, tmpStage[client], szSteamID);
			SQL_TQuery(g_hDb,SQL_CheckCallback,szQuery,DBPrio_Low);	
		}
		else
		{
			if (g_bTmpBonusTimer[client])
				Format(szQuery, 1024, sql_insertPlayerTmp, g_fPlayerCordsLastPosition[client][0],g_fPlayerCordsLastPosition[client][1],g_fPlayerCordsLastPosition[client][2],g_fPlayerAnglesLastPosition[client][0],g_fPlayerAnglesLastPosition[client][1],g_fPlayerAnglesLastPosition[client][2], g_fPlayerLastTime[client],szSteamID, szMapName,tickrate, 1, tmpStage[client]);
			else
				Format(szQuery, 1024, sql_insertPlayerTmp, g_fPlayerCordsLastPosition[client][0],g_fPlayerCordsLastPosition[client][1],g_fPlayerCordsLastPosition[client][2],g_fPlayerAnglesLastPosition[client][0],g_fPlayerAnglesLastPosition[client][1],g_fPlayerAnglesLastPosition[client][2], g_fPlayerLastTime[client],szSteamID, szMapName,tickrate, 0, tmpStage[client]);
			SQL_TQuery(g_hDb,SQL_CheckCallback,szQuery,DBPrio_Low);
		}
	}
}

public db_deletePlayerTmps()
{	 
	decl String:szQuery[64]; 
	Format(szQuery, 64, "delete FROM playertmp");
	SQL_TQuery(g_hDb,SQL_CheckCallback,szQuery,DBPrio_Low);	
}

public db_ViewLatestRecords(client)
{
	SQL_TQuery(g_hDb, sql_selectLatestRecordsCallback, sql_selectLatestRecords, client,DBPrio_Low);
}

public sql_selectLatestRecordsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl String:szName[64];
	decl String:szMapName[64];
	decl String:szDate[64];
	decl String:szTime[32];
	new Float: ftime;
	PrintToConsole(client, "----------------------------------------------------------------------------------------------------");
	PrintToConsole(client,"Last map records:");
	if(SQL_HasResultSet(hndl))
	{		
		new i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			ftime = SQL_FetchFloat(hndl, 1); 
			FormatTimeFloat(client, ftime, 3,szTime,sizeof(szTime));
			SQL_FetchString(hndl, 2, szMapName, 64);
			SQL_FetchString(hndl, 3, szDate, 64);
			PrintToConsole(client,"%s: %s on %s - Time %s",szDate,szName, szMapName, szTime);
			i++;
		}
		if (i==1)
			PrintToConsole(client,"No records found.");	
	}
	else
		PrintToConsole(client,"No records found.");
	PrintToConsole(client, "----------------------------------------------------------------------------------------------------");
	PrintToChat(client, "[%cCK%c] See console for output!", MOSSGREEN,WHITE);	
}

			
public db_InsertLatestRecords(String:szSteamID[32], String:szName[32], Float: FinalTime)
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_insertLatestRecords, szSteamID, szName, FinalTime, g_szMapName); 
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
}

public GetDBName(client, String:szSteamId[32])
{
	decl String:szQuery[512];      
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId); 
	SQL_TQuery(g_hDb, GetDBNameCallback, szQuery, client,DBPrio_Low);
}

public GetDBNameCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, g_szProfileName[client], MAX_NAME_LENGTH);	
		db_viewPlayerAll(client, g_szProfileName[client]);
	}
}

public db_CalcAvgRunTime()
{
	decl String:szQuery[256];  
	Format(szQuery, 256, "select runtimepro from playertimes where mapname = '%s'", g_szMapName);
	SQL_TQuery(g_hDb, SQL_db_CalcAvgRunTimeCallback, szQuery, DBPrio_Low);
}

public SQL_db_CalcAvgRunTimeCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	g_favg_maptime = 0.0;
	if(SQL_HasResultSet(hndl))
	{
		new rowcount = SQL_GetRowCount(hndl);
		new i, protimes;
		new  Float:ProTime;	
		while (SQL_FetchRow(hndl))
		{
			new Float:pro = SQL_FetchFloat(hndl, 0);
			if (pro > 0.0)
			{
				ProTime += pro;
				protimes++;
			}			
			i++;
			if (rowcount == i)
			{
				g_favg_maptime = ProTime / protimes;
			}
		}
	}
}

public db_GetDynamicTimelimit()
{
	if (!g_bDynamicTimelimit)
		return;
	decl String:szQuery[256];  
	Format(szQuery, 256, "select runtime, runtimepro from playertimes where mapname = '%s'", g_szMapName);
	SQL_TQuery(g_hDb, SQL_db_GetDynamicTimelimitCallback, szQuery, DBPrio_Low);
}

public SQL_db_GetDynamicTimelimitCallback(Handle:owner, Handle:hndl, const String:error[], any:data) 
{   
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		new rowcount = SQL_GetRowCount(hndl);
		new i, maptimes;
		new Float:total = 0.0,Float:TpTime,Float:ProTime;	
		while (SQL_FetchRow(hndl))
		{
			
			TpTime = SQL_FetchFloat(hndl, 0);
			ProTime = SQL_FetchFloat(hndl, 1);
			if (TpTime > 0.0 || ProTime > 0.0)
			{
				if (TpTime > 0.0 && ProTime > 0.0)
					total += ((TpTime+ProTime)/2);
				else
					if (TpTime > 0.0)
						total += TpTime;
					else
						total += ProTime;
				maptimes++;
			}
			i++;
			if (rowcount == i)
			{
				//requires min. 5 map times
				if (maptimes > 5)
				{				
					new scale_factor = 3;
					new avg = RoundToNearest((total) / float(60) / float(maptimes)); ////output: x min
			
					//scale factor
					if (avg <= 10) 
						scale_factor = 5;
					if (avg <= 5) 
						scale_factor = 8;
					if (avg <= 3)
						scale_factor = 10;
					if (avg <= 2)
						scale_factor = 12;
					if (avg <= 1)
						scale_factor = 14;			
					avg = avg * scale_factor;
				
					//timelimit: min 20min, max 180min
					if (avg < 20)
						avg = 20;
					if (avg > 150)
						avg = 150;
						
					//set timelimit
					decl String:szTimelimit[32];
					Format(szTimelimit,32,"mp_timelimit %i;mp_roundtime %i", avg, avg);
					ServerCommand(szTimelimit);
					ServerCommand("mp_restartgame 1");
				}
			}
		}
	}
}

public db_CalculatePlayerCount()
{
	decl String:szQuery[255];
	Format(szQuery, 255, sql_CountRankedPlayers);      
	SQL_TQuery(g_hDb, sql_CountRankedPlayersCallback, szQuery,DBPrio_Low);

	//get amount of players with actual player points
	db_CalculatePlayersCountGreater0();
}

public db_CalculatePlayersCountGreater0()
{
	decl String:szQuery[255];
	Format(szQuery, 255, sql_CountRankedPlayers2);      
	SQL_TQuery(g_hDb, sql_CountRankedPlayers2Callback, szQuery,DBPrio_Low);
}



public sql_CountRankedPlayersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_pr_AllPlayers = SQL_FetchInt(hndl, 0);
	}
	else
		g_pr_AllPlayers=1;	
}

public sql_CountRankedPlayers2Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_pr_RankedPlayers = SQL_FetchInt(hndl, 0);
	}
	else
		g_pr_RankedPlayers=0;	
}


public db_ClearLatestRecords()
{
	if(g_DbType == MYSQL)
		SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM LatestRecords WHERE date < NOW() - INTERVAL 1 WEEK", DBPrio_Low);
	else
		SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM LatestRecords WHERE date <= date('now','-7 day')", DBPrio_Low);
}

public db_viewUnfinishedMaps(client, String:szSteamId[32])
{
	decl String:szQuery[1024];       
	new String:map[128];
	for (new i = 0; i < GetArraySize(g_MapList); i++)
	{
		GetArrayString(g_MapList, i, map, sizeof(map));
		Format(szQuery, 1024, sql_selectRecord, szSteamId, map);  
		new Handle:pack = CreateDataPack();			
		WritePackString(pack, map);
		WritePackCell(pack, client);
		SQL_TQuery(g_hDb, db_viewUnfinishedMapsCallback, szQuery, pack,DBPrio_Low);
	}	
	if (IsValidClient(client))
	{
		PrintToConsole(client," ");
		PrintToConsole(client,"-------------");
		PrintToConsole(client,"Unfinished Maps");
		PrintToConsole(client,"SteamID: %s", szSteamId);
		PrintToConsole(client,"-------------");
		PrintToConsole(client," ");
		PrintToChat(client, "%t", "ConsoleOutput", LIMEGREEN,WHITE); 	
		ProfileMenu(client, -1);
	}
}

public db_viewUnfinishedMapsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new Handle:pack = data;
	ResetPack(pack);
	decl String:szMap[128];
	ReadPackString(pack, szMap, 128);
	new client = ReadPackCell(pack);
	new Float:protime;
	CloseHandle(pack);
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		protime = SQL_FetchFloat(hndl, 1);
		if (protime <= 0.0)
			PrintToConsole(client, "%s ",szMap);
	}
	else
	{
		if (IsValidClient(client))
			PrintToConsole(client, "%s \n",szMap);
	}
}

public db_viewPlayerProfile1(client, String:szPlayerName[MAX_NAME_LENGTH])
{
	decl String:szQuery[512];
	decl String:szName[MAX_NAME_LENGTH*2+1];
	SQL_QuoteString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);    
	Format(szQuery, 512, sql_selectPlayerRankAll2, szName);
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, szPlayerName);
	SQL_TQuery(g_hDb, SQL_ViewPlayerProfile1Callback, szQuery, pack,DBPrio_Low);
}

public SQL_ViewPlayerProfile1Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new Handle:pack = data;
	ResetPack(pack);
	new client = ReadPackCell(pack);
	decl String:szPlayerName[MAX_NAME_LENGTH];
	ReadPackString(pack, szPlayerName, MAX_NAME_LENGTH);	
	CloseHandle(pack);
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{           		
		SQL_FetchString(hndl, 1, g_szProfileSteamId[client], 32);
		db_viewPlayerRank(client,g_szProfileSteamId[client]);
	}
	else
	{
		decl String:szQuery[512];
		decl String:szName[MAX_NAME_LENGTH*2+1];
		SQL_QuoteString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);      
		Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT,szName,PERCENT);
		SQL_TQuery(g_hDb, SQL_ViewPlayerProfile2Callback, szQuery, client,DBPrio_Low);		
	}
}


public sql_selectPlayerNameCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new Handle:pack = data;
	ResetPack(pack);
	new clientid = ReadPackCell(pack);
	new client = ReadPackCell(pack);
	CloseHandle(pack);
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, g_pr_szName[clientid], 64);			
		g_bProfileRecalc[clientid]=true;
		if (IsValidClient(client))
			PrintToConsole(client, "Profile refreshed (%s).", g_pr_szSteamID[clientid]);
	}
	else
		if (IsValidClient(client))
			PrintToConsole(client, "SteamID %s not found.", g_pr_szSteamID[clientid]);
}

public RefreshPlayerRankTable(max)
{
	g_pr_Recalc_ClientID=1;
	g_pr_RankingRecalc_InProgress=true;
	decl String:szQuery[255];
	Format(szQuery, 255, sql_selectRankedPlayers);      
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, max);
	SQL_TQuery(g_hDb, sql_selectRankedPlayersCallback, szQuery, pack,DBPrio_Low);
}

public sql_selectRankedPlayersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new Handle:pack = data;
	ResetPack(pack);
	new maxplayers = ReadPackCell(pack);
	CloseHandle(pack);
	if(SQL_HasResultSet(hndl))
	{	
		new i = 66;
		new x;
		g_pr_TableRowCount = SQL_GetRowCount(hndl);
		if (g_pr_TableRowCount==0)
		{
			for (new c = 1; c <= MaxClients; c++)
			if (1 <= c <= MaxClients && IsValidEntity(c) && IsValidClient(c))
			{
				if (g_bManualRecalc)
					PrintToChat(c, "%t", "PrUpdateFinished", MOSSGREEN, WHITE, LIMEGREEN);
				if (g_bTop100Refresh)
					PrintToChat(c, "%t", "Top100Refreshed", MOSSGREEN, WHITE, LIMEGREEN);
			}
			
			g_bTop100Refresh = false;
			g_bManualRecalc = false;
			g_pr_RankingRecalc_InProgress = false;
			
			if (IsValidClient(g_pr_Recalc_AdminID))
			{
				PrintToConsole(g_pr_Recalc_AdminID, ">> Recalculation finished");
				CreateTimer(0.1, RefreshAdminMenu, g_pr_Recalc_AdminID,TIMER_FLAG_NO_MAPCHANGE);
			}			
		}
		if (MAX_PR_PLAYERS != maxplayers && g_pr_TableRowCount > maxplayers)
			x = 66 + maxplayers;
		else
			x = 66 + g_pr_TableRowCount;

		if (x > MAX_PR_PLAYERS)
			x = MAX_PR_PLAYERS-1;
		if (IsValidClient(g_pr_Recalc_AdminID) && g_bManualRecalc)
		{
			new max = MAX_PR_PLAYERS-66;	
			PrintToConsole(g_pr_Recalc_AdminID, " \n>> Recalculation started! (Only Top %i because of performance reasons)",max); 
		}
		while (SQL_FetchRow(hndl))
		{	
			if (i <= x)
			{
				g_pr_points[i] = 0;
				SQL_FetchString(hndl, 0, g_pr_szSteamID[i], 32);
				SQL_FetchString(hndl, 1, g_pr_szName[i], 64);	
				PrintToServer("i = %i, x = %i",i,x);
				g_bProfileRecalc[i] = true;
				i++;
			}
			if (i == x)
			{
				CalculatePlayerRank(66);
			}
		}
	}
	else 
		PrintToConsole(g_pr_Recalc_AdminID, " \n>> No valid players found!");
}

public db_Cleanup()
{
	decl String:szQuery[255];
	
	//tmps
	Format(szQuery, 255, "DELETE FROM playertmp where mapname != '%s'", g_szMapName);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);
	
	//times
	SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM playertimes where runtime = -1.0 and runtimepro = -1.0");
}

public db_dropMap(client)
{
	SQL_LockDatabase(g_hDb);       
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropMap);
	else
		SQL_FastQuery(g_hDb, sqlite_dropMap);	
	SQL_UnlockDatabase(g_hDb);       
	PrintToConsole(client, "map buttons table dropped. Please restart your server!");
}

public db_resetMapRecords(client, String:szMapName[128])
{
	decl String:szQuery[255];      
	Format(szQuery, 255, sql_resetMapRecords, szMapName);
	SQL_TQuery(g_hDb, SQL_CheckCallback2, szQuery,DBPrio_Low);	       
	PrintToConsole(client, "player times on %s cleared.", szMapName);
	if (StrEqual(szMapName,g_szMapName))
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				Format(g_szPersonalRecord[i], 32, "NONE");
				g_fPersonalRecord[i] = 0.0;
				g_MapRank[i] = 99999;
			}
		}
	}            
}

public SQL_CheckZoneQuerySuccess(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	//	PrintToChat(client, "[%cCK%c] Map zones have been inserted into the database. Map reload required to make changes visible.", MOSSGREEN,WHITE);
	new client = data;
	g_zoneQueryNumber++;
	if (hndl == INVALID_HANDLE)
		PrintToConsole(client, "%i / %i: ERROR: Insert was NOT successful!", g_zoneQueryNumber, g_totalZoneQueries);

	if (SQL_GetAffectedRows(owner) == 0)
		PrintToConsole(client, "%i / %i: ERROR: Insert was succesful, but didnt make any changes!", g_zoneQueryNumber, g_totalZoneQueries);
	else
		if (SQL_GetAffectedRows(owner) > 0)
		{
			g_succesfullZoneQueries++;
			PrintToConsole(client, "%i / %i: Insert was succesful!", g_zoneQueryNumber, g_totalZoneQueries);
		}
	if (g_zoneQueryNumber == g_totalZoneQueries && g_succesfullZoneQueries == g_totalZoneQueries)
	{
		PrintToChat(client, "[%cCK%c] %cSuccess! %cMap zones were inserted succesfully!", MOSSGREEN, WHITE, GREEN, WHITE);
		PrintToChat(client, "[%cCK%c] Change the map or restart server to make zones appear.", MOSSGREEN, WHITE);
		PrintToConsole(client, "################# ckSurf - Inserting map zones was succesfull! #################", g_totalZoneQueries);
		g_insertingInformation = false;
	}
	else
		if (g_zoneQueryNumber == g_totalZoneQueries && g_succesfullZoneQueries != g_totalZoneQueries)
		{
			PrintToChat(client, "[%cCK%c] %cERROR: %cMap zones werenot inserted succesfully! Insert them manually from .sql files", MOSSGREEN, WHITE, RED, WHITE);
			PrintToConsole(client, "################# ckSurf - Error inserting mapzones! #################", g_totalZoneQueries);
			g_insertingInformation = false;
		}
}

public SQL_CheckTierQuerySuccess(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client = data;
	g_tierQueryNumber++;
	if (hndl == INVALID_HANDLE)
        PrintToConsole(client, "%i / %i: ERROR: Insert was NOT successful!", g_tierQueryNumber, g_totalTierQueries);

	if (SQL_GetAffectedRows(owner) == 0)
    	PrintToConsole(client, "%i / %i: ERROR: Insert was succesful, but didnt make any changes!", g_tierQueryNumber, g_totalTierQueries);
	else
		if (SQL_GetAffectedRows(owner) > 0)
		{
			g_succesfullTierQueries++;
			PrintToConsole(client, "%i / %i: Insert was succesful!", g_tierQueryNumber, g_totalTierQueries);
		}
	if (g_tierQueryNumber == g_totalTierQueries && g_succesfullTierQueries == g_totalTierQueries)
	{
		PrintToChat(client, "[%cCK%c] %cSuccess! %cMap zones were inserted succesfully!", MOSSGREEN, WHITE, GREEN, WHITE);
		PrintToChat(client, "[%cCK%c] Change the map or restart server to make zones appear.", MOSSGREEN, WHITE);
		PrintToConsole(client, "################# ckSurf - Inserting tier information was successful! #################", g_totalZoneQueries);
		g_insertingInformation = false;
	}
	else
		if (g_tierQueryNumber == g_totalTierQueries && g_succesfullTierQueries != g_totalTierQueries)
		{
			PrintToChat(client, "[%cCK%c] %cERROR: %cMap zones werenot inserted succesfully! Insert them manually from .sql files", MOSSGREEN, WHITE, RED, WHITE);
			PrintToConsole(client, "################# ckSurf - Error inserting tier information! #################", g_totalZoneQueries);
			g_insertingInformation = false;
		}

}

public SQL_InsertPlayerCallBack(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	if (IsClientInGame(client))
		db_UpdateLastSeen(client);	
}


public db_UpdateLastSeen(client)
{	 
	if((StrContains(g_szSteamID[client], "STEAM_") != -1) && !IsFakeClient(client))
	{
		decl String:szQuery[512]; 
		if (g_DbType == 0)
			Format(szQuery, 512, sql_UpdateLastSeenMySQL,g_szSteamID[client]);
		else
			if (g_DbType == 1)
				Format(szQuery, 512, sql_UpdateLastSeenSQLite,g_szSteamID[client]);
		SQL_TQuery(g_hDb,SQL_CheckCallback,szQuery,DBPrio_Low);
	}
}


/////////////////////////////
///// DEFAULT CALLBACKS /////
/////////////////////////////

public SQL_CheckCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}
}


public SQL_CheckCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	db_viewMapProRankCount();
	db_GetMapRecord_Pro();
}

public SQL_CheckCallback3(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new Handle:pack = data;
	ResetPack(pack);
	new client = ReadPackCell(pack);
	decl String:steamid[128];
	ReadPackString(pack, steamid, 128);	
	CloseHandle(pack);
	RecalcPlayerRank(client, steamid);
	db_viewMapProRankCount();
	db_GetMapRecord_Pro();
}

public SQL_CheckCallback4(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new Handle:pack = data;
	ResetPack(pack);
	new client = ReadPackCell(pack);
	decl String:steamid[128];
	ReadPackString(pack, steamid, 128);	
	CloseHandle(pack);
	RecalcPlayerRank(client, steamid);
}














///////////////////////////
///// PLAYER OPTIONS //////
///////////////////////////

public db_viewPlayerOptions(client, String:szSteamId[32])
{
	decl String:szQuery[512];      
	Format(szQuery, 512, sql_selectPlayerOptions, szSteamId);     
	SQL_TQuery(g_hDb, db_viewPlayerOptionsCallback, szQuery,client,DBPrio_Low);	
}

public db_viewPlayerOptionsCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;		
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{		
		g_bInfoPanel[client]=IntoBool(SQL_FetchInt(hndl, 0));
		g_bEnableQuakeSounds[client]=IntoBool(SQL_FetchInt(hndl, 1)); 
		g_bAutoBhopClient[client]=IntoBool(SQL_FetchInt(hndl, 2));
		g_bShowNames[client]=IntoBool(SQL_FetchInt(hndl, 3));
		g_bGoToClient[client]=IntoBool(SQL_FetchInt(hndl, 4));
		g_bShowTime[client]=IntoBool(SQL_FetchInt(hndl, 5));
		g_bHide[client]=IntoBool(SQL_FetchInt(hndl, 6));
		g_bShowSpecs[client]=IntoBool(SQL_FetchInt(hndl, 7));		
		g_bStartWithUsp[client]=IntoBool(SQL_FetchInt(hndl, 9));
		g_bHideChat[client]=IntoBool(SQL_FetchInt(hndl, 10));
		g_bViewModel[client]=IntoBool(SQL_FetchInt(hndl, 11));
		
		//org
		g_borg_AutoBhopClient[client] = g_bAutoBhopClient[client];
		g_borg_InfoPanel[client] = g_bInfoPanel[client];
		g_borg_EnableQuakeSounds[client] = g_bEnableQuakeSounds[client];
		g_borg_ShowNames[client] = g_bShowNames[client];
		g_borg_GoToClient[client] = g_bGoToClient[client];
		g_borg_ShowTime[client] = g_bShowTime[client]; 
		g_borg_Hide[client] = g_bHide[client];
		g_borg_StartWithUsp[client] = g_bStartWithUsp[client];
		g_borg_ShowSpecs[client] = g_bShowSpecs[client]; 
		g_borg_HideChat[client] = g_bHideChat[client];
		g_borg_ViewModel[client] = g_bViewModel[client];

	}
	else
	{
		decl String:szQuery[512];      
		if (!IsValidClient(client))
			return;

		Format(szQuery, 512, sql_insertPlayerOptions, g_szSteamID[client], 1,1,1,1,1,0,0,1,"weapon_knife",0,0,1);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);			
		g_borg_InfoPanel[client] = true;
		g_borg_ShowNames[client] = true;
		g_borg_GoToClient[client] = true;
		g_borg_ShowTime[client] = false; 
		g_borg_Hide[client] = false;
		g_borg_ShowSpecs[client] = true; 
		g_borg_StartWithUsp[client] = false;
		g_borg_AutoBhopClient[client] = true;
		g_borg_HideChat[client] = false;
		g_borg_ViewModel[client] = true;
	}
}

public db_updatePlayerOptions(client)
{
	if (g_borg_ViewModel[client] != g_bViewModel[client] || g_borg_HideChat[client] != g_bHideChat[client] || g_borg_StartWithUsp[client] != g_bStartWithUsp[client] || g_borg_AutoBhopClient[client] != g_bAutoBhopClient[client] || g_borg_InfoPanel[client] != g_bInfoPanel[client] || g_borg_EnableQuakeSounds[client] != g_bEnableQuakeSounds[client] || g_borg_ShowNames[client] != g_bShowNames[client] || g_borg_GoToClient[client] != g_bGoToClient[client] || g_borg_ShowTime[client] != g_bShowTime[client] || g_borg_Hide[client] != g_bHide[client] || g_borg_ShowSpecs[client] != g_bShowSpecs[client])
	{
		decl String:szQuery[1024];

		Format(szQuery, 1024, sql_updatePlayerOptions, BooltoInt(g_bInfoPanel[client]),	BooltoInt(g_bEnableQuakeSounds[client]), BooltoInt(g_bAutoBhopClient[client]),BooltoInt(g_bShowNames[client]),BooltoInt(g_bGoToClient[client]),BooltoInt(g_bShowTime[client]),BooltoInt(g_bHide[client]),BooltoInt(g_bShowSpecs[client]),"weapon_knife",BooltoInt(g_bStartWithUsp[client]),BooltoInt(g_bHideChat[client]),BooltoInt(g_bViewModel[client]),g_szSteamID[client]);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client,DBPrio_Low);
	}
}















//////////////////////////////
/// MENUS ////////////////////
//////////////////////////////


public db_selectTopProRecordHolders(client)
{
	decl String:szQuery[512];       
	Format(szQuery, 512, sql_selectMapRecordHolders);   
	SQL_TQuery(g_hDb, db_sql_selectMapRecordHoldersCallback, szQuery, client);
}

public db_sql_selectMapRecordHoldersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl String:szSteamID[32];
	decl String:szRecords[64];
	decl String:szQuery[256]; 
	new records=0;	 
	if(SQL_HasResultSet(hndl))
	{
		new i = SQL_GetRowCount(hndl);
		new x = i;
		g_hTopJumpersMenu[client] = CreateMenu(TopProHoldersHandler1);
		SetMenuTitle(g_hTopJumpersMenu[client], "Top 5 Pro Jumpers\n#   Records       Player");   
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 0, szSteamID, 32);
			records = SQL_FetchInt(hndl, 1); 
			if (records > 9)
				Format(szRecords,64, "%i", records);
			else
				Format(szRecords,64, "%i  ", records);	
				
			new Handle:pack = CreateDataPack();
			WritePackCell(pack, client);
			WritePackString(pack, szRecords);
			WritePackCell(pack, i);
			WritePackString(pack, szSteamID);
			Format(szQuery, 256, sql_selectRankedPlayer, szSteamID);
			SQL_TQuery(g_hDb, db_sql_selectMapRecordHoldersCallback2, szQuery, pack);
			i--;
		}
		if (x == 0)
		{
			PrintToChat(client, "%t", "NoRecordTop", MOSSGREEN,WHITE);
			TopMenu(client);
		}
	}
	else
	{
		PrintToChat(client, "%t", "NoRecordTop", MOSSGREEN,WHITE);
		TopMenu(client);
	}
}

public db_sql_selectMapRecordHoldersCallback2(Handle:owner, Handle:hndl, const String:error[], any:data)
{       
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		decl String:szName[MAX_NAME_LENGTH];
		decl String:szSteamID[32];
		decl String:szRecords[64];
		decl String:szValue[128];
		new Handle:pack = data;
		ResetPack(pack);
		new client = ReadPackCell(pack);      
		ReadPackString(pack, szRecords, 64);	
		new count = ReadPackCell(pack); 
		ReadPackString(pack, szSteamID, 32);	
		CloseHandle(pack);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
		Format(szValue, 128, "      %s       »  %s",szRecords, szName);
		AddMenuItem(g_hTopJumpersMenu[client], szSteamID, szValue, ITEMDRAW_DEFAULT);
		if (count==1)
		{
			SetMenuOptionFlags(g_hTopJumpersMenu[client], MENUFLAG_BUTTON_EXIT);
			DisplayMenu(g_hTopJumpersMenu[client], client, MENU_TIME_FOREVER);
		}
	}	
}

public db_selectTopPlayers(client)
{
	decl String:szQuery[128];       
	Format(szQuery, 128, sql_selectTopPlayers);   
	SQL_TQuery(g_hDb, db_selectTop100PlayersCallback, szQuery, client,DBPrio_Low);
}

public db_selectTop100PlayersCallback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;
	decl String:szValue[128];
	decl String:szName[64];
	decl String:szRank[16];
	decl String:szSteamID[32];
	decl String:szPerc[16];
	new points;
	new Handle:menu = CreateMenu(TopPlayersMenuHandler1);
	SetMenuTitle(menu, "Top 100 Players\n    Rank   Points       Maps            Player");     
	SetMenuPagination(menu, 5); 
	if(SQL_HasResultSet(hndl))
	{
		new i = 1;
		while (SQL_FetchRow(hndl))
		{	
			SQL_FetchString(hndl, 0, szName, 64);
			if (i==100)
				Format(szRank, 16, "[%i.]",i);
			else
			if (i<10)
				Format(szRank, 16, "[0%i.]  ",i);
			else
				Format(szRank, 16, "[%i.]  ",i);
			points = SQL_FetchInt(hndl, 1); 
			new pro = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);				
			new Float:fperc;
			fperc =  (float(pro) / (float(g_pr_MapCount))) * 100.0;
				
			if (fperc<10.0)
				Format(szPerc, 16, "  %.1f%c  ",fperc,PERCENT);
			else
				if (fperc== 100.0)
					Format(szPerc, 16, "100.0%c",PERCENT);
				else
					if (fperc> 100.0) //player profile not refreshed after removing maps
						Format(szPerc, 16, "100.0%c",PERCENT);
					else
						Format(szPerc, 16, "%.1f%c  ",fperc,PERCENT);
						
			if (points  < 10)
				Format(szValue, 128, "%s      %ip       %s     » %s",szRank, points, szPerc,szName);
			else
				if (points  < 100)
					Format(szValue, 128, "%s     %ip       %s     » %s",szRank, points, szPerc,szName);		
				else
					if (points  < 1000)
						Format(szValue, 128, "%s   %ip       %s     » %s",szRank, points, szPerc,szName);		
					else
						if (points  < 10000)
							Format(szValue, 128, "%s %ip       %s     » %s",szRank, points, szPerc,szName);	
						else
							if (points  < 100000)
								Format(szValue, 128, "%s %ip     %s     » %s",szRank, points, szPerc,szName);	
							else
								Format(szValue, 128, "%s %ip   %s     » %s",szRank, points, szPerc,szName);	
			
			AddMenuItem(menu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if(i == 1)
		{
			PrintToChat(client, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
		}
		else
		{
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, client, MENU_TIME_FOREVER);
		}
	}
	else
	{
		PrintToChat(client, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
	}
}
public SQL_ViewPlayerProfile2Callback(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("[ckSurf] SQL Error: %s", error);
		return;
	}

	new client = data;  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{           
		SQL_FetchString(hndl, 1, g_szProfileSteamId[client], 32);
		db_viewPlayerRank(client,g_szProfileSteamId[client]);
	}
	else
		if(IsClientInGame(client))
			PrintToChat(client, "%t", "PlayerNotFound", MOSSGREEN,WHITE, g_szProfileName[client]);
}

public ProfileMenuHandler(Handle:menu, MenuAction:action, param1,param2)
{ 
	if(action == MenuAction_Select)
	{
		switch(param2)
		{
			case 0: db_viewRecord(param1, g_szProfileSteamId[param1], g_szMapName);
			case 1: db_viewChallengeHistory(param1, g_szProfileSteamId[param1]);
			case 2: db_viewAllRecords(param1, g_szProfileSteamId[param1]);
			case 3: db_viewUnfinishedMaps(param1, g_szProfileSteamId[param1]);	
			case 4:
			{
				if(g_bRecalcRankInProgess[param1])
				{
					PrintToChat(param1, "%t", "PrUpdateInProgress", MOSSGREEN,WHITE);
				}
				else
				{
				
					g_bRecalcRankInProgess[param1] = true;
					PrintToChat(param1, "%t", "Rc_PlayerRankStart", MOSSGREEN,WHITE,GRAY);
					CalculatePlayerRank(param1);
				}
			}		
		}	
	}
	else
	if(action == MenuAction_Cancel)
	{
		if (1 <= param1 <= MaxClients && IsValidClient(param1))
		{
			switch(g_MenuLevel[param1])
			{
				case 0: db_selectTopPlayers(param1);
				case 3: db_selectTopChallengers(param1);	
				case 9: db_selectProClimbers(param1);	
				case 11: db_selectTopProRecordHolders(param1);	

			}	
			if (g_MenuLevel[param1] < 0)		
			{
				if (g_bSelectProfile[param1])
					ProfileMenu(param1,0);
				else
					g_bMenuOpen[param1]=false;	
			}
			g_bProfileSelected[param1]=false;
		}							
	}
	else 
		if (action == MenuAction_End)	
		{
			CloseHandle(menu);
		}
}

public TopPlayersMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1]=0;
		db_viewPlayerRank(param1,info);
	}
	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MapMenuHandler1(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 1;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MapTopMenuHandler2(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 1;
		db_viewPlayerRank(param1, info);		
	}
}

public MapMenuHandler2(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 8;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}


public MapMenuHandler3(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		decl String:info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 9;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		TopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}


public MenuHandler2(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Cancel || action ==  MenuAction_Select)
	{
		ProfileMenu(param1, -1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public RecordPanelHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if(action ==  MenuAction_Select)
	{
		if (g_CMOpen[param1])
		{
			g_CMOpen[param1]=false;
		}
		else
			ProfileMenu(param1,-1);
	}	
}

public RecordPanelHandler2(Handle:menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		TopMenu(param1);
	}
}