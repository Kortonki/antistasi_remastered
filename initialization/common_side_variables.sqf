#include "../macros.hpp"

//Side stuff here


// Picks stuff from templates, checks consistency and define common names
call compile preprocessFileLineNumbers "initSides.sqf";

// Initializes all AAF/NATO/CSAT items (e.g. weapons, mags) from the global variables
// in the templates above. Only non-public globals defined.
call compile preprocessFileLineNumbers "initItemsSides.sqf";

//Keys depending on player side

if (hasACE) then {
  if (AS_P("player_side") == "west") then {
    unlockedItems pushback "ACE_key_west";
  } else {
    unlockedItems pushback "ACE_key_east";
  };
};

AS_Arsenal_initialized = true;
//publicVariable "AS_Arsenal_initialized"; //Commented out, everyone runs this clients and server

// Compositions used to spawn camps, etc. Only non-public globals defined.
call compile preprocessFileLineNumbers "Compositions\campList.sqf";
call compile preprocessFileLineNumbers "Compositions\FIA_RB.sqf";
call compile preprocessFileLineNumbers "Compositions\cmpNATO_RB.sqf";
call compile preprocessFileLineNumbers "Compositions\cmpExp.sqf";
call compile preprocessFileLineNumbers "Compositions\genericCompositions.sqf";

AS_compositions = call DICT_fnc_create;
[AS_compositions, "locations", call DICT_fnc_create] call DICT_fnc_set;

if (worldName == "Altis") then {
    call compile preprocessFileLineNumbers "Compositions\locations_altis.sqf";
};
if (worldName == "Tanoa") then {
    call compile preprocessFileLineNumbers "Compositions\locations_tanoa.sqf";
};

if (worldName == "Ruha") then {
    call compile preprocessFileLineNumbers "Compositions\locations_ruha.sqf";
};

if (worldName == "Enoch") then {
    call compile preprocessFileLineNumbers "Compositions\locations_Enoch.sqf";
};

if (worldName == "tem_kujari") then {
    call compile preprocessFileLineNumbers "Compositions\locations_tem_kujari.sqf";
};
