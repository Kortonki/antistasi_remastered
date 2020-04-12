params ["_position", "_group", ["_priority", 0.25]];

private _vehicles = [];
private _units = [];

(_position call AS_fnc_roadAndDir) params ["_road", "_dir"];
if (!isNull _road and {["static_at", _priority] call AS_fnc_vehicleAvailability}) then {
    //spg can't fire over the bunker wall -> todo: sandbags to the side?
    private _pos = [getPos _road, 7, _dir + 270] call BIS_Fnc_relPos;
    //private _bunker = "Land_BagBunker_Small_F" createVehicle _pos;
    //_bunker setDir _dir;
    //_pos = getPosATL _bunker;
    //_vehicles pushBack _bunker;

    private _veh = [selectRandom (["AAF", "static_at"] call AS_fnc_getEntity), _pos, "AAF", _dir + 180, "NONE"] call AS_fnc_createEmptyVehicle;
    _vehicles pushBack _veh;

    private _unit = ([_position, 0, ["AAF", "gunner"] call AS_fnc_getEntity, _group] call bis_fnc_spawnvehicle) select 0;
    _unit moveInGunner _veh;
    [_unit, false] call AS_fnc_initUnitAAF;
    _units pushBack _unit;
};
[_units, _vehicles]
