if (!(isServer) and {player != leader group player}) exitWith {hint "You cannot dismiss anyone if you are not the squad leader"};

private _units = _this select 0;

private _groupToDelete = createGroup ("FIA" call AS_fnc_getFactionSide);
_groupToDelete setGroupid [format ["Dismissed-%1", count allGroups]];


{
	if (!isPlayer _x) then {
		if ([_x] call AS_fnc_getFIAUnitType != "Survivor") then
			{
			[_x] join _groupToDelete;
			};
	}	else {
		// send the player to a new group.
		[_x] join (createGroup ("FIA" call AS_fnc_getFactionSide));
	};
} forEach _units;

	// order units to return to the HQ.
	{_x domove getMarkerPos "FIA_HQ"} forEach units _groupToDelete;

	private _time = time + (5*60);

	// wait until all units are in the HQ.
	waitUntil {
		sleep 1;
		(time > _time) or (({(_x distance getMarkerPos "FIA_HQ" < 50) and (alive _x)} count units _groupToDelete) == ({alive _x} count units _groupToDelete))
	};

	private _hr = 0;
	private _resourcesFIA = 0;
	private _hqPos = getMarkerPos "FIA_HQ";

	private _cargo_w = [[], []];
	private _cargo_m = [[], []];
	private _cargo_i = [[], []];
	private _cargo_b = [[], []];
	{
		private _unit = _x;
		if ((alive _unit) and {not(_unit call AS_medical_fnc_isUnconscious) or _unit distance2D _hqPos <= 100}) then {


			//Wait unit to lose undercover and get weapons back
			if (captive _unit) then {
				_unit setcaptive false;
				sleep 30;
			};

			_resourcesFIA = _resourcesFIA + ((_unit call AS_fnc_getFIAUnitType) call AS_fnc_getCost);
			_hr = _hr + 1;

			private _arsenal = [_unit, true] call AS_fnc_getUnitArsenal;  // restricted to locked weapons
			_cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
			_cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists; //Consider transfretobox
			_cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
			_cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
			[cajaVeh, (_arsenal select 4)]; call AS_fnc_addMagazineRemains;

			//TODO consider what to do if inside vehicle. ATM the vehicle is left there
			[_unit] RemoteExecCall ["AS_fnc_safeDelete", _unit];
		} else {
			_unit setdamage 1; //Make sure the unit is dead, if still unconscious
		};
	} forEach units _groupToDelete;
	[_groupToDelete] RemoteExec ["deleteGroup", _groupToDelete];

	[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] remoteExec ["AS_fnc_populateBox", 2];

	if (!isMultiplayer) then {
		[_hr,_resourcesFIA] remoteExec ["AS_fnc_changeFIAmoney",2];
	} else {
		[player, "money", _resourcesFIA] remoteExec ["AS_players_fnc_change", 2];
		[_hr,0] remoteExec ["AS_fnc_changeFIAmoney",2];
	};
