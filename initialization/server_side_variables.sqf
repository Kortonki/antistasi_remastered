[] call fnc_BE_initialize;

"spawnNATO" setMarkerType (["NATO", "flag_marker"] call AS_fnc_getEntity);
"spawnNATO" setMarkerText ((["NATO", "shortname"] call AS_fnc_getEntity) + " Carrier");
"spawnCSAT" setMarkerType (["CSAT", "flag_marker"] call AS_fnc_getEntity);
"spawnCSAT" setMarkerText ((["CSAT", "shortname"] call AS_fnc_getEntity) + " Carrier");
