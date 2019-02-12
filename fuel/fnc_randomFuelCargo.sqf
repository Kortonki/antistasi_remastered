params ["_vehicle",["_min", 0],["_max",1]];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_randomFuelCargo.sqf: No vehicle specified"]; 0};

_vehicle setfuel (_min + random (_max-_min));

if (finite (getFuelCargo _vehicle)) then {

  private _type = typeOf _vehicle;
  private _fuelCargoSize =  [(configFile >> "CfgVehicles" >> _type), "transportfuel", 10000] call BIS_fnc_returnConfigEntry;
  _fuelCargoSize = _fuelCargoSize min 10000;

  private _fillAmount = (_min + random (_max-_min)) * _fuelCargoSize;


  _vehicle setVariable ["fuelCargo", _fillAmount, true];

};
