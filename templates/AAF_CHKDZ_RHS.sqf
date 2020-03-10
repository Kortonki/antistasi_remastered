private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str east] call DICT_fnc_set;
[_dict, "roles", ["state"]] call DICT_fnc_set;
[_dict, "name", "ChDKZ (RHS)"] call DICT_fnc_set;
[_dict, "shortname", "ChDKZ"] call DICT_fnc_set;
[_dict, "flag", "Flag_Red_F"] call DICT_fnc_set;
[_dict, "box", "I_supplyCrate_F"] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "rhsgref_ins_commander"] call DICT_fnc_set;
[_dict, "traitor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "gunner", "rhsgref_ins_rifleman_akm"] call DICT_fnc_set;
[_dict, "crew", "rhsgref_ins_crew"] call DICT_fnc_set;
[_dict, "pilot", "rhsgref_ins_pilot"] call DICT_fnc_set;

// To modders: equipment in AAF boxes comes from the set of all equipment of all units on the groups of this cfg
[_dict, "cfgGroups", configfile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry"] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;

// These groups are used in different spawns (locations, patrols, missions)
[_dict, "patrols", ["rhsgref_group_chdkz_infantry_patrol", "rhsgref_group_chdkz_infantry_mg", "rhsgref_group_chdkz_infantry_at"]] call DICT_fnc_set;
[_dict, "teams", ["rhsgref_group_chdkz_infantry_patrol"]] call DICT_fnc_set;
[_dict, "squads", ["rhsgref_group_chdkz_ins_gurgents_squad"]] call DICT_fnc_set;
[_dict, "teamsAA", ["rhsgref_group_chdkz_infantry_aa"]] call DICT_fnc_set;

// To modders: overwrite this in the template to change the vehicles AAF uses.
// Rules:
// 1. vehicle must exist.
// 2. each vehicle must belong to only one category.
[_dict, "planes", ["RHS_Su25SM_vvs"]] call DICT_fnc_set; //these are from AFRF VVS because none available for ChKDZ
[_dict, "helis_armed", ["RHS_Mi8MTV3_vvs"]] call DICT_fnc_set;
[_dict, "helis_transport", ["rhsgref_ins_g_Mi8amt"]] call DICT_fnc_set;
[_dict, "tanks", ["rhsgref_ins_g_t72bc", "rhsgref_ins_g_t72bb", "rhsgref_ins_g_t72ba"]] call DICT_fnc_set;
[_dict, "boats", ["I_G_Boat_Transport_01_F"]] call DICT_fnc_set;
[_dict, "cars_transport", ["rhsgref_ins_g_uaz", "rhsgref_ins_g_uaz_open"]] call DICT_fnc_set;
[_dict, "cars_armed", ["rhsgref_BRDM2_ins_g"," rhsgref_BRDM2_ATGM_ins_g", "rhsgref_BRDM2_HQ_ins_g", "rhsgref_ins_uaz_ags", "rhsgref_ins_uaz_dshkm", "rhsgref_ins_uaz_spg9"]] call DICT_fnc_set;
[_dict, "apcs", ["rhsgref_ins_g_btr60", "rhsgref_ins_g_btr70", "rhsgref_ins_g_bmd1", "rhsgref_ins_g_bmp1"," rhsgref_ins_g_bmp1p", "rhsgref_ins_g_bmp2e"]] call DICT_fnc_set;
[_dict, "trucks", ["rhsgref_ins_g_gaz66o", "rhsgref_ins_g_gaz66"]] call DICT_fnc_set;

[_dict, "other_vehicles", [
"rhsgref_ins_g_gaz66_ammo", "I_Truck_02_fuel_F", "rhsgref_ins_g_gaz66_ap2", "rhsgref_ins_g_gaz66_repair"
]] call DICT_fnc_set;


// used in artillery mission
[_dict, "artillery1", ["rhsgref_ins_g_d30"]] call DICT_fnc_set;
[_dict, "artillery2", ["rhsgref_ins_g_2s1"]] call DICT_fnc_set;

[_dict, "truck_ammo", "rhsgref_ins_g_gaz66_ammo"] call DICT_fnc_set;
[_dict, "truck_repair", "rhsgref_ins_g_gaz66_repair"] call DICT_fnc_set;
[_dict, "truck_fuel", "I_Truck_02_fuel_F"] call DICT_fnc_set;

[_dict, "uavs_small", ["I_UAV_01_F"]] call DICT_fnc_set;
[_dict, "uavs_attack", []] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["rhsgref_ins_g_ZU23"]] call DICT_fnc_set;
[_dict, "static_at", ["rhsgref_ins_g_SPG9"]] call DICT_fnc_set;
[_dict, "static_mg", ["rhsgref_ins_g_DSHKM"]] call DICT_fnc_set;
[_dict, "static_mg_low", ["rhsgref_ins_g_DSHKM_Mini_TriPod"]] call DICT_fnc_set;
[_dict, "static_mortar", ["rhsgref_ins_g_2b14"]] call DICT_fnc_set;

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
