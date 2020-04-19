params ["_location", "_amount", "_overrideSize"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

if (!isnil "_overrideSize") then {
  _size = _overrideSize;
};

private _radius = 50;
private _roads = _position nearRoads _radius;
private _excludedRoads = [];
private _valid = false;
private _pos_dir = [[],[]];


while {_radius <= _size and {!(_valid)}} do {


  while {_radius <= _size and {count (_roads - _excludedRoads) < 3}} do {
    _roads = _position nearRoads _radius;
    _radius = _radius + 50;
  };

  {
    private _road = _x;
    private _roadDir = getDir _road;
    //Take relative x coordinates to calculate width -> too wide is probably a runway -> exclude
    private _roadwidth = (((3 boundingBox _road) select 0) select 0) - (((3 boundingBox _road) select 1) select 0);
    if (_roadWidth <= 8) then {
      _valid = true; //Valid parking poss unless following checks fail
      private _initPos = [position _road, _roadWidth, _roadDir + 90] call BIS_fnc_relpOs;
      private _pos = +_initPos;
      for "_i" from 1 to _amount do {
        //check for objets, if anything found position is not valid and will check for new road
        //TODO improve this, eg make a function which checks for larger radius objects and their size -> that'd be the minimum distance for objects
        private _noclass = nearestobjects [_pos, [], 5, true];
        if (count _noclass > 0) exitWith {
          _pos_dir = [[],[]];
          _excludedRoads pushback _road;
          _valid = false;
        };

        (_pos_dir select 0) pushback _pos;
        (_pos_dir select 1) pushback (_roadDir + 90); //Make the nose of the vehicle point to road
        _pos = [_pos, 10, _roadDir] call BIS_fnc_relPos;
      };

    } else {
      _excludedRoads pushback _road;
    };
    if _valid exitWith {};
  } foreach (_roads - _excludedRoads);
};

//Findspawnspots as backup
if (count (_pos_dir select 0) == 0) then {
  for "_i" from 1 to _amount do {
    private _temp_pos_dir = [_position, ([_position, 50, random 360] call BIS_fnc_relPos)] call AS_fnc_findSpawnSpots;
    (_pos_dir select 0) pushback (_temp_pos_dir select 0);
    (_pos_dir select 1) pushback (_temp_pos_dir select 1); //Make the nose of the vehicle point to road
  };
};

_pos_dir
