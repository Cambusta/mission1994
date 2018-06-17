dnct_fnc_getRandomPlayerPos = {
	_position = getPos ( selectRandom ((call BIS_fnc_listPlayers) select { alive _x }) );
	_position
};

dnct_fnc_getNearestPlayerPos = {
	_unit = param[0, objNull];

	_alivePlayers = (call BIS_fnc_listPlayers) select { alive _x; };

	_closestDistance = 900000;
	_closestPosition = [0,0,0];

	{
		_currentDistance = (getPos _unit) distance (getPos _x);

		if (_currentDistance < _closestDistance) then {
			_closestDistance = _currentDistance;
			_closestPosition = getPos _x;
		};

	} foreach _alivePlayers;

	_closestPosition
};

dnct_fnc_removeAllGroupWaypoints = {
	_group = param[0, grpNull];

	while { (count waypoints _group) > 0 } do {
		deleteWaypoint ((waypoints _group) select 0);
	};
};

dnct_fnc_assignGroupSADWaypoint = {
	_group = param[0, grpNull];

	_group call dnct_fnc_removeAllGroupWaypoints;
	_groupWaypoint = _group addWaypoint [(leader _group) call dnct_fnc_getNearestPlayerPos, 0];
	_groupWaypoint setWaypointCombatMode "RED";
	_groupWaypoint setWaypointType "SAD";
	_groupWaypoint setWaypointSpeed "FULL";
};

dnct_fnc_haveAlive = {
	_units = param[0, []];

	if (typeName _units != "ARRAY") then {
		_single = _units;
		_units = [];
		_units pushBack _single;
	};

	_hasAlive = false;
	_aliveCount = { alive _x; } count _units;	

	if (_aliveCount > 0) then 
	{ _hasAlive = true; };

	_hasAlive
};