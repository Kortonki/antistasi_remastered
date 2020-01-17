/*
This file is run on every machine (server+client) and initializes different
variables.
*/

// Ordered ranks used to rank players
AS_ranks = [
	"PRIVATE", "CORPORAL", "SERGEANT", "LIEUTENANT", "CAPTAIN", "MAJOR", "COLONEL"
];
AS_rank_abbreviations = [
	"PRV", "CPL", "SGT", "LT", "CPT", "MAJ", "COL"
];

AS_traits = call DICT_fnc_create;
[AS_traits, "medic", call DICT_fnc_create] call DICT_fnc_set;
[AS_traits, "medic", "name", "Medic"] call DICT_fnc_set;
[AS_traits, "medic", "trait", "medic"] call DICT_fnc_set;
[AS_traits, "medic", "description", "Allows you to fully heal others"] call DICT_fnc_set;
[AS_traits, "medic", "cost", 200] call DICT_fnc_set;
[AS_traits, "uav_op", call DICT_fnc_create] call DICT_fnc_set;
[AS_traits, "uav_op", "name", "UAV Operator"] call DICT_fnc_set;
[AS_traits, "uav_op", "trait", "UAVHacker"] call DICT_fnc_set;
[AS_traits, "uav_op", "cost", 200] call DICT_fnc_set;
[AS_traits, "uav_op", "description", "Allows you to use UAVs"] call DICT_fnc_set;
[AS_traits, "engineer", call DICT_fnc_create] call DICT_fnc_set;
[AS_traits, "engineer", "name", "Engineer"] call DICT_fnc_set;
[AS_traits, "engineer", "trait", "engineer"] call DICT_fnc_set;
[AS_traits, "engineer", "cost", 200] call DICT_fnc_set;
[AS_traits, "engineer", "description", "Allows you to repair vehicles"] call DICT_fnc_set;
[AS_traits, "explosives", call DICT_fnc_create] call DICT_fnc_set;
[AS_traits, "explosives", "name", "Explosives Specialist"] call DICT_fnc_set;
[AS_traits, "explosives", "trait", "explosiveSpecialist"] call DICT_fnc_set;
[AS_traits, "explosives", "cost", 100] call DICT_fnc_set;
[AS_traits, "explosives", "description", "Allows you to disarm mines"] call DICT_fnc_set;


// UPSMON is used for all kinds of AI patrolling. We initialize it here
// so any client can spawn patrols.
call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";

// Defines lists of available items and properties used to select best items.
// todo: move this to a shared LOGIC object and initialize it once on the server.
// reasoning: this is expensive and should be made only by a single machine.
call compile preprocessFileLineNumbers "initItems.sqf";
call compile preprocessFileLineNumbers "templates\basicLists.sqf";

// Identifies mods.
hasRHS = false;
has3CB = false;
hasACE = false;
hasSFP = false;
hasFFP = false;

hasACEhearing = false;
hasACEMedical = false;
hasACEsplint = false;
if (!isNil "ace_common_settingFeedbackIcons") then {
	hasACE = true;
	if (isClass (configFile >> "CfgSounds" >> "ACE_EarRinging_Weak")) then {
		hasACEhearing = true;
	};
	if (isClass (ConfigFile >> "CfgSounds" >> "ACE_heartbeat_fast_3") and
        (ace_medical_level != 0)) then {
		hasACEMedical = true;
	};
	if ("adv_aceSplint_splint" in AS_allItems) then {
		hasACEsplint = true;
	};
	// Lists of items used by ACE medical system. These are used
	// below to define what factions use and what is unlocked
	AS_aceBasicMedical = [
		"ACE_fieldDressing", "ACE_bloodIV_250", "ACE_bloodIV_500",
		"ACE_bloodIV", "ACE_epinephrine", "ACE_morphine", "ACE_bodyBag"
	];

	AS_aceAdvMedical = [
		"ACE_salineIV_250", "ACE_salineIV_500", "ACE_salineIV",
		"ACE_plasmaIV_250", "ACE_plasmaIV_500", "ACE_plasmaIV",
		"ACE_packingBandage", "ACE_elasticBandage",
		"ACE_quikclot", "ACE_tourniquet", "ACE_atropine","ACE_adenosine",
		"ACE_personalAidKit", "ACE_surgicalKit"
	];
};

// todo: do not rely on AS_allWeapons to check for mods.
if ("rhs_weap_akms" in AS_allWeapons) then {
	hasRHS = true;
};

if ("UK3CB_M16A2" in AS_allWeapons) then {
	has3CB = true;
};

// todo: do not rely on AS_allWeapons to check for mods.
hasCUP = false;
if ("CUP_arifle_AKS74U" in AS_allWeapons) then {
	hasCUP = true;
};

//Swedish and finish packs
if ("sfp_ak4" in AS_allWeapons) then {
	hasSFP = true;
};

if ("ffp_rk62" in AS_allWeapons) then {
	hasFFP = true;
};

