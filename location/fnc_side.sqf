params ["_location"];
if !(_location call AS_location_fnc_exists) exitWith {""};
private _type = _location call AS_location_fnc_type;
if (_type != "city") exitWith {
    [_location, "side"] call AS_location_fnc_get
};
private _FIAsupport = [_location,"FIAsupport"] call AS_location_fnc_get;
private _AAFsupport = [_location,"AAFsupport"] call AS_location_fnc_get;
if (_AAFsupport >= _FIAsupport) exitWith {
    "AAF"
};
    "FIA"
