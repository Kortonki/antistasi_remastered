params ["_location"];
private _posicion = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;
private _fnc_was_captured_OPFOR = {
    (({(not(vehicle _x isKindOf "Air"))} count ([_size, _posicion, "OPFORSpawn"] call AS_fnc_unitsAtDistance)) > 0
    and {({(not(vehicle _x isKindOf "Air"))} count ([_size, _posicion, "BLUFORSpawn"] call AS_fnc_unitsAtDistance)) == 0}
     )
};

private _fnc_was_captured_BLUFOR = {
    (({(not(vehicle _x isKindOf "Air"))} count ([_size, _posicion, "BLUFORSpawn"] call AS_fnc_unitsAtDistance)) > 0
    and {({(not(vehicle _x isKindOf "Air"))} count ([_size, _posicion, "OPFORSpawn"] call AS_fnc_unitsAtDistance)) == 0}
     )
};

private _was_captured_OPFOR = false;
private _was_captured_BLUFOR = false;

waitUntil {sleep AS_spawnLoopTime;
    _was_captured_OPFOR = call _fnc_was_captured_OPFOR;
    _was_captured_BLUFOR = call _fnc_was_captured_BLUFOR;
    (not (_location call AS_location_fnc_spawned)) or _was_captured_OPFOR or _was_captured_BLUFOR
};

if (_was_captured_OPFOR) then {
  [_location] remoteExec ["AS_fnc_lose_neutrallocation", 2];
};

if (_was_captured_BLUFOR) then {
  [_location] remoteExec ["AS_fnc_win_neutrallocation", 2];

};
