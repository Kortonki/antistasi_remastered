{[_x, true] spawn AS_AI_fnc_toggleAutocombat} forEach (groupSelectedUnits player);

{
  {[_x, true] spawn AS_AI_fnc_toggleAutocombat} foreach (units _x);
} foreach (hcSelected player);
