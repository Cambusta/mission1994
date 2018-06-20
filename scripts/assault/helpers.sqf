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

dnct_fnc_assignGroupSADWaypoint = {
	_group = param[0, grpNull];

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
	_delay = 120;

	sleep _delay;
	while { alive _unit } do 
	{
		_currentPosition = getPos _unit;

		if (_currentPosition distance _previousPosition < 5
		&& !([group _unit] call dnct_fnc_groupKnowsAboutPlayers)) then {
			_unit spawn dnct_fnc_pushUnit;
		};

		_previousPosition = _currentPosition;
		sleep _delay;
	};
};

dnct_fnc_pushUnit = {
	_unit = param[0];

	_pos = call dnct_fnc_getNearestPlayerPos;

	_unit disableAI "TARGET";
	_unit disableAI "SUPPRESSION";
	_unit disableAI "COVER";
	_unit disableAI "AUTOCOMBAT";

	sleep 1;

	_unit setBehaviour "CARELESS";
	_unit setSpeedMode "FULL";
	_unit doMove _pos;

	// Debug stuff
	// [getPos _unit] call dnct_fnc_markPosition;
	// [_pos, "hd_flag"] call dnct_fnc_markPosition;

	for "_i" from 0 to 30 do {
		_unit setAnimSpeedCoef 3;
		sleep 0.2;
	};

	_unit enableAI "TARGET";
	_unit enableAI "SUPPRESSION";
	_unit enableAI "COVER";
	_unit enableAI "AUTOCOMBAT";

	_unit setAnimSpeedCoef 1;	
	_unit setBehaviour "AWARE";
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