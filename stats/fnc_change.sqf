params ["_attribute", "_diff", "_key"];

if (isnil "_key") then {
  [AS_container, "stats", ([_attribute] call AS_stats_fnc_get) + _diff] call DICT_fnc_setGlobal;
} else {
  [AS_container, "stats", _key, ([_attribute, _key] call AS_stats_fnc_get) + _diff] call DICT_fnc_setGlobal;
};
