#if defined _CKSurf_misc_included
 #endinput
#endif
#define _CKSurf_misc_included

#define MAX_WEAPON_OFFSET		64
#define MAX_WEAPON_SLOTS		6	// hud item selection slots
#define MAX_WEAPON_POSITIONS	20	// max number of items within a slot
#define MAX_WEAPONS				48	// Max number of weapons availabl
#define WEAPON_NOCLIP			-1	// clip sizes set to this tell the weapon it doesn't use a clip
#define	MAX_AMMO_TYPES			32
#define MAX_AMMO_SLOTS 			32	// not really slots
#define MAX_WEAPON_STRING		80
#define MAX_WEAPON_PREFIX		16
#define MAX_WEAPON_AMMO_NAME	32

/*
 * Checks whether the entity is a valid weapon or not.
 *
 * @param weapon		Weapon Entity.
 * @return				True if the entity is a valid weapon, false otherwise.
 */
stock Weapon_IsValid(int weapon)
{
	if (!IsValidEdict(weapon))
	{
		return false;
	}

	return Entity_ClassNameMatches(weapon, "weapon_", true);
}

/**
 * Checks if a client has a specific weapon.
 *
 * @param client 		Client Index.
 * @param className		Weapon Classname.
 * @return				True if client has the weapon, otherwise false.
 */
stock Client_HasWeapon(int client, const char[] className)
{
	int weapon = Client_GetWeapon(client, className);

	return (weapon != INVALID_ENT_REFERENCE);
}

/**
 * Gets the weapon of a client by the weapon's classname.
 *
 * @param client 		Client Index.
 * @param className		Classname of the weapon.
 * @return				Entity index on success or INVALID_ENT_REFERENCE.
 */
stock Client_GetWeapon(int client, const char[] className)
{
	int offset = Client_GetWeaponsOffset(client) - 4;
	int weapon = INVALID_ENT_REFERENCE;
	for (int i=0; i < MAX_WEAPONS; i++)
	{
		offset += 4;

		weapon = GetEntDataEnt2(client, offset);

		if (!Weapon_IsValid(weapon))
		{
			continue;
		}

		if (Entity_ClassNameMatches(weapon, className))
		{
			return weapon;
		}
	}

	return INVALID_ENT_REFERENCE;
}

/**
 * Gets the next weapon of a client, starting at start.
 *
 * @param client		Client Index (must be a valid client ingame).
 * @param index			Reference to an index variable, will contain the index of the next weapon to check.
 * @return				Weapon Index or -1 if no more weapons are found.
 */
stock Client_GetNextWeapon(int client, int &index = 0)
{
	int offset = Client_GetWeaponsOffset(client) + (index * 4);

	int weapon;
	while (index < MAX_WEAPONS)
	{
		index++;

		weapon = GetEntDataEnt2(client, offset);

		if (Weapon_IsValid(weapon))
		{
			return weapon;
		}

		offset += 4;
	}

	return -1;
}

/**
 * Gets the current/active weapon of a client
 *
 * @param client		Client Index.
 * @return				Weapon Index or INVALID_ENT_REFERENCE if the client has no active weapon.
 */
stock Client_GetActiveWeapon(int client)
{
	new weapon =  GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");

	if (!Entity_IsValid(weapon)) {
		return INVALID_ENT_REFERENCE;
	}

	return weapon;
}

/**
 * Gets the offset for a client's weapon list (m_hMyWeapons).
 * The offset will saved globally for optimization.
 *
 * @param client		Client Index.
 * @return				Weapon list offset or -1 on failure.
 */
stock Client_GetWeaponsOffset(int client)
{
	static offset = -1;

	if (offset == -1) {
		offset = FindDataMapInfo(client, "m_hMyWeapons");
	}

	return offset;
}

/**
 * Sets if to draw the client's view model for the client.
 *
 * @param client		Client Index.
 * @param drawViewModel	Set to true if to draw, false otherwise.
 * @noreturn
 */
stock Client_SetDrawViewModel(int client, bool drawViewModel)
{
	SetEntProp(client, Prop_Send, "m_bDrawViewmodel", drawViewModel);
}

/**
 * Sets the client's Score.
 *
 * @param client			Client's index.
 * @param value				Score.
 * @noreturn
 */
stock Client_SetScore(int client, int value)
{
	SetEntProp(client, Prop_Data, "m_iFrags", value);
}

/**
* Finds a player by his name.
* Only returns the first matching player.
*
* @param name			Name to search for.
* @param partOfName		Whether to search for the part of a name or compare the full name.
* @param caseSensitive	If true, comparison is case sensitive. If false (default), comparison is case insensitive.
* @return				Client Index or -1
*/
stock Client_FindByName(const char[] name, bool partOfName = true, bool caseSensitive = false)
{
	char clientName[MAX_NAME_LENGTH];
	for (int client=1; client <= MaxClients; client++)
	{
		if (!IsClientAuthorized(client))
		{
			continue;
		}

		GetClientName(client, clientName, sizeof(clientName));

		if (partOfName)
		{
			if (StrContains(clientName, name, caseSensitive) != -1)
			{
				return client;
			}
		}
		else if (StrEqual(name, clientName, caseSensitive))
		{
			return client;
		}
	}

	return -1;
}

