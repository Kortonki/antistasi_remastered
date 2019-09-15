#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_activate");
params ["_mission"];
[_mission, "status", "active"] call AS_mission_fnc_set;
waitUntil {sleep AS_spawnLoopTime; !(_mission call AS_spawn_fnc_exists)}; //This to check that no new spawn with same name during deletion
[_mission, "mission"] call AS_spawn_fnc_add;
[[_mission], "AS_spawn_fnc_execute"] call AS_scheduler_fnc_execute;
