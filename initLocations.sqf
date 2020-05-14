#include "macros.hpp"
AS_SERVER_ONLY("initLocations.sqf");

call AS_location_fnc_initialize;

AS_antenasTypes = [];
AS_antenasPos_alive = [];

AS_RadioCoverage = 5000;

//TODO: Make these part of of world template
//Set sandbag and bunker classnames for roadblocks, locations and HQ fortifications. Set a proper camo for map type.

AS_small_bunker_type = "Land_BagBunker_01_small_green_F";
AS_big_bunker_type = "Land_BagBunker_01_large_green_F";
AS_sandbag_type_round = "Land_BagFence_01_round_green_F";
AS_camonet_type = "CamoNet_BLUFOR_big_F";
AS_h_barrier_type = "Land_HBarrier_01_line_5_green_F";
AS_h_barrier_big_type = "Land_HBarrier_01_big_4_green_F";

AS_antenasTypes = [
"Land_TTowerBig_1_F",
"Land_TTowerBig_2_F",
"Land_Com_tower_ep1",
"Land_Telek1",
"Land_Vysilac_vez",
"Land_TTowerBig_1_ruins_F",
"Land_TTowerBig_2_ruins_F",
"Land_Telek1_ruins",
"Land_Com_tower_ruins_EP1"
];

// tower buiuldings where MGs are placed. If no towers, no MGs are placed.
AS_MGbuildings = [
    "Land_Cargo_Tower_V1_F",
    "Land_Cargo_Tower_V2_F",
    "Land_Cargo_Tower_V3_F",
    "Land_Cargo_Patrol_V1_F",
    "Land_Cargo_Patrol_V2_F",
    "Land_Cargo_Patrol_V3_F",
    "Land_Cargo_HQ_V1_F",
    "Land_Cargo_HQ_V2_F",
    "Land_Cargo_HQ_V3_F",
    "Land_BagBunker_01_small_green_F",
    "Land_BagBunker_Small_F"


];
// building types whose destruction is saved persistently
AS_destroyable_buildings = AS_MGbuildings + [

    "Land_HelipadSquare_F",
    "Land_Cargo_Tower_V1_ruins_F",
    "Land_Cargo_Tower_V2_ruins_F",
    "Land_Cargo_Tower_V3_ruins_F"
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

//Map dependet enemy presence distance (affects ability to access garage, repair shit etc.)
AS_enemyDist = 500;

private _mapType = "MapBoard_altis_F";
if (worldName == "Altis") then {
    call compile preprocessFileLineNumbers "templates\world_altis.sqf";
};
if (worldName == "Tanoa") then {
    call compile preprocessFileLineNumbers "templates\world_tanoa.sqf";
    AS_enemyDist = 300;
    _mapType = "MapBoard_tanoa_F";
};
if (worldName == "Ruha") then {
    call compile preprocessFileLineNumbers "templates\world_ruha.sqf";
    AS_enemyDist = 300;
    _mapType = "MapBoard_tanoa_F";
};

if (worldName == "Enoch") then {
    call compile preprocessFileLineNumbers "templates\world_Enoch.sqf";
    AS_enemyDist = 300;
    _mapType = "Land_MapBoard_Enoch_F";
};

if (worldName == "tem_kujari") then {
    call compile preprocessFileLineNumbers "templates\world_tem_kujari.sqf";
    AS_enemyDist = 500;
};

publicVariable "AS_enemyDist";

// exclude from `AS_antenasPos_alive` positions whose antenas are not found
{
    private _antenaProv = nearestObjects [_x, AS_antenasTypes, 25];
    if (count _antenaProv > 0) then {
      private _marker = createMarker [format ["radioTower_%1", _forEachIndex], _x];
      _marker setmarkerType "loc_Transmitter";
      _marker setMarkerText "Radio Tower";
        (_antenaProv select 0) addEventHandler ["Killed", AS_fnc_antennaKilledEH];
    } else {
        AS_antenasPos_alive = AS_antenasPos_alive - [_x];
    };


} forEach +AS_antenasPos_alive;

AS_Pset("antenasPos_alive", AS_antenasPos_alive);
AS_Pset("antenasPos_dead", []);
// these were only needed for the list above.
//AS_antenasTypes = nil; //this is needed for new eventhandlers when antenna is repaired
AS_antenasPos_alive = nil;
publicVariable "AS_antenasTypes";
publicVariable "AS_destroyable_buildings";
publicVariable "AS_MGbuildings";
publicVariable "AS_bankPositions";
publicVariable "AS_sandbag_type_round";
publicVariable "AS_small_bunker_type";
publicVariable "AS_big_bunker_type";
publicVariable "S_camonet_type";
publicVariable "AS_h_barrier_type";
publicVariable "AS_RadioCoverage";



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
        if (_x find "AS_hillAA" == 0) exitWith {[_x, "hillAA"] call AS_location_fnc_add};

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

//Disable fuel from fuel stations



if (!isNil "ace_common_settingFeedbackIcons") then {
  private _allFuelStations = ([0,0,0] nearObjects 40000) select {([_x] call ace_refuel_fnc_getFuel) > 0};
  {[_x, 0] call ace_refuel_fnc_setFuel} foreach _allFuelStations;
} else {
  private _allFuelStations = ([0,0,0] nearObjects 40000) select {getFuelCargo _x > 0};
  {_x setFuelCargo 0} foreach _allFuelStations;
};

//Maximum amount for AAF vehicles
//Location(s), Types, amounts
//Differs from persistent variable which is updated every update
AS_maxAmounts = [
[["roadblock"],
  ["static_mg"],
  [2]],
[["outpost"],
["static_mg", "static_at", "cars_transport", "trucks"],
[4,1,1,1]],
[["outpostAA"],
["static_mg", "static_at", "static_aa", "cars_transport", "trucks"],
[4,1,2,1,1]],
[["factory", "resource", "powerplant"],
["static_mg", "static_at", "trucks"],
[4,1,1]],
[["seaport"],
["static_mg", "trucks", "boats"],
[4,1,4]],
[["base"],
["static_mg", "static_at", "static_aa", "static_mortar", "cars_transport", "cars_armed", "trucks", "apcs", "tanks"],
[8, 4, 4, 4, 2, 4, 7, 4, 4]], //Trucks 4 + 3 supports
[["airfield"],
["static_mg", "static_at", "static_aa", "cars_transport", "cars_armed", "trucks", "apcs", "helis_transport", "helis_armed", "planes"],
[8, 4, 4, 2, 4, 7, 4, 4, 4, 4]]
];
