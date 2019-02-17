params ["_unit", "_player"];

//[[_unit, "remove"],"AS_fnc_addAction"] call BIS_fnc_MP;
[_unit, "remove"] remoteExec ["AS_fnc_addaction", [0, -2] select isDedicated];

_player globalChat "You are free. Come with us!";
if captive _player then {
	[_player, false] remoteExec ["setCaptive", _player];
};
sleep 1;



_unit sideChat "Thank you. I owe you my life!";

[_unit, "ALL"] remoteExecCall ["enableAI", _unit];
/*_unit enableAI "MOVE";
_unit enableAI "AUTOTARGET";
_unit enableAI "TARGET";
_unit enableAI "ANIM";*/
//[_unit setCaptive false;
[_unit, false] remoteExecCall ["setcaptive", _unit];
[_unit] remoteExecCall ["AS_fnc_initUnitFIA", _unit]; 

sleep 5; // This to make sure the unit is inited
[[_unit], group _player] RemoteExecCall ["join", _player];
