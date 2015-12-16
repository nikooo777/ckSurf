ALTER TABLE ck_zones ADD zonegroup INT NOT NULL DEFAULT 0;
ALTER TABLE ck_zones ADD zonename VARCHAR(128);
ALTER TABLE ck_playertemp ADD zonegroup INT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS ck_playertitles (steamid VARCHAR(32), vip INT(12) DEFAULT 0, mapper INT(12) DEFAULT 0, teacher INT(12) DEFAULT 0, custom1 INT(12) DEFAULT 0, custom2 INT(12) DEFAULT 0, custom3 INT(12) DEFAULT 0, custom4 INT(12) DEFAULT 0, custom5 INT(12) DEFAULT 0, custom6 INT(12) DEFAULT 0, custom7 INT(12) DEFAULT 0, custom8 INT(12) DEFAULT 0, custom9 INT(12) DEFAULT 0, custom10 INT(12) DEFAULT 0, custom11 INT(12) DEFAULT 0, custom12 INT(12) DEFAULT 0, custom13 INT(12) DEFAULT 0, custom14 INT(12) DEFAULT 0, custom15 INT(12) DEFAULT 0, custom16 INT(12) DEFAULT 0, custom17 INT(12) DEFAULT 0, custom18 INT(12) DEFAULT 0, custom19 INT(12) DEFAULT 0, custom20 INT(12) DEFAULT 0, inuse INT(12) DEFAULT 0, PRIMARY KEY(steamid));

ALTER TABLE ck_checkpoints RENAME TO ck_checkpoints_temp;
CREATE TABLE IF NOT EXISTS ck_checkpoints (steamid VARCHAR(32), mapname VARCHAR(32), cp1 FLOAT DEFAULT '0.0', cp2 FLOAT DEFAULT '0.0', cp3 FLOAT DEFAULT '0.0', cp4 FLOAT DEFAULT '0.0', cp5 FLOAT DEFAULT '0.0', cp6 FLOAT DEFAULT '0.0', cp7 FLOAT DEFAULT '0.0', cp8 FLOAT DEFAULT '0.0', cp9 FLOAT DEFAULT '0.0', cp10 FLOAT DEFAULT '0.0', cp11 FLOAT DEFAULT '0.0', cp12 FLOAT DEFAULT '0.0', cp13 FLOAT DEFAULT '0.0', cp14 FLOAT DEFAULT '0.0', cp15 FLOAT DEFAULT '0.0', cp16 FLOAT DEFAULT '0.0', cp17  FLOAT DEFAULT '0.0', cp18 FLOAT DEFAULT '0.0', cp19 FLOAT DEFAULT '0.0', cp20  FLOAT DEFAULT '0.0', cp21 FLOAT DEFAULT '0.0', cp22 FLOAT DEFAULT '0.0', cp23 FLOAT DEFAULT '0.0', cp24 FLOAT DEFAULT '0.0', cp25 FLOAT DEFAULT '0.0', cp26 FLOAT DEFAULT '0.0', cp27 FLOAT DEFAULT '0.0', cp28 FLOAT DEFAULT '0.0', cp29 FLOAT DEFAULT '0.0', cp30 FLOAT DEFAULT '0.0', cp31 FLOAT DEFAULT '0.0', cp32  FLOAT DEFAULT '0.0', cp33 FLOAT DEFAULT '0.0', cp34 FLOAT DEFAULT '0.0', cp35 FLOAT DEFAULT '0.0', zonegroup INT(12) NOT NULL DEFAULT 0, PRIMARY KEY(steamid, mapname, zonegroup));
INSERT INTO ck_checkpoints(steamid, mapname, zonegroup, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20) SELECT steamid, mapname, 0, cp1, cp2, cp3, cp4, cp5, cp6, cp7, cp8, cp9, cp10, cp11, cp12, cp13, cp14, cp15, cp16, cp17, cp18, cp19, cp20 FROM ck_checkpoints_temp GROUP BY mapname, steamid;
DROP TABLE ck_checkpoints_temp;

ALTER TABLE ck_bonus RENAME TO ck_bonus_temp;
CREATE TABLE IF NOT EXISTS ck_bonus (steamid VARCHAR(32), name VARCHAR(32), mapname VARCHAR(32), runtime FLOAT NOT NULL DEFAULT '-1.0', zonegroup INT(12) NOT NULL DEFAULT 1, PRIMARY KEY(steamid, mapname, zonegroup));
INSERT INTO ck_bonus(steamid, name, mapname, runtime) SELECT steamid, name, mapname, runtime FROM ck_bonus_temp;
DROP TABLE ck_bonus_temp;

DROP TABLE IF EXISTS ck_playertemp;
CREATE TABLE IF NOT EXISTS ck_playertemp (steamid VARCHAR(32), mapname VARCHAR(32), cords1 FLOAT NOT NULL DEFAULT '-1.0', cords2 FLOAT NOT NULL DEFAULT '-1.0', cords3 FLOAT NOT NULL DEFAULT '-1.0', angle1 FLOAT NOT NULL DEFAULT '-1.0',angle2 FLOAT NOT NULL DEFAULT '-1.0',angle3 FLOAT NOT NULL DEFAULT '-1.0', EncTickrate INT(12) DEFAULT '-1.0', runtimeTmp FLOAT NOT NULL DEFAULT '-1.0', Stage INT, zonegroup INT NOT NULL DEFAULT 0, PRIMARY KEY(steamid,mapname));

ALTER TABLE ck_maptier ADD btier1 INT;
ALTER TABLE ck_maptier ADD btier2 INT;
ALTER TABLE ck_maptier ADD btier3 INT;
ALTER TABLE ck_maptier ADD btier4 INT;
ALTER TABLE ck_maptier ADD btier5 INT;
ALTER TABLE ck_maptier ADD btier6 INT;
ALTER TABLE ck_maptier ADD btier7 INT;
ALTER TABLE ck_maptier ADD btier8 INT;
ALTER TABLE ck_maptier ADD btier9 INT;
ALTER TABLE ck_maptier ADD btier10 INT;

ALTER TABLE ck_spawnlocations RENAME TO ck_spawnlocations_temp;
CREATE TABLE IF NOT EXISTS ck_spawnlocations (mapname VARCHAR(54) NOT NULL, pos_x FLOAT NOT NULL, pos_y FLOAT NOT NULL, pos_z FLOAT NOT NULL, ang_x FLOAT NOT NULL, ang_y FLOAT NOT NULL, ang_z FLOAT NOT NULL, zonegroup INT(12) DEFAULT 0, stage INT(12) DEFAULT 0, PRIMARY KEY(mapname, zonegroup));
INSERT INTO ck_spawnlocations (mapname, pos_x, pos_y, pos_z, ang_x, ang_y, ang_z) SELECT mapname, pos_x, pos_y, pos_z, ang_x, ang_y, ang_z FROM ck_spawnlocations_temp;
DROP TABLE ck_spawnlocations_temp;

UPDATE ck_zones SET zonegroup = 1 WHERE zonetype = 3 OR zonetype = 4;
UPDATE ck_zones SET zonetypeid = 0 WHERE zonetype = 3 OR zonetype = 4;
UPDATE ck_zones SET zonetype = 1 WHERE zonetype = 3;
UPDATE ck_zones SET zonetype = 2 WHERE zonetype = 4;
UPDATE ck_zones SET zonetype = zonetype-2 WHERE zonetype > 4;
