params ["_position"];

// get closest airfield within some conditions
private _base = "";
private _closestDistance = 10000;
{
    private _busy = _x call AS_location_fnc_busy;
    private _pos = _x call AS_location_fnc_position;
    private _distance = _position distance2D _pos;
    if (_distance < _closestDistance and
        {_distance > 1500 and
        {!(_x call AS_location_fnc_spawned)}}) then {
        _base = _x;
        _closestDistance = _distance;
    };
} forEach (["base", "AAF"] call AS_location_fnc_TS);

_base
