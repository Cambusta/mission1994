dnct_findLocation = {
	_center = param[0, [0,0,0]];
	_safezone = param[1, 100];
	_location = [_center, _safezone, _safezone + 200, 3] call BIS_fnc_findSafePos;

	_location
}