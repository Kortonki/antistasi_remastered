params ["_position"];

// get closest airfield within some conditions
private _base = "";
private _closestDistance = 10000;
{
    private _busy = _x call AS_location_fnc_busy;
    private _pos = _x call AS_location_fnc_position;
    if (_position distance2D _pos < _closestDistance and
        _position distance2D _pos > 1500 and
        !(_x call AS_location_fnc_spawned) and !_busy) then {
        _base = _x;
        _closestDistance = _position distance2D _pos;
    };
} forEach (["base", "AAF"] call AS_location_fnc_TS);

_base
