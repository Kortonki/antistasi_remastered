private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str east] call DICT_fnc_set;
[_dict, "roles", ["state", "foreign"]] call DICT_fnc_set;
[_dict, "name", "VDV (RHS)"] call DICT_fnc_set;
[_dict, "shortname", "VDV"] call DICT_fnc_set;
[_dict, "flag", "rhs_Flag_Russia_F"] call DICT_fnc_set;
[_dict, "box", "I_supplyCrate_F"] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "rhs_vdv_officer"] call DICT_fnc_set;
[_dict, "traitor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "gunner", "rhs_vdv_rifleman"] call DICT_fnc_set;
[_dict, "crew", "rhs_vdv_armoredcrew"] call DICT_fnc_set;
[_dict, "pilot", "rhs_pilot_transport_heli"] call DICT_fnc_set;

// To modders: equipment in AAF boxes comes from the set of all equipment of all units on the groups of this cfg
[_dict, "cfgGroups", configfile >> "CfgGroups" >> "east" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry"] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", ["rhs_weap_ak105","rhs_weap_ak104"]] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;

// These groups are used in different spawns (locations, patrols, missions)
[_dict, "patrols", ["rhs_group_rus_vdv_infantry_fireteam","rhs_group_rus_vdv_infantry_MANEUVER","rhs_group_rus_vdv_infantry_section_marksman"]] call DICT_fnc_set;
[_dict, "teams", ["rhs_group_rus_vdv_infantry_section_mg","rhs_group_rus_vdv_infantry_section_marksman","rhs_group_rus_vdv_infantry_section_AT"]] call DICT_fnc_set;
[_dict, "squads", ["rhs_group_rus_vdv_infantry_squad","rhs_group_rus_vdv_infantry_squad_2mg","rhs_group_rus_vdv_infantry_squad_sniper","rhs_group_rus_vdv_infantry_squad_mg_sniper"]] call DICT_fnc_set;
[_dict, "teamsAA", ["rhs_group_rus_vdv_infantry_section_AA"]] call DICT_fnc_set;

// To modders: overwrite this in the template to change the vehicles AAF uses.
// Rules:
// 1. vehicle must exist.
// 2. each vehicle must belong to only one category.
[_dict, "planes", ["rhs_Su25SM_vvsc"]] call DICT_fnc_set;
[_dict, "helis_armed", ["rhs_Mi24V_vdv","rhs_Mi24P_vdv"]] call DICT_fnc_set;
[_dict, "helis_transport", ["RHS_Mi8mt_vdv","RHS_Mi8MTV3_vdv"]] call DICT_fnc_set;
[_dict, "tanks", ["rhs_t72ba_tv","rhs_t72bb_tv","rhs_t72bc_tv","rhs_t80a","rhs_t80b","rhs_t90_tv"]] call DICT_fnc_set;
[_dict, "boats", ["I_Boat_Armed_01_minigun_F"]] call DICT_fnc_set;
[_dict, "cars_transport", ["rhs_tigr_vdv", "rhs_tigr_3camo_vdv", "rhs_tigr_m_vdv", "rhs_tigr_m_3camo_vdv", "rhsgref_BRDM2UM_vdv"]] call DICT_fnc_set;
[_dict, "cars_armed", ["rhs_tigr_sts_vdv", "rhs_tigr_sts_3camo_vdv", "rhsgref_BRDM2_vdv", "rhsgref_BRDM2_HQ_vdv"]] call DICT_fnc_set;
[_dict, "apcs", ["rhs_btr80_vdv","rhs_btr80a_vdv","rhs_bmp2d_vdv","rhs_bmp1p_vdv","rhs_bmd2m","rhs_bmd2k"]] call DICT_fnc_set;
[_dict, "trucks", ["rhs_kamaz5350_open_vdv","rhs_kamaz5350_vdv"]] call DICT_fnc_set;

[_dict, "other_vehicles", [
"rhs_gaz66_ammo_vdv", "RHS_Ural_Fuel_VDV_01", "rhs_gaz66_ap2_vdv", "RHS_Ural_Repair_VDV_01"
]] call DICT_fnc_set;


// used in artillery mission
[_dict, "artillery1", ["rhs_D30_vdv"]] call DICT_fnc_set;
[_dict, "artillery2", ["rhs_2s3_tv"]] call DICT_fnc_set;

[_dict, "truck_ammo", "rhs_gaz66_ammo_vdv"] call DICT_fnc_set;
[_dict, "truck_repair", "rhs_gaz66_repair_vdv"] call DICT_fnc_set;
[_dict, "truck_fuel", "I_Truck_02_fuel_F"] call DICT_fnc_set;

[_dict, "uavs_small", ["rhs_pchela1t_vvs"]] call DICT_fnc_set;
[_dict, "uavs_attack", ["rhs_pchela1t_vvs"]] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["RHS_ZU23_VDV"]] call DICT_fnc_set;
[_dict, "static_at", ["rhs_SPG9M_VDV"]] call DICT_fnc_set;
[_dict, "static_mg", ["rhs_KORD_high_VDV"]] call DICT_fnc_set;
[_dict, "static_mg_low", ["rhs_KORD_MSV"]] call DICT_fnc_set;
[_dict, "static_mortar", ["rhs_2b14_82mm_vdv"]] call DICT_fnc_set;

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
