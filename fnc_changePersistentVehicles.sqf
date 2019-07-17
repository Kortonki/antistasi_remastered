#include "macros.hpp"
AS_SERVER_ONLY("fnc_changePersistentVehicles.sqf");

params ["_vehicles", ["_add", true]];

if (typeName _vehicles != "ARRAY") then {
    _vehicles = [_vehicles];
};

if (_add) then {
    AS_Pset("vehicles", AS_P("vehicles") + _vehicles);
    diag_log format ["[AS] Vehicle added to persistents. Vehicle %1, location %2", _vehicles, (position (_vehicles select 0)) call AS_location_fnc_nearest];
} else {
    AS_Pset("vehicles", AS_P("vehicles") - _vehicles);
    diag_log format ["[AS] Vehicle removed from persistents. Vehicle %1, location %2", _vehicles, (position (_vehicles select 0)) call AS_location_fnc_nearest];
    // set the vehicles back to the despawner
    {
        [_x] spawn AS_fnc_activateVehicleCleanup;
    } forEach _vehicles;
};
