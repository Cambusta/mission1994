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

dnct_fnc_assignGroupTarget = {
	_group = param[0, grpNull];

	if (_group getVariable ["isGroupStuck", false]) exitWith {};

	_position = (leader _group) call dnct_fnc_getNearestPlayerPos;
	
	if ( !(_position isEqualTo [0,0,0]) ) then {
		if (count waypoints _group > 1) then {
			[_group, 1] setWaypointPosition [_position, 0];
		} else {
			_groupWaypoint = _group addWaypoint [_position, 1];
			_groupWaypoint setWaypointStatements ["false", ""];
			_groupWaypoint setWaypointCombatMode "RED";
			_groupWaypoint setWaypointType "MOVE";
			_groupWaypoint setWaypointSpeed "FULL";
		};
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

dnct_fnc_markPosition = {
	_position = param[0, []];
	_markerType = param[1, "Select"];

	_name = format["marker%1_%2", time, floor (random 10000)];
	_marker = createMarker [_name, _position];
	_marker setMarkerType _markerType;
	_marker
};

dnct_fnc_preventIdling = {
	_units = param[0, []];

	{ _x spawn dnct_fnc_preventUnitCowardice; } foreach _units;
};

dnct_fnc_preventUnitCowardice = {
	_unit = param[0, objNull];

	_previousPosition = getPos _unit;
	_delay = 30;

	sleep _delay;
	while { alive _unit } do 
	{
		_currentPosition = getPos _unit;

		if (_currentPosition distance _previousPosition < 10
		&& !([group _unit] call dnct_fnc_groupKnowsAboutPlayers)) then {
			_unit spawn dnct_fnc_pushUnit;
		};

		_previousPosition = _currentPosition;
		sleep _delay;
	};
};

dnct_fnc_pushUnit = {
	_unit = param[0];

	(group _unit) setVariable ["isGroupStuck", true];

	_pos = call dnct_fnc_getNearestPlayerPos;

	_unit disableAI "SUPPRESSION";
	_unit disableAI "COVER";
	_unit disableAI "AUTOCOMBAT";
	_unit setBehaviour "AWARE";
	_unit setSpeedMode "FULL";
	
	while { alive _unit } do {
		_unit doMove _pos;
		sleep 20;
	};
};

dnct_fnc_selectWithProbability = {
	_items = param[0, []];

	_probabilitySum = 0;
	{ _probabilitySum = _probabilitySum + (_x select 1); } forEach _items;

	_random = random _probabilitySum;
	_cumulativeProbability = 0;

	_currentIndex = 0;
	_resultIndex = -1;
	_result = objNull;

	while { (_resultIndex == -1) && (_currentIndex < count _items) } do {
		_currItem = _items select _currentIndex;
		_itemProbability = _currItem select 1;

		_cumulativeProbability = _cumulativeProbability + _itemProbability;

		if (_random <= _cumulativeProbability) then
		{ _resultIndex = _currentIndex; };

		_currentIndex = _currentIndex + 1;
	};

	if (_resultIndex != -1) then 
	{ _result = ((_items select _resultIndex) select 0); };

	_result
};

dnct_fnc_evaluateAttackResults = {
	_attackNumber = param[0, 1];

	_completed = false;

	if ([(call BIS_fnc_listPlayers)] call dnct_fnc_hasAlive) then 
	{ _completed = true; } 
	else 
	{ _completed = false; };
	
	_completed
};