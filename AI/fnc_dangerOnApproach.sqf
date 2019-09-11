//Sets group to combat mode when approaching position and enables UPSMON stuff
//Combined with dismountonDanger should make group disembark when approaching the position
//Distance depends on threat evaluation

params ["_group", "_location"];


private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;
private _threat = _position call AS_fnc_getLandThreat;

private _distance = _size + (random 100) + (_threat*10);
private _leader = leader _group;


while {{alive _x} count units _group > 0} do {

  if (_leader distance2D _position < _distance) exitWith {
    _group setBehaviour "DANGER";
    [_leader, _location, "COMBAT", "SPAWNED", "NOFOLLOW", "NOVEH2"] spawn UPSMON;
  };

};
