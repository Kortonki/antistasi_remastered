params ["_location"];
if !(_location call AS_location_fnc_exists) exitWith {""};
[_location, "side"] call AS_location_fnc_get
