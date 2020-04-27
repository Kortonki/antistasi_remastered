params [["_dist", 50]];
private _position = _this;
private _road = objNull;
private _dist = 50;
{
    if ((position _x) distance2D _position < _dist) then {
        _road = _x;
        _dist = (position _x) distance2D _position;
    };
} forEach (_position nearRoads _dist);
if (isNull _road) exitWith {[objNull, []]};
if (count (roadsConnectedto _road) == 0) exitWith {[objNull, []]};
private _roadcon = (roadsConnectedto _road) select 0;
private _dirveh = [_roadcon, _road] call BIS_fnc_DirTo;
[_road, _dirveh]
