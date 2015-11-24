/////////////////////////
// PREPARED STATEMENTS //
////////////////////////

//TABLE CK_SPAWNLOCATIONS
char sql_createSpawnLocations[]			= "CREATE TABLE IF NOT EXISTS ck_spawnlocations (mapname VARCHAR(54) NOT NULL, pos_x FLOAT NOT NULL, pos_y FLOAT NOT NULL, pos_z FLOAT NOT NULL, ang_x FLOAT NOT NULL, ang_y FLOAT NOT NULL, ang_z FLOAT NOT NULL, zonegroup INT(12) DEFAULT 0, stage INT(12) DEFAULT 0, PRIMARY KEY(mapname, zonegroup));";
char sql_insertSpawnLocations[]			= "INSERT INTO ck_spawnlocations (mapname, pos_x, pos_y, pos_z, ang_x, ang_y, ang_z, zonegroup) VALUES ('%s', '%f', '%f', '%f', '%f', '%f', '%f', %i);";
char sql_updateSpawnLocations[]			= "UPDATE ck_spawnlocations SET pos_x = '%f', pos_y = '%f', pos_z = '%f', ang_x = '%f', ang_y = '%f', ang_z = '%f' WHERE mapname = '%s' AND zonegroup = %i";
char sql_selectSpawnLocations[]			= "SELECT mapname, pos_x, pos_y, pos_z, ang_x, ang_y, ang_z, zonegroup FROM ck_spawnlocations WHERE mapname ='%s';";
char sql_deleteSpawnLocations[]			= "DELETE FROM ck_spawnlocations WHERE mapname = '%s' AND zonegroup = %i";


//TABLE PLAYERTITLES
char sql_createPlayerFlags[]				= "CREATE TABLE IF NOT EXISTS ck_playertitles (steamid VARCHAR(32), vip INT(12) DEFAULT 0, mapper INT(12) DEFAULT 0, teacher INT(12) DEFAULT 0, custom1 INT(12) DEFAULT 0, custom2 INT(12) DEFAULT 0, custom3 INT(12) DEFAULT 0, custom4 INT(12) DEFAULT 0, custom5 INT(12) DEFAULT 0, custom6 INT(12) DEFAULT 0, custom7 INT(12) DEFAULT 0, custom8 INT(12) DEFAULT 0, custom9 INT(12) DEFAULT 0, custom10 INT(12) DEFAULT 0, custom11 INT(12) DEFAULT 0, custom12 INT(12) DEFAULT 0, custom13 INT(12) DEFAULT 0, custom14 INT(12) DEFAULT 0, custom15 INT(12) DEFAULT 0, custom16 INT(12) DEFAULT 0, custom17 INT(12) DEFAULT 0, custom18 INT(12) DEFAULT 0, custom19 INT(12) DEFAULT 0, custom20 INT(12) DEFAULT 0, inuse INT(12) DEFAULT 0, PRIMARY KEY(steamid));";
char sql_insertPlayerFlags[]				= "INSERT INTO ck_playertitles (steamid, vip, mapper, teacher, custom1, custom2, custom3, custom4, custom5, custom6, custom7, custom8, custom9, custom10, custom11, custom12, custom13, custom14, custom15, custom16, custom17, custom18, custom19, custom20, inuse) VALUES ('%s', %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i);";
char sql_updatePlayerFlags[]				= "UPDATE ck_playertitles SET vip = %i, mapper = %i, teacher = %i, custom1 = %i, custom2 = %i, custom3 = %i, custom4 = %i, custom5 = %i, custom6 = %i, custom7 = %i, custom8 = %i, custom9 = %i, custom10 = %i, custom11 = %i, custom12 = %i, custom13 = %i, custom14 = %i, custom15 = %i, custom16 = %i, custom17 = %i, custom18 = %i, custom19 = %i, custom20 = %i, inuse = %i WHERE steamid = '%s'";
char sql_updatePlayerFlagsInUse[]			= "UPDATE ck_playertitles SET inuse = %i WHERE steamid = '%s'";
char sql_deletePlayerFlags[]				= "DELETE FROM ck_playertitles WHERE steamid = '%s'";
char sql_selectPlayerFlags[]				= "SELECT vip, mapper, teacher, custom1, custom2, custom3, custom4, custom5, custom6, custom7, custom8, custom9, custom10, custom11, custom12, custom13, custom14, custom15, custom16, custom17, custom18, custom19, custom20, inuse FROM ck_playertitles WHERE steamid = '%s'";

//TABLE CHALLENGE
char sql_createChallenges[] 				= "CREATE TABLE IF NOT EXISTS ck_challenges (steamid VARCHAR(32), steamid2 VARCHAR(32), bet INT(12), map VARCHAR(32), date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(steamid,steamid2,date));";
char sql_insertChallenges[] 				= "INSERT INTO ck_challenges (steamid, steamid2, bet, map) VALUES('%s','%s','%i','%s');";
char sql_selectChallenges2[] 				= "SELECT steamid, steamid2, bet, map, date FROM ck_challenges where steamid = '%s' OR steamid2 ='%s' ORDER BY date DESC";
char sql_selectChallenges[] 				= "SELECT steamid, steamid2, bet, map FROM ck_challenges where steamid = '%s' OR steamid2 ='%s'";
char sql_selectChallengesCompare[] 		= "SELECT steamid, steamid2, bet FROM ck_challenges where (steamid = '%s' AND steamid2 ='%s') OR (steamid = '%s' AND steamid2 ='%s')";
char sql_deleteChallenges[] 				= "DELETE from ck_challenges where steamid = '%s'";

//TABLE ZONES
char sql_createZones[]					= "CREATE TABLE IF NOT EXISTS ck_zones (mapname VARCHAR(54) NOT NULL, zoneid INT(12) DEFAULT '-1', zonetype INT(12) DEFAULT '-1', zonetypeid INT(12) DEFAULT '-1', pointa_x FLOAT DEFAULT '-1.0', pointa_y FLOAT DEFAULT '-1.0', pointa_z FLOAT DEFAULT '-1.0', pointb_x FLOAT DEFAULT '-1.0', pointb_y FLOAT DEFAULT '-1.0', pointb_z FLOAT DEFAULT '-1.0', vis INT(12) DEFAULT '0', team INT(12) DEFAULT '0', zonegroup INT(12) DEFAULT 0, zonename VARCHAR(128), PRIMARY KEY(mapname, zoneid));";
char sql_insertZones[]					= "INSERT INTO ck_zones (mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename) VALUES ('%s', '%i', '%i', '%i', '%f', '%f', '%f', '%f', '%f', '%f', '%i', '%i', '%i','%s')";
char sql_updateZone[]						= "UPDATE ck_zones SET zonetype = '%i', zonetypeid = '%i', pointa_x = '%f', pointa_y ='%f', pointa_z = '%f', pointb_x = '%f', pointb_y = '%f', pointb_z = '%f', vis = '%i', team = '%i', zonegroup = '%i' WHERE zoneid = '%i' AND mapname = '%s'";
char sql_selectzoneTypeIds[]				= "SELECT zonetypeid FROM ck_zones WHERE mapname='%s' AND zonetype='%i' AND zonegroup = '%i';";
char sql_selectZoneGroupCount[]			= "SELECT zonegroup FROM ck_zones WHERE mapname='%s' GROUP BY zonegroup;";
char sql_selectMapZones[]					= "SELECT mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename FROM ck_zones WHERE mapname = '%s' ORDER BY zonetypeid ASC";
char sql_selectTotalBonusCount[]			= "SELECT mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename FROM ck_zones WHERE zonetype = 3 GROUP BY mapname, zonegroup;";
char sql_selectZoneIds[]					= "SELECT mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename FROM ck_zones WHERE mapname = '%s' ORDER BY zoneid ASC";
char sql_deleteMapZones[]					= "DELETE FROM ck_zones WHERE mapname = '%s'";
char sql_deleteZone[]						= "DELETE FROM ck_zones WHERE mapname = '%s' AND zoneid = '%i'";
char sql_deleteAllZones[]					= "DELETE FROM ck_zones";
char sql_deleteZonesInGroup[]				= "DELETE FROM ck_zones WHERE mapname = '%s' AND zonegroup = '%i'";
char sql_setZoneNames[]					= "UPDATE ck_zones SET zonename = '%s' WHERE mapname = '%s' AND zonegroup = '%i';";

//TABLE MAPTIER
char sql_createMapTier[]					= "CREATE TABLE IF NOT EXISTS ck_maptier (mapname VARCHAR(54) NOT NULL, tier INT(12), btier1 INT(12), btier2 INT(12), btier3 INT(12), btier4 INT(12), btier5 INT(12), btier6 INT(12), btier7 INT(12), btier8 INT(12), btier9 INT(12), btier10 INT(12), PRIMARY KEY(mapname));";
char sql_selectMapTier[]					= "SELECT tier, btier1, btier2, btier3, btier4, btier5, btier6, btier7, btier8, btier9, btier10 FROM ck_maptier WHERE mapname = '%s'";
char sql_deleteAllMapTiers[]				= "DELETE FROM ck_maptier";
char sql_insertmaptier[]					= "INSERT INTO ck_maptier (mapname, tier) VALUES ('%s', '%i');";
char sql_updatemaptier[]					= "UPDATE ck_maptier SET tier = %i WHERE mapname ='%s'";
char sql_updateBonusTier[]					= "UPDATE ck_maptier SET btier%i = %i WHERE mapname ='%s'";
char sql_insertBonusTier[]					= "INSERT INTO ck_maptier (mapname, btier%i) VALUES ('%s', '%i');"

//TABLE BONUS
char sql_createBonus[]					= "CREATE TABLE IF NOT EXISTS ck_bonus (steamid VARCHAR(32), name VARCHAR(32), mapname VARCHAR(32), runtime FLOAT NOT NULL DEFAULT '-1.0', zonegroup INT(12) NOT NULL DEFAULT 1, PRIMARY KEY(steamid, mapname, zonegroup));";
char sql_insertBonus[]					= "INSERT INTO ck_bonus (steamid, name, mapname, runtime, zonegroup) VALUES ('%s', '%s', '%s', '%f', '%i')";	
char sql_updateBonus[]					= "UPDATE ck_bonus SET runtime = '%f', name = '%s' WHERE steamid = '%s' AND mapname = '%s' AND zonegroup = %i";
char sql_selectBonusCount[]				= "SELECT count(*) FROM ck_bonus WHERE mapname = '%s' AND zonegroup = %i;";
char sql_checkIfBonusInMap[]				= "SELECT mapname FROM `ck_zones` WHERE `zonetype` = 3 and `mapname` = '%s' GROUP BY mapname;"
char sql_selectPersonalBonusRecords[] 	= "SELECT runtime, zonegroup FROM ck_bonus WHERE steamid = '%s' AND mapname = '%s' AND runtime > '0.0'"; 
char sql_selectPlayerRankBonus[] 			= "SELECT name FROM ck_bonus WHERE runtime <= (SELECT runtime FROM ck_bonus WHERE steamid = '%s' AND mapname= '%s' AND runtime > 0.0 AND zonegroup = %i) AND mapname = '%s' AND zonegroup = %i;";
char sql_selectFastestBonus[]				= "SELECT db2.runtime, db1.name, db1.steamid, db2.steamid FROM ck_bonus as db2 INNER JOIN ck_playerrank as db1 on db1.steamid = db2.steamid WHERE db2.mapname = '%s' AND db2.runtime  > -1.0 AND db2.zonegroup = %i ORDER BY db2.runtime ASC LIMIT 1;";
char sql_selectPersonalBonusCompleted[]	= "SELECT mapname, zonegroup FROM ck_bonus WHERE steamid = '%s' AND runtime > 0.0";
char sql_deleteBonus[]					= "DELETE FROM ck_bonus WHERE mapname = '%s'";
char sql_selectAllBonusTimesinMap[]		= "SELECT runtime from ck_bonus WHERE mapname = '%s';";
char sql_selectTopBonusSurfers[] 			= "SELECT db2.steamid, db1.name, db2.runtime as overall, db1.steamid, db2.mapname FROM ck_bonus as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname LIKE '%c%s%c' AND db2.runtime > -1.0 AND zonegroup = %i ORDER BY overall ASC LIMIT 100;";


//TABLE CHECKPOINTS
char sql_createCheckpoints[] 				= "CREATE TABLE IF NOT EXISTS ck_checkpoints (steamid VARCHAR(32), mapname VARCHAR(32), cp1 FLOAT DEFAULT '0.0', cp2 FLOAT DEFAULT '0.0', cp3 FLOAT DEFAULT '0.0', cp4 FLOAT DEFAULT '0.0', cp5 FLOAT DEFAULT '0.0', cp6 FLOAT DEFAULT '0.0', cp7 FLOAT DEFAULT '0.0', cp8 FLOAT DEFAULT '0.0', cp9 FLOAT DEFAULT '0.0', cp10 FLOAT DEFAULT '0.0', cp11 FLOAT DEFAULT '0.0', cp12 FLOAT DEFAULT '0.0', cp13 FLOAT DEFAULT '0.0', cp14 FLOAT DEFAULT '0.0', cp15 FLOAT DEFAULT '0.0', cp16 FLOAT DEFAULT '0.0', cp17  FLOAT DEFAULT '0.0', cp18 FLOAT DEFAULT '0.0', cp19 FLOAT DEFAULT '0.0', cp20  FLOAT DEFAULT '0.0', cp21 FLOAT DEFAULT '0.0', cp22 FLOAT DEFAULT '0.0', cp23 FLOAT DEFAULT '0.0', cp24 FLOAT DEFAULT '0.0', cp25 FLOAT DEFAULT '0.0', cp26 FLOAT DEFAULT '0.0', cp27 FLOAT DEFAULT '0.0', cp28 FLOAT DEFAULT '0.0', cp29 FLOAT DEFAULT '0.0', cp30 FLOAT DEFAULT '0.0', cp31 FLOAT DEFAULT '0.0', cp32  FLOAT DEFAULT '0.0', cp33 FLOAT DEFAULT '0.0', cp34 FLOAT DEFAULT '0.0', cp35 FLOAT DEFAULT '0.0', zonegroup INT(12) NOT NULL DEFAULT 0, PRIMARY KEY(steamid, mapname, zonegroup));";
char sql_updateCheckpoints[] 				= "UPDATE ck_checkpoints SET cp1='%f', cp2='%f', cp3='%f', cp4='%f', cp5='%f', cp6='%f', cp7='%f', cp8='%f', cp9='%f', cp10='%f', cp11='%f', cp12='%f', cp13='%f', cp14='%f', cp15='%f', cp16='%f', cp17='%f', cp18='%f', cp19='%f', cp20='%f', cp21='%f', cp22='%f', cp23='%f', cp24='%f', cp25='%f', cp26='%f', cp27='%f', cp28='%f', cp29='%f', cp30='%f', cp31='%f', cp32='%f', cp33='%f', cp34='%f', cp35='%f' WHERE steamid='%s' AND mapname='%s' AND zonegroup='%i'";
char sql_insertCheckpoints[] 				= "INSERT INTO ck_checkpoints VALUES ('%s', '%s', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%i')";
char sql_selectCheckpoints[] 				= "SELECT * FROM ck_checkpoints WHERE steamid='%s' AND mapname='%s' AND zonegroup = %i;";
char sql_selectRecordCheckpoints[]		= "SELECT * FROM ck_checkpoints WHERE steamid = (SELECT steamid FROM ck_playertimes WHERE mapname = '%s' ORDER BY runtimepro ASC LIMIT 1) AND mapname = '%s' AND zonegroup = '%i';";
char sql_deleteCheckpoints[]				= "DELETE FROM ck_checkpoints WHERE mapname = '%s'";

//TABLE LATEST 15 LOCAL RECORDS
char sql_createLatestRecords[] 			= "CREATE TABLE IF NOT EXISTS ck_latestrecords (steamid VARCHAR(32), name VARCHAR(32), runtime FLOAT NOT NULL DEFAULT '-1.0', map VARCHAR(32), date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(steamid,map,date));";
char sql_insertLatestRecords[] 			= "INSERT INTO ck_latestrecords (steamid, name, runtime, map) VALUES('%s','%s','%f','%s');";
char sql_selectLatestRecords[] 			= "SELECT name, runtime, map, date FROM ck_latestrecords ORDER BY date DESC LIMIT 50";

//TABLE PLAYEROPTIONS
char sql_createPlayerOptions[] 			= "CREATE TABLE IF NOT EXISTS ck_playeroptions (steamid VARCHAR(32), speedmeter INT(12) DEFAULT '0', quake_sounds INT(12) DEFAULT '1', autobhop INT(12) DEFAULT '0', shownames INT(12) DEFAULT '1', goto INT(12) DEFAULT '1', showtime INT(12) DEFAULT '1', hideplayers INT(12) DEFAULT '0', showspecs INT(12) DEFAULT '1', knife VARCHAR(32) DEFAULT 'weapon_knife', new1 INT(12) DEFAULT '0', new2 INT(12) DEFAULT '0', new3 INT(12) DEFAULT '0', checkpoints INT(12) DEFAULT '1', PRIMARY KEY(steamid));";
char sql_insertPlayerOptions[] 			= "INSERT INTO ck_playeroptions (steamid, speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3) VALUES('%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%s', '%i', '%i', '%i');";
char sql_selectPlayerOptions[] 			= "SELECT speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3, checkpoints FROM ck_playeroptions where steamid = '%s'";
char sql_updatePlayerOptions[]			= "UPDATE ck_playeroptions SET speedmeter ='%i', quake_sounds ='%i', autobhop ='%i', shownames ='%i', goto ='%i', showtime ='%i', hideplayers ='%i', showspecs ='%i', knife ='%s', new1 = '%i', new2 = '%i', new3 = '%i', checkpoints = '%i' where steamid = '%s'";

//TABLE PLAYERRANK
char sql_createPlayerRank[]				= "CREATE TABLE IF NOT EXISTS ck_playerrank (steamid VARCHAR(32), name VARCHAR(32), country VARCHAR(32), points INT(12)  DEFAULT '0', winratio INT(12)  DEFAULT '0', pointsratio INT(12)  DEFAULT '0',finishedmaps INT(12) DEFAULT '0', multiplier INT(12) DEFAULT '0', finishedmapspro INT(12) DEFAULT '0', lastseen DATE, PRIMARY KEY(steamid));";
char sql_insertPlayerRank[] 				= "INSERT INTO ck_playerrank (steamid, name, country) VALUES('%s', '%s', '%s');";
char sql_updatePlayerRankPoints[]			= "UPDATE ck_playerrank SET name ='%s', points ='%i', finishedmapspro='%i',winratio = '%i',pointsratio = '%i' where steamid='%s'";
char sql_updatePlayerRankPoints2[]		= "UPDATE ck_playerrank SET name ='%s', points ='%i', finishedmapspro='%i',winratio = '%i',pointsratio = '%i', country ='%s' where steamid='%s'";
char sql_updatePlayerRank[]				= "UPDATE ck_playerrank SET finishedmaps ='%i', finishedmapspro='%i', multiplier ='%i'  where steamid='%s'";
char sql_selectPlayerRankAll[] 			= "SELECT name, steamid FROM ck_playerrank where name like '%c%s%c'";
char sql_selectPlayerRankAll2[] 			= "SELECT name, steamid FROM ck_playerrank where name = '%s'";
char sql_selectPlayerName[] 				= "SELECT name FROM ck_playerrank where steamid = '%s'";
char sql_UpdateLastSeenMySQL[]			= "UPDATE ck_playerrank SET lastseen = NOW() where steamid = '%s';";
char sql_UpdateLastSeenSQLite[]			= "UPDATE ck_playerrank SET lastseen = date('now') where steamid = '%s';";
char sql_selectTopPlayers[]				= "SELECT name, points, finishedmapspro, steamid FROM ck_playerrank ORDER BY points DESC LIMIT 100";
char sql_selectTopChallengers[]			= "SELECT name, winratio, pointsratio, steamid FROM ck_playerrank ORDER BY pointsratio DESC LIMIT 5";
char sql_selectRankedPlayer[]				= "SELECT steamid, name, points, finishedmapspro, multiplier, country, lastseen from ck_playerrank where steamid='%s'";
char sql_selectRankedPlayersRank[]		= "SELECT name FROM ck_playerrank WHERE points >= (SELECT points FROM ck_playerrank WHERE steamid = '%s') ORDER BY points";
char sql_selectRankedPlayers[]			= "SELECT steamid, name from ck_playerrank where points > 0 ORDER BY points DESC";
char sql_CountRankedPlayers[] 			= "SELECT COUNT(steamid) FROM ck_playerrank";
char sql_CountRankedPlayers2[] 			= "SELECT COUNT(steamid) FROM ck_playerrank where points > 0";

//TABLE PLAYERTIMES
char sql_createPlayertimes[] 				= "CREATE TABLE IF NOT EXISTS ck_playertimes (steamid VARCHAR(32), mapname VARCHAR(32), name VARCHAR(32), runtimepro FLOAT NOT NULL DEFAULT '-1.0', PRIMARY KEY(steamid,mapname));";
char sql_insertPlayer[] 					= "INSERT INTO ck_playertimes (steamid, mapname, name) VALUES('%s', '%s', '%s');";
char sql_insertPlayerTime[] 				= "INSERT INTO ck_playertimes (steamid, mapname, name,runtimepro) VALUES('%s', '%s', '%s', '%f');";
char sql_updateRecordPro[]				= "UPDATE ck_playertimes SET name = '%s', runtimepro = '%f' WHERE steamid = '%s' AND mapname = '%s';"; 
char sql_selectPlayer[] 					= "SELECT steamid FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s';";
char sql_selectRecord[] 					= "SELECT steamid, runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro  > -1.0";
char sql_selectMapRecordPro[] 			= "SELECT db2.runtimepro, db1.name, db1.steamid, db2.steamid FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db1.steamid = db2.steamid WHERE db2.mapname = '%s' AND db2.runtimepro  > -1.0 ORDER BY db2.runtimepro ASC LIMIT 1"; 
char sql_selectPersonalRecords[] 			= "SELECT db2.mapname, db2.steamid, db1.name, db2.runtimepro, db1.steamid  FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db1.steamid = db2.steamid WHERE db2.steamid = '%s' AND db2.mapname = '%s' AND db2.runtimepro > 0.0"; 
char sql_selectPersonalAllRecords[] 		= "SELECT db1.name, db2.steamid, db2.mapname, db2.runtimepro as overall, db1.steamid FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.steamid = '%s' AND db2.runtimepro > -1.0 ORDER BY mapname ASC;";
char sql_selectProSurfers[] 				= "SELECT db1.name, db2.runtimepro, db2.steamid, db1.steamid FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname = '%s' AND db2.runtimepro > -1.0 ORDER BY db2.runtimepro ASC LIMIT 20";
char sql_selectTopSurfers2[] 				= "SELECT db2.steamid, db1.name, db2.runtimepro as overall, db1.steamid, db2.mapname FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname LIKE '%c%s%c' AND db2.runtimepro > -1.0 ORDER BY overall ASC LIMIT 100;";
char sql_selectTopSurfers[] 				= "SELECT db2.steamid, db1.name, db2.runtimepro as overall, db1.steamid, db2.mapname FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname = '%s' AND db2.runtimepro > -1.0 ORDER BY overall ASC LIMIT 100;";
char sql_selectPlayerProCount[] 			= "SELECT name FROM ck_playertimes WHERE mapname = '%s' AND runtimepro  > -1.0;";
char sql_CountFinishedMaps[] 				= "SELECT mapname FROM ck_playertimes where steamid='%s' AND runtimepro > -1.0;";
char sql_selectPlayerRankProTime[] 		= "SELECT name,mapname FROM ck_playertimes WHERE runtimepro <= (SELECT runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";
char sql_selectMapRecordHolders[] 		= "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM ck_playertimes s INNER JOIN (SELECT mapname, MIN(runtimepro) AS runtimepro FROM ck_playertimes where runtimepro > -1.0 GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtimepro = x.runtimepro) y GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid LIMIT 5;";
char sql_selectMapRecordCount[] 			= "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM ck_playertimes s INNER JOIN (SELECT mapname, MIN(runtimepro) AS runtimepro FROM ck_playertimes where runtimepro > -1.0  GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtimepro = x.runtimepro) y where y.steamid = '%s' GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid;";
char sql_selectAllMapTimesinMap[]			= "SELECT runtimepro from ck_playertimes WHERE mapname = '%s';";

