call compile preprocessFileLineNumbers "scripts\assault\events.sqf";
call compile preprocessFileLineNumbers "scripts\assault\helpers.sqf";
call compile preprocessFileLineNumbers "scripts\assault\waves.sqf";

// Global variables controlling assault state
assaultActive = true;
waveNumber = 1;

dnct_fnc_assault = {
	_center = param[0, [0,0,0]];

	if (_center isEqualTo [0,0,0]) then {
		_center = call dnct_fnc_getMissionLocation;
	};

	// Setup pause
	sleep 10;

	waveNumber = 1;
	publicVariable "waveNumber";

	while { assaultActive } do
	{
		[_center, waveNumber] call dnct_fnc_wave;		
		
		waveNumber = waveNumber + 1;
		publicVariable "waveNumber";

		sleep WAVE_DELAY;
	};
};