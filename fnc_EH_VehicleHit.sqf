private _veh = _this select 0;
private _source = _this select 1;

if (_source != _veh) then {
  _veh setVariable ["vehLastDamagesource", _source, true];
};
