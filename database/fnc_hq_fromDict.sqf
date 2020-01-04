#include "../macros.hpp"
AS_SERVER_ONLY("AS_database_fnc_hq_fromDict");
params ["_dict"];

{
    (AS_permanent_HQplacements select _forEachIndex) setPos (_x select 0);
    (AS_permanent_HQplacements select _forEachIndex) setDir (_x select 1);
} forEach ([_dict, "permanents"] call DICT_fnc_get);

{deleteVehicle _x} forEach AS_HQ_placements;
AS_HQ_placements = [];
{
    _x params ["_pos", "_dir", "_type"];
    private _obj = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
    _obj setDir _dir;
    _obj setVectorUp (surfacenormal (getPosATL _obj));
    AS_HQ_placements pushBack _obj;
    [_obj, "moveObject"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
} forEach ([_dict, "placed"] call DICT_fnc_get);

fuego inflame ([_dict, "inflame"] call DICT_fnc_get);

private _dummy = (["FIA", "flag"] call AS_fnc_getEntity) createVehicle [0,0,0];
_texture = flagTexture _dummy;
bandera setFlagTexture _texture;
deletevehicle _dummy;

call AS_fnc_initPetros;
