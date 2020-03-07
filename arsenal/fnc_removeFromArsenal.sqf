#include "../macros.hpp"

params ["_cargo"];

//EXPERIMENT removal happens on SERVER and USCHEDULED -> no room for overlapping calls
//waitUntil {sleep 0.1; not(AS_S("lockTransfer"))};
//AS_Sset("lockTransfer", true);
waitUntil {not(lockArsenal)};
lockArsenal = true;
([caja] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];
_cargo_w = [_cargo_w, _cargo select 0, false] call AS_fnc_mergeCargoLists;
_cargo_m = [_cargo_m, _cargo select 1, false] call AS_fnc_mergeCargoLists;
_cargo_i = [_cargo_i, _cargo select 2, false] call AS_fnc_mergeCargoLists;
_cargo_b = [_cargo_b, _cargo select 3, false] call AS_fnc_mergeCargoLists;

[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true, true] remoteExecCall ["AS_fnc_populateBox", 2];

//AS_Sset("lockTransfer", false);
