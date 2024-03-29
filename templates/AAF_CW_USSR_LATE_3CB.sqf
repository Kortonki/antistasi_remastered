private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str east] call DICT_fnc_set;
[_dict, "roles", ["state", "foreign"]] call DICT_fnc_set;
[_dict, "name", "Union of Soviet Socialist Republics"] call DICT_fnc_set;
[_dict, "name_info", "Late, Woodland Camo, 3CB"] call DICT_fnc_set;
[_dict, "shortname", "USSR"] call DICT_fnc_set;
[_dict, "flag", "Flag_CW_SOV"] call DICT_fnc_set;
[_dict, "flag_marker", "UK3CB_Marker_CW_SOV"] call DICT_fnc_set;
[_dict, "box", "I_supplyCrate_F"] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "UK3CB_CW_SOV_O_LATE_OFF"] call DICT_fnc_set;
[_dict, "traitor", "UK3CB_CCM_B_RIF_LITE"] call DICT_fnc_set;
[_dict, "gunner", "UK3CB_CW_SOV_O_LATE_RIF_2"] call DICT_fnc_set;
[_dict, "crew", "UK3CB_CW_SOV_O_LATE_CREW"] call DICT_fnc_set;
[_dict, "pilot", "UK3CB_CW_SOV_O_LATE_HELI_PILOT"] call DICT_fnc_set;

// To modders: equipment in AAF boxes comes from the set of all equipment of all units on the groups of this cfg
[_dict, "cfgGroups", configfile >> "CfgGroups" >> "East" >> "UK3CB_CW_SOV_O_LATE" >> "Infantry"] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", [
["RHS_DShkM_Gun_Bag", "RHS_DShkM_TripodHigh_Bag"],
["RHS_SPG9_Tripod_Bag", "RHS_SPG9_Gun_Bag"],
["RHS_Podnos_Gun_Bag", "RHS_Podnos_Bipod_Bag"]
]] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;
[_dict, "additionalBinoculars", []] call DICT_fnc_set;

// These groups are used in different spawns (locations, patrols, missions)
[_dict, "patrols", ["UK3CB_CW_SOV_O_LATE_AR_Sentry", "UK3CB_CW_SOV_O_LATE_LAT_Sentry", "UK3CB_CW_SOV_O_LATE_MG_Sentry", "UK3CB_CW_SOV_O_LATE_MK_Sentry", "UK3CB_CW_SOV_O_LATE_RIF_Sentry", "UK3CB_CW_SOV_O_LATE_UGL_Sentry"]] call DICT_fnc_set;
[_dict, "teams", ["UK3CB_CW_SOV_O_LATE_AR_FireTeam", "UK3CB_CW_SOV_O_LATE_AT_FireTeam", "UK3CB_CW_SOV_O_LATE_MG_FireTeam", "UK3CB_CW_SOV_O_LATE_RIF_FireTeam", "UK3CB_CW_SOV_O_LATE_UGL_FireTeam"]] call DICT_fnc_set;
[_dict, "squads", ["UK3CB_CW_SOV_O_LATE_AR_Squad", "UK3CB_CW_SOV_O_LATE_AT_Squad", "UK3CB_CW_SOV_O_LATE_MG_Squad", "UK3CB_CW_SOV_O_LATE_MK_Squad", "UK3CB_CW_SOV_O_LATE_RIF_Squad"]] call DICT_fnc_set;
[_dict, "teamsAA", ["UK3CB_CW_SOV_O_LATE_AA_FireTeam", "UK3CB_CW_SOV_O_LATE_AA_Squad"]] call DICT_fnc_set;
[_dict, "recon_squad", configfile >> "CfgGroups" >> "East" >> "UK3CB_CW_SOV_O_LATE" >> "SpecOps" >> "UK3CB_CW_SOV_O_LATE_Recon_SpecSquad"] call DICT_fnc_set;
[_dict, "recon_team", configfile >> "CfgGroups" >> "East" >> "UK3CB_CW_SOV_O_LATE" >> "SpecOps" >> "UK3CB_CW_SOV_O_LATE_Recon_SpecTeam"] call DICT_fnc_set;

// To modders: overwrite this in the template to change the vehicles AAF uses.
// Rules:
// 1. vehicle must exist.
// 2. each vehicle must belong to only one category.
[_dict, "planes", ["UK3CB_CW_SOV_O_LATE_MIG29S", "UK3CB_CW_SOV_O_LATE_MIG29SM", "UK3CB_CW_SOV_O_LATE_Su25SM", "UK3CB_CW_SOV_O_LATE_Su25SM_CAS", "UK3CB_CW_SOV_O_LATE_Su25SM_Cluster", "UK3CB_CW_SOV_O_LATE_Su25SM_KH29"]] call DICT_fnc_set;
[_dict, "helis_attack", ["UK3CB_CW_SOV_O_LATE_Mi_24V"]] call DICT_fnc_set;
[_dict, "helis_armed", ["UK3CB_CW_SOV_O_LATE_Mi8AMTSh", "UK3CB_CW_SOV_O_LATE_Mi_24P"]] call DICT_fnc_set;
[_dict, "helis_transport", ["UK3CB_CW_SOV_O_LATE_Mi8", "UK3CB_CW_SOV_O_LATE_Mi8AMT"]] call DICT_fnc_set;