//TABLE PLAYERTEMP
char sql_createPlayertmp[] 				= "CREATE TABLE IF NOT EXISTS ck_playertemp (steamid VARCHAR(32), mapname VARCHAR(32), cords1 FLOAT NOT NULL DEFAULT '-1.0', cords2 FLOAT NOT NULL DEFAULT '-1.0', cords3 FLOAT NOT NULL DEFAULT '-1.0', angle1 FLOAT NOT NULL DEFAULT '-1.0',angle2 FLOAT NOT NULL DEFAULT '-1.0',angle3 FLOAT NOT NULL DEFAULT '-1.0', EncTickrate INT(12) DEFAULT '-1.0', runtimeTmp FLOAT NOT NULL DEFAULT '-1.0', Stage INT, zonegroup INT NOT NULL DEFAULT 0, PRIMARY KEY(steamid,mapname));";
char sql_insertPlayerTmp[]  				= "INSERT INTO ck_playertemp (cords1, cords2, cords3, angle1,angle2,angle3,runtimeTmp,steamid,mapname,EncTickrate,Stage,zonegroup) VALUES ('%f','%f','%f','%f','%f','%f','%f','%s', '%s', '%i', %i, %i);";
char sql_updatePlayerTmp[] 				= "UPDATE ck_playertemp SET cords1 = '%f', cords2 = '%f', cords3 = '%f', angle1 = '%f', angle2 = '%f', angle3 = '%f', runtimeTmp = '%f', mapname ='%s', EncTickrate='%i', Stage = %i, zonegroup = %i WHERE steamid = '%s';";
char sql_deletePlayerTmp[] 				= "DELETE FROM ck_playertemp where steamid = '%s';";
char sql_selectPlayerTmp[] 				= "SELECT cords1,cords2,cords3, angle1, angle2, angle3,runtimeTmp, EncTickrate, Stage, zonegroup FROM ck_playertemp WHERE steamid = '%s' AND mapname = '%s';";

// ADMIN 
char sqlite_dropChallenges[] 			= "DROP TABLE ck_challenges; VACCUM";
char sql_dropChallenges[] 				= "DROP TABLE ck_challenges;";
char sqlite_dropPlayer[] 				= "DROP TABLE ck_playertimes; VACCUM";
char sql_dropPlayer[] 					= "DROP TABLE ck_playertimes;";
char sql_dropPlayerRank[] 				= "DROP TABLE ck_playerrank;";
char sqlite_dropPlayerRank[] 			= "DROP TABLE ck_playerrank; VACCUM";
char sql_resetRecords[] 				= "DELETE FROM ck_playertimes WHERE steamid = '%s'";
char sql_resetRecords2[] 				= "DELETE FROM ck_playertimes WHERE steamid = '%s' AND mapname LIKE '%s';";
char sql_resetRecordPro[] 				= "UPDATE ck_playertimes SET runtimepro = '-1.0' WHERE steamid = '%s' AND mapname LIKE '%s';";
char sql_resetCheckpoints[]				= "DELETE FROM ck_checkpoints WHERE steamid = '%s' AND mapname LIKE '%s';";
char sql_resetMapRecords[] 				= "DELETE FROM ck_playertimes WHERE mapname = '%s'";

////////////////////////
//// DATABASE SETUP/////
////////////////////////

public db_setupDatabase()
{
	////////////////////////////////
	// INIT CONNECTION TO DATABASE//
	////////////////////////////////
	char szError[255];
	g_hDb = SQL_Connect("cksurf", false, szError, 255);
        
	if(g_hDb == null)
	{
		SetFailState("[ckSurf] Unable to connect to database (%s)",szError);
		return;
	}
        
	char szIdent[8];
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


	////////////////////////////////
	// CHECK WHICH CHANGES ARE    //
	// TO BE DONE TO THE DATABASE //
	////////////////////////////////
	g_bRenaming = false;

	// If coming from KZTimer or a really old version, rename and edit tables to new format
	if (SQL_FastQuery(g_hDb, "SELECT * FROM playerrank;") && !SQL_FastQuery(g_hDb, "SELECT * FROM ck_playerrank;"))
	{
		db_renameTables();
		return;
	}
	else // If startring for the first time and tables haven't been created yet.
		if (!SQL_FastQuery(g_hDb, "SELECT * FROM playerrank;") && !SQL_FastQuery(g_hDb, "SELECT * FROM ck_playerrank;"))
		{
			db_createTables();
			return;
		}

	// If updating from a previous version
	SQL_LockDatabase(g_hDb);

	// Drop useless tables from KZTimer
	SQL_FastQuery(g_hDb, "DROP TABLE IF EXISTS ck_mapbuttons");
	SQL_FastQuery(g_hDb, "DROP TABLE IF EXISTS playerjumpstats3");

	// 1.17 Command to disable checkpoint messages
	SQL_FastQuery(g_hDb, "ALTER TABLE ck_playeroptions ADD checkpoints INT DEFAULT 1;");


	////////////////////////////
	// 1.2 A bunch of changes //
	// - Zone Groups          //
	// - Zone Names           //
	// - Bonus Tiers          //
	// - Titles               //
	// - More checkpoints     //
	////////////////////////////

	SQL_FastQuery(g_hDb, "ALTER TABLE ck_zones ADD zonegroup INT NOT NULL DEFAULT 0;");
	SQL_FastQuery(g_hDb, "ALTER TABLE ck_zones ADD zonename VARCHAR(128);");
	SQL_FastQuery(g_hDb, "ALTER TABLE ck_playertemp ADD zonegroup INT NOT NULL DEFAULT 0;");
	SQL_FastQuery(g_hDb, sql_createPlayerFlags);

	SQL_UnlockDatabase(g_hDb);
	g_successfulTransactions = 0;
	for (int i = 0; i < sizeof(g_failedTransactions); i++)
		g_failedTransactions[i] = 0;

	addExtraCheckpoints();
}

void addExtraCheckpoints()
{
	// Add extra checkpoints to Checkpoints and add new primary key:
	if (!SQL_FastQuery(g_hDb, "SELECT cp35 FROM ck_checkpoints;"))
	{
		g_bInTransactionChain = true;
		Transaction h_checkpoint = SQL_CreateTransaction();
		
		SQL_AddQuery(h_checkpoint, "ALTER TABLE ck_checkpoints RENAME TO ck_checkpoints_temp;");
		SQL_AddQuery(h_checkpoint, sql_createCheckpoints);
		SQL_AddQuery(h_checkpoint, "INSERT INTO ck_checkpoints(steamid, mapname, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20) SELECT steamid, mapname, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20 FROM ck_checkpoints_temp;");
		SQL_AddQuery(h_checkpoint, "DROP TABLE ck_checkpoints_temp");

		SQL_ExecuteTransaction(g_hDb, h_checkpoint, SQLTxn_Success, SQLTxn_TXNFailed, 1);
	}
}

void addZoneGroups()
{
	// Add zonegroups to ck_bonus and make it a primary key
	if (!SQL_FastQuery(g_hDb, "SELECT zonegroup FROM ck_bonus;"))
	{
		Transaction h_bonus = SQL_CreateTransaction();

		SQL_AddQuery(h_bonus, "ALTER TABLE ck_bonus RENAME TO ck_bonus_temp;");
		SQL_AddQuery(h_bonus, sql_createBonus);
		SQL_AddQuery(h_bonus, "INSERT INTO ck_bonus(steamid, name, mapname, runtime) SELECT steamid, name, mapname, runtime FROM ck_bonus_temp;");
		SQL_AddQuery(h_bonus, "DROP TABLE ck_bonus_temp;");

		SQL_ExecuteTransaction(g_hDb, h_bonus, SQLTxn_Success, SQLTxn_TXNFailed, 2);
	}
}

void recreatePlayerTemp()
{
	// Recreate playertemp without BonusTimer
	if (SQL_FastQuery(g_hDb, "SELECT BonusTimer FROM ck_playertemp;"))
	{
		// No need to preserve temp data, just drop table
		Transaction h_playertemp = SQL_CreateTransaction();
		SQL_AddQuery(h_playertemp, "DROP TABLE IF EXISTS ck_playertemp");
		SQL_AddQuery(h_playertemp, sql_createPlayertmp);
		SQL_ExecuteTransaction(g_hDb, h_playertemp, SQLTxn_Success, SQLTxn_TXNFailed, 3);
	}
}

void addBonusTiers()
{
	// Add bonus tiers
	if (SQL_FastQuery(g_hDb, "ALTER TABLE ck_maptier ADD btier1 INT;"))
	{
		Transaction h_maptiers = SQL_CreateTransaction();
		char sql[258];
		for (int x = 2; x < 11; x++)
		{
			Format(sql, 258, "ALTER TABLE ck_maptier ADD btier%i INT;", x);
			SQL_AddQuery(h_maptiers, sql);
		}
		SQL_ExecuteTransaction(g_hDb, h_maptiers, SQLTxn_Success, SQLTxn_TXNFailed, 4);  
	}
}
void addSpawnPoints()
{
	if (!SQL_FastQuery(g_hDb, "SELECT zonegroup FROM ck_spawnlocations;"))
	{
		Transaction h_spawnPoints = SQL_CreateTransaction();
		SQL_AddQuery(h_spawnPoints, "ALTER TABLE ck_spawnlocations RENAME TO ck_spawnlocations_temp;");
		SQL_AddQuery(h_spawnPoints, sql_createSpawnLocations);
		SQL_AddQuery(h_spawnPoints, "INSERT INTO ck_spawnlocations (mapname, pos_x, pos_y, pos_z, ang_x, ang_y, ang_z) SELECT mapname, pos_x, pos_y, pos_z, ang_x, ang_y, ang_z FROM ck_spawnlocations_temp;");
		SQL_AddQuery(h_spawnPoints, "DROP TABLE ck_spawnlocations_temp");
		SQL_ExecuteTransaction(g_hDb, h_spawnPoints, SQLTxn_Success, SQLTxn_TXNFailed, 5);
	}
}


public SQLTxn_Success(Handle db, any:data, numQueries, Handle[] results, any:queryData[])
{
	switch (data)
	{
		case 1:{
			addZoneGroups();
		}
		case 2:{
			recreatePlayerTemp();
		}
		case 3:{
			addBonusTiers();
		}
		case 4:{
			addSpawnPoints();
		}
	}

	g_successfulTransactions++;

	if (g_successfulTransactions == 5)
	{
		g_bInTransactionChain = false;

		SQL_LockDatabase(g_hDb);

		// Set Bonuses to zonegroup 1
		SQL_FastQuery(g_hDb, "UPDATE ck_zones SET zonegroup = 1 WHERE zonetype = 3 OR zonetype = 4;");
		SQL_FastQuery(g_hDb, "UPDATE ck_zones SET zonetypeid = 0 WHERE zonetype = 3 OR zonetype = 4;");

		// Remove ZoneTypes 3 & 4
		SQL_FastQuery(g_hDb, "UPDATE ck_zones SET zonetype = 1 WHERE zonetype = 3;");
		SQL_FastQuery(g_hDb, "UPDATE ck_zones SET zonetype = 2 WHERE zonetype = 4;");
		SQL_FastQuery(g_hDb, "UPDATE ck_zones SET zonetype = zonetype-2 WHERE zonetype > 4;");

		SQL_UnlockDatabase(g_hDb);

		ForceChangeLevel(g_szMapName, "Database Changes v1.2 Done. Restarting Map.");
	}
}

public SQLTxn_TXNFailed(Handle db, any:data, numQueries, const char[] error, failIndex, any:queryData[])
{
	if (g_failedTransactions[data] == 0)
	{
		switch (data)
		{
			case 1:{
				addExtraCheckpoints();
			}
			case 2:{
				addZoneGroups();
			}
			case 3:{
				recreatePlayerTemp();
			}
			case 4:{
				addBonusTiers();
			}
		}
	}
	else
	{
		g_bInTransactionChain = false;
		LogError("[ckSurf]: Couldn't make changes into the database. Transaction: %i, error: %s", data, error);
	}
	g_failedTransactions[data]++;
}


public db_createTables()
{
	SQL_LockDatabase(g_hDb);

	SQL_FastQuery(g_hDb, sql_createPlayertmp);
	SQL_FastQuery(g_hDb, sql_createPlayertimes);
	SQL_FastQuery(g_hDb, sql_createPlayerRank);
	SQL_FastQuery(g_hDb, sql_createChallenges);
	SQL_FastQuery(g_hDb, sql_createPlayerOptions);
	SQL_FastQuery(g_hDb, sql_createLatestRecords);
	SQL_FastQuery(g_hDb, sql_createBonus);
	SQL_FastQuery(g_hDb, sql_createCheckpoints);
	SQL_FastQuery(g_hDb, sql_createZones);
	SQL_FastQuery(g_hDb, sql_createMapTier);
	SQL_FastQuery(g_hDb, sql_createSpawnLocations);
	SQL_FastQuery(g_hDb, sql_createPlayerFlags); 

	SQL_UnlockDatabase(g_hDb);
}

public db_renameTables()
{
	g_bRenaming = true;
	Transaction hndl = SQL_CreateTransaction();
	
	SQL_AddQuery(hndl, sql_createSpawnLocations);

	if (g_DbType == MYSQL)
	{
		// Remove unused columns, if coming from KZTimer
		SQL_AddQuery(hndl, "ALTER TABLE challenges DROP COLUMN cp_allowed");
		SQL_AddQuery(hndl, "ALTER TABLE latestrecords DROP COLUMN teleports");
		SQL_AddQuery(hndl, "ALTER TABLE playeroptions2 DROP COLUMN colorchat");
		SQL_AddQuery(hndl, "ALTER TABLE playeroptions2 DROP COLUMN Surfersmenu_sounds");
		SQL_AddQuery(hndl, "ALTER TABLE playeroptions2 DROP COLUMN strafesync");
		SQL_AddQuery(hndl, "ALTER TABLE playeroptions2 DROP COLUMN cpmessage");
		SQL_AddQuery(hndl, "ALTER TABLE playeroptions2 DROP COLUMN adv_menu");
		SQL_AddQuery(hndl, "ALTER TABLE playeroptions2 DROP COLUMN jumppenalty");
		SQL_AddQuery(hndl, "ALTER TABLE playerrank DROP COLUMN finishedmapstp");
		SQL_AddQuery(hndl, "ALTER TABLE playertimes DROP COLUMN teleports");
		SQL_AddQuery(hndl, "ALTER TABLE playertimes DROP COLUMN runtime");
		SQL_AddQuery(hndl, "ALTER TABLE playertimes DROP COLUMN teleports_pro");
		SQL_AddQuery(hndl, "ALTER TABLE playertmp DROP COLUMN teleports");
		SQL_AddQuery(hndl, "ALTER TABLE playertmp DROP COLUMN checkpoints");
		SQL_AddQuery(hndl, "ALTER TABLE LatestRecords DROP COLUMN teleports");

		SQL_AddQuery(hndl, "ALTER TABLE playeroptions2 RENAME TO ck_playeroptions;");
		SQL_AddQuery(hndl, "ALTER TABLE playertimes RENAME TO ck_playertimes;");
		SQL_AddQuery(hndl, "ALTER TABLE challenges RENAME TO ck_challenges;");
		SQL_AddQuery(hndl, "ALTER TABLE playerrank RENAME TO ck_playerrank;");

	}
	else if (g_DbType == SQLITE)
	{
		// player options
		SQL_AddQuery(hndl, sql_createPlayerOptions);
		SQL_AddQuery(hndl, "INSERT INTO ck_playeroptions(steamid, speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, new1, new2, new3) SELECT steamid, speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, new1, new2, new3 FROM playeroptions2;");
		SQL_AddQuery(hndl, "DROP TABLE IF EXISTS playeroptions2");

		// player times
		SQL_AddQuery(hndl, sql_createPlayertimes);
		SQL_AddQuery(hndl, "INSERT INTO ck_playertimes(steamid, mapname, name, runtimepro) SELECT steamid, mapname, name, runtimepro FROM playertimes;");
		SQL_AddQuery(hndl, "DROP TABLE IF EXISTS playertimes");

		// challenges
		SQL_AddQuery(hndl, sql_createChallenges);
		SQL_AddQuery(hndl, "INSERT INTO ck_challenges(steamid, steamid2, bet, map, date) SELECT steamid, steamid2, bet, map, date FROM challenges;");
		SQL_AddQuery(hndl, "DROP TABLE IF EXISTS challenges");

		// playerrank
		SQL_AddQuery(hndl, sql_createPlayerRank);
		SQL_AddQuery(hndl, "INSERT INTO ck_playerrank(steamid, name, country, points, winratio, pointsratio, finishedmaps, multiplier, finishedmapspro, lastseen) SELECT steamid, name, country, points, winratio, pointsratio, finishedmaps, multiplier, finishedmapspro, lastseen FROM playerrank;");
		SQL_AddQuery(hndl, "DROP TABLE IF EXISTS playerrank");
	}

	SQL_AddQuery(hndl, "ALTER TABLE bonus RENAME TO ck_bonus;");
	SQL_AddQuery(hndl, "ALTER TABLE checkpoints RENAME TO ck_checkpoints;");
	SQL_AddQuery(hndl, "ALTER TABLE maptier RENAME TO ck_maptier;");
	SQL_AddQuery(hndl, "ALTER TABLE zones RENAME TO ck_zones;");

	SQL_AddQuery(hndl, sql_createPlayertmp);
	SQL_AddQuery(hndl, sql_createLatestRecords);

	SQL_AddQuery(hndl, "DROP TABLE IF EXISTS playertmp");
	SQL_AddQuery(hndl, "DROP TABLE IF EXISTS LatestRecords");

	SQL_ExecuteTransaction(g_hDb, hndl, SQLTxn_RenameSuccess, SQLTxn_RenameFailed);
}

public SQLTxn_RenameSuccess(Handle db, any:data, numQueries, Handle[] results, any:queryData[])
{
	g_bRenaming = false;
	PrintToChatAll("[%cCK%c] Database changes done succesfully, reloading the map...");
	
	ForceChangeLevel(g_szMapName, "Database Renaming Done. Restarting Map.");
}

public SQLTxn_RenameFailed(Handle db, any:data, numQueries, const char[] error, failIndex, any:queryData[])
{
	g_bRenaming = false;
	SetFailState("[ckSurf] Database changes failed! (Renaming) Error: %s", error);
}


///////////////////////
//// PLAYER TITLES ////
///////////////////////

public db_checkPlayersTitles(client)
{
	for (int i = 0; i < TITLE_COUNT; i++)
		g_bAdminFlagTitlesTemp[client][i] = false;

	SQL_EscapeString(g_hDb, g_szAdminSelectedSteamID[client], g_szAdminSelectedSteamID[client], 32);
	char szQuery[512];
	Format(szQuery, 512, sql_selectPlayerFlags, g_szAdminSelectedSteamID[client]);

	switch (g_iAdminEditingType[client])
	{
		case 1:	SQL_TQuery(g_hDb, SQL_checkPlayerFlagsCallback, szQuery, client, DBPrio_Low);
		case 3: SQL_TQuery(g_hDb, SQL_checkPlayerFlagsCallback2, szQuery, client, DBPrio_Low);
	}
}

public SQL_checkPlayerFlagsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_checkPlayerFlagsCallback): %s ", error);
		return;
	}

	Handle titleMenu = CreateMenu(Handler_TitleMenu);
	char id[2], menuItem[152];

	if (IsValidClient(g_iAdminSelectedClient[data]))
	{
		char szName[MAX_NAME_LENGTH];
		GetClientName(g_iAdminSelectedClient[data], szName, MAX_NAME_LENGTH);
		SetMenuTitle(titleMenu, "Select title to give to %s:", szName);
	}
	else
	{
		SetMenuTitle(titleMenu, "Select which title to give:");
	}


	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bAdminSelectedHasFlag[data] = true;
		for (int i = 0; i < TITLE_COUNT; i++)
		{
			if (!StrEqual(g_szflagTitle_Colored[i], ""))
			{
				Format(id, 2, "%i", i);
				if (SQL_FetchInt(hndl, i) > 0)
				{
					g_bAdminFlagTitlesTemp[data][i] = true;
					Format(menuItem, 152, "[ON] %s", g_szflagTitle_Colored[i]);
					AddMenuItem(titleMenu, id, menuItem);
				}
				else
				{
					Format(menuItem, 152, "[OFF] %s", g_szflagTitle_Colored[i]);
					AddMenuItem(titleMenu, id, menuItem);
				}
			}
		}
	}
	else 
	{
		g_bAdminSelectedHasFlag[data] = false;
		for (int i = 0; i < TITLE_COUNT; i++)
		{
			if (!StrEqual(g_szflagTitle_Colored[i], ""))
			{
				Format(id, 2, "%i", i);
				Format(menuItem, 152, "[OFF] %s", g_szflagTitle_Colored[i]);
				AddMenuItem(titleMenu, id, menuItem);
			}
		}
	}

	SetMenuExitButton(titleMenu, true);
	DisplayMenu(titleMenu, data, MENU_TIME_FOREVER);
}

public SQL_checkPlayerFlagsCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{

	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_checkPlayerFlagsCallback2): %s ", error);
		return;
	}

	Handle titleMenu = CreateMenu(Handler_TitleMenu);
	char id[2], menuItem[152];

	if (IsValidClient(g_iAdminSelectedClient[data]))
	{
		char szName[MAX_NAME_LENGTH];
		GetClientName(g_iAdminSelectedClient[data], szName, MAX_NAME_LENGTH);
		SetMenuTitle(titleMenu, "Which title do you want to remove from %s:", szName);
	}
	else
	{
		SetMenuTitle(titleMenu, "Which title do you wan to remove? :");
	}


	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bAdminSelectedHasFlag[data] = true;
		for (int i = 0; i < TITLE_COUNT; i++)
		{
			if (!StrEqual(g_szflagTitle_Colored[i], ""))
			{
				Format(id, 2, "%i", i);
				if (SQL_FetchInt(hndl, i) > 0)
				{
					g_bAdminFlagTitlesTemp[data][i] = true;
					Format(menuItem, 152, "[ON] %s", g_szflagTitle_Colored[i]);
					AddMenuItem(titleMenu, id, menuItem);
				}
			}
		}
	}
	else 
	{
		AddMenuItem(titleMenu, "-1", "The chosen player doesn't have any titles.");
	}

	SetMenuExitButton(titleMenu, true);
	DisplayMenu(titleMenu, data, MENU_TIME_FOREVER);
}

public db_viewPersonalFlags(client, char SteamID[32])
{
	char szQuery[728];
	Format(szQuery, 728, sql_selectPlayerFlags, SteamID);
	SQL_TQuery(g_hDb, SQL_PersonalFlagCallback, szQuery, client, DBPrio_Low);
}

public SQL_PersonalFlagCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_PersonalFlagCallback): %s ", error);
		return;
	}

	for (int i = 0; i < TITLE_COUNT; i++)
		g_bflagTitles[data][i] = false;

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bHasTitle[data] = true;
		for (int i = 0; i < TITLE_COUNT; i++)
			if (SQL_FetchInt(hndl, i) > 0)
			{
				g_bflagTitles[data][i] = true;
			}

		g_iTitleInUse[data] = SQL_FetchInt(hndl, 23);
	}
	Array_Copy(g_bflagTitles[data], g_bflagTitles_orig[data], TITLE_COUNT);
}

public db_checkChangesInTitle(client, char SteamID[32])
{
	char szQuery[728];
	Format(szQuery, 728, sql_selectPlayerFlags, SteamID);
	SQL_TQuery(g_hDb, db_checkChangesInTitleCallback, szQuery, client, DBPrio_Low);
}

public db_checkChangesInTitleCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_checkChangesInTitleCallback): %s ", error);
		return;
	}

	for (int i = 0; i < TITLE_COUNT; i++)
		g_bflagTitles[data][i] = false;

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bHasTitle[data] = true;
		for (int i = 0; i < TITLE_COUNT; i++)
			if (SQL_FetchInt(hndl, i) > 0)
			{
				g_bflagTitles[data][i] = true;
			}

		g_iTitleInUse[data] = SQL_FetchInt(hndl, 23);
	}
	
	if (!IsValidClient(data))
		return;

	for (int i = 0; i < TITLE_COUNT; i++)
	{
		if (g_bflagTitles[data][i] != g_bflagTitles_orig[data][i])
		{
			if (g_bflagTitles[data][i])
				ClientCommand(data, "play commander\\commander_comment_0%i", GetRandomInt(1, 9));
			else
				ClientCommand(data, "play commander\\commander_comment_%i", GetRandomInt(20, 23));

			switch (i) 
			{
				case 0: 
				{
					g_bflagTitles_orig[data][i] = g_bflagTitles[data][i];
					if (g_bflagTitles[data][i])
						PrintToChat(data, "[%cCK%c] Congratulations! You have gained the VIP privileges!", MOSSGREEN, WHITE);
					else
					{
						g_bTrailOn[data] = false;
						PrintToChat(data, "[%cCK%c] You have lost your VIP privileges!", MOSSGREEN, WHITE);
					}
					break;
				}
				default:
				{
					g_bflagTitles_orig[data][i] = g_bflagTitles[data][i];
					if (g_bflagTitles[data][i])
						PrintToChat(data, "[%cCK%c] Congratulations! You have gained the custom title \"%s\"!", MOSSGREEN, WHITE, g_szflagTitle_Colored[i]);
					else
						PrintToChat(data, "[%cCK%c] You have lost your custom title \"%s\"!", MOSSGREEN, WHITE, g_szflagTitle_Colored[i]);
					break;
				}
			}
		}
	}
}

