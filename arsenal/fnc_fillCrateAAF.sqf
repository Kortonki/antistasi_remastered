if (!isServer and hasInterface) exitWith {};

params ["_crate", "_type"];
private ["_item", "_mag"];

[_crate] call AS_fnc_emptyCrate;

private _getWeaponMags = {
    params ["_weapon"];
    private _index = AS_allWeapons find _weapon;
    if (_index == -1) exitWith {[]};

    // all magazines of this weapon.
    ((AS_allWeaponsAttrs select _index) select 2) - unlockedMagazines
};

_fnc_gear = {
	params ["_cat", ["_typeRan", 4], ["_classRan", 4], ["_magMult", 3]];

    private _typeInt = 1 + (floor random _typeRan);
	private _classInt = _classRan;

	if (_cat == "weapon") exitWith {
        // rifles + GL + MG + Snipers
        private _items = (AAFWeapons arrayIntersect ((AS_weapons select 0) + (AS_weapons select 3) + (AS_weapons select 6) + (AS_weapons select 15))) - unlockedWeapons;

		for "_i" from 0 to _typeInt do {
            _item = selectRandom _items;

			_crate addWeaponCargoGlobal [_item, _classInt];

            _mag = selectRandom ([_item] call _getWeaponMags);
            _crate addMagazineCargoGlobal [_mag, _classInt * _magMult];
		};
	};

	if (_cat == "magazine") exitWith {
        private _items = AAFMagazines - unlockedMagazines;
		for "_i" from 0 to _typeInt do {
			_item = selectRandom _items;
      if (isNil "_item") then {_item = ""};
			_crate addMagazineCargoGlobal [_item, _classInt];
		};
	};

	if (_cat == "item") exitWith {
		for "_i" from 0 to _typeInt do {
			_item = selectRandom (AAFItems - unlockedItems);
      if (isNil "_item") then {_item = ""};
			_crate addItemCargoGlobal [_item, _classInt];
		};
	};

	if (_cat == "optic") exitWith {
        private _items = (AAFItems arrayIntersect AS_allOptics) - unlockedItems;
		for "_i" from 0 to _typeInt do {
			_item = selectRandom _items;
      if (isNil "_item") then {_item = ""};
			_crate addItemCargoGlobal [_item, _classInt];
		};
	};

	if (_cat == "launcher") exitWith {
        private _items = (AAFWeapons arrayIntersect ((AS_weapons select 8) + (AS_weapons select 10))) - unlockedWeapons;
		for "_i" from 0 to _typeInt do {
			_item = selectRandom _items;
			_crate addWeaponCargoGlobal [_item, _classInt];

            _mag = selectRandom ([_item] call _getWeaponMags);
			_crate addMagazineCargoGlobal [_mag, _classInt * _magMult];
		};
	};

	if (_cat == "mine") exitWith {
        private _mines = (["AAF", "ap_mines"] call AS_fnc_getEntity) + (["AAF", "at_mines"] call AS_fnc_getEntity);
		for "_i" from 0 to _typeInt do {
			_item = (selectRandom _mines) call AS_fnc_mineMag;
      if (isNil "_item") then {_item = ""};
			_crate addMagazineCargoGlobal [_item, _classInt];
		};
	};

    if (_cat == "grenades") exitWith {
		for "_i" from 0 to _typeInt do {
			_item = selectRandom (AAFThrowGrenades - unlockedMagazines);
      if (isNil "_item") then {_item = ""};
			_crate addMagazineCargoGlobal [_item, _classInt];
		};
    };
};

call {
	if (_type in ["Airfield", "Watchpost", "Convoy"]) exitWith {
		["weapon", 3, 2, 5] call _fnc_gear;
		["magazine", 5, 5] call _fnc_gear;
		["item", 5, 5] call _fnc_gear;
		["mine", 3, 2] call _fnc_gear;
        ["grenades", 5, 5] call _fnc_gear;
		["launcher", 2, 2, 3] call _fnc_gear;
    ["optic", 2, 2] call _fnc_gear;
	};

	if (_type == "AA") exitWith {
		_item = selectRandom AAFLaunchers;
		_crate addWeaponCargoGlobal [_item, 5];
		_crate addMagazineCargoGlobal [([_item] call _getWeaponMags) select 0, 10];
	};
};


//TODO: Amount of med items depend on relative AAF resources
private _miscItems = [(round (random 9)) + 1] call AS_medical_fnc_crateMeds;

(_miscItems select 0) pushBack (selectRandom (AAFItems arrayIntersect AS_allNVGs));
(_miscItems select 1) pushBack 2;

for "_i" from 0 to count (_miscItems select 0) - 1 do {
	private _name = (_miscItems select 0) select _i;
	private _amount = (_miscItems select 1) select _i;

  _crate addItemCargoGlobal [_name, _amount];
};

if hasTFAR then {
    if (1 < random 3) then {
        _crate addBackpackCargoGlobal [(["AAF", "tfar_lr_radio"] call AS_fnc_getEntity), 4];
    };
};
