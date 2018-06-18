dnct_fnc_getRandomPlayerPos = {
	_alivePlayers = (call BIS_fnc_listPlayers) select { alive _x };
	_position = [0,0,0];

	if (count _alivePlayers > 0) then {
		_position = getPos (selectRandom _alivePlayers);
	};

	_position
};

dnct_fnc_getNearestPlayerPos = {
	_unit = param[0, objNull];

	_alivePlayers = (call BIS_fnc_listPlayers) select { alive _x };

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

dnct_fnc_groupKnowsAboutPlayers = {
	_group = param[0, grpNull];

	_alivePlayers = (call BIS_fnc_listPlayers) select { alive _x };

	_knows = false;
	{
		if((_group knowsAbout _x) == 4) exitWith { _knows = true; };
	} forEach _alivePlayers;

	_knows;
};

dnct_fnc_removeAllButLastGroupWaypoints = {
	_group = param[0, grpNull];

	while { (count waypoints _group) > 1 } do {
		deleteWaypoint ((waypoints _group) select 0);
	};
};

dnct_fnc_assignGroupSADWaypoint = {
	_group = param[0, grpNull];

	_position = (leader _group) call dnct_fnc_getNearestPlayerPos;
	
	if ( !(_position isEqualTo [0,0,0]) ) then {
		_waypointCount = count waypoints _group;		
		_groupWaypoint = _group addWaypoint [_position, 0, _waypointCount];
		_groupWaypoint setWaypointCombatMode "RED";
		_groupWaypoint setWaypointType "SAD";
		_groupWaypoint setWaypointSpeed "FULL";

		_group call dnct_fnc_removeAllButLastGroupWaypoints;
	};
};

dnct_fnc_hasAlive = {
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

dnct_fnc_getEnemyGroups = {
	_enemyGroups = [];

	{
		if (side _x == ENEMY_SIDE
		&& [units _x] call dnct_fnc_hasAlive) then {
			_enemyGroups pushBack _x;
		};
	} forEach allGroups;

	_enemyGroups
};

dnct_fnc_getMissionLocation = {
	_position = getMarkerPos "besiegedLocation";
	_position
};

dnct_fnc_preventIdling = {
	_units = param[0, []];
	
	{ _x spawn dnct_fnc_preventStucking; } foreach _units;
	{ _x spawn dnct_fnc_preventCowardice; } foreach call dnct_fnc_getEnemyGroups;
};

dnct_fnc_preventCowardice = {
	_group = param[0, grpNull];

	while { [units _group] call dnct_fnc_hasAlive } do 
	{
		sleep 30;
		if (!([_group] call dnct_fnc_groupKnowsAboutPlayers)) then 
		{ _group setBehaviour "SAFE"; };
	};
};

dnct_fnc_preventStucking = {
	_unit = param[0, objNull];

	_oldPosition = getPos _unit;

	while { alive _unit } do 
	{
		sleep 180;
		_newPosition = getPos _unit;

		if(_newPosition distance _oldPosition < 5) then {
			_safePos = [(getpos _unit), 15, 100, 10] call BIS_fnc_findSafePos;
			_unit setPos _safePos;
			_oldPosition = getPos _unit;
		} else {
			_oldPosition = _newPosition;
		};
	};
};