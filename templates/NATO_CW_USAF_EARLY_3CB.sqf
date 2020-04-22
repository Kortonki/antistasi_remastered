private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "roles", ["state", "foreign"]] call DICT_fnc_set;
[_dict, "name", "United States Armed Forces (Early Cold War)"] call DICT_fnc_set;
[_dict, "shortname", "USAF"] call DICT_fnc_set;
[_dict, "flag", "Flag_US_F"] call DICT_fnc_set;
[_dict, "flag_marker", "flag_USA"] call DICT_fnc_set;

[_dict, "helis_transport", ["UK3CB_CW_US_B_EARLY_CH47",
"UK3CB_CW_US_B_EARLY_CH47_LIGHT",
"UK3CB_CW_US_B_EARLY_UH1H_M240",
"UK3CB_CW_US_B_EARLY_UH1H"]] call DICT_fnc_set;
[_dict, "helis_attack", ["UK3CB_CW_US_B_EARLY_AH1Z",
"UK3CB_CW_US_B_EARLY_AH1Z_CS"]] call DICT_fnc_set;
[_dict, "helis_armed", ["UK3CB_CW_US_B_EARLY_AH1Z_GS"]] call DICT_fnc_set;
[_dict, "planes", ["UK3CB_CW_US_B_EARLY_A10",
"UK3CB_CW_US_B_EARLY_A10_CBU",
"UK3CB_CW_US_B_EARLY_A10_AT"]] call DICT_fnc_set;

[_dict, "uavs_small", ["B_UAV_01_F"]] call DICT_fnc_set;
[_dict, "uavs_attack", ["B_UAV_02_F"]] call DICT_fnc_set;

[_dict, "tanks", ["UK3CB_CW_US_B_EARLY_M1A1"]] call DICT_fnc_set;
[_dict, "apcs", ["UK3CB_CW_US_B_EARLY_M113_M2",
"UK3CB_CW_US_B_EARLY_M113_M240",
"UK3CB_CW_US_B_EARLY_M113_MK19"]] call DICT_fnc_set;
// used in traitor mission
[_dict, "cars_armed", ["UK3CB_CW_US_B_EARLY_M151_Jeep_HMG",
"UK3CB_CW_US_B_EARLY_M151_Jeep_TOW"]] call DICT_fnc_set;
[_dict, "cars_transport", ["UK3CB_CW_US_B_EARLY_Willys_Jeep_Open",
"UK3CB_CW_US_B_EARLY_M151_Jeep_Closed",
"UK3CB_CW_US_B_EARLY_M151_Jeep_Open"]] call DICT_fnc_set;



// used in roadblock mission
[_dict, "trucks", ["UK3CB_CW_US_B_EARLY_M939",
"UK3CB_CW_US_B_EARLY_M939_Guntruck",
"UK3CB_CW_US_B_EARLY_M939_Open"]] call DICT_fnc_set;
//These are used for AAF convoy missions
[_dict, "vans", [
"C_IDAP_Truck_02_F"
]] call DICT_fnc_set;

[_dict, "boats", ["UK3CB_BAF_RHIB_HMG", "B_Boat_Transport_01_F"]] call DICT_fnc_set;

// used in artillery mission
[_dict, "artillery1", ["UK3CB_CW_US_B_EARLY_M109"]] call DICT_fnc_set;
[_dict, "artillery2", ["UK3CB_CW_US_B_EARLY_M109"]] call DICT_fnc_set;

[_dict, "truck_ammo", "UK3CB_CW_US_B_EARLY_M939_Reammo"] call DICT_fnc_set;
[_dict, "truck_repair", "UK3CB_CW_US_B_EARLY_M939_Repair"] call DICT_fnc_set;
[_dict, "truck_fuel", "UK3CB_CW_US_B_EARLY_M939_Fuel"] call DICT_fnc_set;

// used in spawns (base and airfield)
[_dict, "other_vehicles", [
"UK3CB_CW_US_B_EARLY_M939_Reammo",
"UK3CB_CW_US_B_EARLY_M939_Recovery",
"UK3CB_CW_US_B_EARLY_M939_Fuel",
"UK3CB_CW_US_B_EARLY_M939_Repair",
"UK3CB_CW_US_B_EARLY_M113_AMB"
]] call DICT_fnc_set;

