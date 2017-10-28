 /////////////////////////
// PREPARED STATEMENTS //
////////////////////////

//TABLE CK_SPAWNLOCATIONS
char sql_createSpawnLocations[] = "CREATE TABLE IF NOT EXISTS ck_spawnlocations (mapname VARCHAR(54) NOT NULL, pos_x FLOAT NOT NULL, pos_y FLOAT NOT NULL, pos_z FLOAT NOT NULL, ang_x FLOAT NOT NULL, ang_y FLOAT NOT NULL, ang_z FLOAT NOT NULL, zonegroup INT(12) DEFAULT 0, stage INT(12) DEFAULT 0, PRIMARY KEY(mapname, zonegroup));";
char sql_insertSpawnLocations[] = "INSERT INTO ck_spawnlocations (mapname, pos_x, pos_y, pos_z, ang_x, ang_y, ang_z, zonegroup) VALUES ('%s', '%f', '%f', '%f', '%f', '%f', '%f', %i);";
char sql_updateSpawnLocations[] = "UPDATE ck_spawnlocations SET pos_x = '%f', pos_y = '%f', pos_z = '%f', ang_x = '%f', ang_y = '%f', ang_z = '%f' WHERE mapname = '%s' AND zonegroup = %i";
char sql_selectSpawnLocations[] = "SELECT mapname, pos_x, pos_y, pos_z, ang_x, ang_y, ang_z, zonegroup FROM ck_spawnlocations WHERE mapname ='%s';";
char sql_deleteSpawnLocations[] = "DELETE FROM ck_spawnlocations WHERE mapname = '%s' AND zonegroup = %i";

//TABLE PLAYERTITLES
char sql_createPlayerFlags[] = "CREATE TABLE IF NOT EXISTS ck_playertitles (steamid VARCHAR(32), vip INT(12) DEFAULT 0, mapper INT(12) DEFAULT 0, teacher INT(12) DEFAULT 0, custom1 INT(12) DEFAULT 0, custom2 INT(12) DEFAULT 0, custom3 INT(12) DEFAULT 0, custom4 INT(12) DEFAULT 0, custom5 INT(12) DEFAULT 0, custom6 INT(12) DEFAULT 0, custom7 INT(12) DEFAULT 0, custom8 INT(12) DEFAULT 0, custom9 INT(12) DEFAULT 0, custom10 INT(12) DEFAULT 0, custom11 INT(12) DEFAULT 0, custom12 INT(12) DEFAULT 0, custom13 INT(12) DEFAULT 0, custom14 INT(12) DEFAULT 0, custom15 INT(12) DEFAULT 0, custom16 INT(12) DEFAULT 0, custom17 INT(12) DEFAULT 0, custom18 INT(12) DEFAULT 0, custom19 INT(12) DEFAULT 0, custom20 INT(12) DEFAULT 0, inuse INT(12) DEFAULT 0, PRIMARY KEY(steamid));";
char sql_insertPlayerFlags[] = "INSERT INTO ck_playertitles (steamid, vip, mapper, teacher, custom1, custom2, custom3, custom4, custom5, custom6, custom7, custom8, custom9, custom10, custom11, custom12, custom13, custom14, custom15, custom16, custom17, custom18, custom19, custom20, inuse) VALUES ('%s', %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i);";
char sql_updatePlayerFlags[] = "UPDATE ck_playertitles SET vip = %i, mapper = %i, teacher = %i, custom1 = %i, custom2 = %i, custom3 = %i, custom4 = %i, custom5 = %i, custom6 = %i, custom7 = %i, custom8 = %i, custom9 = %i, custom10 = %i, custom11 = %i, custom12 = %i, custom13 = %i, custom14 = %i, custom15 = %i, custom16 = %i, custom17 = %i, custom18 = %i, custom19 = %i, custom20 = %i, inuse = %i WHERE steamid = '%s'";
char sql_updatePlayerFlagsInUse[] = "UPDATE ck_playertitles SET inuse = %i WHERE steamid = '%s'";
char sql_deletePlayerFlags[] = "DELETE FROM ck_playertitles WHERE steamid = '%s'";
char sql_selectPlayerFlags[] = "SELECT vip, mapper, teacher, custom1, custom2, custom3, custom4, custom5, custom6, custom7, custom8, custom9, custom10, custom11, custom12, custom13, custom14, custom15, custom16, custom17, custom18, custom19, custom20, inuse FROM ck_playertitles WHERE steamid = '%s'";

//TABLE CHALLENGE
char sql_createChallenges[] = "CREATE TABLE IF NOT EXISTS ck_challenges (steamid VARCHAR(32), steamid2 VARCHAR(32), bet INT(12) unsigned, map VARCHAR(32), date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(steamid,steamid2,date));";
char sql_insertChallenges[] = "INSERT INTO ck_challenges (steamid, steamid2, bet, map) VALUES('%s','%s','%i','%s');";
char sql_selectChallenges2[] = "SELECT steamid, steamid2, bet, map, date FROM ck_challenges where steamid = '%s' OR steamid2 ='%s' ORDER BY date DESC";
char sql_selectChallenges[] = "SELECT steamid, steamid2, bet, map FROM ck_challenges where steamid = '%s' OR steamid2 ='%s'";
char sql_selectChallengesCompare[] = "SELECT steamid, steamid2, bet FROM ck_challenges where (steamid = '%s' AND steamid2 ='%s') OR (steamid = '%s' AND steamid2 ='%s')";
char sql_deleteChallenges[] = "DELETE from ck_challenges where steamid = '%s'";

//TABLE ZONES
char sql_createZones[] = "CREATE TABLE IF NOT EXISTS ck_zones (mapname VARCHAR(54) NOT NULL, zoneid INT(12) DEFAULT '-1', zonetype INT(12) DEFAULT '-1', zonetypeid INT(12) DEFAULT '-1', pointa_x FLOAT DEFAULT '-1.0', pointa_y FLOAT DEFAULT '-1.0', pointa_z FLOAT DEFAULT '-1.0', pointb_x FLOAT DEFAULT '-1.0', pointb_y FLOAT DEFAULT '-1.0', pointb_z FLOAT DEFAULT '-1.0', vis INT(12) DEFAULT '0', team INT(12) DEFAULT '0', zonegroup INT(12) DEFAULT 0, zonename VARCHAR(128), PRIMARY KEY(mapname, zoneid));";
char sql_insertZones[] = "INSERT INTO ck_zones (mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename) VALUES ('%s', '%i', '%i', '%i', '%f', '%f', '%f', '%f', '%f', '%f', '%i', '%i', '%i','%s')";
char sql_updateZone[] = "UPDATE ck_zones SET zonetype = '%i', zonetypeid = '%i', pointa_x = '%f', pointa_y ='%f', pointa_z = '%f', pointb_x = '%f', pointb_y = '%f', pointb_z = '%f', vis = '%i', team = '%i', zonegroup = '%i' WHERE zoneid = '%i' AND mapname = '%s'";
char sql_selectzoneTypeIds[] = "SELECT zonetypeid FROM ck_zones WHERE mapname='%s' AND zonetype='%i' AND zonegroup = '%i';";
char sql_selectMapZones[] = "SELECT zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename FROM ck_zones WHERE mapname = '%s' ORDER BY zonetypeid ASC";
char sql_selectTotalBonusCount[] = "SELECT mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename FROM ck_zones WHERE zonetype = 3 GROUP BY mapname, zonegroup;";
char sql_selectZoneIds[] = "SELECT mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename FROM ck_zones WHERE mapname = '%s' ORDER BY zoneid ASC";
char sql_selectBonusesInMap[] = "SELECT mapname, zonegroup, zonename FROM `ck_zones` WHERE mapname LIKE '%c%s%c' AND zonegroup > 0 GROUP BY zonegroup;";
char sql_deleteMapZones[] = "DELETE FROM ck_zones WHERE mapname = '%s'";
char sql_deleteZone[] = "DELETE FROM ck_zones WHERE mapname = '%s' AND zoneid = '%i'";
char sql_deleteAllZones[] = "DELETE FROM ck_zones";
char sql_deleteZonesInGroup[] = "DELETE FROM ck_zones WHERE mapname = '%s' AND zonegroup = '%i'";
char sql_setZoneNames[] = "UPDATE ck_zones SET zonename = '%s' WHERE mapname = '%s' AND zonegroup = '%i';";

//TABLE MAPTIER
char sql_createMapTier[] = "CREATE TABLE IF NOT EXISTS ck_maptier (mapname VARCHAR(54) NOT NULL, tier INT(12), btier1 INT(12), btier2 INT(12), btier3 INT(12), btier4 INT(12), btier5 INT(12), btier6 INT(12), btier7 INT(12), btier8 INT(12), btier9 INT(12), btier10 INT(12), PRIMARY KEY(mapname));";
char sql_selectMapTier[] = "SELECT tier, btier1, btier2, btier3, btier4, btier5, btier6, btier7, btier8, btier9, btier10 FROM ck_maptier WHERE mapname = '%s'";
char sql_deleteAllMapTiers[] = "DELETE FROM ck_maptier";
char sql_insertmaptier[] = "INSERT INTO ck_maptier (mapname, tier) VALUES ('%s', '%i');";
char sql_updatemaptier[] = "UPDATE ck_maptier SET tier = %i WHERE mapname ='%s'";
char sql_updateBonusTier[] = "UPDATE ck_maptier SET btier%i = %i WHERE mapname ='%s'";
char sql_insertBonusTier[] = "INSERT INTO ck_maptier (mapname, btier%i) VALUES ('%s', '%i');";

//TABLE BONUS
char sql_createBonus[] = "CREATE TABLE IF NOT EXISTS ck_bonus (steamid VARCHAR(32), name VARCHAR(32), mapname VARCHAR(32), runtime FLOAT NOT NULL DEFAULT '-1.0', zonegroup INT(12) NOT NULL DEFAULT 1, PRIMARY KEY(steamid, mapname, zonegroup));";
char sql_createBonusIndex[] = "CREATE INDEX bonusrank ON ck_bonus (mapname,runtime,zonegroup);";
char sql_insertBonus[] = "INSERT INTO ck_bonus (steamid, name, mapname, runtime, zonegroup) VALUES ('%s', '%s', '%s', '%f', '%i')";
char sql_updateBonus[] = "UPDATE ck_bonus SET runtime = '%f', name = '%s' WHERE steamid = '%s' AND mapname = '%s' AND zonegroup = %i";
char sql_selectBonusCount[] = "SELECT zonegroup, count(1) FROM ck_bonus WHERE mapname = '%s' GROUP BY zonegroup";
char sql_selectPersonalBonusRecords[] = "SELECT runtime, zonegroup FROM ck_bonus WHERE steamid = '%s' AND mapname = '%s' AND runtime > '0.0'";
char sql_selectPlayerRankBonus[] = "SELECT name FROM ck_bonus WHERE runtime <= (SELECT runtime FROM ck_bonus WHERE steamid = '%s' AND mapname= '%s' AND runtime > 0.0 AND zonegroup = %i) AND mapname = '%s' AND zonegroup = %i;";
char sql_selectFastestBonus[] = "SELECT name, MIN(runtime), zonegroup FROM ck_bonus WHERE mapname = '%s' GROUP BY zonegroup;";
char sql_deleteBonus[] = "DELETE FROM ck_bonus WHERE mapname = '%s'";
char sql_selectAllBonusTimesinMap[] = "SELECT zonegroup, runtime from ck_bonus WHERE mapname = '%s';";
char sql_selectTopBonusSurfers[] = "SELECT db2.steamid, db1.name, db2.runtime as overall, db1.steamid, db2.mapname FROM ck_bonus as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname LIKE '%c%s%c' AND db2.runtime > -1.0 AND zonegroup = %i ORDER BY overall ASC LIMIT 100;";

//TABLE CHECKPOINTS
char sql_createCheckpoints[] = "CREATE TABLE IF NOT EXISTS ck_checkpoints (steamid VARCHAR(32), mapname VARCHAR(32), cp1 FLOAT DEFAULT '0.0', cp2 FLOAT DEFAULT '0.0', cp3 FLOAT DEFAULT '0.0', cp4 FLOAT DEFAULT '0.0', cp5 FLOAT DEFAULT '0.0', cp6 FLOAT DEFAULT '0.0', cp7 FLOAT DEFAULT '0.0', cp8 FLOAT DEFAULT '0.0', cp9 FLOAT DEFAULT '0.0', cp10 FLOAT DEFAULT '0.0', cp11 FLOAT DEFAULT '0.0', cp12 FLOAT DEFAULT '0.0', cp13 FLOAT DEFAULT '0.0', cp14 FLOAT DEFAULT '0.0', cp15 FLOAT DEFAULT '0.0', cp16 FLOAT DEFAULT '0.0', cp17  FLOAT DEFAULT '0.0', cp18 FLOAT DEFAULT '0.0', cp19 FLOAT DEFAULT '0.0', cp20  FLOAT DEFAULT '0.0', cp21 FLOAT DEFAULT '0.0', cp22 FLOAT DEFAULT '0.0', cp23 FLOAT DEFAULT '0.0', cp24 FLOAT DEFAULT '0.0', cp25 FLOAT DEFAULT '0.0', cp26 FLOAT DEFAULT '0.0', cp27 FLOAT DEFAULT '0.0', cp28 FLOAT DEFAULT '0.0', cp29 FLOAT DEFAULT '0.0', cp30 FLOAT DEFAULT '0.0', cp31 FLOAT DEFAULT '0.0', cp32  FLOAT DEFAULT '0.0', cp33 FLOAT DEFAULT '0.0', cp34 FLOAT DEFAULT '0.0', cp35 FLOAT DEFAULT '0.0', zonegroup INT(12) NOT NULL DEFAULT 0, PRIMARY KEY(steamid, mapname, zonegroup));";
char sql_updateCheckpoints[] = "UPDATE ck_checkpoints SET cp1='%f', cp2='%f', cp3='%f', cp4='%f', cp5='%f', cp6='%f', cp7='%f', cp8='%f', cp9='%f', cp10='%f', cp11='%f', cp12='%f', cp13='%f', cp14='%f', cp15='%f', cp16='%f', cp17='%f', cp18='%f', cp19='%f', cp20='%f', cp21='%f', cp22='%f', cp23='%f', cp24='%f', cp25='%f', cp26='%f', cp27='%f', cp28='%f', cp29='%f', cp30='%f', cp31='%f', cp32='%f', cp33='%f', cp34='%f', cp35='%f' WHERE steamid='%s' AND mapname='%s' AND zonegroup='%i'";
char sql_insertCheckpoints[] = "INSERT INTO ck_checkpoints VALUES ('%s', '%s', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%i')";
char sql_selectCheckpoints[] = "SELECT zonegroup, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20, cp21, cp22, cp23, cp24, cp25, cp26, cp27, cp28, cp29, cp30, cp31, cp32, cp33, cp34, cp35 FROM ck_checkpoints WHERE mapname='%s' AND steamid = '%s';";
char sql_selectCheckpointsinZoneGroup[] = "SELECT cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20, cp21, cp22, cp23, cp24, cp25, cp26, cp27, cp28, cp29, cp30, cp31, cp32, cp33, cp34, cp35 FROM ck_checkpoints WHERE mapname='%s' AND steamid = '%s' AND zonegroup = %i;";
char sql_selectRecordCheckpoints[] = "SELECT zonegroup, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20, cp21, cp22, cp23, cp24, cp25, cp26, cp27, cp28, cp29, cp30, cp31, cp32, cp33, cp34, cp35 FROM ck_checkpoints WHERE steamid = '%s' AND mapname='%s' UNION SELECT a.zonegroup, b.cp1, b.cp2, b.cp3, b.cp4, b.cp5, b.cp6, b.cp7, b.cp8, b.cp9, b.cp10, b.cp11, b.cp12, b.cp13, b.cp14, b.cp15, b.cp16, b.cp17, b.cp18, b.cp19, b.cp20, b.cp21, b.cp22, b.cp23, b.cp24, b.cp25, b.cp26, b.cp27, b.cp28, b.cp29, b.cp30, b.cp31, b.cp32, b.cp33, b.cp34, b.cp35 FROM ck_bonus a LEFT JOIN ck_checkpoints b ON a.steamid = b.steamid AND a.zonegroup = b.zonegroup WHERE a.mapname = '%s' GROUP BY a.zonegroup";
char sql_deleteCheckpoints[] = "DELETE FROM ck_checkpoints WHERE mapname = '%s'";

//TABLE LATEST 15 LOCAL RECORDS
char sql_createLatestRecords[] = "CREATE TABLE IF NOT EXISTS ck_latestrecords (steamid VARCHAR(32), name VARCHAR(32), runtime FLOAT NOT NULL DEFAULT '-1.0', map VARCHAR(32), date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(steamid,map,date));";
char sql_insertLatestRecords[] = "INSERT INTO ck_latestrecords (steamid, name, runtime, map, servername) VALUES('%s','%s','%f','%s', '%s');";
char sql_selectLatestRecords[] = "SELECT name, runtime, map, date, servername FROM ck_latestrecords ORDER BY date DESC LIMIT 50";
char sql_select30SecondRecords[] = "SELECT name, runtime, map, date, servername FROM ck_latestrecords WHERE date >= NOW() - INTERVAL 10 second ORDER BY date DESC";

//TABLE PLAYEROPTIONS
char sql_createPlayerOptions[] = "CREATE TABLE IF NOT EXISTS ck_playeroptions (steamid VARCHAR(32), speedmeter INT(12) DEFAULT '0', quake_sounds INT(12) DEFAULT '1', autobhop INT(12) DEFAULT '0', shownames INT(12) DEFAULT '1', goto INT(12) DEFAULT '1', showtime INT(12) DEFAULT '1', hideplayers INT(12) DEFAULT '0', showspecs INT(12) DEFAULT '1', knife VARCHAR(32) DEFAULT 'weapon_knife', new1 INT(12) DEFAULT '0', new2 INT(12) DEFAULT '0', new3 INT(12) DEFAULT '0', checkpoints INT(12) DEFAULT '1', srSound INT(12) NOT NULL  DEFAULT '0', brSound INT(12) NOT NULL DEFAULT '1',  beatSound INT(12) NOT NULL DEFAULT '2',   PRIMARY KEY(steamid));"; 
char sql_newPlayerOptions[] = "ALTER TABLE `ck_playeroptions`  ADD `srSound` INT(12) NOT NULL DEFAULT '0'  AFTER `checkpoints`,  ADD brSound INT(12) NOT NULL DEFAULT '1'  AFTER srSound,  ADD beatSound INT(12) NOT NULL DEFAULT '2'  AFTER `brSound`;";
char sql_insertPlayerOptions[] = "INSERT INTO ck_playeroptions (steamid, speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3, checkpoints, srSound, brSound, beatSound) VALUES('%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i');"; 
char sql_selectPlayerOptions[] = "SELECT speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3, checkpoints, srSound, brSound, beatSound FROM ck_playeroptions where steamid = '%s'"; 
char sql_updatePlayerOptions[] = "UPDATE ck_playeroptions SET speedmeter ='%i', quake_sounds ='%i', autobhop ='%i', shownames ='%i', goto ='%i', showtime ='%i', hideplayers ='%i', showspecs ='%i', knife ='%s', new1 = '%i', new2 = '%i', new3 = '%i', checkpoints = '%i', srSound = '%i', brSound = '%i', beatSound = '%i' where steamid = '%s'"; 


//TABLE SOUND
//char sql_createSound[] = "CREATE TABLE IF NOT EXISTS ck_sound (soundId INT(12) NOT NULL AUTO_INCREMENT, soundCost INT(12) NOT NULL, soundType INT(12) NOT NULL, soundPerm INT(12) NOT NULL, soundPath VARCHAR(64) NOT NULL, PRIMARY KEY (soundId));";
//char sql_insertSoundDefaultSr[] = "INSERT INTO ck_sound (soundId, soundType, soundCost, soundPerm, soundPath) VALUES (0, 0, 0, 0, 'quake/holyshit.mp3');";
//char sql_insertSoundDefaultBr[] = "INSERT INTO ck_sound (soundId, soundType, soundCost, soundPerm, soundPath) VALUES (0, 0, 0, 0, 'quake/wickedsick.mp3');";
//char sql_insertSoundDefaultBeat[] = "INSERT INTO ck_sound (soundId, soundType, soundCost, soundPerm, soundPath) VALUES (0, 0, 0, 0, 'quake/unstoppable.mp3');";
//char sql_updateDefaultSrSound[] = "UPDATE ck_playeroptions SET srSound = 0 where srSound = '%i'";
//char sql_updateDefaultBrSound[] = "UPDATE ck_playeroptions SET brSound = 1 where brSound = '%s'";
//char sql_updateDefaultBeatSound[] = "UPDATE ck_playeroptions SET beatSound = 2 where beatSound = '%s'";
//char sql_insertSound[] = "INSERT INTO ck_sound (soundId, soundType, soundCost, soundPerm, soundPath) VALUES (NULL, '%i', '%i', '%i', '%s');";
//char sql_selectSoundPath[] = "SELECT soundId, soundPath FROM ck_sound;";
//char sql_deleteSound[] = "DELETE FROM ck_sound WHERE soundID = '%i'";

//TABLE PLAYERRANK
char sql_createPlayerRank[] = "CREATE TABLE IF NOT EXISTS ck_playerrank (steamid VARCHAR(32), name VARCHAR(32), country VARCHAR(32), points INT(12) unsigned  DEFAULT '0', winratio INT(12)  DEFAULT '0', pointsratio INT(12)  DEFAULT '0',finishedmaps INT(12) DEFAULT '0', multiplier INT(12) unsigned DEFAULT '0', finishedmapspro INT(12) DEFAULT '0', lastseen DATE, PRIMARY KEY(steamid));";
char sql_insertPlayerRank[] = "INSERT INTO ck_playerrank (steamid, name, country) VALUES('%s', '%s', '%s');";
char sql_updatePlayerRankPoints[] = "UPDATE ck_playerrank SET name ='%s', points ='%i', finishedmapspro='%i',winratio = '%i',pointsratio = '%i' where steamid='%s'";
char sql_updatePlayerRankPoints2[] = "UPDATE ck_playerrank SET name ='%s', points ='%i', finishedmapspro='%i',winratio = '%i',pointsratio = '%i', country ='%s' where steamid='%s'";
char sql_updatePlayerRank[] = "UPDATE ck_playerrank SET finishedmaps ='%i', finishedmapspro='%i', multiplier ='%i'  where steamid='%s'";
char sql_selectPlayerRankAll[] = "SELECT name, steamid FROM ck_playerrank where name like '%c%s%c'";
char sql_selectPlayerRankAll2[] = "SELECT name, steamid FROM ck_playerrank where name = '%s'";
char sql_selectPlayerName[] = "SELECT name FROM ck_playerrank where steamid = '%s'";
char sql_UpdateLastSeenMySQL[] = "UPDATE ck_playerrank SET lastseen = NOW() where steamid = '%s';";
char sql_UpdateLastSeenSQLite[] = "UPDATE ck_playerrank SET lastseen = date('now') where steamid = '%s';";
char sql_selectTopPlayers[] = "SELECT name, points, finishedmapspro, steamid FROM ck_playerrank ORDER BY points DESC LIMIT 100";
char sql_selectTopChallengers[] = "SELECT name, winratio, pointsratio, steamid FROM ck_playerrank ORDER BY pointsratio DESC LIMIT 5";
char sql_selectRankedPlayer[] = "SELECT steamid, name, points, finishedmapspro, multiplier, country, lastseen from ck_playerrank where steamid='%s'";
char sql_selectRankedPlayersRank[] = "SELECT name FROM ck_playerrank WHERE points >= (SELECT points FROM ck_playerrank WHERE steamid = '%s') ORDER BY points";
char sql_selectRankedPlayers[] = "SELECT steamid, name from ck_playerrank where points > 0 ORDER BY points DESC";
char sql_CountRankedPlayers[] = "SELECT COUNT(steamid) FROM ck_playerrank";
char sql_CountRankedPlayers2[] = "SELECT COUNT(steamid) FROM ck_playerrank where points > 0";

//TABLE PLAYERTIMES
char sql_createPlayertimes[] = "CREATE TABLE IF NOT EXISTS ck_playertimes (steamid VARCHAR(32), mapname VARCHAR(32), name VARCHAR(32), runtimepro FLOAT NOT NULL DEFAULT '-1.0', PRIMARY KEY(steamid,mapname));";
char sql_createPlayertimesIndex[] = "CREATE INDEX maprank ON ck_playertimes (mapname, runtimepro);";
char sql_insertPlayer[] = "INSERT INTO ck_playertimes (steamid, mapname, name) VALUES('%s', '%s', '%s');";
char sql_insertPlayerTime[] = "INSERT INTO ck_playertimes (steamid, mapname, name,runtimepro) VALUES('%s', '%s', '%s', '%f');";
char sql_updateRecordPro[] = "UPDATE ck_playertimes SET name = '%s', runtimepro = '%f' WHERE steamid = '%s' AND mapname = '%s';";
char sql_selectPlayer[] = "SELECT steamid FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s';";
char sql_selectMapRecord[] = "SELECT runtimepro, name, steamid FROM ck_playertimes WHERE mapname = '%s' AND runtimepro = (SELECT MIN(runtimepro) FROM ck_playertimes WHERE mapname = '%s' ) AND runtimepro > -1.0";
char sql_selectPersonalRecords[] = "SELECT runtimepro, name FROM ck_playertimes WHERE mapname = '%s' AND steamid = '%s' AND runtimepro > 0.0";
char sql_selectPersonalAllRecords[] = "SELECT db1.name, db2.steamid, db2.mapname, db2.runtimepro as overall, db1.steamid FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.steamid = '%s' AND db2.runtimepro > -1.0 ORDER BY mapname ASC;";
char sql_selectProSurfers[] = "SELECT db1.name, db2.runtimepro, db2.steamid, db1.steamid FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname = '%s' AND db2.runtimepro > -1.0 ORDER BY db2.runtimepro ASC LIMIT 20";
char sql_selectTopSurfers2[] = "SELECT db2.steamid, db1.name, db2.runtimepro as overall, db1.steamid, db2.mapname FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname LIKE '%c%s%c' AND db2.runtimepro > -1.0 ORDER BY overall ASC LIMIT 100;";
char sql_selectTopSurfers[] = "SELECT db2.steamid, db1.name, db2.runtimepro as overall, db1.steamid, db2.mapname FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.mapname = '%s' AND db2.runtimepro > -1.0 ORDER BY overall ASC LIMIT 100;";
char sql_selectPlayerProCount[] = "SELECT name FROM ck_playertimes WHERE mapname = '%s' AND runtimepro  > -1.0;";
char sql_selectPlayerRankProTime[] = "SELECT name,mapname FROM ck_playertimes WHERE runtimepro <= (SELECT runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";
char sql_selectMapRecordHolders[] = "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM ck_playertimes s INNER JOIN (SELECT mapname, MIN(runtimepro) AS runtimepro FROM ck_playertimes where runtimepro > -1.0 GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtimepro = x.runtimepro) y GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid LIMIT 5;";
char sql_selectMapRecordCount[] = "SELECT y.steamid, COUNT(*) AS rekorde FROM (SELECT s.steamid FROM ck_playertimes s INNER JOIN (SELECT mapname, MIN(runtimepro) AS runtimepro FROM ck_playertimes where runtimepro > -1.0  GROUP BY mapname) x ON s.mapname = x.mapname AND s.runtimepro = x.runtimepro) y where y.steamid = '%s' GROUP BY y.steamid ORDER BY rekorde DESC , y.steamid;";
char sql_selectAllMapTimesinMap[] = "SELECT runtimepro from ck_playertimes WHERE mapname = '%s';";

