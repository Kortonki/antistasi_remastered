params ["_group", ["_pos", getMarkerpos "FIA_HQ"]];

private _hr = 0;
private _resourcesFIA = 0;

private _time = time + (5*60);

waitUntil {

	sleep 30;
	//Pre condition calcs

	private _near = false;
	private _hq = false;
  private _leader = leader _group;

  //TODO: Consider making the check for all units (some units might get stuck and the script can't finish)
	if ([position _leader, nil] call AS_fnc_enemiesNearby) then {_near = true};
	if (position _leader distance2D _pos < 100) then {_hq = true};

	 //waituntil condition
	 (!(_near) and {time > _time or _hq}) or
   ({alive _x} count (units _group) < 1)
 };

//todo: check for uncoscius units and don't return resources for them TEST

private _hqPos = getMarkerPos "FIA_HQ";

private _cargo_w = [[], []];
private _cargo_m = [[], []];
private _cargo_i = [[], []];
private _cargo_b = [[], []];


private _vs = [];
	{
		private _unit = _x;
		if (alive _x and {not(_x call AS_medical_fnc_isUnconscious) or _x distance2D _hqPos <= 100}) then { //TODO to check for other healing places, where unconscious can be revived
			_hr = _hr + 1;
			_resourcesFIA = _resourcesFIA + ((_x call AS_fnc_getFIAUnitType) call AS_fnc_getCost); //Get unit cost back

			//Take equipment back

			private _arsenal = [_unit, true] call AS_fnc_getUnitArsenal;  // restricted to locked weapons
			_cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists; //TODO consider transfertobox here
			_cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
			_cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
			_cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
			[cajaVeh, (_arsenal select 4)] call AS_fnc_addMagazineRemains;

			if (!isNull (assignedVehicle _x)) then {
				private _veh = assignedVehicle _x;
				if (!(_veh in _vs)) then {

						//Recover everything if has fuel for the return trip. rough estimate

						private _fuel = _veh call AS_fuel_fnc_getVehicleFuel;
						if (canMove _veh and {_fuel >= (_veh call AS_fuel_fnc_returnTripFuel)}) then {

									//Approximate fuel for the return trip to base. Roughly 0,2 liter per 1km for a standard car, more for tanks etc.

									_fuel = _fuel - (_veh call AS_fuel_fnc_returnTripFuel);
									if (!(_veh in AS_allStatics) and {_veh call AS_fuel_fnc_getFuelCargoSize > 0}) then {_fuel = _fuel + (_veh call AS_fuel_fnc_getFuelCargo);};
									[_fuel] remoteExec ["AS_fuel_fnc_changeFIAfuelReserves", 2];

									// Recover the full price of the vehicle

									_resourcesFIA = _resourcesFIA + ([typeOf _veh] call AS_fnc_getFIAvehiclePrice);

									//Any vehicle (statics) attached to the vehicle

									if (count attachedObjects _veh > 0) then {
												private _subVeh = (attachedObjects _veh) select 0;
												_resourcesFIA = _resourcesFIA + ([(typeOf _subVeh)] call AS_fnc_getFIAvehiclePrice);
												[_subVeh] RemoteExecCall ["deleteVehicle", _subVeh];

									};

										//Recover equipment from the squad vehicle

										private _vehArsenal = [_veh, true] call AS_fnc_getBoxArsenal;
										_cargo_w = [_cargo_w, _vehArsenal select 0] call AS_fnc_mergeCargoLists;
										_cargo_m = [_cargo_m, _vehArsenal select 1] call AS_fnc_mergeCargoLists;
										_cargo_i = [_cargo_i, _vehArsenal select 2] call AS_fnc_mergeCargoLists; //TODO consider AS_fnc_transferToBox
										_cargo_b = [_cargo_b, _vehArsenal select 3] call AS_fnc_mergeCargoLists;
										[cajaVeh, (_vehArsenal select 4)] call AS_fnc_addMagazineRemains;
							};

					_vs pushBack _veh; //Do not recover same vehicle twice
					[_veh] RemoteExec ["deleteVehicle", _veh];
					};
				};
			};
		_x call AS_fnc_safeDelete;
		} forEach (units _group);
[_group] RemoteExec ["deleteGroup", _group];

//Add everything

[_cargo_w, _cargo_m, _cargo_i, _cargo_b] remoteExec ["AS_fnc_addToArsenal", 2];
[_hr,_resourcesFIA] remoteExec ["AS_fnc_changeFIAmoney",2];
