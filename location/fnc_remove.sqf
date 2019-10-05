#include "../macros.hpp"
AS_SERVER_ONLY("AS_location_fnc_remove");
params ["_location"];

//If AAF was patrolling it:

if (_location in AS_P("patrollingLocations")) then {
  AS_Pset("patrollingLocations", (AS_P("patrollingLocations") - [_location]));
};

// the hidden marker
deleteMarker _location;

// the shown marker
deleteMarker (format ["Dum%1", _location]);

waitUntil {sleep AS_spawnLoopTime; (call AS_mission_fnc_active_missions) find (format ["defend_location_%1", _location]) == -1};

[call AS_location_fnc_dictionary, _location] call DICT_fnc_delGlobal;
