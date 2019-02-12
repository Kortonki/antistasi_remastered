// add everything inside _weaponsItemsCargo (includes the weapon)
params ["_weaponsItemsCargo"];
private ["_weapons", "_magazines", "_items"];
_weapons = [];
_magazines = [];
_items = [];




{
	_weapons pushBack ([(_x select 0)] call BIS_fnc_baseWeapon);

	_magazines pushBack ((_x select 4) select 0);

	for "_i" from 1 to (count _x) - 1 do {
		_cosa = _x select _i;
		if (typeName _cosa == typeName "") then {
			if (_cosa != "") then {_items pushBack _cosa};
		};
	};
} forEach _weaponsItemsCargo;

//Don't store weaponitems that come with the weapon itself to avoid duplication in the arsenal

private _weaponPermAcc = [];
private _weapItems = [];
{
	private _weapName = _x;
 _weaponPermAcc = ("getText (_x >> 'item') != ''" configclasses (configFile >>  "CfgWeapons" >> _weapName >> "LinkedItems"));

 				{
					_weapItems pushBack (getText (_x >> "item"));
				} foreach _weaponPermAcc;

} foreach _weapons;

_items = _items - (_items arrayIntersect _weapitems);



[_weapons, _magazines, _items]
