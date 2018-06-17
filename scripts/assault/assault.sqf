call compile preprocessFileLineNumbers "scripts\assault\common.sqf";
call compile preprocessFileLineNumbers "scripts\assault\waves.sqf";

// Global variable to control the assault state
assaultActive = true;

dnct_fnc_assault = {
	_center = param[0, [0,0,0]];
	
	_waveNumber = 1;
	publicVariable "_waveNumber";

	while { assaultActive } do
	{
		[_center, _waveNumber] call dnct_fnc_wave;		
		
		_waveNumber = _waveNumber + 1;
		publicVariable "_waveNumber";

		sleep WAVE_DELAY;
	};

}