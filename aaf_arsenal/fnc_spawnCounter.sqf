#include "../macros.hpp"
params ["_vehicleType", ["_toAdd", true]];

private _vehicleClass = _vehicleType call AS_AAFarsenal_fnc_category;
if (_vehicleClass != "") then {
    private _name = format ["spawned_%1", _vehicleClass];
    private _count = AS_S(_name);
    if (_toAdd) then {
      _count = _count + 1;
    } else {
      _count = _count - 1;
    };
    AS_Sset(_name, _count);
};
