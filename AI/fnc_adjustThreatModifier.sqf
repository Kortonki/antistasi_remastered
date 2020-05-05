#include "../macros.hpp"

params [["_base", ""], ["_airfield", ""], ["_value", 0]];

if (_base != "") then {
  private _threatEval_Land_mod = AS_P("threatEval_Land_mod");
  _threatEval_Land_mod = _threatEval_Land_mod + _value;
  AS_Pset("threatEval_Land_mod", _threatEval_Land_mod);
  diag_log (format ["[AS] AI threat modifier adjust. Land modifier now: %1, adjust value. %2", _threatEval_Land_mod, _value]);
};

if (_airfield != "") then {
  private _threatEval_Air_mod = AS_P("threatEval_Air_mod");
  _threatEval_Air_mod = _threatEval_Air_mod + _value;
  AS_Pset("threatEval_Air_mod", _threatEval_Air_mod);
  diag_log (format ["[AS] AI threat modifier adjust. Air modifier now: %1, adjust value. %2", _threatEval_Air_mod, _value]);
};