public db_insertPlayerTitles(client, titleID)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_insertPlayerFlags, g_szAdminSelectedSteamID[client], BooltoInt(g_bAdminFlagTitlesTemp[client][0]), BooltoInt(g_bAdminFlagTitlesTemp[client][1]), BooltoInt(g_bAdminFlagTitlesTemp[client][2]), BooltoInt(g_bAdminFlagTitlesTemp[client][3]), BooltoInt(g_bAdminFlagTitlesTemp[client][4]), BooltoInt(g_bAdminFlagTitlesTemp[client][5]), BooltoInt(g_bAdminFlagTitlesTemp[client][6]), BooltoInt(g_bAdminFlagTitlesTemp[client][7]), BooltoInt(g_bAdminFlagTitlesTemp[client][8]), BooltoInt(g_bAdminFlagTitlesTemp[client][9]), BooltoInt(g_bAdminFlagTitlesTemp[client][10]), BooltoInt(g_bAdminFlagTitlesTemp[client][11]), BooltoInt(g_bAdminFlagTitlesTemp[client][12]), BooltoInt(g_bAdminFlagTitlesTemp[client][13]), BooltoInt(g_bAdminFlagTitlesTemp[client][14]), BooltoInt(g_bAdminFlagTitlesTemp[client][15]), BooltoInt(g_bAdminFlagTitlesTemp[client][16]), BooltoInt(g_bAdminFlagTitlesTemp[client][17]), BooltoInt(g_bAdminFlagTitlesTemp[client][18]), BooltoInt(g_bAdminFlagTitlesTemp[client][19]), BooltoInt(g_bAdminFlagTitlesTemp[client][20]), BooltoInt(g_bAdminFlagTitlesTemp[client][21]), BooltoInt(g_bAdminFlagTitlesTemp[client][22]), titleID);
	SQL_TQuery(g_hDb, SQL_insertFlagCallback, szQuery, client, DBPrio_Low);
}

public SQL_insertFlagCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_insertFlagCallback): %s ", error);
		return;
	}

	if (IsValidClient(data))
		PrintToChat(data, "[%cCK%c] Succesfully granted title to a player", MOSSGREEN, WHITE);

	db_checkChangesInTitle(g_iAdminSelectedClient[data], g_szAdminSelectedSteamID[data]);
}

public db_updatePlayerTitles(client, titleID)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_updatePlayerFlags, g_bAdminFlagTitlesTemp[client][0], g_bAdminFlagTitlesTemp[client][1], g_bAdminFlagTitlesTemp[client][2], g_bAdminFlagTitlesTemp[client][3], g_bAdminFlagTitlesTemp[client][4], g_bAdminFlagTitlesTemp[client][5], g_bAdminFlagTitlesTemp[client][6], g_bAdminFlagTitlesTemp[client][7], g_bAdminFlagTitlesTemp[client][8], g_bAdminFlagTitlesTemp[client][9], g_bAdminFlagTitlesTemp[client][10], g_bAdminFlagTitlesTemp[client][11], g_bAdminFlagTitlesTemp[client][12], g_bAdminFlagTitlesTemp[client][13], g_bAdminFlagTitlesTemp[client][14], g_bAdminFlagTitlesTemp[client][15], g_bAdminFlagTitlesTemp[client][16], g_bAdminFlagTitlesTemp[client][17], g_bAdminFlagTitlesTemp[client][18], g_bAdminFlagTitlesTemp[client][19], g_bAdminFlagTitlesTemp[client][20], g_bAdminFlagTitlesTemp[client][21], g_bAdminFlagTitlesTemp[client][22], titleID, g_szAdminSelectedSteamID[client]);
	SQL_TQuery(g_hDb, SQL_updatePlayerFlagsCallback, szQuery, client, DBPrio_Low);
}

public SQL_updatePlayerFlagsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_updatePlayerFlagsCallback): %s ", error);
		return;
	}

	if (IsValidClient(data))
		PrintToChat(data, "[%cCK%c] Succesfully updated player's titles", MOSSGREEN, WHITE);
	
	if (g_iAdminSelectedClient[data] != -1)
		db_checkChangesInTitle(g_iAdminSelectedClient[data], g_szAdminSelectedSteamID[data]);
}

public db_updatePlayerTitleInUse(client, char szSteamId[32])
{
	char szQuery[512];
	Format(szQuery, 512, sql_updatePlayerFlagsInUse, g_iTitleInUse[client], szSteamId);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client, DBPrio_Low);
}

public db_deletePlayerTitles(client)
{
	if (IsValidClient(g_iAdminSelectedClient[client]))
	{
		GetClientAuthId(g_iAdminSelectedClient[client], AuthId_Steam2, g_szAdminSelectedSteamID[client], MAX_NAME_LENGTH,true);	
		//GetClientAuthString(g_iAdminSelectedClient[client], g_szAdminSelectedSteamID[client], MAX_NAME_LENGTH, true);
	}
	else if (StrEqual(g_szAdminSelectedSteamID[client], ""))
		return;
		
	char szQuery[258];
	Format(szQuery, 258, sql_deletePlayerFlags, g_szAdminSelectedSteamID[client]);
	SQL_TQuery(g_hDb, SQL_deletePlayerTitlesCallback, szQuery, client, DBPrio_Low);
}

public SQL_deletePlayerTitlesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_deletePlayerTitlesCallback): %s ", error);
		return;
	}

	PrintToChat(data, "[%cCK%c] Succesfully deleted player's titles.", MOSSGREEN, WHITE);
	db_checkChangesInTitle(g_iAdminSelectedClient[data], g_szAdminSelectedSteamID[data]);
}

/////////////////////////
//// SPAWN LOCATIONS ////
/////////////////////////

public db_deleteSpawnLocations(int zGrp)
{
	g_bGotSpawnLocation[zGrp] = false;
	char szQuery[128];
	Format(szQuery, 128, sql_deleteSpawnLocations, g_szMapName, zGrp);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, 1, DBPrio_Low);
}


public db_updateSpawnLocations(float position[3], float angle[3], zGrp)
{
	char szQuery[512];
	Format(szQuery, 512, sql_updateSpawnLocations, position[0], position[1], position[2], angle[0], angle[1], angle[2], g_szMapName, zGrp);
	SQL_TQuery(g_hDb, db_editSpawnLocationsCallback, szQuery, zGrp, DBPrio_Low);
}

public db_insertSpawnLocations(float position[3], float angle[3], zGrp)
{
	char szQuery[512];
	Format(szQuery, 512, sql_insertSpawnLocations, g_szMapName, position[0], position[1], position[2], angle[0], angle[1], angle[2], zGrp);
	SQL_TQuery(g_hDb, db_editSpawnLocationsCallback, szQuery, zGrp, DBPrio_Low);
}

public db_editSpawnLocationsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_editSpawnLocationsCallback): %s ", error);
		return;
	}
	db_selectSpawnLocations(data);
}

public db_selectSpawnLocations(int zGrp)
{
	for (int i = 0; i < MAXZONEGROUPS; i++)
		g_bGotSpawnLocation[i] = false;

	char szQuery[254];
	Format(szQuery, 254, sql_selectSpawnLocations, g_szMapName);
	SQL_TQuery(g_hDb, db_selectSpawnLocationsCallback, szQuery, 1, DBPrio_Low);
}

public db_selectSpawnLocationsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_selectSpawnLocationsCallback): %s ", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			g_bGotSpawnLocation[SQL_FetchInt(hndl, 7)] = true;
			g_fSpawnLocation[SQL_FetchInt(hndl, 7)][0] = SQL_FetchFloat(hndl, 1);
			g_fSpawnLocation[SQL_FetchInt(hndl, 7)][1] = SQL_FetchFloat(hndl, 2);
			g_fSpawnLocation[SQL_FetchInt(hndl, 7)][2] = SQL_FetchFloat(hndl, 3);
			g_fSpawnAngle[SQL_FetchInt(hndl, 7)][0] = SQL_FetchFloat(hndl, 4);
			g_fSpawnAngle[SQL_FetchInt(hndl, 7)][1] = SQL_FetchFloat(hndl, 5);
			g_fSpawnAngle[SQL_FetchInt(hndl, 7)][2] = SQL_FetchFloat(hndl, 6);
		}
	}
}



/////////////////////
//// PLAYER RANK ////
/////////////////////

public db_viewMapProRankCount()
{
	char szQuery[512];
	Format(szQuery, 512, sql_selectPlayerProCount, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectPlayerProCountCallback, szQuery,DBPrio_Low);
}
public sql_selectPlayerProCountCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectPlayerProCountCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_MapTimesCount = SQL_GetRowCount(hndl);
	else
		g_MapTimesCount = 0;
}

//
// Get players rank in current map
//
public db_viewMapRankPro(client, rank)
{
	char szQuery[512];
	if (!IsValidClient(client))
		return;

	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, rank);

	//"SELECT name,mapname FROM ck_playertimes WHERE runtimepro <= (SELECT runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";
	Format(szQuery, 512, sql_selectPlayerRankProTime, g_szSteamID[client], g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, db_viewMapRankProCallback, szQuery, pack, DBPrio_Low);
}

public db_viewMapRankProCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_viewMapRankProCallback): %s ", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int rank = ReadPackCell(data);  // Only used for ck_min_rank_announce
	CloseHandle(data);

	g_OldMapRank[client] = g_MapRank[client];
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl)){
		g_MapRank[client] = SQL_GetRowCount(hndl); 
	}
	if (g_bMapRankToChat[client]){
		MapFinishedMsgs(client, rank);		
	}
}

//
// Players points have changed in game, make changes in database and recalculate points
//
public db_updateStat(client) 
{
	char szQuery[512];
	//"UPDATE ck_playerrank SET finishedmaps ='%i', finishedmapspro='%i', multiplier ='%i'  where steamid='%s'";
	Format(szQuery, 512, sql_updatePlayerRank, g_pr_finishedmaps[client], g_pr_finishedmaps[client],g_pr_multiplier[client],g_szSteamID[client]);
	SQL_TQuery(g_hDb, SQL_UpdateStatCallback, szQuery, client, DBPrio_Low);
	
}

public SQL_UpdateStatCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_UpdateStatCallback): %s", error);
		return;
	}

	// Calculating starts here:
	CalculatePlayerRank(data);
}

public RecalcPlayerRank(client, char steamid[128])
{
	int i = 66;
	while (g_bProfileRecalc[i] == true)
		i++;
	if (!g_bProfileRecalc[i])
	{
		char szQuery[255];
		char szsteamid[128*2+1];
		SQL_EscapeString(g_hDb, steamid, szsteamid, 128*2+1);    
		Format(g_pr_szSteamID[i], 32, "%s", steamid); 	
		Format(szQuery, 255, sql_selectPlayerName, szsteamid); 
		Handle pack = CreateDataPack();
		WritePackCell(pack, i);	
		WritePackCell(pack, client);		
		SQL_TQuery(g_hDb, sql_selectPlayerNameCallback, szQuery, pack);	    
	}
}

//
//  1. Point calculating starts here
// 	There are two ways:
//	- if client > MAXPLAYERS, his rank is being recalculated by an admin
//	- else player has increased his rank = recalculate points	
//
public CalculatePlayerRank(client)
{
	char szQuery[255];      
	char szSteamId[32];
	// Take old points into memory, so at the end you can show how much the points changed
	g_pr_oldpoints[client] = g_pr_points[client];
	// Initialize point calculatin
	g_pr_points[client] = 0;

	// Get steamid - Points are being recalculated by an admin (pretty much going through top 20k players)
	if (client>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else // Get steamid - Normal point increase
	{
		if (!g_bPointSystem || !IsValidClient(client)) 
			return;
		GetClientAuthId(client, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH,true);
		//GetClientAuthString(client, szSteamId, 32);
	}

	//"SELECT steamid, name, points, finishedmapspro, multiplier, country, lastseen from ck_playerrank where steamid='%s'";
	Format(szQuery, 255, sql_selectRankedPlayer, szSteamId);  
	SQL_TQuery(g_hDb, sql_selectRankedPlayerCallback, szQuery,client, DBPrio_Low);	
}

//
// 2. Count points from improvements, or insert new player into the database
//
public sql_selectRankedPlayerCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectRankedPlayerCallback): %s", error);
		return;
	}

	char szSteamId[32];

	// Get SteamID of a player who is being recalculated
	if (data>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[data])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[data]); 
	}
	else // Get SteamID of a player who gained points
	{
		if (IsValidClient(data))
			GetClientAuthId(data, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH,true);
//			GetClientAuthString(data, szSteamId, 32);
		else 
			return;
	}	// Found players information in database
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		//"SELECT steamid, name, points, finishedmapspro, multiplier, country, lastseen from playerrank where steamid='%s'";

		if (data <= MAXPLAYERS && IsValidClient(data))
		{
			float  diff = GetGameTime() - g_fMapStartTime;
			if (GetClientTime(data) < diff)
				db_UpdateLastSeen(data); // Update last seen on server
		}
		// Multiplier = The amount of times a player has improved on his time
		g_pr_multiplier[data] = SQL_FetchInt(hndl, 4);
		if (g_pr_multiplier[data] < 0)
			g_pr_multiplier[data] = g_pr_multiplier[data] * -1;

		// Multiplier increases players points by the set amount in ck_ranking_extra_points_improvements
		g_pr_points[data] +=  g_ExtraPoints * g_pr_multiplier[data];		

		if (IsValidClient(data))
			g_pr_Calculating[data] = true;

		// Next up, challenge points
		char szQuery[512];
		//"SELECT steamid, steamid2, bet, map FROM ck_challenges where steamid = '%s' OR steamid2 ='%s'";
		Format(szQuery, 512, sql_selectChallenges, szSteamId,szSteamId);
		SQL_TQuery(g_hDb, sql_selectChallengesCallbackCalc, szQuery, data,DBPrio_Low);	
	}
	else
	{
		// Players first time on server
		if (data <= MaxClients)
		{
			g_pr_Calculating[data] = false;
			g_pr_AllPlayers++;

			// Insert player to database
			char szQuery[255];
			char szUName[MAX_NAME_LENGTH];
			char szName[MAX_NAME_LENGTH*2+1];      

			GetClientName(data, szUName, MAX_NAME_LENGTH);
			SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);

			//"INSERT INTO ck_playerrank (steamid, name, country) VALUES('%s', '%s', '%s');";
			// No need to continue calculating, as the doesn't have any records.
			Format(szQuery, 255, sql_insertPlayerRank, szSteamId, szName,g_szCountry[data]);
			SQL_TQuery(g_hDb, SQL_InsertPlayerCallBack, szQuery, data, DBPrio_Low);

			g_pr_multiplier[data] = 0;
			g_pr_finishedmaps[data] = 0;
			g_pr_finishedmaps_perc[data] = 0.0;
		}
	}
}

//
// 3. Counting points gained from challenges
//
public sql_selectChallengesCallbackCalc(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectChallengesCallbackCalc): %s", error);
		return;
	}

	char szQuery[512];   
	char szSteamId[32];	
	char szSteamIdChallenge[32];	
	

	// Get SteamID, first is for admin recounting points, 2nd is for gaining points normally
	if (data>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[data])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[data]); 
	}
	else
	{
		if (IsValidClient(data))
			GetClientAuthId(data, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH,true);
			//GetClientAuthString(data, szSteamId, 32);
		else
			return;
	}

	int bet;

	if(SQL_HasResultSet(hndl))
	{	
		//"SELECT steamid, steamid2, bet, map FROM challenges where steamid = '%s' OR steamid2 ='%s'";
		g_Challenge_WinRatio[data] = 0;
		g_Challenge_PointsRatio[data] = 0;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szSteamIdChallenge, 32);
			bet = SQL_FetchInt(hndl, 2);
			if (StrEqual(szSteamIdChallenge,szSteamId)) // Won the challenge
			{
				g_Challenge_WinRatio[data]++;
				g_Challenge_PointsRatio[data]+= bet;
			}
			else 										// Lost the challenge
			{
				g_Challenge_WinRatio[data]--;
				g_Challenge_PointsRatio[data]-= bet;
			}
		}
	}
	if (g_bChallengePoints) // If challenge points are enabled: add them to players points
		g_pr_points[data]+= g_Challenge_PointsRatio[data];

	// Next up, calculate bonus points:
	//SELECT mapname, zonegroup FROM ck_bonus WHERE steamid = '%s' AND runtime > 0.0
	Format(szQuery, 512, sql_selectPersonalBonusCompleted, szSteamId); 
	SQL_TQuery(g_hDb, sql_CountFinishedBonusCallback, szQuery, data, DBPrio_Low);
}

//
// 4. Get players rank in bonuses
//
public sql_CountFinishedBonusCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_CountFinishedBonusCallback): %s", error);
		return;
	}

	char szQuery[512], szSteamId[32];

	// Get SteamID, first is for admin recounting points, 2nd is for gaining points normally
	if (data>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[data])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[data]); 
	}
	else
	{
		if (IsValidClient(data))
			GetClientAuthId(data, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH,true);
//			GetClientAuthString(data, szSteamId, 32);
		else
			return;
	}

	// Count the amount of finished bonuses, and check that the map is in mapcycle
	if(SQL_HasResultSet(hndl))
	{
		g_clientFinishedBonuses[data] = SQL_GetRowCount(hndl);
		g_ClientFinishedBonusesRowCount[data] = 0;
		int zonegrp;
		char mapName[128];
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, mapName, 128);
			zonegrp = SQL_FetchInt(hndl, 1);

			// Get rank in each bonus
			Format(szQuery, 512, "SELECT name, mapname, zonegroup FROM ck_bonus WHERE runtime <= (SELECT runtime FROM ck_bonus WHERE steamid = '%s' AND mapname = '%s' AND runtime > -1.0 AND zonegroup = %i) AND mapname = '%s' AND runtime > -1.0 AND zonegroup = '%i' ORDER BY runtime;", szSteamId, mapName, zonegrp, mapName, zonegrp);
			SQL_TQuery(g_hDb, sql_selectBonusRankCallback, szQuery, data, DBPrio_Low);
		}
	}
	else // Player hasn't finished any bonuses, move to map points
	{
		// Next up: Points from maps
		//"SELECT mapname FROM ck_playertimes where steamid='%s' AND runtimepro > -1.0";
		Format(szQuery, 512, sql_CountFinishedMaps, szSteamId);  
		SQL_TQuery(g_hDb, sql_CountFinishedMapsCallback, szQuery, data, DBPrio_Low);
	}
}


//
// 5. Get percentile rank of rank in bonuses
//
public sql_selectBonusRankCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectBonusRankCallback): %s", error);
		return;
	}

	char szMapName[128];
	char szQuery[255]; 

	//"SELECT name, mapname, zonegroup FROM ck_bonus WHERE runtime <= (SELECT runtime FROM ck_bonus WHERE steamid = '%s' AND mapname = '%s' AND runtime > -1.0 AND zonegroup = %i) AND mapname = '%s' AND runtime > -1.0 AND zonegroup = '%i' ORDER BY runtime;", szSteamId, mapName, zonegroup, mapName, zonegrp);
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, szMapName, 128);	
		int rank = SQL_GetRowCount(hndl);
		int zonegrp = SQL_FetchInt(hndl, 2);

		Handle pack = CreateDataPack();
		WritePackCell(pack, data);
		WritePackCell(pack, rank);
		WritePackString(pack, szMapName);
		
		Format(szQuery, 255, "SELECT name FROM ck_bonus WHERE mapname = '%s' AND runtime > -1.0 AND zonegroup = %i;", szMapName, zonegrp);
		SQL_TQuery(g_hDb, sql_selectBonusPercentileCallback, szQuery, pack, DBPrio_Low);
	}
}


//
// 6. Give points based on bonus rank + percentile
//
public sql_selectBonusPercentileCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectBonusPercentileCallback): %s", error);
		return;
	}

	char szMap[128], szSteamId[128];

	ResetPack(data);
	int client = ReadPackCell(data);
	int rank = ReadPackCell(data);
	ReadPackString(data, szMap, 128);	
	CloseHandle(data);

	// Get SteamID, first is for admin recounting points, 2nd is for gaining points normally
	if (client>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[client])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[client]); 
	}
	else
	{
		if (IsValidClient(client))
			GetClientAuthId(client, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH,true);
//			GetClientAuthString(client, szSteamId, 32);
		else
			return;
	}

	char szMapName2[128];

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		// Total amount of players who have finished the bonus
		int count = SQL_GetRowCount(hndl);
		for (int i = 0; i < GetArraySize(g_MapList); i++) // Check that the map is in the mapcycle
		{
			GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));	
			if (StrEqual(szMapName2, szMap, false))
			{
				float percentage = 1.0 + ((1.0/float(count)) - (float(rank)/float(count)));
				g_pr_points[client]+= RoundToCeil(200.0 * percentage);					
				switch(rank) 
				{
					case 1: g_pr_points[client]+= 200;
					case 2: g_pr_points[client]+= 190;
					case 3: g_pr_points[client]+= 180;
					case 4: g_pr_points[client]+= 170;
					case 5: g_pr_points[client]+= 150;
					case 6: g_pr_points[client]+= 140;
					case 7: g_pr_points[client]+= 135;
					case 8: g_pr_points[client]+= 120;
					case 9: g_pr_points[client]+= 115;
					case 10: g_pr_points[client]+= 105;
					case 11: g_pr_points[client]+= 100;
					case 12: g_pr_points[client]+= 90;
					case 13: g_pr_points[client]+= 80;
					case 14: g_pr_points[client]+= 75;
					case 15: g_pr_points[client]+= 60;
					case 16: g_pr_points[client]+= 50;
					case 17: g_pr_points[client]+= 40;
					case 18: g_pr_points[client]+= 30;
					case 19: g_pr_points[client]+= 20;
					case 20: g_pr_points[client]+= 10;
				}	
				break;
			}				
		}
	}
	g_ClientFinishedBonusesRowCount[client]++;
	if (g_ClientFinishedBonusesRowCount[client] == g_clientFinishedBonuses[client])
	{
		// Next up: Points from maps
		//"SELECT mapname FROM ck_playertimes where steamid='%s' AND runtimepro > -1.0";
		char szQuery[512];
		Format(szQuery, 512, sql_CountFinishedMaps, szSteamId);  
		SQL_TQuery(g_hDb, sql_CountFinishedMapsCallback, szQuery, client, DBPrio_Low);
	}
}


//
// 7. Count the amount of maps finished and gain points from ck_ranking_extra_points_firsttime
//
public sql_CountFinishedMapsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_CountFinishedMapsCallback): %s", error);
		return;
	}

	char szQuery[1024];   
	char szSteamId[32];
	char MapName[128];
	char MapName2[128];
	int finished_Pro=0;
	
	// Get SteamID, first is for admin recounting points, 2nd is for gaining points normally
	if (data>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[data])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[data]); 
	}
	else
	{
		if (IsValidClient(data))
			GetClientAuthId(data, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH,true);
			//GetClientAuthString(data, szSteamId, 32);
		else
			return;
	}

	// Count the amount of maps finished and check that they are in the mapcycle
	if(SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			//"SELECT mapname FROM playertimes where steamid='%s' AND runtimepro > -1.0";

			SQL_FetchString(hndl, 0, MapName, 128);	
			for (int i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, MapName2, sizeof(MapName2));
				if (StrEqual(MapName2, MapName, false))
				{
					finished_Pro++;
					continue;
				}
			}			
		}

		// Finished maps amount is stored in memory
		g_pr_finishedmaps[data]=finished_Pro;
		// Percentage of maps finished
		g_pr_finishedmaps_perc[data]= (float(finished_Pro) / float(g_pr_MapCount)) * 100.0;
		// Points gained from 
		g_pr_points[data]+= (finished_Pro * g_ExtraPoints2);

		//Next up: Get runtimes from database
		//"SELECT db1.name, db2.steamid, db2.mapname, db2.runtimepro as overall, db1.steamid FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.steamid = '%s' AND db2.runtimepro > -1.0 ORDER BY mapname ASC;";
		Format(szQuery, 1024, sql_selectPersonalAllRecords, szSteamId, szSteamId);  
		if ((StrContains(szSteamId, "STEAM_") != -1)) // Bugged ID's are ignored
			SQL_TQuery(g_hDb, sql_selectPersonalAllRecordsCallback, szQuery, data, DBPrio_Low);			
	}	
}

