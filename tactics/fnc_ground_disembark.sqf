params ["_origin", "_destination", "_crew_group", "_marker", "_cargo_group", ["_threat", 0]];

private _safePosition = [_destination, _origin, _threat] call AS_fnc_getSafeRoadToUnload;
private _wp1 = _crew_group addWaypoint [_safePosition, 0];
_wp1 setWaypointType "TR UNLOAD";
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointBehaviour "SAFE";
private _wp2 = _cargo_group addWaypoint [_safePosition, 0];
_wp2 setWaypointType "GETOUT";
_wp2 synchronizeWaypoint [_wp1];

_cargo_group setVariable ["AS_patrol_marker", _marker, true];

[_cargo_group, (vehicle leader _crew_group)] spawn AS_AI_fnc_DismountOnDanger;

[vehicle (leader _crew_group), "Attack", _safePosition] spawn AS_fnc_setConvoyImmune;

//Unnecessary if below is true when they disembark?
/*private _statement = {
    {deleteWaypoint _x} forEach waypoints (group this);
    [this, (group this) getVariable "AS_patrol_marker", "COMBAT", "SPAWNED", "NOFOLLOW"] spawn UPSMON;
};

_wp2 setWaypointStatements ["true", _statement call AS_fnc_codeToString];
*/


//Failsafe if vehicle fucks up
[_cargo_group, _safePosition, _crew_group] spawn {

    params ["_group", "_safePosition", "_crew_group"];
    private _leader = leader _group;

    waitUntil {sleep 5; _leader = leader _group; vehicle _leader == _leader or {alive _x} count (units _group) == 0 or _leader distance2D _safePosition < 70};
    if ({alive _x} count units _group == 0) exitWith {};

    private _marker = _group getVariable "AS_patrol_marker";
    private _size = ((getMarkerSize _marker) select 0) min ((getMarkerSize _marker) select 1);
    private _wp4 = _group addWaypoint [getMarkerpos _marker, _size];
    _wp4 setWaypointType "SAD";
    _wp4 setWaypointSpeed "NORMAL";
    _wp4 setWaypointFormation "LINE";
    _wp4 setWaypointBehaviour "AWARE";
    _group setCurrentWaypoint _wp4;

    {
      unassignVehicle _x;
      [_x] allowGetin false;
      [_x] orderGetin false;
    } foreach units _group;
    [_leader, _marker, "AWARE", "SPAWNED", "NOFOLLOW", "NOVEH2"] spawn UPSMON;
    sleep 10;
    _crew_group setCurrentWaypoint [_crew_group, 2];

};
// send home
private _wp3 = _crew_group addWaypoint [_origin, 0];
_wp3 setWaypointType "MOVE";
[vehicle (leader _crew_group), "Attack", waypointposition [_crew_group, 2]] spawn AS_fnc_setConvoyImmune;
