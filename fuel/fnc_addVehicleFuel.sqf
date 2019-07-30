#include "../macros.hpp"

params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_addVehicleFuel.sqf: No vehicle specified"]; 0};

if (fuel _vehicle == 1) exitWith {
  _text = format ["This vehicle doesn't need fuel"];
	[player,"hint",_text] remoteExec ["AS_fnc_localCommunication", AS_commander];

};

private _fuelReserves = AS_P("fuelFIA");
private _fuelTankSize = _vehicle call AS_fuel_fnc_getFuelTankSize;
private _fillAmount = 0;
private _currentFuel = _vehicle call AS_fuel_fnc_getVehicleFuel;

_fillAmount = _fuelReserves / 8;
_fillAmount = (_fuelTankSize - _currentFuel) min _fillAmount;

[-_fillAmount] remoteExec ["AS_fuel_fnc_changeFIAfuelReserves", 2];

private _newFuel = _currentFuel + _fillAmount;
_vehicle setfuel (_newFuel / _fuelTankSize);

if (fuel _vehicle < 0.99) then {

  private _text = "";

  _fuelReserves = AS_P("fuelFIA");
  _text = format ["The fuel tank wasn't topped up because of low fuel reserves\n\nFuel in tank: %1 / %2 l\nFuel reserves: %3 l", round(_newFuel), _fuelTankSize, round(_fuelReserves)];
  [petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", player];

};

if (_vehicle call AS_fuel_fnc_getFuelCargoSize > 0) then {_vehicle call AS_fuel_fnc_addFuelCargo};
