private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str east] call DICT_fnc_set;
[_dict, "roles", ["state", "foreign"]] call DICT_fnc_set;
[_dict, "name", "VVS (RHS)"] call DICT_fnc_set;
[_dict, "flag", "rhs_Flag_vdv_F"] call DICT_fnc_set;
[_dict, "flag_marker", "rhs_flag_Russia"] call DICT_fnc_set;

[_dict, "helis_transport", ["rhs_ka60_c","RHS_Mi8AMT_vvsc"]] call DICT_fnc_set;
[_dict, "helis_attack", ["rhs_mi28n_vvsc","RHS_Ka52_vvsc","RHS_Mi24V_vvsc"]] call DICT_fnc_set;
[_dict, "helis_armed", ["RHS_Mi8MTV3_vvsc","RHS_Mi8mt_vvsc"]] call DICT_fnc_set;
[_dict, "planes", ["RHS_Su25SM_vvsc", "rhs_mig29sm_vvsc","rhs_mig29s_vvsc","RHS_T50_vvs_generic"]] call DICT_fnc_set;

[_dict, "uavs_small", ["rhs_pchela1t_vvs"]] call DICT_fnc_set;
[_dict, "uavs_attack", ["rhs_pchela1t_vvs"]] call DICT_fnc_set;

[_dict, "tanks", ["rhs_t72ba_tv","rhs_t72bb_tv","rhs_t72bc_tv","rhs_t80a","rhs_t80b","rhs_t90_tv"]] call DICT_fnc_set;
[_dict, "boats", ["O_Boat_Armed_01_hmg_F"]] call DICT_fnc_set;

// used in roadblock mission
[_dict, "trucks", ["rhs_kamaz5350_open_vdv","rhs_kamaz5350_vdv"]] call DICT_fnc_set;
[_dict, "apcs", ["rhs_btr80_vdv","rhs_btr80a_vdv","rhs_bmp2d_vdv","rhs_bmp1p_vdv","rhs_bmd2m","rhs_bmd2k"]] call DICT_fnc_set;

// used in traitor mission
[_dict, "cars_transport", ["rhs_tigr_vdv", "rhs_tigr_3cammo_vdv", "rhs_tigr_m_vdv", "rhs_tigr_m_vdv", "rhs_tigr_m_3cammo_vdv", "rhsgref_BRDM2UM_vdv"]] call DICT_fnc_set;
[_dict, "cars_armed", ["rhs_tigr_sts_vdv", "rhs_tigr_sts_3cammo_vdv", "rhsgref_BRDM2_vdv", "rhsgref_BRDM2_HQ_vdv"]] call DICT_fnc_set;

// used in artillery mission
[_dict, "artillery1", ["rhs_D30_vdv"]] call DICT_fnc_set;
[_dict, "artillery2", ["rhs_2s3_tv"]] call DICT_fnc_set;

[_dict, "truck_ammo", "rhs_gaz66_ammo_vdv"] call DICT_fnc_set;
[_dict, "truck_repair", "RHS_Ural_Repair_VDV_01"] call DICT_fnc_set;
[_dict, "truck_fuel", "I_Truck_02_fuel_F"] call DICT_fnc_set; //RHS ural is prone to get stuck with the AI and no other RHS fuel vehicles

// used in spawns (base and airfield)
[_dict, "other_vehicles", [
"rhs_gaz66_ammo_vdv", "RHS_Ural_Fuel_VDV_01", "rhs_gaz66_ap2_vdv", "RHS_Ural_Repair_VDV_01"
]] call DICT_fnc_set;

[_dict, "self_aa", ["rhs_zsu234_aa"]] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "rhs_vdv_officer"] call DICT_fnc_set;
[_dict, "traitor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "gunner", "rhs_vdv_recon_rifleman_l"] call DICT_fnc_set;
[_dict, "crew", "rhs_vdv_armoredcrew"] call DICT_fnc_set;
[_dict, "pilot", "rhs_pilot_combat_heli"] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["rhs_Igla_AA_pod_vdv"]] call DICT_fnc_set;
[_dict, "static_at", ["rhs_Metis_9k115_2_vdv"]] call DICT_fnc_set;
[_dict, "static_mg", ["rhs_KORD_high_VDV"]] call DICT_fnc_set;
[_dict, "static_mg_low", ["rhs_KORD_MSV"]] call DICT_fnc_set;
[_dict, "static_mortar", ["rhs_2b14_82mm_vdv"]] call DICT_fnc_set;

[_dict, "cfgGroups", configfile >> "CfgGroups" >> "east" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry"] call DICT_fnc_set;
[_dict, "squads", ["rhs_group_rus_vdv_infantry_squad","rhs_group_rus_vdv_infantry_squad_2mg","rhs_group_rus_vdv_infantry_squad_sniper","rhs_group_rus_vdv_infantry_squad_mg_sniper"]] call DICT_fnc_set;
[_dict, "teams", ["rhs_group_rus_vdv_infantry_section_mg","rhs_group_rus_vdv_infantry_section_marksman","rhs_group_rus_vdv_infantry_section_AT"]] call DICT_fnc_set;
[_dict, "teamsAA", ["rhs_group_rus_vdv_infantry_section_AA"]] call DICT_fnc_set;
[_dict, "patrols", ["rhs_group_rus_vdv_infantry_fireteam","rhs_group_rus_vdv_infantry_MANEUVER","rhs_group_rus_vdv_infantry_section_marksman"]] call DICT_fnc_set;
[_dict, "recon_squad", configfile >> "CfgGroups" >> "east" >> "rhs_faction_vdv">> "rhs_group_rus_vdv_infantry_recon" >> "rhs_group_rus_vdv_infantry_recon_squad"] call DICT_fnc_set;
[_dict, "recon_team", configfile >> "CfgGroups" >> "east" >> "rhs_faction_vdv">> "rhs_group_rus_vdv_infantry_recon" >> "rhs_group_rus_vdv_infantry_recon_MANEUVER"] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", ["rhs_weap_ak105","rhs_weap_ak104"]] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;

// These have to be CfgVehicles mines that explode automatically (minefields)
[_dict, "ap_mines", ["rhs_mine_pmn2"]] call DICT_fnc_set;
[_dict, "at_mines", ["rhs_mine_tm62m"]] call DICT_fnc_set;
// These have to be CfgVehicles
[_dict, "explosives", ["SatchelCharge_F","DemoCharge_F","ClaymoreDirectional_F"]] call DICT_fnc_set;

[_dict, "box", "rhs_launcher_crate"] call DICT_fnc_set;

if hasTFAR then {
    [_dict, "tfar_lr_radio", "TFAR_mr3000_rhs"] call DICT_fnc_set;
    [_dict, "tfar_radio", "TFAR_fadak"] call DICT_fnc_set;
};

_dict
