#include "../macros.hpp"
params ["_origin", "_destination"];

private _restrict_to_locked = false;
if (_destination == caja) then {
	_restrict_to_locked = true;
	//waitUntil {sleep 0.1; not AS_S("lockTransfer")}; //No need to lock as we are not clearing the arsenal
	//AS_Sset("lockTransfer", true);
};

([_origin] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magazineRemains"];
[_destination, _cargo_w, _cargo_m, _cargo_i, _cargo_b, _restrict_to_locked] call AS_fnc_populateBox;
[_origin] call AS_fnc_emptyCrate;

if (_destination == caja) then {
	//AS_Sset("lockTransfer", false);
	[cajaVeh, _magazineRemains] call AS_fnc_addMagazineRemains;
} else {
		[_destination, _magazineRemains] call AS_fnc_addMagazineRemains;
};
