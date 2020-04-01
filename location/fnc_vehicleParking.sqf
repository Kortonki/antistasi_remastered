params ["_location", "_amount"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

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
        private _noclass = nearestobjects [_pos, [], 5, true];
        if (count _noclass > 0) exitWith {
          _pos_dir = [[],[]];
          _excludedRoads pushback _road;
          _valid = false;
        };

        (_pos_dir select 0) pushback _pos;
        (_pos_dir select 1) pushback (_roadDir - 90); //Make the nose of the vehicle point to road
        _pos = [_pos, 10, _roadDir] call BIS_fnc_relPos;
      };

    } else {
      _excludedRoads pushback _road;
    };
    if _valid exitWith {};
  } foreach (_roads - _excludedRoads);
};

_pos_dir