//TABLE PLAYERTEMP
char sql_createPlayertmp[] = "CREATE TABLE IF NOT EXISTS ck_playertemp (steamid VARCHAR(32), mapname VARCHAR(32), cords1 FLOAT NOT NULL DEFAULT '-1.0', cords2 FLOAT NOT NULL DEFAULT '-1.0', cords3 FLOAT NOT NULL DEFAULT '-1.0', angle1 FLOAT NOT NULL DEFAULT '-1.0',angle2 FLOAT NOT NULL DEFAULT '-1.0',angle3 FLOAT NOT NULL DEFAULT '-1.0', EncTickrate INT(12) DEFAULT '-1.0', runtimeTmp FLOAT NOT NULL DEFAULT '-1.0', Stage INT, zonegroup INT NOT NULL DEFAULT 0, PRIMARY KEY(steamid,mapname));";
char sql_insertPlayerTmp[] = "INSERT INTO ck_playertemp (cords1, cords2, cords3, angle1,angle2,angle3,runtimeTmp,steamid,mapname,EncTickrate,Stage,zonegroup) VALUES ('%f','%f','%f','%f','%f','%f','%f','%s', '%s', '%i', %i, %i);";
char sql_updatePlayerTmp[] = "UPDATE ck_playertemp SET cords1 = '%f', cords2 = '%f', cords3 = '%f', angle1 = '%f', angle2 = '%f', angle3 = '%f', runtimeTmp = '%f', mapname ='%s', EncTickrate='%i', Stage = %i, zonegroup = %i WHERE steamid = '%s';";
char sql_deletePlayerTmp[] = "DELETE FROM ck_playertemp where steamid = '%s';";
char sql_selectPlayerTmp[] = "SELECT cords1,cords2,cords3, angle1, angle2, angle3,runtimeTmp, EncTickrate, Stage, zonegroup FROM ck_playertemp WHERE steamid = '%s' AND mapname = '%s';";

// ADMIN 
char sqlite_dropChallenges[] = "DROP TABLE ck_challenges; VACCUM";
char sql_dropChallenges[] = "DROP TABLE ck_challenges;";
char sqlite_dropPlayer[] = "DROP TABLE ck_playertimes; VACCUM";
char sql_dropPlayer[] = "DROP TABLE ck_playertimes;";
char sql_dropPlayerRank[] = "DROP TABLE ck_playerrank;";
char sqlite_dropPlayerRank[] = "DROP TABLE ck_playerrank; VACCUM";
char sql_resetRecords[] = "DELETE FROM ck_playertimes WHERE steamid = '%s'";
char sql_resetRecords2[] = "DELETE FROM ck_playertimes WHERE steamid = '%s' AND mapname LIKE '%s';";
char sql_resetRecordPro[] = "UPDATE ck_playertimes SET runtimepro = '-1.0' WHERE steamid = '%s' AND mapname LIKE '%s';";
char sql_resetCheckpoints[] = "DELETE FROM ck_checkpoints WHERE steamid = '%s' AND mapname LIKE '%s';";
char sql_resetMapRecords[] = "DELETE FROM ck_playertimes WHERE mapname = '%s'";

////////////////////////
//// DATABASE SETUP/////
////////////////////////

public void db_setupDatabase()
{
	////////////////////////////////
	// INIT CONNECTION TO DATABASE//
	////////////////////////////////
	debug_msg("Beginning connection to database.");
	char szError[255];
	g_hDb = SQL_Connect("cksurf", false, szError, 255);

	if (g_hDb == null)
	{
		SetFailState("[%s] Unable to connect to database (%s)", g_szChatPrefix, szError);
		return;
	}

	char szIdent[8];
	SQL_ReadDriver(g_hDb, szIdent, 8);

	if (strcmp(szIdent, "mysql", false) == 0)
	{
		SQL_FastQuery(g_hDb, "SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));");
		g_DbType = MYSQL;
	}
	else
		if (strcmp(szIdent, "sqlite", false) == 0)
			g_DbType = SQLITE;
		else
		{
			LogError("[%s] Invalid Database-Type", g_szChatPrefix);
			return;
		}

	// If updating from a previous version
	SQL_LockDatabase(g_hDb);
	SQL_FastQuery(g_hDb, "SET NAMES  'utf8'");

	////////////////////////////////
	// CHECK WHICH CHANGES ARE    //
	// TO BE DONE TO THE DATABASE //
	////////////////////////////////
	g_bRenaming = false;
	g_bInTransactionChain = false;

	// If coming from KZTimer or a really old version, rename and edit tables to new format
	if (SQL_FastQuery(g_hDb, "SELECT steamid FROM playerrank LIMIT 1") && !SQL_FastQuery(g_hDb, "SELECT steamid FROM ck_playerrank LIMIT 1"))
	{
		SQL_UnlockDatabase(g_hDb);
		db_renameTables();
		return;
	}
	else // If startring for the first time and tables haven't been created yet.
		if (!SQL_FastQuery(g_hDb, "SELECT steamid FROM playerrank LIMIT 1") && !SQL_FastQuery(g_hDb, "SELECT steamid FROM ck_playerrank LIMIT 1"))
	{
		SQL_UnlockDatabase(g_hDb);
		db_createTables();
		return;
	}

	// 1.17 Command to disable checkpoint messages
	SQL_FastQuery(g_hDb, "ALTER TABLE ck_playeroptions ADD checkpoints INT DEFAULT 1;");

	////////////////////////////
	// 1.18 A bunch of changes //
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

	SQL_FastQuery(g_hDb, "CREATE INDEX maprank ON ck_playertimes (mapname, runtimepro)");
	SQL_FastQuery(g_hDb, "CREATE INDEX bonusrank ON ck_bonus (mapname,runtime,zonegroup)");

	/////////////////////////////// 
  	// 1.20.7 Changes            // 
  	// -Add Custom wr/br sounds  // 
 	// - Custom join/dc msg      // 
  	// - custom pos              // 
  	/////////////////////////////// 
  	SQL_FastQuery(g_hDb, sql_newPlayerOptions);  
  	SQL_FastQuery(g_hDb, "ALTER TABLE `ck_latestrecords` ADD `servername` VARCHAR(128);");
  	//if (!SQL_FastQuery(g_hDb, "SELECT soundId FROM ck_sound LIMIT 1"))
  	//{
  		//PrintToServer("---------------------------------------------------------------------------");
  		//PrintToServer("[%s] ADDING IN CUSTOM SOUNDS TO DATABSE", g_szChatPrefix);
  		//SQL_FastQuery(g_hDb, sql_createSound);
  		//PrintToServer("---------------------------------------------------------------------------");
		  	
  	//}
  		  	
  	
	SQL_UnlockDatabase(g_hDb);
	//Do custom sounds now, otherwise we'll find that the precache doesnt load in time.
	//db_loadCustomSounds();
	for (int i = 0; i < sizeof(g_failedTransactions); i++)
		g_failedTransactions[i] = 0;

	txn_addExtraCheckpoints();
	return;
}

void txn_addExtraCheckpoints()
{
	// Add extra checkpoints to Checkpoints and add new primary key:
	if (!SQL_FastQuery(g_hDb, "SELECT cp35 FROM ck_checkpoints;"))
	{
		PrintToServer("---------------------------------------------------------------------------");
		disableServerHibernate();
		PrintToServer("[%s] Started to make changes to database. Updating from 1.17 -> 1.18.", g_szChatPrefix);
		PrintToServer("[%s] WARNING: DO NOT CONNECT TO THE SERVER, OR CHANGE MAP!", g_szChatPrefix);
		PrintToServer("[%s] Adding extra checkpoints... (1 / 6)", g_szChatPrefix);

		g_bInTransactionChain = true;
		Transaction h_checkpoint = SQL_CreateTransaction();

		SQL_AddQuery(h_checkpoint, "ALTER TABLE ck_checkpoints RENAME TO ck_checkpoints_temp;");
		SQL_AddQuery(h_checkpoint, sql_createCheckpoints);
		SQL_AddQuery(h_checkpoint, "INSERT INTO ck_checkpoints(steamid, mapname, zonegroup, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20) SELECT steamid, mapname, 0, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20 FROM ck_checkpoints_temp GROUP BY mapname, steamid;");
		SQL_AddQuery(h_checkpoint, "DROP TABLE ck_checkpoints_temp;");

		SQL_ExecuteTransaction(g_hDb, h_checkpoint, SQLTxn_Success, SQLTxn_TXNFailed, 1);
	}
	else
	{
		PrintToServer("[%s] No database update needed!", g_szChatPrefix);
		return;
	}
}

void txn_addZoneGroups()
{
	// Add zonegroups to ck_bonus and make it a primary key
	if (!SQL_FastQuery(g_hDb, "SELECT zonegroup FROM ck_bonus;"))
	{
		Transaction h_bonus = SQL_CreateTransaction();

		SQL_AddQuery(h_bonus, "ALTER TABLE ck_bonus RENAME TO ck_bonus_temp;");
		SQL_AddQuery(h_bonus, sql_createBonus);
		SQL_AddQuery(h_bonus, sql_createBonusIndex);
		SQL_AddQuery(h_bonus, "INSERT INTO ck_bonus(steamid, name, mapname, runtime) SELECT steamid, name, mapname, runtime FROM ck_bonus_temp;");
		SQL_AddQuery(h_bonus, "DROP TABLE ck_bonus_temp;");

		SQL_ExecuteTransaction(g_hDb, h_bonus, SQLTxn_Success, SQLTxn_TXNFailed, 2);
	}
	else
	{
		PrintToServer("[%s] Zonegroup changes were already done! Skipping to recreating playertemp!", g_szChatPrefix);
		txn_recreatePlayerTemp();
	}
}

void txn_recreatePlayerTemp()
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
	else
	{
		PrintToServer("[%s] Playertemp was already recreated! Skipping to bonus tiers", g_szChatPrefix);
		txn_addBonusTiers();
	}
}

void txn_addBonusTiers()
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
	else
	{
		PrintToServer("[%s] Bonus tiers were already added. Skipping to spawn points", g_szChatPrefix);
		txn_addSpawnPoints();
	}
}
void txn_addSpawnPoints()
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
	else
	{
		PrintToServer("[%s] Spawnpoints were already added! Skipping to changes in zones", g_szChatPrefix);
		txn_changesToZones();
	}
}

void txn_changesToZones()
{
	Transaction h_changesToZones = SQL_CreateTransaction();
	// Set right zonegroups
	SQL_AddQuery(h_changesToZones, "UPDATE ck_zones SET zonegroup = 1 WHERE zonetype = 3 OR zonetype = 4;");
	SQL_AddQuery(h_changesToZones, "UPDATE ck_zones SET zonetypeid = 0 WHERE zonetype = 3 OR zonetype = 4;");

	// Remove ZoneTypes 3 & 4
	SQL_AddQuery(h_changesToZones, "UPDATE ck_zones SET zonetype = 1 WHERE zonetype = 3;");
	SQL_AddQuery(h_changesToZones, "UPDATE ck_zones SET zonetype = 2 WHERE zonetype = 4;");

	// Adjust bigger zonetype numbers to match the changes
	SQL_AddQuery(h_changesToZones, "UPDATE ck_zones SET zonetype = zonetype-2 WHERE zonetype > 4;");
	SQL_ExecuteTransaction(g_hDb, h_changesToZones, SQLTxn_Success, SQLTxn_TXNFailed, 6);
}

public void SQLTxn_Success(Handle db, any data, int numQueries, Handle[] results, any[] queryData)
{
	switch (data)
	{
		case 1: {
			PrintToServer("[%s] Checkpoints added succesfully! Next up: adding zonegroups to ck_bonus (2 / 6)", g_szChatPrefix);
			txn_addZoneGroups();
		}
		case 2: {
			PrintToServer("[%s] Bonus zonegroups succesfully added! Next up: recreating playertemp (3 / 6)", g_szChatPrefix);
			txn_recreatePlayerTemp();
		}
		case 3: {
			PrintToServer("[%s] Playertemp succesfully recreated! Next up: adding bonus tiers (4 / 6)", g_szChatPrefix);
			txn_addBonusTiers();
		}
		case 4: {
			PrintToServer("[%s] Bonus tiers added succesfully! Next up: adding spawn points (5 / 6)", g_szChatPrefix);
			txn_addSpawnPoints();
		}
		case 5: {
			PrintToServer("[%s] Spawnpoints added succesfully! Next up: making changes to zones, to make them match the new database (6 / 6)", g_szChatPrefix);
			txn_changesToZones();
		}
		case 6: {
			g_bInTransactionChain = false;

			revertServerHibernateSettings();
			PrintToServer("[%s] All changes succesfully done! Changing map!", g_szChatPrefix);
			char szBuffer[256];
			Format(szBuffer, sizeof(szBuffer), "[%s] All changes succesfully done! Changing map!", g_szChatPrefix);
			ForceChangeLevel(g_szMapName, szBuffer);
		}
	}
}

public void SQLTxn_TXNFailed(Handle db, any data, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	if (g_failedTransactions[data] == 0)
	{
		switch (data)
		{
			case 1: {
				PrintToServer("[%s] Error in adding extra checkpoints! Retrying.. (%s)", g_szChatPrefix, error);
				txn_addExtraCheckpoints();
			}
			case 2: {
				PrintToServer("[%s] Error in addin zonegroups! Retrying... (%s)", g_szChatPrefix, error);
				txn_addZoneGroups();
			}
			case 3: {
				PrintToServer("[%s] Error in recreating playertemp! Retrying... (%s)", g_szChatPrefix, error);
				txn_recreatePlayerTemp();
			}
			case 4: {
				PrintToServer("[%s] Error in adding bonus tiers! Retrying... (%s)", g_szChatPrefix, error);
				txn_addBonusTiers();
			}
			case 5: {
				PrintToServer("[%s] Error in adding spawn points! Retrying... (%s)", g_szChatPrefix, error);
				txn_addSpawnPoints();
			}
			case 6: {
				PrintToServer("[%s] Error in making changes to zones! Retrying... (%s)", g_szChatPrefix, error);
				txn_changesToZones();
			}
		}
	}
	else
	{
		revertServerHibernateSettings();
		PrintToServer("[%s]: Couldn't make changes into the database. Transaction: %i, error: %s", g_szChatPrefix, data, error);
		PrintToServer("[%s]: Revert back to database backup.", g_szChatPrefix);
		LogError("[%s]: Couldn't make changes into the database. Transaction: %i, error: %s", g_szChatPrefix, data, error);
		return;
	}
	g_failedTransactions[data]++;
}

public void db_createTables()
{
	Transaction createTableTnx = SQL_CreateTransaction();

	SQL_AddQuery(createTableTnx, sql_createPlayertmp);
	SQL_AddQuery(createTableTnx, sql_createPlayertimes);
	SQL_AddQuery(createTableTnx, sql_createPlayertimesIndex);
	SQL_AddQuery(createTableTnx, sql_createPlayerRank);
	SQL_AddQuery(createTableTnx, sql_createChallenges);
	SQL_AddQuery(createTableTnx, sql_createPlayerOptions);
	SQL_AddQuery(createTableTnx, sql_createLatestRecords);
	SQL_AddQuery(createTableTnx, sql_createBonus);
	SQL_AddQuery(createTableTnx, sql_createBonusIndex);
	SQL_AddQuery(createTableTnx, sql_createCheckpoints);
	SQL_AddQuery(createTableTnx, sql_createZones);
	SQL_AddQuery(createTableTnx, sql_createMapTier);
	SQL_AddQuery(createTableTnx, sql_createSpawnLocations);
	SQL_AddQuery(createTableTnx, sql_createPlayerFlags);

	SQL_ExecuteTransaction(g_hDb, createTableTnx, SQLTxn_CreateDatabaseSuccess, SQLTxn_CreateDatabaseFailed);

}

public void SQLTxn_CreateDatabaseSuccess(Handle db, any data, int numQueries, Handle[] results, any[] queryData)
{
	PrintToServer("[%s] Database tables succesfully created!", g_szChatPrefix);
}
public void SQLTxn_CreateDatabaseFailed(Handle db, any data, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	SetFailState("[%s] Database tables could not be created! Error: %s", g_szChatPrefix, error);
}

public void db_renameTables()
{
	disableServerHibernate();

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
		SQL_AddQuery(hndl, sql_createPlayertimesIndex);
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

	// Drop useless tables from KZTimer
	SQL_AddQuery(hndl, "DROP TABLE IF EXISTS playertmp");
	SQL_AddQuery(hndl, "DROP TABLE IF EXISTS LatestRecords");
	SQL_AddQuery(hndl, "DROP TABLE IF EXISTS ck_mapbuttons");
	SQL_AddQuery(hndl, "DROP TABLE IF EXISTS playerjumpstats3");

	SQL_ExecuteTransaction(g_hDb, hndl, SQLTxn_RenameSuccess, SQLTxn_RenameFailed);
}

public void SQLTxn_RenameSuccess(Handle db, any data, int numQueries, Handle[] results, any[] queryData)
{
	g_bRenaming = false;
	revertServerHibernateSettings();
	PrintToChatAll("[%c%s%c] Database changes done succesfully, reloading the map...");
	ForceChangeLevel(g_szMapName, "Database Renaming Done. Restarting Map.");
}

public void SQLTxn_RenameFailed(Handle db, any data, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	g_bRenaming = false;
	revertServerHibernateSettings();
	SetFailState("[%s] Database changes failed! (Renaming) Error: %s", g_szChatPrefix, error);
}
//public void SQLTxn_SoundSuccess(Handle db, any data, int numQueries, Handle[] results, any[] queryData)
//{
	//PrintToServer("---------------------------------------------------------------------------");
	//PrintToServer("[ckSurf] Database changes for sounds done succesfully, reloading the map...");
	//ForceChangeLevel(g_szMapName, "Database Renaming Done. Restarting Map.");
	//PrintToServer("---------------------------------------------------------------------------");
//}

//public void SQLTxn_SoundFailed(Handle db, any data, int numQueries, const char[] error, int failIndex, any[] queryData)
//{
	//PrintToServer("---------------------------------------------------------------------------");
	//SetFailState("[%s] Database changes for sounds failed! (Renaming) Error: %s", g_szChatPrefix, error);
	//PrintToServer("[%s] Database changes for sounds failed! (Renaming) Error: %s", g_szChatPrefix, error);
	//PrintToServer("---------------------------------------------------------------------------");
//}
///////////////////////
//// CUSTOM SOUNDS ////
///////////////////////

//public void db_loadCustomSounds()
//{
	//char szQuery[512];
	//Format(szQuery, 512, sql_selectSoundPath);
	//SQL_TQuery(g_hDb, db_viewCustomSoundsCallback, szQuery,  DBPrio_Low);
	
	//if (!g_bServerDataLoaded)
		//db_selectMapZones();
		
//}

//public void db_viewCustomSoundsCallback(Handle owner, Handle hndl, const char[] error, any data)
//{
	//PrintToServer("---------------------------------------------------------------------------");
  	//PrintToServer("[%s] Coming for Custom Records now...", g_szChatPrefix);
  	//PrintToServer("---------------------------------------------------------------------------");
	//if (hndl == null)
	//{
		//PrintToServer("---------------------------------------------------------------------------");
  		//PrintToServer("[%s] ERROR: %s", g_szChatPrefix, error);
  		//PrintToServer("---------------------------------------------------------------------------");
		//LogError("[%s] SQL Error (db_viewCustomSoundsCallback): %s", g_szChatPrefix, error);
		//return;
	//}
	//if (SQL_GetRowCount(hndl) != 0) //Results Found
	//{
		//PrintToServer("---------------------------------------------------------------------------");
  		//PrintToServer("[%s] Custom Records Found...", g_szChatPrefix);
  		//PrintToServer("---------------------------------------------------------------------------");
		//int soundId;
		//char SoundPath[128];
		//{
			//soundId = SQL_FetchInt(hndl, 0);
			//SQL_FetchString(hndl, 1, SoundPath, 128);
			//PrintToServer("[%s] Adding %s",g_szChatPrefix, SoundPath);
			//Format(SoundPath, 64, "'%s'", SoundPath);
			//g_szSoundPath[soundId] = SoundPath;
			//PrintToServer("---------------------------------------------------------------------------");
  			//PrintToServer("[%s] Adding %i with %s", g_szChatPrefix, soundId, SoundPath);
  			//PrintToServer("---------------------------------------------------------------------------");
		//}
	//}
	//else //No Records found, insert default set
	//{
		//PrintToServer("---------------------------------------------------------------------------");
  		//PrintToServer("---------------------------------------------------------------------------");
		//char sql_insertSound[] = "INSERT INTO ck_sound (soundId, soundType, soundCost, soundPerm, soundPath) VALUES (NULL, '%i', '%i', '%i', '%s');";
		//Transaction hndlsound = SQL_CreateTransaction();
		//SQL_AddQuery(hndlsound, "TRUNCATE TABLE ck_sound");
		//SQL_AddQuery(hndlsound, sql_insertSoundDefaultSr);
		//SQL_AddQuery(hndlsound, sql_insertSoundDefaultBr);
		//SQL_AddQuery(hndlsound, sql_insertSoundDefaultBeat);
		//SQL_ExecuteTransaction(g_hDb, hndlsound, SQLTxn_SoundSuccess, SQLTxn_SoundFailed);
	//}
  	//PrintToServer("[%s] Finishing Custom Records now...", g_szChatPrefix);
  	//PrintToServer("---------------------------------------------------------------------------");
  	//InitPrecache();
  	//
	//return;
//}

///////////////////////
//// PLAYER TITLES ////
///////////////////////

public void db_checkPlayersTitles(int client)
{
	for (int i = 0; i < TITLE_COUNT; i++)
		g_bAdminFlagTitlesTemp[client][i] = false;

	char szQuery[512];
	Format(szQuery, 512, sql_selectPlayerFlags, g_szAdminSelectedSteamID[client]);

	switch (g_iAdminEditingType[client])
	{
		case 1:SQL_TQuery(g_hDb, SQL_checkPlayerFlagsCallback, szQuery, client, DBPrio_Low);
		case 3:SQL_TQuery(g_hDb, SQL_checkPlayerFlagsCallback2, szQuery, client, DBPrio_Low);
	}
}

public void SQL_checkPlayerFlagsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_checkPlayerFlagsCallback): %s ", g_szChatPrefix, error);
		return;
	}

	Menu titleMenu = CreateMenu(Handler_TitleMenu);
	char id[8], menuItem[152];

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

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bAdminSelectedHasFlag[data] = true;
		for (int i = 0; i < TITLE_COUNT; i++)
		{
			if (!StrEqual(g_szflagTitle[i], ""))
			{
				Format(id, 8, "%i", i);
				if (SQL_FetchInt(hndl, i) > 0)
				{
					g_bAdminFlagTitlesTemp[data][i] = true;
					Format(menuItem, 152, "[ON] %s", g_szflagTitle[i]);
					AddMenuItem(titleMenu, id, menuItem);
				}
				else
				{
					Format(menuItem, 152, "[OFF] %s", g_szflagTitle[i]);
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
			if (!StrEqual(g_szflagTitle[i], ""))
			{
				Format(id, 8, "%i", i);
				Format(menuItem, 152, "[OFF] %s", g_szflagTitle[i]);
				AddMenuItem(titleMenu, id, menuItem);
			}
		}
	}

	SetMenuExitButton(titleMenu, true);
	DisplayMenu(titleMenu, data, MENU_TIME_FOREVER);
}

public void SQL_checkPlayerFlagsCallback2(Handle owner, Handle hndl, const char[] error, any data)
{

	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_checkPlayerFlagsCallback2): %s ", g_szChatPrefix, error);
		return;
	}

	Menu titleMenu = CreateMenu(Handler_TitleMenu);
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

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
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

public void sql_disableTitleFromAllbyIndex(int index)
{
	// Do a transaction 
	Transaction h_disableUnusedTitles = SQL_CreateTransaction();
	char query[248];
	for (int i = index; i < TITLE_COUNT; i++)
	{
		switch (i)
		{
			case 0:
			{
				SQL_AddQuery(h_disableUnusedTitles, "UPDATE ck_playertitles SET vip = 0;");
				SQL_AddQuery(h_disableUnusedTitles, "UPDATE ck_playertitles SET inuse = -1 WHERE inuse = 0;");
			}
			case 1:
			{
				SQL_AddQuery(h_disableUnusedTitles, "UPDATE ck_playertitles SET mapper = 0;");
				SQL_AddQuery(h_disableUnusedTitles, "UPDATE ck_playertitles SET inuse = -1 WHERE inuse = 1;");
			}
			case 2:
			{
				SQL_AddQuery(h_disableUnusedTitles, "UPDATE ck_playertitles SET teacher = 0;");
				SQL_AddQuery(h_disableUnusedTitles, "UPDATE ck_playertitles SET inuse = -1 WHERE inuse = 2;");
			}
			default:
			{
				if (i > 2 && i < TITLE_COUNT)
				{
					Format(query, 248, "UPDATE ck_playertitles SET custom%i = 0;", (i - 2));
					SQL_AddQuery(h_disableUnusedTitles, query);
					Format(query, 248, "UPDATE ck_playertitles SET inuse = -1 WHERE inuse = %i;", i);
					SQL_AddQuery(h_disableUnusedTitles, query);
				}
			}
		}
	}
	SQL_ExecuteTransaction(g_hDb, h_disableUnusedTitles, _, _);
}

public void db_viewPersonalFlags(int client, char SteamID[32])
{
	char szQuery[728];
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, SteamID);
	Format(szQuery, 728, sql_selectPlayerFlags, SteamID);
	SQL_TQuery(g_hDb, SQL_PersonalFlagCallback, szQuery, pack, DBPrio_Low);
}

public void SQL_PersonalFlagCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
	ResetPack(pack);
	int client = ReadPackCell(pack);
	char szSteamID[32];
	ReadPackString(pack, szSteamID, 32);
	CloseHandle(pack);

	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_PersonalFlagCallback): %s ", g_szChatPrefix, error);
		if (!g_bSettingsLoaded[client])
			db_viewCheckpoints(client, szSteamID, g_szMapName);
		return;
	}

	for (int i = 0; i < TITLE_COUNT; i++)
		g_bflagTitles[client][i] = false;

	g_bHasTitle[client] = false;
	bool hasTitleRow;

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		hasTitleRow = true;
		for (int i = 0; i < TITLE_COUNT; i++)
		{
			if (SQL_FetchInt(hndl, i) > 0)
			{
				g_bHasTitle[client] = true;
				g_bflagTitles[client][i] = true;
			}
		}
		g_iTitleInUse[client] = SQL_FetchInt(hndl, 23);
	}

	if (IsValidClient(client) && g_bAutoVIPFlag)
	{
		if ((GetUserFlagBits(client) & g_AutoVIPFlag))
		{
			if (!g_bHasTitle[client])
				db_updateAdminVIP(client, szSteamID, hasTitleRow);
			else
				if (!g_bflagTitles[client][0])
				db_updateAdminVIP(client, szSteamID, hasTitleRow);
		}
	}

	Array_Copy(g_bflagTitles[client], g_bflagTitles_orig[client], TITLE_COUNT);

	if (!g_bSettingsLoaded[client])
		db_viewCheckpoints(client, szSteamID, g_szMapName);

}

public void db_updateAdminVIP(int client, char SteamID[32], bool hasTitleRow)
{
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, SteamID);

	char szQuery[420];
	if (!hasTitleRow)
		Format(szQuery, 420, "INSERT INTO `ck_playertitles`(`steamid`, `vip`, `mapper`, `teacher`, `custom1`, `custom2`, `custom3`, `custom4`, `custom5`, `custom6`, `custom7`, `custom8`, `custom9`, `custom10`, `custom11`, `custom12`, `custom13`, `custom14`, `custom15`, `custom16`, `custom17`, `custom18`, `custom19`, `custom20`, `inuse`) VALUES ('%s',1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);", SteamID);
	else
		Format(szQuery, 420, "UPDATE `ck_playertitles` SET `vip`= 1, `inuse`= 0 WHERE `steamid` = '%s'", SteamID);
	SQL_TQuery(g_hDb, db_updateVIPAdminCallback, szQuery, pack, DBPrio_Low);
}

