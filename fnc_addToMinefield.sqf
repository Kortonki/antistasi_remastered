#include "macros.hpp"
AS_SERVER_ONLY("fnc_addToMinefield.sqf");
params ["_closest", ["_mineData", []], "_projectile"];

private _minesData = [_closest, "mines"] call AS_location_fnc_get;

_minesData pushBack _mineData;

[_closest, "mines", _minesData, true] call AS_location_fnc_set;

// Also add to the spawn which exists because the player is close. The mine gets deleted properly and not duplicate

waitUntil {AS_spawnLoopTime; _closest call AS_spawn_fnc_exists};

private _mines = [_closest, "mines"] call AS_spawn_fnc_get;
_mines pushBack _projectile;
[_closest, "mines", _mines] call AS_spawn_fnc_set;

[_projectile, _closest] spawn AS_fnc_mineFieldCheck;

_closest call AS_location_fnc_updateMarker;