//
// 8. Use maptimes to check ranks in maps
//
public sql_selectPersonalAllRecordsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error(sql_selectPersonalAllRecordsCallback): %s", error);
		return;
	}

	char szQuery[1024];  
	char szMapName[128];
	char szSteamId[32];

	// Get SteamID, first is for admin recounting points, 2nd is for gaining points normally
	if (data>MAXPLAYERS)
	{
		if (!g_pr_RankingRecalc_InProgress && !g_bProfileRecalc[data])
			return;
		Format(szSteamId, 32, "%s", g_pr_szSteamID[data]); 
	}
	else
	{
		if (IsValidClient(data))
			GetClientAuthId(data, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH,true);
			//GetClientAuthString(data, szSteamId, 32);
		else
			return;
	}

	// Maptimes were found in the database
	//"SELECT db1.name, db2.steamid, db2.mapname, db2.runtimepro as overall, db1.steamid FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.steamid = '%s' AND db2.runtimepro > -1.0 ORDER BY mapname ASC;";
	if(SQL_HasResultSet(hndl))
	{
		g_pr_maprecords_row_counter[data]=0;
		g_pr_maprecords_row_count[data] = SQL_GetRowCount(hndl);
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 2, szMapName, 128);
			//Return the names of players, who were faster than the steamID in the map
			//"SELECT name,mapname FROM ck_playertimes WHERE runtimepro <= (SELECT runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";
			Format(szQuery, 1024, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
			SQL_TQuery(g_hDb, sql_selectPlayerRankCallback, szQuery, data, DBPrio_Low);								
		}	
	}
	if (g_pr_maprecords_row_count[data]==0)
	{
		db_updatePoints(data);		
	}	
}

//
// 9. Select the total amount of players, who have finished the map
//
public 	sql_selectPlayerRankCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectPlayerRankCallback): %s", error);
		return;
	}

	char szMapName[128];
	char szQuery[255];  
	//"SELECT name,mapname FROM playertimes WHERE runtimepro <= (SELECT runtimepro FROM playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, szMapName, 128);	
		int rank = SQL_GetRowCount(hndl);

		Handle pack = CreateDataPack();
		WritePackCell(pack, data);
		WritePackCell(pack, rank);
		WritePackString(pack, szMapName);
		
		//"SELECT name FROM ck_playertimes WHERE mapname = '%s' AND runtimepro  > -1.0;";
		Format(szQuery, 255, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, sql_selectPlayerRankCallback2, szQuery, pack, DBPrio_Low);
	}
}

//
// 10. Give players points based on rank + the percentile rank they are at
//
public sql_selectPlayerRankCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectPlayerRankCallback2): %s", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int rank = ReadPackCell(data);
	char szMap[64];
	ReadPackString(data, szMap, 64);	
	CloseHandle(data);

	char szMapName2[128];

	if (hndl == null)
		return;

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		// Total amount of players who have finished the map
		int count = SQL_GetRowCount(hndl);
		for (int i = 0; i < GetArraySize(g_MapList); i++) // Check that the map is in the mapcycle
		{
			GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));	
			if (StrEqual(szMapName2, szMap, false))
			{
				float  percentage = 1.0 + ((1.0/float(count)) - (float(rank) / float(count)));
				g_pr_points[client]+= RoundToCeil(200.0 * percentage);					
				switch(rank) 
				{
					case 1: g_pr_points[client]+= 500;
					case 2: g_pr_points[client]+= 400;
					case 3: g_pr_points[client]+= 375;
					case 4: g_pr_points[client]+= 350;
					case 5: g_pr_points[client]+= 325;
					case 6: g_pr_points[client]+= 300;
					case 7: g_pr_points[client]+= 275;
					case 8: g_pr_points[client]+= 250;
					case 9: g_pr_points[client]+= 225;
					case 10: g_pr_points[client]+= 200;
					case 11: g_pr_points[client]+= 175;
					case 12: g_pr_points[client]+= 150;
					case 13: g_pr_points[client]+= 125;
					case 14: g_pr_points[client]+= 100;
					case 15: g_pr_points[client]+= 90;
					case 16: g_pr_points[client]+= 80;
					case 17: g_pr_points[client]+= 70;
					case 18: g_pr_points[client]+= 60;
					case 19: g_pr_points[client]+= 50;
					case 20: g_pr_points[client]+= 40;
				}	
				break;
			}				
		}
	}
	g_pr_maprecords_row_counter[client]++;
	if (g_pr_maprecords_row_counter[client]==g_pr_maprecords_row_count[client])
	{
		// Done checking, update points
		db_updatePoints(client);		
	}
}

//
// 11. Updating points to database
//
public db_updatePoints(client)
{
	char szQuery[512];
	char szName[MAX_NAME_LENGTH];	
	char szSteamId[32];	
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
			GetClientAuthId(client, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH,true);
			//GetClientAuthString(client, szSteamId, MAX_NAME_LENGTH);		
			Format(szQuery, 512, sql_updatePlayerRankPoints2, szName, g_pr_points[client], g_pr_finishedmaps[client],g_Challenge_WinRatio[client],g_Challenge_PointsRatio[client],g_szCountry[client], szSteamId); 
			SQL_TQuery(g_hDb, sql_updatePlayerRankPointsCallback, szQuery, client, DBPrio_Low);
		}
	}	
}

//
// 12. Calculations done, if calculating all, move forward, if not announce changes.
//
public sql_updatePlayerRankPointsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_updatePlayerRankPointsCallback): %s", error);
		return;
	}

	// If was recalculating points, go to the next player, announce or end calculating
	if (data>MAXPLAYERS &&  g_pr_RankingRecalc_InProgress  || data>MAXPLAYERS && g_bProfileRecalc[data])
	{		
		if (g_bProfileRecalc[data] && !g_pr_RankingRecalc_InProgress)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i))
				{
					if(StrEqual(g_szSteamID[i],g_pr_szSteamID[data]))
						CalculatePlayerRank(i);
				}
			}
		}
		g_bProfileRecalc[data] = false;
		if (g_pr_RankingRecalc_InProgress)
		{
			//console info
			if (IsValidClient(g_pr_Recalc_AdminID) && g_bManualRecalc)
				PrintToConsole(g_pr_Recalc_AdminID, "%i/%i",g_pr_Recalc_ClientID,g_pr_TableRowCount); 
			int x = 66+g_pr_Recalc_ClientID;
			if(StrContains(g_pr_szSteamID[x],"STEAM",false)!=-1)  
			{
				ContinueRecalc(x);
			}
			else
			{
				for (int i = 1; i <= MaxClients; i++)
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
	else // Gaining points normally
	{	
		// Player recalculated own points in !profile
		if (g_bRecalcRankInProgess[data] && data <= MAXPLAYERS)
		{
			ProfileMenu(data, -1);
			if (IsValidClient(data))
				PrintToChat(data, "%t", "Rc_PlayerRankFinished", MOSSGREEN,WHITE,GRAY,PURPLE,g_pr_points[data],GRAY);	
			g_bRecalcRankInProgess[data]=false;
		}
		if (IsValidClient(data) && g_pr_showmsg[data]) // Player gained points
		{	
			char szName[MAX_NAME_LENGTH];	
			GetClientName(data, szName, MAX_NAME_LENGTH);	
			int diff = g_pr_points[data] - g_pr_oldpoints[data];	
			if (diff > 0) // if player earned points -> Announce
			{
				for (int i = 1; i <= MaxClients; i++)
					if (IsValidClient(i))
						PrintToChat(i, "%t", "EarnedPoints", MOSSGREEN, WHITE, PURPLE,szName, GRAY, PURPLE, diff,GRAY,PURPLE, g_pr_points[data], GRAY);
			}
			g_pr_showmsg[data]=false;
			db_CalculatePlayersCountGreater0();
		}	
		g_pr_Calculating[data] = false;
		db_GetPlayerRank(data);
		CreateTimer(1.0, SetClanTag, data,TIMER_FLAG_NO_MAPCHANGE);			
	}
}

//
// Called when player joins server
//
public db_viewPlayerPoints(client) 
{
	g_pr_multiplier[client] = 0;
	g_pr_finishedmaps[client] = 0;
	g_pr_finishedmaps_perc[client] = 0.0;
	g_pr_points[client] = 0;
	char szQuery[255];      
	if (!IsValidClient(client))
		return;

	//"SELECT steamid, name, points, finishedmapspro, multiplier, country, lastseen from ck_playerrank where steamid='%s'";
	Format(szQuery, 255, sql_selectRankedPlayer, g_szSteamID[client]);     
	SQL_TQuery(g_hDb, db_viewPlayerPointsCallback, szQuery,client,DBPrio_Low);	
}

public db_viewPlayerPointsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_viewPlayerPointsCallback): %s", error);
		return;
	}

	// Old player - get points
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{		
		g_pr_points[data]=SQL_FetchInt(hndl, 2);	
		g_pr_finishedmaps[data] = SQL_FetchInt(hndl, 3);	
		g_pr_multiplier[data] = SQL_FetchInt(hndl, 4);
		if (g_pr_multiplier[data] < 0)
			g_pr_multiplier[data] = -1 * g_pr_multiplier[data];
		g_pr_finishedmaps_perc[data]= (float(g_pr_finishedmaps[data]) / float(g_pr_MapCount)) * 100.0;	
		if (IsValidClient(data)) // Count players rank
			db_GetPlayerRank(data);
	}
	else
	{	// New player - insert
		if (IsValidClient(data))
		{
			//insert	
			char szQuery[512];
			char szUName[MAX_NAME_LENGTH];

			if (IsValidClient(data))
				GetClientName(data, szUName, MAX_NAME_LENGTH);
			else
				return;

			// SQL injection protection
			char szName[MAX_NAME_LENGTH*2+1];      
			SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);

			Format(szQuery, 512, sql_insertPlayerRank, g_szSteamID[data], szName,g_szCountry[data]); 
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
			db_GetPlayerRank(data); // Count players rank
		}
	}
}

//
// Get the amount of palyers, who have more points
//
public db_GetPlayerRank(client)
{
	char szQuery[512];
	//"SELECT name FROM ck_playerrank WHERE points >= (SELECT points FROM ck_playerrank WHERE steamid = '%s') ORDER BY points";
	Format(szQuery, 512, sql_selectRankedPlayersRank, g_szSteamID[client]);
	SQL_TQuery(g_hDb, sql_selectRankedPlayersRankCallback, szQuery, client,DBPrio_Low);		
}

public sql_selectRankedPlayersRankCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectRankedPlayersRankCallback): %s", error);
		return;
	}

	if (!IsValidClient(data))
		return;

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_PlayerRank[data] = SQL_GetRowCount(hndl);
		// Sort players by rank in scoreboard
		if (g_pr_AllPlayers < g_PlayerRank[data])
			CS_SetClientContributionScore(data, 0);
		else
			CS_SetClientContributionScore(data, (g_pr_AllPlayers - SQL_GetRowCount(hndl)));
	}
}

public db_resetPlayerRecords(client, char steamid[128])
{
	char szQuery[255];    
	char szsteamid[128*2+1];
	SQL_EscapeString(g_hDb, steamid, szsteamid, 128*2+1);   	
	Format(szQuery, 255, sql_resetRecords, szsteamid);       
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);	        
	PrintToConsole(client, "map times of %s cleared.", szsteamid);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);	
	SQL_TQuery(g_hDb, SQL_CheckCallback3, "UPDATE ck_playerrank SET multiplier ='0'", pack);
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			if(StrEqual(g_szSteamID[i],szsteamid))
			{
				Format(g_szPersonalRecord[i], 64, "NONE");
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

	SQL_FastQuery(g_hDb, sql_createPlayerRank);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "playerranks table dropped. Please restart your server!");
}

public db_dropPlayer(client)
{
	SQL_TQuery(g_hDb, sql_selectMutliplierCallback, "UPDATE ck_playerrank SET multiplier ='0'", client);
	SQL_LockDatabase(g_hDb);
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropPlayer);
	else
		SQL_FastQuery(g_hDb, sqlite_dropPlayer);
	SQL_FastQuery(g_hDb, sql_createPlayertimes);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "playertimes table dropped. Please restart your server!");
}

public db_viewPlayerRank(client, char szSteamId[32])
{
	char szQuery[512];  
	Format(g_pr_szrank[client], 512, "");	
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback, szQuery, client,DBPrio_Low);
}

public SQL_ViewRankedPlayerCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRankedPlayerCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{	
		char szQuery[512];
		char szName[MAX_NAME_LENGTH];
		char szCountry[100];
		char szLastSeen[100];
		char szSteamId[32];
		int finishedmapspro;
		int points;
		g_MapRecordCount[data] = 0;	
		
		//get the result
		SQL_FetchString(hndl, 0, szSteamId, 32);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
		points = SQL_FetchInt(hndl, 2);
		finishedmapspro = SQL_FetchInt(hndl, 3);
		SQL_FetchString(hndl, 5, szCountry, 100);
		SQL_FetchString(hndl, 6, szLastSeen, 100);
		Handle pack_pr = CreateDataPack();	
		WritePackString(pack_pr, szName);
		WritePackString(pack_pr, szSteamId);	
		WritePackCell(pack_pr, data);		
		WritePackCell(pack_pr, points);
		WritePackCell(pack_pr, finishedmapspro);
		WritePackString(pack_pr, szCountry);	
		WritePackString(pack_pr, szLastSeen);	
		Format(szQuery, 512, sql_selectRankedPlayersRank, szSteamId);
		SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback2, szQuery, pack_pr,DBPrio_Low);
	}
}




public SQL_ViewRankedPlayerCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRankedPlayerCallback2): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		char szQuery[512];
		char szSteamId[32];
		char szName[MAX_NAME_LENGTH];
		int rank = SQL_GetRowCount(hndl);

		WritePackCell(data, rank);
		ResetPack(data);	        
		ReadPackString(data, szName, MAX_NAME_LENGTH);
		ReadPackString(data, szSteamId, 32);	
		Format(szQuery, 512, sql_selectMapRecordCount, szSteamId);
		SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback4, szQuery, data,DBPrio_Low);	
	}
}

public SQL_ViewRankedPlayerCallback4(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRankedPlayerCallback4): %s", error);
		return;
	}

	char szQuery[512];
	char szSteamId[32];
	char szName[MAX_NAME_LENGTH];

	ResetPack(data);       
	ReadPackString(data, szName, MAX_NAME_LENGTH);
	ReadPackString(data, szSteamId, 32);		
	int client = ReadPackCell(data);  
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl)) 
		g_MapRecordCount[client] = SQL_FetchInt(hndl, 1);	//pack full?
	Format(szQuery, 512, sql_selectChallenges, szSteamId,szSteamId);
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback5, szQuery, data,DBPrio_Low);		
}

public SQL_ViewRankedPlayerCallback5(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRankedPlayerCallback5): %s", error);
		return;
	}

	char szChallengesPoints[32];
	Format(szChallengesPoints, 32, "0p");
	char szChallengesWinRatio[32];
	Format(szChallengesWinRatio, 32, "0");

	char szName[MAX_NAME_LENGTH];
	char szSteamId[32];
	char szSteamIdChallenge[32];
	char szCountry[100];
	char szLastSeen[100];
	char szNextRank[32];
	char szSkillGroup[32];
	
	ResetPack(data);     
	ReadPackString(data, szName, MAX_NAME_LENGTH);
	ReadPackString(data, szSteamId, 32);
	int client = ReadPackCell(data);       
	int points = ReadPackCell(data);
	int finishedmapspro = ReadPackCell(data);  
	ReadPackString(data, szCountry, 100);	
	ReadPackString(data, szLastSeen, 100);	
	if (StrEqual(szLastSeen,""))
		Format(szLastSeen, 100, "Unknown");
	int rank = ReadPackCell(data);
	int prorecords = g_MapRecordCount[client];
	Format(g_szProfileSteamId[client], 32, "%s", szSteamId);
	Format(g_szProfileName[client], MAX_NAME_LENGTH, "%s", szName);
	bool master=false;
	int RankDifference;		   
	CloseHandle(data);	
	
	int bet;

	if (StrEqual(szSteamId, g_szSteamID[client]))
		g_PlayerRank[client] = rank;
		
	//get challenge results
	int challenges = 0;
	int challengeswon = 0;  
	int challengespoints = 0;  
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
	
	char szRank[32];
	if (rank > g_pr_RankedPlayers || points == 0)
		Format(szRank,32,"-");
	else
		Format(szRank,32,"%i", rank);
	
	char szRanking[255];
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
	char szID[32][2];
	ExplodeString(szSteamId,"_",szID,2,32);
	char szTitle[1024];
	if (g_bCountry)
		Format(szTitle, 1024, "Player: %s\nSteamID: %s\nNationality: %s \nLast seen: %s\n \n%s\n",  szName,szID[1],szCountry,szLastSeen,g_pr_szrank[client]);		
	else
		Format(szTitle, 1024, "Player: %s\nSteamID: %s\nLast seen: %s\n \n%s\n",  szName,szID[1],szLastSeen,g_pr_szrank[client]);				
			
	Handle menu = CreateMenu(ProfileMenuHandler);
	SetMenuTitle(menu, szTitle);
	AddMenuItem(menu, "Current Map time", "Current Map time");
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
}

public db_viewPlayerRank2(client, char szSteamId[32])
{
	char szQuery[512];  
	Format(g_pr_szrank[client], 512, "");	
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);  
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayer2Callback, szQuery, client,DBPrio_Low);
}

public SQL_ViewRankedPlayer2Callback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRankedPlayer2Callback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{	
		if (!IsValidClient(data))
			return;	
		
		char szQuery[512];
		char szName[MAX_NAME_LENGTH];
		char szSteamIdTarget[32];	
		SQL_FetchString(hndl, 0, szSteamIdTarget, 32);
		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
				
		Handle pack = CreateDataPack();
		WritePackCell(pack, data);
		WritePackString(pack, szName);
		Format(szQuery, 512, sql_selectChallengesCompare, g_szSteamID[data],szSteamIdTarget,szSteamIdTarget,g_szSteamID[data]);
		SQL_TQuery(g_hDb, sql_selectChallengesCompareCallback, szQuery, pack,DBPrio_Low);
	}
}

public db_viewPlayerAll2(client, char szPlayerName[MAX_NAME_LENGTH])
{
	char szQuery[512];
	char szName[MAX_NAME_LENGTH*2+1];
	SQL_EscapeString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);      
	Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT,szName,PERCENT);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, szPlayerName);
	SQL_TQuery(g_hDb, SQL_ViewPlayerAll2Callback, szQuery, pack,DBPrio_Low);
}

public SQL_ViewPlayerAll2Callback(Handle owner, Handle hndl, const char[] error, any:data)
{  

	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewPlayerAll2Callback): %s", error);
		return;
	}

	char szName[MAX_NAME_LENGTH]; 
	char szSteamId2[32];

	ResetPack(data);
	int client = ReadPackCell(data);      
	ReadPackString(data, szName, MAX_NAME_LENGTH);
	if (!IsValidClient(client))	
	{
		CloseHandle(data);
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
	CloseHandle(data);
}



public db_viewPlayerAll(client, char szPlayerName[MAX_NAME_LENGTH])
{
	char szQuery[512];
	char szName[MAX_NAME_LENGTH*2+1];
	SQL_EscapeString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);      
	Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT,szName,PERCENT);
	SQL_TQuery(g_hDb, SQL_ViewPlayerAllCallback, szQuery, client,DBPrio_Low);
}


public SQL_ViewPlayerAllCallback(Handle owner, Handle hndl, const char[] error, any:data)
{    
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewPlayerAllCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{           
		SQL_FetchString(hndl, 1, g_szProfileSteamId[data], 32);
		db_viewPlayerRank(data,g_szProfileSteamId[data]);
	}
	else
		if(IsClientInGame(data))
			PrintToChat(data, "%t", "PlayerNotFound", MOSSGREEN,WHITE, g_szProfileName[data]);
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
		float  diff = GetGameTime() - g_fMapStartTime + 1.5;
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
	char szQuery[128];       
	Format(szQuery, 128, sql_selectTopChallengers);   
	SQL_TQuery(g_hDb, sql_selectTopChallengersCallback, szQuery, client,DBPrio_Low);
}

public sql_selectTopChallengersCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectTopChallengersCallback): %s", error);
		return;
	}
	char szValue[128];
	char szName[MAX_NAME_LENGTH];
	char szWinRatio[32];
	char szSteamID[32];
	char szPointsRatio[32];
	int winratio;
	int pointsratio;
	Handle menu = CreateMenu(TopChallengeHandler1);
	SetMenuPagination(menu, 5); 
	SetMenuTitle(menu, "Top 5 Challengers\n#   W/L P.-Ratio    Player (W/L ratio)");     
	if(SQL_HasResultSet(hndl))
	{
		int i = 1;
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
			PrintToChat(data, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
			ckTopMenu(data);
		}
		else
		{
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, data, MENU_TIME_FOREVER);
		}
	}
	else
	{
		PrintToChat(data, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
		ckTopMenu(data);
	}
}

public db_resetPlayerResetChallenges(client, char steamid[128])
{
	char szQuery[255];
	char szsteamid[128*2+1];
	SQL_EscapeString(g_hDb, steamid, szsteamid, 128*2+1);        
	Format(szQuery, 255, sql_deleteChallenges, szsteamid);       
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);	    
	SQL_TQuery(g_hDb, SQL_CheckCallback4, szQuery, pack);	     	
	PrintToConsole(client, "won challenges cleared (%s)", szsteamid);
}

public db_dropChallenges(client)
{
	SQL_TQuery(g_hDb, SQL_CheckCallback, "UPDATE ck_playerrank SET winratio = '0',pointsratio = '0'", client);
	SQL_LockDatabase(g_hDb);
	if(g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropChallenges);
	else
		SQL_FastQuery(g_hDb, sqlite_dropChallenges);
	SQL_FastQuery(g_hDb, sql_createChallenges);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "challenge table dropped. Please restart your server!");
}

public TopChallengeHandler1(Handle menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1]=3;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public TopTpHoldersHandler1(Handle menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1]=10;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}
public TopProHoldersHandler1(Handle menu, MenuAction:action, param1, param2)
{

	if (action ==  MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1]=11;
		db_viewPlayerRank(param1,info);
	}

	if (action ==  MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public db_viewChallengeHistory(client, char szSteamId[32])
{
	char szQuery[1024];       
	Format(szQuery, 1024, sql_selectChallenges2, szSteamId, szSteamId);  
	if ((StrContains(szSteamId, "STEAM_") != -1) && IsClientInGame(client))
	{
		Handle pack = CreateDataPack();			
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

public sql_selectChallengesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectChallengesCallback): %s", error);
		return;
	}

	//decl.
	int bet, cp_allowed = 0, client;
	int bHeader=false;
	char szMapName[32];
	char szSteamId[32];
	char szSteamId2[32];	
	char szSteamIdTarget[32];
	char szNameTarget[32];	
	char szDate[64];	
	
	//get pack data
	ResetPack(data);
	ReadPackString(data, szSteamIdTarget, 32);
	ReadPackString(data, szNameTarget, 32);
	client = ReadPackCell(data);
	CloseHandle(data);
	
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
			int WinnerTarget=0;
			if (StrEqual(szSteamId,szSteamIdTarget))
				WinnerTarget=1;
			
			//create pack
			Handle pack2 = CreateDataPack();		
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
			char szQuery[512];
			if (WinnerTarget==1)
				Format(szQuery, 512, "select name from ck_playerrank where steamid = '%s'", szSteamId2);
			else
				Format(szQuery, 512, "select name from ck_playerrank where steamid = '%s'", szSteamId);
			SQL_TQuery(g_hDb, sql_selectChallengesCallback2, szQuery, pack2,DBPrio_Low);						
		}
	}
	if(!bHeader)
	{
		ProfileMenu(client, -1);
		PrintToChat(client, "[%cCK%c] No challenges found.",MOSSGREEN,WHITE);
	}
}

public sql_selectChallengesCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectChallengesCallback2): %s", error);
		return;
	}

	//decl.
	char szNameTarget[32];
	char szNameOpponent[32];
	char szSteamId[32];
	char szCps[32];
	char szResult[32];
	char szSteamId2[32];
	char szMapName[32];
	char szDate[64];
	int client, bet, WinnerTarget, cp_allowed;
	
	//get pack data
	ResetPack(data);	
	client = ReadPackCell(data);
	WinnerTarget = ReadPackCell(data);
	ReadPackString(data, szNameTarget, 32);
	ReadPackString(data, szSteamId, 32);
	ReadPackString(data, szSteamId2, 32);
	ReadPackString(data, szMapName, 32);
	ReadPackString(data, szDate, 64);	
	bet = ReadPackCell(data);
	cp_allowed = ReadPackCell(data);
	CloseHandle(data);
	
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

