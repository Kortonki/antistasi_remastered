#include "macros.hpp"
AS_SERVER_ONLY("fnc_changeSecondsforAAFattack.sqf");

params ["_time"];

private _FIAbases = ["base", "FIA"] call AS_location_fnc_TS;
private _allBases = "base" call AS_location_fnc_T;

if (count _allBases == 0) then {
	_allBases = [0];  // avoid 0/0 below
};
private _multiplier = 0.3 + (1 - 0.3)*(count _FIAbases)/(count _allBases);
_time = _time * _multiplier * ((AS_P("upFreq"))/600); //Multiplier for game speed as well


//private _current = AS_P("secondsForAAFAttack");
//AS_Pset("secondsForAAFAttack", (_current + round _time) max 0);

private _nextAttack = AS_P("nextAttack");
private _date = numbertoDate [date select 0, _nextAttack];
_nextAttack = [_date select 0, _date select 1, _date select 2, _date select 3, (_date select 4) + (_time/60)];
_nextAttack = dateToNumber _nextAttack;
AS_Pset("nextAttack", _nextAttack);
