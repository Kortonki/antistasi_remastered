params ["_vehicle", "_player"];

private _arsenal = [_vehicle, false, true] call AS_fnc_getBoxArsenal;

private _itemArray = _arsenal call AS_fnc_countArsenal;

private _text ="CONTAINER CARGO:\n";

if (_vehicle == caja) then {
  _text = "ARSENAL INVENTORY:\n";

  //Consider displaying unlockeds via other ways
  /*_text = format ["%1\nUNLOCKED WEAPONS\n", _text];
  {
    private _name = getText(configFile >> "cfgWeapons" >> _x >> "displayName");
    _text = format ["%1\n%2", _text, _name];
  } foreach unlockedWeapons;

  _text = format ["%1\nUNLOCKED MAGAZINES\n", _text];

  {
    private _name = getText(configfile >> "CfgMagazines" >> _x >> "displayName");
    _text = format ["%1\n%2", _text, _name];
  } foreach unlockedMagazines;

  _text = format ["%1\nUNLOCKED MAGAZINES\n", _text];
  */
};

[_itemArray, _text, true] call AS_fnc_displayCargo_hint;