[_dict, "tanks", ["UK3CB_CW_SOV_O_LATE_T72B",
"UK3CB_CW_SOV_O_LATE_T72BA",
"UK3CB_CW_SOV_O_LATE_T72BE",
"UK3CB_CW_SOV_O_LATE_T72BB",
"UK3CB_CW_SOV_O_LATE_T72BC",
"UK3CB_CW_SOV_O_LATE_T72BD"
]] call DICT_fnc_set;
[_dict, "boats", ["I_G_Boat_Transport_01_F"]] call DICT_fnc_set;
[_dict, "cars_transport", ["UK3CB_CW_SOV_O_LATE_UAZ_Closed",
"UK3CB_CW_SOV_O_LATE_UAZ_Open",
"UK3CB_CW_SOV_O_LATE_BRDM2_UM"]] call DICT_fnc_set;
[_dict, "cars_armed", ["UK3CB_CW_SOV_O_LATE_BRDM2",
"UK3CB_CW_SOV_O_LATE_BRDM2_ATGM",
"UK3CB_CW_SOV_O_LATE_BRDM2_HQ",
"UK3CB_CW_SOV_O_LATE_UAZ_AGS30",
"UK3CB_CW_SOV_O_LATE_UAZ_MG",
"UK3CB_CW_SOV_O_LATE_UAZ_SPG9"
]] call DICT_fnc_set;
[_dict, "apcs", ["UK3CB_CW_SOV_O_LATE_MTLB_PKT",
"UK3CB_CW_SOV_O_LATE_BTR80",
"UK3CB_CW_SOV_O_LATE_BTR80a",
"UK3CB_CW_SOV_O_LATE_BMP2",
"UK3CB_CW_SOV_O_LATE_BMP2K"
]] call DICT_fnc_set;
[_dict, "trucks", ["UK3CB_CW_SOV_O_LATE_Ural",
"UK3CB_CW_SOV_O_LATE_Ural_Open",
"rhs_kamaz5350_msv",
"rhs_kamaz5350_open_msv"]] call DICT_fnc_set;
//These are used for AAF convoy missions
[_dict, "vans", [
"C_IDAP_Truck_02_F"
]] call DICT_fnc_set;

[_dict, "other_vehicles", [
"UK3CB_CW_SOV_O_LATE_Ural_Ammo",
"UK3CB_CW_SOV_O_LATE_Ural_Recovery",
"UK3CB_CW_SOV_O_LATE_Ural_Repair",
"UK3CB_CW_SOV_O_LATE_Ural_Fuel"
]] call DICT_fnc_set;

[_dict, "self_aa", ["UK3CB_CW_SOV_O_LATE_ZsuTank"]] call DICT_fnc_set;


// used in artillery mission
[_dict, "artillery1", ["UK3CB_CW_SOV_O_LATE_2S1", "UK3CB_CW_SOV_O_LATE_2S3"]] call DICT_fnc_set;
[_dict, "artillery2", ["UK3CB_CW_SOV_O_LATE_BM21"]] call DICT_fnc_set;

[_dict, "truck_ammo", "UK3CB_CW_SOV_O_LATE_Ural_Ammo"] call DICT_fnc_set;
[_dict, "truck_repair", "UK3CB_CW_SOV_O_LATE_Ural_Repair"] call DICT_fnc_set;
[_dict, "truck_fuel", "UK3CB_CW_SOV_O_LATE_Ural_Fuel"] call DICT_fnc_set;

[_dict, "uavs_small", ["I_UAV_01_F"]] call DICT_fnc_set;
[_dict, "uavs_attack", ["I_UAV_02_F"]] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["UK3CB_CW_SOV_O_Late_ZU23", "UK3CB_CW_SOV_O_Late_Igla_AA_pod"]] call DICT_fnc_set;
[_dict, "static_at", ["UK3CB_CW_SOV_O_Late_SPG9"]] call DICT_fnc_set;
[_dict, "static_mg", ["UK3CB_CW_SOV_O_Late_DSHKM"]] call DICT_fnc_set;
[_dict, "static_mg_low", ["UK3CB_CW_SOV_O_Late_DSHkM_Mini_TriPod", "UK3CB_CW_SOV_O_Late_NSV"]] call DICT_fnc_set;
[_dict, "static_mortar", ["UK3CB_CW_SOV_O_Late_2b14_82mm"]] call DICT_fnc_set;

// These have to be CfgVehicles mines that explode automatically (minefields)
[_dict, "ap_mines", ["rhs_mine_pmn2"]] call DICT_fnc_set;
[_dict, "at_mines", ["rhs_mine_tm62m"]] call DICT_fnc_set;
// These have to be CfgVehicles
[_dict, "explosives", ["SatchelCharge_F","DemoCharge_F","Claymore_F"]] call DICT_fnc_set;

if hasTFAR then {
    [_dict, "tfar_lr_radio", "TFAR_anprc155"] call DICT_fnc_set;
    [_dict, "tfar_radio", "TFAR_anprc148jem"] call DICT_fnc_set;
};

_dict
