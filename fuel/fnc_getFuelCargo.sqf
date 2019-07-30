//Return vehicle fuel cargo in liters

//OBSOLETE with setVariable based fuel cargo

params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_getFuelCargo.sqf: No vehicle specified"]; 0};


if (not(_vehicle call AS_fuel_fnc_getFuelCargoSize > 0)) exitWith {0};

if (!hasACE) exitWith {_vehicle getVariable ["fuelCargo", 0]};

[_vehicle] call ace_refuel_fnc_getFuel



/* private _type = typeOf _vehicle;
private _fuelCargoSize = [(configFile >> "CfgVehicles" >> _type), "transportfuel", 10000] call BIS_fnc_returnConfigEntry;

private _actualFuelCargo = _fuelCargoSize * _fuelCargo;
*/
