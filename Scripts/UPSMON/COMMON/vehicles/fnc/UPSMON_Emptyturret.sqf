/****************************************************************
File: UPSMON_Emptyturret.sqf
Author: Azroul13

Description:
	Get number of empty turret
Parameter(s):
	<--- vehicle
Returns:
	number
****************************************************************/

private ["_turretpath","_number"];

//_turretpath = _this call UPSMON_fnc_commonTurrets;
//This should return the same excluding FFV turrets
_turretpath = allTurrets [_this, false];

_number = 0;

{
	If (IsNull (_this turretUnit _x)) then {_number = _number + 1;};
} foreach _turretpath;

_number
