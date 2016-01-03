<?php

/*----------  First, comment out the database you are NOT using:  ----------*/

//define("DB", "SQLITE");
define("DB", "MYSQL");

/*----------  Then, set up your database information bellow, depending on which database you use  ----------*/

///////////////////////////////////////////////////////////////////////////////

/*======================================
=            MySQL Settings            =
======================================*/

$DB_ADDRESS = 'Database Address';
$DB_USER = 'Database User';
$DB_PASS = 'Database Password';
$DB_DATABASE = 'Database to Use';

/*=====  End of MySQL Settings  ======*/


///////////////////////////////////////////////////////////////////////////////

/*=======================================
=            SQLITE Settings            =
=======================================*/

// Path to your servers .sq3 file (usually in the /addons/sourcemod/data/sqlite folder)
$DB_PATH = '/home/cs/serverfiles/csgo/addons/sourcemod/data/sqlite/ckSurf.sq3';

/*=====  End of SQLITE Settings  ======*/


?>