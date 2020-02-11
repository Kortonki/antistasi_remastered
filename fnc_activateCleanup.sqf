#include "macros.hpp"
private _killed = _this select 0;
private _group = group _killed;


_killed setVariable ["inDespawner", true, true]; //this to make so activaVehicleCleanup doesn't activate for mission vehicles
if (_killed isKindof "AllVehicles") then {
	diag_log format ["ActivateCleanup activated for vehicle %1, Group %2 location %3", _killed, group _killed, (position _killed) call AS_location_fnc_nearest];
};

[_killed] call AS_debug_fnc_initDead;

if (_killed in (AS_P("vehicles"))) then {
	[_killed, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
	diag_log format ["Persistent vehicle deleted via AS_fnc_activateCleanup. Vehicle %1, location %2", _killed, (position _killed) call AS_location_fnc_nearest];
};

sleep AS_P("cleantime");
waitUntil {sleep 20; not([AS_P("spawnDistance"), _killed, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance) or isnull _killed};

//This happens in killed eventhandler
/*if (_killed call AS_fnc_getSide == "AAF") then {
	private _vehicleType = typeof _killed;
	[_vehicleType, false] call AS_AAFarsenal_fnc_spawnCounter;
};*/

if (!(isNull _killed)) then {
	_killed call AS_fnc_safeDelete;
};



if (!isNull _group) then {
	if ({alive _x} count units _group == 0) then {
		_group remoteExec ["deleteGroup", groupOwner _group];
	};
};