public sql_selectChallengesCompareCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectChallengesCompareCallback): %s", error);
		return;
	}

	int winratio=0;
	int challenges= SQL_GetRowCount(hndl);
	int pointratio=0;
	char szWinRatio[32];
	char szPointsRatio[32];
	char szName[MAX_NAME_LENGTH];

	ResetPack(data);
	int client = ReadPackCell(data);      
	ReadPackString(data, szName, MAX_NAME_LENGTH);
	CloseHandle(data);	

	if (!IsValidClient(client))
		return;

	if(SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			char szID[32];
			int bet;
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
	char szQuery[255];
	int points;
	points = g_Challenge_Bet[client] * g_pr_PointUnit;

	Format(szQuery, 255, sql_insertChallenges, g_szSteamID[client], g_szChallenge_OpponentID[client],points,g_szMapName);
	SQL_TQuery(g_hDb, sql_insertChallengesCallback, szQuery,client,DBPrio_Low);
}

public sql_insertChallengesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_insertChallengesCallback): %s", error);
		return;
	}
}	
















///////////////////
// PLAYERTIMES ////
///////////////////

public db_resetPlayerMapRecord(client, char steamid[128], char szMapName[128])
{
	char szQuery[255];
	char szQuery2[255];
	char szsteamid[128*2+1];
	
	SQL_EscapeString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetRecordPro, szsteamid, szMapName);
	Format(szQuery2, 255, sql_resetCheckpoints, szsteamid, szMapName);  
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);	    
	SQL_TQuery(g_hDb, SQL_CheckCallback3, szQuery,pack);
	SQL_TQuery(g_hDb, SQL_CheckCallback3, szQuery2,1);	    
	PrintToConsole(client, "map time of %s on %s cleared.", steamid, szMapName);
    
	if (StrEqual(szMapName,g_szMapName))
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if(StrEqual(g_szSteamID[i],szsteamid))
				{
					Format(g_szPersonalRecord[i], 64, "NONE");
					g_fPersonalRecord[i] = 0.0;
					g_MapRank[i] = 99999;
				}
			}
		}
	} 
}

public db_resetPlayerRecords2(client, char steamid[128], char szMapName[128])
{
	char szQuery[255];      
	char szsteamid[128*2+1];
	
	SQL_EscapeString(g_hDb, steamid, szsteamid, 128*2+1);      
	Format(szQuery, 255, sql_resetRecords2, szsteamid, szMapName); 
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);		
	SQL_TQuery(g_hDb, SQL_CheckCallback3, szQuery, pack);	    
	PrintToConsole(client, "map times of %s on %s cleared.", steamid, szMapName);
    
	if (StrEqual(szMapName,g_szMapName))
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if(StrEqual(g_szSteamID[i],szsteamid))
				{
					Format(g_szPersonalRecord[i], 64, "NONE");
					g_fPersonalRecord[i] = 0.0;
					g_MapRank[i] = 99999;
				}
			}
		}
	}
}

public db_GetMapRecord_Pro()
{
	char szQuery[512];      
	Format(szQuery, 512, sql_selectMapRecordPro, g_szMapName);      
	SQL_TQuery(g_hDb, sql_selectMapRecordProCallback, szQuery,DBPrio_Low);
}

public sql_selectMapRecordProCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectMapRecordProCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if (SQL_FetchFloat(hndl, 0) > -1.0)
		{
			g_fRecordMapTime = SQL_FetchFloat(hndl, 0);
			FormatTimeFloat(0, g_fRecordMapTime, 3, g_szRecordMapTime, 64);
			SQL_FetchString(hndl, 1, g_szRecordPlayer, MAX_NAME_LENGTH);	
		}
		else
		{
			Format(g_szRecordMapTime, 64, "N/A");
			g_fRecordMapTime = 9999999.0;
		}
	}
	else
	{
		Format(g_szRecordMapTime, 64, "N/A");
		g_fRecordMapTime = 9999999.0;
	}
}


public sql_selectProSurfersCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectProSurfersCallback): %s", error);
		return;
	}

	char szValue[128];
	char szSteamID[32];
	char szName[64];
	char szTime[32];
	float time;
	Handle menu = CreateMenu(MapMenuHandler3);
	SetMenuPagination(menu, 5);
	SetMenuTitle(menu, "Top 20 Map Times (local)\n    Rank   Time              Player");     
	if(SQL_HasResultSet(hndl))
		
	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 0, szName, 64);
			time = SQL_FetchFloat(hndl, 1);		
			SQL_FetchString(hndl, 2, szSteamID, 32);
			FormatTimeFloat(data, time, 3,szTime,sizeof(szTime));			
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
			PrintToChat(data, "%t", "NoMapRecords",MOSSGREEN,WHITE, g_szMapName);
		}
	}     
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, data, MENU_TIME_FOREVER);
}

public db_selectTopSurfers(client, char mapname[128])
{
	char szQuery[1024];       
	Format(szQuery, 1024, sql_selectTopSurfers, mapname);  
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, mapname);
	SQL_TQuery(g_hDb, sql_selectTopSurfersCallback, szQuery, pack,DBPrio_Low);
}

public db_selectMapTopSurfers(client, char mapname[128])
{
	char szQuery[1024];       
	Format(szQuery, 1024, sql_selectTopSurfers2, PERCENT,mapname,PERCENT);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, mapname);
	SQL_TQuery(g_hDb, sql_selectTopSurfersCallback, szQuery, pack,DBPrio_Low);
}


//// BONUS //////////
public db_selectBonusTopSurfers(client, char mapname[128], zGrp)
{
	char szQuery[1024];       
	Format(szQuery, 1024, sql_selectTopBonusSurfers, PERCENT,mapname,PERCENT, zGrp);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, mapname);
	WritePackCell(pack, zGrp);
	SQL_TQuery(g_hDb, sql_selectTopBonusSurfersCallback, szQuery, pack,DBPrio_Low);
}

public sql_selectTopBonusSurfersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectTopBonusSurfersCallback): %s", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	char szMap[128];
	ReadPackString(data, szMap, 128);	
	int zGrp = ReadPackCell(data);
	CloseHandle(data);

	char szFirstMap[128], szValue[128], szName[64], szSteamID[32], lineBuf[256], title[256];
	float time;
	bool bduplicat = false;
	Handle stringArray = CreateArray(100), menu;

	if (StrEqual(szMap,g_szMapName))
		menu = CreateMenu(MapMenuHandler1);
	else
		menu = CreateMenu(MapTopMenuHandler2);

	SetMenuPagination(menu, 5);

	if(SQL_HasResultSet(hndl))
	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			bduplicat = false;
			SQL_FetchString(hndl, 0, szSteamID, 32);
			SQL_FetchString(hndl, 1, szName, 64);
			time = SQL_FetchFloat(hndl, 2); 
			SQL_FetchString(hndl, 4, szMap, 128);
			if (i == 1 || (i > 1 && StrEqual(szFirstMap,szMap)))
			{
				int stringArraySize = GetArraySize(stringArray);
				for(int x = 0; x < stringArraySize; x++)
				{
					GetArrayString(stringArray, x, lineBuf, sizeof(lineBuf));
					if (StrEqual(lineBuf, szName, false))
						bduplicat=true;		
				}
				if (bduplicat==false && i < 51)
				{	
					char szTime[32];
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
	Format(title, 256, "Top 50 Times on %s (B %i) \n    Rank    Time               Player", szFirstMap, zGrp);
	SetMenuTitle(menu, title);     
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
	CloseHandle(stringArray);
}

public sql_selectTopSurfersCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectTopSurfersCallback): %s", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	char szMap[128];
	ReadPackString(data, szMap, 128);	
	CloseHandle(data);

	char szFirstMap[128];
	char szValue[128];
	char szName[64];
	float time;
	char szSteamID[32];
	char lineBuf[256];
	Handle stringArray = CreateArray(100);
	Handle menu;
	if (StrEqual(szMap,g_szMapName))
		menu = CreateMenu(MapMenuHandler1);
	else
		menu = CreateMenu(MapTopMenuHandler2);		
	SetMenuPagination(menu, 5);
	bool bduplicat = false;
	char title[256];
	if(SQL_HasResultSet(hndl))
	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			bduplicat = false;
			SQL_FetchString(hndl, 0, szSteamID, 32);
			SQL_FetchString(hndl, 1, szName, 64);
			time = SQL_FetchFloat(hndl, 2); 
			SQL_FetchString(hndl, 4, szMap, 128);
			if (i == 1 || (i > 1 && StrEqual(szFirstMap,szMap)))
			{
				int stringArraySize = GetArraySize(stringArray);
				for(int x = 0; x < stringArraySize; x++)
				{
					GetArrayString(stringArray, x, lineBuf, sizeof(lineBuf));
					if (StrEqual(lineBuf, szName, false))
						bduplicat=true;		
				}
				if (bduplicat==false && i < 51)
				{	
					char szTime[32];
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
	Format(title, 256, "Top 50 Times on %s \n    Rank    Time               Player", szFirstMap);
	SetMenuTitle(menu, title);     
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
	CloseHandle(stringArray);
}

public db_selectProSurfers(client)
{
	char szQuery[1024];       
	Format(szQuery, 1024, sql_selectProSurfers, g_szMapName);   		
	SQL_TQuery(g_hDb, sql_selectProSurfersCallback, szQuery, client,DBPrio_Low);
}

public db_currentRunRank(client)
{
	if (!IsValidClient(client))
		return;

	char szQuery[512];
	Format(szQuery, 512, "SELECT runtimepro FROM `ck_playertimes` WHERE `mapname` = '%s' AND `runtimepro` < %f;", g_szMapName, g_fFinalTime[client]);
	SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback2, szQuery, client, DBPrio_Low);
}

//
// Get clients record from database
//
public db_selectRecord(client)
{
	if (!IsValidClient(client))
		return;

	char szQuery[255];
	//SELECT mapname, runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro  > -1.0";
	Format(szQuery, 255, sql_selectRecord, g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, sql_selectRecordCallback, szQuery, client,DBPrio_Low);
}

public sql_selectRecordCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectRecordCallback): %s", error);
		return;
	}

	if (!IsValidClient(data))
		return;


	char szQuery[512];

	// Found old time from database
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		float time;
		time = SQL_FetchFloat(hndl, 1);
		// If old time was slower than the new time, update record
		if((g_fFinalTime[data] <= time || time <= 0.0)) 
		{
			db_updateRecordPro(data);
		}
	}    
	else
	{	// No record found from database - Let's insert

		// Escape name for SQL injection protection
		char szName[MAX_NAME_LENGTH], szUName[MAX_NAME_LENGTH];
		GetClientName(data, szUName, MAX_NAME_LENGTH);
		SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH);

		// Format record time string
		FormatTimeFloat(data, g_fFinalTime[data], 3, g_szPersonalRecord[data], 64);
		g_fPersonalRecord[data] = g_fFinalTime[data];

		// Move required information in datapack
		Handle pack = CreateDataPack();
		WritePackFloat(pack,  g_fFinalTime[data]);
		WritePackCell(pack, data);

		//"INSERT INTO ck_playertimes (steamid, mapname, name,runtimepro) VALUES('%s', '%s', '%s', '%f');";
		Format(szQuery, 512, sql_insertPlayerTime, g_szSteamID[data], g_szMapName, szName, g_fFinalTime[data]);
		SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback, szQuery,pack,DBPrio_Low);	
	}
}

//
// If latest record was faster than old - Update time
//
public db_updateRecordPro(client)
{
	char szUName[MAX_NAME_LENGTH];

	if (IsValidClient(client))
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	else
		return;

	// Also updating name in database, escape string
	char szName[MAX_NAME_LENGTH*2+1];
	SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);

	//Format Record String
	FormatTimeFloat(client, g_fFinalTime[client], 3, g_szPersonalRecord[client], 64);
	g_fPersonalRecord[client] = g_fFinalTime[client];

	// Packing required information for later
	Handle pack = CreateDataPack();
	WritePackFloat(pack, g_fFinalTime[client]);
	WritePackCell(pack, client);

	char szQuery[1024];
	//"UPDATE ck_playertimes SET name = '%s', runtimepro = '%f' WHERE steamid = '%s' AND mapname = '%s';"; 
	Format(szQuery, 1024, sql_updateRecordPro, szName, g_fFinalTime[client], g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback, szQuery, pack, DBPrio_Low);
}


public SQL_UpdateRecordProCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_UpdateRecordProCallback): %s", error);
		return;
	}

	float time = -1.0;

	// Error checking
	if (data != INVALID_HANDLE)
	{
		ResetPack(data);
		time = ReadPackFloat(data);
		int client = ReadPackCell(data);
		CloseHandle(data);
		
		// Find out how many times are are faster than the players time
		char szQuery[512];
		Format(szQuery, 512, "SELECT runtimepro FROM `ck_playertimes` WHERE `mapname` = '%s' AND `runtimepro` < %f;", g_szMapName, time);
		SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback2, szQuery, client, DBPrio_Low);

	}
}

public SQL_UpdateRecordProCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_UpdateRecordProCallback2): %s", error);
		return;
	}
	// Get players rank, 9999999 = error
	int rank = 9999999;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		rank = (1+SQL_GetRowCount(hndl));
	}

	g_bMapRankToChat[data]=true;
	// Get rank, and announce to chat
	db_viewMapRankPro(data, rank);
}

public db_viewRecord(client, char szSteamId[32], char szMapName[128])
{
	char szQuery[512];       
	Format(szQuery, 512, sql_selectPersonalRecords, szSteamId, szMapName);  
	SQL_TQuery(g_hDb, SQL_ViewRecordCallback, szQuery, client,DBPrio_Low);
}



public SQL_ViewRecordCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRecordCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		
		char szQuery[512];
		char szMapName[128];
		char szName[MAX_NAME_LENGTH];
		char szSteamId[32];
		float timepro;

		//get the result
		SQL_FetchString(hndl, 0, szMapName, 128);
		SQL_FetchString(hndl, 1, szSteamId, MAX_NAME_LENGTH);
		SQL_FetchString(hndl, 2, szName, MAX_NAME_LENGTH);
		timepro = SQL_FetchFloat(hndl, 3);      
		Handle pack1 = CreateDataPack();		
		WritePackString(pack1, szMapName);
		WritePackString(pack1, szSteamId);	
		WritePackString(pack1, szName);	
		WritePackCell(pack1, data);
		WritePackFloat(pack1, timepro);

		Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback2, szQuery, pack1,DBPrio_Low);
	}
	else
	{ 
		Handle panel = CreatePanel();
		DrawPanelText(panel, "Current map time");
		DrawPanelText(panel, " ");
		DrawPanelText(panel, "No record found on this map.");
		DrawPanelItem(panel, "exit");
		SendPanelToClient(panel, data, MenuHandler2, 300);
		CloseHandle(panel);
	}
}

public SQL_ViewRecordCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRecordCallback2): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
	char szQuery[512];
	int rank = SQL_GetRowCount(hndl);
	char szMapName[128];
	char szSteamId[32];
	char szName[MAX_NAME_LENGTH];

	WritePackCell(data, rank);
	ResetPack(data);	
	ReadPackString(data, szMapName, 128);
	ReadPackString(data, szSteamId, 32);
	ReadPackString(data, szName, MAX_NAME_LENGTH);
	
	Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
	SQL_TQuery(g_hDb, SQL_ViewRecordCallback3, szQuery, data,DBPrio_Low);
	}
}


public SQL_ViewRecordCallback3(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRecordCallback3): %s", error);
		return;
	}

	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		int count1 = SQL_GetRowCount(hndl);
		char szMapName[128];
		char szSteamId[32];
		char szName[MAX_NAME_LENGTH];
		float timepro = ReadPackFloat(data);

		ResetPack(data);		
		ReadPackString(data, szMapName, 128);
		ReadPackString(data, szSteamId, 32);
		ReadPackString(data, szName, MAX_NAME_LENGTH);	
		int client = ReadPackCell(data);
		int rank = ReadPackCell(data);
		
		if (timepro != -1.0)
		{               
				Handle panel = CreatePanel();
				char szVrName[256];
				char szVrTime[256];
				Format(szVrName, 256, "Map time of %s", szName);
				DrawPanelText(panel, szVrName);
				Format(szVrName, 256, "on %s", g_szMapName);
				DrawPanelText(panel, " ");		
				char szVrRank[32];
				
				FormatTimeFloat(client, timepro, 3,szVrTime,sizeof(szVrTime));
				Format(szVrTime, 256, "Time: %s", szVrTime);

				Format(szVrRank, 32, "Rank: %i of %i", rank,count1);
				DrawPanelText(panel, "Pro time:");
				DrawPanelText(panel, szVrTime);
				DrawPanelText(panel, szVrRank);
				DrawPanelText(panel, " ");
				DrawPanelItem(panel, "Exit");
				CloseHandle(data);
				SendPanelToClient(panel, client, RecordPanelHandler, 300);
				CloseHandle(panel);
			}
			else
				if (timepro != 0.000000)
				{
					WritePackCell(data, count1);
					char szQuery[512];
					Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
					SQL_TQuery(g_hDb, SQL_ViewRecordCallback4, szQuery, data,DBPrio_Low);
                }
        }
}

public SQL_ViewRecordCallback4(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRecordCallback4): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{

		char szQuery[512];
		int rankPro = SQL_GetRowCount(hndl);
		char szMapName[128];

		WritePackCell(data, rankPro);
		ResetPack(data);
		ReadPackString(data, szMapName, 128);

		Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback5, szQuery, data,DBPrio_Low);
	}
}

public SQL_ViewRecordCallback5(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewRecordCallback5): %s", error);
		return;
	}

	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		int countPro = SQL_GetRowCount(hndl);           
		//retrieve all values
		ResetPack(data);            
		char szMapName[128];
		ReadPackString(data, szMapName, 128);
		char szSteamId[32];
		ReadPackString(data, szSteamId, 32);
		char szName[MAX_NAME_LENGTH];
		ReadPackString(data, szName, MAX_NAME_LENGTH);	
		int client = ReadPackCell(data);
		float timepro = ReadPackFloat(data);
		int rank = ReadPackCell(data);                  
		int count1 = ReadPackCell(data);        
		int rankPro = ReadPackCell(data);                 
		if (timepro != -1.0)
		{				
			Handle panel = CreatePanel();
			char szVrName[256];
			Format(szVrName, 256, "Map time of %s", szName);
			DrawPanelText(panel, szVrName);
			Format(szVrName, 256, "on %s", g_szMapName);
			DrawPanelText(panel, " ");
			
			char szVrRank[32];
			char szVrRankPro[32];      
			char szVrTimePro[256];
			FormatTimeFloat(client, timepro, 3,szVrTimePro,sizeof(szVrTimePro));
			Format(szVrTimePro, 256, "Time: %s", szVrTimePro);
			
			Format(szVrRank, 32, "Rank: %i of %i", rank,count1); 
			Format(szVrRankPro, 32, "Rank: %i of %i", rankPro,countPro); 
					          
			DrawPanelText(panel, szVrRank);
			DrawPanelText(panel, " ");
			DrawPanelText(panel, "Time:");
			DrawPanelText(panel, szVrTimePro);
			DrawPanelText(panel, szVrRankPro);
			DrawPanelText(panel, " ");
			DrawPanelItem(panel, "exit");
			SendPanelToClient(panel, client, RecordPanelHandler, 300);
			CloseHandle(panel);
		}
	}
	CloseHandle(data);
}

public db_viewAllRecords(client, char szSteamId[32])
{
	char szQuery[1024];       
	Format(szQuery, 1024, sql_selectPersonalAllRecords, szSteamId, szSteamId);  
	if ((StrContains(szSteamId, "STEAM_") != -1))
		SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback, szQuery, client,DBPrio_Low);
	else
		if (IsClientInGame(client))
			PrintToChat(client,"[%cCK%c] Invalid SteamID found.",RED,WHITE);
	ProfileMenu(client, -1);
}


public SQL_ViewAllRecordsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewAllRecordsCallback): %s", error);
		return;
	}

	int bHeader=false;
	char szUncMaps[1024];
	int mapcount=0;
	char szName[MAX_NAME_LENGTH];
	char szSteamId[32];
	if(SQL_HasResultSet(hndl))
	{	
		float time;
		char szMapName[128];		
		char szMapName2[128];
		char szRecord_type[4];
		char szQuery[1024];
		Format(szUncMaps,sizeof(szUncMaps),"");
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 1, szSteamId, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 2, szMapName, 128);	
			
			time = SQL_FetchFloat(hndl, 3);
				
			Format(szRecord_type, 4, "PRO");	
			int mapfound=false;
			
			//map in rotation?
			for (int i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));
				if (StrEqual(szMapName2, szMapName, false))
				{
					if (!bHeader)
					{
						PrintToConsole(data," ");
						PrintToConsole(data,"-------------");
						PrintToConsole(data,"Finished Maps");
						PrintToConsole(data,"Player: %s", szName);
						PrintToConsole(data,"SteamID: %s", szSteamId);
						PrintToConsole(data,"-------------");
						PrintToConsole(data," ");
						bHeader=true;
						PrintToChat(data, "%t", "ConsoleOutput", LIMEGREEN,WHITE); 	
					}
					Handle pack = CreateDataPack();			
					WritePackString(pack, szName);
					WritePackString(pack, szSteamId);
					WritePackString(pack, szMapName);			
					WritePackString(pack, szRecord_type);		
					WritePackFloat(pack, time);
					WritePackCell(pack, data);

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
			PrintToChat(data, "%t", "ConsoleOutput", LIMEGREEN,WHITE); 
			PrintToConsole(data," ");
			PrintToConsole(data,"-------------");
			PrintToConsole(data,"Finished Maps");
			PrintToConsole(data,"Player: %s", szName);
			PrintToConsole(data,"SteamID: %s", szSteamId);
			PrintToConsole(data,"-------------");
			PrintToConsole(data," ");		
		}
		PrintToConsole(data, "Times on maps which are not in the mapcycle.txt (TP and Pro records still count but you don't get points): %s", szUncMaps);
	}
	if(!bHeader && StrEqual(szUncMaps,""))
	{
		ProfileMenu(data, -1);
		PrintToChat(data, "%t", "PlayerHasNoMapRecords", LIMEGREEN,WHITE,g_szProfileName[data]);
	}
}

public SQL_ViewAllRecordsCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewAllRecordsCallback2): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		char szQuery[512];
		char szName[MAX_NAME_LENGTH];
		char szSteamId[32];
		char szMapName[128];
		char szRecord_type[4];

		int rank = SQL_GetRowCount(hndl);
		WritePackCell(data, rank);
		ResetPack(data);
		ReadPackString(data, szName, MAX_NAME_LENGTH);
		ReadPackString(data, szSteamId, 32);
		ReadPackString(data, szMapName, 128);
		ReadPackString(data, szRecord_type, 4);	

		Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback3, szQuery, data,DBPrio_Low);		
	}
}

public SQL_ViewAllRecordsCallback3(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewAllRecordsCallback3): %s", error);
		return;
	}

	//if there is a player record
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		int count = SQL_GetRowCount(hndl);
		char szRecord_type[4];
		char szTime[32];
		char szMapName[128];
		char szSteamId[32];
		char szName[MAX_NAME_LENGTH];

		ResetPack(data);
		ReadPackString(data, szName, MAX_NAME_LENGTH);
		ReadPackString(data, szSteamId, 32);
		ReadPackString(data, szMapName, 128);	
		ReadPackString(data, szRecord_type, 4);				
		float time = ReadPackFloat(data);	
		int client = ReadPackCell(data);
		int rank = ReadPackCell(data);
		CloseHandle(data);

		FormatTimeFloat(client,time,3,szTime,sizeof(szTime));
		if (IsValidClient(client))
			PrintToConsole(client,"%s, Time: %s (%s), Rank: %i/%i", szMapName, szTime, szRecord_type, rank,count);
	}
}	


public db_selectPlayer(client)
{
	char szQuery[255];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 255, sql_selectPlayer, g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, SQL_SelectPlayerCallback, szQuery, client,DBPrio_Low);
}

public SQL_SelectPlayerCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_SelectPlayerCallback): %s", error);
		return;
	}

	if(!SQL_HasResultSet(hndl) && !SQL_FetchRow(hndl) && !IsValidClient(data))
		db_insertPlayer(data);
}

public db_insertPlayer(client)
{
	char szQuery[255];
	char szUName[MAX_NAME_LENGTH];
	if (IsValidClient(client))
	{
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	}
	else
		return;	
	char szName[MAX_NAME_LENGTH*2+1];      
	SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	Format(szQuery, 255, sql_insertPlayer, g_szSteamID[client], g_szMapName, szName); 
	SQL_TQuery(g_hDb, SQL_InsertPlayerCallback, szQuery,client,DBPrio_Low);
}

public SQL_InsertPlayerCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_InsertPlayerCallback): %s", error);
		return;
	}
}

//
// Getting players record in current map
//
public db_viewPersonalRecords(client, char szSteamId[32], char szMapName[128])
{
	char szQuery[1024];
	//"SELECT db2.mapname, db2.steamid, db1.name, db2.runtimepro, db1.steamid  FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db1.steamid = db2.steamid WHERE db2.steamid = '%s' AND db2.mapname = '%s' AND db2.runtimepro > 0.0";  
	Format(szQuery, 1024, sql_selectPersonalRecords, szSteamId, szMapName);
	SQL_TQuery(g_hDb, SQL_selectPersonalRecordsCallback, szQuery, client, DBPrio_Low);
}
	

