#include "../macros.hpp"

// the current vehicles of a given category or list of categories.
// If no argument is provided, returns all vehicles of all categories
private _categories = _this;
if (typeName _categories == "STRING") then {
    _categories = [_this];
};
if (isNil "_categories") then {
    _categories = call AS_AAFarsenal_fnc_all;
};
private _all = 0;
{
  private _name = format ["spawned_%1", _x];
  _all = _all + ([_x, "count"] call AS_AAFarsenal_fnc_get) - (AS_S(_name));
} forEach _categories;
_all
