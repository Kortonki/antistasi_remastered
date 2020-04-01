params ["_veh", "_side", "_crewType"];

if (!(_crewType in ["pilot", "gunner", "crew"])) then {
  diag_log format ["[AS] createVehicleGroup error: invalid crewType: %1, set to default", _crewType];
  _crewType = "crew";
};

private _crewClass = [_side, _crewType] call AS_fnc_getEntity;

private _crewGroup = createGroup (_side call AS_fnc_getFactionSide);
private _pos = position _veh;

private _unit = _crewgroup createUnit [_crewClass, _pos, [], 10, "NONE"];


if (_veh emptyPositions "Commander" > 0) then {
  private _commander = _crewgroup createUnit [_crewClass, _pos, [], 10, "NONE"];
  _commander setRank "LIEUTENANT";
};

for "_i" from 1 to (_veh emptyPositions "Gunner") do {
  private _gunner = _crewgroup createUnit [_crewClass, _pos, [], 10, "NONE"];
};

{
  private _turretgunner = _crewgroup createUnit [_crewClass, _pos, [], 10, "NONE"];
} foreach ([_veh] call AS_fnc_otherTurrets);

private _units = units _crewGroup;

{
  [_x, _side, true] call AS_fnc_initUnit;
} foreach _units;

[_crewGroup, _units]
