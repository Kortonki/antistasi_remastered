params ["_position", "_faction", ["_size", 200], ["_priority", 0.25]];

if (!(["static_mortar", _priority] call AS_fnc_vehicleAvailability) and {_faction == "AAF"}) exitWith {[[], [], []]};

private _newSize = _size/2;
private _dir = random 360;
private _i = 0;

private _origin = +_position;
private _initPos = +_position;

private _valid = false;


//This commented out - preventing spawn?
//and {!(_position isFlatEmpty  [-1, -1, 0.35, 4, 0] isEqualTo [])

//Rotate first to find

while {_newSize < _size*1.5} do {

  while {_i < 12} do {
    _dir = _dir + 115;
    _initPos = [_origin, _newSize*(random 2)/2, _dir] call BIS_fnc_relPos;
    _position = _initPos findEmptyPosition [5, 20, "Land_HelipadSquare_F"];
      if  ((_position call AS_fnc_isSafePos) and {!(_position isFlatEmpty  [-1, -1, 0.35, 4, 0] isEqualTo [])}) exitWith {_valid = true};
    _i = _i + 1;
    };
  if (_valid) exitWith {};
  _newSize = _newSize + 10;
  _i = 0;
};



if (!_valid) exitWith {
    diag_log format ["AS_fnc_spawnMortar could not find a suitable position, spawn cancelled near %1", _origin call AS_location_fnc_nearest];
    [[], [], []]

  };

private _objects = [
	["Land_SandbagBarricade_01_half_F",[-1.17114,2.7998,0.00133133],177.685,1,0,[0,-0],"","",true,false],
	["Land_SandbagBarricade_01_half_F",[-2.84399,-1.31934,0.000164032],87.4029,1,0,[0,0],"","",true,false],
	["Land_SandbagBarricade_01_half_F",[-1.09058,-2.93262,-0.000862122],359.863,1,0,[0,0],"","",true,false],
	["Land_SandbagBarricade_01_half_F",[-2.9231,1.24609,0.000165939],87.4029,1,0,[0,0],"","",true,false],
	["Land_SandbagBarricade_01_half_F",[1.39697,2.86816,0.0011158],177.685,1,0,[0,-0],"","",true,false],
	["Land_SandbagBarricade_01_half_F",[2.92505,1.35742,-3.62396e-005],267.743,1,0,[0,0],"","",true,false],
	["Land_SandbagBarricade_01_half_F",[2.98706,-1.21094,5.53131e-005],267.743,1,0,[0,0],"",""]
];
private _vehicles = [_position, 0, _objects] call BIS_fnc_ObjectsMapper;
{_x setVectorUp (surfacenormal (getPosATL _x))} forEach _vehicles;

private _mortarType = selectRandom([_faction, "static_mortar"] call AS_fnc_getEntity);
private _gunnerType = [_faction, "gunner"] call AS_fnc_getEntity;

private _group = createGroup (_faction call AS_fnc_getFactionSide);
private _veh = [_mortarType, _position, _faction, random 360, "CAN_COLLIDE"] call AS_fnc_createEmptyVehicle;
_vehicles pushBack _veh;
[_veh] execVM "scripts\UPSMON\MON_artillery_add.sqf";
private _unit = ([_position, 0, _gunnerType, _group] call bis_fnc_spawnvehicle) select 0;
[_unit, _faction, false] call AS_fnc_initUnit;
_unit moveInGunner _veh;
[[_unit], [_group], _vehicles]