[_dict, "self_aa", ["B_T_APC_Tracked_01_AA_F"]] call DICT_fnc_set;

// special units used in special occasions
[_dict, "officer", "UK3CB_CW_US_B_EARLY_OFF"] call DICT_fnc_set;
[_dict, "traitor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "gunner", "UK3CB_CW_US_B_EARLY_RIF_2"] call DICT_fnc_set;
[_dict, "crew", "UK3CB_CW_US_B_EARLY_CREW"] call DICT_fnc_set;
[_dict, "pilot", "UK3CB_CW_US_B_EARLY_HELI_PILOT"] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["UK3CB_CW_US_B_Early_Stinger_AA_pod"]] call DICT_fnc_set;
[_dict, "static_at", ["UK3CB_CW_US_B_Early_TOW_TriPod","UK3CB_CW_US_B_Early_M119"]] call DICT_fnc_set;
[_dict, "static_mg", ["UK3CB_CW_US_B_Early_M2_TriPod"]] call DICT_fnc_set;
[_dict, "static_mg_low", ["UK3CB_CW_US_B_Early_M2_MiniTripod"]] call DICT_fnc_set;
[_dict, "static_mortar", ["UK3CB_CW_US_B_Early_M252"]] call DICT_fnc_set;

[_dict, "cfgGroups", (configfile >> "CfgGroups" >> "West" >> "UK3CB_CW_US_B_EARLY" >> "Infantry")] call DICT_fnc_set;
[_dict, "squads", ["UK3CB_CW_US_B_EARLY_AR_Squad", "UK3CB_CW_US_B_EARLY_AT_Squad","UK3CB_CW_US_B_EARLY_MG_Squad", "UK3CB_CW_US_B_EARLY_MK_Squad","UK3CB_CW_US_B_EARLY_RIF_Squad"]] call DICT_fnc_set;
[_dict, "teams", ["UK3CB_CW_US_B_EARLY_AR_FireTeam", "UK3CB_CW_US_B_EARLY_AT_FireTeam", "UK3CB_CW_US_B_EARLY_MG_FireTeam","UK3CB_CW_US_B_EARLY_RIF_FireTeam","UK3CB_CW_US_B_EARLY_UGL_FireTeam"]] call DICT_fnc_set;
[_dict, "teamsAA", ["UK3CB_CW_US_B_EARLY_AA_FireTeam", "UK3CB_CW_US_B_EARLY_AA_Squad"]] call DICT_fnc_set;
[_dict, "patrols", ["UK3CB_CW_US_B_EARLY_AR_Sentry", "UK3CB_CW_US_B_EARLY_LAT_Sentry", "UK3CB_CW_US_B_EARLY_MG_Sentry","UK3CB_CW_US_B_EARLY_MK_Sentry","UK3CB_CW_US_B_EARLY_RIF_Sentry","UK3CB_CW_US_B_EARLY_UGL_Sentry"]] call DICT_fnc_set;
[_dict, "recon_squad", "UK3CB_CW_US_B_EARLY_Recon_SpecSquad"] call DICT_fnc_set;
[_dict, "recon_team", "UK3CB_CW_US_B_EARLY_Recon_SpecTeam"] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", [
["rhs_M252_Gun_Bag", "rhs_M252_Bipod_Bag"],
["RHS_M2_Gun_Bag", "RHS_M2_Tripod_Bag"],
["rhs_Tow_Gun_Bag", "rhs_TOW_Tripod_Bag"]
]] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;
[_dict, "additionalBinoculars", []] call DICT_fnc_set;

// These have to be CfgVehicles mines that explode automatically (minefields)
[_dict, "ap_mines", ["rhsusf_mine_m14"]] call DICT_fnc_set;
[_dict, "at_mines", ["rhs_mine_M19_mag"]] call DICT_fnc_set;
// These have to be CfgVehicles
[_dict, "explosives", ["SatchelCharge_F","DemoCharge_F","Claymore_F"]] call DICT_fnc_set;

[_dict, "box", "B_supplyCrate_F"] call DICT_fnc_set;

if hasTFAR then {
    [_dict, "tfar_lr_radio", "TFAR_rt1523g_rhs"] call DICT_fnc_set;
    [_dict, "tfar_radio", "TFAR_anprc152"] call DICT_fnc_set;
};


_dict
