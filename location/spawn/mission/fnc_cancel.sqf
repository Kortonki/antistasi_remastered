#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_cancel");
[(_this select 0), "status", "completed"] call AS_mission_fnc_set;
