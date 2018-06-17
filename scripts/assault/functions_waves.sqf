dnct_createWave = {
	_center = param[0, [0,0,0]];
	_waveNumber = param[2, 0];

	//_units = [_center, _safezone, INFANTRY_BASIC, 10] call dnct_createSquad;
	_units = [_center, _safezone, INFANTRY_BASIC] call dnct_createSquadOrganized;
	hint str(_units);
};

dnct_createSquad = {
	_center = param[0, [0,0,0]];
	_unitClasses = param[2, []];

	_location = [_center, SAFEZONE_AREA, SAFEZONE_AREA_EXTENSION, 3] call BIS_fnc_findSafePos;
	_squad = [_location, ENEMY_SIDE, INFANTRY_BASIC, [], [], [], [], [6, 0.7]] call BIS_fnc_spawnGroup;

	_groupWaypoint = _squad addWaypoint [getPos player, 0];
	_groupWaypoint setWaypointCombatMode "RED";
	_groupWaypoint setWaypointType "SAD";
	_groupWaypoint setWaypointSpeed "FULL";

	_squad
};

dnct_createCrowd = {
	_center = param[0, [0,0,0]];
	_unitClases = param[2, []];
	_unitCount = param[3, 0];
		
	_location = [_center, SAFEZONE_AREA, SAFEZONE_AREA_EXTENSION, 3] call BIS_fnc_findSafePos;

	_crowd = [];

	for ("_i") from 0 to _unitCount do {
		_group = createGroup [ENEMY_SIDE, true];
		_class = selectRandom _unitClases;
		_unit = _group createUnit [_class, _location, [], 0.5, "NONE"];
		sleep 0.5;

		if (random 1 < 0.2) then {
			_unit disableAI "AUTOCOMBAT";
		};

		//_unit doMove (getPos (selectRandom playableUnits));
		_unit doMove (getPos player);
		_crowd append [_unit];
	};

	_crowd
};