{[_x, false] spawn AS_AI_fnc_toggleAutocombat} forEach (groupSelectedUnits player);

{
  {[_x, false] spawn AS_AI_fnc_toggleAutocombat} foreach (units _x);
} foreach (hcSelected player);
