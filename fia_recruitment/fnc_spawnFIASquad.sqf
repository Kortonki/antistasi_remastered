params ["_squadType", "_position", "_group"];
{
    _position = _position findEmptyPosition [0, 30, "C_Hatchback_01_F"];
    [_x, _position, _group] call AS_fnc_spawnFIAUnit;
} forEach (["FIA", _squadType] call AS_fnc_getEntity);
