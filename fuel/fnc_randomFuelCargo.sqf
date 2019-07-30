params ["_vehicle",["_min", 0],["_max",1]];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_randomFuelCargo.sqf: No vehicle specified"]; 0};

_vehicle setfuel (_min + random (_max-_min));
private _fuelCargoSize = _vehicle call AS_fuel_fnc_getFuelCargoSize;

if (_fuelCargoSize > 0) then {

  private _type = typeOf _vehicle;
  private _fillAmount = (_min + random (_max-_min)) * _fuelCargoSize;
  _vehicle setVariable ["fuelCargo", _fillAmount, true];
  if (hasACE) then {
    [_vehicle, _fillAmount] call ace_refuel_fnc_setFuel;
  };


};
