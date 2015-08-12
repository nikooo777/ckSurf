//button hook
public Action:NormalSHook_callback(clients[64], &numClients, String:sample[PLATFORM_MAX_PATH], &entity, &channel, &Float:volume, &level, &pitch, &flags)
{
    if(entity > MaxClients)
    {
        new String:clsname[20]; GetEntityClassname(entity, clsname, sizeof(clsname));
        if(StrEqual(clsname, "func_button", false))
        {
            return Plugin_Handled;
        }
    }
    return Plugin_Continue;
}  

//attack spam protection
public Action:Event_OnFire(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client   = GetClientOfUserId(GetEventInt(event, "userid"));
	if (client > 0 && IsClientInGame(client) && g_bAttackSpamProtection) 
	{
		decl String: weapon[64];
		GetEventString(event, "weapon", weapon, 64);
		if (StrContains(weapon,"knife",true) == -1 && g_AttackCounter[client] < 41)
		{	
			if (g_AttackCounter[client] < 41)
			{
				g_AttackCounter[client]++;
				if (StrContains(weapon,"grenade",true) != -1 || StrContains(weapon,"flash",true) != -1)
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
public Action:Event_OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(client != 0)
	{	
		PlayerSpawn(client);
	}
	return Plugin_Continue;
}

PlayerSpawn(client)
{
	if (!IsValidClient(client))
		return;

	g_fStartCommandUsed_LastTime[client] = GetEngineTime();
	g_SpecTarget[client] = -1;	
	g_bPause[client] = false;
	g_bFirstButtonTouch[client]=true;
	SetEntityMoveType(client, MOVETYPE_WALK);
	SetEntityRenderMode(client, RENDER_NORMAL);
	
	//strip weapons
	if ((GetClientTeam(client) > 1) && IsValidClient(client))
	{			
		StripAllWeapons(client);
		if (!IsFakeClient(client))
			GivePlayerItem(client, "weapon_usp_silencer");
		if (!g_bStartWithUsp[client])
		{
			new weapon = GetPlayerWeaponSlot(client, 2);
			if (weapon != -1 && !IsFakeClient(client))
				 SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);
		}
	}	

	//godmode
	if (g_bgodmode || IsFakeClient(client))
		SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);
	else
		SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
		
	//NoBlock
	if(g_bNoBlock || IsFakeClient(client))
		SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 2, 4, true);
	else
		SetEntData(client, FindSendPropOffs("CBaseEntity", "m_CollisionGroup"), 5, 4, true);
						
	//botmimic2		
	if(g_hBotMimicsRecord[client] != INVALID_HANDLE && IsFakeClient(client))
	{
		g_BotMimicTick[client] = 0;
		g_CurrentAdditionalTeleportIndex[client] = 0;
	}	
	
	if (IsFakeClient(client))	
	{
		if (client==g_InfoBot)
			CS_SetClientClanTag(client, ""); 	
		else
			CS_SetClientClanTag(client, "LOCALHOST"); 	
		return;
	}
	
	//change player skin
	if (g_bPlayerSkinChange && (GetClientTeam(client) > 1))
	{
		SetEntPropString(client, Prop_Send, "m_szArmsModel", g_sArmModel);
		SetEntityModel(client,  g_sPlayerModel);
	}		

	//1st spawn & t/ct
	if (g_bFirstSpawn[client] && (GetClientTeam(client) > 1))		
	{
		StartRecording(client);
		CreateTimer(1.5, CenterMsgTimer, client,TIMER_FLAG_NO_MAPCHANGE);		
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
				TeleportEntity(client, g_fPlayerCordsRestore[client],g_fPlayerAnglesRestore[client],NULL_VECTOR);
				g_bRestorePosition[client]  = false;
			}
			else
				if (g_bRespawnPosition[client])
				{
					TeleportEntity(client, g_fPlayerCordsRestore[client],g_fPlayerAnglesRestore[client],NULL_VECTOR);
					g_bRespawnPosition[client] = false;
				}
				else
					if (g_bAutoTimer)
					{
						if (bSpawnToStartZone) 
							Command_Restart(client, 1);

						CreateTimer(0.1, StartTimer, client,TIMER_FLAG_NO_MAPCHANGE);			
					}
					else
					{
						g_bTimeractivated[client] = false;	
						g_fStartTime[client] = -1.0;
						g_fCurrentRunTime[client] = -1.0;	

						// Spawn client to the start zone.
						if (bSpawnToStartZone) 
							Command_Restart(client, 1);
					}	
		}
	}
	else
	{
		SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,-100.0});
		TeleportEntity(client, g_fTeleLocation[client],NULL_VECTOR,Float:{0.0,0.0,-100.0});
		g_specToStage[client] = false;
	}
	
	//hide radar
	CreateTimer(0.0, HideRadar, client,TIMER_FLAG_NO_MAPCHANGE);
	
	//set clantag
	CreateTimer(1.5, SetClanTag, client,TIMER_FLAG_NO_MAPCHANGE);	
			
	//set speclist
	Format(g_szPlayerPanelText[client], 512, "");		

	//get speed & origin
	g_fLastSpeed[client] = GetSpeed(client);
	GetClientAbsOrigin(client, g_fLastPosition[client]);	
}

