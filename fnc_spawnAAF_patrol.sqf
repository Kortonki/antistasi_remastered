#include "macros.hpp"
params ["_location", "_amount"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _units = [];
private _groups = [];

// marker used to set the patrol area
private _mrk = createMarker [format ["%1_%2_patrolarea", random 100, diag_tickTime], _position];
_mrk setMarkerShape "RECTANGLE";
_mrk setMarkerSize [_size*1.5,_size*1.5];
_mrk setMarkerType "hd_warning";
_mrk setMarkerColor "ColorRed";
_mrk setMarkerBrush "DiagGrid";
_mrk setMarkerDir(markerDir _location);  // ERROR
_mrk setMarkerAlpha 0;


private _count = 0;
_amount = round(_amount*AS_patrolSizeRef);
// spawn patrols
while {_count < _amount} do {
    if !(_location call AS_location_fnc_spawned) exitWith {};

    private _pos = [0,0,0];
    while {true} do {
        _pos = [_position, 150 + (random 350) ,random 360] call BIS_fnc_relPos;
        if (!surfaceIsWater _pos) exitWith {};
    };
    private _group = [_pos, "AAF" call AS_fnc_getFactionSide, [["AAF", "patrols"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup] call BIS_Fnc_spawnGroup;
    _count = _count + (count (units _group));

    if (random 10 < ((count _units)*2.5/AS_patrolSizeRef)) then {
        [_group] call AS_fnc_spawnDog;
    };
    [leader _group, _mrk, "SAFE","SPAWNED", "NOVEH"] spawn UPSMON;

    _groups pushBack _group;

};
{
private _group = _x;
  {
    [_x, false] call AS_fnc_initUnitAAF;
    _units pushBack _x;
  } forEach units _group;
} foreach _groups;

[_units, _groups, _mrk]
