private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "roles", ["state", "foreign"]] call DICT_fnc_set;
[_dict, "name", "Afghan Army (3CB)"] call DICT_fnc_set;
[_dict, "shortname", "Afghans"] call DICT_fnc_set;
[_dict, "flag", "Flag_AFG_13"] call DICT_fnc_set;
[_dict, "box", "I_supplyCrate_F"] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "UK3CB_ANA_B_OFF"] call DICT_fnc_set;
[_dict, "traitor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "gunner", "UK3CB_ANA_B_RIF_1"] call DICT_fnc_set;
[_dict, "crew", "UK3CB_ANA_B_CREW"] call DICT_fnc_set;
[_dict, "pilot", "UK3CB_ANA_B_HELI_PILOT"] call DICT_fnc_set;

// To modders: equipment in AAF boxes comes from the set of all equipment of all units on the groups of this cfg
[_dict, "cfgGroups", configfile >> "CfgGroups" >> "West" >> "UK3CB_ANA_B" >> "Infantry"] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;

// These groups are used in different spawns (locations, patrols, missions)
[_dict, "patrols", ["UK3CB_TKM_B_AR_Sentry","UK3CB_TKM_B_AT_Sentry","UK3CB_TKM_B_MG_Sentry","UK3CB_TKM_B_MK_Sentry","UK3CB_TKM_B_UGL_Sentry"]] call DICT_fnc_set;
[_dict, "teams", ["UK3CB_ANA_B_AR_FireTeam","UK3CB_ANA_B_AT_FireTeam","UK3CB_ANA_B_MG_FireTeam","UK3CB_ANA_B_RIF_FireTeam","UK3CB_ANA_B_UGL_FireTeam"]] call DICT_fnc_set;
[_dict, "squads", ["UK3CB_ANA_B_AR_Squad","UK3CB_ANA_B_AT_Squad","UK3CB_ANA_B_MG_Squad","UK3CB_ANA_B_RIF_Squad","UK3CB_ANA_B_MK_Squad"]] call DICT_fnc_set;
[_dict, "teamsAA", ["UK3CB_ANA_B_AA_FireTeam","UK3CB_ANA_B_AA_Squad"]] call DICT_fnc_set;

// To modders: overwrite this in the template to change the vehicles AAF uses.
// Rules:
// 1. vehicle must exist.
// 2. each vehicle must belong to only one category.
[_dict, "planes", ["UK3CB_ANA_B_L39_CAS"]] call DICT_fnc_set;
[_dict, "helis_armed", ["UK3CB_ANA_B_Mi_24V","UK3CB_ANA_B_Mi_24P","UK3CB_ANA_B_Mi8AMTSh","UK3CB_ANA_B_AH9"]] call DICT_fnc_set;
[_dict, "helis_transport", ["UK3CB_ANA_B_Benches_MH9","UK3CB_ANA_B_Mi8","UK3CB_ANA_B_Mi8AMT","UK3CB_ANA_B_UH1H_M240","UK3CB_ANA_B_UH1H","UK3CB_ANA_B_B_UH60M","UK3CB_ANA_B_B_UH60M2"]] call DICT_fnc_set;
[_dict, "tanks", ["UK3CB_ANA_B_T55","UK3CB_ANA_B_T72A","UK3CB_ANA_B_T72BM","UK3CB_ANA_B_T72B"]] call DICT_fnc_set;
[_dict, "boats", ["B_Boat_Armed_01_minigun_F"]] call DICT_fnc_set;
[_dict, "cars_transport", ["UK3CB_ANA_B_Offroad","UK3CB_ANA_B_Hilux_Open","UK3CB_ANA_B_Hilux_Closed","UK3CB_ANA_B_M998_2DR","UK3CB_ANA_B_M1025"]] call DICT_fnc_set;
[_dict, "cars_armed", ["UK3CB_ANA_B_M1025","UK3CB_ANA_B_Dshkm","UK3CB_ANA_B_Pkm","UK3CB_ANA_B_Spg9","UK3CB_ANA_B_Zu23","UK3CB_ANA_B_M1025_MK19","UK3CB_ANA_B_M1025_M2","UK3CB_ANA_B_MaxxPro_M2","UK3CB_ANA_B_MaxxPro_MK19","UK3CB_ANA_B_Offroad_M2"]] call DICT_fnc_set;
[_dict, "apcs", ["UK3CB_ANA_B_BMP1","UK3CB_ANA_B_BMP2","UK3CB_ANA_B_BMP2K","UK3CB_ANA_B_M1117","UK3CB_ANA_B_M113_M2","UK3CB_ANA_B_M113_M240","UK3CB_ANA_B_M113_MK19"]] call DICT_fnc_set;
[_dict, "trucks", ["UK3CB_ANA_B_Ural","UK3CB_ANA_B_Ural_Open"]] call DICT_fnc_set;

[_dict, "other_vehicles", [
"UK3CB_ANA_B_Ural_Ammo", "UK3CB_ANA_B_Ural_Fuel", "UK3CB_ANA_B_M113_AMB", "UK3CB_ANA_B_Ural_Repair"
]] call DICT_fnc_set;


// used in artillery mission
[_dict, "artillery1", ["UK3CB_ANA_B_D30"]] call DICT_fnc_set;
[_dict, "artillery2", ["UK3CB_ANA_B_BM21"]] call DICT_fnc_set;

[_dict, "truck_ammo", "UK3CB_ANA_B_Ural_Ammo"] call DICT_fnc_set;
[_dict, "truck_repair", "UK3CB_ANA_B_Ural_Repair"] call DICT_fnc_set;
[_dict, "truck_fuel", "UK3CB_ANA_B_Ural_Fuel"] call DICT_fnc_set;

[_dict, "uavs_small", ["B_UAV_01_F"]] call DICT_fnc_set;
[_dict, "uavs_attack", ["B_UAV_02_F"]] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["UK3CB_TKA_B_ZU23"]] call DICT_fnc_set;
[_dict, "static_at", ["UK3CB_TKA_B_SPG9"]] call DICT_fnc_set;
[_dict, "static_mg", ["UK3CB_TKA_B_KORD_high"]] call DICT_fnc_set;
[_dict, "static_mg_low", ["UK3CB_TKA_B_KORD"]] call DICT_fnc_set;
[_dict, "static_mortar", ["UK3CB_TKA_B_2b14_82mm"]] call DICT_fnc_set;

// These have to be CfgVehicles mines that explode automatically (minefields)
[_dict, "ap_mines", ["APERSMine_Range_Mag"]] call DICT_fnc_set;
[_dict, "at_mines", ["ATMine_Range_Mag"]] call DICT_fnc_set;
// These have to be CfgVehicles
[_dict, "explosives", ["SatchelCharge_F","DemoCharge_F","Claymore_F"]] call DICT_fnc_set;

if hasTFAR then {
    [_dict, "tfar_lr_radio", "TFAR_rt1523g_big_bwmod"] call DICT_fnc_set;
    [_dict, "tfar_radio", "TFAR_anprc152"] call DICT_fnc_set;
};

_dict
