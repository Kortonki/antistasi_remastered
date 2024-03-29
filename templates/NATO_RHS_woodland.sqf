private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "roles", ["state", "foreign"]] call DICT_fnc_set;
[_dict, "name", "United States Marine Corps"] call DICT_fnc_set;
[_dict, "name_info", "Woodland Camo RHS"] call DICT_fnc_set;
[_dict, "shortname", "USMC"] call DICT_fnc_set;
[_dict, "flag", "Flag_US_F"] call DICT_fnc_set;
[_dict, "flag_marker", "rhs_flag_USA"] call DICT_fnc_set;

[_dict, "helis_transport", ["RHS_MELB_MH6M", "RHS_UH1Y_UNARMED", "RHS_UH1Y", "rhsusf_CH53E_USMC"]] call DICT_fnc_set;
[_dict, "helis_attack", ["RHS_AH1Z_wd"]] call DICT_fnc_set;
[_dict, "helis_armed", ["RHS_MELB_AH6M","RHS_UH1Y"]] call DICT_fnc_set;
[_dict, "planes", ["RHS_A10","rhsusf_f22"]] call DICT_fnc_set;

[_dict, "uavs_small", ["B_UAV_01_F"]] call DICT_fnc_set;
[_dict, "uavs_attack", ["B_UAV_02_F"]] call DICT_fnc_set;

[_dict, "tanks", ["rhsusf_m1a1fep_wd"]] call DICT_fnc_set;
[_dict, "boats", ["B_Boat_Armed_01_minigun_F"]] call DICT_fnc_set;

// used in roadblock mission
[_dict, "trucks", ["rhsusf_M1083A1P2_WD_fmtv_usarmy","rhsusf_M1083A1P2_B_WD_fmtv_usarmy","rhsusf_M1078A1P2_WD_fmtv_usarmy"]] call DICT_fnc_set;
//These are used for AAF convoy missions
[_dict, "vans", [
"C_IDAP_Truck_02_F"
]] call DICT_fnc_set;
[_dict, "apcs", ["rhsusf_m113_usarmy_unarmed","rhsusf_m113_usarmy","rhsusf_m113_usarmy_M240","rhsusf_m113_usarmy_MK19","RHS_M2A2_wd","RHS_M2A2_BUSKI_WD"]] call DICT_fnc_set;

// used in traitor mission
[_dict, "cars_transport", ["rhsusf_m1025_w_s","rhsusf_m1043_w_s","rhsusf_m998_w_s_2dr_halftop",
"rhsusf_m998_w_s_2dr",
"rhsusf_m998_w_s_2dr_fulltop",
"rhsusf_m998_w_s_4dr_halftop",
"rhsusf_m998_w_s_4dr",
"rhsusf_m998_w_s_4dr_fulltop"]] call DICT_fnc_set;
[_dict, "cars_armed", ["rhsusf_m1025_w_s_m2",
"rhsusf_m1025_w_s_Mk19",
"rhsusf_m1025_w_s_m2",
"rhsusf_m1045_w_s",
"rhsusf_m1043_w_s_mk19",
"rhsusf_m1043_w_s_m2"]] call DICT_fnc_set;

// used in artillery mission
[_dict, "artillery1", ["RHS_M119_WD"]] call DICT_fnc_set;
[_dict, "artillery2", ["rhsusf_m109_usarmy"]] call DICT_fnc_set;

[_dict, "truck_ammo", "rhsusf_M977A4_AMMO_usarmy_wd"] call DICT_fnc_set;
[_dict, "truck_repair", "rhsusf_M977A4_REPAIR_usarmy_wd"] call DICT_fnc_set;
[_dict, "truck_fuel", "rhsusf_M978A4_usarmy_wd"] call DICT_fnc_set;

// used in spawns (base and airfield)
[_dict, "other_vehicles", [
"rhsusf_m113_usarmy_supply","rhsusf_M977A4_REPAIR_usarmy_wd","rhsusf_m113_usarmy_medical","rhsusf_M1085A1P2_B_WD_Medical_fmtv_usarmy","rhsusf_M978A4_usarmy_wd","rhsusf_M977A4_AMMO_usarmy_wd"
]] call DICT_fnc_set;

[_dict, "self_aa", ["RHS_M2A3_wd","RHS_M2A3_BUSKI_wd","RHS_M2A3_BUSKIII_wd"]] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "rhsusf_usmc_marpat_wd_officer"] call DICT_fnc_set;
[_dict, "traitor", "rhsusf_usmc_marpat_wd_officer"] call DICT_fnc_set;
[_dict, "gunner", "rhsusf_usmc_marpat_wd_rifleman_light"] call DICT_fnc_set;
[_dict, "crew", "rhsusf_usmc_marpat_wd_crewman"] call DICT_fnc_set;
[_dict, "pilot", "rhsusf_airforce_pilot"] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["RHS_Stinger_AA_pod_USMC_WD"]] call DICT_fnc_set;
[_dict, "static_at", ["RHS_TOW_TriPod_USMC_WD"]] call DICT_fnc_set;
[_dict, "static_mg", ["RHS_M2StaticMG_USMC_WD"]] call DICT_fnc_set;
[_dict, "static_mg_low", ["RHS_M2StaticMG_MiniTripod_USMC_WD"]] call DICT_fnc_set;
[_dict, "static_mortar", ["RHS_M252_USMC_WD"]] call DICT_fnc_set;

//
//Jatka tästä
//

[_dict, "cfgGroups", (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_wd_infantry")] call DICT_fnc_set;
[_dict, "squads", ["rhs_group_nato_usmc_wd_infantry_squad","rhs_group_nato_usmc_wd_infantry_squad_sniper","rhs_group_nato_usmc_wd_infantry_weaponsquad"]] call DICT_fnc_set;
[_dict, "teams", ["rhs_group_nato_usmc_wd_infantry_team","rhs_group_nato_usmc_wd_infantry_team_heavy_AT","rhs_group_nato_usmc_wd_infantry_team_MG","rhs_group_nato_usmc_wd_infantry_team_support"]] call DICT_fnc_set;
[_dict, "teamsAA", ["rhs_group_nato_usmc_wd_infantry_team_AA"]] call DICT_fnc_set;
[_dict, "patrols", ["rhs_group_nato_usmc_wd_infantry_team"]] call DICT_fnc_set;
[_dict, "recon_squad", configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_recon_wd_infantry" >> "rhs_group_nato_usmc_recon_wd_infantry_team_lite"] call DICT_fnc_set;
[_dict, "recon_team", configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_wd" >> "rhs_group_nato_usmc_recon_wd_infantry" >> "rhs_group_nato_usmc_recon_wd_infantry_team_lite"] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;
[_dict, "additionalBinoculars", []] call DICT_fnc_set;

// These have to be CfgVehicles mines that explode automatically (minefields)
[_dict, "ap_mines", ["rhsusf_mine_m14"]] call DICT_fnc_set;
[_dict, "at_mines", ["rhsusf_mine_M19"]] call DICT_fnc_set;
// These have to be CfgVehicles
[_dict, "explosives", ["SatchelCharge_F","DemoCharge_F","Claymore_F"]] call DICT_fnc_set;

[_dict, "box", "B_supplyCrate_F"] call DICT_fnc_set;

if hasTFAR then {
    [_dict, "tfar_lr_radio", "TFAR_rt1523g_rhs"] call DICT_fnc_set;
    [_dict, "tfar_radio", "TFAR_anprc152"] call DICT_fnc_set;
};


_dict
