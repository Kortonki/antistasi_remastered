#include "../macros.hpp"
AS_SERVER_ONLY("AS_stats_fnc_initialize");
[AS_container, "stats", call DICT_fnc_create] call DICT_fnc_setGlobal; //What does dict_fnc_create return? an object

[] call AS_stats_fnc_init;
