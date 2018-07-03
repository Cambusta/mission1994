dnct_fnc_showResupplyDialog = {
	_target = param[0, objNull];
	_caller = param[1, objNull];
	_id = param[2, -1];
	_arguments = param[3, []];

	if (damage _target == 1) exitWith { hint "Uniable to request resupplies - the radio is destroyed."; };

	[
		[0, "HEADER", "Resupplying"]
		, [1, "LABEL", "Available supply points:"]
		, [1, "LABEL", str(supplyPoints)]
		
		, [2, "DROPDOWN", PDO_NAMES, PDO_COSTS]
		
		, [3, "LABEL", ""]

		, [4, "BUTTON", "Purchase", { 
			private _dropDownInput = _this select 0;
			private _selectedItem = _dropDownInput select 0;
			private _itemCost = _dropDownInput select 3; 

			[_selectedItem, _itemCost] call dnct_fnc_purchase;
			closeDialog 2;
		}]
	] call dzn_fnc_ShowAdvDialog;
};

dnct_fnc_purchase = {
	_itemIndex = param[0, 0];
	_itemCost = param[1, 0];

	if (_itemCost <= supplyPoints) then {
		_itemCost spawn dnct_fnc_deductResupplyPoints;

		switch (_selectedItem) do {
			case 0: { ["SHORT"] call dnct_fnc_resupplySandbags; };
			case 1: { ["LONG"] call dnct_fnc_resupplySandbags; };
			case 2: { ["ROUND"] call dnct_fnc_resupplySandbags; };
			case 3: { ["CORNER"] call dnct_fnc_resupplySandbags; };
			case 4: { 0 = ["ILLUM"] spawn dnct_fnc_resupplyArtillery; };
			case 5: { 0 = ["SMOKE"] spawn dnct_fnc_resupplyArtillery; };
			case 6: { 0 = ["HE"] spawn dnct_fnc_resupplyArtillery; };
			case 7: { 0 = ["GRAD"] spawn dnct_fnc_resupplyArtillery; };
		};
	} else {
		hint "Not enough supply points.";
	};
};

dnct_fnc_deductResupplyPoints = {
	_amount = param[0, 0];
	supplyPoints = supplyPoints - _amount;
	publicVariable "supplyPoints";
};