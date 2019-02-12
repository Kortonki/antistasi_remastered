private _fuelTruck = _this select 0;
private _unit = _this select 1;

private _vehicle = vehicle _unit;

if (vehicle _unit == _unit) exitWith {
_text = "You must be inside a vehicle to refuel from a fuel truck";
[petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", _unit]
};

private _fuelCargo = _fuelTruck getVariable "fuelCargo";
private _fuelTankSize = _vehicle call AS_fuel_fnc_getFuelTankSize;

private _fillAmount = 0;
private _currentFuel = _vehicle call AS_fuel_fnc_getVehicleFuel;

_fillAmount = _fuelCargo / 8;
_fillAmount = (_fuelTankSize - _currentFuel) min _fillAmount;


_fuelCargo = _fuelCargo - _fillAmount;
_fuelTruck setVariable ["fuelCargo", _fuelCargo, true];

private _newFuel = _currentFuel + _fillAmount;
_vehicle setfuel (_newFuel / _fuelTankSize);

if (fuel _vehicle < 0.99) then {

  private _text = "";

  private _fuelCargoSize = _vehicle call AS_fuel_fnc_getFuelCargoSize;
  _text = format ["The fuel tank wasn't topped up because of low fuel level in the container\n\nFuel in tank: %1 / %2 l\nFuel in the container: %3 / %4 l", round(_newFuel), _fuelTankSize, round(_fuelCargo), _fuelCargoSize];
  [petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", _unit];

};
