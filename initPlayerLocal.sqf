waitUntil { ! isNull player };
[] execVM "scripts\snow\goon_snowstorm.sqf";

call compile preprocessFileLineNumbers "scripts\plank\plank_init.sqf";
[player, [2, 2, 2, 2]] call plank_api_fnc_forceAddFortifications;