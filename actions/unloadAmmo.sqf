params ["_pos"];
private _unit = _this select 1;

if (vehicle _unit == _unit) exitWith {
	_text = format ["You must be in the vehicle you want to unload"];
	[player,"hint",_text] remoteExec ["AS_fnc_localCommunication", _unit];
};

private _vehicle = vehicle _unit;

private _actualAmmo = _vehicle call AS_ammo_fnc_getVehicleAmmo;

[_actualAmmo] remoteExec ["AS_ammo_fnc_changeFIAammoReserves", 2];

diag_log _actualAmmo;

_vehicle setVehicleAmmo 0;