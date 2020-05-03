params ["_type", "_location", "_side"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

_position = [_position, 0, _size, 10, 0, 0.3, 0, [], [_position, _position]] call BIS_Fnc_findSafePos;

([_type, _position, random 360, _side, "crew", 0, "NONE", false] call AS_fnc_createVehicle) params ["_vehicle", "_group", "_driver"];

private _patrolMarker = createMarker [format ["vehpatrol_%1%2", round (diag_tickTime/60), round (random 100)], _position];
_patrolMarker setMarkerShape "ELLIPSE";
_patrolMarker setMarkerSize [_size,_size];
_patrolMarker setMarkerAlpha 0;

[leader _group, _patrolMarker, "SAFE", "LIMITED", "SPAWNED", "ONROAD"] spawn UPSMON;

[_vehicle, _group, _patrolMarker]