//TFAR detection and config.
hasTFAR = false;
if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
    hasTFAR = true;
	// see https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki/API:-Variables
	["TF_west_radio_code", "", true, "mission"] call CBA_settings_fnc_set;
	["TF_east_radio_code", "", true, "mission"] call CBA_settings_fnc_set;
	["TF_guer_radio_code", "", true, "mission"] call CBA_settings_fnc_set;
	["TF_same_sw_frequencies_for_side", true, true, "mission"] call CBA_settings_fnc_set;
};

// Initializes unlocked items.
unlockedItems = [
	"ItemMap",
	"ItemRadio",
	"ItemWatch",
	"ItemCompass",
	"FirstAidKit",
	"Medikit",
	"Toolkit"
];

//Probably unnecessary, fixed now bug where AAF radios are unlocked

if hasTFAR then {
	unlockedItems = unlockedItems - ["ItemRadio"];
	unlockedItems append ["TFAR_rf7800str", "TFAR_anprc152"];
};

if hasACE then {
	// Must be called after unlockedItems is defined
	call compile preprocessFileLineNumbers "initACE.sqf";
};

if isServer then {
    AS_server_config = [hasACE, hasRHS, hasCUP, hasTFAR];
	publicVariable "AS_server_config";
} else {
	waitUntil {not isNil "AS_server_config"};
	if not ([hasACE, hasRHS, hasCUP, hasTFAR] isEqualTo AS_server_config) then {
		// Not the same configuration. Disconnect
		["invalidConfiguration", false, false, false, false] call BIS_fnc_endMission;
	};
};

//Music files
//with Say3D these must be defined in description.ext

private _musicCfg = missionconfigFile >> "CfgSounds";
AS_MusicFiles = [];

for "_i" from 0 to ((count _musicCfg - 1)) do {
	private _class =  _musicCfg select _i;
	if (isClass _class) then {
		private _name = configName _class;
		if (isArray (_musicCfg >> _name >> "sound")) then {
			AS_MusicFiles pushback _name;
		};
	};
};

AS_MusicFiles = AS_MusicFiles - ["fire"];


AS_entities = createSimpleObject ["Static", [0, 0, 0]];

// fallback to the default template
private _dict = call compile preprocessFileLineNumbers "templates\CIV.sqf";
AS_entities setVariable ["CIV", _dict];
_dict = call compile preprocessFileLineNumbers "templates\AAF.sqf";
AS_entities setVariable ["AAF", _dict];
_dict = call compile preprocessFileLineNumbers "templates\CSAT.sqf";
AS_entities setVariable ["CSAT", _dict];
_dict = call compile preprocessFileLineNumbers "templates\NATO.sqf";
AS_entities setVariable ["NATO", _dict];
_dict = call compile preprocessFileLineNumbers "templates\FIA_WEST.sqf";
AS_entities setVariable ["FIA_WEST", _dict];
_dict = call compile preprocessFileLineNumbers "templates\FIA_EAST.sqf";
AS_entities setVariable ["FIA_EAST", _dict];

if hasRHS then {
	_dict = call compile preprocessFileLineNumbers "templates\AAF_RHS.sqf";
	AS_entities setVariable ["RHS_AAF", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\CSAT_RHS.sqf";
	AS_entities setVariable ["RHS_CSAT", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\NATO_RHS.sqf";
	AS_entities setVariable ["RHS_NATO_D", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\NATO_RHS_woodland.sqf";
	AS_entities setVariable ["RHS_NATO_WD", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\FIA_WEST_RHS.sqf";
	AS_entities setVariable ["RHS_FIA_WEST", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\FIA_EAST_RHS.sqf";
	AS_entities setVariable ["RHS_FIA_EAST", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\AAF_CHKDZ_RHS.sqf";
	AS_entities setVariable ["RHS_AAF_CHKDZ", _dict];
	if (hasSFP and {hasFFP}) then {
		_dict = call compile preprocessFileLineNumbers "templates\FIA_WEST_FFP.sqf";
		AS_entities setVariable ["RHS_FIA_WEST_FFP", _dict];
		_dict = call compile preprocessFileLineNumbers "templates\FIA_EAST_FFP.sqf";
		AS_entities setVariable ["RHS_FIA_EAST_FFP", _dict];
	};
	if has3CB then {
		_dict = call compile preprocessFileLineNumbers "templates\NATO_3CB_AFGHAN.sqf";
		AS_entities setVariable ["RHS_3CB_AFGHAN", _dict];
	};
};
if hasCUP then {
	_dict = call compile preprocessFileLineNumbers "templates\AAF_CUP.sqf";
	AS_entities setVariable ["CUP_AAF", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\CSAT_CUP.sqf";
	AS_entities setVariable ["CUP_CSAT", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\NATO_CUP.sqf";
	AS_entities setVariable ["CUP_NATO", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\FIA_WEST_CUP.sqf";
	AS_entities setVariable ["CUP_FIA_WEST", _dict];
	_dict = call compile preprocessFileLineNumbers "templates\FIA_EAST_CUP.sqf";
	AS_entities setVariable ["CUP_FIA_EAST", _dict];
};

call compile preprocessFileLineNumbers "initialization\checkFactionsAttributes.sqf"