public Action:Say_Hook(client, const String:command[], argc)
{
	//Call Admin - Own Reason
	if (g_bClientOwnReason[client])
	{
		StopClimbersMenu(client);
		g_bClientOwnReason[client] = false;
		return Plugin_Continue;
	}

	new Float:messageTime = GetEngineTime();
	
	//Chat trigger?
	g_bSayHook[client]=true;
	if (IsValidClient(client))
	{
		if (BaseComm_IsClientGagged(client))
			return Plugin_Handled;

		if ((messageTime - g_fLastChatMessage[client]) < g_fChatSpamFilter)
		{
			return Plugin_Handled;
		}

		g_fLastChatMessage[client] = messageTime;
		decl String:sText[1024];
		GetCmdArgString(sText, sizeof(sText));
		StripQuotes(sText);
		new team = GetClientTeam(client);		
		TrimString(sText); 
		
		ReplaceString(sText,1024,"{darkred}","",false);
		ReplaceString(sText,1024,"{green}","",false);
		ReplaceString(sText,1024,"{lightgreen}","",false);
		ReplaceString(sText,1024,"{blue}","",false);
		ReplaceString(sText,1024,"{olive}","",false);
		ReplaceString(sText,1024,"{lime}","",false);
		ReplaceString(sText,1024,"{red}","",false);
		ReplaceString(sText,1024,"{purple}","",false);
		ReplaceString(sText,1024,"{grey}","",false);
		ReplaceString(sText,1024,"{yellow}","",false);
		ReplaceString(sText,1024,"{lightblue}","",false);
		ReplaceString(sText,1024,"{steelblue}","",false);
		ReplaceString(sText,1024,"{darkblue}","",false);
		ReplaceString(sText,1024,"{pink}","",false);
		ReplaceString(sText,1024,"{lightred}","",false);

		//empty message
		if(StrEqual(sText, " ") || StrEqual(sText, ""))
		{
			g_bSayHook[client]=false;
			return Plugin_Handled;		
		}

		//lowercase
		if((sText[0] == '/') || (sText[0] == '!'))
		{
			if(IsCharUpper(sText[1]))
			{
				for(new i = 0; i <= strlen(sText); ++i)
						sText[i] = CharToLower(sText[i]);
				g_bSayHook[client]=false;
				FakeClientCommand(client, "say %s", sText);
				return Plugin_Handled;
			}
		}
		
		//blocked commands
		for(new i = 0; i < sizeof(g_BlockedChatText); i++)
		{
			if (StrEqual(g_BlockedChatText[i],sText,true))
			{
				g_bSayHook[client]=false;
				return Plugin_Handled;			
			}
		}

		// !s and !stage commands
		if (strlen(sText)>2 &&strlen(sText)<=5)
		{
			if (sText[0]=='!' && sText[1]=='s')
			{
				g_bSayHook[client]=false;
				return Plugin_Handled;	
			}
		}
		if (strlen(sText)>6 &&strlen(sText)<=9)
		{
			if (sText[0]=='!' && sText[1]=='s' && sText[2]=='t' && sText[3]=='a' && sText[4]=='g' && sText[5]=='e')
			{
				g_bSayHook[client]=false;
				return Plugin_Handled;	
			}
		}
		
		//chat trigger?
		if((IsChatTrigger() && sText[0] == '/') || (sText[0] == '@' && (GetUserFlagBits(client) & ADMFLAG_ROOT ||  GetUserFlagBits(client) & ADMFLAG_GENERIC)))
		{
			g_bSayHook[client]=false;
			return Plugin_Continue;
		}

		decl String:szName[64];
		GetClientName(client,szName,64);		
		ReplaceString(szName,64,"{darkred}","",false);
		ReplaceString(szName,64,"{green}","",false);
		ReplaceString(szName,64,"{lightgreen}","",false);
		ReplaceString(szName,64,"{blue}","",false);
		ReplaceString(szName,64,"{olive}","",false);
		ReplaceString(szName,64,"{lime}","",false);
		ReplaceString(szName,64,"{red}","",false);
		ReplaceString(szName,64,"{purple}","",false);
		ReplaceString(szName,64,"{grey}","",false);
		ReplaceString(szName,64,"{yellow}","",false);
		ReplaceString(szName,64,"{lightblue}","",false);
		ReplaceString(szName,64,"{steelblue}","",false);
		ReplaceString(szName,64,"{darkblue}","",false);
		ReplaceString(szName,64,"{pink}","",false);
		ReplaceString(szName,64,"{lightred}","",false);
		////////////////
		//say stuff
		//
		//SPEC

		/*#define WHITE 0x01
		#define DARKRED 0x02
		#define PURPLE 0x03
		#define GREEN 0x04
		#define MOSSGREEN 0x05
		#define LIMEGREEN 0x06
		#define RED 0x07
		#define GRAY 0x08
		#define YELLOW 0x09
		#define DARKGREY 0x0A
		#define BLUE 0x0B
		#define DARKBLUE 0x0C
		#define LIGHTBLUE 0x0D
		#define PINK 0x0E
		#define LIGHTRED 0x0F
		*/

		if (g_bPointSystem && g_bColoredNames)
		{
			switch(g_PlayerChatRank[client])
			{
				case 0: // 1st Rank
					Format(szName, 64, "%c%s", WHITE, szName);
				case 1:
					Format(szName, 64, "%c%s", WHITE, szName);
				case 2:
					Format(szName, 64, "%c%s", GRAY, szName);
				case 3:
					Format(szName, 64, "%c%s", LIGHTBLUE, szName);
				case 4:
					Format(szName, 64, "%c%s", BLUE, szName);
				case 5:
					Format(szName, 64, "%c%s", DARKBLUE, szName);
				case 6:
					Format(szName, 64, "%c%s", PINK, szName);
				case 7:
					Format(szName, 64, "%c%s", LIGHTRED, szName);
				case 8: // Highest rank
					Format(szName, 64, "%c%s", DARKRED, szName);
			/*	case 9: // Admin
					Format(szName, 64, "%c%s", GREEN, szName);
				case 10: // VIP
					Format(szName, 64, "%c%s", MOSSGREEN, szName);
				case 11: // Mapper
					Format(szName, 64, "%c%s", YELLOW, szName);*/
			}
		}

		if (team==1)
		{
			PrintSpecMessageAll(client);
			g_bSayHook[client]=false;
			return Plugin_Handled;
		}
		else
		{
			decl String:szChatRank[64];
			Format(szChatRank, 64, "%s",g_pr_chat_coloredrank[client]);			
			
			if (g_bCountry && (g_bPointSystem || ((StrEqual(g_pr_rankname[client], "ADMIN", false)) && g_bAdminClantag) || ((StrEqual(g_pr_rankname[client], "VIP", false)) && g_bVipClantag)))
			{						
				if (StrEqual(sText,""))
				{
					g_bSayHook[client]=false;
					return Plugin_Handled;
				}
				if (IsPlayerAlive(client))
					CPrintToChatAllEx(client,"{green}%s{default} %s {teamcolor}%s{default}: %s",g_szCountryCode[client],szChatRank,szName,sText);			
				else
					CPrintToChatAllEx(client,"{green}%s{default} %s {teamcolor}*DEAD* %s{default}: %s",g_szCountryCode[client],szChatRank,szName,sText);
				g_bSayHook[client]=false;				
				return Plugin_Handled;
			}
			else
			{
				if (g_bPointSystem || ((StrEqual(g_pr_rankname[client], "ADMIN", false)) && g_bAdminClantag) || ((StrEqual(g_pr_rankname[client], "VIP", false)) && g_bVipClantag))
				{
					if (StrEqual(sText,""))
					{
						g_bSayHook[client]=false;
						return Plugin_Handled;
					}
					if (IsPlayerAlive(client))
						CPrintToChatAllEx(client,"%s {teamcolor}%s{default}: %s",szChatRank,szName,sText);	
					else
						CPrintToChatAllEx(client,"%s {teamcolor}*DEAD* %s{default}: %s",szChatRank,szName,sText);
					g_bSayHook[client]=false;						
					return Plugin_Handled;							
				}
				else
					if (g_bCountry)
					{
						if (StrEqual(sText,""))
						{
							g_bSayHook[client]=false;
							return Plugin_Handled;
						}
						if (IsPlayerAlive(client))
							CPrintToChatAllEx(client,"[{green}%s{default}] {teamcolor}%s{default}: %s",g_szCountryCode[client],szName,sText);	
						else
							CPrintToChatAllEx(client,"[{green}%s{default}] {teamcolor}*DEAD* %s{default}: %s",g_szCountryCode[client],szName,sText);		
						g_bSayHook[client]=false;
						return Plugin_Handled;							
					}								
			}
		}	
	}
	g_bSayHook[client]=false;
	return Plugin_Continue;
}

