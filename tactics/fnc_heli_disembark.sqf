params ["_origin", "_destination", "_crew_group", "_cargo_group", "_patrol_marker", ["_enemySide", "FIA"]];

private _vehicles = [];

// between 300m and 500m from destination, 10x10, max 0.3 sloop

private _threat = [_destination, _enemySide] call AS_fnc_getAirThreat;
private _distance = (400 + (_threat * 50)) min 1200;
private _landing_position = [_destination, _distance, _distance + 200, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
_landing_position set [2, 0];

private _pad = createVehicle ["Land_HelipadEmpty_F", _landing_position, [], 0, "NONE"];
_vehicles pushBack _pad;
private _wp0 = _crew_group addWaypoint [_landing_position, 0];
_wp0 setWaypointType "TR UNLOAD";
_wp0 setWaypointSpeed "NORMAL";
_wp0 setWaypointBehaviour "CARELESS";

private _wp3 = _cargo_group addWaypoint [_landing_position, 0];
_wp3 setWaypointType "GETOUT";
_wp0 synchronizeWaypoint [_wp3];

_cargo_group setVariable ["AS_patrol_marker", _patrol_marker, true];
/*private _statement = {
    {deleteWaypoint _x} forEach waypoints group this;
    [this, group this getVariable "AS_patrol_marker", "COMBAT", "SPAWNED", "NOFOLLOW"] spawn UPSMON;
};
_wp3 setWaypointStatements ["true", _statement call AS_fnc_codeToString];
*/
[_cargo_group, _landing_position, _crew_group] spawn {

    params ["_group", "_landing_position", "_crew_group"];
    private _leader = leader _group;

    waitUntil {sleep 5; _leader = leader _group; vehicle _leader == _leader or {alive _x} count (units _group) == 0 or _leader distance2D _landing_position < 70};
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
    [_leader, _marker, "AWARE", "SPAWNED", "NOVEH"] spawn UPSMON;
    sleep 10;
    _crew_group setCurrentWaypoint [_crew_group, 2];

};

// send home
private _wp2 = _crew_group addWaypoint [_origin, 1];
_wp2 setWaypointType "MOVE";

_vehicles
