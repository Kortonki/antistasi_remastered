params ["_origin", "_destination", "_crew_group", "_patrol_marker", "_cargo_group", ["_threat", 0]];

{
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET"
} foreach units _crew_group;

private _distance = 400 + (10*_threat);

private _arrivePosition = [];
private _startDropPosition = [];
private _midDropPosition = [];

private _randang = random 360;

// find a position within distance from the target
private _midDropPosition = [_destination, _distance, _randang] call BIS_Fnc_relPos;
while {surfaceIsWater _midDropPosition} do {
	_randang = random 360;
 	_midDropPosition = [_destination, _distance, _randang] call BIS_Fnc_relPos;
};

_randang = _randang + 90;

private _endDropPosition = [_destination, 400, _randang] call BIS_Fnc_relPos;
while {surfaceIsWater _endDropPosition or _endDropPosition distance _destination < 300} do {
 	_endDropPosition = [_destination, 400, _randang] call BIS_Fnc_relPos;
 	_randang = _randang + 5;
 	if ((!surfaceIsWater _endDropPosition) and (_endDropPosition distance _destination > 300)) exitWith {};
};

_randang = ([_midDropPosition,_endDropPosition] call BIS_fnc_dirTo) - 180;

_startDropPosition = [_midDropPosition, 1000, _randang] call BIS_Fnc_relPos;

_arrivePosition = [_startDropPosition, 400, _randang] call BIS_fnc_relPos;

_crew_group setBehaviour "CARELESS";
vehicle (leader _crew_group) flyInHeight (150+(20*_threat));

private _wp0 = _crew_group addWaypoint [_arrivePosition, 0];
_wp0 setWaypointType "MOVE";
_wp0 setWaypointSpeed "NORMAL";

private _wp = _crew_group addWaypoint [_startDropPosition, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "LIMITED";

_crew_group setVariable ["AS_cargo_group", _cargo_group, true];
private _statement = {
    private _veh = vehicle this;
    if not alive _veh exitWith {};
	[group this getVariable "AS_cargo_group"] spawn {
		params ["_cargo_group"];
		{
		   unAssignVehicle _x;
		   _x allowDamage false;
		   moveOut _x;
		   sleep 0.35;
		   private _chute = createVehicle ["NonSteerable_Parachute_F", getPos _x, [], 0, "NONE"];
		   _chute setPos (getPos _x);
		   _x moveinDriver _chute;
		   _x allowDamage true;
		   sleep 0.5;
		} forEach units _cargo_group;
	};
};
_wp setWaypointStatements ["true", _statement call AS_fnc_codeToString];

// keep dropping
private _wp1 = _crew_group addWaypoint [_midDropPosition, 1];
_wp1 setWaypointType "MOVE";

// hopefully finish dropping
private _wp2 = _crew_group addWaypoint [_endDropPosition, 2];
_wp2 setWaypointType "MOVE";

// move group to mid point to re-group, and then patrol marker.
private _wp3 = _cargo_group addWaypoint [_midDropPosition, 0];
_wp3 setWaypointType "MOVE";

private _size = ((getMarkerSize _patrol_marker) select 0) min ((getMarkerSize _patrol_marker) select 1);
private _wp4 = _group addWaypoint [getMarkerpos _patrol_marker, _size];
_wp4 setWaypointType "SAD";
_wp4 setWaypointSpeed "NORMAL";
_wp4 setWaypointFormation "LINE";
_wp4 setWaypointBehaviour "AWARE";
_group setCurrentWaypoint _wp4;

_cargo_group setVariable ["AS_patrol_marker", _patrol_marker, true];
private _statement = {
    [this, group this getVariable "AS_patrol_marker", "AWARE", "SPAWNED"] spawn UPSMON;
};
_wp3 setWaypointStatements ["true", _statement call AS_fnc_codeToString];

// send the helicopter home
_crew_group addWaypoint [_origin, 0];
