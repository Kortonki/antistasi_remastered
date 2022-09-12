#include "../macros.hpp"
AS_SERVER_ONLY("AS_stats_fnc_fromDict");

params ["_dict"];
[] call AS_stats_fnc_deinitialize;
[AS_container, "stats", _dict call DICT_fnc_copyGlobal] call DICT_fnc_setGlobal; //Changed to copyglobal

//Legacy saves

if (isNil {["startdate"] call AS_stats_fnc_get}) then {
  [] call AS_stats_fnc_deinitialize;
  [] call AS_stats_fnc_initialize;
  ["startdate", [date select 0, 6, 6, 0, 0]] call AS_stats_fnc_set;
};

if (isnil {["storedmessages"] call AS_stats_fnc_get}) then {
  ["storedmessages", []] call AS_stats_fnc_set;
};
