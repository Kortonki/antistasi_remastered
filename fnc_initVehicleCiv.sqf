params ["_veh"];

if(!(local _veh)) exitWith {
		diag_log format ["[AS] Error: InitVehicleCIV run where the unit is not local. InitVehicleCIV remoteExec'd where it's local. Time: %1, Vehicle: %2", time, _veh];
		[_veh] remoteExec ["AS_fnc_initVehicleCiv", _veh];
};

[_veh, "CIV"] call AS_fnc_setSide;

[_veh] call AS_debug_fnc_initVehicle;

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

//Randomise fuel and fuel cargo

_veh setfuel (0 + 1*((random 1)^2));
if (finite (getFuelCargo _veh)) then {
	_veh setfuelCargo 0;
	[_veh, 0, 0.1] call AS_fuel_fnc_randomFuelCargo;
	[_veh, "refuel_truck"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
	[_veh, "refuel_truck_check"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
};

//Steal Penalty

_veh addEventHandler ["Getin", {
		private _vehicle = _this select 0;
		private _unitveh = _this select 2;
		private _sideunit = _unitveh call AS_fnc_getSide;
				if (_sideunit == "FIA") exitWith {
						//Penalties here
						[-1,0] remoteExec ["AS_fnc_changeForeignSupport",2];
						[0,-1,getPos _vehicle] remoteExec ["AS_fnc_changeCitySupport",2]; //For comparison killing a civ it's -5%

						[_vehicle, "FIA"] call AS_fnc_setSide;
						_vehicle removeEventHandler ["Getin", _thisEventHandler];
				};
	}];

_veh addEventHandler ["Killed", {
	[_this select 0] remoteExec ["AS_fnc_activateCleanup", 2];
}];

//Commented out vehicle simulation disable because of locality issues

if (count crew _veh == 0) then {
		//_veh enableSimulationGlobal false;
		_veh allowDamage false;
	sleep 60;
	// stop its simulation and on
	_veh allowDamage true;

	/*_veh addEventHandler ["GetIn", {
		_veh = _this select 0;
		if (!simulationEnabled _veh) then {
			_veh enableSimulationGlobal true
		};
		[_veh] spawn AS_fnc_activateVehicleCleanup;
	}];

	_veh addEventHandler ["HandleDamage", {
		_veh = _this select 0;
		if (!simulationEnabled _veh) then {
			_veh enableSimulationGlobal true
		};
	}];*/
};
