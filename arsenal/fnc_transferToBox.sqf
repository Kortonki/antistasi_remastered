#include "../macros.hpp"
params ["_origin", "_destination"];

([_origin] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magazineRemains"];

private _restrict_to_locked = false;



if (_destination == caja) then {
	//AS_Sset("lockTransfer", false);
	[_cargo_w, _cargo_m, _cargo_i, _cargo_b] remoteExec ["AS_fnc_addToArsenal", 2];
	[cajaVeh, _magazineRemains] call AS_fnc_addMagazineRemains;

	//Publish arsenal update
	//Arrays are copied and not referenced to because countArsenal fiddles with them
	private _itemArray = [+_cargo_w, +_cargo_m, +_cargo_i, +_cargo_b, _magazineRemains] call AS_fnc_countArsenal;
	if (count (_itemArray select 0) > 0) then {
		[_itemArray, "ARSENAL SUPPLIED WITH NEW EQUIPMENT\n", false] remoteExec ["AS_fnc_displayCargo_hint", AS_CLIENTS];
	};

} else {
		[_destination, _cargo_w, _cargo_m, _cargo_i, _cargo_b, _restrict_to_locked] call AS_fnc_populateBox;
		[_destination, _magazineRemains] call AS_fnc_addMagazineRemains;
};

[_origin] call AS_fnc_emptyCrate;
