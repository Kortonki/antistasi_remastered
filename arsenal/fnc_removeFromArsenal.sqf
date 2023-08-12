#include "../macros.hpp"

params ["_cargo"];

//EXPERIMENT removal happens on SERVER and USCHEDULED -> no room for overlapping calls
//waitUntil {sleep 0.1; not(AS_S("lockTransfer"))};
//AS_Sset("lockTransfer", true);
waitUntil {not(lockArsenal)};
lockArsenal = true;
(call AS_fnc_getArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];
_cargo_w = [_cargo_w, _cargo select 0, false] call AS_fnc_mergeCargoLists;
_cargo_m = [_cargo_m, _cargo select 1, false] call AS_fnc_mergeCargoLists;
_cargo_i = [_cargo_i, _cargo select 2, false] call AS_fnc_mergeCargoLists;
_cargo_b = [_cargo_b, _cargo select 3, false] call AS_fnc_mergeCargoLists;

//this prolly unnecessary because above is a pointer to arsenal array
[_cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_setArsenal;

//AS_Sset("lockTransfer", false);
