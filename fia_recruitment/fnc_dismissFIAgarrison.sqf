#include "../macros.hpp"
params ["_type", "_location"];

if ([_location call AS_location_fnc_position, nil] call AS_fnc_enemiesNearby) exitWith {
	Hint "There are enemies near the zone. You can not dismiss units.";
};

[1, _type call AS_fnc_getCost] remoteExec ["AS_fnc_changeFIAmoney",2];

private _garrison = [_location, "garrison"] call AS_location_fnc_get;
_garrison deleteAt (_garrison find _type);
[_location, "garrison", _garrison] call AS_location_fnc_set;
