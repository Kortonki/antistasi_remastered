params ["_type"];

private _vest = ([caja, "vest"] call AS_fnc_getBestItem);
private _helmet = ([caja, "helmet"] call AS_fnc_getBestItem);

// survivors have no weapons.
if (_type == "Survivor") exitWith {
    ["", "", "", "", "", [], "", [], "", [], [],""]
};

// choose a list of weapons to choose from the unit type.
private _primaryWeapons = (AS_weapons select 0) + (AS_weapons select 13) + (AS_weapons select 14); // Assault Rifles + Rifles + SubmachineGun + unlocked
private _secondaryWeapons = [];
private _useBinoculars = false;
private _useBackpack = false;
private _items = call AS_medical_fnc_FIAuniformMeds;
private _scopeType = "rifleScope";  // "rifleScope" prefers as low zoom as possible
private _primaryMagCount = 6 + 1;  // +1 for the weapon.
private _missingGrenades = 2;
private _missingSmokes = 2;

//TODO binoculars to squad leaders
if (_type == "Squad Leader") then {
    _primaryWeapons = (AS_weapons select 0) + (AS_weapons select 13) + (AS_weapons select 14); // G. Launchers
    _useBinoculars = true;
    _missingGrenades = 1;
    _missingSmokes = 3;
    };

if (_type == "Grenadier") then {
    _primaryWeapons = AS_weapons select 3; // G. Launchers
    _useBackpack = true;
    // todo: check that secondary magazines exist.
};
if (_type == "Autorifleman") then {
    _primaryWeapons = AS_weapons select 6; // Machine guns
    _primaryMagCount = 2 + 1;  // because MG clips have more bullets.
    _scopeType = "";
    _useBackpack = true;
};
if (_type == "Sniper") then {
    _primaryWeapons = AS_weapons select 15;  // Snipers
    _scopeType = "sniperScope";
    _useBackpack = false;
    _primaryMagCount = 8 + 1;  // because snipers clips have less bullets.
};
if (_type == "AT Specialist") then {
    // todo: this list includes AT and AA. Fix it.
    _secondaryWeapons = (AS_weapons select 10); // missile launchers
    _useBackpack = true;
};
if (_type == "AA Specialist") then {
    // todo: this list includes AT and AA. Fix it.
    _secondaryWeapons = (AS_weapons select 8); // missile launchers
    _useBackpack = true;
};
if (_type == "Medic") then {
    _items = call AS_medical_fnc_FIAmedicBackpack;
    _missingGrenades = 0;
    _missingSmokes = 4;
    _scopeType = "";
    _useBackpack = true;
};
if (_type == "Engineer") then {
    _items = [["ToolKit", 1]];
    _useBackpack = true;
    _scopeType = "";
};
if (_type == "Crew") then {
    _scopeType = "";
};


private _backpack = "";
if _useBackpack then {
    _backpack = ([caja, "backpack"] call AS_fnc_getBestItem);
};

private _binoculars = "";
if _useBinoculars then {
    _binoculars = [caja, "binoculars"] call AS_fnc_getBestItem;
};

private _availableWeapons = getWeaponCargo caja;
private _availableMagazines = getMagazineCargo caja;

// add unlocked stuff
(call AS_fnc_unlockedCargoList) params ["_unlockedCargoWeapons", "_unlockedCargoMagazines"];
_availableWeapons = [_availableWeapons, _unlockedCargoWeapons] call AS_fnc_mergeCargoLists;
_availableMagazines = [_availableMagazines, _unlockedCargoMagazines] call AS_fnc_mergeCargoLists;

private _primaryWeapon = ([_availableWeapons, _availableMagazines, _primaryWeapons, _primaryMagCount] call AS_fnc_getBestWeapon);
private _primaryMags = [[], []];
if (_primaryWeapon != "") then {
    _primaryMags = ([caja, _primaryWeapon, _primaryMagCount] call AS_fnc_getBestMagazines);
};

private _secondaryWeapon = ([_availableWeapons, _availableMagazines, _secondaryWeapons, 2 + 1] call AS_fnc_getBestWeapon);
private _secondaryMags = [[], []];
if (_secondaryWeapon != "") then {
    _secondaryMags = ([caja, _secondaryWeapon, 2 + 1] call AS_fnc_getBestMagazines);
};

// Add grenades

if (_missingGrenades > 0) then {
    private _ordered_list = ([caja, "throw_grenades", true] call AS_fnc_getBestItem);

    {
      private _index = ((_availableMagazines select 0) find _x);
      private _amount = (_availableMagazines select 1) select _index;
      if (_amount >= _missingGrenades) exitWith {
        _items pushBack [_x, _missingGrenades];
    };
      _items pushBack [_x, _amount];
      _missingGrenades = _missingGrenades - _amount;
    } forEach _ordered_list;

};
//Add smokes

if (_missingSmokes > 0) then {
    private _ordered_list = ([caja, "throw_smokes", true] call AS_fnc_getBestItem);

    {
      private _index = ((_availableMagazines select 0) find _x);
      private _amount = (_availableMagazines select 1) select _index;
      if (_amount >= _missingSmokes) exitWith {
        _items pushBack [_x, _missingSmokes];
    };
      _items pushBack [_x, _amount];
      _missingSmokes = _missingSmokes - _amount;
    } forEach _ordered_list;
};

private _scope = "";
if (_scopeType != "") then {
  _scope = ([caja, _scopeType] call AS_fnc_getBestItem);
};

private _primaryWeaponItems = [];
private _googles = "";
if (SunOrMoon < 1) then {
    _googles = ([caja, "nvg"] call AS_fnc_getBestItem);

    if (_googles != "") then {
        private _laser = [caja, "laser"] call AS_fnc_getBestItem;
        if (_laser != "") then {
            _primaryWeaponItems pushBack _laser;
        };
    } else {
        private _flashlight = [caja, "flashlight"] call AS_fnc_getBestItem;
        if (_flashlight != "") then {
            _primaryWeaponItems pushBack _flashlight;
        };
    };
};

//Rifleman and squad leader always takes first of unlocked weapons and magazines there is nothing else
//Must have enough mags or revert to unlocked weapon

private _actualMagCount = 0;

{_actualMagCount = _actualMagCount + _x}
foreach (_primaryMags select 1);

if  (_primaryWeapon == ""
    or (_actualMagCount < _primaryMagCount))
    then {
    [petros, "sideChat", format ["%1 recruited: No weapons or ammo for %1, takes default weapon", _type]] remoteExec ["AS_fnc_localCommunication", [0, -2] select isDedicated];
  if (not(isNil {(_unlockedCargoWeapons select 0) select 0})) then {_primaryWeapon = ((_unlockedCargoWeapons select 0) select 0);};
  _primaryMags = ([caja, _primaryWeapon, 10] call AS_fnc_getBestMagazines);
};


[_vest, _helmet, _googles, _backpack, _primaryWeapon, _primaryMags, _secondaryWeapon, _secondaryMags, _scope, _items, _primaryWeaponItems, _binoculars]
