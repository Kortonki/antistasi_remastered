//This function will return all FIA locations discovered by the AAF. If any arguments, add or deduct from know Locations
//Only applies to hq, watchpost, roadblock and camp
params ["_location", ["_add", true]];

if (!(isNil "_location")) exitWith {
  diag_log format ["AS_fnc_knownlocations: Changing locations, params: Location %1, to add :%2", _location, _add];
  private _knownLocations = AS_persistent getVariable ["knownLocations", []];
  if (_add) then {
    _knownLocations pushbackUnique _location;
  } else {
    _knownLocations = _knownLocations - [_location];
  };
  AS_persistent setVariable ["knownLocations", _knownLocations, true];
  _knownLocations
};

AS_persistent getVariable ["knownLocations", []]
