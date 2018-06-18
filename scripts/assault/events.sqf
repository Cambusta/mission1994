dnct_fnc_onWaveStart = {
	_waveNumber = param[0, 1];

	// Spawn a flare to singal the beginning of a new wave
	_flarePos = [call dnct_fnc_getMissionLocation, random 100, random 360] call BIS_fnc_relPos;
	_flare = createVehicle ["rhs_40mm_white", _flarePos, [], 0, "NONE"];
	_flare setPosATL [getPosATL _flare select 0, getPosATL _flare select 1, 250 + (random 75)];
	_flare setVelocity [0,0,-0.15];

	setPlayerRespawnTime 9999999;
};

dnct_fnc_onWaveEnd = {
	_waveNumber = param[0, 1];
	_successfull = param[1, false];

	if (_successfull) then {
		hint "Wave completed!";

		setPlayerRespawnTime 1;
		sleep 5;
		setPlayerRespawnTime 9999999;
	};
};