/*
 * Checks if an entity is valid and exists.
 *
 * @param entity		Entity Index.
 * @return				True if the entity is valid, false otherwise.
 */
stock Entity_IsValid(int entity)
{
	return IsValidEntity(entity);
}

/**
 * Searches for an entity by classname.
 * This is a wrapper around FindEntityByClassname
 * and has been added for completion.
 *
 * @param startEnt		The entity index after which to begin searching from. Use -1 to start from the first entity.
 * @param classname		Classname of the entity to find.
 * @return				Entity index >= 0 if found, -1 otherwise.
 */

stock Entity_FindByClassName(int startEntity, const char[] className)
{
	return FindEntityByClassname(startEntity, className);
}

/**
 * Gets the Classname of an entity.
 * This is like GetEdictClassname(), except it works for ALL
 * entities, not just edicts.
 *
 * @param entity			Entity index.
 * @param buffer			Return/Output buffer.
 * @param size				Max size of buffer.
 * @return					Number of non-null bytes written.
 */
stock Entity_GetClassName(int entity, char[] buffer, int size)
{
	return GetEntPropString(entity, Prop_Data, "m_iClassname", buffer, size);
}

/**
 * Checks if an entity (partially) matches a specific entity class.
 *
 * @param entity		Entity Index.
 * @param className		Classname String.
 * @partialMatch		If to do a partial classname check.
 * @return				True if the classname matches, false otherwise.
 */
stock bool Entity_ClassNameMatches(int entity, const char[] className, partialMatch = false)
{
	char entity_className[64];
	Entity_GetClassName(entity, entity_className, sizeof(entity_className));

	if (partialMatch)
	{
		return (StrContains(entity_className, className) != -1);
	}

	return StrEqual(entity_className, className);
}

/**
 * Gets the Absolute velocity of an entity.
 * The absolute velocity is the sum of the local
 * and base velocities. It's the actual value used to move.
 *
 * @param entity		Entity index.
 * @param vel			An 3 dim array
 * @noreturn
 */
stock Entity_GetAbsVelocity(int entity, float vec[3])
{
	GetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", vec);
}

/**
 * Sets an entity's color.
 * Doesn't change the value, if set to -1.
 *
 * @param entity	Entity index
 * @param r 		Amount of red (0-255)
 * @param g 		Amount of green (0-255)
 * @param b 		Amount of blue (0-255)
 * @param a 		Amount of alpha (0-255)
 * @noreturn
 * @error			Invalid entity index, or lack of mod compliance.
 */
stock Entity_SetRenderColor(int entity, int r = -1, int g = -1, int b = -1, int a = -1)
{
	static bool gotconfig = false;
	static char prop[32];

	if (!gotconfig)
	{
		Handle gc = LoadGameConfigFile("core.games");
		bool exists = GameConfGetKeyValue(gc, "m_clrRender", prop, sizeof(prop));
		CloseHandle(gc);

		if (!exists)
		{
			strcopy(prop, sizeof(prop), "m_clrRender");
		}

		gotconfig = true;
	}

	int offset = GetEntSendPropOffs(entity, prop);

	if (offset <= 0)
	{
		ThrowError("SetEntityRenderColor not supported by this mod");
	}

	if (r != -1)
	{
		SetEntData(entity, offset, r, 1, true);
	}

	if (g != -1)
	{
		SetEntData(entity, offset + 1, g, 1, true);
	}

	if (b != -1)
	{
		SetEntData(entity, offset + 2, b, 1, true);
	}

	if (a != -1)
	{
		SetEntData(entity, offset + 3, a, 1, true);
	}
}

/*
 * Copies file source to destination
 * Based on code of javalia:
 * http://forums.alliedmods.net/showthread.php?t=159895
 *
 * @param source		Input file
 * @param destination	Output file
 */
stock bool File_Copy(const char[] source, const char[] destination)
{
	Handle file_source = OpenFile(source, "rb");

	if (file_source == INVALID_HANDLE)
	{
		return false;
	}

	Handle file_destination = OpenFile(destination, "wb");

	if (file_destination == INVALID_HANDLE)
	{
		CloseHandle(file_source);
		return false;
	}

	int buffer[32];
	int cache;

	while (!IsEndOfFile(file_source))
	{
		cache = ReadFile(file_source, buffer, 32, 1);
		WriteFile(file_destination, buffer, cache, 1);
	}

	CloseHandle(file_source);
	CloseHandle(file_destination);

	return true;
}

/**
 * Copies a 1 dimensional static array.
 *
 * @param array			Static Array to copy from.
 * @param newArray		New Array to copy to.
 * @param size			Size of the array (or number of cells to copy)
 * @noreturn
 */
stock void Array_Copy(const any[] array, any[] newArray, int size)
{
	for (int i = 0; i < size; i++)
	{
		newArray[i] = array[i];
	}
}