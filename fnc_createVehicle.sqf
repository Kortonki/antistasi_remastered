params ["_vehicleType","_pos", ["_dir", 0], "_side", ["_type", "any"], ["_radius", 0], ["_special", "NONE"], ["_spawn", true], ["_crew", 7]];
//CREW: 7 all crews, from 0 no crew,  add 1 for driver, 2 for gunner, 4 for commander. -> all possible permutations for crew


private _vehicle = createVehicle [_vehicleType, _pos, [], _radius, _special];
if (isNull _vehicle) exitWith {
  diag_log format ["[AS] CreateVehicle, classname doesn't exist: %1. Vehicle not created", _vehicleType];
};
_vehicle allowDamage false;
[_vehicle, false] remoteExecCall ["enablesimulationGlobal", 2];
_vehicle setdir _dir;

private _driver = objnull;

private _vehicleGroup = createGroup (_side call AS_fnc_getFactionSide);

//Man the vehicle

if (_type isEqualto "any") then {
  if  (!(typeOf _vehicle in ([_side, "apcs"] call AS_fnc_getEntity) or typeOf _vehicle in ([_side, "tanks"] call AS_fnc_getEntity))) then {
    _type = "gunner";
  } else {
  _type = "crew";
  };
};

if (_crew in [1,3,5,7]) then {

  while {isNull assignedDriver _vehicle and {_vehicle emptyPositions "Driver" > 0}} do {
    _driver = _vehicleGroup createUnit [[_side, _type] call AS_fnc_getEntity, _pos, [], 0, "NONE"];
    [_driver, _side, _spawn] call AS_fnc_initUnit;
    _driver assignAsDriver _vehicle;
    _driver moveInDriver _vehicle;

  };
};

if (_crew in [4,5,6,7]) then {

  while {isNull assignedCommander _vehicle and {_vehicle emptyPositions "Commander" > 0}} do {
    private _unit = _vehicleGroup createUnit [[_side, _type] call AS_fnc_getEntity, _pos, [], 0, "NONE"];
    [_unit, _side, _spawn] call AS_fnc_initUnit;
    _unit setRank "LIEUTENANT";
    _unit assignAsCommander _vehicle;
    _unit moveInCommander _vehicle;
  };
};

if (_crew in [2,3,6,7]) then {

  while {isNull assignedGunner _vehicle and {_vehicle emptyPositions "Gunner" > 0}} do {
    private _unit = _vehicleGroup createUnit [[_side, _type] call AS_fnc_getEntity, _pos, [], 0, "NONE"];
    [_unit, _side, _spawn] call AS_fnc_initUnit;
    _unit assignAsGunner _vehicle;
    _unit moveInGunner _vehicle;
  };

  //Other turrets. This must be done last because otherTurrets checks for empty turrets

  {
    private _unit = _vehicleGroup createUnit [[_side, _type] call AS_fnc_getEntity, _pos, [], 0, "NONE"];
    [_unit, _side, _spawn] call AS_fnc_initUnit;
    _unit assignAsTurret [_vehicle, _x];
    _unit moveinTurret [_vehicle, _x];
  } foreach ([_vehicle] call AS_fnc_otherTurrets);

};



_vehicleGroup addVehicle _vehicle;

[_vehicle, _side] call AS_fnc_initVehicle;
[_vehicle, true] remoteExecCall ["enablesimulationGlobal", 2];

[_vehicle] spawn {
  params ["_vehicle"];
  sleep 3;
  _vehicle allowDamage true;
};

//Counter for AAF spawned vehicles to avoid more vehs than in arsenal
if (_side == "AAF") then {
    [_vehicleType] RemoteExeccall ["AS_AAFarsenal_fnc_spawnCounter", 2];
};


[_vehicle, _vehicleGroup, _driver]
