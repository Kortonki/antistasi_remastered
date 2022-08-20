#include "../macros.hpp"
params ["_unit", "_player"];

[_unit, "remove"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated, true];

if (!alive _unit) exitWith {};

_player globalChat "You have one chance, join us and help us liberate the island from tiranny!";

private _chance = AS_P("NATOsupport") - AS_P("CSATsupport");

_chance = _chance + 20;

if (_chance < 20) then {_chance = 20};

if (floor random 100 < _chance) then {
	//[_unit, true] enableSimulationGlobal true;
	_unit globalChat "Okay, thank you. I was expecting this this. See you in HQ";
	[_unit,""] remoteExecCall ["switchmove", _unit];
	[_unit,"ANIM"] remoteExecCall ["enableAI", _unit];
	[_unit, "MOVE"] remoteExecCall ["enableAI", _unit];
	[_unit, false] RemoteExecCall ["stop", _unit];

	[_unit,getMarkerPos "FIA_HQ"] remoteExec ["domove",_unit];
	if (_unit getVariable ["OPFORSpawn",false]) then {
		_unit setVariable ["OPFORSpawn",nil,true]
	};
	sleep 100;
	if alive _unit then {
		[1,0] remoteExec ["AS_fnc_changeForeignSupport",2];
		[-1,1,position _unit] remoteExec ["AS_fnc_changeCitySupport",2];
		[1,0] remoteExec ["AS_fnc_changeFIAmoney",2];
	};
} else {
	_unit globalChat "Screw you!";
};
