params ["_unit"];

_unit allowDamage false;
_unit setCaptive true;
_unit disableAI "MOVE";
_unit disableAI "AUTOTARGET";
_unit disableAI "TARGET";
_unit setBehaviour "CARELESS";
_unit setUnitPos "UP";
_unit allowFleeing 0;

removeAllWeapons _unit;
removeAllAssignedItems _unit;

_unit addEventHandler ["killed", {

  params ["_killed"];
  // if dead has no weapons, it is an unlawful kill
  if (count weapons _killed < 1) then {
    [0,-1] remoteExec ["AS_fnc_changeForeignSupport",2];
    [-1,1,getPos _killed] remoteExec ["AS_fnc_changeCitySupport",2];
  };

}];
