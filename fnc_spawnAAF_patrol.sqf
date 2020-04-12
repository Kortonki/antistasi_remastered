#include "macros.hpp"
params ["_location", "_amount"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _units = [];
private _groups = [];

// marker used to set the patrol area
private _mrk = createMarkerLocal [format ["%1patrolarea", random 100], _position];
_mrk setMarkerShapeLocal "RECTANGLE";
_mrk setMarkerSizeLocal [_size*1.5,_size*1.5];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_mrk setMarkerDirLocal (markerDir _location);  // ERROR
_mrk setMarkerAlphaLocal 0;

// spawn patrols
for "_i" from 1 to _amount do {
    if !(_location call AS_location_fnc_spawned) exitWith {};

    private _pos = [0,0,0];
    while {true} do {
        _pos = [_position, 150 + (random 350) ,random 360] call BIS_fnc_relPos;
        if (!surfaceIsWater _pos) exitWith {};
    };
    private _group = [_pos, "AAF" call AS_fnc_getFactionSide, [["AAF", "patrols"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup] call BIS_Fnc_spawnGroup;

    if (random 10 < 2.5) then {
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
