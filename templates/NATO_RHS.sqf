private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "roles", ["state", "foreign"]] call DICT_fnc_set;
[_dict, "name", "USMC Desert Camo (RHS)"] call DICT_fnc_set;
[_dict, "flag", "Flag_US_F"] call DICT_fnc_set;
[_dict, "flag_marker", "rhs_flag_USA"] call DICT_fnc_set;

[_dict, "helis_transport", ["RHS_MELB_MH6M", "RHS_UH1Y_UNARMED_d", "RHS_UH1Y_d", "rhsusf_CH53E_USMC_D"]] call DICT_fnc_set;
[_dict, "helis_attack", ["RHS_AH1Z"]] call DICT_fnc_set;
[_dict, "helis_armed", ["RHS_MELB_AH6M","RHS_UH1Y_d"]] call DICT_fnc_set;
[_dict, "planes", ["RHS_A10","rhsusf_f22"]] call DICT_fnc_set;

[_dict, "uavs_small", ["B_UAV_01_F"]] call DICT_fnc_set;
[_dict, "uavs_attack", ["B_UAV_02_F"]] call DICT_fnc_set;

[_dict, "tanks", ["rhsusf_m1a1fep_d"]] call DICT_fnc_set;
[_dict, "boats", ["B_Boat_Armed_01_minigun_F"]] call DICT_fnc_set;

// used in roadblock mission
[_dict, "trucks", ["rhsusf_M1083A1P2_D_fmtv_usarmy","rhsusf_M1083A1P2_B_D_fmtv_usarmy","rhsusf_M1083A1P2_D_flatbed_fmtv_usarmy","rhsusf_M1083A1P2_B_D_flatbed_fmtv_usarmy","rhsusf_M1078A1P2_D_fmtv_usarmy","rhsusf_M1078A1P2_D_flatbed_fmtv_usarmy"]] call DICT_fnc_set;
[_dict, "apcs", ["rhsusf_m113d_usarmy_unarmed","rhsusf_m113d_usarmy","rhsusf_m113d_usarmy_M240","rhsusf_m113d_usarmy_MK19","RHS_M2A2","RHS_M2A2_BUSKI","RHS_M2A3","RHS_M2A3_BUSKI","RHS_M2A3_BUSKIII"]] call DICT_fnc_set;

// used in traitor mission
[_dict, "cars_transport", ["rhsusf_m1025_d_s","rhsusf_m1043_d_s","rhsusf_m998_d_s_2dr_halftop",
"rhsusf_m998_d_s_2dr",
"rhsusf_m998_d_s_2dr_fulltop",
"rhsusf_m998_d_s_4dr_halftop",
"rhsusf_m998_d_s_4dr",
"rhsusf_m998_d_s_4dr_fulltop"]] call DICT_fnc_set;
[_dict, "cars_armed", ["rhsusf_m1025_d_s_m2",
"rhsusf_m1025_d_s_Mk19",
"rhsusf_m1025_d_s_m2",
"rhsusf_m1043_d_s_mk19",
"rhsusf_m1043_d_s_m2",
"rhsusf_m1045_d_s"
]] call DICT_fnc_set;

// used in artillery mission
[_dict, "artillery1", ["RHS_M119_D"]] call DICT_fnc_set;
[_dict, "artillery2", ["rhsusf_m109d_usarmy"]] call DICT_fnc_set;

[_dict, "truck_ammo", "rhsusf_M977A4_AMMO_usarmy_d"] call DICT_fnc_set;
[_dict, "truck_repair", "rhsusf_M977A4_REPAIR_usarmy_d"] call DICT_fnc_set;
[_dict, "truck_fuel", "rhsusf_M978A4_usarmy_d"] call DICT_fnc_set;

// used in spawns (base and airfield)
[_dict, "other_vehicles", [
"rhsusf_m113d_usarmy_supply","rhsusf_M977A4_REPAIR_usarmy_d","rhsusf_m113d_usarmy_medical","rhsusf_M1085A1P2_B_D_Medical_fmtv_usarmy","rhsusf_M978A4_usarmy_d"
]] call DICT_fnc_set;

[_dict, "self_aa", ["RHS_M2A3","RHS_M2A3_BUSKI","RHS_M2A3_BUSKIII"]] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "rhsusf_usmc_marpat_d_officer"] call DICT_fnc_set;
[_dict, "traitor", "rhsusf_usmc_marpat_d_officer"] call DICT_fnc_set;
[_dict, "gunner", "rhsusf_usmc_marpat_d_rifleman_light"] call DICT_fnc_set;
[_dict, "crew", "rhsusf_usmc_marpat_d_crewman"] call DICT_fnc_set;
[_dict, "pilot", "rhsusf_airforce_pilot"] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["RHS_Stinger_AA_pod_USMC_D"]] call DICT_fnc_set;
[_dict, "static_at", ["RHS_TOW_TriPod_USMC_D"]] call DICT_fnc_set;
[_dict, "static_mg", ["RHS_M2StaticMG_USMC_D"]] call DICT_fnc_set;
[_dict, "static_mg_low", ["RHS_M2StaticMG_MiniTripod_USMC_D"]] call DICT_fnc_set;
[_dict, "static_mortar", ["RHS_M252_USMC_D"]] call DICT_fnc_set;

[_dict, "cfgGroups", (configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_d" >> "rhs_group_nato_usmc_d_infantry")] call DICT_fnc_set;
[_dict, "squads", ["rhs_group_nato_usmc_d_infantry_squad","rhs_group_nato_usmc_d_infantry_squad_sniper","rhs_group_nato_usmc_d_infantry_weaponsquad"]] call DICT_fnc_set;
[_dict, "teams", ["rhs_group_nato_usmc_d_infantry_team","rhs_group_nato_usmc_d_infantry_team_heavy_AT","rhs_group_nato_usmc_d_infantry_team_MG","rhs_group_nato_usmc_d_infantry_team_support"]] call DICT_fnc_set;
[_dict, "teamsAA", ["rhs_group_nato_usmc_d_infantry_team_AA"]] call DICT_fnc_set;
[_dict, "patrols", ["rhs_group_nato_usmc_d_infantry_team"]] call DICT_fnc_set;
[_dict, "recon_squad", configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_d" >> "rhs_group_nato_usmc_recon_d_infantry" >> "rhs_group_nato_usmc_recon_d_infantry_team_lite"] call DICT_fnc_set;
[_dict, "recon_team", configfile >> "CfgGroups" >> "West" >> "rhs_faction_usmc_d" >> "rhs_group_nato_usmc_recon_d_infantry" >> "rhs_group_nato_usmc_recon_d_infantry_team_lite"] call DICT_fnc_set;

// These have to be CfgVehicles mines that explode automatically (minefields)
[_dict, "ap_mines", ["rhs_mine_pmn2"]] call DICT_fnc_set;
[_dict, "at_mines", ["rhs_mine_tm62m"]] call DICT_fnc_set;
// These have to be CfgVehicles
[_dict, "explosives", ["SatchelCharge_F","DemoCharge_F","ClaymoreDirectional_F"]] call DICT_fnc_set;

[_dict, "box", "Box_NATO_Equip_F"] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", ["rhs_weap_ak105","rhs_weap_ak104"]] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;

if hasTFAR then {
    [_dict, "tfar_lr_radio", "TFAR_rt1523g_rhs"] call DICT_fnc_set;
    [_dict, "tfar_radio", "TFAR_anprc152"] call DICT_fnc_set;
};

_dict
