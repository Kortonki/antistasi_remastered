#include "../macros.hpp"

params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_setVehicleFuel.sqf: No vehicle specified"]; 0};

private _fuelReserves = AS_P("fuelFIA");
private _fuelTankSize = _vehicle call AS_fuel_fnc_getFuelTankSize;
private _fillAmount = 0;

//Low reserves (8  times the fuel tank size) won' t top up the fuel tank

_fillAmount = _fuelReserves / 8;
_fillAmount = _fuelTankSize min _fillAmount;

[-_fillAmount] remoteExec ["AS_fuel_fnc_changeFIAfuelReserves", 2];

_vehicle setfuel (_fillAmount / _fuelTankSize);

if (_fillAmount < _fuelTankSize) then {

private _text = "";

_fuelReserves = AS_P("fuelFIA");
_text = format ["The fuel tank wasn't topped up because of low fuel reserves\n\nFuel in tank: %1 / %2 l\nFuel reserves: %3 l", round(_fillAmount), _fuelTankSize, round(_fuelReserves)];
[petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", player];


};


if (finite (getFuelCargo _vehicle)) then {_vehicle call AS_fuel_fnc_setFuelCargo;};
