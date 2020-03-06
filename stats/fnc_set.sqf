params ["_attribute", "_value", "_key"];
if (isnil "_key") then {
  [AS_container, "stats", _attribute, _value] call DICT_fnc_setGlobal;
} else {
  [AS_container, "stats", _key, _attribute, _value] call DICT_fnc_setGlobal;
};
