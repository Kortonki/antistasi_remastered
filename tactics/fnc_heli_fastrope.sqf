params ["_origin", "_destination", "_crew_group", "_patrol_marker", "_cargo_group", ["_threat", 0]];

private _heli = vehicle (leader _crew_group);
private _safePosition = [_destination, (100 + 10*_threat) min 1000, 1100, 5, 0, 0.3, 0] call BIS_Fnc_findSafePos;

//HERE make waypoint past the actual position to avoid ARMA 3 feature of completing air waypoints too early

private _dir = [_heli, _safePosition] call bis_fnc_dirTo;
private _movePosition = [_safePosition, 500, _dir] call bis_fnc_relPos;

(leader _crew_group) domove _movePosition;
_heli flyinHeight 40;
_heli setBehaviour "SAFE";
_heli setSpeedMode "FULL";

//Failsafe: Continue after 5 minutes if conditions not met

private _timeRTB = time;

//Slow down when nearing the drop-off point

waitUntil {sleep 1; position _heli distance2D _safePosition < 400 or not(canmove _heli) or time > (_timeRTB + 300)};

_crew_group setSpeedMode "LIMITED";

waitUntil {sleep 1; position _heli distance2D _safePosition < 50 or not(canmove _heli)  or time > (_timeRTB + 300)};

//Move a little if chopper happens to be over water

if (surfaceIsWater (position _heli)) then {
  _safeposition = [_safepostion, 50, 200, 5, 0, 0.9, 0] call BIS_Fnc_findSafePos;

  _dir = [_heli, _safePosition] call bis_fnc_dirTo;
  _movePosition = [_safePosition, 500, _dir] call bis_fnc_relPos;

  (leader _crew_group) domove _movePosition;


  waitUntil {sleep 1; position _heli distance2D _safePosition < 50 or not(canmove _heli) or time > (_timeRTB + 300)};
};

[_cargo_group, _heli] spawn SHK_Fastrope_fnc_AIs;



//EXPERIMENT IF USING DOMOVE IS MORE RELIABLE
/*private _wp1 = _crew_group addWaypoint [_safePosition, 0];
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
_wp1 setWaypointStatements ["true", _statement call AS_fnc_codeToString];*/

private _wp2 = _cargo_group addWaypoint [_safePosition, 0];
_wp2 setWaypointType "MOVE";

private _size = ((getMarkerSize _patrol_marker) select 0) min ((getMarkerSize _patrol_marker) select 1);
private _wp4 = _cargo_group addWaypoint [getMarkerpos _patrol_marker, _size];
_wp4 setWaypointType "SAD";
_wp4 setWaypointSpeed "NORMAL";
_wp4 setWaypointFormation "LINE";
_wp4 setWaypointBehaviour "AWARE";

_cargo_group setVariable ["AS_patrol_marker", _patrol_marker, true];
private _statement2 = {
    [this, group this getVariable "AS_patrol_marker", "COMBAT", "SPAWNED", "NOFOLLOW", "NOVEH2"] spawn UPSMON;
};
_wp2 setWaypointStatements ["true", _statement2 call AS_fnc_codeToString];

// send the helicopter home
sleep 5;
private _timeLeave = time + (5*60); //Leave after minute (failsafe)
waitUntil {sleep 2; not(isnil {_heli getVariable "RoppingReady"}) or time > _timeLeave};
private _wp1 = _crew_group addWaypoint [_origin, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "FULL";
_wp1 setWaypointBehaviour "CARELESS";
_crew_group setCurrentWaypoint [_crew_group, 2];
