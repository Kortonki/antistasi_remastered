#include "macros.hpp"
AS_SERVER_ONLY("initLocations.sqf");

call AS_location_fnc_initialize;

AS_antenasTypes = [];
AS_antenasPos_alive = [];

//Set sandbag and bunker classnames for roadblocks, locations and HQ fortifications. Set a proper camo for map type.

AS_small_bunker_type = "Land_BagBunker_01_small_green_F";
AS_big_bunker_type = "Land_BagBunker_01_large_green_F";
AS_sandbag_type_round = "Land_BagFence_01_round_green_F";
AS_camonet_type = "CamoNet_BLUFOR_big_F";
AS_h_barrier_type = "Land_HBarrier_01_line_5_green_F";

// tower buiuldings where MGs are placed. If no towers, no MGs are placed.
AS_MGbuildings = [
    "Land_Cargo_Tower_V1_F",
    "Land_Cargo_Tower_V1_No1_F",
    "Land_Cargo_Tower_V1_No2_F",
    "Land_Cargo_Tower_V1_No3_F",
    "Land_Cargo_Tower_V1_No4_F",
    "Land_Cargo_Tower_V1_No5_F",
    "Land_Cargo_Tower_V1_No6_F",
    "Land_Cargo_Tower_V1_No7_F",
    "Land_Cargo_Tower_V2_F",
    "Land_Cargo_Tower_V3_F",
    "Land_BagBunker_01_small_green_F",
    "Land_BagBunker_Small_F"

];
// building types whose destruction is saved persistently
AS_destroyable_buildings = AS_MGbuildings + [
    "Land_Cargo_HQ_V1_F",
    "Land_Cargo_HQ_V2_F",
    "Land_Cargo_HQ_V3_F",
    "Land_Cargo_Patrol_V1_F",
    "Land_Cargo_Patrol_V2_F",
    "Land_Cargo_Patrol_V3_F",
    "Land_HelipadSquare_F",
    "Land_Cargo_Tower_V1_ruins_F",
    "Land_Cargo_Tower_V2_ruins_F",
    "Land_Cargo_Tower_V3_ruins_F",
    "Land_TTowerBig_1_F",
    "Land_TTowerBig_2_F",
    "Land_Communication_F"
] - ["Land_BagBunker_01_small_green_F","Land_BagBunker_Small_F"];

// these are the lamps that are shut-off when the city loses power.
// if empty, no lamps are turned off
AS_lampTypes = [
    "Lamps_Base_F",
    "PowerLines_base_F",
    "Land_LampDecor_F",
    "Land_LampHalogen_F",
    "Land_LampHarbour_F",
    "Land_LampShabby_F",
    "Land_NavigLight",
    "Land_runway_edgelight",
    "Land_PowerPoleWooden_L_F"
];
// positions of the banks. If empty, there are no bank missions.
AS_bankPositions = [];

private _mapType = "MapBoard_altis_F";
if (worldName == "Altis") then {
    call compile preprocessFileLineNumbers "templates\world_altis.sqf";
};
if (worldName == "Tanoa") then {
    call compile preprocessFileLineNumbers "templates\world_tanoa.sqf";
    _mapType = "MapBoard_tanoa_F";
};
if (worldName == "Ruha") then {
    call compile preprocessFileLineNumbers "templates\world_ruha.sqf";
    _mapType = "MapBoard_tanoa_F";
};


// exclude from `AS_antenasPos_alive` positions whose antenas are not found
{
    private _antenaProv = nearestObjects [_x, AS_antenasTypes, 25];
    if (count _antenaProv > 0) then {
        (_antenaProv select 0) addEventHandler ["Killed", AS_fnc_antennaKilledEH];
    } else {
        AS_antenasPos_alive = AS_antenasPos_alive - [_x];
    };
} forEach +AS_antenasPos_alive;

AS_Pset("antenasPos_alive", AS_antenasPos_alive);
AS_Pset("antenasPos_dead", []);
// these were only needed for the list above.
AS_antenasTypes = nil;
AS_antenasPos_alive = nil;
publicVariable "AS_destroyable_buildings";
publicVariable "AS_MGbuildings";
publicVariable "AS_bankPositions";
publicVariable "AS_sandbag_type_round";
publicVariable "AS_small_bunker_type";
publicVariable "AS_big_bunker_type";
publicVariable "S_camonet_type";
publicVariable "AS_h_barrier_type";

// This searches through all the markers in the mission.sqm and adds them.
{
    call {
        if (_x find "blacklist" > 0) exitWith {_x setMarkerAlpha 0}; //This was added to not spawn vehicles on runways 
        if (_x find "AS_powerplant" == 0) exitWith {[_x, "powerplant"] call AS_location_fnc_add};
        if (_x find "AS_base" == 0) exitWith {[_x, "base"] call AS_location_fnc_add};
        if (_x find "AS_airfield" == 0) exitWith {[_x, "airfield"] call AS_location_fnc_add};
        if (_x find "AS_resource" == 0) exitWith {[_x, "resource"] call AS_location_fnc_add};
        if (_x find "AS_factory" == 0) exitWith {[_x, "factory"] call AS_location_fnc_add};
        if (_x find "AS_seaport" == 0) exitWith {[_x, "seaport"] call AS_location_fnc_add};
        if (_x find "AS_outpostAA" == 0) exitWith {[_x, "outpostAA"] call AS_location_fnc_add};
        if (_x find "AS_outpost" == 0) exitWith {[_x, "outpost"] call AS_location_fnc_add};
        if (_x find "AS_roadblock" == 0) exitWith {[_x, "roadblock"] call AS_location_fnc_add};

    };
} forEach (allMapMarkers select {!(_x find "convoy" > 0)}); //Do not make locations out of convoy start markers

call AS_location_fnc_addAllRoadblocks;

["FIA_HQ", "fia_hq"] call AS_location_fnc_add;

// Initializes HQ placements and petros

bandera  = "Flag_FIA_F" createvehicle [0,0,0];
publicVariable "bandera";
bandera allowdamage false;
fuego = "Land_Campfire_F" createvehicle [0,0,0];
publicVariable "fuego";
fuego allowDamage false;
caja = "IG_supplyCrate_F" createvehicle [0,0,0];
[caja] call AS_fnc_emptyCrate;
publicVariable "caja";
caja allowDamage false;
mapa = _mapType createvehicle [0,0,0];
publicVariable "mapa";
mapa allowDamage false;
cajaVeh = "Box_NATO_AmmoVeh_F" createvehicle [0,0,0];
publicVariable "cajaVeh";
cajaVeh allowDamage false;
vehiclePad = "Land_JumpTarget_F" createvehicle [0,0,0];
publicVariable "vehiclePad";
vehiclePad allowDamage false;

AS_permanent_HQplacements = [caja, cajaVeh, mapa, fuego, bandera, vehiclePad];
AS_HQ_placements = []; // objects placed on HQ
