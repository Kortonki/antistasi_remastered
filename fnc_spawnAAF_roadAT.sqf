params ["_position", "_group", ["_size", 200], ["_priority", 0.25]];

if (!(["static_at", _priority] call AS_fnc_vehicleAvailability)) exitWith {[[],[]]};

private _origin = +_position;
private _vehicles = [];
private _units = [];

private _newSize = _size;
private _valid = false;

private _dir = random 360;

while {_newSize < _size*1.5} do {

  ([_origin, [_origin, _newSize, random 360] call Bis_fnc_relpos] call AS_fnc_findspawnSpots) params ["_roadpos", "_roaddir"];

  //If roads not found, other positions can be valid too
  if ((count _roadpos) > 0) then {

      //Findspawnspots can find non road positions too
    if (([_roadpos, 5] call BIS_fnc_nearestRoad) != objNull) then {
      //Roadside if pos at road
      _position = [_roadpos, 8, _dir + 270] call BIS_Fnc_relPos;
      _dir = _roaddir;
    } else {
      _position = _roadpos;
    };

    //Check new pos once more
    //and {!(_position isFlatEmpty  [-1, -1, 0.5, 4, 0] isEqualTo [])} COMMETNED OUT to not prevent spawn EXPERIMENT
    if ((_position call AS_fnc_isSafePos)) exitWith {_valid = true};
  };

  if (_valid) exitWith {};

  _newSize = _newSize + 20;

};

if (!(_valid)) exitWith {
    diag_log format ["AS_fnc_spawnAAF_RoadAT could not find a suitable position, spawn cancelled near %1", _origin call AS_location_fnc_nearest];
    [[], []]

  };

//([_position, [_position, _size, random 360] call Bis_fnc_relpos] call AS_fnc_findspawnSpots) params ["_roadpos", "_dir"];
    //spg can't fire over the bunker wall -> todo: sandbags to the side?

    //private _bunker = "Land_BagBunker_Small_F" createVehicle _pos;
    //_bunker setDir _dir;
    //_pos = getPosATL _bunker;
    //_vehicles pushBack _bunker;

    private _veh = [selectRandom (["AAF", "static_at"] call AS_fnc_getEntity), _position, "AAF", _dir + 180, "NONE"] call AS_fnc_createEmptyVehicle;
    _vehicles pushBack _veh;

    private _unit = ([_position, 0, ["AAF", "gunner"] call AS_fnc_getEntity, _group] call bis_fnc_spawnvehicle) select 0;
    _unit moveInGunner _veh;
    [_unit, false] call AS_fnc_initUnitAAF;
    _units pushBack _unit;

[_units, _vehicles]
