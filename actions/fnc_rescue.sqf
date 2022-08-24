params ["_unit", "_player"];

[_unit, "remove"] remoteExec ["AS_fnc_addaction", [0, -2] select isDedicated];

_player groupChat "You are free. Come with us!";
if (captive _player and{[_player] call AS_fnc_detected}) then {
	[_player, false] remoteExec ["setCaptive", _player];
};
sleep 1;

["rescued", 1, "fiastats"] remoteExec ["AS_stats_fnc_change", 2];

_unit sideChat "Thank you. I owe you my life!";

[_unit, "ALL"] remoteExecCall ["enableAI", _unit];
/*_unit enableAI "MOVE";
_unit enableAI "AUTOTARGET";
_unit enableAI "TARGET";
_unit enableAI "ANIM";*/
//[_unit setCaptive false;

private _captive = captive _player;

[_unit] remoteExec ["AS_fnc_initUnitFIA", _unit];

sleep 5; // This to make sure the unit is inited
[[_unit], group _player] RemoteExecCall ["join", _player];

if (!(_captive)) then {
	[_unit, false] remoteExecCall ["setcaptive", _unit];
} else {
	[_unit] remoteExec ["AS_fnc_activateUndercoverAI", _unit];
};
