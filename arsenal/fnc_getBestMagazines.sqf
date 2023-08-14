params ["_box", "_weapon", "_maxAmount"];

private _index = AS_allWeapons find _weapon;
if (_index == -1) exitWith {[[""],[0]]};

// all magazines of this weapon.
private _suitableMags = (AS_allWeaponsAttrs select _index) select 2;

// all magazines of this weapon that are unlocked.
// private _alwaysAvailable = _suitableMags arrayIntersect unlockedMagazines;

private _arsenalMags = (((call AS_fnc_getArsenal) select 1) select 0);
private _availableMags = _arsenalMags + unlockedMagazines;
private _availableMagsAmounts = (((call AS_fnc_getArsenal) select 1) select 1);

private _validMagazines = _suitableMags arrayIntersect _availableMags;

private _attributes = [];
private _indexes = [];

{
    // compute available weapons and magazines count for this weapon
    private _i = _availableMags find _x;
		private _amount = 200;

		if (_i < (count _arsenalMags)) then {
				private _amount = _availableMagsAmounts select _i;
		};

	 	private _m_index = AS_allMagazines find _x;

		if (_amount > 0) then {
			_attributes pushBack ((AS_allMagazinesAttrs select _m_index) + [_amount]);
			_indexes pushBack _forEachIndex;
		};


} forEach _validMagazines;

if ((count _indexes) == 0) exitwith { [[""],[0]] };



//TODO: different sorting for AT, AA and such?

private _sortingFunction = {
	private _bull_weight = (_input0 select _x) select 0;
	private _bull_speed = (_input0 select _x) select 1;
	private _ammocount = (_input0 select _x) select 2;
	private _amount = (_input0 select _x) select 3;

	private _m_factor = 1.0/(1 + exp (-2*_amount + 8*_maxAmount));  // 0 => 0; _recomendedMags => 0.5; 100 => 1

	_m_factor*(((_bull_speed/40)^2) * _bull_weight)*(_ammocount)
};

_indexes = [_indexes, [_attributes], _sortingFunction, "DESCEND"] call BIS_fnc_sortBy;


/*// check if mags are unlimited. If yes, exit with then
if (count _alwaysAvailable > 0) exitWith {
	// todo: choose best?
	private _mag = _alwaysAvailable select 0;

	[[_mag], [_maxAmount]]
};
*/
// else, fill result with the mags from the box
//private _availableMags = +((call AS_fnc_getArsenal) select 1);
private _result = [[], []];  // magazines names, magazines count
private _totalMags = 0;  // sum of the second list of _result.
private _count = count _indexes;
for "_i" from 0 to _count - 1 do {
	if (_totalMags == _maxAmount) exitWith {};

	private _mag = _validMagazines select (_indexes select _i);
	private _amount = (_attributes select _i) select 3;


		(_result select 0) pushBack _mag;
		// cap on maxAmount.
		if (_totalMags + _amount >= _maxAmount) then {
			_amount = _maxAmount - _totalMags;
		};
		(_result select 1) pushBack _amount;

		_totalMags = _totalMags + _amount;
};




_result
