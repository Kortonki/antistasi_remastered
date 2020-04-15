params ["_side"];

private _dummy = ([_side, "flag"] call AS_fnc_getEntity) createVehicleLocal [0,0,0];
private _texture = flagTexture _dummy;
deletevehicle _dummy;
_texture