public SQL_selectPersonalRecordsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectPersonalRecordsCallback): %s", error);
		return;
	}

	g_fPersonalRecord[data] = 0.0;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalRecord[data] = SQL_FetchFloat(hndl, 3); 
		
		if (g_fPersonalRecord[data]>0.0)
		{
			FormatTimeFloat(data, g_fPersonalRecord[data], 3, g_szPersonalRecord[data], 64);
			// Time found, get rank in current map
			db_viewMapRankPro(data, 1);
		}
		else
		{
			Format(g_szPersonalRecord[data], 64, "NONE");
			g_fPersonalRecord[data] = 0.0;
		}
	}
}              












///////////////////////
//// PLAYER TEMP //////
///////////////////////

public db_deleteTmp(client)
{
	char szQuery[256];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 256, sql_deletePlayerTmp, g_szSteamID[client]); 
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client,DBPrio_Low);
}

public db_selectLastRun(client)
{
	char szQuery[512];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 512, sql_selectPlayerTmp, g_szSteamID[client], g_szMapName);     
	SQL_TQuery(g_hDb, SQL_LastRunCallback, szQuery, client,DBPrio_Low);
}

public SQL_LastRunCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_LastRunCallback): %s", error);
		return;
	}
	
	g_bTimeractivated[data] = false;
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl) && IsValidClient(data))
	{

		//"SELECT cords1,cords2,cords3, angle1, angle2, angle3,runtimeTmp, EncTickrate, Stage, zonegroup FROM ck_playertemp WHERE steamid = '%s' AND mapname = '%s';";

		//Get last psition
		g_fPlayerCordsRestore[data][0] = SQL_FetchFloat(hndl, 0);
		g_fPlayerCordsRestore[data][1] = SQL_FetchFloat(hndl, 1);
		g_fPlayerCordsRestore[data][2] = SQL_FetchFloat(hndl, 2);
		g_fPlayerAnglesRestore[data][0] = SQL_FetchFloat(hndl, 3);
		g_fPlayerAnglesRestore[data][1] = SQL_FetchFloat(hndl, 4);
		g_fPlayerAnglesRestore[data][2] = SQL_FetchFloat(hndl, 5);


		int zGroup;
		zGroup = SQL_FetchInt(hndl, 9);

		g_iClientInZone[data][2] = zGroup;

		g_Stage[zGroup][data] = SQL_FetchInt(hndl, 8);
		
		//Set new start time	
		float  fl_time = SQL_FetchFloat(hndl, 6);
		int tickrate = RoundFloat(float(SQL_FetchInt(hndl, 7)) / 5.0 / 11.0);		
		if (tickrate == g_Server_Tickrate)
		{
			if (fl_time > 0.0)
			{
				g_fStartTime[data] = GetGameTime() - fl_time;  
				g_bTimeractivated[data] = true;
			}
				
			if (SQL_FetchFloat(hndl, 0) == -1.0 && SQL_FetchFloat(hndl, 1) == -1.0 && SQL_FetchFloat(hndl, 2) == -1.0) 
			{
				g_bRestorePosition[data] = false;
				g_bRestorePositionMsg[data] = false;
			}
			else
			{
				if (g_bLateLoaded && IsPlayerAlive(data) && !g_specToStage[data])
				{
					g_bPositionRestored[data] = true;
					TeleportEntity(data, g_fPlayerCordsRestore[data],g_fPlayerAnglesRestore[data],NULL_VECTOR);
					g_bRestorePosition[data]  = false;
				}
				else
				{
					g_bRestorePosition[data] = true;
					g_bRestorePositionMsg[data]=true;
				}
				
			}
		}
	}
	else
	{
		
		g_bTimeractivated[data] = false;
	}
}









///////////////////////
//// Checkpoints //////
///////////////////////



public db_viewRecordCheckpoints(zonegrp)
{
	for (int i = 0; i < CPLIMIT; i++)
		g_fCheckpointServerRecord[zonegrp][i] = 0.0;
		
	//"SELECT * FROM ck_checkpoints WHERE steamid = (SELECT steamid FROM ck_playertimes WHERE mapname = '%s' ORDER BY runtimepro ASC LIMIT 1) AND mapname = '%s' AND zonegroup = '%i';";

	char szQuery[512];
	Format(szQuery, 512, sql_selectRecordCheckpoints, g_szMapName, g_szMapName, zonegrp);
	SQL_TQuery(g_hDb, sql_selectRecordCheckpointsCallback, szQuery, zonegrp, DBPrio_Low);
}

public sql_selectRecordCheckpointsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectRecordCheckpointsCallback): %s", error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bCheckpointRecordFound[data] = true;
		int k = 2;
		//PrintToServer("----------- CP RECORDS -----------");
		for (int i = 0; i < CPLIMIT; i++) {
			g_fCheckpointServerRecord[data][i] = SQL_FetchFloat(hndl, k);
			//PrintToServer("%i: %f", i, g_fCheckpointServerRecord[data][i]);
			k++;
		}
	}
	else
		g_bCheckpointRecordFound[data] = false;
}

public db_viewCheckpoints(client, char szSteamID[32], char szMapName[128], zoneGrp)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectCheckpoints, szSteamID, szMapName, zoneGrp);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, zoneGrp);
	SQL_TQuery(g_hDb, SQL_selectCheckpointsCallback, szQuery, pack, DBPrio_Low);
}

public SQL_selectCheckpointsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectCheckpointsCallback): %s", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int zonegrp = ReadPackCell(data);
	CloseHandle(data);

	int k = 2;

	if (!IsValidClient(client))
		return;

	if (SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			k = 2
			zonegrp = SQL_FetchInt(hndl, 37);
			g_bCheckpointsFound[zonegrp][client] = true;
			for (int i = 0; i < CPLIMIT; i++)
			{
				g_fCheckpointTimesRecord[zonegrp][client][i] = SQL_FetchFloat(hndl, k);
				k++;
			}
		}
	}
	else
		g_bCheckpointsFound[zonegrp][client] = false;

}

public db_UpdateCheckpoints(client, char szSteamID[32], zGroup)
{
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, zGroup);
	if (g_bCheckpointsFound[zGroup][client])
	{
		char szQuery[1024];
		Format(szQuery, 1024, sql_updateCheckpoints, g_fCheckpointTimesNew[zGroup][client][0], g_fCheckpointTimesNew[zGroup][client][1], g_fCheckpointTimesNew[zGroup][client][2], g_fCheckpointTimesNew[zGroup][client][3], g_fCheckpointTimesNew[zGroup][client][4], g_fCheckpointTimesNew[zGroup][client][5], g_fCheckpointTimesNew[zGroup][client][6], g_fCheckpointTimesNew[zGroup][client][7], g_fCheckpointTimesNew[zGroup][client][8], g_fCheckpointTimesNew[zGroup][client][9], g_fCheckpointTimesNew[zGroup][client][10], g_fCheckpointTimesNew[zGroup][client][11], g_fCheckpointTimesNew[zGroup][client][12], g_fCheckpointTimesNew[zGroup][client][13], g_fCheckpointTimesNew[zGroup][client][14], g_fCheckpointTimesNew[zGroup][client][15], g_fCheckpointTimesNew[zGroup][client][16], g_fCheckpointTimesNew[zGroup][client][17], g_fCheckpointTimesNew[zGroup][client][18], g_fCheckpointTimesNew[zGroup][client][19], g_fCheckpointTimesNew[zGroup][client][20], g_fCheckpointTimesNew[zGroup][client][21], g_fCheckpointTimesNew[zGroup][client][22], g_fCheckpointTimesNew[zGroup][client][23], g_fCheckpointTimesNew[zGroup][client][24], g_fCheckpointTimesNew[zGroup][client][25], g_fCheckpointTimesNew[zGroup][client][26], g_fCheckpointTimesNew[zGroup][client][27], g_fCheckpointTimesNew[zGroup][client][28], g_fCheckpointTimesNew[zGroup][client][29], g_fCheckpointTimesNew[zGroup][client][30], g_fCheckpointTimesNew[zGroup][client][31], g_fCheckpointTimesNew[zGroup][client][32], g_fCheckpointTimesNew[zGroup][client][33], g_fCheckpointTimesNew[zGroup][client][34], szSteamID, g_szMapName, zGroup);
		SQL_TQuery(g_hDb, SQL_updateCheckpointsCallback, szQuery, pack, DBPrio_Low);
	}
	else 
	{
		char szQuery[1024];
		Format(szQuery, 1024, sql_insertCheckpoints, szSteamID, g_szMapName, g_fCheckpointTimesNew[zGroup][client][0], g_fCheckpointTimesNew[zGroup][client][1], g_fCheckpointTimesNew[zGroup][client][2], g_fCheckpointTimesNew[zGroup][client][3], g_fCheckpointTimesNew[zGroup][client][4], g_fCheckpointTimesNew[zGroup][client][5], g_fCheckpointTimesNew[zGroup][client][6], g_fCheckpointTimesNew[zGroup][client][7], g_fCheckpointTimesNew[zGroup][client][8], g_fCheckpointTimesNew[zGroup][client][9], g_fCheckpointTimesNew[zGroup][client][10], g_fCheckpointTimesNew[zGroup][client][11], g_fCheckpointTimesNew[zGroup][client][12], g_fCheckpointTimesNew[zGroup][client][13], g_fCheckpointTimesNew[zGroup][client][14], g_fCheckpointTimesNew[zGroup][client][15], g_fCheckpointTimesNew[zGroup][client][16], g_fCheckpointTimesNew[zGroup][client][17], g_fCheckpointTimesNew[zGroup][client][18], g_fCheckpointTimesNew[zGroup][client][19], g_fCheckpointTimesNew[zGroup][client][20], g_fCheckpointTimesNew[zGroup][client][21], g_fCheckpointTimesNew[zGroup][client][22], g_fCheckpointTimesNew[zGroup][client][23], g_fCheckpointTimesNew[zGroup][client][24], g_fCheckpointTimesNew[zGroup][client][25], g_fCheckpointTimesNew[zGroup][client][26], g_fCheckpointTimesNew[zGroup][client][27], g_fCheckpointTimesNew[zGroup][client][28], g_fCheckpointTimesNew[zGroup][client][29], g_fCheckpointTimesNew[zGroup][client][30], g_fCheckpointTimesNew[zGroup][client][31], g_fCheckpointTimesNew[zGroup][client][32], g_fCheckpointTimesNew[zGroup][client][33], g_fCheckpointTimesNew[zGroup][client][34], zGroup);
		SQL_TQuery(g_hDb, SQL_updateCheckpointsCallback, szQuery, pack, DBPrio_Low);
	}
}

public SQL_updateCheckpointsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_updateCheckpointsCallback): %s", error);
		return;
	}
	ResetPack(data);
	int client = ReadPackCell(data);
	int zonegrp = ReadPackCell(data);
	CloseHandle(data);

	db_viewCheckpoints(client, g_szSteamID[client], g_szMapName, zonegrp);
}

public db_deleteCheckpoints()
{
	char szQuery[258];
	Format(szQuery, 258, sql_deleteCheckpoints, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteCheckpointsCallback, szQuery, 1, DBPrio_Low);
}

public SQL_deleteCheckpointsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_deleteCheckpointsCallback): %s", error);
		return;
	}
}















//////////////////////
//// MapTier /////////
//////////////////////

public db_insertMapTier(tier, zGrp)
{
	char szQuery[256];
	if (g_bTierEntryFound)
	{
		if (zGrp > 0)
		{
			Format(szQuery, 256, sql_updateBonusTier, zGrp, tier, g_szMapName);
		}
		else 
		{
			Format(szQuery, 256, sql_updatemaptier, tier, g_szMapName);
		}
		SQL_TQuery(g_hDb, db_insertMapTierCallback, szQuery, 1, DBPrio_Low);
	}
	else
	{
		if (zGrp > 0)
		{
			Format(szQuery, 256, sql_insertBonusTier, zGrp, tier, g_szMapName);
		}
		else
		{
			Format(szQuery, 256, sql_insertmaptier, g_szMapName, tier);
		}
		SQL_TQuery(g_hDb, db_insertMapTierCallback, szQuery, 1, DBPrio_Low);
	}
}

public db_insertMapTierCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_insertMapTierCallback): %s", error);
		return;
	}

	db_selectMapTier();
}

public db_selectMapTier()
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectMapTier, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectMapTierCallback, szQuery, 1, DBPrio_Low);
}

public SQL_selectMapTierCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectMapTierCallback): %s", error);
		return;
	}
	g_bTierEntryFound = false;

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bTierEntryFound = true;
		int tier;

		// Format tier string for all
		for(int i = 0; i < 11; i++)
		{
			tier = SQL_FetchInt(hndl, i);
			if (0 < tier < 7)
			{
				g_bTierFound[i] = true;
				if (i == 0)
				{
					Format(g_sTierString[0], 512, " [%cCK%c] %cMap: %c%s %c| ", MOSSGREEN, WHITE, GREEN, LIMEGREEN, g_szMapName, GREEN);
					switch(tier) 
					{
						case 1: Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], GRAY, tier, GREEN);
						case 2: Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], LIGHTBLUE, tier, GREEN);
						case 3: Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], BLUE, tier, GREEN);
						case 4: Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], DARKBLUE, tier, GREEN);
						case 5: Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], RED, tier, GREEN);
						case 6: Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], DARKRED, tier, GREEN);
						default: Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], GRAY, tier, GREEN);
					}
					if (g_bhasStages)
						Format(g_sTierString[0], 512, "%s%c%i Stages", g_sTierString[0], MOSSGREEN, (g_mapZonesTypeCount[0][3]+1));
					else
						Format(g_sTierString[0], 512, "%s%cLinear", g_sTierString[0], LIMEGREEN);

					if (g_bhasBonus)
						if (g_mapZoneGroupCount > 2)
							Format(g_sTierString[0], 512, "%s %c|%c %i Bonuses", g_sTierString[0], GREEN, YELLOW, (g_mapZoneGroupCount-1));
						else
							Format(g_sTierString[0], 512, "%s %c|%c Bonus", g_sTierString[0], GREEN, YELLOW, (g_mapZoneGroupCount-1));
				}
				else 
				{
					switch(tier) 
					{
						case 1: Format(g_sTierString[i], 512, "[%cCK%c] &c%s Tier: %i", MOSSGREEN, WHITE, GRAY, g_szZoneGroupName[i], tier);  
						case 2: Format(g_sTierString[i], 512, "[%cCK%c] &c%s Tier: %i", MOSSGREEN, WHITE, LIGHTBLUE, g_szZoneGroupName[i], tier); 
						case 3: Format(g_sTierString[i], 512, "[%cCK%c] &c%s Tier: %i", MOSSGREEN, WHITE, BLUE, g_szZoneGroupName[i], tier); 
						case 4: Format(g_sTierString[i], 512, "[%cCK%c] &c%s Tier: %i", MOSSGREEN, WHITE, DARKBLUE, g_szZoneGroupName[i], tier); 
						case 5: Format(g_sTierString[i], 512, "[%cCK%c] &c%s Tier: %i", MOSSGREEN, WHITE, RED, g_szZoneGroupName[i], tier); 
						case 6: Format(g_sTierString[i], 512, "[%cCK%c] &c%s Tier: %i", MOSSGREEN, WHITE, DARKRED, g_szZoneGroupName[i], tier); 
					}
				}
			}
		}
	}
	else 
		g_bTierEntryFound = false;
}


public db_deleteAllMaptiers(client)
{
	char szQuery[128];
	Format(szQuery, 128, sql_deleteAllMapTiers);
	SQL_TQuery(g_hDb, SQL_deleteAllMapTiersCallback, szQuery, client, DBPrio_Low);
}

public SQL_deleteAllMapTiersCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_deleteAllMapTiersCallback): %s", error);
		return;
	}

	Admin_InsertMapTierstoDatabase(data);
}

















/////////////////////
//// SQL Bonus //////
/////////////////////


public db_viewMapRankBonus(client, zgroup, type)
{
	char szQuery[1024];
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, zgroup);
	WritePackCell(pack, type);

	Format(szQuery, 1024, sql_selectPlayerRankBonus, g_szSteamID[client], g_szMapName, zgroup, g_szMapName, zgroup);
	SQL_TQuery(g_hDb, db_viewMapRankBonusCallback, szQuery, pack, DBPrio_Low);
}

public db_viewMapRankBonusCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_viewMapRankBonusCallback): %s", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int zgroup = ReadPackCell(data);
	int type = ReadPackCell(data);
	CloseHandle(data);

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_MapRankBonus[zgroup][client] = SQL_GetRowCount(hndl);
	}
	else
	{
		g_MapRankBonus[zgroup][client] = 9999999;
	}

	switch(type)
	{
		case 1: {
			PrintChatBonus(client, zgroup);
			g_iBonusCount[zgroup]++;
		}
		case 2: {
			PrintChatBonus(client, zgroup);
		}
	}
}

//
// Get player rank in bonus - current map
//
public	db_viewPersonalBonusRecords(client, char szSteamId[32])
{
	char szQuery[1024];
	//"SELECT runtime, zonegroup FROM ck_bonus WHERE steamid = '%s' AND mapname = '%s' AND runtime > '0.0'"; 
	Format(szQuery, 1024, sql_selectPersonalBonusRecords, szSteamId, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectPersonalBonusRecordsCallback, szQuery, client, DBPrio_Low);
}

public SQL_selectPersonalBonusRecordsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectPersonalBonusRecordsCallback): %s", error);
		return;
	}

	int zgroup;

	for (int i = 0; i<MAXZONEGROUPS; i++)
		g_fPersonalRecordBonus[i][data] = 0.0;
	
	if(SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			zgroup = SQL_FetchInt(hndl, 1);
			g_fPersonalRecordBonus[zgroup][data] = SQL_FetchFloat(hndl, 0);
			
			if (g_fPersonalRecordBonus[zgroup][data] > 0.0) 
			{
				FormatTimeFloat(data, g_fPersonalRecordBonus[zgroup][data], 3, g_szPersonalRecordBonus[zgroup][data], 64);
				db_viewMapRankBonus(data, zgroup, 0); // get rank
			}
			else
			{
				g_fPersonalRecordBonus[zgroup][data] = 0.0;
			}
		}
	}
}

public db_viewFastestBonus(zgroup)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectFastestBonus, g_szMapName, zgroup);
	SQL_TQuery(g_hDb, SQL_selectFastestBonusCallback, szQuery, zgroup, DBPrio_High);
}

public SQL_selectFastestBonusCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectFastestBonusCallback): %s", error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, g_szBonusFastest[data], MAX_NAME_LENGTH);
		g_fBonusFastest[data] = SQL_FetchFloat(hndl, 0);
		FormatTimeFloat(1, g_fBonusFastest[data], 3, g_szBonusFastestTime[data], 54);
	} 
	else 
	{
		g_fBonusFastest[data] = 9999999.0;
	}
	
	if (g_fBonusFastest[data] == 0.0)
		g_fBonusFastest[data] = 9999999.0;
}

public db_deleteBonus()
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_deleteBonus, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteBonusCallback, szQuery, 1, DBPrio_Low);
}
public db_viewBonusTotalCount(zgroup)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectBonusCount, g_szMapName, zgroup);
	SQL_TQuery(g_hDb, SQL_selectBonusTotalCountCallback, szQuery, zgroup, DBPrio_Low);
}

public SQL_selectBonusTotalCountCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectBonusTotalCountCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_iBonusCount[data] = SQL_FetchInt(hndl, 0);
	} 
	else
	{
		g_iBonusCount[data] = 0;
	}
}

	
public db_insertBonus(client, char szSteamId[32], char szUName[32], float FinalTime, zoneGrp)
{
	char szQuery[1024];
	char szName[MAX_NAME_LENGTH*2+1];
	SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, zoneGrp);
	Format(szQuery, 1024, sql_insertBonus, szSteamId, szName, g_szMapName, FinalTime, zoneGrp);
	SQL_TQuery(g_hDb, SQL_insertBonusCallback, szQuery, pack, DBPrio_Low);
}

public SQL_insertBonusCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_insertBonusCallback): %s", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int zgroup = ReadPackCell(data);
	CloseHandle(data);

	db_viewMapRankBonus(client, zgroup, 1);

	CalculatePlayerRank(client);
}	

public db_updateBonus(client, char szSteamId[32], char szUName[32], float FinalTime, zoneGrp)
{
	char szQuery[1024];
	char szName[MAX_NAME_LENGTH*2+1];
	Handle datapack = CreateDataPack();
	WritePackCell(datapack, client);
	WritePackCell(datapack, zoneGrp);
	SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH*2+1);
	Format(szQuery, 1024, sql_updateBonus, FinalTime, szName, szSteamId, g_szMapName, zoneGrp);
	SQL_TQuery(g_hDb, SQL_updateBonusCallback, szQuery, datapack, DBPrio_Low);
}


public SQL_updateBonusCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_updateBonusCallback): %s", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int zgroup = ReadPackCell(data);
	CloseHandle(data);

	db_viewMapRankBonus(client, zgroup, 2);

	CalculatePlayerRank(client);
}

public SQL_deleteBonusCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_deleteBonusCallback): %s", error);
		return;
	}
}

public db_selectBonusCount()
{
	char szQuery[258];
	Format(szQuery, 258, sql_selectTotalBonusCount);
	SQL_TQuery(g_hDb, SQL_selectBonusCountCallback, szQuery, 1, DBPrio_Low);
}

public SQL_selectBonusCountCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectBonusCountCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		char mapName[128];
		char mapName2[128]
		g_totalBonusCount = 0;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, mapName2, 128); 
			for (int i = 0; i < GetArraySize(g_MapList); i++)
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
	SetSkillGroups();
}














////////////////////////////
//// SQL Zones /////////////
////////////////////////////

public db_setZoneNames(client, char szName[128])
{
	char szQuery[512], szEscapedName[128];
	SQL_EscapeString(g_hDb, szName, szEscapedName, 128);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, g_CurrentZoneGroup[client]);
	WritePackString(pack, szEscapedName);
	// UPDATE ck_zones SET zonename = '%s' WHERE mapname = '%s' AND zonegroup = '%i';
	Format(szQuery, 512, sql_setZoneNames, szEscapedName, g_szMapName, g_CurrentZoneGroup[client]);
	SQL_TQuery(g_hDb, sql_setZoneNamesCallback, szQuery, pack, DBPrio_Low);
}

public sql_setZoneNamesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_setZoneNamesCallback): %s", error);
		CloseHandle(data);
		return;
	}

	char szName[64];
	ResetPack(data);
	int client = ReadPackCell(data);
	int zonegrp = ReadPackCell(data);
	ReadPackString(data, szName, 64);
	CloseHandle(data);

	for (int i = 0; i < g_mapZonesCount; i++)
	{
		if (g_mapZones[i][zoneGroup] == zonegrp)
			Format(g_mapZones[i][zoneName], 64, szName);
	}

	if (IsValidClient(client))
	{
		PrintToChat(client, "[%cCK%c] Bonus name succesfully changed.", MOSSGREEN, WHITE);
		ListBonusSettings(client);
	}
}

public db_checkAndFixZoneIds()
{
	char szQuery[128];
	//"SELECT mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename FROM ck_zones WHERE mapname = '%s' ORDER BY zoneid ASC";
	Format(szQuery, 128, sql_selectZoneIds, g_szMapName);
	SQL_TQuery(g_hDb, db_checkAndFixZoneIdsCallback, szQuery, 1, DBPrio_Low);
}

public db_checkAndFixZoneIdsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_checkAndFixZoneIdsCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		bool IDError = false;
		float x1[128], y1[128], z1[128], x2[128], y2[128], z2[128];
		int checker = 0, i, zonetype[128], zonetypeid[128], vis[128], team[128], zoneGrp[128];
		char zName[128][128];

		while (SQL_FetchRow(hndl))
		{
			i = SQL_FetchInt(hndl, 1);
			zonetype[checker] = SQL_FetchInt(hndl, 2);
			zonetypeid[checker] = SQL_FetchInt(hndl, 3);
			x1[checker] = SQL_FetchFloat(hndl, 4);
			y1[checker] = SQL_FetchFloat(hndl, 5);
			z1[checker] = SQL_FetchFloat(hndl, 6);
			x2[checker] = SQL_FetchFloat(hndl, 7);
			y2[checker] = SQL_FetchFloat(hndl, 8);
			z2[checker] = SQL_FetchFloat(hndl, 9);
			vis[checker] = SQL_FetchInt(hndl, 10);
			team[checker] = SQL_FetchInt(hndl, 11)
			zoneGrp[checker] = SQL_FetchInt(hndl, 12);
			SQL_FetchString(hndl, 13, zName[checker], 128);

			if (i != checker)
				IDError = true;

			checker++;
		}

		if (IDError)
		{
			char szQuery[256];
			Format(szQuery, 256, sql_deleteMapZones, g_szMapName);
			SQL_FastQuery(g_hDb, szQuery);

			for(int k = 0; k < checker; k++)
			{
				db_insertZoneCheap(k, zonetype[k], zonetypeid[k], x1[k], y1[k], z1[k], x2[k], y2[k], z2[k], vis[k], team[k], zoneGrp[k], zName[k]);
			}
		}
	}
	db_selectMapZones();
}

