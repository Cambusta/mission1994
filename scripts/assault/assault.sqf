call compile preprocessFileLineNumbers "scripts\assault\events.sqf";
call compile preprocessFileLineNumbers "scripts\assault\helpers.sqf";
call compile preprocessFileLineNumbers "scripts\assault\waves.sqf";

// Global variables controlling assault state
assaultActive = true;
attackNumber = 1;
publicVariable "attackNumber";

dnct_fnc_assault = {
	_center = param[0, [0,0,0]];

	if (_center isEqualTo [0,0,0]) then {
		_center = call dnct_fnc_getMissionLocation;
	};

	// Setup pause
	sleep 10;

	while { assaultActive } do 
	{	
		attackNumber spawn dnct_on_attackStart;

		_wavesCount = attackNumber call dnct_fnc_getWaveCount;
		for "_wave" from 1 to _wavesCount do 
		{
			if (_wave > 1) then
			{ sleep WAVE_DELAY; };

			[_center, attackNumber, _wave] call dnct_fnc_wave;
		};

		attackNumber spawn dnct_fnc_evaluateAttackResults;
		attackNumber = attackNumber + 1; 
		publicVariable "attackNumber";

		sleep ATTACK_DELAY;
	};
};