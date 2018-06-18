/* 
Goon/Gooncorp 2015
call from init.sqf
[] execVM "goon_snowstorm.sqf"; 
*/

/*
	Adjusted by Cambusta for mission1994. 
	Grab original script at http://www.armaholic.com/page.php?id=29156
*/

_alpha = .55 + random 0.12;// set the alpha of the particles
[_alpha] spawn {

	while {true} do {		
		_obj = (vehicle player);
		_pos = getposASL _obj;
		_n = abs(wind select 0) + abs(wind select 1) + abs(wind select 2);
		_velocity = wind;
		_color = [1, 1, 1];   

		_snowflakes = "#particlesource" createVehicleLocal _pos; 
		_snowflakes attachto [player, [0,0,12]];
		_snowflakes setParticleParams [["a3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 2, 0], "", "Billboard", 1, 6, [0, 0, 6], _velocity, (0), 1.39, 0, 0, [.05], [[1,1,1,0],[1,1,1,1],[1,1,1,1]],[1000], 0, 0, "", "", _obj];
		_snowflakes setParticleRandom [0, [14 + (random 2),14 + (random 2), 5], [0, 0, 0], 0, 0, [0, 0, 0, 2], 0, 0];
		_snowflakes setParticleCircle [0, [0, 0, 0]];
		_snowflakes setDropInterval 0.015; 

		sleep 30;
		deletevehicle _snowflakes;
	};
};