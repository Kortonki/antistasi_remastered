// Removes the vehicle type from the arsenal.
params ["_category"];
private _count = _category call AS_AAFarsenal_fnc_count;
[_category, "count", _count - 1] call AS_AAFarsenal_fnc_set;
diag_log format ["[AS] AAFArsenal: %1 removed from AAF arsenal, count now %2", _category, _count - 1];
