#include "../macros.hpp"
/*
This function adds stuff to the box. "restrict" is used to only add if a condition is fulfilled.
See implementation below.
*/
params ["_box", "_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", ["_restrict", false], ["_clear", false]];
private ["_name", "_amount"];

/*private _is_locked = {
	waitUntil {sleep 1; not(isNull _box)};
	_box getVariable ["AS_lockedCargo", false]
};

if (call _is_locked) then {
	waitUntil {sleep 0.1; not(call _is_locked)};
};
_box setVariable ["AS_lockedCargo", true, true];*/


//Only final cargo arrays here meaning unlocked removed to avoid unneccessary fiddling
if (_box == caja) exitWith {

	if (!_clear) then {
		[_cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_addToArsenal;
	} else {
		[_cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_setArsenal;
	};
};

if _clear then {
	[_box] call AS_fnc_emptyCrate;
};

for "_i" from 0 to (count (_cargo_w select 0) - 1) do {
	_name = (_cargo_w select 0) select _i;
	_amount = (_cargo_w select 1) select _i;
	_box addWeaponCargoGlobal [_name,_amount max 0];
};

for "_i" from 0 to (count (_cargo_m select 0) - 1) do {
	_name = (_cargo_m select 0) select _i;
	_amount = (_cargo_m select 1) select _i;
	_box addMagazineCargoGlobal [_name,_amount max 0];

};

for "_i" from 0 to (count (_cargo_i select 0) - 1) do {
	_name = (_cargo_i select 0) select _i;
	_amount = (_cargo_i select 1) select _i;
	_box addItemCargoGlobal [_name,_amount max 0];
};

for "_i" from 0 to (count (_cargo_b select 0) - 1) do {
	_name = (_cargo_b select 0) select _i;
	_amount = (_cargo_b select 1) select _i;
	_box addBackpackCargoGlobal [_name,_amount max 0];
};
