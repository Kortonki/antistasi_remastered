params ["_attribute", "_key"];

if (isnil "_key") then {
  [AS_container, "stats", _attribute] call DICT_fnc_get;
} else {
  [AS_container, "stats", _key, _attribute] call DICT_fnc_get;
};
