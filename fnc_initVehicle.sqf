#include "macros.hpp"

params ["_veh", "_side", "_fuel", "_fuelCargo"];

if(!(local _veh)) exitWith {
		diag_log format ["[AS] Error: InitVehicle run where the unit is not local. InitVehicle remoteExec'd where it's local. Time: %1, Vehicle: %2 Side: %3", time, _veh, _side];
		[_veh, _side] remoteExec ["AS_fnc_initVehicle", _veh];
};

// _side can only be FIA, AAF, NATO or CSAT
// We need this because FIA can steal from others, and thus the vehicle class
// does not uniquely define the necessary initialization.

[_veh, _side] call AS_fnc_setSide;

if ((_veh isKindOf "FlagCarrier") or (_veh isKindOf "Building")) exitWith {};
if (_veh isKindOf "ReammoBox_F" and _side == "AAF") exitWith {[_veh,"Watchpost"] call AS_fnc_fillCrateAAF};

// So the vehicle appears in debug mode. Does nothing otherwise.
[_veh] call AS_debug_fnc_initVehicle;

private _tipo = typeOf _veh;
private _vehicleCategory = _tipo call AS_AAFarsenal_fnc_category;

// Equipment-related initialisation
[_veh] call AS_fnc_emptyCrate;
if (_tipo == (["AAF", "truck_ammo"] call AS_fnc_getEntity) and _side == "AAF") then {[_veh, "Convoy"] call AS_fnc_fillCrateAAF};
if (_tipo == (["CSAT", "box"] call AS_fnc_getEntity) and _side == "CSAT") then {[_veh, "AA"] call AS_fnc_fillCrateAAF};
// todo: add more equipment depending on spawing side / vehicle

if (_side != "NATO") then {
	// vehicle is stolen (NATO vehicles cannot be entered)
	_veh addEventHandler ["GetIn", {
		params ["_vehicle", "_position", "_unit"];
		[_vehicle, _unit call AS_fnc_getSide] call AS_fnc_setSide;
		if (isNil{_veh getVariable "boxCargo"}) then {_veh setVariable ["boxCargo",[], true];}
	}];

	if (_tipo isKindof "Truck_F" and {!(finite (getFuelCargo _veh))}) then {
		[_veh, "recoverEquipment"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated, true];
		};
};

//Cargo release on destruction

_veh addEventHandler ["Killed", {
	private _veh = _this select 0;
	[_veh] spawn AS_fnc_activateCleanup;
	if (!isNil{_veh getVariable "boxCargo"}) then {
		 {
			 detach _x;
		 } foreach (_veh getVariable "boxCargo");
		};

	}];

private _aaf_veh_EHkilled = {
	params ["_veh", "_killer"];
	//if (([_veh] call AS_fnc_getSide) != "AAF") exitWith {}; //If vehicle was stolen, there's nothing to do here

		//Deduct from AAF arsenal regardless of killers side
	[typeOf _veh] call AS_AAFarsenal_fnc_deleteVehicle;
	private _vehicleCategory = (typeOf _veh) call AS_AAFarsenal_fnc_category;

		//This was moved so XP is gained only if FIA is the killer or capturer
	if (side _killer == ("FIA" call AS_fnc_getFactionSide)) then {

		private _citySupportEffect = 0;
		private _xpEffect = "";
		switch _vehicleCategory do {
			case "planes": {
				_citySupportEffect = 5;
				_xpEffect = "des_arm";
			};
			case "helis_armed": {
				_citySupportEffect = 5;
				_xpEffect = "des_arm";
			};
			case "tanks": {
				_citySupportEffect = 4;
				_xpEffect = "des_arm";
			};
			case "helis_transport": {
				_citySupportEffect = 3;
				_xpEffect = "des_veh";
			};
			case "apcs": {
				_citySupportEffect = 2;
				_xpEffect = "des_arm";
			};
			case "boats" : {
				_xpEffect = "_des_veh";
				_citySupportEffect = 1;
			};
			case "cars_armed" : {
				_xpEffect = "_des_veh";
				_citySupportEffect = 1;
			};
			case "trucks" : {
				_xpEffect = "des_veh";
			};
			case "cars_transport" : {
				_xpEffect = "des_veh";
			};



			default {
				diag_log format ["[AS] ERROR in AS_AAF_VE_EHkilled: '%1' is invalid type", typeOf _veh];
			};
		};
		if (_citySupportEffect != 0) then {
			[-_citySupportEffect,_citySupportEffect,position _veh] remoteExec ["AS_fnc_changeCitySupport",2];
		};
		if (_xpEffect != "") then {[_xpEffect] remoteExec ["fnc_BE_XP", 2]};
	};
	//This eventhandler is no longer needed
	_veh removeEventHandler ["killed", _thisEventHandler];
};

