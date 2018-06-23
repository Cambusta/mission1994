dnct_fnc_addResupplyPoints = {
	_amount = param[0, 0];
	supplyPoints = supplyPoints + _amount;
	publicVariable "supplyPoints";
};