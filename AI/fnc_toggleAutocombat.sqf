//Toggle autocombat for player led squads
params ["_unit", ["_toggle", false]];

if _toggle then {
  [_unit, "AUTOCOMBAT"] remoteExec ["enableAI", _unit];
} else {
  [_unit, "AUTOCOMBAT"] remoteExec ["enableAI", _unit];
};
