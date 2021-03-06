#include "../macros.hpp"
AS_SERVER_ONLY("AS_AAFarsenal_fnc_initialize");

[AS_container, "aaf_arsenal", call DICT_fnc_create] call DICT_fnc_setGlobal;

// AAF will only buy and use vehicles of the types added here. See template.
private _names = ["MG statics", "AT statics", "Mortars", "AA statics",
    "Trucks", "Cars", "Armed cars", "APCs", "Boats",
    "Transport Helicopters", "Tanks", "Armed Helicopters", "Planes"
];
// The list of all categories.
private _categories = [
  "static_mg", "static_at", "static_mortar", "static_aa", "trucks", "cars_transport", "cars_armed", "apcs", "boats", "helis_transport", "tanks", "helis_armed", "planes"
];
private _costs = [300, 600, 600, 1200, 600, 400, 1000, 5000, 600, 10000, 10000, 20000, 20000];

//this is subject to change

{
    [call AS_AAFarsenal_fnc_dictionary, _x, call DICT_fnc_create] call DICT_fnc_setGlobal;
    [_x, "name", _names select _forEachIndex] call AS_AAFarsenal_fnc_set;
    [_x, "count", 0] call AS_AAFarsenal_fnc_set;
    [_x, "cost", _costs select _forEachIndex] call AS_AAFarsenal_fnc_set;
    [_x, "value", (_costs select _forEachIndex)/2] call AS_AAFarsenal_fnc_set;
    [_x, "max", _x call AS_AAFarsenal_fnc_updateMax] call AS_AAFarsenal_fnc_set;
} forEach _categories;

//This just to bandaid weird bug where above function deletes "tanks", "static_mortar" and "boats" form _categories, but only if "max" dict entyry is made
//"max values entries are set just fine so it's some random shieeet
_categories = [
  "static_mg", "static_at", "static_mortar", "static_aa", "trucks", "cars_transport", "cars_armed", "apcs", "boats", "helis_transport", "tanks", "helis_armed", "planes"
];

// the order of which the AAF buys from categories (AS_fnc_spendAAFmoney.sqf)
AS_AAFarsenal_buying_order = +_categories;
