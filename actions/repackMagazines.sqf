private _unit = _this select 0;



[_unit, (position _unit), (count magazines _unit)*2, {true}, {speed _unit > 1}, "", "Keep still"] call AS_fnc_wait_or_fail;

if (speed _unit > 1) exitWith {};


private _magazineTypes = [];
private _magazineAmmo = [];
private _countTypes = 0;


{

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

} forEach magazinesAmmo _unit;


//Remove all magazines except for the one in weapons

{_unit removeMagazine _x} forEach magazines _unit;

//calculate ammo for different mag types and make full mags

private _count = 0;

{
	private _magsize = (getNumber (configFile >> "cfgMagazines" >> _x >> "count"));
 private _mags = floor ((_magazineAmmo select _count) / _magsize);

_unit addMagazines [_x, _mags];

//Add a partial mag

	private _remains = (_magazineAmmo select _count) - _mags * _magsize;
	if (_remains > 0) then {_unit addMagazine [_x, _remains]}; // DOn't give empty mags

//Switch to next mag type

 _count = _count + 1;

} foreach _magazineTypes;
