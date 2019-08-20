#include "macros.hpp"
private ["_killed", "_group"];
_killed = _this select 0;

[_killed] call AS_debug_fnc_initDead;

if (_killed in AS_P("vehicles")) then {
	diag_log format ["Persistent vehicle deleted via AS_fnc_activate´Cleanup. Vehicle %1, location %2", _killed, (position _killed) call AS_location_fnc_nearest];
	[_killed, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
};

sleep AS_P("cleantime");
waitUntil {sleep 20; not([AS_P("spawnDistance"), _killed, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance)};

_group = group _killed;
[_killed] RemoteExecCall ["deleteVehicle", _killed];

if (!isNull _group) then {
	if ({alive _x} count units _group == 0) then {
		_group remoteExec ["deleteGroup", groupOwner _group];
	};
};
