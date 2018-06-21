dnct_fnc_wave = {
	_center = param[0, [0,0,0]];
	_attackNumber = param[1, 0];
	_waveNumber = param[2, 0];

	// Don't start the wave if there's no alive players
	if ( !([(call BIS_fnc_listPlayers)] call dnct_fnc_hasAlive) ) exitWith {};

	[_attackNumber, _waveNumber] spawn dnct_on_waveStart;

	_createdUnits = [_center, _attackNumber] call dnct_fnc_createWaveUnits;
	[_createdUnits] spawn dnct_fnc_preventIdling;

	while { [_createdUnits] call dnct_fnc_hasAlive && [(call BIS_fnc_listPlayers)] call dnct_fnc_hasAlive } do 
	{
		sleep 15;
		{ _x spawn dnct_fnc_assignGroupSADWaypoint; } foreach call dnct_fnc_getEnemyGroups;
	};

	[_attackNumber, _waveNumber] spawn dnct_on_waveEnd;
};

dnct_fnc_createWaveUnits = {
	_center = param[0, [0,0,0]];
	_attackNumber = param[1, 0];

	_waveStructure = _attackNumber call dnct_fnc_getWaveStucture;
	_crowds = _waveStructure select 0;
	_squads = _waveStructure select 1;
	_crowdInfantryTypes = _waveStructure select 2;
	_squadInfantryTypes = _waveStructure select 3;	
	_unitsPerCrowd = _waveStructure select 4;
	_unitsPerSquad = _waveStructure select 5;

	_waveUnits = [];

	// Create crowds and squads
	for "_i" from 1 to _crowds do {
		_units = [_center, _crowdInfantryTypes, _unitsPerCrowd] call dnct_fnc_createCrowd;
		_waveUnits append _units;
	};

	for "_i" from 1 to _squads do {
		_units = [_center, _squadInfantryTypes, _unitsPerSquad] call dnct_fnc_createSquad;
		_waveUnits append _units;
	};

	_waveUnits
};

dnct_fnc_getWaveCount = {
	_attackNumber = param[0, 1];

	_wavesCount = 1;
	
	if(_attackNumber > 5 && _attackNumber <= 10) then {
		_wavesCount = 2;
	};
	if(_attackNumber > 10 && _attackNumber <= 15) then {
		_wavesCount = 4;
	};
	if(_attackNumber > 15) then {
		_wavesCount = 6;
	};

	_wavesCount
};

dnct_fnc_getWaveStucture = {
	_attackNumber = param[0, 1];

	// Default values
	_crowds = 1;
	_squads = 1;
	_crowdInfantryTypes = INFANTRY_BASIC;
	_squadInfantryTypes = INFANTRY_BASIC;	
	_unitsPerCrowd = 1;
	_unitsPerSquad = 1;

	// 1 - 5 (14 units)
	if (_attackNumber <= 5) then {
		_crowds = 2;
		_squads = 1;
		_unitsPerCrowd = 4;
		_unitsPerSquad = 6;
	};

	// 5 - 10 (28 units)
	if (_attackNumber > 5 && _attackNumber <= 10) then {
		_crowds = 4;
		_squads = 2;
		_unitsPerCrowd = 4;
		_unitsPerSquad = 6;
	};

	// 10 - 15 (38 units)
	if (_attackNumber > 10 && _attackNumber <= 15) then {
		_crowds = 5;
		_squads = 3;
		_unitsPerCrowd = 4;
		_unitsPerSquad = 6;
	};

	// 15 - 20 (48 units)
	if (_attackNumber > 15 && _attackNumber <= 20) then {
		_crowds = 2;
		_squads = 5;
		_unitsPerCrowd = 4;
		_unitsPerSquad = 8;
	};

	// 20+ (64 units)
	if (_attackNumber > 20) then {
		_crowds = 4;
		_squads = 4;
		_unitsPerCrowd = 8;
		_unitsPerSquad = 8;
	};

	[_crowds, _squads, _crowdInfantryTypes, _squadInfantryTypes, _unitsPerCrowd, _unitsPerSquad]
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