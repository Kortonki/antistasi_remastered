params ["_location"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _vehicles = [];

if ("trucks" call AS_AAFarsenal_fnc_countAvailable > 0) then {
    private _type = selectRandom ("trucks" call AS_AAFarsenal_fnc_valid);
    private _pos = _position;
    private _dir = random 360;
    //Prefer roads if near
    private _roads = _position nearroads _size;
    if (count _roads > 1) then {
      private _p1 = _roads select 0;
      if (count (roadsConnectedto _p1) > 0) then {
        private _p2 = getPos ((roadsConnectedto _p1) select 0);
        _dir = [_p1, _p2] call BIS_fnc_DirTo;
      };
      _pos = [_p1, 3, _dir + 90] call BIS_Fnc_relPos;
    } else {
      _pos = [_position, 0, 50, 8, 0, 0.5, 0,[], [_position, _position]] call BIS_Fnc_findSafePos;
    };
    //private _pos = _position findEmptyPosition [5,_size, _type];
    ([_type,_pos,"AAF", _dir] call AS_fnc_createEmptyVehicle) params ["_veh"];
    _vehicles pushBack _veh;
};
[_vehicles]
