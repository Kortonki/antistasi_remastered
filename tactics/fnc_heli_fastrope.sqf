params ["_origin", "_destination", "_crew_group", "_patrol_marker", "_cargo_group", ["_threat", 0]];

private _heli = vehicle (leader _crew_group);
private _safePosition = [_destination, (100 + 10*_threat) min 300, 500, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
private _wp1 = _crew_group addWaypoint [_safePosition, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "FULL";
_wp1 setWaypointBehaviour "CARELESS";
_heli flyinHeight 40;

_crew_group setVariable ["AS_cargo_group", _cargo_group, true];
private _statement = {
    private _veh = vehicle this;
    if not alive _veh exitWith {};
    private _cargo_group = group this getVariable "AS_cargo_group";
    0 = [_cargo_group, _veh] spawn SHK_Fastrope_fnc_AIs;
    //waitUntil {scriptDone _ropping};
};
_wp1 setWaypointStatements ["true", _statement call AS_fnc_codeToString];

private _wp2 = _cargo_group addWaypoint [_safePosition, 0];
_wp2 setWaypointType "MOVE";

private _size = ((getMarkerSize _patrol_marker) select 0) min ((getMarkerSize _patrol_marker) select 1);
private _wp4 = _cargo_group addWaypoint [getMarkerpos _patrol_marker, _size];
_wp4 setWaypointType "SAD";
_wp4 setWaypointSpeed "NORMAL";
_wp4 setWaypointFormation "LINE";
_wp4 setWaypointBehaviour "COMBAT";

_cargo_group setVariable ["AS_patrol_marker", _patrol_marker, true];
private _statement2 = {
    [this, group this getVariable "AS_patrol_marker", "COMBAT", "SPAWNED", "NOFOLLOW"] spawn UPSMON;
};
_wp2 setWaypointStatements ["true", _statement2 call AS_fnc_codeToString];

// send the helicopter home
sleep 5;
private _timeLeave = time + 60;
waitUntil {sleep 2; not(isnil {_heli getVariable "RoppingReady"}) or time > _timeLeave};
private _wp2 = _crew_group addWaypoint [_origin, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "FULL";
_wp1 setWaypointBehaviour "CARELESS";
_crew_group setCurrentWaypoint [_crew_group, 2];