public void db_updateVIPAdminCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_updateVIPAdminCallback): %s ", g_szChatPrefix, error);
		return;
	}

	ResetPack(pack);
	int client = ReadPackCell(pack);
	char szSteamID[32];
	ReadPackString(pack, szSteamID, 32);
	CloseHandle(pack);

	db_checkChangesInTitle(client, szSteamID);
}

public void db_checkChangesInTitle(int client, char SteamID[32])
{
	char szQuery[728];
	Format(szQuery, 728, sql_selectPlayerFlags, SteamID);

	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, SteamID);

	SQL_TQuery(g_hDb, db_checkChangesInTitleCallback, szQuery, pack, DBPrio_Low);
}

public void db_checkChangesInTitleCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_checkChangesInTitleCallback): %s ", g_szChatPrefix, error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	char steamid[32];
	ReadPackString(data, steamid, 32);
	CloseHandle(data);

	if (IsValidClient(client))
	{
		for (int i = 0; i < TITLE_COUNT; i++)
			g_bflagTitles[client][i] = false;

		g_bHasTitle[client] = false;

		if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			for (int i = 0; i < TITLE_COUNT; i++)
				if (SQL_FetchInt(hndl, i) > 0)
				{
					g_bHasTitle[client] = true;
					g_bflagTitles[client][i] = true;
				}

			//g_iTitleInUse[client] = SQL_FetchInt(hndl, 23);
		}
	}
	else
	{
		db_updatePlayerTitleInUse(-1, steamid);
		return;
	}

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
					{
						if (g_iTitleInUse[client] == i)
						{
							g_iTitleInUse[client] = -1;
							db_updatePlayerTitleInUse(-1, steamid);
						}

						g_bTrailOn[client] = false;
						PrintToChat(client, "[%c%s%c] You have lost your VIP privileges!", MOSSGREEN, g_szChatPrefix, WHITE);
					}
					break;
				}
				default:
				{

					g_bflagTitles_orig[client][i] = g_bflagTitles[client][i];
					if (g_bflagTitles[client][i])
						PrintToChat(client, "[%c%s%c] Congratulations! You have gained the custom title \"%s\"!", MOSSGREEN, g_szChatPrefix, WHITE, g_szflagTitle_Colored[i]);
					else
					{
						if (g_iTitleInUse[client] == i)
						{
							g_iTitleInUse[client] = -1;
							db_updatePlayerTitleInUse(-1, steamid);
						}

						PrintToChat(client, "[%c%s%c] You have lost your custom title \"%s\"!", MOSSGREEN, g_szChatPrefix, WHITE, g_szflagTitle_Colored[i]);
					}
					break;
				}
			}
		}
	}
}

public void db_insertPlayerTitles(int client, int titleID)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_insertPlayerFlags, g_szAdminSelectedSteamID[client], BooltoInt(g_bAdminFlagTitlesTemp[client][0]), BooltoInt(g_bAdminFlagTitlesTemp[client][1]), BooltoInt(g_bAdminFlagTitlesTemp[client][2]), BooltoInt(g_bAdminFlagTitlesTemp[client][3]), BooltoInt(g_bAdminFlagTitlesTemp[client][4]), BooltoInt(g_bAdminFlagTitlesTemp[client][5]), BooltoInt(g_bAdminFlagTitlesTemp[client][6]), BooltoInt(g_bAdminFlagTitlesTemp[client][7]), BooltoInt(g_bAdminFlagTitlesTemp[client][8]), BooltoInt(g_bAdminFlagTitlesTemp[client][9]), BooltoInt(g_bAdminFlagTitlesTemp[client][10]), BooltoInt(g_bAdminFlagTitlesTemp[client][11]), BooltoInt(g_bAdminFlagTitlesTemp[client][12]), BooltoInt(g_bAdminFlagTitlesTemp[client][13]), BooltoInt(g_bAdminFlagTitlesTemp[client][14]), BooltoInt(g_bAdminFlagTitlesTemp[client][15]), BooltoInt(g_bAdminFlagTitlesTemp[client][16]), BooltoInt(g_bAdminFlagTitlesTemp[client][17]), BooltoInt(g_bAdminFlagTitlesTemp[client][18]), BooltoInt(g_bAdminFlagTitlesTemp[client][19]), BooltoInt(g_bAdminFlagTitlesTemp[client][20]), BooltoInt(g_bAdminFlagTitlesTemp[client][21]), BooltoInt(g_bAdminFlagTitlesTemp[client][22]), titleID);
	SQL_TQuery(g_hDb, SQL_insertFlagCallback, szQuery, client, DBPrio_Low);
}

public void SQL_insertFlagCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_insertFlagCallback): %s ", g_szChatPrefix, error);
		return;
	}

	if (IsValidClient(data))
		PrintToChat(data, "[%c%s%c] Succesfully granted title to a player", MOSSGREEN, g_szChatPrefix, WHITE);

	db_checkChangesInTitle(g_iAdminSelectedClient[data], g_szAdminSelectedSteamID[data]);
}

public void db_updatePlayerTitles(int client, int titleID)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_updatePlayerFlags, g_bAdminFlagTitlesTemp[client][0], g_bAdminFlagTitlesTemp[client][1], g_bAdminFlagTitlesTemp[client][2], g_bAdminFlagTitlesTemp[client][3], g_bAdminFlagTitlesTemp[client][4], g_bAdminFlagTitlesTemp[client][5], g_bAdminFlagTitlesTemp[client][6], g_bAdminFlagTitlesTemp[client][7], g_bAdminFlagTitlesTemp[client][8], g_bAdminFlagTitlesTemp[client][9], g_bAdminFlagTitlesTemp[client][10], g_bAdminFlagTitlesTemp[client][11], g_bAdminFlagTitlesTemp[client][12], g_bAdminFlagTitlesTemp[client][13], g_bAdminFlagTitlesTemp[client][14], g_bAdminFlagTitlesTemp[client][15], g_bAdminFlagTitlesTemp[client][16], g_bAdminFlagTitlesTemp[client][17], g_bAdminFlagTitlesTemp[client][18], g_bAdminFlagTitlesTemp[client][19], g_bAdminFlagTitlesTemp[client][20], g_bAdminFlagTitlesTemp[client][21], g_bAdminFlagTitlesTemp[client][22], titleID, g_szAdminSelectedSteamID[client]);
	SQL_TQuery(g_hDb, SQL_updatePlayerFlagsCallback, szQuery, client, DBPrio_Low);
}

public void SQL_updatePlayerFlagsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_updatePlayerFlagsCallback): %s ", g_szChatPrefix, error);
		return;
	}

	if (IsValidClient(data))
		PrintToChat(data, "[%c%s%c] Succesfully updated player's titles", MOSSGREEN, g_szChatPrefix, WHITE);

	if (g_iAdminSelectedClient[data] != -1)
		db_checkChangesInTitle(g_iAdminSelectedClient[data], g_szAdminSelectedSteamID[data]);
}

public void db_updatePlayerTitleInUse(int inUse, char szSteamId[32])
{
	char szQuery[512];
	Format(szQuery, 512, sql_updatePlayerFlagsInUse, inUse, szSteamId);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, -1, DBPrio_Low);
}

public void db_deletePlayerTitles(int client)
{
	if (IsValidClient(g_iAdminSelectedClient[client]))
	{
		GetClientAuthId(g_iAdminSelectedClient[client], AuthId_Steam2, g_szAdminSelectedSteamID[client], MAX_NAME_LENGTH, true);
	}
	else if (StrEqual(g_szAdminSelectedSteamID[client], ""))
		return;

	char szQuery[258];
	Format(szQuery, 258, sql_deletePlayerFlags, g_szAdminSelectedSteamID[client]);
	SQL_TQuery(g_hDb, SQL_deletePlayerTitlesCallback, szQuery, client, DBPrio_Low);
}

public void SQL_deletePlayerTitlesCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_deletePlayerTitlesCallback): %s ", g_szChatPrefix, error);
		return;
	}

	PrintToChat(data, "[%c%s%c] Succesfully deleted player's titles.", MOSSGREEN, g_szChatPrefix, WHITE);
	db_checkChangesInTitle(g_iAdminSelectedClient[data], g_szAdminSelectedSteamID[data]);
}

/////////////////////////
//// SPAWN LOCATIONS ////
/////////////////////////

public void db_deleteSpawnLocations(int zGrp)
{
	g_bGotSpawnLocation[zGrp] = false;
	char szQuery[128];
	Format(szQuery, 128, sql_deleteSpawnLocations, g_szMapName, zGrp);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, 1, DBPrio_Low);
}

public void db_updateSpawnLocations(float position[3], float angle[3], int zGrp)
{
	char szQuery[512];
	Format(szQuery, 512, sql_updateSpawnLocations, position[0], position[1], position[2], angle[0], angle[1], angle[2], g_szMapName, zGrp);
	SQL_TQuery(g_hDb, db_editSpawnLocationsCallback, szQuery, zGrp, DBPrio_Low);
}

public void db_insertSpawnLocations(float position[3], float angle[3], int zGrp)
{
	char szQuery[512];
	Format(szQuery, 512, sql_insertSpawnLocations, g_szMapName, position[0], position[1], position[2], angle[0], angle[1], angle[2], zGrp);
	SQL_TQuery(g_hDb, db_editSpawnLocationsCallback, szQuery, zGrp, DBPrio_Low);
}

public void db_editSpawnLocationsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_editSpawnLocationsCallback): %s ", g_szChatPrefix, error);
		return;
	}
	db_selectSpawnLocations();
}

public void db_selectSpawnLocations()
{
	debug_msg("Started db_selectSpawnLocations");
	for (int i = 0; i < MAXZONEGROUPS; i++)
		g_bGotSpawnLocation[i] = false;

	char szQuery[254];
	Format(szQuery, 254, sql_selectSpawnLocations, g_szMapName);
	SQL_TQuery(g_hDb, db_selectSpawnLocationsCallback, szQuery, 1, DBPrio_Low);
}

public void db_selectSpawnLocationsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_selectSpawnLocationsCallback): %s ", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_GetMapRecord_Pro();
		return;
	}

	if (SQL_HasResultSet(hndl))
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
	debug_msg("Ended db_selectSpawnLocations");
	if (!g_bServerDataLoaded)
		db_GetMapRecord_Pro();
	return;
}

/////////////////////
//// PLAYER RANK ////
/////////////////////

public void db_viewMapProRankCount()
{
	debug_msg(" Started db_viewMapProRankCount ");
	g_MapTimesCount = 0;
	char szQuery[512];
	Format(szQuery, 512, sql_selectPlayerProCount, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectPlayerProCountCallback, szQuery, DBPrio_Low);
}

public void sql_selectPlayerProCountCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectPlayerProCountCallback): %s", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_viewFastestBonus();
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_MapTimesCount = SQL_GetRowCount(hndl);
	else
		g_MapTimesCount = 0;
	debug_msg(" Ended sql_selectPlayerProCountCallback ");
	if (!g_bServerDataLoaded)
		db_viewFastestBonus();

	return;
}

//
// Get players rank in current map
//
public void db_viewMapRankPro(int client)
{
	char szQuery[512];
	if (!IsValidClient(client))
		return;

	//"SELECT name,mapname FROM ck_playertimes WHERE runtimepro <= (SELECT runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0) AND mapname = '%s' AND runtimepro > -1.0 ORDER BY runtimepro;";
	Format(szQuery, 512, sql_selectPlayerRankProTime, g_szSteamID[client], g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, db_viewMapRankProCallback, szQuery, client, DBPrio_Low);
}

public void db_viewMapRankProCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_viewMapRankProCallback): %s ", g_szChatPrefix, error);
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_MapRank[client] = SQL_GetRowCount(hndl);
	}
	if (!g_bSettingsLoaded[client])
		db_viewPersonalBonusRecords(client, g_szSteamID[client]);
}

//
// Players points have changed in game, make changes in database and recalculate points
//
public void db_updateStat(int client)
{
	char szQuery[512];
	//"UPDATE ck_playerrank SET finishedmaps ='%i', finishedmapspro='%i', multiplier ='%i'  where steamid='%s'";
	Format(szQuery, 512, sql_updatePlayerRank, g_pr_finishedmaps[client], g_pr_finishedmaps[client], g_pr_multiplier[client], g_szSteamID[client]);

	SQL_TQuery(g_hDb, SQL_UpdateStatCallback, szQuery, client, DBPrio_Low);

}

public void SQL_UpdateStatCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_UpdateStatCallback): %s", g_szChatPrefix, error);
		return;
	}

	// Calculating starts here:
	CalculatePlayerRank(data);
}

public void RecalcPlayerRank(int client, char steamid[128])
{
	int i = 66;
	while (g_bProfileRecalc[i] == true)
		i++;
	if (!g_bProfileRecalc[i])
	{
		char szQuery[255];
		char szsteamid[128 * 2 + 1];
		SQL_EscapeString(g_hDb, steamid, szsteamid, 128 * 2 + 1);
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
public void CalculatePlayerRank(int client)
{

	char szQuery[255];
	char szSteamId[32];
	// Take old points into memory, so at the end you can show how much the points changed
	g_pr_oldpoints[client] = g_pr_points[client];
	// Initialize point calculatin
	g_pr_points[client] = 0;

	getSteamIDFromClient(client, szSteamId, 32);

	Format(szQuery, 255, "SELECT multiplier FROM ck_playerrank WHERE steamid = '%s'", szSteamId);
	SQL_TQuery(g_hDb, sql_selectRankedPlayerCallback, szQuery, client, DBPrio_Low);
}

//
// 2. Count points from improvements, or insert new player into the database
// Fetched values:
// multiplier
//
public void sql_selectRankedPlayerCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectRankedPlayerCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szSteamId[32];

	getSteamIDFromClient(client, szSteamId, 32);

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		if (IsValidClient(client))
		{
			g_pr_Calculating[client] = true;
			if (GetClientTime(client) < (GetEngineTime() - g_fMapStartTime))
				db_UpdateLastSeen(client); // Update last seen on server
		}
		// Multiplier = The amount of times a player has improved on his time
		g_pr_multiplier[client] = SQL_FetchInt(hndl, 0);
		if (g_pr_multiplier[client] < 0)
			g_pr_multiplier[client] *= -1;
		/**
		* The following printtoconsole are for debugging! remove them when done
		*/
		if (IsValidClient(client))	
			PrintToConsole(client, "-----\nBefore calculation:\ng_pr_multiplier: %d\ng_pr_points: %d\n------", g_pr_multiplier[client],g_pr_points[client]);

		// Multiplier increases players points by the set amount in ck_ranking_extra_points_improvements
		g_pr_points[client] += GetConVarInt(g_hExtraPoints) * g_pr_multiplier[client];

		if (IsValidClient(client))
			PrintToConsole(client, "-----\nafter calculation:\ng_hExtraPoints: %d\ng_pr_points: %d\n------", GetConVarInt(g_hExtraPoints),g_pr_points[client]);
		// Next up, challenge points
		char szQuery[512];

		Format(szQuery, 512, "SELECT steamid, bet FROM ck_challenges WHERE steamid = '%s' OR steamid2 ='%s'", szSteamId, szSteamId);
		SQL_TQuery(g_hDb, sql_selectChallengesCallbackCalc, szQuery, client, DBPrio_Low);
	}
	else
	{
		// Players first time on server
		if (client <= MaxClients)
		{			
			g_pr_Calculating[client] = false;
			g_pr_AllPlayers++;

			// Insert player to database
			char szQuery[255];
			char szUName[MAX_NAME_LENGTH];
			char szName[MAX_NAME_LENGTH * 2 + 1];

			GetClientName(client, szUName, MAX_NAME_LENGTH);
			SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH * 2 + 1);

			//"INSERT INTO ck_playerrank (steamid, name, country) VALUES('%s', '%s', '%s');";
			// No need to continue calculating, as the doesn't have any records.
			Format(szQuery, 255, sql_insertPlayerRank, szSteamId, szName, g_szCountry[client]);
			SQL_TQuery(g_hDb, SQL_InsertPlayerCallBack, szQuery, client, DBPrio_Low);

			g_pr_multiplier[client] = 0;
			g_pr_finishedmaps[client] = 0;
			g_pr_finishedmaps_perc[client] = 0.0;
		}
	}
}

//
// 3. Counting points gained from challenges
// Fetched values:
// steamid, bet
public void sql_selectChallengesCallbackCalc(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectChallengesCallbackCalc): %s", g_szChatPrefix, error);
		return;
	}

	char szQuery[512];
	char szSteamId[32];
	char szSteamIdChallenge[32];

	getSteamIDFromClient(client, szSteamId, 32);

	int bet;

	if (SQL_HasResultSet(hndl))
	{
		g_Challenge_WinRatio[client] = 0;
		g_Challenge_PointsRatio[client] = 0;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szSteamIdChallenge, 32);
			bet = SQL_FetchInt(hndl, 1);
			if (StrEqual(szSteamIdChallenge, szSteamId)) // Won the challenge
			{
				//jesus christ. this is not a ratio. a ratio would be wins/losses -> always positive
				g_Challenge_WinRatio[client]++;
				g_Challenge_PointsRatio[client] += bet;
			}
			else // Lost the challenge
			{
				g_Challenge_WinRatio[client]--;
				g_Challenge_PointsRatio[client] -= bet;
			}
		}
	}
	if (GetConVarBool(g_hChallengePoints)) // If challenge points are enabled: add them to players points
		g_pr_points[client] += g_Challenge_PointsRatio[client];

	// Next up, calculate bonus points:
	Format(szQuery, 512, "SELECT mapname, (SELECT count(1)+1 FROM ck_bonus b WHERE a.mapname=b.mapname AND a.runtime > b.runtime AND a.zonegroup = b.zonegroup) AS rank, (SELECT count(1) FROM ck_bonus b WHERE a.mapname = b.mapname AND a.zonegroup = b.zonegroup) as total FROM ck_bonus a WHERE steamid = '%s';", szSteamId);
	SQL_TQuery(g_hDb, sql_CountFinishedBonusCallback, szQuery, client, DBPrio_Low);
}

//
// 4. Calculate points gained from bonuses
// Fetched values
// mapname, rank, total
//
public void sql_CountFinishedBonusCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_CountFinishedBonusCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szMap[128], szSteamId[32], szMapName2[128];
	int totalplayers, rank;

	getSteamIDFromClient(client, szSteamId, 32);

	if (SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			// Total amount of players who have finished the bonus
			totalplayers = SQL_FetchInt(hndl, 2);
			rank = SQL_FetchInt(hndl, 1);
			SQL_FetchString(hndl, 0, szMap, 128);
			for (int i = 0; i < GetArraySize(g_MapList); i++) // Check that the map is in the mapcycle
			{
				GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));
				if (StrEqual(szMapName2, szMap, false))
				{
					float percentage = 1.0 + ((1.0 / float(totalplayers)) - (float(rank) / float(totalplayers)));
					g_pr_points[client] += RoundToCeil(200.0 * percentage);
					g_pr_points[client] += RoundToCeil(200.0/float(rank));
					break;
				}
			}
		}
	}

	// Next up: Points from maps
	char szQuery[512];
	Format(szQuery, 512, "SELECT mapname, (select count(1)+1 from ck_playertimes b where a.mapname=b.mapname and a.runtimepro > b.runtimepro) AS rank, (SELECT count(1) FROM ck_playertimes b WHERE a.mapname = b.mapname) as total FROM ck_playertimes a where steamid = '%s';", szSteamId);
	SQL_TQuery(g_hDb, sql_CountFinishedMapsCallback, szQuery, client, DBPrio_Low);
}

//
// 5. Count the points gained from regular maps
// Fetching:
// mapname, rank, total
//
public void sql_CountFinishedMapsCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_CountFinishedMapsCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szMap[128], szMapName2[128];
	int finishedMaps = 0, totalplayers, rank;

	if (SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			// Total amount of players who have finished the map
			totalplayers = SQL_FetchInt(hndl, 2);
			// Rank in that map
			rank = SQL_FetchInt(hndl, 1);
			// Map name
			SQL_FetchString(hndl, 0, szMap, 128);

			for (int i = 0; i < GetArraySize(g_MapList); i++) // Check that the map is in the mapcycle
			{
				GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));
				if (StrEqual(szMapName2, szMap, false))
				{
					finishedMaps++;
					float percentage = 1.0 + ((1.0 / float(totalplayers)) - (float(rank) / float(totalplayers)));
					g_pr_points[client] += RoundToCeil(200.0 * percentage);
					g_pr_points[client] += RoundToCeil(500.0/float(rank));
					break;
				}
			}
		}
	}
	// Finished maps amount is stored in memory
	g_pr_finishedmaps[client] = finishedMaps;
	// Percentage of maps finished
	g_pr_finishedmaps_perc[client] = (float(finishedMaps) / float(g_pr_MapCount)) * 100.0;
	// Points gained from finishing maps for the first time
	g_pr_points[client] += (finishedMaps * GetConVarInt(g_hExtraPoints2));

	// Done checking, update points
	db_updatePoints(client);

}

//
// 6. Updating points to database
//
public void db_updatePoints(int client)
{
	char szQuery[512];
	char szName[MAX_NAME_LENGTH * 2 + 1];
	char szSteamId[32];
	if (client > MAXPLAYERS && g_pr_RankingRecalc_InProgress || client > MAXPLAYERS && g_bProfileRecalc[client])
	{
		SQL_EscapeString(g_hDb, g_pr_szName[client], szName, MAX_NAME_LENGTH * 2 + 1);
		Format(szQuery, 512, sql_updatePlayerRankPoints, szName, g_pr_points[client], g_pr_finishedmaps[client], g_Challenge_WinRatio[client], g_Challenge_PointsRatio[client], g_pr_szSteamID[client]);
		SQL_TQuery(g_hDb, sql_updatePlayerRankPointsCallback, szQuery, client, DBPrio_Low);
	}
	else
	{
		if (IsValidClient(client))
		{
			GetClientName(client, szName, MAX_NAME_LENGTH);
			GetClientAuthId(client, AuthId_Steam2, szSteamId, MAX_NAME_LENGTH, true);
			//GetClientAuthString(client, szSteamId, MAX_NAME_LENGTH);		
			Format(szQuery, 512, sql_updatePlayerRankPoints2, szName, g_pr_points[client], g_pr_finishedmaps[client], g_Challenge_WinRatio[client], g_Challenge_PointsRatio[client], g_szCountry[client], szSteamId);
			SQL_TQuery(g_hDb, sql_updatePlayerRankPointsCallback, szQuery, client, DBPrio_Low);
		}
	}
}

//
// 7. Calculations done, if calculating all, move forward, if not announce changes.
//
public void sql_updatePlayerRankPointsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_updatePlayerRankPointsCallback): %s", g_szChatPrefix, error);
		return;
	}

	// If was recalculating points, go to the next player, announce or end calculating
	if (data > MAXPLAYERS && g_pr_RankingRecalc_InProgress || data > MAXPLAYERS && g_bProfileRecalc[data])
	{
		if (g_bProfileRecalc[data] && !g_pr_RankingRecalc_InProgress)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i))
				{
					if (StrEqual(g_szSteamID[i], g_pr_szSteamID[data]))
						CalculatePlayerRank(i);
				}
			}
		}
		g_bProfileRecalc[data] = false;
		if (g_pr_RankingRecalc_InProgress)
		{
			//console info
			if (IsValidClient(g_pr_Recalc_AdminID) && g_bManualRecalc)
				PrintToConsole(g_pr_Recalc_AdminID, "%i/%i", g_pr_Recalc_ClientID, g_pr_TableRowCount);
			int x = 66 + g_pr_Recalc_ClientID;
			if (StrContains(g_pr_szSteamID[x], "STEAM", false) != -1)
			{
				ContinueRecalc(x);
			}
			else
			{
				for (int i = 1; i <= MaxClients; i++)
					if (1 <= i <= MaxClients && IsValidClient(i))
					{
						if (g_bManualRecalc)
							PrintToChat(i, "%t", "PrUpdateFinished", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN);
					}
				g_bManualRecalc = false;
				g_pr_RankingRecalc_InProgress = false;

				if (IsValidClient(g_pr_Recalc_AdminID))
					CreateTimer(0.1, RefreshAdminMenu, GetClientSerial(g_pr_Recalc_AdminID), TIMER_FLAG_NO_MAPCHANGE);
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
				PrintToChat(data, "%t", "Rc_PlayerRankFinished", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, g_pr_points[data], GRAY);
			g_bRecalcRankInProgess[data] = false;
		}
		if (IsValidClient(data) && g_pr_showmsg[data]) // Player gained points
		{
			char szName[MAX_NAME_LENGTH];
			GetClientName(data, szName, MAX_NAME_LENGTH);
			int earnedPoints = g_pr_points[data] - g_pr_oldpoints[data];
			if (earnedPoints > 0) // if player earned points -> Announce
			{
				for (int i = 1; i <= MaxClients; i++)
					if (IsValidClient(i))
						PrintToChat(i, "%t", "EarnedPoints", MOSSGREEN, g_szChatPrefix, WHITE, PURPLE, szName, GRAY, PURPLE, earnedPoints, GRAY, PURPLE, g_pr_points[data], GRAY);
			}
			g_pr_showmsg[data] = false;
			db_CalculatePlayersCountGreater0();
		}
		g_pr_Calculating[data] = false;
		db_GetPlayerRank(data);
		RequestFrame(SetClanTag, GetClientSerial(data));
	}
}

//
// Called when player joins server
//
public void db_viewPlayerPoints(int client)
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
	SQL_TQuery(g_hDb, db_viewPlayerPointsCallback, szQuery, client, DBPrio_Low);
}

public void db_viewPlayerPointsCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_viewPlayerPointsCallback): %s", g_szChatPrefix, error);
		if (!g_bSettingsLoaded[client])
			db_viewPlayerOptions(client, g_szSteamID[client]);
		return;
	}

	// Old player - get points
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_pr_points[client] = SQL_FetchInt(hndl, 2);
		g_pr_finishedmaps[client] = SQL_FetchInt(hndl, 3);
		g_pr_multiplier[client] = SQL_FetchInt(hndl, 4);
		if (g_pr_multiplier[client] < 0)
			g_pr_multiplier[client] *= -1;
		g_pr_finishedmaps_perc[client] = (float(g_pr_finishedmaps[client]) / float(g_pr_MapCount)) * 100.0;
		if (IsValidClient(client)) // Count players rank
			db_GetPlayerRank(client);
	}
	else
	{  // New player - insert
		if (IsValidClient(client))
		{
			//insert	
			char szQuery[512];
			char szUName[MAX_NAME_LENGTH];

			if (IsValidClient(client))
				GetClientName(client, szUName, MAX_NAME_LENGTH);
			else
				return;

			// SQL injection protection
			char szName[MAX_NAME_LENGTH * 2 + 1];
			SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH * 2 + 1);

			Format(szQuery, 512, sql_insertPlayerRank, g_szSteamID[client], szName, g_szCountry[client]);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
			db_GetPlayerRank(client); // Count players rank
		}
	}
}

//
// Get the amount of palyers, who have more points
//
public void db_GetPlayerRank(int client)
{
	char szQuery[512];
	//"SELECT name FROM ck_playerrank WHERE points >= (SELECT points FROM ck_playerrank WHERE steamid = '%s') ORDER BY points";
	Format(szQuery, 512, sql_selectRankedPlayersRank, g_szSteamID[client]);
	SQL_TQuery(g_hDb, sql_selectRankedPlayersRankCallback, szQuery, client, DBPrio_Low);
}

public void sql_selectRankedPlayersRankCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectRankedPlayersRankCallback): %s", g_szChatPrefix, error);
		if (!g_bSettingsLoaded[client])
			db_viewPlayerOptions(client, g_szSteamID[client]);
		return;
	}

	if (!IsValidClient(client))
		return;

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_PlayerRank[client] = SQL_GetRowCount(hndl);
		// Sort players by rank in scoreboard
		if (g_pr_AllPlayers < g_PlayerRank[client])
			CS_SetClientContributionScore(client, -9999);
		else
			CS_SetClientContributionScore(client, g_PlayerRank[client] * -1);
	}

	if (!g_bSettingsLoaded[client])
		db_viewPlayerOptions(client, g_szSteamID[client]);
}