public db_deleteAllZones(client)
{
	char szQuery[128];
	Format(szQuery, 128, sql_deleteAllZones);
	SQL_TQuery(g_hDb, SQL_deleteAllZonesCallback, szQuery, client, DBPrio_Low);
}

public SQL_deleteAllZonesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_deleteAllZonesCallback): %s", error);
		return;
	}

	Admin_InsertZonestoDatabase(data);
}

public ZoneDefaultName(zonetype, zonegroup, char zName[128]) 
{
	if (zonegroup > 0)
	{
		Format(zName, 64, "BONUS %i", zonegroup);
	}
	else 
		if (-1 < zonetype < ZONEAMOUNT)
			Format(zName, 128, "%s %i", g_szZoneDefaultNames[zonetype], zonegroup); 
		else
			Format(zName, 64, "Unknown");
}

public db_insertZoneCheap(zoneid, zonetype, zonetypeid, float pointax, float pointay, float pointaz, float pointbx, float pointby, float pointbz, vis, team, zGrp, char zName[128])
{
	char szQuery[1024];
	//"INSERT INTO ck_zones (mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename) VALUES ('%s', '%i', '%i', '%i', '%f', '%f', '%f', '%f', '%f', '%f', '%i', '%i', '%i', '%s')";
	Format(szQuery, 1024, sql_insertZones, g_szMapName, zoneid, zonetype, zonetypeid, pointax, pointay, pointaz, pointbx, pointby, pointbz, vis, team, zGrp, zName);
	SQL_TQuery(g_hDb, SQL_insertZonesCheapCallback, szQuery, 1, DBPrio_Low);
}

public SQL_insertZonesCheapCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		
		PrintToChatAll("[%cCK%c] Failed to create a zone, attempting a fix... Recreate the zone, please.", MOSSGREEN, WHITE);
		db_checkAndFixZoneIds();
		return;
	}
}

public db_insertZone(zoneid, zonetype, zonetypeid, float pointax, float pointay, float pointaz, float pointbx, float pointby, float pointbz, vis, team, zonegroup)
{
	char szQuery[1024];
	char zName[128];

	if (zonegroup == g_mapZoneGroupCount)
		ZoneDefaultName(zonetype, zonegroup, zName);
	else
		Format(zName, 128, g_szZoneGroupName[zonegroup]);

	//"INSERT INTO ck_zones (mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename) VALUES ('%s', '%i', '%i', '%i', '%f', '%f', '%f', '%f', '%f', '%f', '%i', '%i', '%i', '%s')";
	Format(szQuery, 1024, sql_insertZones, g_szMapName, zoneid, zonetype, zonetypeid, pointax, pointay, pointaz, pointbx, pointby, pointbz, vis, team, zonegroup, zName);
	SQL_TQuery(g_hDb, SQL_insertZonesCallback, szQuery, 1, DBPrio_Low);
}

public SQL_insertZonesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		
		PrintToChatAll("[%cCK%c] Failed to create a zone, attempting a fix... Recreate the zone, please.", MOSSGREEN, WHITE);
		db_checkAndFixZoneIds();
		return;
	}

	db_selectMapZones();
}

public db_saveZones()
{
	char szQuery[258];
	Format(szQuery, 258, sql_deleteMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_saveZonesCallBack, szQuery, 1, DBPrio_Low);
}

public SQL_saveZonesCallBack(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_saveZonesCallBack): %s", error);
		return;
	}
	char szzone[128];
	for(int i = 0; i < g_mapZonesCount; i++)
	{
		Format(szzone, 128, "%s", g_szZoneGroupName[g_mapZones[i][zoneGroup]]);
		if (g_mapZones[i][PointA][0] != -1.0 && g_mapZones[i][PointA][1]  != -1.0 && g_mapZones[i][PointA][2] != -1.0 )
			db_insertZoneCheap(g_mapZones[i][zoneId], g_mapZones[i][zoneType], g_mapZones[i][zoneTypeId], g_mapZones[i][PointA][0], g_mapZones[i][PointA][1], g_mapZones[i][PointA][2], g_mapZones[i][PointB][0], g_mapZones[i][PointB][1], g_mapZones[i][PointB][2], g_mapZones[i][Vis], g_mapZones[i][Team], g_mapZones[i][zoneGroup], szzone);
	}
	db_selectMapZones();
}

public db_updateZone(zoneid, zonetype, zonetypeid, float[] Point1, float[] Point2, vis, team, zonegroup)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_updateZone, zonetype, zonetypeid, Point1[0], Point1[1], Point1[2], Point2[0], Point2[1], Point2[2], vis, team, zonegroup, zoneid, g_szMapName);
	SQL_TQuery(g_hDb, SQL_updateZoneCallback, szQuery, 1, DBPrio_Low);
}

public SQL_updateZoneCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_updateZoneCallback): %s", error);
		return;
	}

	db_selectMapZones();
}

public db_deleteZonesInGroup(client)
{
	char szQuery[258];
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, g_iClientInZone[client][2]);
	Format(szQuery, 258, sql_deleteZonesInGroup, g_szMapName, g_iClientInZone[client][2]);
	SQL_TQuery(g_hDb, db_deleteZonesInGroupCallback, szQuery, pack, DBPrio_Low);
}

public db_deleteZonesInGroupCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_deleteZonesInGroupCallback): %s", error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int zgroup = ReadPackCell(data);
	CloseHandle(data);

	char szQuery[258];
	Format(szQuery, 258, "UPDATE ck_zones SET zonegroup = (zonegroup-1) WHERE zonegroup > %i", zgroup);
	SQL_TQuery(g_hDb, db_deleteZonesInGroupCallback2, szQuery, client, DBPrio_Low);
}
public db_deleteZonesInGroupCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_deleteZonesInGroupCallback2): %s", error);
		return;
	}

	db_selectMapZones();

	if (IsValidClient(data))
	{
		ZoneMenu(data);
		PrintToChat(data, "[%cCK%c] Zone group deleted.", MOSSGREEN, WHITE);
	}
}
public db_selectzoneTypeIds(zonetype, client, zonegrp)
{
	char szQuery[258];
	Format(szQuery, 258, sql_selectzoneTypeIds, g_szMapName, zonetype, zonegrp);
	SQL_TQuery(g_hDb, SQL_selectzoneTypeIdsCallback, szQuery, client, DBPrio_Low);
}

public SQL_selectzoneTypeIdsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectzoneTypeIdsCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		int availableids[MAXZONES] = {0, ...}, i;
		while (SQL_FetchRow(hndl))
		{
			i = SQL_FetchInt(hndl, 0);
			if (i < MAXZONES)
				availableids[i] = 1;
		}

		Handle TypeMenu = CreateMenu(Handle_EditZoneTypeId);
		char MenuNum[24], MenuInfo[6], MenuItemName[24];
		int x = 0;
		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
		switch (g_CurrentZoneType[data]) {
			case 0: Format(MenuItemName, 24, "Stop");
			case 1: Format(MenuItemName, 24, "Start");
			case 2: Format(MenuItemName, 24, "End");
			case 3:{
					Format(MenuItemName, 24, "Stage");
					x = 2;
			}
			case 4: Format(MenuItemName, 24, "Checkpoint");
			case 5: Format(MenuItemName, 24, "Speed");
			case 6: Format(MenuItemName, 24, "TeleToStart");
			case 7: Format(MenuItemName, 24, "Validator");
			case 8: Format(MenuItemName, 24, "Checker");
			default: Format(MenuItemName, 24, "Unknown");
		}

		for (int k = 0; k<35; k++)
		{
			if (availableids[k] == 0)
			{
				Format(MenuNum, sizeof(MenuNum), "%s-%i", MenuItemName, (k+x));
				Format(MenuInfo, sizeof(MenuInfo), "%i", k);
				AddMenuItem(TypeMenu, MenuInfo, MenuNum);
			}
		}

		SetMenuExitBackButton(TypeMenu, true);
		DisplayMenu(TypeMenu, data, MENU_TIME_FOREVER);
	}
}

public checkZoneTypeIds()
{
	char szQuery[258];
	Format(szQuery, 258, "SELECT `zonegroup` ,`zonetype`, `zonetypeid`  FROM `ck_zones` WHERE `mapname` = '%s';", g_szMapName);
	SQL_TQuery(g_hDb, checkZoneTypeIdsCallback, szQuery, 1, DBPrio_Low);
}

public checkZoneTypeIdsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (checkZoneTypeIds): %s", error);
		return;
	}
	if(SQL_HasResultSet(hndl))
	{
		int idChecker[MAXZONEGROUPS][ZONEAMOUNT][MAXZONES], idCount[MAXZONEGROUPS][ZONEAMOUNT];
		char szQuery[258];
		while (SQL_FetchRow(hndl))
		{
			idChecker[SQL_FetchInt(hndl, 0)][SQL_FetchInt(hndl, 1)][SQL_FetchInt(hndl, 2)] = 1;
			idCount[SQL_FetchInt(hndl, 0)][SQL_FetchInt(hndl, 1)]++;
		}
		for (int i = 0; i < MAXZONEGROUPS; i++)
		{
			for (int j = 0; j < ZONEAMOUNT; j++)
			{
				for (int k = 0; k < idCount[i][j]; k++)
				{
					if (idChecker[i][j][k] == 1)
						continue;
					else
					{
						//PrintToServer("[ckSurf] Error on zonetype: %i, zonetypeid: %i", i, idChecker[i][k]);
						Format(szQuery, 258, "UPDATE `ck_zones` SET zonetypeid = zonetypeid-1 WHERE mapname = '%s' AND zonetype = %i AND zonetypeid > %i AND zonegroup = %i;", g_szMapName, j, k, i);
						SQL_LockDatabase(g_hDb);
						SQL_FastQuery(g_hDb, szQuery);
						SQL_UnlockDatabase(g_hDb);
					}
				}
			}
		}

		char szQuery2[258];
		Format(szQuery2, 258, "SELECT `zoneid` FROM `ck_zones` WHERE mapname = '%s' ORDER BY zoneid ASC;", g_szMapName);
		SQL_TQuery(g_hDb, checkZoneIdsCallback, szQuery2, 1, DBPrio_Low);
	}
}

public checkZoneIdsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (checkZoneIdsCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		int i = 0;
		char szQuery[258];
		while (SQL_FetchRow(hndl))
		{
			if (SQL_FetchInt(hndl, 0) == i)
			{
				i++;
				continue;
			}
			else
			{
				Format(szQuery, 258, "UPDATE `ck_zones` SET zoneid = %i WHERE mapname = '%s' AND zoneid = %i", g_szMapName, SQL_FetchInt(hndl, 0));
				SQL_LockDatabase(g_hDb);
				SQL_FastQuery(g_hDb, szQuery);
				SQL_UnlockDatabase(g_hDb);
				i++;
			}
		}

		char szQuery2[258];
		Format(szQuery2, 258, "SELECT `zonegroup` FROM `ck_zones` WHERE `mapname` = '%s' ORDER BY `zonegroup` ASC;", g_szMapName);
		SQL_TQuery(g_hDb, checkZoneGroupIds, szQuery2, 1, DBPrio_Low);
	}
}

public checkZoneGroupIds(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (checkZoneGroupIds): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		int i = 0;
		char szQuery[258];
		while (SQL_FetchRow(hndl))
		{
			if (SQL_FetchInt(hndl, 0) == i)
				continue;
			else if (SQL_FetchInt(hndl, 0) == (i+1))
				i++;
			else
			{
				i++;
				Format(szQuery, 258, "UPDATE `ck_zones` SET `zonegroup` = %i WHERE `mapname` = '%s' AND `zonegroup` = %i", i, g_szMapName, SQL_FetchInt(hndl, 0));
				SQL_LockDatabase(g_hDb);
				SQL_FastQuery(g_hDb, szQuery);
				SQL_UnlockDatabase(g_hDb);
			}
		}
		db_selectMapZones();
	}
}

public db_selectMapZones()
{
	char szQuery[258];
	Format(szQuery, 258, sql_selectMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectMapZonesCallback, szQuery, 1, DBPrio_Low);
}

public SQL_selectMapZonesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_selectMapZonesCallback): %s", error);
		return;
	}
	RemoveZones();

	if(SQL_HasResultSet(hndl))
	{
		float posA[3], posB[3];
		g_mapZonesCount = 0;
		g_bhasStages = false;
		g_bhasBonus = false;

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
			g_mapZones[i][zoneGroup] = 0;
		}

		for (int x = 0; x < MAXZONEGROUPS; x++)
		{
			g_mapZoneCountinGroup[x] = 0;
			for(int k = 0; k < ZONEAMOUNT; k++)
				g_mapZonesTypeCount[x][k] = 0;
		}

		// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
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
			g_mapZones[g_mapZonesCount][Vis] = SQL_FetchInt(hndl, 10);
			g_mapZones[g_mapZonesCount][Team] = SQL_FetchInt(hndl, 11);
			g_mapZones[g_mapZonesCount][zoneGroup] = SQL_FetchInt(hndl, 12);

			Array_Copy(g_mapZones[g_mapZonesCount][PointA], posA, 3);
			Array_Copy(g_mapZones[g_mapZonesCount][PointB], posB, 3);

			AddVectors(posA, posB, g_fZonePositions[g_mapZonesCount]);
			g_fZonePositions[g_mapZonesCount][0]=FloatDiv(g_fZonePositions[g_mapZonesCount][0], 2.0);
			g_fZonePositions[g_mapZonesCount][1]=FloatDiv(g_fZonePositions[g_mapZonesCount][1], 2.0);
			g_fZonePositions[g_mapZonesCount][2]=FloatDiv(g_fZonePositions[g_mapZonesCount][2], 2.0);

			SQL_FetchString(hndl, 13, g_mapZones[g_mapZonesCount][zoneName], 128);

			if (!g_mapZones[g_mapZonesCount][zoneName][0])
			{
				switch(g_mapZones[g_mapZonesCount][zoneType])
				{
					case 0:{
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Stop-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 1:{
						if (g_mapZones[g_mapZonesCount][zoneGroup] > 0)
						{
							g_bhasBonus = true;
							Format(g_mapZones[g_mapZonesCount][zoneName], 128, "BonusStart-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							Format(g_szZoneGroupName[g_mapZones[g_mapZonesCount][zoneGroup]], 128, "BONUS %i", g_mapZones[g_mapZonesCount][zoneGroup]);							
						}
						else
							Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Start-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 2:{
						if (g_mapZones[g_mapZonesCount][zoneGroup] > 0)
							Format(g_mapZones[g_mapZonesCount][zoneName], 128, "BonusEnd-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
						else
							Format(g_mapZones[g_mapZonesCount][zoneName], 128, "End-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 3:{
						g_bhasStages = true;
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Stage-%i", (g_mapZones[g_mapZonesCount][zoneTypeId]+2));
					}
					case 4:{
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Checkpoint-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 5:{
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Speed-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 6:{
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "TeleToStart-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 7:{
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Validator-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 8:{
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Checker-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
				}
			}
			else
			{			
				if (g_mapZones[g_mapZonesCount][zoneType] == 1)
					Format(g_szZoneGroupName[g_mapZones[g_mapZonesCount][zoneGroup]], 128, "%s", g_mapZones[g_mapZonesCount][zoneName]);
			}
				
			g_mapZonesTypeCount[g_mapZones[g_mapZonesCount][zoneGroup]][g_mapZones[g_mapZonesCount][zoneType]]++;
			
			g_mapZonesCount++;
		}
	}
	db_selectZoneGroupCount();
}

public db_selectZoneGroupCount()
{
	char szQuery[258];
	Format(szQuery, 258, sql_selectZoneGroupCount, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectZoneGroupCountCallback, szQuery, 1, DBPrio_Low);
}

public sql_selectZoneGroupCountCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectZoneGroupCountCallback): %s", error);
		return;
	}
	g_mapZoneGroupCount = 1; // 1 = No Bonus, 2 = Bonus, >2 = Multiple bonuses

	if(SQL_HasResultSet(hndl))
		g_mapZoneGroupCount = SQL_GetRowCount(hndl);
	
	if (g_mapZoneGroupCount < 1)
		g_mapZoneGroupCount = 1;

	for (int x = 0; x < MAXZONEGROUPS; x++)
		for(int k = 0; k < ZONEAMOUNT; k++)
			if (g_mapZonesTypeCount[x][k] > 0)
				g_mapZoneCountinGroup[x]++

	RefreshZones();
	db_selectMapTier();
	db_CalcAvgRunTime();
	CheckSpawnPoints();

	for (int i = 0; i < g_mapZoneGroupCount; i++)
	{
		db_selectSpawnLocations(i);
		db_viewRecordCheckpoints(i);
		db_viewBonusTotalCount(i);
		db_viewFastestBonus(i);
	}
}


public db_deleteMapZones()
{
	char szQuery[258];
	Format(szQuery, 258, sql_deleteMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteMapZonesCallback, szQuery, 1, DBPrio_Low);
}

public SQL_deleteMapZonesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_deleteMapZonesCallback): %s", error);
		return;
	}
}

public db_deleteZone(zoneid)
{
	char szQuery[258];
	Format(szQuery, 258, sql_deleteZone, g_szMapName, zoneid);
	SQL_TQuery(g_hDb, SQL_deleteZoneCallback, szQuery, 1, DBPrio_Low);
}

public SQL_deleteZoneCallback(Handle owner, Handle hndl, const char[] error, any:data)
{	
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_deleteZoneCallback): %s", error);
		return;
	}

	db_checkAndFixZoneIds();
}














///////////////////////
//// MISC /////////////
///////////////////////


public db_insertLastPosition(client, char szMapName[128], stage, zgroup)
{	 
	if(g_bRestore && !g_bRoundEnd && (StrContains(g_szSteamID[client], "STEAM_") != -1) && g_bTimeractivated[client])
	{
		Handle pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szMapName);
		WritePackString(pack, g_szSteamID[client]);
		WritePackCell(pack, stage);
		WritePackCell(pack, zgroup);
		char szQuery[512]; 
		Format(szQuery, 512, "SELECT * FROM ck_playertemp WHERE steamid = '%s'",g_szSteamID[client]);
		SQL_TQuery(g_hDb,db_insertLastPositionCallback,szQuery,pack,DBPrio_Low);
	}
}

public db_insertLastPositionCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_insertLastPositionCallback): %s", error);
		return;
	}

	char szQuery[1024]; 
	char szMapName[128]; 
	char szSteamID[32]; 

	ResetPack(data);
	int client = ReadPackCell(data);      
	ReadPackString(data, szMapName, 128);	
	ReadPackString(data, szSteamID, 32);	
	int stage = ReadPackCell(data);
	int zgroup = ReadPackCell(data);
	CloseHandle(data);

	if (1 <= client <= MaxClients)
	{
		if (!g_bTimeractivated[client])
			g_fPlayerLastTime[client] = -1.0;
		int tickrate = g_Server_Tickrate * 5 * 11;
		if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			Format(szQuery, 1024, sql_updatePlayerTmp, g_fPlayerCordsLastPosition[client][0],g_fPlayerCordsLastPosition[client][1],g_fPlayerCordsLastPosition[client][2],g_fPlayerAnglesLastPosition[client][0],g_fPlayerAnglesLastPosition[client][1],g_fPlayerAnglesLastPosition[client][2], g_fPlayerLastTime[client], szMapName, tickrate, stage, zgroup, szSteamID);
			SQL_TQuery(g_hDb,SQL_CheckCallback,szQuery,DBPrio_Low);	
		}
		else
		{
			Format(szQuery, 1024, sql_insertPlayerTmp, g_fPlayerCordsLastPosition[client][0],g_fPlayerCordsLastPosition[client][1],g_fPlayerCordsLastPosition[client][2],g_fPlayerAnglesLastPosition[client][0],g_fPlayerAnglesLastPosition[client][1],g_fPlayerAnglesLastPosition[client][2], g_fPlayerLastTime[client],szSteamID, szMapName,tickrate, stage, zgroup);
			SQL_TQuery(g_hDb,SQL_CheckCallback,szQuery,DBPrio_Low);
		}
	}
}

public db_deletePlayerTmps()
{	 
	char szQuery[64]; 
	Format(szQuery, 64, "delete FROM ck_playertemp");
	SQL_TQuery(g_hDb,SQL_CheckCallback,szQuery,DBPrio_Low);	
}

public db_ViewLatestRecords(client)
{
	SQL_TQuery(g_hDb, sql_selectLatestRecordsCallback, sql_selectLatestRecords, client,DBPrio_Low);
}

public sql_selectLatestRecordsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectLatestRecordsCallback): %s", error);
		return;
	}

	char szName[64];
	char szMapName[64];
	char szDate[64];
	char szTime[32];
	float  ftime;
	PrintToConsole(data, "----------------------------------------------------------------------------------------------------");
	PrintToConsole(data,"Last map records:");
	if(SQL_HasResultSet(hndl))
	{		
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			ftime = SQL_FetchFloat(hndl, 1); 
			FormatTimeFloat(data, ftime, 3,szTime,sizeof(szTime));
			SQL_FetchString(hndl, 2, szMapName, 64);
			SQL_FetchString(hndl, 3, szDate, 64);
			PrintToConsole(data,"%s: %s on %s - Time %s",szDate,szName, szMapName, szTime);
			i++;
		}
		if (i==1)
			PrintToConsole(data,"No records found.");	
	}
	else
		PrintToConsole(data,"No records found.");
	PrintToConsole(data, "----------------------------------------------------------------------------------------------------");
	PrintToChat(data, "[%cCK%c] See console for output!", MOSSGREEN,WHITE);	
}

			
public db_InsertLatestRecords(char szSteamID[32], char szName[32], float FinalTime)
{
	char szQuery[512];       
	Format(szQuery, 512, sql_insertLatestRecords, szSteamID, szName, FinalTime, g_szMapName); 
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);
}

public GetDBName(client, char szSteamId[32])
{
	char szQuery[512];      
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId); 
	SQL_TQuery(g_hDb, GetDBNameCallback, szQuery, client,DBPrio_Low);
}

public GetDBNameCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (GetDBNameCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, g_szProfileName[data], MAX_NAME_LENGTH);	
		db_viewPlayerAll(data, g_szProfileName[data]);
	}
}

public db_CalcAvgRunTime()
{
	char szQuery[256];  
	Format(szQuery, 256, sql_selectAllMapTimesinMap, g_szMapName);
	SQL_TQuery(g_hDb, SQL_db_CalcAvgRunTimeCallback, szQuery, DBPrio_Low);
}

public SQL_db_CalcAvgRunTimeCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_db_CalcAvgRunTimeCallback): %s", error);
		return;
	}

	g_favg_maptime = 0.0;
	if(SQL_HasResultSet(hndl))
	{
		int rowcount = SQL_GetRowCount(hndl);
		int i, protimes;
		float ProTime;	
		while (SQL_FetchRow(hndl))
		{
			float pro = SQL_FetchFloat(hndl, 0);
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
	// Types: Start(1), End(2), BonusStart(3), BonusEnd(4), Stage(5), Checkpoint(6), Speed(7), TeleToStart(8), Validator(9), Chekcer(10), Stop(0)
	if (g_bhasBonus)
	{
		for (int i = 1; i < MAXZONEGROUPS; i++)
		db_CalcAvgRunTimeBonus(i);
	}
}
public db_CalcAvgRunTimeBonus(zonegrp)
{
	char szQuery[256];  
	Format(szQuery, 256, sql_selectAllBonusTimesinMap, g_szMapName);
	SQL_TQuery(g_hDb, SQL_db_CalcAvgRunBonusTimeCallback, szQuery, zonegrp, DBPrio_Low);
}

public SQL_db_CalcAvgRunBonusTimeCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_db_CalcAvgRunTimeCallback): %s", error);
		return;
	}

	g_fAvg_BonusTime[data] = 0.0;
	if(SQL_HasResultSet(hndl))
	{
		int rowcount = SQL_GetRowCount(hndl);
		int i, runtimes;
		float runtime;	
		while (SQL_FetchRow(hndl))
		{
			float time = SQL_FetchFloat(hndl, 0);
			if (time > 0.0)
			{
				runtime += time;
				runtimes++;
			}			
			i++;
			if (rowcount == i)
			{
				g_fAvg_BonusTime[data] = runtime / runtimes;
			}
		}
	}
}

