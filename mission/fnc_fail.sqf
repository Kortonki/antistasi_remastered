#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_fail");
(_this call AS_mission_fnc__getFailData) call AS_mission_fnc_execute;
[(_this select 0), "status", "completed"] call AS_mission_fnc_set;
