params [["_magazines", ["",0]]];



private _magazineTypes = [];
private _magazineAmmo = [];
private _countTypes = 0;

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


} forEach _magazines;

//TODO check proper mag calculation
//TODO Store partial mags somehow. Currently rounded down to avoid cheating

private _count = 0;

{
 private _mags = floor ((_magazineAmmo select _count) / (getNumber (configFile >> "cfgMagazines" >> _x >> "count")));

	for "_i" from 0 to (_mags - 1) step 1 do {

	_magazines pushBack _x;

	};

 _count = _count + 1;



} foreach _magazineTypes;

_magazines
