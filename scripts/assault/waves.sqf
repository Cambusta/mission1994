dnct_fnc_wave = {
	_center = param[0, [0,0,0]];
	_waveNumber = param[1, 0];

	[_waveNumber] spawn dnct_fnc_onWaveStart;

	_createdUnits = [_center, _waveNumber] call dnct_fnc_createWaveUnits;
	[_createdUnits] spawn dnct_fnc_preventIdling;

	// Main wave loop
	while { [_createdUnits] call dnct_fnc_hasAlive && [(call BIS_fnc_listPlayers)] call dnct_fnc_hasAlive } do 
	{
		sleep 15;
		{ _x spawn dnct_fnc_assignGroupSADWaypoint; } foreach call dnct_fnc_getEnemyGroups;
	};

	// Handle wave completion
	if ([(call BIS_fnc_listPlayers)] call dnct_fnc_hasAlive) then {
		[_waveNumber, true] spawn dnct_fnc_onWaveEnd;
	} else {
		[_waveNumber, false] spawn dnct_fnc_onWaveEnd;
	};
};

dnct_fnc_createWaveUnits = {
	_center = param[0, [0,0,0]];
	_waveNumber = param[1, 0];

	_waveUnits = [];
	for "_i" from 1 to _waveNumber do {
		_units = [_center, INFANTRY_BASIC, 10] call dnct_fnc_createSquad;
		_waveUnits append _units;
	};

	_waveUnits
};

dnct_fnc_generateRoster = {
	_unitTypes = param[0, []];
	_unitCount = param[1, 4];

	_roster = [];

	for "_i" from 1 to _unitCount do {
		_role = [_unitTypes] call dnct_fnc_selectWithProbability;
		_roster pushBack _role;
	};

	_roster
};

dnct_fnc_createSquad = {
	_center = param[0, [0,0,0]];
	_unitClasses = param[1, []];
	_unitCount = param[2, 0];

	_location = [_center, SAFEZONE_AREA, SAFEZONE_AREA_EXTENSION, 10] call BIS_fnc_findSafePos;
	_roster = [_unitClasses, _unitCount] call dnct_fnc_generateRoster;
	_squad = [_location, ENEMY_SIDE, _roster] call BIS_fnc_spawnGroup;
	_squad allowFleeing 0;
	_squad spawn dnct_fnc_assignGroupSADWaypoint; 

	_units = units _squad;
	_units
};

dnct_fnc_createCrowd = {
	_center = param[0, [0,0,0]];
	_unitClasses = param[1, []];
	_unitCount = param[2, 0];
		
	_location = [_center, SAFEZONE_AREA, SAFEZONE_AREA_EXTENSION, 10] call BIS_fnc_findSafePos;
	_roster = [_unitClasses, _unitCount] call dnct_fnc_generateRoster;	
	_crowd = [];

	{
		_group = createGroup [ENEMY_SIDE, true];
		_class = _x;

		_unit = _group createUnit [_class, _location, [], 0.5, "NONE"];
		sleep 0.5;

		// Simulate "berserk mode" for some of the unorganized troops
		if (random 1 < 0.2) then {
			_unit disableAI "AUTOCOMBAT";
		};

		_group allowFleeing 0;
		_group spawn dnct_fnc_assignGroupSADWaypoint;
		_crowd pushBack _unit;
	} foreach _roster;

	_crowd
};
