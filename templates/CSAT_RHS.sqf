private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str east] call DICT_fnc_set;
[_dict, "roles", ["state", "foreign"]] call DICT_fnc_set;
[_dict, "name", "VMF (RHS)"] call DICT_fnc_set;
[_dict, "flag", "rhs_Flag_vmf_F"] call DICT_fnc_set;
[_dict, "flag_marker", "rhs_flag_Russia"] call DICT_fnc_set;

[_dict, "helis_transport", ["rhs_ka60_c", "RHS_Mi8AMT_vvsc", "RHS_Mi8mt_vvsc", "RHS_Mi8mt_Cargo_vvsc"]] call DICT_fnc_set;
[_dict, "helis_attack", ["RHS_Ka52_vvsc", "rhs_mi28n_vvsc"]] call DICT_fnc_set;
[_dict, "helis_armed", ["RHS_Mi24P_vvsc", "RHS_Mi24V_vvsc", "RHS_Mi24Vt_vvsc", "RHS_Mi8AMTSh_vvsc", "RHS_Mi8MTV3_vvsc", "RHS_Mi8mtv3_Cargo_vvsc", "RHS_Mi8MTV3_heavy_vvsc"]] call DICT_fnc_set;

[_dict, "planes", ["RHS_Su25SM_vvs", "RHS_T50_vvs_generic", "rhs_mig29sm_vvs", "rhs_mig29s_vvs"]] call DICT_fnc_set;

[_dict, "uavs_small", ["rhs_pchela1t_vvs"]] call DICT_fnc_set;
[_dict, "uavs_attack", []] call DICT_fnc_set;

[_dict, "tanks", ["rhs_t72bd_tv", "rhs_t80um", "rhs_t90a_tv"]] call DICT_fnc_set;
[_dict, "boats", ["O_Boat_Armed_01_hmg_F"]] call DICT_fnc_set;

// used in roadblock mission
[_dict, "trucks", ["rhs_zil131_open_vmf","rhs_zil131_vmf","RHS_Ural_Open_VMF_01","RHS_Ural_VMF_01","rhs_gaz66_vmf","rhs_gaz66o_vmf","rhs_kamaz5350_vmf","rhs_kamaz5350_open_vmf"]] call DICT_fnc_set;
[_dict, "apcs", ["rhs_prp3_vmf","rhs_brm1k_vmf","rhs_bmp2k_vmf","rhs_bmp2d_vmf","rhs_bmp2_vmf","rhs_bmp2e_vmf","rhs_bmp1p_vmf","rhs_bmp1k_vmf","rhs_bmp1d_vmf","rhs_bmp1_vmf","rhs_btr60_vmf", "rhs_btr70_vmf","rhs_btr80_vmf","rhs_btr80a_vmf"]] call DICT_fnc_set;

// used in traitor mission
[_dict, "cars_transport", ["rhs_tigr_vmf", "rhs_tigr_3cammo_vmf", "rhs_uaz_vmf", "rhs_tigr_m_vmf", "rhs_tigr_m_3cammo_vmf", "rhs_uaz_open_vmf", "rhsgref_BRDM2UM_vmf"]] call DICT_fnc_set;
[_dict, "cars_armed", ["rhs_tigr_sts_vmf", "rhs_tigr_sts_3cammo_vmf", "rhsgref_BRDM2_vmf", "rhsgref_BRDM2_HQ_vmf", "rhsgref_BRDM2_ATGM_vmf"]] call DICT_fnc_set;

// used in artillery mission
[_dict, "artillery1", ["rhs_D30_vmf"]] call DICT_fnc_set;
[_dict, "artillery2", ["rhs_2s3_tv"]] call DICT_fnc_set;

[_dict, "truck_ammo", "rhs_gaz66_ammo_vmf"] call DICT_fnc_set;
[_dict, "truck_repair", "rhs_ural_repair_vmf_01"] call DICT_fnc_set;

// used in spawns (base and airfield)
[_dict, "other_vehicles", [
"rhs_gaz66_ammo_vmf", "rhs_ural_fuel_vmf_01", "rhs_gaz66_ap2_vmf", "rhs_ural_repair_vmf_01"
]] call DICT_fnc_set;

[_dict, "self_aa", "rhs_zsu234_aa"] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "rhs_vmf_recon_officer"] call DICT_fnc_set;
[_dict, "traitor", "rhs_vmf_recon_officer_armored"] call DICT_fnc_set;
[_dict, "gunner", "rhs_vmf_recon_rifleman_asval"] call DICT_fnc_set;
[_dict, "crew", "rhs_vmf_recon_rifleman_asval"] call DICT_fnc_set;
[_dict, "pilot", "rhs_pilot_combat_heli"] call DICT_fnc_set;

[_dict, "static_aa", "rhs_Igla_AA_pod_vmf"] call DICT_fnc_set;
[_dict, "static_at", "rhs_Metis_9k115_2_vmf"] call DICT_fnc_set;
[_dict, "static_mg", "rhs_KORD_high_VMF"] call DICT_fnc_set;
[_dict, "static_mg_low", "rhs_KORD_VMF"] call DICT_fnc_set;
[_dict, "static_mortar", "rhs_2b14_82mm_vmf"] call DICT_fnc_set;

[_dict, "cfgGroups", configfile >> "CfgGroups" >> "East" >> "rhs_faction_vmf" >> "rhs_group_rus_vmf_infantry"] call DICT_fnc_set;
[_dict, "squads", ["rhs_group_rus_vmf_infantry_squad_sniper", "rhs_group_rus_vmf_infantry_squad_mg_sniper", "rhs_group_rus_vmf_infantry_squad_2mg", "rhs_group_rus_vmf_infantry_squad"]] call DICT_fnc_set;
[_dict, "teams", ["rhs_group_rus_vmf_infantry_section_mg", "rhs_group_rus_vmf_infantry_section_marksman", "rhs_group_rus_vmf_infantry_section_AT", "rhs_group_rus_vmf_infantry_chq"]] call DICT_fnc_set;
[_dict, "teamsAA", ["rhs_group_rus_vmf_infantry_section_AA"]] call DICT_fnc_set;
[_dict, "patrols", ["rhs_group_rus_vmf_infantry_MANEUVER", "rhs_group_rus_vmf_infantry_fireteam"]] call DICT_fnc_set;
[_dict, "recon_squad", configfile >> "CfgGroups" >> "East" >> "rhs_faction_vmf" >> "rhs_group_rus_vmf_infantry_recon" >> "rhs_group_rus_vmf_infantry_recon_squad"] call DICT_fnc_set;
[_dict, "recon_team", configfile >> "CfgGroups" >> "East" >> "rhs_faction_vmf" >> "rhs_group_rus_vmf_infantry_recon" >> "rhs_group_rus_vmf_infantry_recon_fireteam"] call DICT_fnc_set;

// These have to be CfgVehicles mines that explode automatically (minefields)
[_dict, "ap_mines", ["rhs_mine_pmn2"]] call DICT_fnc_set;
[_dict, "at_mines", ["rhs_mine_tm62m"]] call DICT_fnc_set;
// These have to be CfgVehicles
[_dict, "explosives", ["SatchelCharge_F","DemoCharge_F","ClaymoreDirectional_F"]] call DICT_fnc_set;

[_dict, "box", "Box_East_WpsLaunch_F"] call DICT_fnc_set;

if hasTFAR then {
    [_dict, "tfar_lr_radio", "tf_mr3000_rhs"] call DICT_fnc_set;
    [_dict, "tfar_radio", "tf_fadak"] call DICT_fnc_set;
};

_dict