public void db_resetPlayerRecords(int client, char steamid[128])
{
	char szQuery[255];
	char szsteamid[128 * 2 + 1];
	SQL_EscapeString(g_hDb, steamid, szsteamid, 128 * 2 + 1);
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
			if (StrEqual(g_szSteamID[i], szsteamid))
			{
				Format(g_szPersonalRecord[i], 64, "NONE");
				g_fPersonalRecord[i] = 0.0;
				g_MapRank[i] = 99999;
			}
		}
	}
}

public void db_dropPlayerRanks(int client)
{
	SQL_LockDatabase(g_hDb);
	if (g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropPlayerRank);
	else
		SQL_FastQuery(g_hDb, sqlite_dropPlayerRank);

	SQL_FastQuery(g_hDb, sql_createPlayerRank);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "playerranks table dropped. Please restart your server!");
}

public void db_dropPlayer(int client)
{
	SQL_TQuery(g_hDb, sql_selectMutliplierCallback, "UPDATE ck_playerrank SET multiplier ='0'", client);
	SQL_LockDatabase(g_hDb);
	if (g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropPlayer);
	else
		SQL_FastQuery(g_hDb, sqlite_dropPlayer);
	SQL_FastQuery(g_hDb, sql_createPlayertimes);
	SQL_FastQuery(g_hDb, sql_createPlayertimesIndex);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "playertimes table dropped. Please restart your server!");
}

public void db_viewPlayerRank(int client, char szSteamId[32])
{
	char szQuery[512];
	Format(g_pr_szrank[client], 512, "");
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback, szQuery, client, DBPrio_Low);
}

public void SQL_ViewRankedPlayerCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRankedPlayerCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
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
		SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback2, szQuery, pack_pr, DBPrio_Low);
	}
}

public void SQL_ViewRankedPlayerCallback2(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRankedPlayerCallback2): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
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
		SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback4, szQuery, data, DBPrio_Low);
	}
}

public void SQL_ViewRankedPlayerCallback4(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRankedPlayerCallback4): %s", g_szChatPrefix, error);
		return;
	}

	char szQuery[512];
	char szSteamId[32];
	char szName[MAX_NAME_LENGTH];

	ResetPack(data);
	ReadPackString(data, szName, MAX_NAME_LENGTH);
	ReadPackString(data, szSteamId, 32);
	int client = ReadPackCell(data);
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		g_MapRecordCount[client] = SQL_FetchInt(hndl, 1); //pack full?
	Format(szQuery, 512, sql_selectChallenges, szSteamId, szSteamId);
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayerCallback5, szQuery, data, DBPrio_Low);
}

public void SQL_ViewRankedPlayerCallback5(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRankedPlayerCallback5): %s", g_szChatPrefix, error);
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
	if (StrEqual(szLastSeen, ""))
		Format(szLastSeen, 100, "Unknown");
	int rank = ReadPackCell(data);
	int prorecords = g_MapRecordCount[client];
	Format(g_szProfileSteamId[client], 32, "%s", szSteamId);
	Format(g_szProfileName[client], MAX_NAME_LENGTH, "%s", szName);
	bool master = false;
	int RankDifference;
	CloseHandle(data);

	int bet;

	if (StrEqual(szSteamId, g_szSteamID[client]))
		g_PlayerRank[client] = rank;

	//get challenge results
	int challenges = 0;
	int challengeswon = 0;
	int challengespoints = 0;
	if (SQL_HasResultSet(hndl))
	{
		challenges = SQL_GetRowCount(hndl);
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szSteamIdChallenge, 32);
			bet = SQL_FetchInt(hndl, 2);
			if (StrEqual(szSteamIdChallenge, szSteamId))
			{
				challengespoints += bet;
				challengeswon++;
			}
			else
			{
				challengespoints -= bet;
				challengeswon--;
			}
		}
	}

	if (!GetConVarBool(g_hChallengePoints))
		challengespoints = 0;

	if (challengespoints > 0)
		Format(szChallengesPoints, 32, "+%ip", challengespoints);
	else
		if (challengespoints <= 0 && GetConVarBool(g_hChallengePoints))
			Format(szChallengesPoints, 32, "%ip", challengespoints);
		else
			if (challengespoints <= 0 && !GetConVarBool(g_hChallengePoints))
				Format(szChallengesPoints, 32, "0p (disabled)");

	if (challengeswon > 0)
		Format(szChallengesWinRatio, 32, "+%i", challengeswon);
	else
		if (challengeswon < 0)
		Format(szChallengesWinRatio, 32, "%i", challengeswon);

	if (finishedmapspro > g_pr_MapCount)
		finishedmapspro = g_pr_MapCount;

	int index = GetSkillgroupFromPoints(points), RankValue[SkillGroup];
	GetArrayArray(g_hSkillGroups, index, RankValue[0]);

	Format(szSkillGroup, 32, "%s", RankValue[RankName]);

	if (index == (GetArraySize(g_hSkillGroups)-1))
	{
		RankDifference = 0;
		Format(szNextRank, 32, " ");
		master = true;
	}
	else
	{
		GetArrayArray(g_hSkillGroups, (index+1), RankValue[0]);
		RankDifference = RankValue[PointReq] - points;
		Format(szNextRank, 32, " (%s)", RankValue[RankName]);
	}

	char szRank[32];
	if (rank > g_pr_RankedPlayers || points == 0)
		Format(szRank, 32, "-");
	else
		Format(szRank, 32, "%i", rank);

	char szRanking[255];
	Format(szRanking, 255, "");
	if (master == false)
	{
		if (GetConVarBool(g_hPointSystem))
			Format(szRanking, 255, "Rank: %s/%i (%i)\nPoints: %ip (%s)\nNext skill group in: %ip%s\n", szRank, g_pr_RankedPlayers, g_pr_AllPlayers, points, szSkillGroup, RankDifference, szNextRank);
		Format(g_pr_szrank[client], 512, "Rank: %s/%i (%i)\nPoints: %ip (%s)\nNext skill group in: %ip%s\nMaps completed: %i/%i (records: %i)\nPlayed challenges: %i\n+W/L Ratio: %s\n+W/L Points ratio: %s\n ", szRank, g_pr_RankedPlayers, g_pr_AllPlayers, points, szSkillGroup, RankDifference, szNextRank, finishedmapspro, g_pr_MapCount, prorecords, challenges, szChallengesWinRatio, szChallengesPoints);
	}
	else
	{
		if (GetConVarBool(g_hPointSystem))
			Format(szRanking, 255, "Rank: %s/%i (%i)\nPoints: %ip (%s)\n", szRank, g_pr_RankedPlayers, g_pr_AllPlayers, points, szSkillGroup);
		Format(g_pr_szrank[client], 512, "Rank: %s/%i (%i)\nPoints: %ip (%s)\nMaps completed: %i/%i (records: %i)\nPlayed challenges: %i\n+ W/L Ratio: %s\n+ W/L points ratio: %s\n ", szRank, g_pr_RankedPlayers, g_pr_AllPlayers, points, szSkillGroup, finishedmapspro, g_pr_MapCount, prorecords, challenges, szChallengesWinRatio, szChallengesPoints);

	}
	char szID[32][2];
	ExplodeString(szSteamId, "_", szID, 2, 32);
	char szTitle[1024];
	if (GetConVarBool(g_hCountry))
		Format(szTitle, 1024, "Player: %s\nSteamID: %s\nNationality: %s \nLast seen: %s\n \n%s\n", szName, szID[1], szCountry, szLastSeen, g_pr_szrank[client]);
	else
		Format(szTitle, 1024, "Player: %s\nSteamID: %s\nLast seen: %s\n \n%s\n", szName, szID[1], szLastSeen, g_pr_szrank[client]);

	Menu profileMenu = new Menu(ProfileMenuHandler);
	profileMenu.SetTitle(szTitle);
	profileMenu.AddItem("Current Map time", "Current Map time");
	profileMenu.AddItem("Challenge history", "Challenge history");
	profileMenu.AddItem("Finished maps", "Finished maps");

	if (IsValidClient(client))
	{
		if (StrEqual(szSteamId, g_szSteamID[client]))
		{
			profileMenu.AddItem("Unfinished maps", "Unfinished maps");
			if (GetConVarBool(g_hPointSystem))
				profileMenu.AddItem("Refresh my profile", "Refresh my profile");
		}
	}
	profileMenu.ExitButton = true;
	profileMenu.Display(client, MENU_TIME_FOREVER);
}

public void db_viewPlayerRank2(int client, char szSteamId[32])
{
	char szQuery[512];
	Format(g_pr_szrank[client], 512, "");
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);
	SQL_TQuery(g_hDb, SQL_ViewRankedPlayer2Callback, szQuery, client, DBPrio_Low);
}

public void SQL_ViewRankedPlayer2Callback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRankedPlayer2Callback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
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
		Format(szQuery, 512, sql_selectChallengesCompare, g_szSteamID[data], szSteamIdTarget, szSteamIdTarget, g_szSteamID[data]);
		SQL_TQuery(g_hDb, sql_selectChallengesCompareCallback, szQuery, pack, DBPrio_Low);
	}
}

public void db_viewPlayerAll2(int client, char szPlayerName[MAX_NAME_LENGTH])
{
	char szQuery[512];
	char szName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH * 2 + 1);
	Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT, szName, PERCENT);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, szPlayerName);
	SQL_TQuery(g_hDb, SQL_ViewPlayerAll2Callback, szQuery, pack, DBPrio_Low);
}

public void SQL_ViewPlayerAll2Callback(Handle owner, Handle hndl, const char[] error, any data)
{

	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewPlayerAll2Callback): %s", g_szChatPrefix, error);
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
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, szSteamId2, 32);
		if (!StrEqual(szSteamId2, g_szSteamID[client]))
			db_viewPlayerRank2(client, szSteamId2);
	}
	else
		PrintToChat(client, "%t", "PlayerNotFound", MOSSGREEN, g_szChatPrefix, WHITE, szName);
	CloseHandle(data);
}

public void db_viewPlayerAll(int client, char szPlayerName[MAX_NAME_LENGTH])
{
	char szQuery[512];
	char szName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH * 2 + 1);
	Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT, szName, PERCENT);
	SQL_TQuery(g_hDb, SQL_ViewPlayerAllCallback, szQuery, client, DBPrio_Low);
}

public void SQL_ViewPlayerAllCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewPlayerAllCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, g_szProfileSteamId[data], 32);
		db_viewPlayerRank(data, g_szProfileSteamId[data]);
	}
	else
		if (IsClientInGame(data))
		PrintToChat(data, "%t", "PlayerNotFound", MOSSGREEN, g_szChatPrefix, WHITE, g_szProfileName[data]);
}

public void ContinueRecalc(int client)
{
	//ON RECALC ALL
	if (client > MAXPLAYERS)
		CalculatePlayerRank(client);
	else
	{
		//ON CONNECT
		if (!IsValidClient(client) || IsFakeClient(client))
			return;
		float diff = GetGameTime() - g_fMapStartTime + 1.5;
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

public void db_selectTopChallengers(int client)
{
	char szQuery[128];
	Format(szQuery, 128, sql_selectTopChallengers);
	SQL_TQuery(g_hDb, sql_selectTopChallengersCallback, szQuery, client, DBPrio_Low);
}

public void sql_selectTopChallengersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectTopChallengersCallback): %s", g_szChatPrefix, error);
		return;
	}
	char szValue[128];
	char szName[MAX_NAME_LENGTH];
	char szWinRatio[32];
	char szSteamID[32];
	char szPointsRatio[32];
	int winratio;
	int pointsratio;
	Menu topChallengersMenu = new Menu(TopChallengeHandler1);
	SetMenuPagination(topChallengersMenu, 5);
	topChallengersMenu.SetTitle("Top 5 Challengers\n#   W/L P.-Ratio    Player (W/L ratio)");
	if (SQL_HasResultSet(hndl))
	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			winratio = SQL_FetchInt(hndl, 1);
			if (!GetConVarBool(g_hChallengePoints))
				pointsratio = 0;
			else
				pointsratio = SQL_FetchInt(hndl, 2);
			SQL_FetchString(hndl, 3, szSteamID, 32);
			if (winratio >= 0)
				Format(szWinRatio, 32, "+%i", winratio);
			else
				Format(szWinRatio, 32, "%i", winratio);

			if (pointsratio >= 0)
				Format(szPointsRatio, 32, "+%ip", pointsratio);
			else
				Format(szPointsRatio, 32, "%ip", pointsratio);

			if (pointsratio < 10)
				Format(szValue, 128, "       %s         » %s (%s)", szPointsRatio, szName, szWinRatio);
			else
				if (pointsratio < 100)
					Format(szValue, 128, "       %s       » %s (%s)", szPointsRatio, szName, szWinRatio);
				else
					if (pointsratio < 1000)
						Format(szValue, 128, "       %s     » %s (%s)", szPointsRatio, szName, szWinRatio);
					else
						if (pointsratio < 10000)
							Format(szValue, 128, "       %s   » %s (%s)", szPointsRatio, szName, szWinRatio);
						else
							Format(szValue, 128, "       %s » %s (%s)", szPointsRatio, szName, szWinRatio);

			topChallengersMenu.AddItem(szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if (i == 1)
		{
			PrintToChat(data, "%t", "NoPlayerTop", MOSSGREEN, g_szChatPrefix, WHITE);
			ckTopMenu(data);
		}
		else
		{
			SetMenuOptionFlags(topChallengersMenu, MENUFLAG_BUTTON_EXIT);
			topChallengersMenu.Display(data, MENU_TIME_FOREVER);
		}
	}
	else
	{
		PrintToChat(data, "%t", "NoPlayerTop", MOSSGREEN, g_szChatPrefix, WHITE);
		ckTopMenu(data);
	}
}

public void db_resetPlayerResetChallenges(int client, char steamid[128])
{
	char szQuery[255];
	char szsteamid[128 * 2 + 1];
	SQL_EscapeString(g_hDb, steamid, szsteamid, 128 * 2 + 1);
	Format(szQuery, 255, sql_deleteChallenges, szsteamid);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);
	SQL_TQuery(g_hDb, SQL_CheckCallback4, szQuery, pack);
	PrintToConsole(client, "won challenges cleared (%s)", szsteamid);
}

public void db_dropChallenges(int client)
{
	SQL_TQuery(g_hDb, SQL_CheckCallback, "UPDATE ck_playerrank SET winratio = '0',pointsratio = '0'", client);
	SQL_LockDatabase(g_hDb);
	if (g_DbType == MYSQL)
		SQL_FastQuery(g_hDb, sql_dropChallenges);
	else
		SQL_FastQuery(g_hDb, sqlite_dropChallenges);
	SQL_FastQuery(g_hDb, sql_createChallenges);
	SQL_UnlockDatabase(g_hDb);
	PrintToConsole(client, "challenge table dropped. Please restart your server!");
}

public int TopChallengeHandler1(Handle menu, MenuAction action, int client, int item)
{

	if (action == MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, item, info, sizeof(info));
		g_MenuLevel[client] = 3;
		db_viewPlayerRank(client, info);
	}

	if (action == MenuAction_Cancel)
	{
		ckTopMenu(client);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public void TopTpHoldersHandler1(Handle menu, MenuAction action, int param1, int param2)
{

	if (action == MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 10;
		db_viewPlayerRank(param1, info);
	}

	if (action == MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public int TopProHoldersHandler1(Handle menu, MenuAction action, int client, int item)
{

	if (action == MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, item, info, sizeof(info));
		g_MenuLevel[client] = 11;
		db_viewPlayerRank(client, info);
	}

	if (action == MenuAction_Cancel)
	{
		ckTopMenu(client);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public void db_viewChallengeHistory(int client, char szSteamId[32])
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectChallenges2, szSteamId, szSteamId);
	if ((StrContains(szSteamId, "STEAM_") != -1) && IsClientInGame(client))
	{
		Handle pack = CreateDataPack();
		WritePackString(pack, szSteamId);
		WritePackString(pack, g_szProfileName[client]);
		WritePackCell(pack, client);
		SQL_TQuery(g_hDb, sql_selectChallengesCallback, szQuery, pack, DBPrio_Low);
	}
	else
		if (IsClientInGame(client))
		PrintToChat(client, "[%c%s%c] Invalid SteamID found.", RED, WHITE);
	ProfileMenu(client, -1);
}

public void sql_selectChallengesCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectChallengesCallback): %s", g_szChatPrefix, error);
		return;
	}

	//decl.
	int bet, cp_allowed = 0, client;
	int bHeader = false;
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

	if (SQL_HasResultSet(hndl))
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
				PrintToConsole(client, " ");
				PrintToConsole(client, "-------------");
				PrintToConsole(client, "Challenge history");
				PrintToConsole(client, "Player: %s", szNameTarget);
				PrintToConsole(client, "SteamID: %s", szSteamIdTarget);
				PrintToConsole(client, "-------------");
				PrintToConsole(client, " ");
				bHeader = true;
				PrintToChat(client, "%t", "ConsoleOutput", LIMEGREEN, g_szChatPrefix, WHITE);
			}

			//won/loss?
			int WinnerTarget = 0;
			if (StrEqual(szSteamId, szSteamIdTarget))
				WinnerTarget = 1;

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
			if (WinnerTarget == 1)
				Format(szQuery, 512, "select name from ck_playerrank where steamid = '%s'", szSteamId2);
			else
				Format(szQuery, 512, "select name from ck_playerrank where steamid = '%s'", szSteamId);
			SQL_TQuery(g_hDb, sql_selectChallengesCallback2, szQuery, pack2, DBPrio_Low);
		}
	}
	if (!bHeader)
	{
		ProfileMenu(client, -1);
		PrintToChat(client, "[%c%s%c] No challenges found.", MOSSGREEN, g_szChatPrefix, WHITE);
	}
}

public void sql_selectChallengesCallback2(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectChallengesCallback2): %s", g_szChatPrefix, error);
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
	if (WinnerTarget == 1)
		Format(szNameOpponent, 32, "%s", szSteamId2);
	else
		Format(szNameOpponent, 32, "%s", szSteamId);

	//query result
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		SQL_FetchString(hndl, 0, szNameOpponent, 32);

	//format..
	if (WinnerTarget == 1)
		Format(szResult, 32, "WIN");
	else
		Format(szResult, 32, "LOSS");

	if (cp_allowed == 1)
		Format(szCps, 32, "yes");
	else
		Format(szCps, 32, "no");

	//console msg
	if (IsClientInGame(client))
		PrintToConsole(client, "(%s) %s vs. %s, map: %s, bet: %i, result: %s", szDate, szNameTarget, szNameOpponent, szMapName, bet, szCps, szResult);
}

public void sql_selectChallengesCompareCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectChallengesCompareCallback): %s", g_szChatPrefix, error);
		return;
	}

	int winratio = 0;
	int challenges = SQL_GetRowCount(hndl);
	int pointratio = 0;
	char szWinRatio[32];
	char szPointsRatio[32];
	char szName[MAX_NAME_LENGTH];

	ResetPack(data);
	int client = ReadPackCell(data);
	ReadPackString(data, szName, MAX_NAME_LENGTH);
	CloseHandle(data);

	if (!IsValidClient(client))
		return;

	if (SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			char szID[32];
			int bet;
			SQL_FetchString(hndl, 0, szID, 32);
			bet = SQL_FetchInt(hndl, 2);
			if (StrEqual(szID, g_szSteamID[client]))
			{
				winratio++;
				pointratio += bet;
			}
			else
			{
				winratio--;
				pointratio -= bet;
			}
		}
		if (winratio > 0)
			Format(szWinRatio, 32, "+%i", winratio);
		else
			Format(szWinRatio, 32, "%i", winratio);

		if (pointratio > 0)
			Format(szPointsRatio, 32, "+%ip", pointratio);
		else
			Format(szPointsRatio, 32, "%ip", pointratio);

		if (winratio > 0)
		{
			if (pointratio > 0)
				PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, GREEN, szWinRatio, GRAY, GREEN, szPointsRatio, GRAY);
			else
				if (pointratio < 0)
					PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, GREEN, szWinRatio, GRAY, RED, szPointsRatio, GRAY);
				else
					PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, GREEN, szWinRatio, GRAY, YELLOW, szPointsRatio, GRAY);
		}
		else
		{
			if (winratio < 0)
			{
				if (pointratio > 0)
					PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, RED, szWinRatio, GRAY, GREEN, szPointsRatio, GRAY);
				else
					if (pointratio < 0)
						PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, RED, szWinRatio, GRAY, RED, szPointsRatio, GRAY);
					else
						PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, RED, szWinRatio, GRAY, YELLOW, szPointsRatio, GRAY);

			}
			else
			{
				if (pointratio > 0)
					PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, YELLOW, szWinRatio, GRAY, GREEN, szPointsRatio, GRAY);
				else
					if (pointratio < 0)
						PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, YELLOW, szWinRatio, GRAY, RED, szPointsRatio, GRAY);
					else
						PrintToChat(client, "[%c%s%c] %cYou have played %c%i%c challenges against %c%s%c (win/loss ratio: %c%s%c, points ratio: %c%s%c)", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, PURPLE, challenges, GRAY, PURPLE, szName, GRAY, YELLOW, szWinRatio, GRAY, YELLOW, szPointsRatio, GRAY);
			}
		}
	}
	else
		PrintToChat(client, "[%c%s%c] No challenges againgst %s found", szName);
}

public void db_insertPlayerChallenge(int client)
{
	if (!IsValidClient(client))
		return;
	char szQuery[255];
	int points;
	points = g_Challenge_Bet[client] * g_pr_PointUnit;

	Format(szQuery, 255, sql_insertChallenges, g_szSteamID[client], g_szChallenge_OpponentID[client], points, g_szMapName);
	SQL_TQuery(g_hDb, sql_insertChallengesCallback, szQuery, client, DBPrio_Low);
}

public void sql_insertChallengesCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_insertChallengesCallback): %s", g_szChatPrefix, error);
		return;
	}
}

///////////////////
// PLAYERTIMES ////
///////////////////

public void db_resetPlayerMapRecord(int client, char steamid[128], char szMapName[128])
{
	char szQuery[255];
	char szQuery2[255];
	char szsteamid[128 * 2 + 1];

	SQL_EscapeString(g_hDb, steamid, szsteamid, 128 * 2 + 1);
	Format(szQuery, 255, sql_resetRecordPro, szsteamid, szMapName);
	Format(szQuery2, 255, sql_resetCheckpoints, szsteamid, szMapName);

	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);

	SQL_TQuery(g_hDb, SQL_CheckCallback3, szQuery, pack);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery2, 1);
	PrintToConsole(client, "map time of %s on %s cleared.", steamid, szMapName);

	if (StrEqual(szMapName, g_szMapName))
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if (StrEqual(g_szSteamID[i], szsteamid))
				{
					Format(g_szPersonalRecord[i], 64, "NONE");
					g_fPersonalRecord[i] = 0.0;
					g_MapRank[i] = 99999;
				}
			}
		}
	}
}

public void db_resetPlayerRecords2(int client, char steamid[128], char szMapName[128])
{
	char szQuery[255];
	char szsteamid[128 * 2 + 1];

	SQL_EscapeString(g_hDb, steamid, szsteamid, 128 * 2 + 1);
	Format(szQuery, 255, sql_resetRecords2, szsteamid, szMapName);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, steamid);
	SQL_TQuery(g_hDb, SQL_CheckCallback3, szQuery, pack);
	PrintToConsole(client, "map times of %s on %s cleared.", steamid, szMapName);

	if (StrEqual(szMapName, g_szMapName))
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if (StrEqual(g_szSteamID[i], szsteamid))
				{
					Format(g_szPersonalRecord[i], 64, "NONE");
					g_fPersonalRecord[i] = 0.0;
					g_MapRank[i] = 99999;
				}
			}
		}
	}
}

public void db_GetMapRecord_Pro()
{
	debug_msg("Started db_GetMapRecord_Pro");
	g_fRecordMapTime = 9999999.0;
	char szQuery[512];
	// SELECT MIN(runtimepro), name, steamid FROM ck_playertimes WHERE mapname = '%s' AND runtimepro > -1.0
	Format(szQuery, 512, sql_selectMapRecord, g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectMapRecordCallback, szQuery, DBPrio_Low);
}

public void sql_selectMapRecordCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectMapRecordCallback): %s", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_viewMapProRankCount();
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fRecordMapTime = SQL_FetchFloat(hndl, 0);
		if (g_fRecordMapTime > -1.0 && !SQL_IsFieldNull(hndl, 0))
		{
			g_fRecordMapTime = SQL_FetchFloat(hndl, 0);
			FormatTimeFloat(0, g_fRecordMapTime, 3, g_szRecordMapTime, 64);
			SQL_FetchString(hndl, 1, g_szRecordPlayer, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 2, g_szRecordMapSteamID, MAX_NAME_LENGTH);
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
	debug_msg(" Ended sql_selectMapRecordCallback ");
	if (!g_bServerDataLoaded)
		db_viewMapProRankCount();
	return;
}

public void sql_selectProSurfersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectProSurfersCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szValue[128];
	char szSteamID[32];
	char szName[64];
	char szTime[32];
	float time;

	Menu topSurfersMenu = new Menu(MapMenuHandler3);
	topSurfersMenu.Pagination = 5;
	topSurfersMenu.SetTitle("Top 20 Map Times (local)\n    Rank   Time              Player");
	if (SQL_HasResultSet(hndl))

	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			time = SQL_FetchFloat(hndl, 1);
			SQL_FetchString(hndl, 2, szSteamID, 32);
			FormatTimeFloat(data, time, 3, szTime, sizeof(szTime));
			if (time < 3600.0)
				Format(szTime, 32, "  %s", szTime);
			if (i < 10)
				Format(szValue, 128, "[0%i.] %s    » %s", i, szTime, szName);
			else
				Format(szValue, 128, "[%i.] %s    » %s", i, szTime, szName);
			AddMenuItem(topSurfersMenu, szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if (i == 1)
		{
			PrintToChat(data, "%t", "NoMapRecords", MOSSGREEN, g_szChatPrefix, WHITE, g_szMapName);
		}
	}
	topSurfersMenu.OptionFlags = MENUFLAG_BUTTON_EXIT;
	topSurfersMenu.Display(data, MENU_TIME_FOREVER);
}

public void db_selectTopSurfers(int client, char mapname[128])
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectTopSurfers, mapname);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, mapname);
	SQL_TQuery(g_hDb, sql_selectTopSurfersCallback, szQuery, pack, DBPrio_Low);
}

public void db_selectMapTopSurfers(int client, char mapname[128])
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectTopSurfers2, PERCENT, mapname, PERCENT);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, mapname);
	SQL_TQuery(g_hDb, sql_selectTopSurfersCallback, szQuery, pack, DBPrio_Low);
}

//// BONUS //////////'

public void db_selectBonusesInMap(int client, char mapname[128])
{
	// SELECT mapname, zonegroup, zonename FROM `ck_zones` WHERE mapname LIKE '%c%s%c' AND zonegroup > 0 GROUP BY zonegroup;
	char szQuery[512];
	Format(szQuery, 512, sql_selectBonusesInMap, PERCENT, mapname, PERCENT);
	SQL_TQuery(g_hDb, db_selectBonusesInMapCallback, szQuery, client, DBPrio_Low);
}

