call compile preprocessFileLineNumbers "scripts\resupply\purchasing.sqf";

supplyPoints = 0;
publicVariable "supplyPoints";

dnct_fnc_initResupply = {	
	if(isNil "resupplyObject") exitWith { hint "Resupply system error: resupply object not found" };	

	resupplyObject addAction[
		"Resupply"
		,{ 0 = _this spawn dnct_fnc_showResupplyDialog; }
		,nil 		// arguments
		,1.5		// priority
		,false		// showWindow
		,true		// hideOnUse
		,""			// shortcut
		,"true"		// condition
		,5			// radius
		,false		// unconscious
	];
};