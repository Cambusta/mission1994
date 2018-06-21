dnct_on_attackStart = {
	_waveNumber = param[0, 1];

	// Spawn a flare to singal the beginning of a new attack
	_flarePos = [call dnct_fnc_getMissionLocation, random 100, random 360] call BIS_fnc_relPos;
	_flare = createVehicle ["rhs_40mm_white", _flarePos, [], 0, "NONE"];
	_flare setPosATL [getPosATL _flare select 0, getPosATL _flare select 1, 250 + (random 75)];
	_flare setVelocity [0,0,-0.15];

	setPlayerRespawnTime 9999999;
};

dnct_on_attackEnd = {
	_waveNumber = param[0, 1];
	_successfull = param[1, false];

	if (_successfull) then {
		hint "Attack completed!";

		setPlayerRespawnTime 1;
		sleep 5;
		setPlayerRespawnTime 9999999;
	};
};

dnct_on_waveStart = {
	_attackNumber = param[0, 1];
	_waveNumber = param[1, 1];

	player sideChat format["Wave %1 of attack %2 begins...", _waveNumber, _attackNumber];
};

dnct_on_waveEnd = {
	_attackNumber = param[0, 1];
	_waveNumber = param[1, 1];

	player sideChat format["Wave %1 of attack %2 completed!", _waveNumber, _attackNumber];
};