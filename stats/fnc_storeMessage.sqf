params ["_date", "_message"];

private _msgs = ["storedmessages"] call AS_stats_fnc_get;

_msgs pushBack [_date, _message];

["storedmessages", _msgs] call AS_stats_fnc_set;
