private _caller = _this select 1;

private _cargo = [_caller, true] call AS_fnc_getUnitArsenal;

private _cargo_w = _cargo select 0;
private _cargo_m = _cargo select 1;
private _cargo_i = _cargo select 2;
private _cargo_b = _cargo select 3;

[cajaVeh, (_cargo select 4)] call AS_fnc_addMagazineRemains;
[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_populateBox;

_caller call AS_fnc_emptyUnit;

_caller call AS_fnc_equipDefault;
