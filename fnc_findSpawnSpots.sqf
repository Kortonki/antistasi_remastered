// find road spots to spawn vehicles on, provide initial heading
params [["_origin", [0,0,0]], ["_dest", [0,0,0]], ["_spot", false]];
private _startRoad = _origin;
private _roads = [];

private _tam = 20;

while {true} do {
    _roads = _startRoad nearRoads _tam;
    if (count _roads > 0) exitWith {};
    _tam = _tam + 10;
};

private _road = _roads select 0;
private _conRoads = roadsConnectedto _road;
private _posRoad = position _road;
private _dist = _posRoad distance2D _dest;
private _dir = getDir _road;

if (count _conRoads > 0 and {count (nearestobjects [_posRoad, ["house"], 1, true]) == 0}) then {
    {
        if ((position _x distance2D _dest) < _dist) then {
            _posRoad = position _x;
            _dist = _posRoad distance2D _dest;
            _dir = ([position _road, _posRoad] call BIS_fnc_dirTo);
        };
    } forEach _conRoads;
};



[position _road, _dir]
