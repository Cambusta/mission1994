call compile preprocessFileLineNumbers "resources\configuration.sqf";
call compile preprocessFileLineNumbers "resources\unit_classes.sqf";
call compile preprocessFileLineNumbers "scripts\assault\assault.sqf";
call compile preprocessFileLineNumbers "scripts\ambient\shelling.sqf";

waitUntil { time > 1 };
0 = [] spawn dnct_fnc_assault;
0 = [] spawn dnct_fnc_ambientShelling;