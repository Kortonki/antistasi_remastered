{[_x, ["autoHeal", true]] remoteExec ["setvariable", _x]} forEach (groupSelectedUnits player);

{
  {[_x, ["autoHeal", true]] remoteExec ["setvariable", _x]} foreach (units _x);
} foreach (hcSelected player);
