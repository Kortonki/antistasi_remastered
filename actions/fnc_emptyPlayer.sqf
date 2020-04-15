private _caller = _this select 1;

private _cargo = [_caller, true] call AS_fnc_getUnitArsenal;
[cajaVeh, (_cargo select 4)] call AS_fnc_addMagazineRemains;
_cargo remoteExec ["AS_fnc_addToArsenal", 2];

_caller call AS_fnc_emptyUnit;

_caller call AS_fnc_equipDefault;
