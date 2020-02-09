// Increases the time the location is busy.
// Location needs to be a base or airport
#include "../macros.hpp"
AS_SERVER_ONLY("AS_location_fnc_increaseBusy");
params ["_location", "_minutes"];
private _busy = [_location,"busy"] call AS_location_fnc_get;
if (_busy < dateToNumber date) then {_busy = dateToNumber date};

private _busy2 = numberToDate [2035,_busy];
_busy2 set [4, (_busy2 select 4) + _minutes];

[_location,"busy",dateToNumber _busy2] call AS_location_fnc_set;
