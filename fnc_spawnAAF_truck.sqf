params ["_location"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _vehicles = [];

if ("trucks" call AS_AAFarsenal_fnc_count > 0) then {
    private _type = selectRandom ("trucks" call AS_AAFarsenal_fnc_valid);
    private _pos = [_position, 0, 30, 8, 0, 50, 0,[], _position] call BIS_Fnc_findSafePos;
    //private _pos = _position findEmptyPosition [5,_size, _type];
    ([_type,_pos,"AAF", random 360] call AS_fnc_createEmptyVehicle) params ["_veh"];
    _vehicles pushBack _veh;
};
[_vehicles]
