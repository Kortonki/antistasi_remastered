params ["_itemArray", ["_text", "Vehicle cargo\n"], ["_captioned", false]];

_text = _text + ([_itemArray] call AS_fnc_getCargoAsText);

if (_captioned) then {
  hintC _text;
} else {
  hint _text;
};
