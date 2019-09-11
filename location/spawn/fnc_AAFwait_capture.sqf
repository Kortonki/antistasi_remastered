params ["_location"];
private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _soldados = [_location, "soldiers"] call AS_spawn_fnc_get;

private _fnc_was_captured = {
    (({(not(vehicle _x isKindOf "Air"))} count ([_size, _position, "BLUFORSpawn"] call AS_fnc_unitsAtDistance)) >
     3*({_x call AS_fnc_canFight and {_x distance2D _position < _size}} count _soldados))
};

private _was_captured = false;
waitUntil {sleep AS_spawnLoopTime;
    _was_captured = call _fnc_was_captured;
    (not (_location call AS_location_fnc_spawned)) or _was_captured
};

if _was_captured then {
    [_location] remoteExec ["AS_fnc_win_location", 2];


    //Send nearby units for a quick counterattack
    //TODO: make this an external function, without adjustable params
    //TODO: make this qwork iwth upsmon
    {

      if (!(side _x in [("FIA" call AS_fnc_getFactionSide), civilian]) and {_x == (leader _x)} and {_x distance _position < 1000}) then {
        if (_x distance _position < 300) then {
          _x move _position;
        } else {
          //Farther groups have probability to move based on their distance. Farther units have less probability, 300m away are sure to come.
          if ((random 1) < (300/(_x distance _position))) then {

            if (vehicle _x != _x) then {
                private _wp0 = (group _x) addWaypoint [_position, 500]; //TODO: improve this to consider the direction of approach
                _wp0 setWaypointType "UNLOAD";
                _wp0 setWaypointBehaviour "SAFE";
                (group _x) setCurrentWaypoint _wp0;
                private _wp1 = (group _x) addwaypoint [_position, 10];
                _wp1 setWaypointBehaviour "AWARE";

            } else {
                group _x move _position;

                group _x setSpeedMode "FULL";
                group _x setBehaviour "AWARE";
                group _x setFormation "LINE";
            };
          };
        };
      };
        } forEach allUnits;
};
