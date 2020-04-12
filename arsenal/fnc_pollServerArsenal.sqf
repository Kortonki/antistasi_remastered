#include "../macros.hpp"
AS_SERVER_ONLY("AS_fnc_pollServerArsenal.sqf");

params ["_unit", "_phase", "_box"];

private _owner = owner _unit;

while {lockArsenal} do {
  ["Arsenal is busy, wait"] remoteExec ["hint", _unit];
  sleep 0.5;
};

private _arsenal = ([caja, true] call AS_fnc_getBoxArsenal);

if (_phase == "open") exitWith {
  [_arsenal, _box, _unit] remoteExec ["AS_fnc_openArsenal", _owner, false];
};
//Arsenal is locked during the time player gear is checked and removed from ARSENAL
lockArsenal = true;
[_arsenal, _unit] remoteExec ["AS_fnc_checkArsenal", _owner, false];
