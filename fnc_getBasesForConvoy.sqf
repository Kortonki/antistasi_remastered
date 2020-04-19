#include "macros.hpp"

params ["_position", ["_types", ["base"]]];


//Pick up random from valid
private _bases = [];
private _closestDistance = 10000;
{
    private _busy = _x call AS_location_fnc_busy;
    private _pos = _x call AS_location_fnc_position;
    private _distance = _position distance2D _pos;
    if (_distance < _closestDistance and
        {_distance > AS_P("spawnDistance") and
        {!(_x call AS_location_fnc_spawned)}}) then {
        _bases pushback _x;
    };
} forEach ([_types, "AAF"] call AS_location_fnc_TS);

if (count _bases > 0) exitWith {
  (selectRandom _bases)
};

""
