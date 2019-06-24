params ["_vehicle"];

if (not(isNil {_vehicle getVariable "fuelCargoSize"})) exitWith {(_vehicle getVariable "fuelCargoSize")};

if !hasACE then {
	private _fuelCargoSize =  [(configFile >> "CfgVehicles" >> typeOf _vehicle), "transportfuel", 10000] call BIS_fnc_returnConfigEntry;
    } else {
	private _fuelCargoSize =  [(configFile >> "CfgVehicles" >> typeOf _vehicle), "ace_refuel_fuelCargo", 10000] call BIS_fnc_returnConfigEntry;
};	

_fuelCargoSize = _fuelCargoSize min 10000;

_vehicle setVariable ["fuelCargoSize", _fuelCargoSize, true];

_fuelCargoSize
