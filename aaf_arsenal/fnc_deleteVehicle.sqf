// Removes the vehicle type from the arsenal.
#include "../macros.hpp"
params ["_type"];
private _category = _type call AS_AAFarsenal_fnc_category;
private _count = _category call AS_AAFarsenal_fnc_count;
[_category, "count", _count - 1] call AS_AAFarsenal_fnc_set;
