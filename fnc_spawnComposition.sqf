params ["_location"];
private _returnObjects = [];
//This to spawn thing unscheduled to avoid exploding vehicles on spawn
private _check = isNil {
  if ([AS_compositions, "locations", _location] call DICT_fnc_exists) then {
    private _center = [AS_compositions, "locations", _location, "center"] call DICT_fnc_get;
    private _objects = [AS_compositions, "locations", _location, "objects"] call DICT_fnc_get;
    _returnObjects = [_center, 0, _objects] call BIS_fnc_ObjectsMapper;

  };
};

//This to alleviate floating objs problem
{
  [_x] spawn {
    params ["_obj"];
    sleep (60 + (random 15));
    _obj setPosATL [getPosATL _obj select 0,getPosATL _obj select 1,0];
    };
} foreach _returnObjects;
_returnObjects
