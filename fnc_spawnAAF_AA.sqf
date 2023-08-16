params ["_position", "_group", "_size", ["_priority", 0.25]];

if (!(["static_aa", _priority] call AS_fnc_vehicleAvailability)) exitWith {[[], []]};


private _vehicles = [];
private _units = [];

private _origin = +_position;
private _initPos = +_position;

private _newSize = _size/2;
private _dir = random 360;
private _i = 0;

private _valid = false;

//This commented out - preventing spawn?
 //and {!(_position isFlatEmpty  [-1, -1, 0.6, 4, 0] isEqualTo [])}
 //Todo: MAKE THIS A SEPARATE FUNCTION

 while {_newSize < _size*1.5} do {

   while {_i < 12} do {
   _dir = _dir + 115;
   _initPos = [_origin, _newSize*(random 2)/2, _dir] call BIS_fnc_relPos;
   _position = _initPos findEmptyPosition [5, 20, "Land_HelipadSquare_F"];
     if  ((_position call AS_fnc_isSafePos) and {!(_position isFlatEmpty  [-1, -1, 0.6, 4, 0] isEqualTo [])}) exitWith {_valid = true};
   _i = _i + 1;
   };
   if (_valid) exitWith {};
   _newSize = _newSize + 10;
   _i = 0;
 };

if (!(_valid)) exitWith {
    diag_log format ["AS_fnc_spawnAAF_AA could not find a suitable position, spawn cancelled near %1", _origin call AS_location_fnc_nearest];
    [[], []]

  };


    //spg can't fire over the bunker wall -> todo: sandbags to the side?

    //private _bunker = "Land_BagBunker_Small_F" createVehicle _pos;
    //_bunker setDir _dir;
    //_pos = getPosATL _bunker;
    //_vehicles pushBack _bunker;

    private _veh = [selectrandom (["AAF", "static_aa"] call AS_fnc_getEntity), _position, "AAF", random 360, "CAN_COLLIDE"] call AS_fnc_createEmptyVehicle;
    _vehicles pushBack _veh;

    private _objects = [
  	[AS_sandbag_type_round ,[-0.575195,3.12817,-0.024229],170.576,1,0,[-0.0234358,-1.0123],"","",true,false],
  	[AS_sandbag_type_round ,[1.98145,2.61194,0.000823021],214.039,1,0,[0.55467,0.202553],"","",true,false],
  	[AS_sandbag_type_round ,[3.38574,0.515015,0.0755463],255.336,1,0,[0.900887,2.87112],"","",true,false],
  	[AS_sandbag_type_round ,[-2.93262,1.94678,-0.0138779],130.537,1,0,[0.465369,-0.54417],"","",true,false],
  	[AS_sandbag_type_round ,[-2.3584,-2.76392,-0.10144],40.2211,1,0,[-2.72256,-3.42879],"","",true,false],
  	[AS_sandbag_type_round ,[3.01807,-2.05542,0.0383673],294.529,1,0,[-1.33123,2.22534],"","",true,false],
  	[AS_sandbag_type_round ,[-3.62646,-0.399536,-0.0354023],79.0155,1,0,[-0.272919,-1.40581],"","",true,false]
    ];

    private _forts = [getpos _veh, 0, _objects] call BIS_fnc_ObjectsMapper;
    {_x setVectorUp (surfacenormal (getPosATL _x))} forEach _forts;
    _vehicles append _forts;

    private _unit = ([_position, 0, ["AAF", "gunner"] call AS_fnc_getEntity, _group] call bis_fnc_spawnvehicle) select 0;
    _unit moveInGunner _veh;
    [_unit, false] call AS_fnc_initUnitAAF;
    _units pushBack _unit;
    //May have commander slot, for example RHS sergei
    if (_veh emptyPositions "Commander" > 0) then {
      private _commander = ([_position, 0, ["AAF", "gunner"] call AS_fnc_getEntity, _group] call bis_fnc_spawnvehicle) select 0;
      _commander moveInCommander _veh;
      _units pushback _commander;
      [_commander, false] call AS_fnc_initUnitAAF;
    };
[_units, _vehicles]
