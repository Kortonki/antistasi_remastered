params ["_veh"];

if(!(local _veh)) exitWith {
		diag_log format ["[AS] Error: InitVehicleCIV run where the unit is not local. InitVehicleCIV remoteExec'd where it's local. Time: %1, Vehicle: %2", time, _veh];
		[_veh] remoteExec ["AS_fnc_initVehicleCiv", _veh];
};

[_veh, "CIV"] call AS_fnc_setSide;

[_veh] call AS_debug_fnc_initVehicle;

[_veh] call AS_fnc_emptyCrate;

// do not allow wheels to break when AI is driving
if (_veh isKindOf "Car") then {
	_veh addEventHandler ["HandleDamage", {
		params ["_veh", "_part", "_damage", "_injurer", "_projectile"];
		if ((_part find "wheel" != -1) and (_projectile == "") and (!isPlayer driver _veh)) then {
			0
		} else {
			_damage
		};
	}];
};

//The looting script

if ((typeOf _veh) isKindof "Truck_F" and {!((_veh call AS_fuel_fnc_getfuelCargoSize) > 0)}) then {
	[_veh, "recoverEquipment"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
	[_veh, "transferTo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
	};

//Randomise fuel and fuel cargo

_veh setfuel (0 + 1*((random 1)^2));
if (_veh call AS_fuel_fnc_getfuelCargoSize > 0) then {
	_veh setfuelCargo 0;
	[_veh, 0, 0.1] call AS_fuel_fnc_randomFuelCargo;

};

//Steal Penalty

_veh addEventHandler ["Getin", {
		private _vehicle = _this select 0;
		private _unitveh = _this select 2;
		private _sideunit = _unitveh call AS_fnc_getSide;
				if (_sideunit == "FIA" and {(_vehicle call AS_fnc_getside) != "FIA"}) exitWith {

						//Penalties here
						[-1,0] remoteExec ["AS_fnc_changeForeignSupport",2];
						[0,-1,getPos _vehicle] remoteExec ["AS_fnc_changeCitySupport",2]; //For comparison killing a civ it's -5%

						[_vehicle] spawn {
							params ["_vehicle"];
							waitUntil {sleep 0.5; count (crew _vehicle) == 0};
							[_vehicle] remoteExec ["AS_fnc_changePersistentVehicles", 2];
						};

						[_vehicle, "FIA"] call AS_fnc_setSide;

						//if it's a refuel truck

						if (_vehicle call AS_fuel_fnc_getfuelCargoSize > 0) then {
							[_vehicle, "refuel_truck"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
							[_vehicle, "refuel_truck_check"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
						};

				};
	}];

_veh addEventHandler ["Killed", {
	[_this select 0] remoteExec ["AS_fnc_activateCleanup", 2];
}];
