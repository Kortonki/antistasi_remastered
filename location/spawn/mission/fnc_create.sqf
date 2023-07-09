#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_create");
params ["_type", "_NATOsupport", ["_params", []]];
//timestamp to make spawn unique
private _suffix = format ["%1", diag_tickTime];
private _mission = [_type, _suffix] call AS_mission_fnc_add;
[-_NATOsupport, 0] call AS_fnc_changeForeignSupport;
[_mission, "NATOsupport", AS_P("NATOsupport")] call AS_mission_fnc_set;
{
    _x params ["_name", "_value"];
    [_mission, _name, _value] call AS_mission_fnc_set;
} forEach _params;
_mission call AS_mission_fnc_activate;
