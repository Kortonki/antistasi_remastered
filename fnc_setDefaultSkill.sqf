#include "macros.hpp"
params ["_unit", ["_sideSkill", AS_maxSkill]];
_unit setSkill (AS_P("minAISkill") + (AS_P("maxAISkill") - AS_P("minAISkill"))*_sideSkill/AS_maxSkill);

//increase spotting and commanding skill for squad leaders

if ((_unit getvariable "AS_type") == "Squad Leader" or ((_unit call AS_fnc_getSide) != "FIA" and (leader _unit == _unit))) then {

  private _spotDistance = (_unit skill "spotDistance")*1.3;
  _spotDistance = _spotDistance min 1;
  private _spotTime = (_unit skill "spotTime")*1.3;
  _spotTime = _spotTime min 1;
  private _commanding = (_unit skill "commanding")*1.3;
  _commanding = _commanding min 1;

  _unit setSkill ["spotDistance", _spotDistance];
  _unit setSkill ["spotTime", _spotTime];
  _unit setSkill ["commanding", _commanding];

};
