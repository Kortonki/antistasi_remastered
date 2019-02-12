params ["_origin", "_destination", "_crew_group", "_marker", ["_threat", 0]];

private _safePosition = [_destination, _origin, _threat] call AS_fnc_getSafeRoadToUnload;
private _wp1 = _crew_group addWaypoint [_safePosition, 10];
_wp1 setWaypointType "UNLOAD";
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointBehaviour "SAFE";

private _size = ((getMarkerSize _marker) select 0) min ((getMarkerSize _marker) select 1);
private _wp2 = _crew_group addWaypoint [getMarkerpos _marker, _size];
_wp2 setWaypointType "SAD";
_wp2 setWaypointSpeed "NORMAL";
_wp2 setWaypointFormation "LINE";
_wp2 setWaypointBehaviour "COMBAT";

_crew_group setVariable ["AS_patrol_marker", _marker, true];

private _statement = {
    (vehicle (leader group this)) fire  "SmokeLauncher";
    [this, group this getVariable "AS_patrol_marker", "COMBAT", "SPAWNED", "NOFOLLOW"] spawn UPSMON;
};

_wp1 setWaypointStatements ["true", _statement call AS_fnc_codeToString];

[vehicle (leader _crew_group), "Attack", _safePosition] spawn AS_fnc_setConvoyImmune;
