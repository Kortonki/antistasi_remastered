#include "macros.hpp"

params ["_mine", "_location"];

waitUntil {sleep AS_spawnLoopTime; isNull _mine}; //Mine explosion and location despawn should trigger this
if (!(_location call AS_location_fnc_spawned)) exitWith {}; //don't fiddle anything after despawn

private _mines = ([_location, "mines"] call AS_spawn_fnc_get);
private _minesData = ([_location, "mines"] call AS_location_fnc_get);

private _index = _mines find _mine;

//Delete the mine from both spawn and location
//deleteMarker ((_minesData select _index) select 1) call BIS_Fnc_nearestPosition;
//Find the nearest marker and delete ti

private _pos = ((_minesData select _index) select 1);
private _nearest = [allMapMarkers select {getMarkerType _x == "hd_dot"}, _pos] call BIS_Fnc_nearestPosition;

//This low "resolution" might cause problems
if (_nearest distance2d _pos <= 0.5) then {deleteMarker _nearest};

_mines deleteAt _index;
_minesData deleteAt _index;

[_location, "mines", _mines] call AS_spawn_fnc_set;
[_location, "mines", _minesData] call AS_location_fnc_set;

[_location] call AS_location_fnc_updateMarker;
