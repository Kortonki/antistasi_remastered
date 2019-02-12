params ["_unit"];

private _side = _unit getVariable "AS_side";

if (isNil "_side") then {
    _side = "UNKNOWN";
    diag_log format ["[AS] Error: %1 (%2) was initialized without side", _unit, typeOf _unit];
};

_side
