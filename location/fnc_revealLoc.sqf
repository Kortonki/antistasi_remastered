params ["_location"];

private _position = _location call AS_location_fnc_position;
private _pos = [_position select 0, _position select 1, (getTerrainHeightASL _position) + 2.5];

while {sleep AS_spawnLoopTime; _location call AS_location_fnc_spawned and {!(_location in ([] call AS_location_fnc_knownLocations))}} do {
  {
    //Reveal location if there's enemies within range of the location
    //Only reveal to location if there's radio coverage and the leader is alive after the contact for some.

      if (_x distance2D _position < 50  and {([_x, "VIEW"] checkVisibility [eyepos _x, _pos]) > 0.5}) then {
        private _leader = leader _x;
        if (_leader == _x and {(position _x) call AS_fnc_hasRadioCoverage and {!(_x getVariable ["revealing", false])}}) then {

           [_x, _location, _position] spawn {
             params ["_unit","_location", "_position"];
             _unit setVariable ["revealing", true, true];
             sleep (5 + random 30);
             if (alive _unit and {random 100 > _unit distance2D _position}) then {
                waitUntil {sleep 1; !(_unit call AS_medical_fnc_isUnconscious)};
                [_location] call AS_location_fnc_knownLocations;
              };
              _unit setVariable ["revealing", nil, true];
             };
           } else {
                private _group = group _x;
                if (!(_group getVariable ["inving", false])) then {
                  _group move _position;
                  _group setBehaviour "STEALTH";
                  _group setVariable ["inving", true, true];
                };
              };
          };

  } forEach (allUnits select {(_x call AS_fnc_getSide) in ["AAF","CSAT"]});
};
