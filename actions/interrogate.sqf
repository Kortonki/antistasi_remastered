#include "../macros.hpp"
params ["_unit", "_player"];

[_unit, "remove"] remoteExec ["AS_fnc_addaction", [0,-2] select isDedicated];

if (!alive _unit) exitWith {};

//_player globalChat "You *&%#¤! Tell me what you know!";

private _chance = 100 -  4*(AS_P("skillAAF")) -  0.5*((AS_P("CSATsupport")) - (AS_P("NATOsupport")));


_chance = (_chance max 20) min 95;

if (floor random 100 < _chance) then {
	["Suprprisingly he told you something valuable"] remoteExec ["hint", _player];
	[_unit] call AS_fnc_showFoundIntel;
} else {
	["He doesn't want to co-operate"] remoteExec ["hint", _player];
};
