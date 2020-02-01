params [["_order", ""]];

if (map_location == "") exitWith {hint "No map location selected";};

private _location = map_location;

if (_order in  ["BLUE", "GREEN", "WHITE", "YELLOW", "RED"]) then {
  [_location, "combatMode", _order] call AS_location_fnc_set;
  if (_location call AS_location_fnc_spawned) then {

      // combatmode must be run from server (groupowner needs it)
    [_location, _order, ""] remoteExec ["AS_AI_fnc_setOrders", 2];
  };
};

if (_order in ["CARELESS","SAFE", "AWARE", "COMBAT", "STEALTH"]) then {
  [_location, "behaviour", _order] call AS_location_fnc_set;

  if (_location call AS_location_fnc_spawned) then {

      // combatmode must be run from server (groupowner needs it)
    [_location, "", _order] remoteExec ["AS_AI_fnc_setOrders", 2];
  };
};
