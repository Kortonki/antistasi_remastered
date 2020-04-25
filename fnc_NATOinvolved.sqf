#include "macros.hpp"

if (
    (AS_P("NATOsupport") > 0 and {count ([["base", "airfield"], "FIA"] call AS_location_fnc_TS) > 0}) or
    (!isnil{["NATO_killCSAT_date"] call AS_stats_fnc_get}) or
    (!isnil{["NATO_killAAF_date"] call AS_stats_fnc_get})
    ) exitWith {true};

false
