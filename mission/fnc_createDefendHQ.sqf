#include "../macros.hpp"
AS_SERVER_ONLY("defendHQ");
private _location = "fia_hq";
private _position = _location call AS_location_fnc_position;

private _debug_prefix = "defend_hq cancelled: ";
if AS_S("blockCSAT") exitWith {
    private _message = "blocked";
    AS_ISDEBUG(_debug_prefix + _message);
};
if (count ("defend_hq" call AS_mission_fnc_active_missions) != 0) exitWith {
    private _message = "one already in progress";
    AS_ISDEBUG(_debug_prefix + _message);
    false
};
if (count ("defend_hq" call AS_mission_fnc_active_missions) != 0) exitWith {
    private _message = "one already in progress";
    AS_ISDEBUG(_debug_prefix + _message);
    false
};
if (not(alive petros)) exitWith {
    private _message = "Petros not alive";
    AS_ISDEBUG(_debug_prefix + _message);
    false
};

private _mission = ["defend_hq", _location] call AS_mission_fnc_add;
[_mission] call AS_mission_fnc_activate;
true
