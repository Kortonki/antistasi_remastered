{[_x] spawn AS_AI_fnc_autoRearm; sleep 3 + (random 5)} forEach (groupSelectedUnits player);

{
  {[_x] spawn AS_AI_fnc_autoRearm; sleep 3 + (random 5)} forEach (units _x);
} foreach (hcSelected player);
