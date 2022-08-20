params ["_type", "_position", "_group", ["_recruit", false], ["_unitParams", []], ["_radius", 50]];

private _unit = _group createUnit [_type call AS_fnc_getFIAUnitClass, _position, [], _radius, "NONE"]; //Unit is local where this line is run
_unit setVariable ["AS_type", _type, true];

//AI for players group are created and inited locally

if (_recruit) then {

  private _bluforSpawn = _unitParams select 0;
  private _equipment =  _unitParams select 2;


  [_unit, _bluforSpawn, nil, _equipment] spawn AS_fnc_initUnitFIA; //Here remoteExec is not needed because this function is already local for player as Spawnfiaunit is executed on player machine
  _unit disableAI "AUTOCOMBAT";
};

_unit
