dnct_fnc_ambientShelling = {

	_center = getMarkerPos "besiegedLocation";

	while { true } do {
		_position = [_center, 300, 1000] call BIS_fnc_findSafePos;
		[_position] spawn dnct_fnc_beginFireMission;
		
		_delay = 60 + round(random 600);
		sleep _delay;
	};
};

dnct_fnc_beginFiremission = {
	_position = param[0, []];

	_postionDescription = [_position, "CIRCLE", 0, 100];
	_ammoCount = 4 + round (random 15);
	[_postionDescription, "rhs_ammo_3WOF27", _ammoCount] spawn dzn_fnc_StartVirtualFiremission;
};