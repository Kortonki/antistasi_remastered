private _dict = ([AS_entities, "FIA_WEST"] call DICT_fnc_get) call DICT_fnc_copy;
[_dict, "name", "CZ"] call DICT_fnc_set;
[_dict, "name_info", "CUP"] call DICT_fnc_set;
[_dict, "flag", "Flag_FIA_F"] call DICT_fnc_set;

[_dict, "soldier", "CUP_B_CZ_soldier_DES"] call DICT_fnc_set;
[_dict, "crew", "CUP_B_CZ_crew_DES"] call DICT_fnc_set;
[_dict, "survivor", "CUP_B_CZ_soldier_light_DES"] call DICT_fnc_set;
[_dict, "engineer", "CUP_B_CZ_engineer_DES"] call DICT_fnc_set;
[_dict, "medic", "CUP_B_CZ_medic_DES"] call DICT_fnc_set;

[_dict, "unlockedWeapons", ["Binocular","CUP_arifle_AKS74U","CUP_hgun_Makarov"]] call DICT_fnc_set;

[_dict, "unlockedMagazines", ["CUP_30Rnd_545x39_AK_M","CUP_8Rnd_9x18_Makarov_M",
"IEDUrbanBig_Remote_Mag",
"IEDLandBig_Remote_Mag",
"IEDUrbanSmall_Remote_Mag",
"IEDLandSmall_Remote_Mag"]] call DICT_fnc_set;

[_dict, "unlockedBackpacks", ["CUP_B_CivPack_WDL"]] call DICT_fnc_set;

[_dict, "vans", ["CUP_C_LR_Transport_CTK"]] call DICT_fnc_set;

// FIA minefield uses first of this list
[_dict, "land_vehicles", ["CUP_C_UAZ_Unarmed_TK_CIV","CUP_C_LR_Transport_CTK","CUP_C_V3S_Open_TKC","CUP_I_Datsun_PK"]] call DICT_fnc_set;
[_dict, "water_vehicles", ["B_G_Boat_Transport_01_F"]] call DICT_fnc_set;
// First helicopter of this list is undercover
[_dict, "air_vehicles", ["CUP_B_MH6J_OBS_USA"]] call DICT_fnc_set;

[_dict, "cars_armed", ["CUP_I_Datsun_PK"]] call DICT_fnc_set;


// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;
[_dict, "additionalBinoculars", []] call DICT_fnc_set;

// costs of **land vehicle**. Every vehicle in `"land_vehicles"` must be here.
private _costs = [_dict, "costs"] call DICT_fnc_get; //Baseline so no missing for HC squads etc.
[_costs, "CUP_C_UAZ_Unarmed_TK_CIV", 300] call DICT_fnc_set;
[_costs, "CUP_C_LR_Transport_CTK", 300] call DICT_fnc_set;
[_costs, "CUP_C_V3S_Open_TKC", 600] call DICT_fnc_set;
[_costs, "CUP_I_Datsun_PK", 700] call DICT_fnc_set;

_dict