public Action:Event_OnPlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!IsValidClient(client) || IsFakeClient(client))
		return Plugin_Continue;
	new team = GetEventInt(event, "team");
	if(team == 1)
	{
		SpecListMenuDead(client);
		if (!g_bFirstSpawn[client])
		{
			GetClientAbsOrigin(client,g_fPlayerCordsRestore[client]);
			GetClientEyeAngles(client, g_fPlayerAnglesRestore[client]);
			g_bRespawnPosition[client] = true;
		}
		if (g_bTimeractivated[client])
		{	
			g_fStartPauseTime[client] = GetEngineTime();
			if (g_fPauseTime[client] > 0.0)
				g_fStartPauseTime[client] = g_fStartPauseTime[client] - g_fPauseTime[client];	
		}
		g_bSpectate[client] = true;
		if (g_bPause[client])
			g_bPauseWasActivated[client]=true;
		g_bPause[client]=false;
	}
	return Plugin_Continue;
}

public Action:Event_PlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_bDisconnectMsg)
	{
		decl String:szName[64];
		decl String:disconnectReason[64];
		new clientid = GetEventInt(event,"userid");
		new client = GetClientOfUserId(clientid);
		if (!IsValidClient(client) || IsFakeClient(client))
			return Plugin_Handled;
		GetEventString(event, "name", szName, sizeof(szName));
		GetEventString(event, "reason", disconnectReason, sizeof(disconnectReason));  
		for (new i = 1; i <= MaxClients; i++)
			if (IsValidClient(i) && i != client && !IsFakeClient(i))
				PrintToChat(i, "%t", "Disconnected1",WHITE, MOSSGREEN, szName, WHITE, disconnectReason);	
		return Plugin_Handled;
	}
	else
	{
		SetEventBroadcast(event, true);
		return Plugin_Handled;
	}
}

