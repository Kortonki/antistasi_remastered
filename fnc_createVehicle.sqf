params ["_vehicleType","_pos", ["_dir", 0], "_side", ["_type", "any"], ["_radius", 0], ["_special", "NONE"], ["_spawn", true]];


private _vehicle = createVehicle [_vehicleType, _pos, [], _radius, _special];
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


while {isNull assignedDriver _vehicle and {_vehicle emptyPositions "Driver" > 0}} do {
  _driver = _vehicleGroup createUnit [[_side, _type] call AS_fnc_getEntity, _pos, [], 0, "NONE"];
  [_driver, _side, _spawn] call AS_fnc_initUnit;
  _driver assignAsDriver _vehicle;
  _driver moveInDriver _vehicle;

};

while {isNull assignedGunner _vehicle and {_vehicle emptyPositions "Gunner" > 0}} do {
  private _unit = _vehicleGroup createUnit [[_side, _type] call AS_fnc_getEntity, _pos, [], 0, "NONE"];
  [_unit, _side, _spawn] call AS_fnc_initUnit;
  _unit assignAsGunner _vehicle;
  _unit moveInGunner _vehicle;
};

while {isNull assignedCommander _vehicle and {_vehicle emptyPositions "Commander" > 0}} do {
  private _unit = _vehicleGroup createUnit [[_side, _type] call AS_fnc_getEntity, _pos, [], 0, "NONE"];
  [_unit, _side, _spawn] call AS_fnc_initUnit;
  _unit setRank "LIEUTENANT";
  _unit assignAsCommander _vehicle;
  _unit moveInCommander _vehicle;
};

_vehicleGroup addVehicle _vehicle;

[_vehicle, _side] call AS_fnc_initVehicle;
_vehicle allowDamage true;
[_vehicle, true] remoteExecCall ["enablesimulationGlobal", 2];


[_vehicle, _vehicleGroup, _driver]