public db_GetDynamicTimelimit()
{
	if (!g_bDynamicTimelimit)
		return;
	char szQuery[256];  
	Format(szQuery, 256, sql_selectAllMapTimesinMap, g_szMapName);
	SQL_TQuery(g_hDb, SQL_db_GetDynamicTimelimitCallback, szQuery, DBPrio_Low);
}


public SQL_db_GetDynamicTimelimitCallback(Handle owner, Handle hndl, const char[] error, any:data) 
{   
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_db_GetDynamicTimelimitCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{
		int maptimes = 0;
		float total = 0.0, time = 0.0;	
		while (SQL_FetchRow(hndl))
		{	
			time = SQL_FetchFloat(hndl, 0);
			if (time > 0.0)
			{
				total += time;
				maptimes++;
			}
		}
				//requires min. 5 map times
		if (maptimes > 5)
		{
			int scale_factor = 3;
			int avg = RoundToNearest((total) / 60.0 / float(maptimes)); 
	
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
		
			//timelimit: min 20min, max 120min
			if (avg < 20)
				avg = 20;
			if (avg > 120)
				avg = 120;
				
			//set timelimit
			char szTimelimit[32];
			Format(szTimelimit,32,"mp_timelimit %i;mp_roundtime %i", avg, avg);
			ServerCommand(szTimelimit);
			ServerCommand("mp_restartgame 1");
		}
		else
			ServerCommand("mp_timelimit 50");
	}
}


public db_CalculatePlayerCount()
{
	char szQuery[255];
	Format(szQuery, 255, sql_CountRankedPlayers);      
	SQL_TQuery(g_hDb, sql_CountRankedPlayersCallback, szQuery,DBPrio_Low);

	//get amount of players with actual player points
	db_CalculatePlayersCountGreater0();
}

public db_CalculatePlayersCountGreater0()
{
	char szQuery[255];
	Format(szQuery, 255, sql_CountRankedPlayers2);      
	SQL_TQuery(g_hDb, sql_CountRankedPlayers2Callback, szQuery,DBPrio_Low);
}



public sql_CountRankedPlayersCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_CountRankedPlayersCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_pr_AllPlayers = SQL_FetchInt(hndl, 0);
	}
	else
		g_pr_AllPlayers=1;	
}

public sql_CountRankedPlayers2Callback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_CountRankedPlayers2Callback): %s", error);
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
		SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM ck_latestrecords WHERE date < NOW() - INTERVAL 1 WEEK", DBPrio_Low);
	else
		SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM ck_latestrecords WHERE date <= date('now','-7 day')", DBPrio_Low);
}

public db_viewUnfinishedMaps(client, char szSteamId[32])
{
	char szQuery[1024];       
	char map[128];
	int queryNumber = 1;
	g_unfinishedMaps[client] = 0;
	g_unfinishedBonuses[client] = 0;
	for (int i = 0; i < GetArraySize(g_MapList); i++)
	{
		GetArrayString(g_MapList, i, map, sizeof(map));
		Format(szQuery, 1024, sql_selectRecord, szSteamId, map);  
		Handle pack = CreateDataPack();
		WritePackString(pack, map);
		WritePackString(pack, szSteamId);
		WritePackCell(pack, client);
		WritePackCell(pack, queryNumber);
		SQL_TQuery(g_hDb, db_viewUnfinishedMapsCallback, szQuery, pack,DBPrio_Low);
		queryNumber++;
	}	
	if (IsValidClient(client))
	{
		PrintToConsole(client," ");
		PrintToConsole(client,"-------------");
		PrintToConsole(client,"Unfinished Maps of %i maps", g_pr_MapCount);
		PrintToConsole(client,"SteamID: %s", szSteamId);
		PrintToConsole(client,"-------------");
		PrintToConsole(client," ");
		PrintToChat(client, "%t", "ConsoleOutput", LIMEGREEN,WHITE); 	
		ProfileMenu(client, -1);
	}
}

public db_viewUnfinishedMapsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_viewUnfinishedMapsCallback): %s", error);
		return;
	}
	char szSteamId[128];
	char szMap[128];

	ResetPack(data);
	ReadPackString(data, szMap, 128);
	ReadPackString(data, szSteamId, 128);
	int client = ReadPackCell(data);
	int queryNumber = ReadPackCell(data);
	CloseHandle(data);

	float maptime = -1.0;
	
	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		maptime = SQL_FetchFloat(hndl, 1);
	}
	Handle pack2 = CreateDataPack();
	WritePackString(pack2, szMap);
	WritePackString(pack2, szSteamId);
	WritePackCell(pack2, client);
	WritePackCell(pack2, queryNumber);
	WritePackFloat(pack2, maptime);

	char szQuery[1024];
	Format(szQuery, 1024, sql_checkIfBonusInMap, szMap);
	SQL_TQuery(g_hDb, SQL_viewUnfinishedBonusesCallback, szQuery, pack2, DBPrio_Low);
}

public SQL_viewUnfinishedBonusesCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_viewUnfinishedBonusesCallback): %s", error);
		return;
	}
	char szMap[128];
	char szSteamId[128];

	ResetPack(data);
	ReadPackString(data, szMap, 128);
	ReadPackString(data, szSteamId, 128);
	int client = ReadPackCell(data);
	int queryNumber = ReadPackCell(data);
	float runtime = ReadPackFloat(data);
	CloseHandle(data);

	if(SQL_HasResultSet(hndl) && SQL_GetRowCount(hndl) > 0) // has bonus
	{
		Handle pack2 = CreateDataPack();
		WritePackString(pack2, szMap);
		WritePackString(pack2, szSteamId);
		WritePackCell(pack2, client);
		WritePackCell(pack2, queryNumber);
		WritePackFloat(pack2, runtime);

		char szQuery[1024];
		Format(szQuery, sizeof(szQuery), sql_selectPersonalBonusRecords, szSteamId, szMap);
		SQL_TQuery(g_hDb, SQL_viewUnfinishedBonusesCallback2, szQuery, pack2, DBPrio_Low);
	}
	else // no bonus on this map, print if not finished
	{
		if(IsValidClient(client))
		{
			if (runtime <= 0.0 && IsValidClient(client))
			{
				if (strlen(szMap) < 15) // <- 14
					PrintToConsole(client, "%s:\t\t\tMap", szMap);
				else
					if (14 < strlen(szMap) < 23) // 15 - 22
						PrintToConsole(client, "%s:\t\tMap", szMap);
					else
						if (22 < strlen(szMap) < 29) // 23 - 28
							PrintToConsole(client, "%s:\tMap", szMap);
						else
							if (strlen(szMap) > 28) // 29 ->
								PrintToConsole(client, "%s: Map", szMap);

				g_unfinishedMaps[client]++;
			}
		
			if (queryNumber == g_pr_MapCount)
			{
				PrintToConsole(client, "------------------");
				PrintToConsole(client, "%i unfinished maps", g_unfinishedMaps[client]);
				PrintToConsole(client, "%i unfinished bonuses", g_unfinishedBonuses[client]);
			}
		}
	}
}

public SQL_viewUnfinishedBonusesCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_viewUnfinishedBonusesCallback2): %s", error);
		return;
	}

	char szMap[128];
	char szSteamId[128];

	ResetPack(data);
	ReadPackString(data, szMap, 128);
	ReadPackString(data, szSteamId, 128);
	int client = ReadPackCell(data);
	int queryNumber = ReadPackCell(data);
	float MapTime = ReadPackFloat(data);
	CloseHandle(data);

	bool unfinished = false;
	float BonusTime = -1.0;
	char printedLine[256];

	if (strlen(szMap) < 15) // <- 14
		Format(printedLine, 256, "%s:\t\t\t", szMap);
	else
		if (14 < strlen(szMap) < 23) // 15 - 22
			Format(printedLine, 256, "%s:\t\t", szMap);
		else
			if (22 < strlen(szMap) < 29) // 23 - 28
				Format(printedLine, 256, "%s:\t", szMap);
			else
				if (strlen(szMap) > 28) // 29 ->
					Format(printedLine, 256, "%s: ", szMap);

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl)) // has bonus
	{
		BonusTime = SQL_FetchFloat(hndl, 0);
	}

	if (BonusTime <= 0.0 && MapTime <= 0.0)
	{
		g_unfinishedMaps[client]++;
		g_unfinishedBonuses[client]++;
		Format(printedLine, 256, "%sMap & Bonus", printedLine);
		unfinished = true;
	}
	else 
	{
		if (BonusTime <= 0.0)
		{
			g_unfinishedBonuses[client]++;
			Format(printedLine, 256, "%sBonus", printedLine);
			unfinished = true;
		}
		else
		{
			if (MapTime <= 0.0)
			{
				g_unfinishedMaps[client]++;
				Format(printedLine, 256, "%sMap", printedLine);
				unfinished = true;
			}
		}
	}
	if(unfinished && IsValidClient(client))
	{
		PrintToConsole(client, printedLine);
	}
	if (queryNumber == g_pr_MapCount)
	{
		PrintToConsole(client, "------------------");
		PrintToConsole(client, "%i unfinished maps", g_unfinishedMaps[client]);
		PrintToConsole(client, "%i unfinished bonuses", g_unfinishedBonuses[client]);
	}}

public db_viewPlayerProfile1(client, char szPlayerName[MAX_NAME_LENGTH])
{
	char szQuery[512];
	char szName[MAX_NAME_LENGTH*2+1];
	SQL_EscapeString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);    
	Format(szQuery, 512, sql_selectPlayerRankAll2, szName);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, szPlayerName);
	SQL_TQuery(g_hDb, SQL_ViewPlayerProfile1Callback, szQuery, pack,DBPrio_Low);
}

public SQL_ViewPlayerProfile1Callback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewPlayerProfile1Callback): %s", error);
		return;
	}
	char szPlayerName[MAX_NAME_LENGTH];

	ResetPack(data);
	int client = ReadPackCell(data);
	ReadPackString(data, szPlayerName, MAX_NAME_LENGTH);	
	CloseHandle(data);

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{           		
		SQL_FetchString(hndl, 1, g_szProfileSteamId[client], 32);
		db_viewPlayerRank(client,g_szProfileSteamId[client]);
	}
	else
	{
		char szQuery[512];
		char szName[MAX_NAME_LENGTH*2+1];
		SQL_EscapeString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH*2+1);      
		Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT,szName,PERCENT);
		SQL_TQuery(g_hDb, SQL_ViewPlayerProfile2Callback, szQuery, client,DBPrio_Low);		
	}
}


public sql_selectPlayerNameCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectPlayerNameCallback): %s", error);
		return;
	}

	ResetPack(data);
	int clientid = ReadPackCell(data);
	int client = ReadPackCell(data);
	CloseHandle(data);

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

//
// 0. Admins counting players points starts here
//
public RefreshPlayerRankTable(max)
{
	g_pr_Recalc_ClientID=1;
	g_pr_RankingRecalc_InProgress=true;
	char szQuery[255];

	//SELECT steamid, name from ck_playerrank where points > 0 ORDER BY points DESC";
	Format(szQuery, 255, sql_selectRankedPlayers);      
	SQL_TQuery(g_hDb, sql_selectRankedPlayersCallback, szQuery, max,DBPrio_Low);
}

public sql_selectRankedPlayersCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (sql_selectRankedPlayersCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl))
	{	
		int i = 66;
		int x;
		g_pr_TableRowCount = SQL_GetRowCount(hndl);
		if (g_pr_TableRowCount==0)
		{
			for (int c = 1; c <= MaxClients; c++)
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
		if (MAX_PR_PLAYERS != data && g_pr_TableRowCount > data)
			x = 66 + data;
		else
			x = 66 + g_pr_TableRowCount;

		if (x > MAX_PR_PLAYERS)
			x = MAX_PR_PLAYERS-1;
		if (IsValidClient(g_pr_Recalc_AdminID) && g_bManualRecalc)
		{
			int max = MAX_PR_PLAYERS-66;	
			PrintToConsole(g_pr_Recalc_AdminID, " \n>> Recalculation started! (Only Top %i because of performance reasons)",max); 
		}
		while (SQL_FetchRow(hndl))
		{	
			if (i <= x)
			{
				g_pr_points[i] = 0;
				SQL_FetchString(hndl, 0, g_pr_szSteamID[i], 32);
				SQL_FetchString(hndl, 1, g_pr_szName[i], 64);	
				
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
	char szQuery[255];
	
	//tmps
	Format(szQuery, 255, "DELETE FROM ck_playertemp where mapname != '%s'", g_szMapName);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);
	
	//times
	SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM ck_playertimes where runtimepro = -1.0");
}

public db_resetMapRecords(client, char szMapName[128])
{
	char szQuery[255];      
	Format(szQuery, 255, sql_resetMapRecords, szMapName);
	SQL_TQuery(g_hDb, SQL_CheckCallback2, szQuery,DBPrio_Low);	       
	PrintToConsole(client, "player times on %s cleared.", szMapName);
	if (StrEqual(szMapName,g_szMapName))
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				Format(g_szPersonalRecord[i], 64, "NONE");
				g_fPersonalRecord[i] = 0.0;
				g_MapRank[i] = 99999;
			}
		}
	}            
}

public SQL_InsertPlayerCallBack(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_InsertPlayerCallBack): %s", error);
		return;
	}

	if (IsClientInGame(data))
		db_UpdateLastSeen(data);	
}


public db_UpdateLastSeen(client)
{	 
	if((StrContains(g_szSteamID[client], "STEAM_") != -1) && !IsFakeClient(client))
	{
		char szQuery[512]; 
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

public SQL_CheckCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_CheckCallback): %s", error);
		return;
	}
}


public SQL_CheckCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_CheckCallback2): %s", error);
		return;
	}

	db_viewMapProRankCount();
	db_GetMapRecord_Pro();
}

public SQL_CheckCallback3(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_CheckCallback3): %s", error);
		return;
	}

	char steamid[128];

	ResetPack(data);
	int client = ReadPackCell(data);
	ReadPackString(data, steamid, 128);	
	CloseHandle(data);	

	RecalcPlayerRank(client, steamid);
	db_viewMapProRankCount();
	db_GetMapRecord_Pro();
}

public SQL_CheckCallback4(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_CheckCallback4): %s", error);
		return;
	}
	char steamid[128];

	ResetPack(data);
	int client = ReadPackCell(data);
	ReadPackString(data, steamid, 128);	
	CloseHandle(data);

	RecalcPlayerRank(client, steamid);
}














///////////////////////////
///// PLAYER OPTIONS //////
///////////////////////////

public db_viewPlayerOptions(client, char szSteamId[32])
{
	char szQuery[512];      
	Format(szQuery, 512, sql_selectPlayerOptions, szSteamId);     
	SQL_TQuery(g_hDb, db_viewPlayerOptionsCallback, szQuery,client,DBPrio_Low);	
}

public db_viewPlayerOptionsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_viewPlayerOptionsCallback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		//"SELECT speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3, checkpoints FROM ck_playeroptions where steamid = '%s'";

		g_bInfoPanel[data]=bool:SQL_FetchInt(hndl, 0);
		g_bEnableQuakeSounds[data]=bool:SQL_FetchInt(hndl, 1); 
		g_bAutoBhopClient[data]=bool:SQL_FetchInt(hndl, 2);
		g_bShowNames[data]=bool:SQL_FetchInt(hndl, 3);
		g_bGoToClient[data]=bool:SQL_FetchInt(hndl, 4);
		g_bShowTime[data]=bool:SQL_FetchInt(hndl, 5);
		g_bHide[data]=bool:SQL_FetchInt(hndl, 6);
		g_bShowSpecs[data]=bool:SQL_FetchInt(hndl, 7);		
		g_bStartWithUsp[data]=bool:SQL_FetchInt(hndl, 9);
		g_bHideChat[data]=bool:SQL_FetchInt(hndl, 10);
		g_bViewModel[data]=bool:SQL_FetchInt(hndl, 11);
		g_bCheckpointsEnabled[data]=bool:SQL_FetchInt(hndl, 12);
		
		//org
		g_borg_AutoBhopClient[data] = g_bAutoBhopClient[data];
		g_borg_InfoPanel[data] = g_bInfoPanel[data];
		g_borg_EnableQuakeSounds[data] = g_bEnableQuakeSounds[data];
		g_borg_ShowNames[data] = g_bShowNames[data];
		g_borg_GoToClient[data] = g_bGoToClient[data];
		g_borg_ShowTime[data] = g_bShowTime[data]; 
		g_borg_Hide[data] = g_bHide[data];
		g_borg_StartWithUsp[data] = g_bStartWithUsp[data];
		g_borg_ShowSpecs[data] = g_bShowSpecs[data]; 
		g_borg_HideChat[data] = g_bHideChat[data];
		g_borg_ViewModel[data] = g_bViewModel[data];
		g_borg_CheckpointsEnabled[data] = g_bCheckpointsEnabled[data];
	}
	else
	{
		char szQuery[512];      
		if (!IsValidClient(data))
			return;
		
		//"INSERT INTO ck_playeroptions (steamid, speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3) VALUES('%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%s', '%i', '%i', '%i');";

		Format(szQuery, 512, sql_insertPlayerOptions, g_szSteamID[data], 1,1,1,1,1,0,0,1,"weapon_knife",0,0,1,1);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery,DBPrio_Low);			
		g_borg_InfoPanel[data] = true;
		g_borg_EnableQuakeSounds[data] = true;
		g_borg_AutoBhopClient[data] = true;
		g_borg_ShowNames[data] = true;
		g_borg_GoToClient[data] = true;
		g_borg_ShowTime[data] = false; 
		g_borg_Hide[data] = false;
		g_borg_ShowSpecs[data] = true;
		// weapon_knife
		g_borg_StartWithUsp[data] = false;
		g_borg_HideChat[data] = false;
		g_borg_ViewModel[data] = true;
		g_borg_CheckpointsEnabled[data] = true;
	}
}

public db_updatePlayerOptions(client)
{
	if (g_borg_ViewModel[client] != g_bViewModel[client] || g_borg_HideChat[client] != g_bHideChat[client] || g_borg_StartWithUsp[client] != g_bStartWithUsp[client] || g_borg_AutoBhopClient[client] != g_bAutoBhopClient[client] || g_borg_InfoPanel[client] != g_bInfoPanel[client] || g_borg_EnableQuakeSounds[client] != g_bEnableQuakeSounds[client] || g_borg_ShowNames[client] != g_bShowNames[client] || g_borg_GoToClient[client] != g_bGoToClient[client] || g_borg_ShowTime[client] != g_bShowTime[client] || g_borg_Hide[client] != g_bHide[client] || g_borg_ShowSpecs[client] != g_bShowSpecs[client] || g_borg_CheckpointsEnabled[client] != g_bCheckpointsEnabled[client])
	{
		char szQuery[1024];

		Format(szQuery, 1024, sql_updatePlayerOptions, BooltoInt(g_bInfoPanel[client]),	BooltoInt(g_bEnableQuakeSounds[client]), BooltoInt(g_bAutoBhopClient[client]),BooltoInt(g_bShowNames[client]),BooltoInt(g_bGoToClient[client]),BooltoInt(g_bShowTime[client]),BooltoInt(g_bHide[client]),BooltoInt(g_bShowSpecs[client]),"weapon_knife",BooltoInt(g_bStartWithUsp[client]),BooltoInt(g_bHideChat[client]),BooltoInt(g_bViewModel[client]),BooltoInt(g_bCheckpointsEnabled[client]),g_szSteamID[client]);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client,DBPrio_Low);
	}
}















//////////////////////////////
/// MENUS ////////////////////
//////////////////////////////


public db_selectTopProRecordHolders(client)
{
	char szQuery[512];       
	Format(szQuery, 512, sql_selectMapRecordHolders);   
	SQL_TQuery(g_hDb, db_sql_selectMapRecordHoldersCallback, szQuery, client);
}

public db_sql_selectMapRecordHoldersCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_sql_selectMapRecordHoldersCallback): %s", error);
		return;
	}

	char szSteamID[32];
	char szRecords[64];
	char szQuery[256]; 
	int records=0;	 
	if(SQL_HasResultSet(hndl))
	{
		int i = SQL_GetRowCount(hndl);
		int x = i;
		g_hTopJumpersMenu[data] = CreateMenu(TopProHoldersHandler1);
		SetMenuTitle(g_hTopJumpersMenu[data], "Top 5 Pro Jumpers\n#   Records       Player");   
		while (SQL_FetchRow(hndl))
		{		
			SQL_FetchString(hndl, 0, szSteamID, 32);
			records = SQL_FetchInt(hndl, 1); 
			if (records > 9)
				Format(szRecords,64, "%i", records);
			else
				Format(szRecords,64, "%i  ", records);	
				
			Handle pack = CreateDataPack();
			WritePackCell(pack, data);
			WritePackString(pack, szRecords);
			WritePackCell(pack, i);
			WritePackString(pack, szSteamID);
			Format(szQuery, 256, sql_selectRankedPlayer, szSteamID);
			SQL_TQuery(g_hDb, db_sql_selectMapRecordHoldersCallback2, szQuery, pack);
			i--;
		}
		if (x == 0)
		{
			PrintToChat(data, "%t", "NoRecordTop", MOSSGREEN,WHITE);
			ckTopMenu(data);
		}
	}
	else
	{
		PrintToChat(data, "%t", "NoRecordTop", MOSSGREEN,WHITE);
		ckTopMenu(data);
	}
}

public db_sql_selectMapRecordHoldersCallback2(Handle owner, Handle hndl, const char[] error, any:data)
{       
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_sql_selectMapRecordHoldersCallback2): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		char szName[MAX_NAME_LENGTH];
		char szSteamID[32];
		char szRecords[64];
		char szValue[128];

		ResetPack(data);
		int client = ReadPackCell(data);      
		ReadPackString(data, szRecords, 64);	
		int count = ReadPackCell(data); 
		ReadPackString(data, szSteamID, 32);	
		CloseHandle(data);

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
	char szQuery[128];       
	Format(szQuery, 128, sql_selectTopPlayers);   
	SQL_TQuery(g_hDb, db_selectTop100PlayersCallback, szQuery, client,DBPrio_Low);
}

public db_selectTop100PlayersCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (db_selectTop100PlayersCallback): %s", error);
		return;
	}

	char szValue[128];
	char szName[64];
	char szRank[16];
	char szSteamID[32];
	char szPerc[16];
	int points;
	Handle menu = CreateMenu(TopPlayersMenuHandler1);
	SetMenuTitle(menu, "Top 100 Players\n    Rank   Points       Maps            Player");     
	SetMenuPagination(menu, 5); 
	if(SQL_HasResultSet(hndl))
	{
		int i = 1;
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
			int pro = SQL_FetchInt(hndl, 2); 
			SQL_FetchString(hndl, 3, szSteamID, 32);				
			float fperc;
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
			PrintToChat(data, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
		}
		else
		{
			SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
			DisplayMenu(menu, data, MENU_TIME_FOREVER);
		}
	}
	else
	{
		PrintToChat(data, "%t", "NoPlayerTop", MOSSGREEN,WHITE);
	}
}

public SQL_ViewPlayerProfile2Callback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[ckSurf] SQL Error (SQL_ViewPlayerProfile2Callback): %s", error);
		return;
	}

	if(SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{           
		SQL_FetchString(hndl, 1, g_szProfileSteamId[data], 32);
		db_viewPlayerRank(data,g_szProfileSteamId[data]);
	}
	else
		if(IsClientInGame(data))
			PrintToChat(data, "%t", "PlayerNotFound", MOSSGREEN,WHITE, g_szProfileName[data]);
}

public ProfileMenuHandler(Handle menu, MenuAction:action, param1,param2)
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
					PrintToChat(param1, "[%cCK%c] %cRecalculation in progress. Please wait!", MOSSGREEN,WHITE,GRAY);
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
				case 9: db_selectProSurfers(param1);	
				case 11: db_selectTopProRecordHolders(param1);	

			}	
			if (g_MenuLevel[param1] < 0)		
			{
				if (g_bSelectProfile[param1])
					ProfileMenu(param1,0);
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

public TopPlayersMenuHandler1(Handle menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1]=0;
		db_viewPlayerRank(param1,info);
	}
	if (action ==  MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MapMenuHandler1(Handle menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 1;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public MapTopMenuHandler2(Handle menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 1;
		db_viewPlayerRank(param1, info);		
	}
}

public MapMenuHandler2(Handle menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 8;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}


public MapMenuHandler3(Handle menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 9;
		db_viewPlayerRank(param1, info);		
	}
	if (action ==  MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}


public MenuHandler2(Handle menu, MenuAction:action, param1, param2)
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

public RecordPanelHandler(Handle menu, MenuAction:action, param1, param2)
{
	if(action ==  MenuAction_Select)
	{
		ProfileMenu(param1,-1);
	}	
}

public RecordPanelHandler2(Handle menu, MenuAction:action, param1, param2)
{
	if (action ==  MenuAction_Select)
	{
		ckTopMenu(param1);
	}
}