params ["_crewGroup", "_vehicle", "_location", "_radius"];

private _vehiclePos = position _vehicle;
private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _wp0 = _crewGroup addWaypoint [position _vehicle, _radius];
_wp0 setWaypointType "SENTRY";
_wp0 setWaypointBehaviour "SAFE";
_wp0 setWaypointSpeed "LIMITED";


private _wp1 = _crewGroup addWaypoint [position _vehicle, 0];
_wp1 setWaypointType "GETIN";
_wp1 setWaypointBehaviour "AWARE";
_wp1 setWaypointSpeed "FULL";


private _patrolMarker = createMarker [format ["crew_sentry_%1", call AS_fnc_uniqueID], _position];
_patrolMarker setMarkerShape "RECTANGLE";
_patrolMarker setMarkerSize [_size,_size];
_patrolMarker setMarkerAlpha 0;

if (_vehicle isKindof "LandVehicle") then {
  [_vehiclePos, _position, _crewGroup, _patrolMarker] spawn AS_tactics_fnc_ground_attack;
} else {
  [_vehiclePos, _position, _crewGroup] spawn AS_tactics_fnc_heli_attack;
};

_patrolMarker
