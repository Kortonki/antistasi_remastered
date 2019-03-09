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
private _group = (group(driver _veh));
//If no destination set, it's the drivers groups waypoint

private _waypoint = currentWaypoint _group; //This is used for detection of a changed waypoint

if (_destination isEqualTo []) then {

	_destination = waypointPosition [_group, _waypoint];
};

diag_log format ["[AS] SetConvoyImmune started. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];

while {(alive _veh) and {((driver _veh) call AS_fnc_getSide) == _side and {_veh distance2D _destination > 50 and {currentWaypoint _group == _waypoint}}}} do {
	private _pos = getPos _veh;
	sleep 60;
	private _newPos = getPos _veh;
	// in case it stopped, give vehicles a nodge to continue
	if (_newPos distance _pos < 5 and {{_x distance2D _newPos < 500} count (allPlayers - (entities "HeadlessClient_F")) == 0}) then {
		_newPos = [[[_newPos,10]]] call BIS_fnc_randomPos;
		private _road = [_newPos,100] call BIS_fnc_nearestRoad;
		if (!isNull _road) then {
			_veh setPos getPos _road;
			diag_log format ["[AS] SetConvoyImmune. Vehicle returned to road. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];
		} else {
			_newPos = _newPos findEmptyPosition [1,10, (typeOf _veh)];
			if (!(_newPos isEqualTo [])) then{
				_veh setPos _newPos;
				diag_log format ["[AS] SetConvoyImmune. Vehicle set to new position. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];
			};

		};
	};
};

diag_log format ["[AS] SetConvoyImmune ended. Vehicle: %1 Type of vehicle %2 Destination: %3 Text %4", _veh, typeOf _veh, _destination, _text];