public Action:Hook_SetTransmit(entity, client) 
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

public Action:Event_OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetEventInt(event,"userid");
	if (IsValidClient(client))
	{
		if (!IsFakeClient(client))
		{
			if(g_hRecording[client] != INVALID_HANDLE)
				StopRecording(client);			
			CreateTimer(2.0, RemoveRagdoll, client);
		}
		else 
			if(g_hBotMimicsRecord[client] != INVALID_HANDLE)
			{
				g_BotMimicTick[client] = 0;
				g_CurrentAdditionalTeleportIndex[client] = 0;
				if(GetClientTeam(client) >= CS_TEAM_T)
					CreateTimer(1.0, RespawnBot, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
			}
	}
	return Plugin_Continue;
}
					
public Action:CS_OnTerminateRound(&Float:delay, &CSRoundEndReason:reason)
{
	new timeleft;
	GetMapTimeLeft(timeleft);
	if (timeleft>= -1 && !g_bAllowRoundEndCvar)
		return Plugin_Handled;
	return Plugin_Continue;
} 

public Action:Event_OnRoundEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	g_bRoundEnd=true;
	return Plugin_Continue;
}

public OnPlayerThink(entity)
{
	SetEntPropEnt(entity, Prop_Send, "m_bSpotted", 0); 
}


// OnRoundRestart
public Action:Event_OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iEnt;
	for(new i = 0; i < sizeof(EntityList); i++)
	{
		while((iEnt = FindEntityByClassname(iEnt, EntityList[i])) != -1)
		{
			AcceptEntityInput(iEnt, "Disable");
			AcceptEntityInput(iEnt, "Kill");
		}
	}
	
	g_bRoundEnd=false;
	RefreshZones();
	return Plugin_Continue; 
}

// PlayerHurt 
public Action:Event_OnPlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (!g_bgodmode && g_Autohealing_Hp > 0)
	{
		new client = GetClientOfUserId(GetEventInt(event, "userid"));
		new remainingHeatlh = GetEventInt(event, "health");
		if (remainingHeatlh>0)
		{
			if ((remainingHeatlh+g_Autohealing_Hp) > 100)
				SetEntData(client, FindSendPropOffs("CBasePlayer", "m_iHealth"), 100);
			else
				SetEntData(client, FindSendPropOffs("CBasePlayer", "m_iHealth"), remainingHeatlh+g_Autohealing_Hp);
		}
	}
	return Plugin_Continue; 
}