public void db_selectBonusesInMapCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_selectBonusesInMapCallback): %s", g_szChatPrefix, error);
		return;
	}
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		char mapname[128], MenuTitle[248], BonusName[128], MenuID[248];
		int zGrp;

		if (SQL_GetRowCount(hndl) == 1)
		{
			SQL_FetchString(hndl, 0, mapname, 128);
			db_selectBonusTopSurfers(client, mapname, SQL_FetchInt(hndl, 1));
			return;
		}

		Menu listBonusesinMapMenu = new Menu(MenuHandler_SelectBonusinMap);

		SQL_FetchString(hndl, 0, mapname, 128);
		zGrp = SQL_FetchInt(hndl, 1);
		Format(MenuTitle, 248, "Choose a Bonus in %s", mapname);
		listBonusesinMapMenu.SetTitle(MenuTitle);

		SQL_FetchString(hndl, 2, BonusName, 128);

		if (!BonusName[0])
			Format(BonusName, 128, "BONUS %i", zGrp);

		Format(MenuID, 248, "%s-%i", mapname, zGrp);

		listBonusesinMapMenu.AddItem(MenuID, BonusName);

		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 2, BonusName, 128);
			zGrp = SQL_FetchInt(hndl, 1);

			if (StrEqual(BonusName, "NULL", false))
				Format(BonusName, 128, "BONUS %i", zGrp);

			Format(MenuID, 248, "%s-%i", mapname, zGrp);

			listBonusesinMapMenu.AddItem(MenuID, BonusName);
		}

		listBonusesinMapMenu.ExitButton = true;
		listBonusesinMapMenu.Display(client, 60);
	}
	else
	{
		PrintToChat(client, "[%c%s%c] No bonuses found.", MOSSGREEN, g_szChatPrefix, WHITE);
		return;
	}
}

public int MenuHandler_SelectBonusinMap(Handle sMenu, MenuAction action, int client, int item)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			char aID[248];
			char splits[2][128];
			GetMenuItem(sMenu, item, aID, sizeof(aID));
			ExplodeString(aID, "-", splits, sizeof(splits), sizeof(splits[]));

			db_selectBonusTopSurfers(client, splits[0], StringToInt(splits[1]));
		}
		case MenuAction_End:
		{
			delete sMenu;
		}
	}
}

public void db_selectBonusTopSurfers(int client, char mapname[128], int zGrp)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectTopBonusSurfers, PERCENT, mapname, PERCENT, zGrp);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, mapname);
	WritePackCell(pack, zGrp);
	SQL_TQuery(g_hDb, sql_selectTopBonusSurfersCallback, szQuery, pack, DBPrio_Low);
}

public void sql_selectTopBonusSurfersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectTopBonusSurfersCallback): %s", g_szChatPrefix, error);
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
	Handle stringArray = CreateArray(100);
	Menu topMenu;

	if (StrEqual(szMap, g_szMapName))
		topMenu = new Menu(MapMenuHandler1);
	else
		topMenu = new Menu(MapTopMenuHandler2);

	topMenu.Pagination = 5;

	if (SQL_HasResultSet(hndl))
	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			bduplicat = false;
			SQL_FetchString(hndl, 0, szSteamID, 32);
			SQL_FetchString(hndl, 1, szName, 64);
			time = SQL_FetchFloat(hndl, 2);
			SQL_FetchString(hndl, 4, szMap, 128);
			if (i == 1 || (i > 1 && StrEqual(szFirstMap, szMap)))
			{
				int stringArraySize = GetArraySize(stringArray);
				for (int x = 0; x < stringArraySize; x++)
				{
					GetArrayString(stringArray, x, lineBuf, sizeof(lineBuf));
					if (StrEqual(lineBuf, szName, false))
						bduplicat = true;
				}
				if (bduplicat == false && i < 51)
				{
					char szTime[32];
					FormatTimeFloat(client, time, 3, szTime, sizeof(szTime));
					if (time < 3600.0)
						Format(szTime, 32, "   %s", szTime);
					if (i == 100)
						Format(szValue, 128, "[%i.] %s |    » %s", i, szTime, szName);
					if (i >= 10)
						Format(szValue, 128, "[%i.] %s |    » %s", i, szTime, szName);
					else
						Format(szValue, 128, "[0%i.] %s |    » %s", i, szTime, szName);
					topMenu.AddItem(szSteamID, szValue, ITEMDRAW_DEFAULT);
					PushArrayString(stringArray, szName);
					if (i == 1)
						Format(szFirstMap, 128, "%s", szMap);
					i++;
				}
			}
		}
		if (i == 1)
		{
			PrintToChat(client, "%t", "NoTopRecords", MOSSGREEN, g_szChatPrefix, WHITE, szMap);
		}
	}
	else
		PrintToChat(client, "%t", "NoTopRecords", MOSSGREEN, g_szChatPrefix, WHITE, szMap);
	Format(title, 256, "Top 50 Times on %s (B %i) \n    Rank    Time               Player", szFirstMap, zGrp);
	topMenu.SetTitle(title);
	topMenu.OptionFlags = MENUFLAG_BUTTON_EXIT;
	topMenu.Display(client, MENU_TIME_FOREVER);
	CloseHandle(stringArray);
}

public void sql_selectTopSurfersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectTopSurfersCallback): %s", g_szChatPrefix, error);
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
	if (StrEqual(szMap, g_szMapName))
		menu = CreateMenu(MapMenuHandler1);
	else
		menu = CreateMenu(MapTopMenuHandler2);
	SetMenuPagination(menu, 5);
	bool bduplicat = false;
	char title[256];
	if (SQL_HasResultSet(hndl))
	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			bduplicat = false;
			SQL_FetchString(hndl, 0, szSteamID, 32);
			SQL_FetchString(hndl, 1, szName, 64);
			time = SQL_FetchFloat(hndl, 2);
			SQL_FetchString(hndl, 4, szMap, 128);
			if (i == 1 || (i > 1 && StrEqual(szFirstMap, szMap)))
			{
				int stringArraySize = GetArraySize(stringArray);
				for (int x = 0; x < stringArraySize; x++)
				{
					GetArrayString(stringArray, x, lineBuf, sizeof(lineBuf));
					if (StrEqual(lineBuf, szName, false))
						bduplicat = true;
				}
				if (bduplicat == false && i < 51)
				{
					char szTime[32];
					FormatTimeFloat(client, time, 3, szTime, sizeof(szTime));
					if (time < 3600.0)
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
						Format(szFirstMap, 128, "%s", szMap);
					i++;
				}
			}
		}
		if (i == 1)
		{
			PrintToChat(client, "%t", "NoTopRecords", MOSSGREEN, g_szChatPrefix, WHITE, szMap);
		}
	}
	else
		PrintToChat(client, "%t", "NoTopRecords", MOSSGREEN, g_szChatPrefix, WHITE, szMap);
	Format(title, 256, "Top 50 Times on %s \n    Rank    Time               Player", szFirstMap);
	SetMenuTitle(menu, title);
	SetMenuOptionFlags(menu, MENUFLAG_BUTTON_EXIT);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
	CloseHandle(stringArray);
}

public void db_selectProSurfers(int client)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_selectProSurfers, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectProSurfersCallback, szQuery, client, DBPrio_Low);
}

public void db_currentRunRank(int client)
{
	if (!IsValidClient(client))
		return;

	char szQuery[512];
	Format(szQuery, 512, "SELECT count(runtimepro)+1 FROM `ck_playertimes` WHERE `mapname` = '%s' AND `runtimepro` < %f;", g_szMapName, g_fFinalTime[client]);
	SQL_TQuery(g_hDb, SQL_CurrentRunRankCallback, szQuery, client, DBPrio_Low);
}

public void SQL_CurrentRunRankCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_CurrentRunRankCallback): %s", g_szChatPrefix, error);
		return;
	}
	// Get players rank, 9999999 = error
	int rank;
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		rank = SQL_FetchInt(hndl, 0);
	}

	MapFinishedMsgs(client, rank);
}

//
// Get clients record from database
// Called when a player finishes a map
//
public void db_selectRecord(int client)
{
	if (!IsValidClient(client))
		return;

	char szQuery[255];
	Format(szQuery, 255, "SELECT runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname = '%s' AND runtimepro > -1.0", g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, sql_selectRecordCallback, szQuery, client, DBPrio_Low);
}

public void sql_selectRecordCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectRecordCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (!IsValidClient(client))
		return;

	char szQuery[512];

	// Found old time from database
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		float time = SQL_FetchFloat(hndl, 0);

		// If old time was slower than the new time, update record
		if ((g_fFinalTime[client] <= time || time <= 0.1))
		{
			db_updateRecordPro(client);
		}
	}
	else
	{  // No record found from database - Let's insert

		// Escape name for SQL injection protection
		char szName[MAX_NAME_LENGTH * 2 + 1], szUName[MAX_NAME_LENGTH];
		GetClientName(client, szUName, MAX_NAME_LENGTH);
		SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH);

		// Move required information in datapack
		Handle pack = CreateDataPack();
		WritePackFloat(pack, g_fFinalTime[client]);
		WritePackCell(pack, client);

		//"INSERT INTO ck_playertimes (steamid, mapname, name,runtimepro) VALUES('%s', '%s', '%s', '%f');";
		Format(szQuery, 512, sql_insertPlayerTime, g_szSteamID[client], g_szMapName, szName, g_fFinalTime[client]);
		SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback, szQuery, pack, DBPrio_Low);
	}
}

//
// If latest record was faster than old - Update time
//
public void db_updateRecordPro(int client)
{
	char szUName[MAX_NAME_LENGTH];

	if (!IsValidClient(client))
		return;
	GetClientName(client, szUName, MAX_NAME_LENGTH);

	// Also updating name in database, escape string
	char szName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH * 2 + 1);

	// Packing required information for later
	Handle pack = CreateDataPack();
	WritePackFloat(pack, g_fFinalTime[client]);
	WritePackCell(pack, client);

	char szQuery[1024];
	//"UPDATE ck_playertimes SET name = '%s', runtimepro = '%f' WHERE steamid = '%s' AND mapname = '%s';"; 
	Format(szQuery, 1024, sql_updateRecordPro, szName, g_fFinalTime[client], g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback, szQuery, pack, DBPrio_Low);
}

public void SQL_UpdateRecordProCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_UpdateRecordProCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (data != INVALID_HANDLE)
	{
		ResetPack(data);
		float time = ReadPackFloat(data);
		int client = ReadPackCell(data);
		CloseHandle(data);

		// Find out how many times are are faster than the players time
		char szQuery[512];
		Format(szQuery, 512, "SELECT count(runtimepro) FROM `ck_playertimes` WHERE `mapname` = '%s' AND `runtimepro` < %f;", g_szMapName, time);
		SQL_TQuery(g_hDb, SQL_UpdateRecordProCallback2, szQuery, client, DBPrio_Low);

	}
}

public void SQL_UpdateRecordProCallback2(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_UpdateRecordProCallback2): %s", g_szChatPrefix, error);
		return;
	}
	// Get players rank, 9999999 = error
	int rank = 9999999;
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		rank = (SQL_FetchInt(hndl, 0)+1);
	}
	g_MapRank[data] = rank;
	MapFinishedMsgs(data);
}

public void db_viewRecord(int client, char szSteamId[32], char szMapName[128])
{
	char szQuery[512];
	// SELECT runtimepro, name FROM ck_playertimes WHERE mapname = '%s' AND steamid = '%s' AND runtimepro > 0.0
	Handle pack = CreateDataPack();
	WritePackString(pack, szMapName);
	WritePackString(pack, szSteamId);
	WritePackCell(pack, client);

	Format(szQuery, 512, sql_selectPersonalRecords, szSteamId, szMapName);
	SQL_TQuery(g_hDb, SQL_ViewRecordCallback, szQuery, pack, DBPrio_Low);
}

public void SQL_ViewRecordCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRecordCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szSteamId[32];
	char szMapName[128];

	ResetPack(pack);
	ReadPackString(pack, szMapName, 128);
	ReadPackString(pack, szSteamId, 32);
	int client = ReadPackCell(pack);

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{

		char szName[MAX_NAME_LENGTH];

		SQL_FetchString(hndl, 1, szName, MAX_NAME_LENGTH);
		float runtime = SQL_FetchFloat(hndl, 0);

		Handle pack1 = CreateDataPack();
		WritePackString(pack1, szMapName);
		WritePackString(pack1, szSteamId);
		WritePackString(pack1, szName);
		WritePackCell(pack1, client);
		WritePackFloat(pack1, runtime);

		char szQuery[512];
		Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback2, szQuery, pack1, DBPrio_Low);
	}
	else
	{
		Panel panel = new Panel();
		panel.DrawText("Current map time");
		panel.DrawText(" ");
		panel.DrawText("No record found on this map.");
		panel.DrawItem("exit");
		panel.Send(client, MenuHandler2, 300);
		delete panel;
	}
}

public void SQL_ViewRecordCallback2(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRecordCallback2): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
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
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback3, szQuery, data, DBPrio_Low);
	}
}

public void SQL_ViewRecordCallback3(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRecordCallback3): %s", g_szChatPrefix, error);
		return;
	}

	//if there is a player record
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		int count1 = SQL_GetRowCount(hndl);
		char szMapName[128];
		char szSteamId[32];
		char szName[MAX_NAME_LENGTH];
		float runtime = ReadPackFloat(data);

		ResetPack(data);
		ReadPackString(data, szMapName, 128);
		ReadPackString(data, szSteamId, 32);
		ReadPackString(data, szName, MAX_NAME_LENGTH);
		int client = ReadPackCell(data);
		int rank = ReadPackCell(data);

		if (runtime != -1.0)
		{
			Panel panel = new Panel();
			char szVrItem[256];
			Format(szVrItem, 256, "Map time of %s", szName);
			panel.DrawText(szVrItem);
			panel.DrawText(" ");

			FormatTimeFloat(client, runtime, 3, szVrItem, sizeof(szVrItem));
			Format(szVrItem, 256, "Time: %s", szVrItem);
			panel.DrawText(szVrItem);

			panel.DrawText("Map time:");
			Format(szVrItem, 256, "Rank: %i of %i", rank, count1);
			panel.DrawText(szVrItem);
			panel.DrawText(" ");

			panel.DrawItem("Exit");
			CloseHandle(data);
			panel.Send(client, RecordPanelHandler, 300);
			CloseHandle(panel);
		}
		else
			if (runtime != 0.000000)
		{
			WritePackCell(data, count1);
			char szQuery[512];
			Format(szQuery, 512, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
			SQL_TQuery(g_hDb, SQL_ViewRecordCallback4, szQuery, data, DBPrio_Low);
		}
	}
}

public void SQL_ViewRecordCallback4(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRecordCallback4): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{

		char szQuery[512];
		int rankPro = SQL_GetRowCount(hndl);
		char szMapName[128];

		WritePackCell(data, rankPro);
		ResetPack(data);
		ReadPackString(data, szMapName, 128);

		Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewRecordCallback5, szQuery, data, DBPrio_Low);
	}
}

public void SQL_ViewRecordCallback5(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewRecordCallback5): %s", g_szChatPrefix, error);
		return;
	}

	//if there is a player record
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
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
		float runtime = ReadPackFloat(data);
		int rank = ReadPackCell(data);
		int count1 = ReadPackCell(data);
		int rankPro = ReadPackCell(data);
		if (runtime != -1.0)
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
			FormatTimeFloat(client, runtime, 3, szVrTimePro, sizeof(szVrTimePro));
			Format(szVrTimePro, 256, "Time: %s", szVrTimePro);

			Format(szVrRank, 32, "Rank: %i of %i", rank, count1);
			Format(szVrRankPro, 32, "Rank: %i of %i", rankPro, countPro);

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

public void db_viewAllRecords(int client, char szSteamId[32])
{
	//"SELECT db1.name, db2.steamid, db2.mapname, db2.runtimepro as overall, db1.steamid FROM ck_playertimes as db2 INNER JOIN ck_playerrank as db1 on db2.steamid = db1.steamid WHERE db2.steamid = '%s' AND db2.runtimepro > -1.0 ORDER BY mapname ASC;";

	char szQuery[1024];
	Format(szQuery, 1024, sql_selectPersonalAllRecords, szSteamId, szSteamId);
	if ((StrContains(szSteamId, "STEAM_") != -1))
		SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback, szQuery, client, DBPrio_Low);
	else
		if (IsClientInGame(client))
		PrintToChat(client, "[%c%s%c] Invalid SteamID found.", RED, WHITE);
	ProfileMenu(client, -1);
}

public void SQL_ViewAllRecordsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewAllRecordsCallback): %s", g_szChatPrefix, error);
		return;
	}

	int bHeader = false;
	char szUncMaps[1024];
	int mapcount = 0;
	char szName[MAX_NAME_LENGTH];
	char szSteamId[32];
	if (SQL_HasResultSet(hndl))
	{
		float time;
		char szMapName[128];
		char szMapName2[128];
		char szQuery[1024];
		Format(szUncMaps, sizeof(szUncMaps), "");
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 1, szSteamId, MAX_NAME_LENGTH);
			SQL_FetchString(hndl, 2, szMapName, 128);

			time = SQL_FetchFloat(hndl, 3);

			int mapfound = false;

			//map in rotation?
			for (int i = 0; i < GetArraySize(g_MapList); i++)
			{
				GetArrayString(g_MapList, i, szMapName2, sizeof(szMapName2));
				if (StrEqual(szMapName2, szMapName, false))
				{
					if (!bHeader)
					{
						PrintToConsole(data, " ");
						PrintToConsole(data, "-------------");
						PrintToConsole(data, "Finished Maps");
						PrintToConsole(data, "Player: %s", szName);
						PrintToConsole(data, "SteamID: %s", szSteamId);
						PrintToConsole(data, "-------------");
						PrintToConsole(data, " ");
						bHeader = true;
						PrintToChat(data, "%t", "ConsoleOutput", LIMEGREEN, g_szChatPrefix, WHITE);
					}
					Handle pack = CreateDataPack();
					WritePackString(pack, szName);
					WritePackString(pack, szSteamId);
					WritePackString(pack, szMapName);
					WritePackFloat(pack, time);
					WritePackCell(pack, data);

					Format(szQuery, 1024, sql_selectPlayerRankProTime, szSteamId, szMapName, szMapName);
					SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback2, szQuery, pack, DBPrio_Low);
					mapfound = true;
					continue;
				}
			}
			if (!mapfound)
			{
				mapcount++;
				if (!mapfound && mapcount == 1)
				{
					Format(szUncMaps, sizeof(szUncMaps), "%s", szMapName);
				}
				else
				{
					if (!mapfound && mapcount > 1)
					{
						Format(szUncMaps, sizeof(szUncMaps), "%s, %s", szUncMaps, szMapName);
					}
				}
			}
		}
	}
	if (!StrEqual(szUncMaps, ""))
	{
		if (!bHeader)
		{
			PrintToChat(data, "%t", "ConsoleOutput", LIMEGREEN, g_szChatPrefix, WHITE);
			PrintToConsole(data, " ");
			PrintToConsole(data, "-------------");
			PrintToConsole(data, "Finished Maps");
			PrintToConsole(data, "Player: %s", szName);
			PrintToConsole(data, "SteamID: %s", szSteamId);
			PrintToConsole(data, "-------------");
			PrintToConsole(data, " ");
		}
		PrintToConsole(data, "Times on maps which are not in the mapcycle.txt (Records still count but you don't get points): %s", szUncMaps);
	}
	if (!bHeader && StrEqual(szUncMaps, ""))
	{
		ProfileMenu(data, -1);
		PrintToChat(data, "%t", "PlayerHasNoMapRecords", LIMEGREEN, g_szChatPrefix, WHITE, g_szProfileName[data]);
	}
}

public void SQL_ViewAllRecordsCallback2(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewAllRecordsCallback2): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		char szQuery[512];
		char szName[MAX_NAME_LENGTH];
		char szSteamId[32];
		char szMapName[128];

		int rank = SQL_GetRowCount(hndl);
		WritePackCell(data, rank);
		ResetPack(data);
		ReadPackString(data, szName, MAX_NAME_LENGTH);
		ReadPackString(data, szSteamId, 32);
		ReadPackString(data, szMapName, 128);

		Format(szQuery, 512, sql_selectPlayerProCount, szMapName);
		SQL_TQuery(g_hDb, SQL_ViewAllRecordsCallback3, szQuery, data, DBPrio_Low);
	}
}

public void SQL_ViewAllRecordsCallback3(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewAllRecordsCallback3): %s", g_szChatPrefix, error);
		return;
	}

	//if there is a player record
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		int count = SQL_GetRowCount(hndl);
		char szTime[32];
		char szMapName[128];
		char szSteamId[32];
		char szName[MAX_NAME_LENGTH];

		ResetPack(data);
		ReadPackString(data, szName, MAX_NAME_LENGTH);
		ReadPackString(data, szSteamId, 32);
		ReadPackString(data, szMapName, 128);
		float time = ReadPackFloat(data);
		int client = ReadPackCell(data);
		int rank = ReadPackCell(data);
		CloseHandle(data);

		FormatTimeFloat(client, time, 3, szTime, sizeof(szTime));
		if (IsValidClient(client))
			PrintToConsole(client, "%s, Time: %s, Rank: %i/%i", szMapName, szTime, rank, count);
	}
}

public void db_selectPlayer(int client)
{
	char szQuery[255];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 255, sql_selectPlayer, g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, SQL_SelectPlayerCallback, szQuery, client, DBPrio_Low);
}

public void SQL_SelectPlayerCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_SelectPlayerCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (!SQL_HasResultSet(hndl) && !SQL_FetchRow(hndl) && !IsValidClient(data))
		db_insertPlayer(data);
}

public void db_insertPlayer(int client)
{
	char szQuery[255];
	char szUName[MAX_NAME_LENGTH];
	if (IsValidClient(client))
	{
		GetClientName(client, szUName, MAX_NAME_LENGTH);
	}
	else
		return;
	char szName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH * 2 + 1);
	Format(szQuery, 255, sql_insertPlayer, g_szSteamID[client], g_szMapName, szName);
	SQL_TQuery(g_hDb, SQL_InsertPlayerCallBack, szQuery, client, DBPrio_Low);
}

//
// Getting player settings starts here
//
public void db_viewPersonalRecords(int client, char szSteamId[32], char szMapName[128])
{
	char szQuery[1024];
	Format(szQuery, 1024, "SELECT runtimepro FROM ck_playertimes WHERE steamid = '%s' AND mapname ='%s' AND runtimepro > 0.0;", szSteamId, szMapName);
	SQL_TQuery(g_hDb, SQL_selectPersonalRecordsCallback, szQuery, client, DBPrio_Low);
}

public void SQL_selectPersonalRecordsCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectPersonalRecordsCallback): %s", g_szChatPrefix, error);
		if (!g_bSettingsLoaded[client])
			db_viewPersonalBonusRecords(client, g_szSteamID[client]);
		return;
	}

	g_fPersonalRecord[client] = 0.0;
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_fPersonalRecord[client] = SQL_FetchFloat(hndl, 0);

		if (g_fPersonalRecord[client] > 0.0)
		{
			FormatTimeFloat(client, g_fPersonalRecord[client], 3, g_szPersonalRecord[client], 64);
			// Time found, get rank in current map
			db_viewMapRankPro(client);
			return;
		}
		else
		{
			Format(g_szPersonalRecord[client], 64, "NONE");
			g_fPersonalRecord[client] = 0.0;
		}
	}
	if (!g_bSettingsLoaded[client])
		db_viewPersonalBonusRecords(client, g_szSteamID[client]);
	return;
}

///////////////////////
//// PLAYER TEMP //////
///////////////////////

public void db_deleteTmp(int client)
{
	char szQuery[256];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 256, sql_deletePlayerTmp, g_szSteamID[client]);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client, DBPrio_Low);
}

public void db_selectLastRun(int client)
{
	char szQuery[512];
	if (!IsValidClient(client))
		return;
	Format(szQuery, 512, sql_selectPlayerTmp, g_szSteamID[client], g_szMapName);
	SQL_TQuery(g_hDb, SQL_LastRunCallback, szQuery, client, DBPrio_Low);
}

public void SQL_LastRunCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_LastRunCallback): %s", g_szChatPrefix, error);
		return;
	}

	g_bTimeractivated[data] = false;
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl) && IsValidClient(data))
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
		float fl_time = SQL_FetchFloat(hndl, 6);
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
					TeleportEntity(data, g_fPlayerCordsRestore[data], g_fPlayerAnglesRestore[data], NULL_VECTOR);
					g_bRestorePosition[data] = false;
				}
				else
				{
					g_bRestorePosition[data] = true;
					g_bRestorePositionMsg[data] = true;
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

public void db_viewRecordCheckpointInMap()
{
	debug_msg(" Started db_viewRecordCheckpointInMap ");
	for (int k = 0; k < MAXZONEGROUPS; k++)
	{
		g_bCheckpointRecordFound[k] = false;
		for (int i = 0; i < CPLIMIT; i++)
			g_fCheckpointServerRecord[k][i] = 0.0;
	}

	//"SELECT c.zonegroup, c.cp1, c.cp2, c.cp3, c.cp4, c.cp5, c.cp6, c.cp7, c.cp8, c.cp9, c.cp10, c.cp11, c.cp12, c.cp13, c.cp14, c.cp15, c.cp16, c.cp17, c.cp18, c.cp19, c.cp20, c.cp21, c.cp22, c.cp23, c.cp24, c.cp25, c.cp26, c.cp27, c.cp28, c.cp29, c.cp30, c.cp31, c.cp32, c.cp33, c.cp34, c.cp35 FROM ck_checkpoints c WHERE steamid = '%s' AND mapname='%s' UNION SELECT a.zonegroup, b.cp1, b.cp2, b.cp3, b.cp4, b.cp5, b.cp6, b.cp7, b.cp8, b.cp9, b.cp10, b.cp11, b.cp12, b.cp13, b.cp14, b.cp15, b.cp16, b.cp17, b.cp18, b.cp19, b.cp20, b.cp21, b.cp22, b.cp23, b.cp24, b.cp25, b.cp26, b.cp27, b.cp28, b.cp29, b.cp30, b.cp31, b.cp32, b.cp33, b.cp34, b.cp35 FROM ck_bonus a LEFT JOIN ck_checkpoints b ON a.steamid = b.steamid AND a.zonegroup = b.zonegroup WHERE a.mapname = '%s' GROUP BY a.zonegroup";
	char szQuery[1028];
	Format(szQuery, 1028, sql_selectRecordCheckpoints, g_szRecordMapSteamID, g_szMapName, g_szMapName);
	SQL_TQuery(g_hDb, sql_selectRecordCheckpointsCallback, szQuery, 1, DBPrio_Low);
}

public void sql_selectRecordCheckpointsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectRecordCheckpointsCallback): %s", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_CalcAvgRunTime();
		return;
	}

	if (SQL_HasResultSet(hndl))
	{
		int zonegroup;
		while (SQL_FetchRow(hndl))
		{
			zonegroup = SQL_FetchInt(hndl, 0);
			for (int i = 0; i < CPLIMIT; i++) 
			{
				g_fCheckpointServerRecord[zonegroup][i] = SQL_FetchFloat(hndl, (i + 1));
				if (!g_bCheckpointRecordFound[zonegroup] && g_fCheckpointServerRecord[zonegroup][i] > 0.0)
					g_bCheckpointRecordFound[zonegroup] = true;
			}
		}
	}
	debug_msg(" Ended sql_selectRecordCheckpointsCallback ");
	if (!g_bServerDataLoaded)
		db_CalcAvgRunTime();

	return;
}

public void db_viewCheckpoints(int client, char szSteamID[32], char szMapName[128])
{
	char szQuery[1024];
	//"SELECT zonegroup, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20, cp21, cp22, cp23, cp24, cp25, cp26, cp27, cp28, cp29, cp30, cp31, cp32, cp33, cp34, cp35 FROM ck_checkpoints WHERE mapname='%s' AND steamid = '%s';";
	Format(szQuery, 1024, sql_selectCheckpoints, szMapName, szSteamID);
	SQL_TQuery(g_hDb, SQL_selectCheckpointsCallback, szQuery, client, DBPrio_Low);
}

