dnct_fnc_createWave = {
	_center = param[0, [0,0,0]];
	_waveNumber = param[2, 0];

	_units = [_center, INFANTRY_BASIC, 10] call dnct_fnc_createCrowd;
	//_units = [_center, INFANTRY_BASIC] call dnct_fnc_createSquad;
	hint str(_units);
};

dnct_fnc_createSquad = {
	_center = param[0, [0,0,0]];
	_unitClasses = param[2, []];

	_location = [_center, SAFEZONE_AREA, SAFEZONE_AREA_EXTENSION, 3] call BIS_fnc_findSafePos;
	_squad = [_location, ENEMY_SIDE, INFANTRY_BASIC, [], [], [], [], [6, 0.7]] call BIS_fnc_spawnGroup;

	_groupWaypoint = _squad addWaypoint [call dnct_fnc_getRandomPlayerPos, 0];
	_groupWaypoint setWaypointCombatMode "RED";
	_groupWaypoint setWaypointType "SAD";
	_groupWaypoint setWaypointSpeed "FULL";

	_squad
};

dnct_fnc_createCrowd = {
	_center = param[0, [0,0,0]];
	_unitClases = param[1, []];
	_unitCount = param[2, 0];
		
	_location = [_center, SAFEZONE_AREA, SAFEZONE_AREA_EXTENSION, 3] call BIS_fnc_findSafePos;

	_crowd = [];

	for ("_i") from 0 to _unitCount do {
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