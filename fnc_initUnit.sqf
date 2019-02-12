params ["_unit", "_faction", "_spawned"];

if (_faction == "AAF") exitWith {
    [_unit, _spawned] remoteExecCall ["AS_fnc_initUnitAAF", _unit];
};
if (_faction == "CSAT") exitWith {
    [_unit] RemoteExec ["AS_fnc_initUnitCSAT", _unit];
};
if (_faction == "NATO") exitWith {
    [_unit] RemoteExec ["AS_fnc_initUnitNATO", _unit];
};
if (_faction == "FIA") exitWith {
    [_unit, _spawned] remoteExecCall ["AS_fnc_initUnitFIA", _unit];
};
if (_faction == "CIV") exitWith {
    [_unit] RemoteExec ["AS_fnc_initUnitCIV", _unit];
};