public void SQL_selectCheckpointsCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectCheckpointsCallback): %s", g_szChatPrefix, error);
		return;
	}

	int zoneGrp;

	if (!IsValidClient(client))
		return;

	if (SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			zoneGrp = SQL_FetchInt(hndl, 0);
			g_bCheckpointsFound[zoneGrp][client] = true;
			int k = 1;
			for (int i = 0; i < CPLIMIT; i++)
			{
				g_fCheckpointTimesRecord[zoneGrp][client][i] = SQL_FetchFloat(hndl, k);
				k++;
			}
		}
	}

	if (!g_bSettingsLoaded[client])
	{
		g_bSettingsLoaded[client] = true;
		g_bLoadingSettings[client] = false;
		if (GetConVarBool(g_hTeleToStartWhenSettingsLoaded))
		{
			Command_Restart(client, 1);	
			PrintToChat(client, "[%c%s%c] Your settings have been loaded. You may now begin your run.", MOSSGREEN, g_szChatPrefix, WHITE);

			ClientCommand(client, "play buttons\\weapon_confirm.wav");
			
		}
		char buffer[412];
		Format(buffer, 412, "Finished Loading: %N on map: %s", client, g_szMapName);
		debug_msg(buffer);	
		// Seach for next client to load
		for (int i = 1; i < MAXPLAYERS + 1; i++)
		{
			if (IsValidClient(i) && !IsFakeClient(i) && !g_bSettingsLoaded[i] && !g_bLoadingSettings[i])
			{
				Format(buffer, 412, "Started Loading: %N on map: %s", i, g_szMapName);
				debug_msg(buffer);	
				char szSteamID[32];
				GetClientAuthId(i, AuthId_Steam2, szSteamID, 32, true);
				db_viewPersonalRecords(i, szSteamID, g_szMapName);
				g_bLoadingSettings[i] = true;
				break;
			}
		}
	}		
}

public void db_viewCheckpointsinZoneGroup(int client, char szSteamID[32], char szMapName[128], int zonegroup)
{
	char szQuery[1024];
	//"SELECT cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20, cp21, cp22, cp23, cp24, cp25, cp26, cp27, cp28, cp29, cp30, cp31, cp32, cp33, cp34, cp35 FROM ck_checkpoints WHERE mapname='%s' AND steamid = '%s' AND zonegroup = %i;";
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, zonegroup);

	Format(szQuery, 1024, sql_selectCheckpointsinZoneGroup, szMapName, szSteamID, zonegroup);
	SQL_TQuery(g_hDb, db_viewCheckpointsinZoneGroupCallback, szQuery, pack, DBPrio_Low);
}

public void db_viewCheckpointsinZoneGroupCallback(Handle owner, Handle hndl, const char[] error, any pack)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectCheckpointsCallback): %s", g_szChatPrefix, error);
		return;
	}

	ResetPack(pack);
	int client = ReadPackCell(pack);
	int zonegrp = ReadPackCell(pack);
	CloseHandle(pack);

	if (!IsValidClient(client))
		return;

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bCheckpointsFound[zonegrp][client] = true;
		for (int i = 0; i < CPLIMIT; i++)
		{
			g_fCheckpointTimesRecord[zonegrp][client][i] = SQL_FetchFloat(hndl, i);
		}
	}
	else
	{
		g_bCheckpointsFound[zonegrp][client] = false;
	}
}

public void db_UpdateCheckpoints(int client, char szSteamID[32], int zGroup)
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

public void SQL_updateCheckpointsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_updateCheckpointsCallback): %s", g_szChatPrefix, error);
		return;
	}
	ResetPack(data);
	int client = ReadPackCell(data);
	int zonegrp = ReadPackCell(data);
	CloseHandle(data);

	db_viewCheckpointsinZoneGroup(client, g_szSteamID[client], g_szMapName, zonegrp);
}

public void db_deleteCheckpoints()
{
	char szQuery[258];
	Format(szQuery, 258, sql_deleteCheckpoints, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteCheckpointsCallback, szQuery, 1, DBPrio_Low);
}

public void SQL_deleteCheckpointsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_deleteCheckpointsCallback): %s", g_szChatPrefix, error);
		return;
	}
}

//////////////////////
//// MapTier /////////
//////////////////////

public void db_insertMapTier(int tier, int zGrp)
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

public void db_insertMapTierCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_insertMapTierCallback): %s", g_szChatPrefix, error);
		return;
	}

	db_selectMapTier();
}

public void db_selectMapTier()
{
	debug_msg(" Started db_selectMapTier ");
	g_bTierEntryFound = false;

	char szQuery[1024];
	Format(szQuery, 1024, sql_selectMapTier, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectMapTierCallback, szQuery, 1, DBPrio_Low);
}

public void SQL_selectMapTierCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectMapTierCallback): %s", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_viewRecordCheckpointInMap();
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_bTierEntryFound = true;
		int tier;

		// Format tier string for all
		for (int i = 0; i < 11; i++)
		{
			tier = SQL_FetchInt(hndl, i);
			if (0 < tier < 8)
			{
				g_bTierFound[i] = true;
				if (i == 0)
				{
					Format(g_sTierString[0], 512, " [%c%s%c] %cMap: %c%s %c| ", MOSSGREEN, g_szChatPrefix, WHITE, GREEN, LIMEGREEN, g_szMapName, GREEN);
					switch (tier)
					{
						case 1:Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], GRAY, tier, GREEN);
						case 2:Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], LIGHTBLUE, tier, GREEN);
						case 3:Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], BLUE, tier, GREEN);
						case 4:Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], DARKBLUE, tier, GREEN);
						case 5:Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], RED, tier, GREEN);
						case 6:Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], DARKRED, tier, GREEN);
						case 7:Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], DARKRED, tier, GREEN);
						default:Format(g_sTierString[0], 512, "%s%cTier %i %c| ", g_sTierString[0], GRAY, tier, GREEN);
					}
					switch (tier)
					{
						case 1:Format(g_sJustTier, 64, "<font color='#75d31b'>Tier: %i</font>", tier);
						case 2:Format(g_sJustTier, 64, "<font color='#6ed8c8'>Tier: %i</font>", tier);
						case 3:Format(g_sJustTier, 64, "<font color='#1364dd'>Tier: %i</font>", tier);
						case 4:Format(g_sJustTier, 64, "<font color='#410dbc'>Tier: %i</font>", tier);
						case 5:Format(g_sJustTier, 64, "<font color='#efe347'>Tier: %i</font>", tier);
						case 6:Format(g_sJustTier, 64, "<font color='#f75a3b'>Tier: %i</font>", tier);
						case 7:Format(g_sJustTier, 64, "<font color='#ff2a00'>Tier: %i</font>", tier);
						
						
						default:Format(g_sJustTier, 64, "<font color='#70a83b'>Tier: %i</font>", tier);
					}
					if (g_bhasStages)
						Format(g_sTierString[0], 512, "%s%c%i Stages", g_sTierString[0], MOSSGREEN, (g_mapZonesTypeCount[0][3] + 1));
					else
						Format(g_sTierString[0], 512, "%s%cLinear", g_sTierString[0], LIMEGREEN);

					if (g_bhasBonus)
						if (g_mapZoneGroupCount > 2)
							Format(g_sTierString[0], 512, "%s %c|%c %i Bonuses", g_sTierString[0], GREEN, YELLOW, (g_mapZoneGroupCount - 1));
						else
							Format(g_sTierString[0], 512, "%s %c|%c Bonus", g_sTierString[0], GREEN, YELLOW, (g_mapZoneGroupCount - 1));
				}
				else
				{
					switch (tier)
					{
						case 1:Format(g_sTierString[i], 512, "[%c%s%c] &c%s Tier: %i", MOSSGREEN, g_szChatPrefix, WHITE, GRAY, g_szZoneGroupName[i], tier);
						case 2:Format(g_sTierString[i], 512, "[%c%s%c] &c%s Tier: %i", MOSSGREEN, g_szChatPrefix, WHITE, LIGHTBLUE, g_szZoneGroupName[i], tier);
						case 3:Format(g_sTierString[i], 512, "[%c%s%c] &c%s Tier: %i", MOSSGREEN, g_szChatPrefix, WHITE, BLUE, g_szZoneGroupName[i], tier);
						case 4:Format(g_sTierString[i], 512, "[%c%s%c] &c%s Tier: %i", MOSSGREEN, g_szChatPrefix, WHITE, DARKBLUE, g_szZoneGroupName[i], tier);
						case 5:Format(g_sTierString[i], 512, "[%c%s%c] &c%s Tier: %i", MOSSGREEN, g_szChatPrefix, WHITE, RED, g_szZoneGroupName[i], tier);
						case 6:Format(g_sTierString[i], 512, "[%c%s%c] &c%s Tier: %i", MOSSGREEN, g_szChatPrefix, WHITE, DARKRED, g_szZoneGroupName[i], tier);
						case 7:Format(g_sTierString[i], 512, "[%c%s%c] &c%s Tier: %i", MOSSGREEN, g_szChatPrefix, WHITE, DARKRED, g_szZoneGroupName[i], tier);
					}
				}
			}
		}
	}
	else
		g_bTierEntryFound = false;
	debug_msg(" Ended SQL_selectMapTierCallback ");
	if (!g_bServerDataLoaded)
		db_viewRecordCheckpointInMap();

	return;
}

public void db_deleteAllMaptiers(int client)
{
	char szQuery[128];
	Format(szQuery, 128, sql_deleteAllMapTiers);
	SQL_TQuery(g_hDb, SQL_deleteAllMapTiersCallback, szQuery, client, DBPrio_Low);
}

public void SQL_deleteAllMapTiersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_deleteAllMapTiersCallback): %s", g_szChatPrefix, error);
		return;
	}

	Admin_InsertMapTierstoDatabase(data);
}

/////////////////////
//// SQL Bonus //////
/////////////////////

public void db_currentBonusRunRank(int client, int zGroup)
{
	char szQuery[512];
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, zGroup);
	Format(szQuery, 512, "SELECT count(runtime)+1 FROM ck_bonus WHERE mapname = '%s' AND zonegroup = '%i' AND runtime < %f", g_szMapName, zGroup, g_fFinalTime[client]);
	SQL_TQuery(g_hDb, db_viewBonusRunRank, szQuery, pack, DBPrio_Low);
}

public void db_viewBonusRunRank(Handle owner, Handle hndl, const char[] error, any pack)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_viewBonusRunRank): %s", g_szChatPrefix, error);
		return;
	}

	ResetPack(pack);
	int client = ReadPackCell(pack);
	int zGroup = ReadPackCell(pack);
	CloseHandle(pack);
	int rank;
	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		rank = SQL_FetchInt(hndl, 0);
	}

	PrintChatBonus(client, zGroup, rank);
}

public void db_viewMapRankBonus(int client, int zgroup, int type)
{
	char szQuery[1024];
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, zgroup);
	WritePackCell(pack, type);

	Format(szQuery, 1024, sql_selectPlayerRankBonus, g_szSteamID[client], g_szMapName, zgroup, g_szMapName, zgroup);
	SQL_TQuery(g_hDb, db_viewMapRankBonusCallback, szQuery, pack, DBPrio_Low);
}

public void db_viewMapRankBonusCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_viewMapRankBonusCallback): %s", g_szChatPrefix, error);
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

	switch (type)
	{
		case 1: {
			g_iBonusCount[zgroup]++;
			PrintChatBonus(client, zgroup);
		}
		case 2: {
			PrintChatBonus(client, zgroup);
		}
	}
}

//
// Get player rank in bonus - current map
//
public void db_viewPersonalBonusRecords(int client, char szSteamId[32])
{
	char szQuery[1024];
	//"SELECT runtime, zonegroup FROM ck_bonus WHERE steamid = '%s' AND mapname = '%s' AND runtime > '0.0'"; 
	Format(szQuery, 1024, sql_selectPersonalBonusRecords, szSteamId, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectPersonalBonusRecordsCallback, szQuery, client, DBPrio_Low);
}

public void SQL_selectPersonalBonusRecordsCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectPersonalBonusRecordsCallback): %s", g_szChatPrefix, error);
		if (!g_bSettingsLoaded[client])
			db_viewPlayerPoints(client);
		return;
	}

	int zgroup;

	for (int i = 0; i < MAXZONEGROUPS; i++)
	{
		g_fPersonalRecordBonus[i][client] = 0.0;
		Format(g_szPersonalRecordBonus[i][client], 64, "N/A");
	}

	if (SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			zgroup = SQL_FetchInt(hndl, 1);
			g_fPersonalRecordBonus[zgroup][client] = SQL_FetchFloat(hndl, 0);

			if (g_fPersonalRecordBonus[zgroup][client] > 0.0)
			{
				FormatTimeFloat(client, g_fPersonalRecordBonus[zgroup][client], 3, g_szPersonalRecordBonus[zgroup][client], 64);
				db_viewMapRankBonus(client, zgroup, 0); // get rank
			}
			else
			{
				Format(g_szPersonalRecordBonus[zgroup][client], 64, "N/A");
				g_fPersonalRecordBonus[zgroup][client] = 0.0;
			}
		}
	}
	if (!g_bSettingsLoaded[client])
		db_viewPlayerPoints(client);
	return;
}

public void db_viewFastestBonus()
{
	debug_msg(" Started db_viewFastestBonus ");
	char szQuery[1024];
	//SELECT name, MIN(runtime), zonegroup FROM ck_bonus WHERE mapname = '%s' GROUP BY zonegroup;
	Format(szQuery, 1024, sql_selectFastestBonus, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectFastestBonusCallback, szQuery, 1, DBPrio_High);
}

public void SQL_selectFastestBonusCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectFastestBonusCallback): %s", g_szChatPrefix, error);

		if (!g_bServerDataLoaded)
			db_viewBonusTotalCount();
		return;
	}

	for (int i = 0; i < MAXZONEGROUPS; i++)
	{
		Format(g_szBonusFastestTime[i], 64, "N/A");
		g_fBonusFastest[i] = 9999999.0;
	}

	if (SQL_HasResultSet(hndl))
	{
		int zonegroup;
		while (SQL_FetchRow(hndl))
		{
			zonegroup = SQL_FetchInt(hndl, 2);
			SQL_FetchString(hndl, 0, g_szBonusFastest[zonegroup], MAX_NAME_LENGTH);
			g_fBonusFastest[zonegroup] = SQL_FetchFloat(hndl, 1);

			FormatTimeFloat(1, g_fBonusFastest[zonegroup], 3, g_szBonusFastestTime[zonegroup], 64);
		}
	}

	for (int i = 0; i < MAXZONEGROUPS; i++)
	{
		if (g_fBonusFastest[i] == 0.0)
			g_fBonusFastest[i] = 9999999.0;
	}
	debug_msg(" Ended SQL_selectFastestBonusCallback ");
	if (!g_bServerDataLoaded)
		db_viewBonusTotalCount();

	return;
}

public void db_deleteBonus()
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_deleteBonus, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteBonusCallback, szQuery, 1, DBPrio_Low);
}
public void db_viewBonusTotalCount()
{
	debug_msg(" Started db_viewBonusTotalCount ");
	char szQuery[1024];
	//"SELECT zonegroup, count(1) FROM ck_bonus WHERE mapname = '%s' GROUP BY zonegroup";
	Format(szQuery, 1024, sql_selectBonusCount, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectBonusTotalCountCallback, szQuery, 1, DBPrio_Low);
}

public void SQL_selectBonusTotalCountCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectBonusTotalCountCallback): %s", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_selectMapTier();
		return;
	}

	for (int i = 1; i < MAXZONEGROUPS; i++)
		g_iBonusCount[i] = 0;

	if (SQL_HasResultSet(hndl))
	{
		int zonegroup;
		while (SQL_FetchRow(hndl))
		{
			zonegroup = SQL_FetchInt(hndl, 0);
			g_iBonusCount[zonegroup] = SQL_FetchInt(hndl, 1);
		}
	}
	debug_msg(" Ended SQL_selectBonusTotalCountCallback ");
	if (!g_bServerDataLoaded)
		db_selectMapTier();

	return;
}

public void db_insertBonus(int client, char szSteamId[32], char szUName[32], float FinalTime, int zoneGrp)
{
	char szQuery[1024];
	char szName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH * 2 + 1);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, zoneGrp);
	Format(szQuery, 1024, sql_insertBonus, szSteamId, szName, g_szMapName, FinalTime, zoneGrp);
	SQL_TQuery(g_hDb, SQL_insertBonusCallback, szQuery, pack, DBPrio_Low);
}

public void SQL_insertBonusCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_insertBonusCallback): %s", g_szChatPrefix, error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int zgroup = ReadPackCell(data);
	CloseHandle(data);

	db_viewMapRankBonus(client, zgroup, 1);
	// Change to update profile timer, if giving multiplier count or extra points for bonuses
	CalculatePlayerRank(client);
}

public void db_updateBonus(int client, char szSteamId[32], char szUName[32], float FinalTime, int zoneGrp)
{
	char szQuery[1024];
	char szName[MAX_NAME_LENGTH * 2 + 1];
	Handle datapack = CreateDataPack();
	WritePackCell(datapack, client);
	WritePackCell(datapack, zoneGrp);
	SQL_EscapeString(g_hDb, szUName, szName, MAX_NAME_LENGTH * 2 + 1);
	Format(szQuery, 1024, sql_updateBonus, FinalTime, szName, szSteamId, g_szMapName, zoneGrp);
	SQL_TQuery(g_hDb, SQL_updateBonusCallback, szQuery, datapack, DBPrio_Low);
}

public void SQL_updateBonusCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_updateBonusCallback): %s", g_szChatPrefix, error);
		return;
	}

	ResetPack(data);
	int client = ReadPackCell(data);
	int zgroup = ReadPackCell(data);
	CloseHandle(data);

	db_viewMapRankBonus(client, zgroup, 2);

	CalculatePlayerRank(client);
}

public void SQL_deleteBonusCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_deleteBonusCallback): %s", g_szChatPrefix, error);
		return;
	}
}

public void db_selectBonusCount()
{
	char szQuery[258];
	Format(szQuery, 258, sql_selectTotalBonusCount);
	SQL_TQuery(g_hDb, SQL_selectBonusCountCallback, szQuery, 1, DBPrio_Low);
}

public void SQL_selectBonusCountCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectBonusCountCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl))
	{
		char mapName[128];
		char mapName2[128];
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

public void db_setZoneNames(int client, char szName[128])
{
	char szQuery[512], szEscapedName[128 * 2 + 1];
	SQL_EscapeString(g_hDb, szName, szEscapedName, 128 * 2 + 1);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackCell(pack, g_CurrentSelectedZoneGroup[client]);
	WritePackString(pack, szEscapedName);
	// UPDATE ck_zones SET zonename = '%s' WHERE mapname = '%s' AND zonegroup = '%i';
	Format(szQuery, 512, sql_setZoneNames, szEscapedName, g_szMapName, g_CurrentSelectedZoneGroup[client]);
	SQL_TQuery(g_hDb, sql_setZoneNamesCallback, szQuery, pack, DBPrio_Low);
}

public void sql_setZoneNamesCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_setZoneNamesCallback): %s", g_szChatPrefix, error);
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
		PrintToChat(client, "[%c%s%c] Bonus name succesfully changed.", MOSSGREEN, g_szChatPrefix, WHITE);
		ListBonusSettings(client);
	}
	db_selectMapZones();
}

public void db_checkAndFixZoneIds()
{
	char szQuery[512];
	//"SELECT mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename FROM ck_zones WHERE mapname = '%s' ORDER BY zoneid ASC";
	if (!g_szMapName[0])
		GetCurrentMap(g_szMapName, 128);

	Format(szQuery, 512, sql_selectZoneIds, g_szMapName);
	SQL_TQuery(g_hDb, db_checkAndFixZoneIdsCallback, szQuery, 1, DBPrio_Low);
}

public void db_checkAndFixZoneIdsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_checkAndFixZoneIdsCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl))
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
			team[checker] = SQL_FetchInt(hndl, 11);
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

			for (int k = 0; k < checker; k++)
			{
				db_insertZoneCheap(k, zonetype[k], zonetypeid[k], x1[k], y1[k], z1[k], x2[k], y2[k], z2[k], vis[k], team[k], zoneGrp[k], zName[k], -10);
			}
		}
	}
	db_selectMapZones();
}

public void db_deleteAllZones(int client)
{
	char szQuery[128];
	Format(szQuery, 128, sql_deleteAllZones);
	SQL_TQuery(g_hDb, SQL_deleteAllZonesCallback, szQuery, client, DBPrio_Low);
}

public void SQL_deleteAllZonesCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_deleteAllZonesCallback): %s", g_szChatPrefix, error);
		return;
	}

	Admin_InsertZonestoDatabase(data);
}

public void ZoneDefaultName(int zonetype, int zonegroup, char zName[128])
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

public void db_insertZoneCheap(int zoneid, int zonetype, int zonetypeid, float pointax, float pointay, float pointaz, float pointbx, float pointby, float pointbz, int vis, int team, int zGrp, char zName[128], int query)
{
	char szQuery[1024];
	//"INSERT INTO ck_zones (mapname, zoneid, zonetype, zonetypeid, pointa_x, pointa_y, pointa_z, pointb_x, pointb_y, pointb_z, vis, team, zonegroup, zonename) VALUES ('%s', '%i', '%i', '%i', '%f', '%f', '%f', '%f', '%f', '%f', '%i', '%i', '%i', '%s')";
	Format(szQuery, 1024, sql_insertZones, g_szMapName, zoneid, zonetype, zonetypeid, pointax, pointay, pointaz, pointbx, pointby, pointbz, vis, team, zGrp, zName);
	SQL_TQuery(g_hDb, SQL_insertZonesCheapCallback, szQuery, query, DBPrio_Low);
}

public void SQL_insertZonesCheapCallback(Handle owner, Handle hndl, const char[] error, any query)
{
	if (hndl == null)
	{
		PrintToChatAll("[%c%s%c] Failed to create a zone, attempting a fix... Recreate the zone, please.", MOSSGREEN, g_szChatPrefix, WHITE);
		db_checkAndFixZoneIds();
		return;
	}
	if (query == (g_mapZonesCount - 1))
		db_selectMapZones();
}

public void db_insertZone(int zoneid, int zonetype, int zonetypeid, float pointax, float pointay, float pointaz, float pointbx, float pointby, float pointbz, int vis, int team, int zonegroup)
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

public void SQL_insertZonesCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{

		PrintToChatAll("[%c%s%c] Failed to create a zone, attempting a fix... Recreate the zone, please.", MOSSGREEN, g_szChatPrefix, WHITE);
		db_checkAndFixZoneIds();
		return;
	}

	db_selectMapZones();
}

public void db_saveZones()
{
	char szQuery[258];
	Format(szQuery, 258, sql_deleteMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_saveZonesCallBack, szQuery, 1, DBPrio_Low);
}

public void SQL_saveZonesCallBack(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_saveZonesCallBack): %s", g_szChatPrefix, error);
		return;
	}
	char szzone[128];
	for (int i = 0; i < g_mapZonesCount; i++)
	{
		Format(szzone, 128, "%s", g_szZoneGroupName[g_mapZones[i][zoneGroup]]);
		if (g_mapZones[i][PointA][0] != -1.0 && g_mapZones[i][PointA][1] != -1.0 && g_mapZones[i][PointA][2] != -1.0)
			db_insertZoneCheap(g_mapZones[i][zoneId], g_mapZones[i][zoneType], g_mapZones[i][zoneTypeId], g_mapZones[i][PointA][0], g_mapZones[i][PointA][1], g_mapZones[i][PointA][2], g_mapZones[i][PointB][0], g_mapZones[i][PointB][1], g_mapZones[i][PointB][2], g_mapZones[i][Vis], g_mapZones[i][Team], g_mapZones[i][zoneGroup], szzone, i);
	}
}

public void db_updateZone(int zoneid, int zonetype, int zonetypeid, float[] Point1, float[] Point2, int vis, int team, int zonegroup)
{
	char szQuery[1024];
	Format(szQuery, 1024, sql_updateZone, zonetype, zonetypeid, Point1[0], Point1[1], Point1[2], Point2[0], Point2[1], Point2[2], vis, team, zonegroup, zoneid, g_szMapName);
	SQL_TQuery(g_hDb, SQL_updateZoneCallback, szQuery, 1, DBPrio_Low);
}

public void SQL_updateZoneCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_updateZoneCallback): %s", g_szChatPrefix, error);
		return;
	}

	db_selectMapZones();
}

public int db_deleteZonesInGroup(int client)
{
	char szQuery[258];

	if (g_CurrentSelectedZoneGroup[client] < 1)
	{
		if(IsValidClient(client))
			PrintToChat(client, "[%c%s%c] Invalid zonegroup index selected, aborting. (%i)", MOSSGREEN, g_szChatPrefix, WHITE, g_CurrentSelectedZoneGroup[client]);

		PrintToServer("[%s] Invalid zonegroup index selected, aborting. (%i)", g_szChatPrefix, g_CurrentSelectedZoneGroup[client]);
	}

	Transaction h_DeleteZoneGroup = SQL_CreateTransaction();

	Format(szQuery, 258, sql_deleteZonesInGroup, g_szMapName, g_CurrentSelectedZoneGroup[client]);
	SQL_AddQuery(h_DeleteZoneGroup, szQuery);

	Format(szQuery, 258, "UPDATE ck_zones SET zonegroup = zonegroup-1 WHERE zonegroup > %i AND mapname = '%s';", g_CurrentSelectedZoneGroup[client], g_szMapName);
	SQL_AddQuery(h_DeleteZoneGroup, szQuery);

	Format(szQuery, 258, "DELETE FROM ck_bonus WHERE zonegroup = %i AND mapname = '%s';", g_CurrentSelectedZoneGroup[client], g_szMapName);
	SQL_AddQuery(h_DeleteZoneGroup, szQuery);

	Format(szQuery, 258, "UPDATE ck_bonus SET zonegroup = zonegroup-1 WHERE zonegroup > %i AND mapname = '%s';", g_CurrentSelectedZoneGroup[client], g_szMapName);
	SQL_AddQuery(h_DeleteZoneGroup, szQuery);

	SQL_ExecuteTransaction(g_hDb, h_DeleteZoneGroup, SQLTxn_ZoneGroupRemovalSuccess, SQLTxn_ZoneGroupRemovalFailed, client);

}

public void SQLTxn_ZoneGroupRemovalSuccess(Handle db, any client, int numQueries, Handle[] results, any[] queryData)
{
	PrintToServer("[%s] Zonegroup removal was successful", g_szChatPrefix);

	db_selectMapZones();
	db_viewFastestBonus();
	db_viewBonusTotalCount();
	db_viewRecordCheckpointInMap();

	if (IsValidClient(client))
	{
		ZoneMenu(client);
		PrintToChat(client, "[%c%s%c] Zone group deleted.", MOSSGREEN, g_szChatPrefix, WHITE);
	}
	return;
}

public void SQLTxn_ZoneGroupRemovalFailed(Handle db, any client, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	if(IsValidClient(client))
		PrintToChat(client, "[%c%s%c] Zonegroup removal failed! (Error: %s)", MOSSGREEN, g_szChatPrefix, WHITE, error);

	PrintToServer("[%s] Zonegroup removal failed (Error: %s)", g_szChatPrefix, error);
	return;
}

public void db_selectzoneTypeIds(int zonetype, int client, int zonegrp)
{
	char szQuery[258];
	Format(szQuery, 258, sql_selectzoneTypeIds, g_szMapName, zonetype, zonegrp);
	SQL_TQuery(g_hDb, SQL_selectzoneTypeIdsCallback, szQuery, client, DBPrio_Low);
}

