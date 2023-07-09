
params ["_location"];
waitUntil {sleep AS_spawnLoopTime; not(_location call AS_location_fnc_spawned)};

([_location, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];

if (_location call AS_location_fnc_side == "FIA") then {

_location call AS_fnc_collectDroppedEquipment;

};

//Send each soldier away from closest BLUFORspawn to avoid soldier multiplying when location despawns and spawns while
//soldiers do not (individually checked for spawn condition). OTOH removing them immediately might make them
//despawn far away from location but close to a player or FIA soldiers (UPSMON can send them away and otherwise)

[_groups, _vehicles, _markers] call AS_fnc_cleanResources;
[_location, "delete", true] call AS_spawn_fnc_set;
