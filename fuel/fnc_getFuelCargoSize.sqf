params ["_vehicle"];

if (not(isNil {_vehicle getVariable "fuelCargoSize"})) exitWith {(_vehicle getVariable "fuelCargoSize")};

private _type = typeOf _vehicle;
private _fuelCargoSize =  [(configFile >> "CfgVehicles" >> _type), "transportfuel", 10000] call BIS_fnc_returnConfigEntry;
_fuelCargoSize = _fuelCargoSize min 10000;

_vehicle setVariable ["fuelCargoSize", _fuelCargoSize, true];

_fuelCargoSize
