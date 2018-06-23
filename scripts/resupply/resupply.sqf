call compile preprocessFileLineNumbers "scripts\resupply\purchasing.sqf";

supplyPoints = 0;
publicVariable "supplyPoints";

dnct_fnc_initResupply = {	
	if(isNil "resupplyObject") exitWith { hint "Resupply system error: resupply object not found" };	

	resupplyObject addAction[
		"Resupply"
		,{ 0 = [] spawn dnct_fnc_showResupplyDialog; }
		,nil
		,1.5
		,false
		,true
		,""
		,"true"
		,5
		,false
	];
};