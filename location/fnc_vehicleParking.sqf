params ["_location", "_amount", ["_class", "trucks"], "_overrideSize", "_overrideGap"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _gap = 10;

if (!isnil "_overrideGap") then {
  _gap = _overrideGap;
};

if (!isnil "_overrideSize") then {
  _size = _overrideSize;
};

private _radius = 50;
private _roads = (_position nearRoads _radius);
private _excludedRoads = [];
private _valid = false;
private _pos_dir = [[],[]];


//Increase size for a good measure to find good parking spots
while {_radius <= _size*1.5 and {!(_valid)}} do {


  while {_radius <= _size*1.5 and {count (_roads - _excludedRoads) < 3}} do {
    _roads = (_position nearRoads _radius);
    _radius = _radius + 10;
  };

  _roads call AS_fnc_shuffle; //Shuffle to not necessarily pick roads next to center or next to each other

  {
    private _road = _x;
    private _roadDir = getDir _road;
    //Take relative x coordinates to calculate width -> too wide is probably a runway -> exclude
    private _roadwidth = (((3 boundingBox _road) select 0) select 0) - (((3 boundingBox _road) select 1) select 0);
    //private _roadwidth = (getRoadInfo _road) select 1;
    if (_roadWidth <= 8) then {
      _valid = true; //Valid parking poss unless following checks fail
      private _initPos = [position _road, _roadWidth, _roadDir + 90] call BIS_fnc_relpos;
      private _pos = +_initPos;
      for "_i" from 1 to _amount do {
        //check for objets, if anything found position is not valid and will check for new road
        //TODO improve this, eg make a function which checks for larger radius objects and their size -> that'd be the minimum distance for objects

        _pos = _pos findEmptyPosition [5, 5, "B_MBT_01_TUSK_F"];


        //private _noclass = nearestobjects [_pos, [], 5, true];
        // Multiple checks: Nearest entities nor nearestobjects wont detect at least walls in the terrain
        if (!(_pos call AS_fnc_isSafePos)) exitWith {
          _pos_dir = [[],[]];
          _excludedRoads pushback _road;
          _valid = false;
        };

        (_pos_dir select 0) pushback _pos;
        (_pos_dir select 1) pushback (_roadDir + 90); //Make the nose of the vehicle point to road
        _pos = [_pos, _gap, _roadDir] call BIS_fnc_relPos;
      };

    } else {
      _excludedRoads pushback _road;
    };
    if _valid exitWith {};
  } foreach (_roads - _excludedRoads);
};

//Findspawnspots as backup
if (count (_pos_dir select 0) == 0) then {
    diag_log format ["AS_fnc_vehicleParking: Couldn't find safe parking near %1, reverting to fnc_findSpawnSpots", _location];
  for "_i" from 1 to _amount do {
    private _temp_pos_dir = [_position, ([_position, 50, random 360] call BIS_fnc_relPos)] call AS_fnc_findSpawnSpots;
    (_pos_dir select 0) pushback (_temp_pos_dir select 0);
    (_pos_dir select 1) pushback (_temp_pos_dir select 1);
  };
};

_pos_dir
