params ["_location", "_amount"];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _units = [];
private _groups = [];

private _count = 0;

_amount = round(_amount*AS_squadSizeRef);

while {_count < _amount} do {
    //if !(_location call AS_location_fnc_spawned) exitWith {};
    private _pos = [];
    while {true} do {
        _pos = [_position, random _size,random 360] call BIS_fnc_relPos;
        if (!surfaceIsWater _pos) exitWith {};
    };
    private _group = [_pos, "AAF" call AS_fnc_getFactionSide, [["AAF", "squads"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup] call BIS_Fnc_spawnGroup;

    private _stance = "RANDOM";
    if (_count == 0) then {_stance = "RANDOMUP"};

    _count = _count + (count (units _group));

    [leader _group,_location,"SAFE","SPAWNED",_stance,"NOVEH","NOFOLLOW"] spawn UPSMON;
    _groups pushBack _group;
    sleep 1;
};

{
private _group = _x;
  {
    [_x, false] call AS_fnc_initUnitAAF;
    _units pushBack _x;
  } forEach units _group;
} foreach _groups;


[_units, _groups]
