params ["_mag"];

private _lowered = toLower _mag;
private _ammotext = tolower (getText (configFile >> "CfgMagazines" >> _mag >> "ammo"));
private _displaynameShort = toLower (getText (configFile >> "CfgMagazines" >> _mag >> "displayNameShort"));

if (
    ("blank" in _ammotext) or
    ("blank" in _lowered) or
    ("blank" in _displaynameShort)
  ) exitWith {false};
  //is not blank
true
