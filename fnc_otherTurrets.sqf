params ["_veh"];

private _emptyTurrets = [];

{
  if (isNull (_x select 0)) then {
    _emptyTurrets pushback (_x select 3);
  };
} foreach (fullCrew [_veh, "turret", true]);

//Failsafe, no FFV turrets
(_emptyTurrets arrayintersect (allTurrets [_veh, false]))
