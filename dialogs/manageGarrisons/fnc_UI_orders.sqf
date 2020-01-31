params [["_order", 0]];

if (map_location == "") exitWith {hint "No map location selected";};

if (_order == 0) then {[map_location, "combatMode", "GREEN"] call AS_location_fnc_set;};
if (_order == 1) then {[map_location, "combatMode", "YELLOW"] call AS_location_fnc_set;};
