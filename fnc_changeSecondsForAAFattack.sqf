#include "macros.hpp"
AS_SERVER_ONLY("fnc_changeSecondsforAAFattack.sqf");

params ["_time"];

//TODO: same function in mission description. Make it a separate function and call it here AND mission description
private _allBases = ([["base", "airfield"], "AAF"] call AS_location_fnc_TS) select {_x call AS_fnc_hasRadioCoverage};

if (count _allBases == 0) then {
	_allBases = [0];  // avoid 0/0 below
};
private _multiplier = 0.5 + (1 - 0.5)*1/(count _allBases);
_time = _time * _multiplier * ((AS_P("upFreq"))/600); //Multiplier for game speed as well


//private _current = AS_P("secondsForAAFAttack");
//AS_Pset("secondsForAAFAttack", (_current + round _time) max 0);

private _nextAttack = AS_P("nextAttack");
private _date = numbertoDate [date select 0, _nextAttack];
_nextAttack = [_date select 0, _date select 1, _date select 2, _date select 3, (_date select 4) + (_time/60)];
_nextAttack = dateToNumber _nextAttack;
AS_Pset("nextAttack", _nextAttack);
