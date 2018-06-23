if (!isDedicated) then {
    call compile preprocessFileLineNumbers "resources\fortifications.sqf";

    plank_isInitialized = false;

    waitUntil {
        !isNil {BIS_fnc_init} && {BIS_fnc_init};
    };
    call compile preProcessFileLineNumbers "scripts\plank\deploy_functions.sqf";
    call compile preProcessFileLineNumbers "scripts\plank\ui_functions.sqf";
    call compile preProcessFileLineNumbers "scripts\plank\api_functions.sqf";

    plank_isInitialized = true;
};