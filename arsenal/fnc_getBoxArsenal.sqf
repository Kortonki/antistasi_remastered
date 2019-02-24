params ["_box", ["_restrict", false]];

private _weapons = [];
private _magazinesCargo = magazinesAmmoCargo _box;
private _magazines = [];
private _items = itemCargo _box;
private _backpacks = [];
private _weaponsItemsCargo = weaponsItemsCargo _box;

private _magazineTypes = [];
private _magazineAmmo = [];
private _countTypes = 0;

if (count backpackCargo _box > 0) then {
	{
	_backpacks pushBack (_x call BIS_fnc_basicBackpack);
	} forEach backpackCargo _box;
};

// add everything inside _box containers.
{
	_magazinesCargo = _magazinesCargo + (magazinesAmmoCargo (_x select 1));
	_items = _items + (itemCargo (_x select 1));
	_weaponsItemsCargo = _weaponsItemsCargo + weaponsItemsCargo (_x select 1); // this??
} forEach everyContainer _box;

// get stuff inside the _weaponsItems
private _result = [_weaponsItemsCargo] call AS_fnc_getWeaponItemsCargo;
_weapons = _weapons + (_result select 0);
{
	if (count (_x select 4) > 0) then {

		_magazinesCargo = _magazinesCargo + [(_x select 4)];
	};

} foreach _weaponsItemsCargo;
_items = _items + (_result select 2);

//Check all mags for partial mags and add full automatically
//TODO make external function work to tidy up code
//_magazines = [_magazinesCargo] call AS_fnc_countMagazineAmmo;

{
if (_x select 1 == (getNumber (configFile >> "cfgMagazines" >> (_x select 0) >> "count"))) then {_magazines pushBack (_x select 0);}

else {

	private _index = _magazineTypes pushBackUnique (_x select 0);

	if (_index != -1) then {
		_magazineAmmo pushBack (_x select 1);
		_countTypes = _countTypes + 1;

	} else {

		for "_i" from 0 to (_countTypes - 1) step 1 do {

			if (_x select 0 == (_magazineTypes select _i)) then {
				_magazineAmmo set [_i, (_magazineAmmo select _i) + (_x select 1)];
				};
			};
		};
	};

} forEach _magazinesCargo;

//Add up partial mags

private _count = 0;
private _magazineRemains = [];


{
	private _magsize = (getNumber (configFile >> "cfgMagazines" >> _x >> "count"));
 private _mags = floor ((_magazineAmmo select _count) / _magsize);

	for "_i" from 0 to (_mags - 1) step 1 do {

	_magazines pushBack _x;

	};

	private _remains = (_magazineAmmo select _count) - _mags * _magsize;

	//cajaVeh addMagazineAmmoCargo [_x, 1, _remains]; //This has problems: faraway equipment recovered to truck teleports them to cajaveh
	_magazineRemains pushBack [_x, _remains];

 _count = _count + 1;



} foreach _magazineTypes;





// restrict to locked equipment.
if (_restrict) then {
	_weapons = _weapons - unlockedWeapons;
	_magazines = _magazines - unlockedMagazines;
	_items = _items - unlockedItems;
	_backpacks = _backpacks - unlockedBackpacks;
};

// build the vectors.
private _weaponsFinal = [];
private _weaponsFinalCount = [];
{
	private _weapon = _x;
	if (not(_weapon in _weaponsFinal)) then {
		_weaponsFinal pushBack _weapon;
		_weaponsFinalCount pushBack ({_x == _weapon} count _weapons);
	};
} forEach _weapons;

private _magazinesFinal = [];
private _magazinesFinalCount = [];
{
	private _magazine = _x;
	if (not(_magazine in _magazinesFinal)) then {
		_magazinesFinal pushBack _magazine;
		_magazinesFinalCount pushBack ({_x == _magazine} count _magazines);
	};
} forEach  _magazines;

private _itemsFinal = [];
private _itemsFinalCount = [];
{
	private _item = _x;
	if (not(_item in _itemsFinal)) then {
		_itemsFinal pushBack _item;
		_itemsFinalCount pushBack ({_x == _item} count _items);
	};
} forEach _items;

private _backpacksFinal = [];
private _backpacksFinalCount = [];
{
	private _backpack = _x;
	if (not(_backpack in _backpacksFinal)) then {
		_backpacksFinal pushBack _backpack;
		_backpacksFinalCount pushBack ({_x == _backpack} count _backpacks);
	};
} forEach _backpacks;

[[_weaponsFinal, _weaponsFinalCount], [_magazinesFinal, _magazinesFinalCount], [_itemsFinal, _itemsFinalCount], [_backpacksFinal, _backpacksFinalCount], _magazineRemains]
