params ["_squadType", "_position", "_group"];
{

    _position = _position findEmptyPosition [0, 20, "B_G_Quadbike_01_F"];

    if (count _position < 3) then {
      _position = _position findEmptyPosition [0, 100,"B_G_Soldier_F"];
    };



    [_x, _position, _group, false, [], 0] call AS_fnc_spawnFIAUnit;
} forEach (["FIA", _squadType] call AS_fnc_getEntity);
