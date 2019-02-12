#include "../macros.hpp"

params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_addFuelCargo.sqf: No vehicle specified"]; 0};

private _fuelReserves = AS_P("fuelFIA");

private _fuelCargoSize = _vehicle call AS_fuel_fnc_getFuelCargoSize;

private _fillAmount = 0;
private _currentFuelCargo = _vehicle call AS_fuel_fnc_getFuelCargo;

_fillAmount = _fuelReserves / 3;
_fillAmount = (_fuelCargoSize - _currentFuelCargo) min _fillAmount;



private _newFuelCargo = _currentFuelCargo + _fillAmount;
_vehicle setVariable ["fuelCargo", _newFuelCargo, true];
//_vehicle setfuelCargo (_newFuelCargo / _fuelCargoSize);

/*if (getFuelCargo _vehicle < 0.01) exitWith {
  _vehicle setfuelCargo 0;
  private _text = "";

  _text = format ["The fuel cargo was left empty because of low fuel reserves\n\nFuel reserves:%1 l",round(_fuelReserves)];
  [petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", AS_commander];

  };
*/


[-_fillAmount] remoteExec ["AS_fuel_fnc_changeFIAfuelReserves", 2];

if (_newFuelCargo != _fuelCargoSize) then {

private _text = "";

_fuelReserves = AS_P("fuelFIA");
_text = format ["The fuel cargo wasn't topped up because of low fuel reserves\n\nFuel Cargo: %1 / %2 l\nFuel reserves: %3 l",round(_newFuelCargo), _fuelCargoSize, round(_fuelReserves)];
[petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", player];

};
