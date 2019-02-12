params ["_unit", ["_restrict", false]];

private _weapons = [];
private _items = [];
private _magazines = [];
private _backpacks = [];

private _backpack = backpack _unit;
if (_backpack != "") then {
	_backpacks pushback (_backpack call BIS_fnc_basicBackpack);
};

// items
{
	if (_x != "") then {
		_items pushBack _x;
	};
} forEach [headgear _unit, vest _unit] + items _unit + assignedItems _unit - AS_allBinoculars;

// weapons and attachments
private _result = [weaponsItems _unit] call AS_fnc_getWeaponItemsCargo;
_weapons = _weapons + (_result select 0);
_items = _items + (_result select 2);


private _magazineTypes = [];
private _magazineAmmo = [];
private _countTypes = 0;

//TODO make external function work to tidy up code
// _magazines = [magazinesAmmoFull _unit] call AS_fnc_countMagazineAmmo;

// magazines
{
if (_x select 1 == (getNumber (configFile >> "cfgMagazines" >> (_x select 0) >> "count"))) then {_magazines pushBack (_x select 0);}

else {

	private _index = _magazineTypes pushBackUnique (_x select 0);

	if (_index != -1) then {
		_magazineAmmo pushBack (_x select 1);
		_countTypes = _countTypes + 1;
	}

	else {

		for "_i" from 0 to (_countTypes - 1) step 1 do {

			if (_x select 0 == (_magazineTypes select _i)) then {
				_magazineAmmo set [_i, (_magazineAmmo select _i) + (_x select 1)];
			};



		};
	};

};


} forEach magazinesAmmoFull _unit;

//TODO check proper mag calculation

private _count = 0;
private _magazineRemains = [];

{
	private _magsize = (getNumber (configFile >> "cfgMagazines" >> _x >> "count"));
 private _mags = floor ((_magazineAmmo select _count) / _magsize);

	for "_i" from 0 to (_mags - 1) step 1 do {

	_magazines pushBack _x;

	};

	private _remains = (_magazineAmmo select _count) - _mags * _magsize;
	//cajaVeh addMagazineAmmoCargo [_x, 1, _remains]; //This is processed later in populateBox.sqf or transfertobox.sqf
	_magazineRemains pushBack [_x, _remains];


 _count = _count + 1;



} foreach _magazineTypes;



if (_restrict) then {
	_weapons = _weapons - unlockedWeapons;
	_magazines = _magazines - unlockedMagazines;
	_items = _items - unlockedItems;
	_backpacks = _backpacks - unlockedBackpacks;
};

// transform in cargoList
private _cargo_w = [_weapons] call AS_fnc_listToCargoList;
private _cargo_m = [_magazines] call AS_fnc_listToCargoList;
private _cargo_i = [_items] call AS_fnc_listToCargoList;
private _cargo_b = [_backpacks] call AS_fnc_listToCargoList;

[_cargo_w, _cargo_m, _cargo_i, _cargo_b, _magazineRemains]
