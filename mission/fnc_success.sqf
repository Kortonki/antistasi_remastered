#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_success");
(_this call AS_mission_fnc__getSuccessData) call AS_mission_fnc_execute;
[(_this select 0), "status", "completed"] call AS_mission_fnc_set; //this changed to contain mission name only
["mis"] call fnc_BE_XP;
