params ["_pos"];
private _unit = _this select 1;

if (vehicle _unit == _unit) exitWith {
	_text = format ["You must be in the vehicle you want to refuel"];
	[player,"hint",_text] remoteExec ["AS_fnc_localCommunication", _unit];
};

private _vehicle = vehicle _unit;

_vehicle call AS_fuel_fnc_addVehicleFuel;
