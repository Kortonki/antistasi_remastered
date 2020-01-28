if !(_this call AS_location_fnc_exists) exitWith {false};

if (([_this,"spawned"] call AS_location_fnc_get) or ([_this,"forced_spawned"] call AS_location_fnc_get)) exitWith {true};
false
