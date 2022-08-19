params ["_origin", "_destination", "_crew_group"];

private _wp1 = _crew_group addWaypoint [_destination, 1];
_wp1 setWaypointBehaviour "COMBAT";
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointCombatMode "RED";

private _wp2 = _crew_group addWaypoint [getWPPos _wp1, 0.5];
private _wp3 = _crew_group addWaypoint [getWPPos _wp1, 0.5];
private _wp4 = _crew_group addWaypoint [getWPPos _wp1, 0.5];
private _wp5 = _crew_group addWaypoint [getWPPos _wp1, 0.5];

_wp1 setWaypointposition [[((getWPPos _wp1 select 0)-1000), (getWPPos _wp1 select 1), 0], 0];
_wp2 setWaypointposition [[((getWPPos _wp2 select 0)+1000), (getWPPos _wp2 select 1), 0], 0];
_wp3 setWaypointposition [[(getWPPos _wp3 select 0), ((getWPPos _wp3 select 1)-1000), 0], 0];
_wp4 setWaypointposition [[(getWPPos _wp4 select 0), ((getWPPos _wp4 select 1)+1000), 0], 0];

_wp5 setWaypointposition [getWPPos _wp1, 2];
_wp5 setWayPointType "CYCLE";
