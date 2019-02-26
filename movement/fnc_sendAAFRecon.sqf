//TODO: Improve this to send recon patrols where FIA has been seen

private _position = [];
private _valid = false;
private _i = 0;
while {_i = _i + 1; !(_valid) and {_i < 100}} do { //Limit to 100 iterations
  private _searchFrom = selectRandom ([["base", "outpost", "airfield"], "AAF"] call AS_location_fnc_TS);
  _position = [(_searchFrom call AS_location_fnc_position), 500 + random 2000, random 360] call bis_fnc_relPos; //TODO check for map edges
  _valid = true;
  if (surfaceisWater _position) then {
    _valid = false;
  }  else {
    {
      if ((_x call AS_location_fnc_position) distance2D _position < 500) exitWith {_valid = false;}; //position is not too close to any other enemy position
    } foreach (["AAF", "CSAT"] call AS_location_fnc_S);
  };
};

if (_valid) then {
  [_position] spawn AS_movement_fnc_sendAAFpatrol;
  diag_log format ["[AS] sendAAFRecon: Send AAF recon patrol to position: %1", _position];
} else {
  diag_log "[AS] sendAAFRecon: No valid missions or recon areas for AAF. Do nothing";
};
