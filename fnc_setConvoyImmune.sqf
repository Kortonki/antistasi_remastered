//HOW TO USE: call everytime a new waypoint is set with new waypoint location as second argument

params [
"_veh",
"_text",
["_destination", [],[[]], 3]
];

If (typeOf _veh != "LandVehicle") exitWith {}; //Exit for air vehicles and such

waitUntil {sleep 5; (alive _veh) and {!(isNull driver _veh)}};
private _side = side (driver _veh);

//If no destination set, it's the drivers groups waypoint

private _waypoint = currentWaypoint (group(driver _veh)); //This is used for detection of a changed waypoint

if (_destination isEqualTo []) then {

	_destination = waypointPosition [group (driver _veh), _waypoint];
};



while {(alive _veh) and {side (driver _veh) == _side and {_veh distance _destination > 50 and {currentWaypoint (group(driver _veh)) == _waypoint}}}} do {
	private _pos = getPos _veh;
	sleep 60;
	private _newPos = getPos _veh;
	// in case it stopped, give vehicles a nodge to continue
	if (_newPos distance _pos < 5 and {{_x distance _newPos < 500} count (allPlayers - (entities "HeadlessClient_F")) == 0}) then {
		_newPos = [[[_newPos,10]]] call BIS_fnc_randomPos;
		private _road = [_newPos,100] call BIS_fnc_nearestRoad;
		if (!isNull _road) then {
			_veh setPos getPos _road;
		} else {
			_newPos = _newPos findEmptyPosition [1,10, (typeOf _veh)];
			if (!(_newPos isEqualTo [])) then{ _veh setPos _newPos;};

		};
	};
};
