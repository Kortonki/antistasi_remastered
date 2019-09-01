/*
Controlled way to despawn a vehicle. The vehicle is despawned when (AND):
* it is not a saved vehicle
* it is not close to FIA_HQ
* there is no BLUFOR around
*/
#include "macros.hpp"
params ["_vehicle"];

if (_vehicle getVariable ["inDespawner", false]) exitWith {};
_vehicle setVariable ["inDespawner", true, true];

//Spawndistance - 100 because while the location might be outside spawndistance, the object might not. Can cause loc to respawn while old objects still there
waitUntil {
	sleep AS_spawnLoopTime;
	not([(AS_P("spawnDistance") - 100), _vehicle, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance)
};

if (alive _vehicle and {_vehicle call AS_fnc_getSide == "AAF"}) then {
	//Deduct from spawned vehicles. Killed vehicles are deducted from arsenal elsewhere
	private _vehicleType = typeof _vehicle;
	[_vehicleType, false] call AS_AAFarsenal_fnc_spawnCounter;
};

if (_vehicle in AS_S("reportedVehs")) then {
	AS_Sset("reportedVehs", AS_S("reportedVehs") - [_vehicle]);
};
if (_vehicle in AS_P("vehicles")) exitWith {
	diag_log format ["Persistent vehicle attempt to delete via AS_fnc_activateVehicleCleanup. Vehicle %1, location %2", _vehicle, (position _vehicle) call AS_location_fnc_nearest];
	//[_vehicle, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
};
if (_vehicle isKindOf "test_EmptyObjectForSmoke") then {
	{[_x] RemoteExecCall ["deleteVehicle", _x]} forEach (_vehicle getVariable ["effects", []]);
};
{
	detach _x;
	_x setvariable ["asCargo", false, true];
} foreach attachedobjects _vehicle;

[_vehicle] RemoteExecCall ["deleteVehicle", _vehicle];
