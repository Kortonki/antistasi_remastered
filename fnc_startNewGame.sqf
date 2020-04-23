#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_startGame.sqf");
params ["_side", "_guerrilla", "_pro_guerrilla", "_state", "_pro_state", "_civilians", "_position", "_difficulty"];



AS_Pset("faction_anti_state", _guerrilla);
AS_Pset("faction_pro_anti_state", _pro_guerrilla);
AS_Pset("faction_state", _state);
AS_Pset("faction_pro_state", _pro_state);

//Override civilian template to match the same with FIA side
_civilians = ["FIA", "civs"] call AS_fnc_getEntity;

AS_Pset("faction_civilian", _civilians);

AS_Pset("player_side", _side);

[_position, true] call AS_fnc_HQplace;

//get flag texture of the player faction via a dummy flag. Used for the HQ flag

bandera setFlagTexture (["FIA"] call AS_fnc_getFlagTexture);



if (_difficulty == "easy") then {
    [caja, 10] call AS_fnc_fillCrateNATO;
};

// Fill Crate with additional items

//////////////////// additional Cargo /////////////////
//UGLY solution but works without new one-time use function
  {
    [
    [[_x select 0], [_x select 1]],
    [[],[]],
    [[],[]],
    [[],[]]
    ] call AS_fnc_addToArsenal;
  } foreach (["FIA", "addWeapons"] call AS_fnc_getEntity);

  {
    [
    [[],[]],
    [[_x select 0], [_x select 1]],
    [[],[]],
    [[],[]]
    ] call AS_fnc_addToArsenal;
  } foreach (["FIA", "addMagazines"] call AS_fnc_getEntity);

  {
    [
    [[],[]],
    [[],[]],
    [[],[]],
    [[_x select 0], [_x select 1]]
    ] call AS_fnc_addToArsenal;

  } foreach (["FIA", "addBackpacks"] call AS_fnc_getEntity);

  {
    [
    [[],[]],
    [[],[]],
    [[_x select 0], [_x select 1]],
    [[],[]]
    ] call AS_fnc_addToArsenal;
  } foreach (["FIA", "addItems"] call AS_fnc_getEntity);

// populate garage with vehicles
private _validVehicles = (
    (["FIA", "land_vehicles"] call AS_fnc_getEntity)
);
private _garageVehicles = [];
for "_i" from 1 to (1 + floor random 3) do {
	_garageVehicles pushBack (selectRandom _validVehicles);
};
AS_Pset("vehiclesInGarage", _garageVehicles);

{
    [_x, "valid", ["AAF", _x] call AS_fnc_getEntity] call AS_AAFarsenal_fnc_set;
} forEach AS_AAFarsenal_buying_order;

AS_dataInitialized = true;
publicVariable "AS_dataInitialized";

//Init weather

[] call AS_weather_fnc_init;
[] spawn AS_weather_fnc_randomWeather;
