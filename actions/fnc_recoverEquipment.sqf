params ["_vehicle"];

private _unit = _this select 1;
private _group = group _unit;

if ((_unit getVariable ["loadingCrate", false])) exitWith {
	hint "You are already transfering cargo...";
};

scopeName "main";

//Nearby enemy check

if ([position _vehicle, 50] call AS_fnc_enemiesNearby) exitWith {

		private _text = "You cannot load cargo with enemies nearby!";
		[_unit, "hint", _text] call AS_fnc_localCommunication;

};

_unit setVariable ["loadingCrate", true];
_unit setcaptive false; //Cannot stay undercover

private _position = position _vehicle;
private _size = 20;


private _totalRecovered = 0;

//This is the main hoarding loop which terminates in case it finishes or enemies come within 50m

while {true} do {

	//Nearby boxes
	private _boxes = nearestObjects [_position, ["AllVehicles", "ReammoBox_F"], _size];
	if (caja in _boxes) then {_boxes = _boxes - [caja];}; //Dumbproofing
	_boxes = _boxes select {!(_x getvariable ["asCargo", false]) and {count ((getweaponCargo _x select 0) + (getmagazineCargo _x select 0) + (getitemCargo _x select 0) + (getbackpackCargo _x select 0)) > 0}}; //Try  //Try using getMagazine instead of magazine for locality issues

	{
		if (_x != _vehicle) then {
			private _total = 0;
			{
						_total = _total + _x;
			} foreach ((getweaponCargo _x select 1) + (getmagazineCargo _x select 1) + (getitemCargo _x select 1) + (getbackpackCargo _x select 1));

			private _units = (units _group) select {alive _x and {vehicle _x == _x and {!(_x call AS_medical_fnc_isUnconscious) and {_x distance2D _position <= _size}}}};
			if (count _units == 0) then {
				hint "Have someone from your group outside the truck";
				breakTO "main"
			};
			private _time = _total/(count _units);
	    [_x, _position, _time/2, {true}, {speed _vehicle >= 1}, "Keep the truck still", ""] call AS_fnc_wait_or_fail;

		if (speed _vehicle < 1) then {
			[_x, _vehicle] call AS_fnc_transferToBox;
			_totalRecovered = _totalRecovered + _total;
			};
		};

		//Cancel action if enemies come near

		if ([position _vehicle, 50] call AS_fnc_enemiesNearby) exitWith {

				private _text = "You cannot load cargo with enemies nearby!";
				[_unit, "hint", _text] call AS_fnc_localCommunication;
				breakTo "main";
		};
	} forEach _boxes;


	// dropped equipment
	private _holders = nearestObjects [_position, ["WeaponHolderSimulated", "WeaponHolder"], _size];
	_holders = _holders select {count ((getweaponCargo _x select 0) + (getmagazineCargo _x select 0) + (getitemCargo _x select 0) + (getbackpackCargo _x select 0)) > 0}; //Try
	{
		private _total = 0;
		{
					_total = _total + _x;
		} foreach ((getweaponCargo _x select 1) + (getmagazineCargo _x select 1) + (getitemCargo _x select 1) + (getbackpackCargo _x select 1));

	   // Time depends on friendly units around the truck
		 private _units = (units _group) select {alive _x and {vehicle _x == _x and {!(_x call AS_medical_fnc_isUnconscious) and {_x distance2D _position <= _size}}}};
		 if (count _units == 0) then {
			 hint "Have someone from your group outside the truck";
			 breakTO "main"};
		 private _time = _total/(count _units);
	   [_x, _position, _time, {true}, {speed _vehicle >= 1}, "Keep the truck still", ""] call AS_fnc_wait_or_fail;

		if (speed _vehicle < 1) then {
			[_x, _vehicle] call AS_fnc_transferToBox;
			[_x] remoteExecCall ["deleteVehicle", _x];
			_totalRecovered = _totalRecovered + _total;
		};

		//Cancel action if enemies come near

		if ([position _vehicle, 50] call AS_fnc_enemiesNearby) exitWith {

				private _text = "You cannot load cargo with enemies nearby!";
				[_unit, "hint", _text] call AS_fnc_localCommunication;
				breakTo "main";
		};
	} forEach _holders;


	// dead bodies
	{
	    if not (alive _x) then {
	        ([_x, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magazineRemains"];

			private _total = 0;
			{
				{_total = _total + _x} forEach (_x select 1);
			} forEach [_cargo_w, _cargo_m, _cargo_i, _cargo_b];

			private _units = (units _group) select {alive _x and {vehicle _x == _x and {!(_x call AS_medical_fnc_isUnconscious) and {_x distance2D _position <= _size}}}};
			if (count _units == 0) then {
				hint "Have someone from your group outside the truck";
				breakTO "main"
			};
			private _time = _total/(count _units);

			[_x, _position, _time, {true}, {speed _vehicle >= 1}, "Keep the truck still", ""] call AS_fnc_wait_or_fail;

			if (speed _vehicle < 1) then {
				[_vehicle, _cargo_w, _cargo_m, _cargo_i, _cargo_b, false] call AS_fnc_populateBox;
				[_vehicle, _magazineRemains] call AS_fnc_addMagazineRemains;
		        _x call AS_fnc_emptyUnit;
				_totalRecovered = _totalRecovered + _total;
			};
	  };

		//Cancel action if enemies come near

		if ([position _vehicle, 50] call AS_fnc_enemiesNearby) exitWith {

				private _text = "You cannot load cargo with enemies nearby!";
				[_unit, "hint", _text] call AS_fnc_localCommunication;
				breakTo "main";
		};
	} forEach (_position nearObjects ["Man", _size]);
	breakTo "main";
};

//This is where the hoarding loop breaks to in case enemies come within 50m or there are no one outside the truck
if (_totalRecovered > 0) then {
	private _text = format ["%1 items recovered into the truck", _totalRecovered];
	[_unit, "hint", _text] call AS_fnc_localCommunication;
};
[0,true] remoteExec ["AS_fnc_showProgressBar",player];
_unit setVariable ["loadingCrate", false];
