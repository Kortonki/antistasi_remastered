//Return vehicle fuel in liters

params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_getVehicleFuel.sqf: No vehicle specified"]; 0};

private _fuelTankSize = _vehicle call AS_fuel_fnc_getFuelTankSize;
private _fuel = fuel _vehicle;
if (isNil "_fuel") exitWith {0}; //failsafe

private _actualFuel = _fuel * _fuelTankSize;



_actualFuel