// PlayerDamage (if godmode 0)
public Action:Hook_OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if (g_bgodmode)
		return Plugin_Handled;
	return Plugin_Continue;
}


//thx to TnTSCS (player slap stops timer)
//https://forums.alliedmods.net/showthread.php?t=233966
public Action:OnLogAction(Handle:source, Identity:ident, client, target, const String:message[])
{	
    if ((1 > target > MaxClients))
        return Plugin_Continue;
    if (IsValidClient(target) && IsPlayerAlive(target) && g_bTimeractivated[target] && !IsFakeClient(target))
	{
		decl String:logtag[PLATFORM_MAX_PATH];
		if (ident == Identity_Plugin)
			GetPluginFilename(source, logtag, sizeof(logtag));
		else
			Format(logtag, sizeof(logtag), "OTHER");
		
		if ((strcmp("playercommands.smx", logtag, false) == 0) ||(strcmp("slap.smx", logtag, false) == 0))
			Client_Stop(target, 0);
	}   
    return Plugin_Continue;
}  

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	
	if (g_bRoundEnd || !IsValidClient(client))
		return Plugin_Continue;	

	if(IsPlayerAlive(client))	
	{
		decl Float:speed, Float:origin[3],Float:ang[3];
		g_CurrentButton[client] = buttons;
		GetClientAbsOrigin(client, origin);
		GetClientEyeAngles(client, ang);		

		speed = GetSpeed(client);		
		if (GetEntityFlags(client) & FL_ONGROUND)
			g_bOnGround[client]=true;
		else
			g_bOnGround[client]=false;
		
		//menu refreshing
		MenuTitleRefreshing(client);

		PlayReplay(client, buttons, subtype, seed, impulse, weapon, angles, vel);
		RecordReplay(client, buttons, subtype, seed, impulse, weapon, angles, vel);
		AutoBhopFunction(client, buttons);
		NoClipCheck(client);
		AttackProtection(client, buttons);
		HookCheck(client);

		// If in start zone, cap speed
		if (g_binStartZone[client])
			LimitSpeed(client, 0);
		else
			if (g_binSpeedZone[client])
				LimitSpeed(client, 1);
			else
				if (g_binBonusStartZone[client])
					LimitSpeed(client, 2);


		if (g_bOnGround[client])
		{
			g_bBeam[client] = false;
		}		
		g_fLastAngles[client] = ang;
		g_fLastSpeed[client] = speed;
		g_fLastPosition[client] = origin;
		g_LastButton[client] = buttons;

		BeamBox_OnPlayerRunCmd(client);
	}
	return Plugin_Continue;
}

public Action:Event_OnJump(Handle:Event, const String:Name[], bool:Broadcast)
{
	decl client;
	client = GetClientOfUserId(GetEventInt(Event, "userid"));	
	g_bBeam[client]=true;
	
	//noclip check
	decl Float: flEngineTime;
	flEngineTime = GetEngineTime();
	decl Float:flDiff;
	flDiff = flEngineTime - g_fLastTimeNoClipUsed[client];
	if (flDiff < 4.0)
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, Float:{0.0,0.0,-100.0});
}
		
			
public Hook_PostThinkPost(entity)
{
	SetEntProp(entity, Prop_Send, "m_bInBuyZone", 0);
} 

public Action:Event_JoinTeamFailed(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!client || !IsClientInGame(client))
		return Plugin_Continue;
	new EJoinTeamReason:m_eReason = EJoinTeamReason:GetEventInt(event, "reason");
	new m_iTs = GetTeamClientCount(CS_TEAM_T);
	new m_iCTs = GetTeamClientCount(CS_TEAM_CT);
	switch(m_eReason)
	{
		case k_OneTeamChange:
		{
			return Plugin_Continue;
		}

		case k_TeamsFull:
		{
			if(m_iCTs == g_CTSpawns && m_iTs == g_TSpawns)
				return Plugin_Continue;
		}
		case k_TTeamFull:
		{
			if(m_iTs == g_TSpawns)
				return Plugin_Continue;
		}
		case k_CTTeamFull:
		{
			if(m_iCTs == g_CTSpawns)
				return Plugin_Continue;
		}
		default:
		{
			return Plugin_Continue;
		}
	}
	ChangeClientTeam(client, g_SelectedTeam[client]);

	return Plugin_Handled;
}
