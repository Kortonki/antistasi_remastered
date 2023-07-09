#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_activate");
params ["_mission"];
if (_mission call AS_spawn_fnc_exists) exitWith {diag_log format ["[AS] mission activate error: Mission %1 tried to activate while it was still spawned", _mission]}; //This to check that no new spawn with same name during deletion
[_mission, "status", "active"] call AS_mission_fnc_set;
[_mission, "mission"] call AS_spawn_fnc_add;
[[_mission], "AS_spawn_fnc_execute"] call AS_scheduler_fnc_execute;