public void SQL_selectzoneTypeIdsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectzoneTypeIdsCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl))
	{
		int availableids[MAXZONES] =  { 0, ... }, i;
		while (SQL_FetchRow(hndl))
		{
			i = SQL_FetchInt(hndl, 0);
			if (i < MAXZONES)
				availableids[i] = 1;
		}
		Menu TypeMenu = new Menu(Handle_EditZoneTypeId);
		char MenuNum[24], MenuInfo[6], MenuItemName[24];
		int x = 0;
		// Types: Start(1), End(2), Stage(3), Checkpoint(4), Speed(5), TeleToStart(6), Validator(7), Chekcer(8), Stop(0)
		switch (g_CurrentZoneType[data]) {
			case 0:Format(MenuItemName, 24, "Stop");
			case 1:Format(MenuItemName, 24, "Start");
			case 2:Format(MenuItemName, 24, "End");
			case 3: {
				Format(MenuItemName, 24, "Stage");
				x = 2;
			}
			case 4:Format(MenuItemName, 24, "Checkpoint");
			case 5:Format(MenuItemName, 24, "Speed");
			case 6:Format(MenuItemName, 24, "TeleToStart");
			case 7:Format(MenuItemName, 24, "Validator");
			case 8:Format(MenuItemName, 24, "Checker");
			default:Format(MenuItemName, 24, "Unknown");
		}

		for (int k = 0; k < 35; k++)
		{
			if (availableids[k] == 0)
			{
				Format(MenuNum, sizeof(MenuNum), "%s-%i", MenuItemName, (k + x));
				Format(MenuInfo, sizeof(MenuInfo), "%i", k);
				TypeMenu.AddItem(MenuInfo, MenuNum);
			}
		}
		TypeMenu.ExitButton = true;
		TypeMenu.Display(data, MENU_TIME_FOREVER);
	}
}
/*
public checkZoneTypeIds()
{
	InitZoneVariables();

	char szQuery[258];
	Format(szQuery, 258, "SELECT `zonegroup` ,`zonetype`, `zonetypeid`  FROM `ck_zones` WHERE `mapname` = '%s';", g_szMapName);
	SQL_TQuery(g_hDb, checkZoneTypeIdsCallback, szQuery, 1, DBPrio_High);
}

public checkZoneTypeIdsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[%s] SQL Error (checkZoneTypeIds): %s", g_szChatPrefix, error);
		return;
	}
	if(SQL_HasResultSet(hndl))
	{
		int idChecker[MAXZONEGROUPS][ZONEAMOUNT][MAXZONES], idCount[MAXZONEGROUPS][ZONEAMOUNT];
		char szQuery[258];
		//  Fill array with id's
		// idChecker = map zones in 
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
						PrintToServer("[%s] Error on zonetype: %i, zonetypeid: %i", g_szChatPrefix, i, idChecker[i][k]);
						Format(szQuery, 258, "UPDATE `ck_zones` SET zonetypeid = zonetypeid-1 WHERE mapname = '%s' AND zonetype = %i AND zonetypeid > %i AND zonegroup = %i;", g_szMapName, j, k, i);
						SQL_LockDatabase(g_hDb);
						SQL_FastQuery(g_hDb, szQuery);
						SQL_UnlockDatabase(g_hDb);
					}
				}
			}
		}

		Format(szQuery, 258, "SELECT `zoneid` FROM `ck_zones` WHERE mapname = '%s' ORDER BY zoneid ASC;", g_szMapName);
		SQL_TQuery(g_hDb, checkZoneIdsCallback, szQuery, 1, DBPrio_High);
	}
}

public checkZoneIdsCallback(Handle owner, Handle hndl, const char[] error, any:data)
{
	if(hndl == null)
	{
		LogError("[%s] SQL Error (checkZoneIdsCallback): %s", g_szChatPrefix, error);
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
				PrintToServer("[%s] Found an error in ZoneID's. Fixing...", g_szChatPrefix);
				Format(szQuery, 258, "UPDATE `ck_zones` SET zoneid = %i WHERE mapname = '%s' AND zoneid = %i", i, g_szMapName, SQL_FetchInt(hndl, 0));
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
		LogError("[%s] SQL Error (checkZoneGroupIds): %s", g_szChatPrefix, error);
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
				PrintToServer("[%s] Found an error in zoneGroupID's. Fixing...", g_szChatPrefix);
				Format(szQuery, 258, "UPDATE `ck_zones` SET `zonegroup` = %i WHERE `mapname` = '%s' AND `zonegroup` = %i", i, g_szMapName, SQL_FetchInt(hndl, 0));
				SQL_LockDatabase(g_hDb);
				SQL_FastQuery(g_hDb, szQuery);
				SQL_UnlockDatabase(g_hDb);
			}
		}
		db_selectMapZones();
	}
}
*/
public void db_selectMapZones()
{
	debug_msg("Started selectMapZones");
	char szQuery[258];
	Format(szQuery, 258, sql_selectMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_selectMapZonesCallback, szQuery, 1, DBPrio_High);
}

public void SQL_selectMapZonesCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_selectMapZonesCallback): %s", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_selectSpawnLocations();
		return;
	}

	RemoveZones();

	if (SQL_HasResultSet(hndl))
	{
		g_mapZonesCount = 0;
		g_bhasStages = false;
		g_bhasBonus = false;
		g_mapZoneGroupCount = 0; // 1 = No Bonus, 2 = Bonus, >2 = Multiple bonuses

		for (int i = 0; i < MAXZONES; i++) 
		{
			resetZone(i);
		}

		for (int x = 0; x < MAXZONEGROUPS; x++)
		{
			g_mapZoneCountinGroup[x] = 0;
			for (int k = 0; k < ZONEAMOUNT; k++)
				g_mapZonesTypeCount[x][k] = 0;
		}

		int zoneIdChecker[MAXZONES], zoneTypeIdChecker[MAXZONEGROUPS][ZONEAMOUNT][MAXZONES], zoneTypeIdCheckerCount[MAXZONEGROUPS][ZONEAMOUNT], zoneGroupChecker[MAXZONEGROUPS];

		// Types: Start(1), End(2), Stage(3), Checkpoint(4), Speed(5), TeleToStart(6), Validator(7), Chekcer(8), Stop(0)
		while (SQL_FetchRow(hndl))
		{
			g_mapZones[g_mapZonesCount][zoneId] = SQL_FetchInt(hndl, 0);
			g_mapZones[g_mapZonesCount][zoneType] = SQL_FetchInt(hndl, 1);
			g_mapZones[g_mapZonesCount][zoneTypeId] = SQL_FetchInt(hndl, 2);
			g_mapZones[g_mapZonesCount][PointA][0] = SQL_FetchFloat(hndl, 3);
			g_mapZones[g_mapZonesCount][PointA][1] = SQL_FetchFloat(hndl, 4);
			g_mapZones[g_mapZonesCount][PointA][2] = SQL_FetchFloat(hndl, 5);
			g_mapZones[g_mapZonesCount][PointB][0] = SQL_FetchFloat(hndl, 6);
			g_mapZones[g_mapZonesCount][PointB][1] = SQL_FetchFloat(hndl, 7);
			g_mapZones[g_mapZonesCount][PointB][2] = SQL_FetchFloat(hndl, 8);
			g_mapZones[g_mapZonesCount][Vis] = SQL_FetchInt(hndl, 9);
			g_mapZones[g_mapZonesCount][Team] = SQL_FetchInt(hndl, 10);
			g_mapZones[g_mapZonesCount][zoneGroup] = SQL_FetchInt(hndl, 11);

			/** 
			* Initialize error checking
			* 0 = zone not found
			* 1 = zone found
			*
			* IDs must be in order 0, 1, 2.... n
			* Duplicate zoneids not possible due to primary key
			*/
			zoneIdChecker[g_mapZones[g_mapZonesCount][zoneId]]++;
			if (zoneGroupChecker[g_mapZones[g_mapZonesCount][zoneGroup]] != 1)
			{
				// 1 = No Bonus, 2 = Bonus, >2 = Multiple bonuses
				g_mapZoneGroupCount++;
				zoneGroupChecker[g_mapZones[g_mapZonesCount][zoneGroup]] = 1;
			}

			// You can have the same zonetype and zonetypeid values in different zonegroups
			zoneTypeIdChecker[g_mapZones[g_mapZonesCount][zoneGroup]][g_mapZones[g_mapZonesCount][zoneType]][g_mapZones[g_mapZonesCount][zoneTypeId]]++;
			zoneTypeIdCheckerCount[g_mapZones[g_mapZonesCount][zoneGroup]][g_mapZones[g_mapZonesCount][zoneType]]++;

			SQL_FetchString(hndl, 12, g_mapZones[g_mapZonesCount][zoneName], 128);

			if (!g_mapZones[g_mapZonesCount][zoneName][0])
			{
				switch (g_mapZones[g_mapZonesCount][zoneType])
				{
					case 0: {
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Stop-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 1: {
						if (g_mapZones[g_mapZonesCount][zoneGroup] > 0)
						{
							g_bhasBonus = true;
							Format(g_mapZones[g_mapZonesCount][zoneName], 128, "BonusStart-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
							Format(g_szZoneGroupName[g_mapZones[g_mapZonesCount][zoneGroup]], 128, "BONUS %i", g_mapZones[g_mapZonesCount][zoneGroup]);
						}
						else
							Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Start-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 2: {
						if (g_mapZones[g_mapZonesCount][zoneGroup] > 0)
							Format(g_mapZones[g_mapZonesCount][zoneName], 128, "BonusEnd-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
						else
							Format(g_mapZones[g_mapZonesCount][zoneName], 128, "End-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 3: {
						g_bhasStages = true;
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Stage-%i", (g_mapZones[g_mapZonesCount][zoneTypeId] + 2));
					}
					case 4: {
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Checkpoint-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 5: {
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Speed-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 6: {
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "TeleToStart-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 7: {
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Validator-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
					case 8: {
						Format(g_mapZones[g_mapZonesCount][zoneName], 128, "Checker-%i", g_mapZones[g_mapZonesCount][zoneTypeId]);
					}
				}
			}
			else
			{
				switch (g_mapZones[g_mapZonesCount][zoneType])
				{
					case 1:
					{
						if (g_mapZones[g_mapZonesCount][zoneGroup] > 0)
							g_bhasBonus = true;
						Format(g_szZoneGroupName[g_mapZones[g_mapZonesCount][zoneGroup]], 128, "%s", g_mapZones[g_mapZonesCount][zoneName]);
					}
					case 3:
					g_bhasStages = true;

				}
			}

			/**
			*	Count zone center
			**/ 
			// Center
			float posA[3], posB[3], result[3];
			Array_Copy(g_mapZones[g_mapZonesCount][PointA], posA, 3);
			Array_Copy(g_mapZones[g_mapZonesCount][PointB], posB, 3);
			AddVectors(posA, posB, result);
			g_mapZones[g_mapZonesCount][CenterPoint][0] = FloatDiv(result[0], 2.0);
			g_mapZones[g_mapZonesCount][CenterPoint][1] = FloatDiv(result[1], 2.0);
			g_mapZones[g_mapZonesCount][CenterPoint][2] = FloatDiv(result[2], 2.0);

			for (int i = 0; i < 3; i++)
			{
				g_fZoneCorners[g_mapZonesCount][0][i] = g_mapZones[g_mapZonesCount][PointA][i];
				g_fZoneCorners[g_mapZonesCount][7][i] = g_mapZones[g_mapZonesCount][PointB][i];
			}

			// Zone counts:
			g_mapZonesTypeCount[g_mapZones[g_mapZonesCount][zoneGroup]][g_mapZones[g_mapZonesCount][zoneType]]++;
			g_mapZonesCount++;
		}
		// Count zone corners
		// https://forums.alliedmods.net/showpost.php?p=2006539&postcount=8
		for (int x = 0; x < g_mapZonesCount; x++)
		{
			for(int i = 1; i < 7; i++)
			{
				for(int j = 0; j < 3; j++)
				{
					g_fZoneCorners[x][i][j] = g_fZoneCorners[x][((i >> (2-j)) & 1) * 7][j];
				}
			}
		}

		/**
		* Check for errors
		*
		* 1. ZoneId
		*/
		char szQuery[258];
		for (int i = 0; i < g_mapZonesCount; i++)
			if (zoneIdChecker[i] == 0)
			{
				PrintToServer("[%s] Found an error in zoneid : %i", g_szChatPrefix, i);
				Format(szQuery, 258, "UPDATE `ck_zones` SET zoneid = zoneid-1 WHERE mapname = '%s' AND zoneid > %i", g_szMapName, i);
				PrintToServer("Query: %s", szQuery);
				SQL_TQuery(g_hDb, sql_zoneFixCallback, szQuery, -1, DBPrio_Low);
				return;
			}

		// 2nd ZoneGroup
		for (int i = 0; i < g_mapZoneGroupCount; i++)
			if (zoneGroupChecker[i] == 0)
			{
				PrintToServer("[%s] Found an error in zonegroup %i (ZoneGroups total: %i)", g_szChatPrefix, i, g_mapZoneGroupCount);
				Format(szQuery, 258, "UPDATE `ck_zones` SET `zonegroup` = zonegroup-1 WHERE `mapname` = '%s' AND `zonegroup` > %i", g_szMapName, i);
				SQL_TQuery(g_hDb, sql_zoneFixCallback, szQuery, zoneGroupChecker[i], DBPrio_Low);
				return;
			}

		// 3rd ZoneTypeId
		for (int i = 0; i < g_mapZoneGroupCount; i++)
			for (int k = 0; k < ZONEAMOUNT; k++)
				for (int x = 0; x < zoneTypeIdCheckerCount[i][k]; x++)
					if (zoneTypeIdChecker[i][k][x] != 1 && (k == 3) || (k == 4))
					{
						if (zoneTypeIdChecker[i][k][x] == 0)
						{
							PrintToServer("[%s] ZoneTypeID missing! [ZoneGroup: %i ZoneType: %i, ZonetypeId: %i]", g_szChatPrefix, i, k, x);
							Format(szQuery, 258, "UPDATE `ck_zones` SET zonetypeid = zonetypeid-1 WHERE mapname = '%s' AND zonetype = %i AND zonetypeid > %i AND zonegroup = %i;", g_szMapName, k, x, i);
							SQL_TQuery(g_hDb, sql_zoneFixCallback, szQuery, -1, DBPrio_Low);
							return;
						}
						else if (zoneTypeIdChecker[i][k][x] > 1)
						{
							char szerror[258];
							Format(szerror, 258, "[%s] Duplicate Stage Zone ID's on %s [ZoneGroup: %i, ZoneType: 3, ZoneTypeId: %i]", g_szChatPrefix, g_szMapName, k, x);
							LogError(szerror);
						}
					}

		RefreshZones();

		// Set mapzone count in group
		for (int x = 0; x < g_mapZoneGroupCount; x++)
			for (int k = 0; k < ZONEAMOUNT; k++)
				if (g_mapZonesTypeCount[x][k] > 0)
					g_mapZoneCountinGroup[x]++;
		debug_msg("Ended selectMapZones");
		if (!g_bServerDataLoaded)
			db_selectSpawnLocations();
		
		return;
	}
}

public void sql_zoneFixCallback(Handle owner, Handle hndl, const char[] error, any zongeroup)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_zoneFixCallback): %s", g_szChatPrefix, error);
		return;
	}
	if (zongeroup == -1)
	{
		db_selectMapZones();
	}
	else
	{
		char szQuery[258];
		Format(szQuery, 258, "DELETE FROM `ck_bonus` WHERE `mapname` = '%s' AND `zonegroup` = %i;", g_szMapName, zongeroup);
		SQL_TQuery(g_hDb, sql_zoneFixCallback2, szQuery, zongeroup, DBPrio_Low);
	}
}

public void sql_zoneFixCallback2(Handle owner, Handle hndl, const char[] error, any zongeroup)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_zoneFixCallback2): %s", g_szChatPrefix, error);
		return;
	}

	char szQuery[258];
	Format(szQuery, 258, "UPDATE ck_bonus SET zonegroup = zonegroup-1 WHERE `mapname` = '%s' AND `zonegroup` = %i;", g_szMapName, zongeroup);
	SQL_TQuery(g_hDb, sql_zoneFixCallback, szQuery, -1, DBPrio_Low);
}

public void db_deleteMapZones()
{
	char szQuery[258];
	Format(szQuery, 258, sql_deleteMapZones, g_szMapName);
	SQL_TQuery(g_hDb, SQL_deleteMapZonesCallback, szQuery, 1, DBPrio_Low);
}

public void SQL_deleteMapZonesCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_deleteMapZonesCallback): %s", g_szChatPrefix, error);
		return;
	}
}

public void db_deleteZone(int client, int zoneid)
{
	char szQuery[258];
	Transaction h_deleteZone = SQL_CreateTransaction();

	Format(szQuery, 258, sql_deleteZone, g_szMapName, zoneid);
	SQL_AddQuery(h_deleteZone, szQuery);

	Format(szQuery, 258, "UPDATE ck_zones SET zoneid = zoneid-1 WHERE mapname = '%s' AND zoneid > %i", g_szMapName, zoneid);
	SQL_AddQuery(h_deleteZone, szQuery);

	SQL_ExecuteTransaction(g_hDb, h_deleteZone, SQLTxn_ZoneRemovalSuccess, SQLTxn_ZoneRemovalFailed, client);
}

public void SQLTxn_ZoneRemovalSuccess(Handle db, any client, int numQueries, Handle[] results, any[] queryData)
{
	if (IsValidClient(client))
		PrintToChat(client, "[%c%s%c] Zone Removed Succesfully", MOSSGREEN, g_szChatPrefix, WHITE);
	PrintToServer("[%s] Zone Removed Succesfully", g_szChatPrefix);
}

public void SQLTxn_ZoneRemovalFailed(Handle db, any client, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	if (IsValidClient(client))
		PrintToChat(client, "[%c%s%c] %cZone Removal Failed! Error:%c %s", MOSSGREEN, g_szChatPrefix, WHITE, RED, WHITE, error);
	PrintToServer("[%s] Zone Removal Failed. Error: %s", g_szChatPrefix, error);
	return;
}

///////////////////////
//// MISC /////////////
///////////////////////

public void db_insertLastPosition(int client, char szMapName[128], int stage, int zgroup)
{
	if (GetConVarBool(g_hcvarRestore) && !g_bRoundEnd && (StrContains(g_szSteamID[client], "STEAM_") != -1) && g_bTimeractivated[client])
	{
		Handle pack = CreateDataPack();
		WritePackCell(pack, client);
		WritePackString(pack, szMapName);
		WritePackString(pack, g_szSteamID[client]);
		WritePackCell(pack, stage);
		WritePackCell(pack, zgroup);
		char szQuery[512];
		Format(szQuery, 512, "SELECT * FROM ck_playertemp WHERE steamid = '%s'", g_szSteamID[client]);
		SQL_TQuery(g_hDb, db_insertLastPositionCallback, szQuery, pack, DBPrio_Low);
	}
}

public void db_insertLastPositionCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_insertLastPositionCallback): %s", g_szChatPrefix, error);
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
		if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			Format(szQuery, 1024, sql_updatePlayerTmp, g_fPlayerCordsLastPosition[client][0], g_fPlayerCordsLastPosition[client][1], g_fPlayerCordsLastPosition[client][2], g_fPlayerAnglesLastPosition[client][0], g_fPlayerAnglesLastPosition[client][1], g_fPlayerAnglesLastPosition[client][2], g_fPlayerLastTime[client], szMapName, tickrate, stage, zgroup, szSteamID);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
		}
		else
		{
			Format(szQuery, 1024, sql_insertPlayerTmp, g_fPlayerCordsLastPosition[client][0], g_fPlayerCordsLastPosition[client][1], g_fPlayerCordsLastPosition[client][2], g_fPlayerAnglesLastPosition[client][0], g_fPlayerAnglesLastPosition[client][1], g_fPlayerAnglesLastPosition[client][2], g_fPlayerLastTime[client], szSteamID, szMapName, tickrate, stage, zgroup);
			SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
		}
	}
}

public void db_deletePlayerTmps()
{
	char szQuery[64];
	Format(szQuery, 64, "delete FROM ck_playertemp");
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
}

public void db_ViewLatestRecords(int client)
{
	SQL_TQuery(g_hDb, sql_selectLatestRecordsCallback, sql_selectLatestRecords, client, DBPrio_Low);
}

public void sql_selectLatestRecordsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectLatestRecordsCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szName[64];
	char szMapName[64];
	char szDate[64];
	char szTime[32];
	char szServerName[128];
	float ftime;
	PrintToConsole(data, "----------------------------------------------------------------------------------------------------");
	PrintToConsole(data, "Last map records:");
	if (SQL_HasResultSet(hndl))
	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			ftime = SQL_FetchFloat(hndl, 1);
			FormatTimeFloat(data, ftime, 3, szTime, sizeof(szTime));
			SQL_FetchString(hndl, 2, szMapName, 64);
			SQL_FetchString(hndl, 3, szDate, 64);
			SQL_FetchString(hndl, 4, szServerName, 128);
			PrintToConsole(data, "%s: %s on %s - Time %s on %s", szDate, szName, szMapName, szTime, szServerName);
			i++;
		}
		if (i == 1)
			PrintToConsole(data, "No records found.");
	}
	else
		PrintToConsole(data, "No records found.");
	PrintToConsole(data, "----------------------------------------------------------------------------------------------------");
	PrintToChat(data, "[%c%s%c] See console for output!", MOSSGREEN, g_szChatPrefix, WHITE);
}

public void db_CheckLatestRecords()
{
	SQL_TQuery(g_hDb, sql_checkLatestRecordsCallback, sql_select30SecondRecords, DBPrio_Low);
}

public void sql_checkLatestRecordsCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_checkLatestRecordsCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szName[64];
	char szMapName[64];
	char szDate[64];
	char szTime[32];
	char szServerName[128];
	float ftime;
	
	if (SQL_HasResultSet(hndl) && (SQL_GetRowCount(hndl) != 0))
	{
		//TODO Log bonus records!
		while (SQL_FetchRow(hndl))
		{	
			SQL_FetchString(hndl, 0, szName, 64);
			ftime = SQL_FetchFloat(hndl, 1);
			FormatTimeFloat(data, ftime, 3, szTime, sizeof(szTime));
			SQL_FetchString(hndl, 2, szMapName, 64);
			SQL_FetchString(hndl, 3, szDate, 64);
			SQL_FetchString(hndl, 4, szServerName, 128);
			if(!StrEqual(szServerName, g_szServerNameBrowser))
			{
				
				//Check if record was set on another server, set the new recrod to this, so we dont have multiple servers running the same maps simultantesoly
				//But having differnt record threads :) 
				if(strcmp(szMapName, g_szMapName) == 0)
				{
					g_szRecordMapTime = szTime;
					g_fRecordMapTime = ftime;
				}
				if (g_hMultiServerAnnouncements.BoolValue)
				{
					PrintToChatAll("%c　%c━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",MOSSGREEN, YELLOW);
					PrintToChatAll("　　　　　　　　[%c%s%c] %Announcement", MOSSGREEN, g_szChatPrefix, WHITE, PURPLE);
					PrintToChatAll("");
					PrintToChatAll("%c　%c%s%c has beaten the %c%s %cMAP RECORD%c with a time of %c%s%c in the %c%s%c Server.",MOSSGREEN, LIMEGREEN, szName, GRAY, LIMEGREEN, szMapName, DARKBLUE, GRAY, LIMEGREEN, szTime , GRAY, LIMEGREEN, szServerName, GRAY);
					PrintToChatAll("　");
					PrintToChatAll("%c　%c━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",MOSSGREEN, YELLOW);
					for (int b = 1; b <= MaxClients; b++)
						{	
						if (IsValidClient(b) && !IsFakeClient(b))
							{
							ClientCommand(b, "play resource\\warning.wav");
							}
						}							
				}
			}
		}
		
	}
}

public void db_InsertLatestRecords(char szSteamID[32], char szName[32], float FinalTime)
{
	char szQuery[512];
	Format(szQuery, 512, sql_insertLatestRecords, szSteamID, szName, FinalTime, g_szMapName, g_szServerNameBrowser);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
}

public void GetDBName(int client, char szSteamId[32])
{
	char szQuery[512];
	Format(szQuery, 512, sql_selectRankedPlayer, szSteamId);
	SQL_TQuery(g_hDb, GetDBNameCallback, szQuery, client, DBPrio_Low);
}

public void GetDBNameCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (GetDBNameCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, g_szProfileName[data], MAX_NAME_LENGTH);
		db_viewPlayerAll(data, g_szProfileName[data]);
	}
}

public void db_CalcAvgRunTime()
{
	debug_msg(" Started db_CalcAvgRunTime ");
	char szQuery[256];
	Format(szQuery, 256, sql_selectAllMapTimesinMap, g_szMapName);
	SQL_TQuery(g_hDb, SQL_db_CalcAvgRunTimeCallback, szQuery, DBPrio_Low);
}

public void SQL_db_CalcAvgRunTimeCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_db_CalcAvgRunTimeCallback): %s", g_szChatPrefix, error);

		if (!g_bServerDataLoaded && g_bhasBonus)
			db_CalcAvgRunTimeBonus();
		else if (!g_bServerDataLoaded)
			db_CalculatePlayerCount();

		return;
	}

	g_favg_maptime = 0.0;
	if (SQL_HasResultSet(hndl))
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
	debug_msg(" Ended SQL_db_CalcAvgRunTimeCallback ");
	if (g_bhasBonus)
		db_CalcAvgRunTimeBonus();
	else
		db_CalculatePlayerCount();
}
public void db_CalcAvgRunTimeBonus()
{
	debug_msg(" Started db_CalcAvgRunTimeBonus ");
	char szQuery[256];
	Format(szQuery, 256, sql_selectAllBonusTimesinMap, g_szMapName);
	SQL_TQuery(g_hDb, SQL_db_CalcAvgRunBonusTimeCallback, szQuery, 1, DBPrio_Low);
}

public void SQL_db_CalcAvgRunBonusTimeCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_db_CalcAvgRunTimeCallback): %s", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_CalculatePlayerCount();
		return;
	}

	for (int i = 1; i < MAXZONEGROUPS; i++)
		g_fAvg_BonusTime[i] = 0.0;

	if (SQL_HasResultSet(hndl))
	{
		int zonegroup, runtimes[MAXZONEGROUPS];
		float runtime[MAXZONEGROUPS], time;
		while (SQL_FetchRow(hndl))
		{
			zonegroup = SQL_FetchInt(hndl, 0);
			time = SQL_FetchFloat(hndl, 1);
			if (time > 0.0)
			{
				runtime[zonegroup] += time;
				runtimes[zonegroup]++;
			}
		}

		for (int i = 1; i < MAXZONEGROUPS; i++)
			g_fAvg_BonusTime[i] = runtime[i] / runtimes[i];
	}
	debug_msg(" Ended SQL_db_CalcAvgRunBonusTimeCallback ");
	if (!g_bServerDataLoaded)
		db_CalculatePlayerCount();

	return;
}

public void db_GetDynamicTimelimit()
{
	debug_msg(" Started db_GetDynamicTimelimit ");
	if (!GetConVarBool(g_hDynamicTimelimit))
	{
		if (!g_bServerDataLoaded)
			loadAllClientSettings();
		return;
	}
	char szQuery[256];
	Format(szQuery, 256, sql_selectAllMapTimesinMap, g_szMapName);
	SQL_TQuery(g_hDb, SQL_db_GetDynamicTimelimitCallback, szQuery, DBPrio_Low);
}

public void SQL_db_GetDynamicTimelimitCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_db_GetDynamicTimelimitCallback): %s", g_szChatPrefix, error);
		loadAllClientSettings();
		return;
	}

	if (SQL_HasResultSet(hndl))
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
			Format(szTimelimit, 32, "mp_timelimit %i;mp_roundtime %i", avg, avg);
			ServerCommand(szTimelimit);
			ServerCommand("mp_restartgame 1");
		}
		else
			ServerCommand("mp_timelimit 50");
	}
	debug_msg(" Ended SQL_db_GetDynamicTimelimitCallback ");
	if (!g_bServerDataLoaded)
		loadAllClientSettings();

	return;
}

public void db_CalculatePlayerCount()
{
	debug_msg(" Started db_CalculatePlayerCount ");
	char szQuery[255];
	Format(szQuery, 255, sql_CountRankedPlayers);
	SQL_TQuery(g_hDb, sql_CountRankedPlayersCallback, szQuery, DBPrio_Low);
}

