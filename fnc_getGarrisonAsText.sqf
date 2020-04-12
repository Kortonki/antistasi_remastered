#include "macros.hpp"
params ["_location", ["_restructured", false]];
private ["_texto","_garrison","_size","_posicion"];

private _garrison = [_location, "garrison"] call AS_location_fnc_get;
private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;
private _behaviour = [_location, "behaviour"] call AS_location_fnc_get;
private _combatMode = [_location, "combatMode"] call AS_location_fnc_get;

private _textCombatMode = "";

switch (_combatmode) do {
  case "BLUE" ;
  case "GREEN" ;
  case "WHITE" : {_textCombatMode = "Hold fire"};
  case "YELLOW" ;
  case "RED" : {_textCombatMode = "Open fire"};
  default {_textCombatMode = "No orders"};
};

private _lineBreak = "\n";
if (_restructured) then {
    _lineBreak = "<br/>";
};

_text = format [" garrison size: %1" + _lineBreak, count _garrison] +
        format ["Orders: %1 and %2" + _lineBreak + _lineBreak, _behaviour, _textCombatMode] +

        format ["Statics: %1" + _lineBreak, {_x distance2D _position <= _size and {(typeof _x) in AS_allStatics}} count AS_P("vehicles")];

{
    private _type = _x;
    private _count = {_x == _type} count _garrison;
    if (_count > 0) then {
        _text = _text + format [_lineBreak+"%1: %2", _type, _count];
    };
} forEach AS_allFIAUnitTypes;
_text
