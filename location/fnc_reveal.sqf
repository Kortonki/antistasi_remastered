params ["_veh", ["_location",""]];
diag_log format ["AS_fnc_reveal started. Parameters: _veh: %1 _location %2", _veh, _location];
if (isNil "_veh") exitWith {diag_log format ["AS Error: nil vehicle passed to AS_location_fnc_reveal. Location: %1", _location]};
if (_location in ([] call AS_location_fnc_knownLocations)) exitWith {}; //No need for checks if locations is already known

while {sleep AS_spawnLoopTime; (alive _veh) and {!(_location in ([] call AS_location_fnc_knownLocations))}} do {
  {
      if (_x knowsAbout _veh > 1.4) then {
        if (leader _x == _x and {(position _x) call AS_fnc_hasRadioCoverage}) then {

           [_x, _location] spawn {
             params ["_unit","_location"];
             sleep (10 + random 30);
             if (alive _unit and {!(_unit call AS_medical_fnc_isUnconscious)}) then {
                [_location] call AS_location_fnc_knownLocations;
              };
             };
           } else {
                private _group = group _x;
                if (!(_group getVariable ["inving", false])) then {
                  _group move (position _veh);
                  _group setBehaviour "STEALTH";
                  _group setVariable ["inving", true, true];
                };
              };
          };

  } forEach (allUnits select {(_x call AS_fnc_getSide) in ["AAF","CSAT"]});
};
diag_log format ["AS_fnc_reveal ended. Parameters: _veh: %1 _location %2", _veh, _location];