public void db_CalculatePlayersCountGreater0()
{
	debug_msg(" Started db_CalculatePlayersCountGreater0 ");
	char szQuery[255];
	Format(szQuery, 255, sql_CountRankedPlayers2);
	SQL_TQuery(g_hDb, sql_CountRankedPlayers2Callback, szQuery, DBPrio_Low);
}

public void sql_CountRankedPlayersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_CountRankedPlayersCallback): %s", g_szChatPrefix, error);
		db_CalculatePlayersCountGreater0();
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_pr_AllPlayers = SQL_FetchInt(hndl, 0);
	}
	else
		g_pr_AllPlayers = 1;

	//get amount of players with actual player points
	debug_msg(" Ended sql_CountRankedPlayersCallback ");
	db_CalculatePlayersCountGreater0();
	return;
}

public void sql_CountRankedPlayers2Callback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_CountRankedPlayers2Callback): %s", g_szChatPrefix, error);
		if (!g_bServerDataLoaded)
			db_ClearLatestRecords();
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		g_pr_RankedPlayers = SQL_FetchInt(hndl, 0);
	}
	else
		g_pr_RankedPlayers = 0;
	debug_msg(" Ended sql_CountRankedPlayers2Callback ");
	if (!g_bServerDataLoaded)
		db_ClearLatestRecords();

	return;
}

public void db_ClearLatestRecords()
{
	debug_msg(" Started xxxxxx ");
	if (g_DbType == MYSQL)
		SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM ck_latestrecords WHERE date < NOW() - INTERVAL 1 WEEK", DBPrio_Low);
	else
		SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM ck_latestrecords WHERE date <= date('now','-7 day')", DBPrio_Low);
	debug_msg(" Ended db_ClearLatestRecords ");
	if (!g_bServerDataLoaded)
		db_GetDynamicTimelimit();
		
}

public void db_viewUnfinishedMaps(int client, char szSteamId[32])
{
	if (IsValidClient(client))
	{
		PrintToChat(client, "%t", "ConsoleOutput", LIMEGREEN, g_szChatPrefix, WHITE);
		ProfileMenu(client, -1);
	}
	else
		return;

	char szQuery[720];
	// Gets all players unfinished maps and bonuses from the database
	Format(szQuery, 720, "SELECT mapname, zonegroup, zonename FROM ck_zones a WHERE (zonetype = 1 OR zonetype = 5) AND (SELECT runtimepro FROM ck_playertimes b WHERE b.mapname = a.mapname AND a.zonegroup = 0 AND steamid = '%s' UNION SELECT runtime FROM ck_bonus c WHERE c.mapname = a.mapname AND c.zonegroup = a.zonegroup AND steamid = '%s') IS NULL GROUP BY mapname, zonegroup ORDER BY mapname, zonegroup ASC;", szSteamId, szSteamId);
	SQL_TQuery(g_hDb, db_viewUnfinishedMapsCallback, szQuery, client, DBPrio_Low);
}

public void db_viewUnfinishedMapsCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_viewUnfinishedMapsCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl))
	{
		char szMap[128], szMap2[128], tmpMap[128], consoleString[1024], unfinishedBonusBuffer[772], zName[128];
		bool mapUnfinished, bonusUnfinished;
		int zGrp, count, mapCount, bonusCount, mapListSize = GetArraySize(g_MapList), digits;
		float time = 0.5;
		while (SQL_FetchRow(hndl))
		{
			// Get the map and check that it is in the mapcycle
			SQL_FetchString(hndl, 0, szMap, 128);
			for (int i = 0; i < mapListSize; i++)
			{
				GetArrayString(g_MapList, i, szMap2, 128);
				if (StrEqual(szMap, szMap2, false))
				{
					// Map is in the mapcycle, and is unfinished

					// Initialize the name
					if (!tmpMap[0])
						strcopy(tmpMap, 128, szMap);

					// Check if the map changed, if so announce to client's console
					if (!StrEqual(szMap, tmpMap, false))
					{
						if (count < 10)
							digits = 1;
						else
							if (count < 100)
								digits = 2;
							else
								digits = 3;

						if (strlen(tmpMap) < (13-digits)) // <- 11
							Format(tmpMap, 128, "%s:\t\t\t\t", tmpMap);
						else
							if ((12-digits) < strlen(tmpMap) < (21-digits)) // 12 - 19
								Format(tmpMap, 128, "%s:\t\t\t", tmpMap);
							else
								if ((20-digits) < strlen(tmpMap) < (28-digits)) // 20 - 25
									Format(tmpMap, 128, "%s:\t\t", tmpMap);
								else
									Format(tmpMap, 128, "%s:\t", tmpMap);

						count++;
						if (!mapUnfinished) // Only bonus is unfinished
							Format(consoleString, 1024, "%i. %s\t\t|  %s", count, tmpMap, unfinishedBonusBuffer);
						else
							if (!bonusUnfinished) // Only map is unfinished
								Format(consoleString, 1024, "%i. %sMap unfinished\t|", count, tmpMap);
							else // Both unfinished
								Format(consoleString, 1024, "%i. %sMap unfinished\t|  %s", count, tmpMap, unfinishedBonusBuffer);

						// Throttle messages to not cause errors on huge mapcycles
						time = time + 0.1;
						Handle pack = CreateDataPack();
						WritePackCell(pack, client);
						WritePackString(pack, consoleString);
						CreateTimer(time, PrintUnfinishedLine, pack);

						mapUnfinished = false;
						bonusUnfinished = false;
						consoleString[0] = '\0';
						unfinishedBonusBuffer[0] = '\0';
						strcopy(tmpMap, 128, szMap);
					}

					zGrp = SQL_FetchInt(hndl, 1);
					if (zGrp < 1)
					{
						mapUnfinished = true;
						mapCount++;
					}
					else
					{
						SQL_FetchString(hndl, 2, zName, 128);

						if (!zName[0])
							Format(zName, 128, "BONUS %i", zGrp);

						if (bonusUnfinished)
							Format(unfinishedBonusBuffer, 772, "%s, %s", unfinishedBonusBuffer, zName);
						else
						{
							bonusUnfinished = true;
							Format(unfinishedBonusBuffer, 772, "Bonus: %s", zName);
						}
						bonusCount++;
					}
					break;
				}
			}
		}
		if (IsValidClient(client))
		{
			PrintToConsole(client, " ");
			PrintToConsole(client, "------- User Stats -------");
			PrintToConsole(client, "%i unfinished maps of total %i maps", mapCount, g_pr_MapCount);
			PrintToConsole(client, "%i unfinished bonuses", bonusCount);
			PrintToConsole(client, "SteamID: %s", g_szProfileSteamId[client]);
			PrintToConsole(client, "--------------------------");
			PrintToConsole(client, " ");
			PrintToConsole(client, "------------------------------ Map Details -----------------------------");
		}
	}
	return;
}
public Action PrintUnfinishedLine(Handle timer, any pack)
{
	ResetPack(pack);
	int client = ReadPackCell(pack);
	char teksti[1024];
	ReadPackString(pack, teksti, 1024);
	CloseHandle(pack);
	if (IsValidClient(client))
		PrintToConsole(client, teksti);

}

/*
void PrintUnfinishedLine(Handle pack)
{
	ResetPack(pack);
	int client = ReadPackCell(pack);
	char teksti[1024];
	ReadPackString(pack, teksti, 1024);
	CloseHandle(pack);
	PrintToConsole(client, teksti);
}
*/
public void db_viewPlayerProfile1(int client, char szPlayerName[MAX_NAME_LENGTH])
{
	char szQuery[512];
	char szName[MAX_NAME_LENGTH * 2 + 1];
	SQL_EscapeString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH * 2 + 1);
	Format(szQuery, 512, sql_selectPlayerRankAll2, szName);
	Handle pack = CreateDataPack();
	WritePackCell(pack, client);
	WritePackString(pack, szPlayerName);
	SQL_TQuery(g_hDb, SQL_ViewPlayerProfile1Callback, szQuery, pack, DBPrio_Low);
}

public void SQL_ViewPlayerProfile1Callback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewPlayerProfile1Callback): %s", g_szChatPrefix, error);
		return;
	}
	char szPlayerName[MAX_NAME_LENGTH];

	ResetPack(data);
	int client = ReadPackCell(data);
	ReadPackString(data, szPlayerName, MAX_NAME_LENGTH);
	CloseHandle(data);

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, g_szProfileSteamId[client], 32);
		db_viewPlayerRank(client, g_szProfileSteamId[client]);
	}
	else
	{
		char szQuery[512];
		char szName[MAX_NAME_LENGTH * 2 + 1];
		SQL_EscapeString(g_hDb, szPlayerName, szName, MAX_NAME_LENGTH * 2 + 1);
		Format(szQuery, 512, sql_selectPlayerRankAll, PERCENT, szName, PERCENT);
		SQL_TQuery(g_hDb, SQL_ViewPlayerProfile2Callback, szQuery, client, DBPrio_Low);
	}
}

public void sql_selectPlayerNameCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectPlayerNameCallback): %s", g_szChatPrefix, error);
		return;
	}

	ResetPack(data);
	int clientid = ReadPackCell(data);
	int client = ReadPackCell(data);
	CloseHandle(data);

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 0, g_pr_szName[clientid], 64);
		g_bProfileRecalc[clientid] = true;
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
public void RefreshPlayerRankTable(int max)
{
	g_pr_Recalc_ClientID = 1;
	g_pr_RankingRecalc_InProgress = true;
	char szQuery[255];

	//SELECT steamid, name from ck_playerrank where points > 0 ORDER BY points DESC";
	Format(szQuery, 255, sql_selectRankedPlayers);
	SQL_TQuery(g_hDb, sql_selectRankedPlayersCallback, szQuery, max, DBPrio_Low);
}

public void sql_selectRankedPlayersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (sql_selectRankedPlayersCallback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl))
	{
		int i = 66;
		int x;
		g_pr_TableRowCount = SQL_GetRowCount(hndl);
		if (g_pr_TableRowCount == 0)
		{
			for (int c = 1; c <= MaxClients; c++)
				if (1 <= c <= MaxClients && IsValidClient(c))
				{
					if (g_bManualRecalc)
						PrintToChat(c, "%t", "PrUpdateFinished", MOSSGREEN, g_szChatPrefix, WHITE, LIMEGREEN);
				}
			g_bManualRecalc = false;
			g_pr_RankingRecalc_InProgress = false;

			if (IsValidClient(g_pr_Recalc_AdminID))
			{
				PrintToConsole(g_pr_Recalc_AdminID, ">> Recalculation finished");
				CreateTimer(0.1, RefreshAdminMenu, GetClientSerial(g_pr_Recalc_AdminID), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		if (MAX_PR_PLAYERS != data && g_pr_TableRowCount > data)
			x = 66 + data;
		else
			x = 66 + g_pr_TableRowCount;

		if (g_pr_TableRowCount > MAX_PR_PLAYERS)
			g_pr_TableRowCount = MAX_PR_PLAYERS;

		if (x > MAX_PR_PLAYERS)
			x = MAX_PR_PLAYERS - 1;
		if (IsValidClient(g_pr_Recalc_AdminID) && g_bManualRecalc)
		{
			int max = MAX_PR_PLAYERS - 66;
			PrintToConsole(g_pr_Recalc_AdminID, " \n>> Recalculation started! (Only Top %i because of performance reasons)", max);
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

public void db_Cleanup()
{
	char szQuery[255];

	//tmps
	Format(szQuery, 255, "DELETE FROM ck_playertemp where mapname != '%s'", g_szMapName);
	SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery);

	//times
	SQL_TQuery(g_hDb, SQL_CheckCallback, "DELETE FROM ck_playertimes where runtimepro = -1.0");
}

public void db_resetMapRecords(int client, char szMapName[128])
{
	char szQuery[255];
	Format(szQuery, 255, sql_resetMapRecords, szMapName);
	SQL_TQuery(g_hDb, SQL_CheckCallback2, szQuery, DBPrio_Low);
	PrintToConsole(client, "player times on %s cleared.", szMapName);
	if (StrEqual(szMapName, g_szMapName))
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

public void SQL_InsertPlayerCallBack(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_InsertPlayerCallBack): %s", g_szChatPrefix, error);
		return;
	}

	if (IsClientInGame(data))
		db_UpdateLastSeen(data);
}

public void db_UpdateLastSeen(int client)
{
	if ((StrContains(g_szSteamID[client], "STEAM_") != -1) && !IsFakeClient(client))
	{
		char szQuery[512];
		if (g_DbType == MYSQL)
			Format(szQuery, 512, sql_UpdateLastSeenMySQL, g_szSteamID[client]);
		else
			if (g_DbType == SQLITE)
			Format(szQuery, 512, sql_UpdateLastSeenSQLite, g_szSteamID[client]);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
	}
}

/////////////////////////////
///// DEFAULT CALLBACKS /////
/////////////////////////////

public void SQL_CheckCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_CheckCallback): %s", g_szChatPrefix, error);
		return;
	}
}

public void SQL_CheckCallback2(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_CheckCallback2): %s", g_szChatPrefix, error);
		return;
	}

	db_viewMapProRankCount();
	db_GetMapRecord_Pro();
}

public void SQL_CheckCallback3(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_CheckCallback3): %s", g_szChatPrefix, error);
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

public void SQL_CheckCallback4(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_CheckCallback4): %s", g_szChatPrefix, error);
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

public void db_viewPlayerOptions(int client, char szSteamId[32])
{
	char szQuery[512];
	Format(szQuery, 512, sql_selectPlayerOptions, szSteamId);
	SQL_TQuery(g_hDb, db_viewPlayerOptionsCallback, szQuery, client, DBPrio_Low);
}

public void db_viewPlayerOptionsCallback(Handle owner, Handle hndl, const char[] error, any client)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_viewPlayerOptionsCallback): %s", g_szChatPrefix, error);
		if (!g_bSettingsLoaded[client])
			db_viewPersonalFlags(client, g_szSteamID[client]);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		//"SELECT speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3, checkpoints FROM ck_playeroptions where steamid = '%s'";

		g_bInfoPanel[client] = view_as<bool>(SQL_FetchInt(hndl, 0));
		g_bEnableQuakeSounds[client] = view_as<bool>(SQL_FetchInt(hndl, 1));
		g_bAutoBhopClient[client] = view_as<bool>(SQL_FetchInt(hndl, 2));
		g_bShowNames[client] = view_as<bool>(SQL_FetchInt(hndl, 3));
		g_bGoToClient[client] = view_as<bool>(SQL_FetchInt(hndl, 4));
		g_bShowTime[client] = view_as<bool>(SQL_FetchInt(hndl, 5));
		g_bHide[client] = view_as<bool>(SQL_FetchInt(hndl, 6));
		g_bShowSpecs[client] = view_as<bool>(SQL_FetchInt(hndl, 7));
		g_bStartWithUsp[client] = view_as<bool>(SQL_FetchInt(hndl, 9));
		g_bHideChat[client] = view_as<bool>(SQL_FetchInt(hndl, 10));
		g_bViewModel[client] = view_as<bool>(SQL_FetchInt(hndl, 11));
		g_bCheckpointsEnabled[client] = view_as<bool>(SQL_FetchInt(hndl, 12));
		g_SrSoundId[client] = SQL_FetchInt(hndl, 13); 
		g_BrSoundId[client] = SQL_FetchInt(hndl, 14); 
		g_BeatSoundId[client] = SQL_FetchInt(hndl, 15); 
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
		g_borg_CheckpointsEnabled[client] = g_bCheckpointsEnabled[client];
		g_orgSrSoundId[client] = g_SrSoundId[client]; 
		g_orgBrSoundId[client] = g_BrSoundId[client]; 
		g_orgBeatSoundId[client] = g_BeatSoundId[client];  
	}
	else
	{
		char szQuery[512];
		if (!IsValidClient(client))
			return;

		//"INSERT INTO ck_playeroptions (steamid, speedmeter, quake_sounds, autobhop, shownames, goto, showtime, hideplayers, showspecs, knife, new1, new2, new3) VALUES('%s', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%i', '%s', '%i', '%i', '%i');";

		
		Format(szQuery, 512, sql_insertPlayerOptions, g_szSteamID[client], 1, 1, 1, 1, 1, 0, 0, 1, "weapon_knife", 0, 0, 1, 1, 0, 1, 2); 
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, DBPrio_Low);
		g_borg_InfoPanel[client] = true;
		g_borg_EnableQuakeSounds[client] = true;
		g_borg_AutoBhopClient[client] = true;
		g_borg_ShowNames[client] = true;
		g_borg_GoToClient[client] = true;
		g_borg_ShowTime[client] = false;
		g_borg_Hide[client] = false;
		g_borg_ShowSpecs[client] = true;
		// weapon_knife
		g_borg_StartWithUsp[client] = false;
		g_borg_HideChat[client] = false;
		g_borg_ViewModel[client] = true;
		g_borg_CheckpointsEnabled[client] = true;
		g_orgSrSoundId[client] = 0; 
		g_orgBrSoundId[client] = 1; 
		g_orgBeatSoundId[client] = 2; 
	}
	if (!g_bSettingsLoaded[client])
		db_viewPersonalFlags(client, g_szSteamID[client]);
	return;
}

public void db_updatePlayerOptions(int client)
{
	if (g_borg_ViewModel[client] != g_bViewModel[client] || g_borg_HideChat[client] != g_bHideChat[client] || g_borg_StartWithUsp[client] != g_bStartWithUsp[client] || g_borg_AutoBhopClient[client] != g_bAutoBhopClient[client] || g_borg_InfoPanel[client] != g_bInfoPanel[client] || g_borg_EnableQuakeSounds[client] != g_bEnableQuakeSounds[client] || g_borg_ShowNames[client] != g_bShowNames[client] || g_borg_GoToClient[client] != g_bGoToClient[client] || g_borg_ShowTime[client] != g_bShowTime[client] || g_borg_Hide[client] != g_bHide[client] || g_borg_ShowSpecs[client] != g_bShowSpecs[client] || g_borg_CheckpointsEnabled[client] != g_bCheckpointsEnabled[client] || g_orgSrSoundId[client] != g_SrSoundId[client] || g_orgBrSoundId[client] != g_BrSoundId[client] || g_orgBeatSoundId[client] != g_BeatSoundId[client]) 
	{
		char szQuery[1024];
		Format(szQuery, 1024, sql_updatePlayerOptions, BooltoInt(g_bInfoPanel[client]), BooltoInt(g_bEnableQuakeSounds[client]), BooltoInt(g_bAutoBhopClient[client]), BooltoInt(g_bShowNames[client]), BooltoInt(g_bGoToClient[client]), BooltoInt(g_bShowTime[client]), BooltoInt(g_bHide[client]), BooltoInt(g_bShowSpecs[client]), "weapon_knife", BooltoInt(g_bStartWithUsp[client]), BooltoInt(g_bHideChat[client]), BooltoInt(g_bViewModel[client]), BooltoInt(g_bCheckpointsEnabled[client]),g_SrSoundId[client] ,g_BrSoundId[client] ,g_BeatSoundId[client] , g_szSteamID[client]);
		SQL_TQuery(g_hDb, SQL_CheckCallback, szQuery, client, DBPrio_Low);
	}
}

//////////////////////////////
/// MENUS ////////////////////
//////////////////////////////

public void db_selectTopProRecordHolders(int client)
{
	char szQuery[512];
	Format(szQuery, 512, sql_selectMapRecordHolders);
	SQL_TQuery(g_hDb, db_sql_selectMapRecordHoldersCallback, szQuery, client);
}

public void db_sql_selectMapRecordHoldersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_sql_selectMapRecordHoldersCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szSteamID[32];
	char szRecords[64];
	char szQuery[256];
	int records = 0;
	if (SQL_HasResultSet(hndl))
	{
		int i = SQL_GetRowCount(hndl);
		int x = i;
		g_menuTopSurfersMenu[data] = new Menu(TopProHoldersHandler1);
		g_menuTopSurfersMenu[data].SetTitle("Top 5 Pro Surfers\n#   Records       Player");
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szSteamID, 32);
			records = SQL_FetchInt(hndl, 1);
			if (records > 9)
				Format(szRecords, 64, "%i", records);
			else
				Format(szRecords, 64, "%i  ", records);

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
			PrintToChat(data, "%t", "NoRecordTop", MOSSGREEN, g_szChatPrefix, WHITE);
			ckTopMenu(data);
		}
	}
	else
	{
		PrintToChat(data, "%t", "NoRecordTop", MOSSGREEN, g_szChatPrefix, WHITE);
		ckTopMenu(data);
	}
}

public void db_sql_selectMapRecordHoldersCallback2(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_sql_selectMapRecordHoldersCallback2): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
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
		Format(szValue, 128, "      %s       »  %s", szRecords, szName);
		g_menuTopSurfersMenu[client].AddItem(szSteamID, szValue, ITEMDRAW_DEFAULT);
		if (count == 1)
		{
			g_menuTopSurfersMenu[client].OptionFlags = MENUFLAG_BUTTON_EXIT;
			g_menuTopSurfersMenu[client].Display(client, MENU_TIME_FOREVER);
		}
	}
}

public void db_selectTopPlayers(int client)
{
	char szQuery[128];
	Format(szQuery, 128, sql_selectTopPlayers);
	SQL_TQuery(g_hDb, db_selectTop100PlayersCallback, szQuery, client, DBPrio_Low);
}

public void db_selectTop100PlayersCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (db_selectTop100PlayersCallback): %s", g_szChatPrefix, error);
		return;
	}

	char szValue[128];
	char szName[64];
	char szRank[16];
	char szSteamID[32];
	char szPerc[16];
	int points;
	Menu menu = new Menu(TopPlayersMenuHandler1);
	menu.SetTitle("Top 100 Players\n    Rank   Points       Maps            Player");
	menu.Pagination = 5;
	if (SQL_HasResultSet(hndl))
	{
		int i = 1;
		while (SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, szName, 64);
			if (i == 100)
				Format(szRank, 16, "[%i.]", i);
			else
				if (i < 10)
					Format(szRank, 16, "[0%i.]  ", i);
				else
					Format(szRank, 16, "[%i.]  ", i);

			points = SQL_FetchInt(hndl, 1);
			int pro = SQL_FetchInt(hndl, 2);
			SQL_FetchString(hndl, 3, szSteamID, 32);
			float fperc;
			fperc = (float(pro) / (float(g_pr_MapCount))) * 100.0;

			if (fperc < 10.0)
				Format(szPerc, 16, "  %.1f%c  ", fperc, PERCENT);
			else
				if (fperc == 100.0)
					Format(szPerc, 16, "100.0%c", PERCENT);
				else
					if (fperc > 100.0) //player profile not refreshed after removing maps
						Format(szPerc, 16, "100.0%c", PERCENT);
					else
						Format(szPerc, 16, "%.1f%c  ", fperc, PERCENT);

			if (points < 10)
				Format(szValue, 128, "%s      %ip       %s     » %s", szRank, points, szPerc, szName);
			else
				if (points < 100)
					Format(szValue, 128, "%s     %ip       %s     » %s", szRank, points, szPerc, szName);
				else
					if (points < 1000)
						Format(szValue, 128, "%s   %ip       %s     » %s", szRank, points, szPerc, szName);
					else
						if (points < 10000)
							Format(szValue, 128, "%s %ip       %s     » %s", szRank, points, szPerc, szName);
						else
							if (points < 100000)
								Format(szValue, 128, "%s %ip     %s     » %s", szRank, points, szPerc, szName);
							else
								Format(szValue, 128, "%s %ip   %s     » %s", szRank, points, szPerc, szName);

			menu.AddItem(szSteamID, szValue, ITEMDRAW_DEFAULT);
			i++;
		}
		if (i == 1)
		{
			PrintToChat(data, "%t", "NoPlayerTop", MOSSGREEN, g_szChatPrefix, WHITE);
		}
		else
		{
			menu.OptionFlags = MENUFLAG_BUTTON_EXIT;
			menu.Display(data, MENU_TIME_FOREVER);
		}
	}
	else
	{
		PrintToChat(data, "%t", "NoPlayerTop", MOSSGREEN, g_szChatPrefix, WHITE);
	}
}

public void SQL_ViewPlayerProfile2Callback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("[%s] SQL Error (SQL_ViewPlayerProfile2Callback): %s", g_szChatPrefix, error);
		return;
	}

	if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
	{
		SQL_FetchString(hndl, 1, g_szProfileSteamId[data], 32);
		db_viewPlayerRank(data, g_szProfileSteamId[data]);
	}
	else
		if (IsClientInGame(data))
		PrintToChat(data, "%t", "PlayerNotFound", MOSSGREEN, g_szChatPrefix, WHITE, g_szProfileName[data]);
}

public int ProfileMenuHandler(Handle menu, MenuAction action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		switch (item)
		{
			case 0:db_viewRecord(client, g_szProfileSteamId[client], g_szMapName);
			case 1:db_viewChallengeHistory(client, g_szProfileSteamId[client]);
			case 2:db_viewAllRecords(client, g_szProfileSteamId[client]);
			case 3:db_viewUnfinishedMaps(client, g_szProfileSteamId[client]);
			case 4:
			{
				if (g_bRecalcRankInProgess[client])
				{
					PrintToChat(client, "[%c%s%c] %cRecalculation in progress. Please wait!", MOSSGREEN, g_szChatPrefix, WHITE, GRAY);
				}
				else
				{

					g_bRecalcRankInProgess[client] = true;
					PrintToChat(client, "%t", "Rc_PlayerRankStart", MOSSGREEN, g_szChatPrefix, WHITE, GRAY);
					CalculatePlayerRank(client);
				}
			}
		}
	}
	else
		if (action == MenuAction_Cancel)
		{
			if (1 <= client <= MaxClients && IsValidClient(client))
			{
				switch (g_MenuLevel[client])
				{
					case 0:db_selectTopPlayers(client);
					case 3:db_selectTopChallengers(client);
					case 9:db_selectProSurfers(client);
					case 11:db_selectTopProRecordHolders(client);

				}
				if (g_MenuLevel[client] < 0)
				{
					if (g_bSelectProfile[client])
						ProfileMenu(client, 0);
				}
			}
		}
		else
		if (action == MenuAction_End)
		{
			CloseHandle(menu);
		}
}

public int TopPlayersMenuHandler1(Handle menu, MenuAction action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, item, info, sizeof(info));
		g_MenuLevel[client] = 0;
		db_viewPlayerRank(client, info);
	}
	if (action == MenuAction_Cancel)
	{
		ckTopMenu(client);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public int MapMenuHandler1(Handle menu, MenuAction action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, item, info, sizeof(info));
		g_MenuLevel[client] = 1;
		db_viewPlayerRank(client, info);
	}
	if (action == MenuAction_Cancel)
	{
		ckTopMenu(client);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public int MapTopMenuHandler2(Handle menu, MenuAction action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, item, info, sizeof(info));
		g_MenuLevel[client] = 1;
		db_viewPlayerRank(client, info);
	}
}

public void MapMenuHandler2(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, param2, info, sizeof(info));
		g_MenuLevel[param1] = 8;
		db_viewPlayerRank(param1, info);
	}
	if (action == MenuAction_Cancel)
	{
		ckTopMenu(param1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public int MapMenuHandler3(Handle menu, MenuAction action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		char info[32];
		GetMenuItem(menu, item, info, sizeof(info));
		g_MenuLevel[client] = 9;
		db_viewPlayerRank(client, info);
	}
	if (action == MenuAction_Cancel)
	{
		ckTopMenu(client);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public int MenuHandler2(Handle menu, MenuAction action, int client, int param2)
{
	if (action == MenuAction_Cancel || action == MenuAction_Select)
	{
		ProfileMenu(client, -1);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

public int RecordPanelHandler(Handle menu, MenuAction action, int client, int item)
{
	if (action == MenuAction_Select)
	{
		ProfileMenu(client, -1);
	}
}

public void RecordPanelHandler2(Handle menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		ckTopMenu(param1);
	}
} 