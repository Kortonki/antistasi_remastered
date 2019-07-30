private _fuelTruck = _this select 0;
private _unit = _this select 1;

private _fuelCargo = call {
    if (!hasACE) exitWith {_fuelTruck getVariable ["fuelCargo", 0]};
    ([_fuelTruck] call ace_refuel_fnc_getFuel)
};

private _fuelCargoSize = _fuelTruck call AS_fuel_fnc_getFuelCargoSize;

_text = format ["Fuel in container:\n\n %1 / %2 l", round(_fuelCargo), _fuelCargoSize];
[petros,"hint",_text] remoteExec ["AS_fnc_localCommunication", _unit];