_csat_veh_EHkilled = {
	params ["_veh", "_killer"];
	private _type = typeOf _veh;
	private _effect = 0;
	if (_type in (["CSAT", "helis_transport"] call AS_fnc_getEntity)) then {_effect = 5};
	if (_type in (["CSAT", "helis_attack"] call AS_fnc_getEntity)) then {_effect = 10};
	if (_type in (["CSAT", "planes"] call AS_fnc_getEntity)) then {_effect = 10};
	if (_type in (["CSAT", "helis_armed"] call AS_fnc_getEntity)) then {_effect = 5};

	[0, -(_effect)] remoteExec ["AS_fnc_changeForeignSupport", 2];
	[-(_effect/2),(_effect/2), position _veh] remoteExec ["AS_fnc_changeCitySupport",2];
	if (_type in (["CSAT", "helis_transport"] call AS_fnc_getEntity)) then {
		["des_arm"] remoteExec ["fnc_BE_XP", 2];
		} else {
		["des_veh"] remoteExec ["fnc_BE_XP", 2];
		};

	_veh removeEventHandler ["killed", _thisEventHandler];
};

if (_side  == "AAF" and not(_vehicleCategory == "")) then {
	//Steal Penalty

	_veh addEventHandler ["Getin", {
			private _vehicle = _this select 0;
			private _unitveh = _this select 2;
			private _sideunit = _unitveh call AS_fnc_getSide;
					if (_sideunit == "FIA") exitWith {

							[_vehicle, _unitveh] call _aaf_veh_EHkilled;
							//Changing sides are already handled via another EH
							_vehicle removeEventHandler ["Getin", _thisEventHandler];
					};
		}];

	_veh addEventHandler ["killed", _aaf_veh_EHkilled];
};

if (_side == "CSAT") then {
	_veh addeventHandler ["killed", _csat_veh_EHkilled];
};

// UAV is not part of the AAF arsenal, so the killing of it is dealt separately
if (_side == "AAF" and _tipo in (["AAF", "uavs_attack"] call AS_fnc_getEntity)) then {
    _veh addEventHandler ["killed",{[-2500] remoteExec ["AS_fnc_changeAAFmoney",2]}];
};

