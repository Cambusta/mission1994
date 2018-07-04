dnct_fnc_ambientShelling = {

	_center = getMarkerPos "besiegedLocation";

	while { true } do {
		_position = [_center, 300, 1000] call BIS_fnc_findSafePos;
		
		if ((random 1) <= 0.9) then {
			[_position] spawn dnct_fnc_beginFireMission; 
		} else {
			[_position] spawn dnct_fnc_beginFlares; 
		};
		
		_delay = 60 + round(random 600);
		sleep _delay;
	};
};

dnct_fnc_beginFiremission = {
	_position = param[0, []];

	_postionDescription = [_position, "CIRCLE", 0, 100];
	_ammoCount = 4 + round (random 15);
	[_postionDescription, "rhs_ammo_3WOF27", 1, _ammoCount] spawn dzn_fnc_StartVirtualFiremission;
};

dnct_fnc_beginFlares = {
	_position = param[0, []];

	_postionDescription = [_position, "CIRCLE", 0, 100];
	[_postionDescription, "rhs_ammo_3WS23", 1, 2] spawn dzn_fnc_StartVirtualFiremission;
};