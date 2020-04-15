#include "../macros.hpp"
params ["_origin", "_destination"];

([_origin] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magazineRemains"];

private _restrict_to_locked = false;



if (_destination == caja) then {
	//AS_Sset("lockTransfer", false);
	[_destination, _cargo_w, _cargo_m, _cargo_i, _cargo_b, _restrict_to_locked] remoteExec ["AS_fnc_populateBox", 2];
	[cajaVeh, _magazineRemains] call AS_fnc_addMagazineRemains;
} else {
		[_destination, _cargo_w, _cargo_m, _cargo_i, _cargo_b, _restrict_to_locked] call AS_fnc_populateBox;
		[_destination, _magazineRemains] call AS_fnc_addMagazineRemains;
};

[_origin] call AS_fnc_emptyCrate;
