params ["_position", "_group", "_size", ["_priority", 0.25]];

private _vehicles = [];
private _units = [];

private _pos = [_position, _size/2, _size, 40, 0, 0.3, 0, [], [_position, [0,0,0]]] call BIS_Fnc_findSafePos;

if (["static_aa", _priority] call AS_fnc_vehicleAvailability and {!(_pos isEqualTo _position)}) then {
    //spg can't fire over the bunker wall -> todo: sandbags to the side?

    //private _bunker = "Land_BagBunker_Small_F" createVehicle _pos;
    //_bunker setDir _dir;
    //_pos = getPosATL _bunker;
    //_vehicles pushBack _bunker;

    private _veh = [selectrandom (["AAF", "static_aa"] call AS_fnc_getEntity), _pos, "AAF", random 360, "NONE"] call AS_fnc_createEmptyVehicle;
    _vehicles pushBack _veh;

    private _unit = ([_position, 0, ["AAF", "gunner"] call AS_fnc_getEntity, _group] call bis_fnc_spawnvehicle) select 0;
    _unit moveInGunner _veh;
    [_unit, false] call AS_fnc_initUnitAAF;
    _units pushBack _unit;
    //May have commander slot, for example RHS sergei
    if (_veh emptyPositions "Commander" > 0) then {
      private _commander = ([_position, 0, ["AAF", "gunner"] call AS_fnc_getEntity, _group] call bis_fnc_spawnvehicle) select 0;
      _commander moveInCommander _veh;
      _units pushback _commander;
      [_commander, false] call AS_fnc_initUnitAAF;
    };
};
[_units, _vehicles]
