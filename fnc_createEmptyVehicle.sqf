params ["_vehicleType","_pos", "_side", ["_dir", 0], ["_special", "NONE"], ["_radius", 0]];

private _vehicle = createVehicle [_vehicleType, _pos, [], _radius, _special];
_vehicle allowDamage false;
[_vehicle, false] remoteExecCall ["enablesimulationGlobal", 2];
_vehicle setdir _dir;

if (_side isEqualto "CIV") then {
  [_vehicle] call AS_fnc_initVehicleCiv;
} else {
  [_vehicle, _side] call AS_fnc_initVehicle;
};

[_vehicle, true] remoteExecCall ["enablesimulationGlobal", 2];

[_vehicle] spawn {
  params ["_vehicle"];
  sleep 3;
  waitUntil {sleep 1; speed _vehicle < 0.1};
  sleep 1;
  _vehicle allowDamage true;
};

//Counter for AAF spawned vehicles to avoid more vehs than in arsenal
if (_side == "AAF") then {
    [_vehicleType] RemoteExeccall ["AS_AAFarsenal_fnc_spawnCounter", 2];
};



_vehicle
