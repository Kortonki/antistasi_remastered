//HOW TO USE: call everytime a new waypoint is set with new waypoint location as second argument

params [
"_veh",
["_text",""],
["_destination", []]
];

If (!(_veh isKindOf "LandVehicle")) exitWith {}; //Exit for air vehicles and such


waitUntil {sleep 5; (alive _veh) and {!(isNull driver _veh)}};
private _driver = driver _veh;
private _side = _driver call AS_fnc_getSide;
private _group = (group _driver);
//If no destination set, it's the drivers groups waypoint

private _waypoint = currentWaypoint _group; //This is used for detection of a changed waypoint

if (_destination isEqualTo []) then {

	_destination = waypointPosition [_group, _waypoint];
};

diag_log format ["[AS] SetConvoyImmune started. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];

while {(alive _veh) and {!(isNull driver _veh) and {((driver _veh) call AS_fnc_getSide) == _side and {_veh distance2D _destination > 50 and {currentWaypoint _group == _waypoint}}}}} do {
	private _pos = getPos _veh;
	sleep 60;
	private _newPos = getPos _veh;
	// in case it stopped, give vehicles a nodge to continue
	if (_newPos distance2D _pos < 10 and {{_x distance2D _newPos < 500} count (allPlayers - (entities "HeadlessClient_F")) == 0}) then {
		_newPos = [[[_newPos,20]]] call BIS_fnc_randomPos;
		private _road = [_newPos,100] call BIS_fnc_nearestRoad;
		sleep (random 10);
		if (!isNull _road) then {
			_veh setVehiclePosition [getPos _road, [], 0 , "NONE"];
			diag_log format ["[AS] SetConvoyImmune. Vehicle returned to road. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];
		} else {
			_newPos = _newPos findEmptyPosition [1,20, (typeOf _veh)];
			if (!(_newPos isEqualTo [])) then{
				_veh setVehiclePosition [_newPos, [], 0, "NONE"];
				diag_log format ["[AS] SetConvoyImmune. Vehicle set to new position. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];
			};

		};
		//Give new domove command to the original waypoint avoid getting stuck
		//(driver _veh) domove _destination;

		//Experiment refreshing the currentwaypoint
		_group setCurrentWaypoint [_group, 0];
		sleep 1;
		_group setCurrentWaypoint [_group, _waypoint];
		if ((leader _group) in (crew _veh)) then {
			_group selectLeader (effectiveCommander _veh);
		};
		(driver _veh) dofollow (leader _group);
	};
};

//If driver got out because vehicle flipped, do following checks
(_veh call BIS_fnc_getPitchBank) params ["_vx","_vy"];
private _isFlipped = if (([_vx,_vy] findIf {_x > 70 || _x < -70}) != -1) then {true} else {false};

//If flipped and not captured, set upright and spawn new convoysetimmune
if (_isFlipped and {_veh call AS_fnc_getSide == _side and {{_x distance2D (position _veh) < 500} count (allPlayers - (entities "HeadlessClient_F")) == 0}}) exitWith {
	_veh setVectorUp (surfaceNormal (position _veh));
	_driver assignAsDriver _veh;
	_driver moveinDriver _veh;
	_group addVehicle _veh;

	[_veh, _text, _destination] spawn AS_fnc_setConvoyImmune;

	diag_log format ["[AS] SetConvoyImmune ended and restarted. Vehicle flipped, crew reassigned. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];


};

diag_log format ["[AS] SetConvoyImmune ended. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];
