#include "../macros.hpp"
params ["_box", "_unit"];

if (not(isnil "AS_savingServer")) exitWith {hint "Server saving in progress. Wait."};
if (not(isnil {_unit getVariable "arsenalPoll"})) exitWith {hint "You're already trying to access arsenal.\n\n If this persists for over a minute, try exit the game to slotting room and rejoin."};
_unit setVariable ["arsenalPoll", true];

if (_box != caja) then {
    [_box, caja] call AS_fnc_transferToBox;
};

private _old_cargo = [_unit, true] call AS_fnc_getUnitArsenal;

_unit setVariable ["old_Cargo", _old_cargo, false];

hint "Opening arsenal";

[_unit, "open", _box] remoteExec ["AS_fnc_pollServerArsenal", 2];
