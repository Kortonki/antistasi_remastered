//Sets group to combat mode when approaching position and enables UPSMON stuff
//Combined with dismountonDanger should make group disembark when approaching the position
//Distance depends on threat evaluation

params ["_group", "_location", ["_minDist", 1000]];

private _position = _location;
private _size = 100;

//if destination is location
if (typename _location == "STRING") then {
  _position = _location call AS_location_fnc_position;
  _size = _location call AS_location_fnc_size;
};

private _patrolMarker = createMarker [format ["escort_%1", call AS_fnc_uniqueID], _position]; //location changed away to avoid sepc characters
_patrolMarker setMarkerShape "RECTANGLE";
_patrolMarker setMarkerSize [_size,_size];
_patrolMarker setMarkerAlpha 0;

private _threat = [_position, "FIA"] call AS_fnc_getLandThreat;

private _distance = _size + ((400 + (_threat*50)) min _minDist);
private _leader = leader _group;


while {{alive _x} count units _group > 0} do {

  if (_leader distance2D _position < _distance or behaviour _leader == "COMBAT" or vehicle _leader == _leader) exitWith {
    //This to let dismount on danger fire, stay in combat mode for dismount, then aware
    _group setBehaviour "COMBAT";
    sleep 20;
    [_leader, _patrolMarker, "AWARE", "SPAWNED", "NOVEH"] spawn UPSMON;
  };
  sleep 1;
};

waitUntil {sleep 10; {alive _x} count units _group == 0};

deleteMarker _patrolMarker;