if (_tipo in AS_allMortarStatics) then {
	// mortars may denounce position for every shot fired.
	_veh addEventHandler ["Fired", {
		params ["_mortar"];
		private _side = side gunner _mortar;

		if (_side == ("FIA" call AS_fnc_getFactionSide)) then {
			if (random 8 < 1) then {
				if (_mortar distance (getMarkerPos "FIA_HQ") < 200) then {
					if (count ("aaf_attack_hq" call AS_mission_fnc_active_missions) == 0) then {
						private _lider = leader (gunner _mortar);
						if isPlayer _lider then {
							[[], "AS_mission_fnc_createDefendHQ"] remoteExec ["AS_scheduler_fnc_execute", 2];
						};
					};
				} else {
					[[position _mortar], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
				};
			};
		} else {
			// todo: chance of being detected by FIA if shot by AAF
		};
	}];
};

// start smoke script when hit for non-statics
if !(_veh isKindOf "StaticWeapon") then {
	_veh addEventHandler ["HandleDamage", {
        params ["_veh", "_part", "_dam"];
        if (_part == "") then {
            if ((_dam > 0.9) and (!isNull driver _veh)) then {
                [_veh] call AS_AI_fnc_activateSmokeCover;
            };
        };
    }];
};

// air units can only be piloted by humans
if (_vehicleCategory in ["planes", "helis_armed", "helis_transport"]) then {
	_veh addEventHandler ["GetIn", {
		private _posicion = _this select 1;
		if (_posicion == "driver") then {
			private _unit = _this select 2;
			if ((!isPlayer _unit) and (_unit getVariable ["BLUFORSpawn",false])) then {
				moveOut _unit;
				hint "Only Humans can pilot an air vehicle";
			};
		};
	}];
};

// cars receive no damage to wheels if no projectile is involved and driver is not player.
// to avoid becoming stuck
if (_veh isKindOf "Car") then {
	_veh addEventHandler ["HandleDamage", {
		params ["_unit", "_part", "_dam", "_attacker", "_proj"];
		if ((_part find "wheel" != -1) and (_proj == "") and (!isPlayer driver _unit)) then {
			0
		} else {
			_dam
		};
	}];
};

// NATO vehicles are locked and take support on destruction.
if (_side == "NATO") then {
    _veh lock 3;  // locked for players

    // do not accept AIs from players groups to enter.
    _veh addEventHandler ["GetIn", {
        private _unit = _this select 2;
        if ({isPlayer _x} count units group _unit > 0) then {
            moveOut _unit;
        };
    }];
    // lose support when vehicle is destroyed
    _veh addEventHandler ["killed", {
        [-2,0] remoteExec ["AS_fnc_changeForeignSupport",2];
        [2,-2,position (_this select 0)] remoteExec ["AS_fnc_changeCitySupport",2];
    }];
};

//Set vehicle fuel

if (_side == "FIA") then {
	if ((_tipo isKindOf "Car") or (_tipo isKindOf "Tank") or (_tipo isKindOf "Helicopter") or  (_tipo isKindOf "Plane") or (_tipo isKindOf "Boat")) then {
		_veh setFuelCargo 0;
		if (!(isNil "_fuel")) then {
			_veh setfuel _fuel;
			if (finite (getFuelCargo _veh)) then {
				_veh setVariable ["fuelCargo", _fuelCargo, true];
				[_veh, "refuel_truck"] remoteExecCall ["AS_fnc_addAction", [0, -2] select isDedicated, true];
				[_veh, "refuel_truck_check"] remoteExecCall ["AS_fnc_addAction", [0, -2] select isDedicated, true];
				};
			} else {
			_veh call AS_fuel_fnc_setVehicleFuel;
			};

		_veh setVariable ["boxCargo",[], true];
	};

	_veh addEventhandler ["Getin", {
			params ["_vehicle", "_role", "_unit", "_turret"];
			private _side = _unit call AS_fnc_getSide;
			if (_side != "FIA") then {
				if (_vehicle in AS_P("vehicles")) then {
					[_vehicle, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
				};
				//Here anything related to FIA vehicles being captured
			};

		}];

		_veh addEventHandler ["killed", {
			private _vehicle = _this select 0;
			if (_vehicle in (AS_P("vehicles"))) then {
				[_vehicle, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
				};
			}];


};

if (not(_side == "FIA")) then {

	if ((_tipo isKindOf "Car") or (_tipo isKindOf "Tank") or (_tipo isKindOf "Helicopter") or  (_tipo isKindOf "Plane") or (_tipo isKindOf "Boat")) then {

		if (not(_side == "AAF")) then {
			[_veh, 0.3, 1] call AS_fuel_fnc_randomFuelCargo;
		}
		else {
			private _min = 0.1;
			private _max = 1;
			private _AAFresAdj = [] call AS_fnc_getAAFresourcesAdj;

			//In case of low AAF resources, fuel tanks of their vehicles run dry

			_min = (0.3*(_AAFresAdj / 1500)) min 0.3;
			_max = (_AAFresAdj / 2000) min 1;
			[_veh, _min, _max] call AS_fuel_fnc_randomFuelCargo;

			//Same for vehicle ammo,
			_max = (0.9*(_AAFresAdj / 1000)) min 0.9;
			_veh setVehicleAmmoDef (0.1 + _max);

		};

		if (finite (getFuelCargo _veh)) then {
				//TODO Improve this to revert to FIA fuel system to prevent cheating. For AI must have vanilla fuel cargo system
				//TODO Ability to carry fuel can be checked by much simpler terms via dictionary fuel vehicle

			_veh addEventHandler ["Getin", {
				private _vehicle = _this select 0;
				private _unitveh = _this select 2;
				private _sideunit = _unitveh call AS_fnc_getSide;

				//After capturing fuel truck, make it FIA fuel system compatible

				if (_sideunit == "FIA") exitWith {
					_vehicle setFuelCargo 0;
					[_vehicle, "refuel_truck"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
					[_vehicle, "refuel_truck_check"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
					_vehicle removeEventHandler ["Getin", _thisEventHandler];

					};
				}];
		};
	};
};
