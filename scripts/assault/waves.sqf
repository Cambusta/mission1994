dnct_fnc_wave = {
	_center = param[0, [0,0,0]];
	_waveNumber = param[1, 0];

	hint format["Wave %1", _waveNumber];
	_createdUnits = [_center, _waveNumber] call dnct_fnc_createWaveUnits;
	
	while { [_createdUnits] call dnct_fnc_haveAlive && [(call BIS_fnc_listPlayers)] call dnct_fnc_haveAlive } do 
	{
		sleep 5;
		{
			if (side _x == ENEMY_SIDE) then 
			{ _x spawn dnct_fnc_assignGroupSADWaypoint; };
		} foreach allGroups;
	};

	hint "Wave complete!";
};

dnct_fnc_createWaveUnits = {
	_center = param[0, [0,0,0]];
	_waveNumber = param[1, 0];

	_waveUnits = [];
	for "_i" from 1 to _waveNumber do {
		_units = [_center, INFANTRY_BASIC, 10] call dnct_fnc_createCrowd;
		_waveUnits append _units;
	};

	_waveUnits
};

dnct_fnc_createSquad = {
	_center = param[0, [0,0,0]];
	_unitClasses = param[2, []];

	_location = [_center, SAFEZONE_AREA, SAFEZONE_AREA_EXTENSION, 3] call BIS_fnc_findSafePos;
	_squad = [_location, ENEMY_SIDE, INFANTRY_BASIC, [], [], [], [], [6, 0.7]] call BIS_fnc_spawnGroup;
	_squad spawn dnct_fnc_assignGroupSADWaypoint; 

	_units = units _squad;
	_units
};

dnct_fnc_createCrowd = {
	_center = param[0, [0,0,0]];
	_unitClases = param[1, []];
	_unitCount = param[2, 0];
		
	_location = [_center, SAFEZONE_AREA, SAFEZONE_AREA_EXTENSION, 3] call BIS_fnc_findSafePos;

	_crowd = [];

	for "_i" from 1 to _unitCount do {
		_group = createGroup [ENEMY_SIDE, true];
		_class = selectRandom _unitClases;
		_unit = _group createUnit [_class, _location, [], 0.5, "NONE"];
		sleep 0.5;

		// Simulate "berserk mode" for some of the unorganized troops
		if (random 1 < 0.2) then {
			_unit disableAI "AUTOCOMBAT";
		};

		_unit doMove (call dnct_fnc_getRandomPlayerPos);
		_crowd pushBack _unit;
	};

	_crowd
};