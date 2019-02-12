params ["_location"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _vehicles = [];

if ("trucks" call AS_AAFarsenal_fnc_count > 0) then {
    private _type = selectRandom ("trucks" call AS_AAFarsenal_fnc_valid);
    private _pos = [_position, 0, 30, 8, 0, 50, 0,[], _position] call BIS_Fnc_findSafePos;
    //private _pos = _position findEmptyPosition [5,_size, _type];
    private _veh = createVehicle [_type, [_pos select 0, _pos select 1, 0.1], [], 0, "NONE"];
    _veh allowDamage false;
    _veh setDir random 360;
    _vehicles pushBack _veh;
    [_veh, "AAF"] call AS_fnc_initVehicle;
    _veh allowDamage true;
};
[_vehicles]
