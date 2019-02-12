//Toggle autocombat for player led squads
params ["_unit", ["_toggle", false]];

if _toggle then {
  _unit enableAI "AUTOCOMBAT";
} else {
  _unit disableAI "AUTOCOMBAT";
};
