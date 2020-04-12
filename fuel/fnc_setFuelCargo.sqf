#include "../macros.hpp"

params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_setFuelCargo.sqf: No vehicle specified"]; 0};

private _fuelReserves = AS_P("fuelFIA");

private _fuelCargoSize = _vehicle call AS_fuel_fnc_getFuelCargoSize;

private _fillAmount = 0;

//Low reserves (3  times the fuel tank size) won' t top up the fuel cargo

_fillAmount = _fuelReserves / 3;
_fillAmount = _fuelCargoSize min _fillAmount;

//_vehicle setFuelCargo (_fillAmount / _fuelCargoSize);
_vehicle setVariable ["fuelCargo", _fillAmount, true];
if (hasACE) then {
  [_vehicle, _fillAmount] call ace_refuel_fnc_setFuel;
};

//This is to not fill fuel cargo at all if it'd be very low to avoid floating point issues

/*if (getFuelCargo _vehicle < 0.01) exitWith {
  _vehicle setFuelCargo 0;
  private _text = "";

  _text = format ["The fuel cargo was left empty because of low fuel reserves\n\nFuel reserves:%1 l",round(_fuelReserves)];
  [petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", AS_commander];

  };
*/


[-_fillAmount] remoteExec ["AS_fuel_fnc_changeFIAfuelReserves", 2];



if (_fillAmount < _fuelCargoSize) then {

private _text = "";

_fuelReserves = AS_P("fuelFIA");
_text = format ["The fuel cargo wasn't topped up because of low fuel reserves\n\nFuel Cargo: %1 / %2 l\nFuel reserves:%3 l",round(_fillAmount), _fuelCargoSize, round(_fuelReserves)];
[petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", player];

};

[_vehicle, "refuel_truck"] remoteExecCall ["AS_fnc_addAction", [0, -2] select isDedicated];
[_vehicle, "refuel_truck_check"] remoteExecCall ["AS_fnc_addAction", [0, -2] select isDedicated];
