call compile preprocessFileLineNumbers "scripts\resupply\resupply.sqf";
call compile preprocessFileLineNumbers "scripts\plank\plank_init.sqf";

waitUntil { ! isNull player };
[] execVM "scripts\snow\goon_snowstorm.sqf";
[] call dnct_fnc_initResupply;