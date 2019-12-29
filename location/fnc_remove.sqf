#include "../macros.hpp"
AS_SERVER_ONLY("AS_location_fnc_remove");
params ["_location"];

//If AAF was patrolling it:

if (_location in AS_P("patrollingLocations")) then {
  AS_Pset("patrollingLocations", (AS_P("patrollingLocations") - [_location]));
};

// the hidden marker
deleteMarker _location;

private _marker = (format ["Dum%1", _location]);

// the shown marker
deleteMarker _marker;

[call AS_location_fnc_dictionary, _location] call DICT_fnc_delGlobal;
