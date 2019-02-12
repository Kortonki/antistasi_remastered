private _fuelTruck = _this select 0;
private _unit = _this select 1;

private _fuelCargo = _fuelTruck getVariable "fuelCargo";
private _fuelCargoSize = _fuelTruck call AS_fuel_fnc_getFuelCargoSize;

_text = format ["Fuel in container:\n\n %1 / %2 l", round(_fuelCargo), _fuelCargoSize];
[petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", _unit];
