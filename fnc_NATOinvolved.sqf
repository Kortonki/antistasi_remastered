#include "macros.hpp"

if (
    (AS_P("NATOsupport") > 0 and {count ([["base", "airfield"], "FIA"] call AS_location_fnc_TS) > 0}) or
    (["NATO_killCSAT_date"] call AS_stats_fnc_exists) or
    (["NATO_killAAF_date"] call AS_stats_fnc_exists)
    ) exitWith {true};

false
