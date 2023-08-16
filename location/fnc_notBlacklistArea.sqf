if (count _this < 3) exitWith {diag_log "AS_location_fnc_notBlacklistArea: Position of less than 3 elements was provided"; true};

private _pos = _this;
private _result = true;

{
  if (_pos inArea _x) exitWith {_result = false};
} foreach AS_blackListAreas;

_result
