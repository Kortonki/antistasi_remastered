#include "macros.hpp"
private ["_killed", "_group"];
_killed = _this select 0;

_killed setVariable ["inDespawner", true, true]; //this to make so activaVehicleCleanup doesn't activate for mission vehicles

[_killed] call AS_debug_fnc_initDead;

if (_killed in AS_P("vehicles")) then {
	diag_log format ["Persistent vehicle deleted via AS_fnc_activateCleanup. Vehicle %1, location %2", _killed, (position _killed) call AS_location_fnc_nearest];
	[_killed, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
};

sleep AS_P("cleantime");
waitUntil {sleep 20; not([AS_P("spawnDistance"), _killed, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance)};

//This happens in killed eventhandler
/*if (_killed call AS_fnc_getSide == "AAF") then {
	private _vehicleType = typeof _killed;
	[_vehicleType, false] call AS_AAFarsenal_fnc_spawnCounter;
};*/

_group = group _killed;
[_killed] RemoteExecCall ["deleteVehicle", _killed];

if (!isNull _group) then {
	if ({alive _x} count units _group == 0) then {
		_group remoteExec ["deleteGroup", groupOwner _group];
	};
};
