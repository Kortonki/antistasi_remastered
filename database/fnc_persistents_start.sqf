#include "../macros.hpp"
AS_SERVER_ONLY("AS_database_fnc_persistents_start");

// modify map items consequent of the persistents
private _towerIndex = 0;
{
    private _antenna = (nearestObjects [_x, AS_antenasTypes, 25]) select 0;
    _antenna removeAllEventHandlers "Killed";
    _antenna setDamage 1;

    private _marker = createMarker [format ["radioTower_%1", _towerIndex], _x];
    _towerIndex = _towerIndex + 1;
    _marker setmarkerType "hd_destroy";
    _marker setMarkerColor "ColorRed";
    _marker setMarkerText "Radio Tower";

} forEach AS_P("antenasPos_dead");
{
    private _antenna = (nearestObjects [_x, AS_antenasTypes, 25]) select 0;
    _antenna removeAllEventHandlers "Killed";
    _antenna setDamage 0;

    private _marker = createMarker [format ["radioTower_%1", _towerIndex], _x];
    _towerIndex = _towerIndex + 1;
    _marker setmarkerType "loc_Transmitter";
    _marker setMarkerText "Radio Tower";
    _antenna addEventHandler ["Killed", AS_fnc_antennaKilledEH];

} forEach AS_P("antenasPos_alive");

{
    [_x, false] call AS_fnc_destroy_location;
} forEach AS_P("destroyedLocations");

// destroy the buildings.
{
    private _buildings = [];
    private _dist = 5;
    while {count _buildings == 0} do {
        _buildings = nearestObjects [_x, AS_destroyable_buildings, _dist];
        _dist = _dist + 5;
    };
    (_buildings select 0) setDamage 1;
} forEach AS_P("destroyedBuildings");

// this depends on destroyed locations, so it is run here
{
    [_x] call AS_fnc_recomputePowerGrid;
} forEach ("powerplant" call AS_location_fnc_T);

// resume saved patrols
[] spawn {
   sleep 25;
   {
    [[_x, "", 0, 0, true], "AS_movement_fnc_sendAAFpatrol"] call AS_scheduler_fnc_execute;
   } forEach AS_P("patrollingLocations");
{
    [[_x, "", 0, 0, true], "AS_movement_fnc_sendAAFpatrol"] call AS_scheduler_fnc_execute;
   } forEach AS_P("patrollingPositions");
};
