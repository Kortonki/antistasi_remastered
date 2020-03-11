#include "../macros.hpp"
AS_SERVER_ONLY("AS_AAFarsenal_fnc_fromDict");
params ["_dict"];
call AS_AAFarsenal_fnc_deinitialize;
[AS_container, "aaf_arsenal", _dict call DICT_fnc_copyGlobal] call DICT_fnc_setGlobal; //Changed to copyGlobal

//LEGACY STUFF for saves without statics in AAF arsenal

{
  private _category = _x select 0;
  private _name = _x select 1;
  private _cost = _x select 2;
  if (!([call AS_AAFarsenal_fnc_dictionary, _category] call DICT_fnc_exists)) then {
    [call AS_AAFarsenal_fnc_dictionary, _category, call DICT_fnc_create] call DICT_fnc_setGlobal;
    [_category, "name", _name] call AS_AAFarsenal_fnc_set;
    [_category, "count", floor((_category call AS_AAFarsenal_fnc_max)/2)] call AS_AAFarsenal_fnc_set;
    [_category, "cost", _cost] call AS_AAFarsenal_fnc_set;
    [_category, "value", _cost/2] call AS_AAFarsenal_fnc_set;
    [_category, "valid", ["AAF", _category] call AS_fnc_getEntity] call AS_AAFarsenal_fnc_set;
  };
} foreach [["static_mg", "MG statics", 300], ["static_at", "AT statics", 600], ["static_mortar", "Mortars", 600], ["static_aa", "AA statics", 1200]];
