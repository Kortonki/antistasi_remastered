// find road spots to spawn vehicles on, provide initial heading
params [["_origin", [0,0,0]], ["_dest", [0,0,0]], ["_spot", false]];
private _startRoad = _origin;
private _roads = [];

private _tam = 20;

while {_tam < 400} do {
    _roads = (_startRoad nearRoads _tam);
    if (count _roads > 50) exitWith {};
    _tam = _tam + 10;
};

//Shuffle so not always the same road found
_roads call AS_fnc_shuffle;

private _i = 0;
private _road = objNull;
private _valid = false;

//Fallbacks
private _dir = [_origin, _dest] call bis_fnc_dirto;
private _position = _origin;


while {!(_valid) and {_i < (count _roads)}} do {
  _road = _roads select _i;
  if ((position _road) call AS_fnc_isSafePos) then {
    _valid = true;
  };
  _i = _i + 1;
};

if (_valid) then {

  //Fallbacks if nothings found
  _position = position _road;
  _dir = getDir _road;


  private _conRoads = roadsConnectedto _road;
  private _posRoad = position _road;

  private _dist = _posRoad distance2D _dest;

//  and {count (nearestobjects [_posRoad, ["house"], 1, true]) == 0 //This commented out from below, checks already made above
  if (count _conRoads > 0) then {
      {

          if ((position _x distance2D _dest) < _dist) then {
              _posRoad = position _x;
              _dist = _posRoad distance2D _dest;
              _dir = ([position _road, _posRoad] call BIS_fnc_dirTo);
              //TODO: trigonometry here to put spot next to the road?
          };
      } forEach _conRoads;
    };

} else {

  //Apparently nearentities or nearobjects don't detect walls and buildings - nearestObjects does
  private _j = 50;
  private _initPos = +_origin;
  _initPos = [_initPos, _j*(random 2)/2, random 360] call BIS_fnc_relPos;
  _position = _initPos findEmptyPosition [5, 20, "B_MBT_01_TUSK_F"];
  while {!(_position call AS_fnc_isSafePos)} do {

    if (_j > 200) exitWith {
      _position = _origin;
      _dir = random 360;
      diag_log format ["AS_fnc_findSpawnSpots: Couldn't find safe spot to spawn near %1, reverting to origin position", _origin call AS_location_fnc_nearest];
    };

    _initPos = [_initPos, _j*(random 2)/2, random 360] call BIS_fnc_relPos;
    _position = _initPos findEmptyPosition [5, 20, "B_MBT_01_TUSK_F"];
    _j = _j + 10;

  };
};



[_position, _dir]
