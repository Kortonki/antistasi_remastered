private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str civilian] call DICT_fnc_set;
[_dict, "roles", ["civilian"]] call DICT_fnc_set;
[_dict, "name", "CW (RHS and 3CB)"] call DICT_fnc_set;
[_dict, "flat", "Flag_White_F"] call DICT_fnc_set;

[_dict, "units", [
"UK3CB_CHC_C_ACT",
"UK3CB_CHC_C_BODYG",
"UK3CB_CHC_C_CIT",
"UK3CB_CHC_C_DOC",
"UK3CB_CHC_C_COACH",
"UK3CB_CHC_C_FUNC",
"UK3CB_CHC_C_HIKER",
"UK3CB_CHC_C_LABOUR",
"UK3CB_CHC_C_PILOT",
"UK3CB_CHC_C_POLITIC",
"UK3CB_CHC_C_PRIEST",
"UK3CB_CHC_C_PROF",
"UK3CB_CHC_C_CIV",
"UK3CB_CHC_C_SPY",
"UK3CB_CHC_C_VILL",
"UK3CB_CHC_C_CAN",
"UK3CB_CHC_C_WOOD",
"UK3CB_CHC_C_WORKER",
"C_Man_casual_1_F_euro",
"C_Man_casual_2_F_euro",
"C_Man_casual_3_F_euro",
"C_man_p_fugitive_F",
"C_Man_Fisherman_01_F",
"C_man_hunter_1_F",
"C_man_w_worker_F",
"C_Farmer_01_enoch_F"
]] call DICT_fnc_set;

[_dict, "vehicles", [
"UK3CB_C_Datsun_Closed",
"UK3CB_C_Datsun_Open",
"UK3CB_C_Hatchback",
"UK3CB_C_Hilux_Closed",
"UK3CB_C_Hilux_Open",
"UK3CB_C_Ikarus",
"UK3CB_C_Ikarus_RED",
"UK3CB_C_Kamaz_Covered",
"UK3CB_C_Kamaz_Fuel",
"UK3CB_C_Kamaz_Repair",
"UK3CB_C_Lada",
"UK3CB_C_LandRover_Closed",
"UK3CB_C_LandRover_Open",
"UK3CB_Civ_LandRover_Soft_Blue_A",
"UK3CB_Civ_LandRover_Soft_Green_A",
"UK3CB_Civ_LandRover_Soft_Red_A",
"UK3CB_C_V3S_Refuel",
"UK3CB_C_V3S_Recovery",
"UK3CB_C_V3S_Repair",
"UK3CB_C_V3S_Closed",
"UK3CB_C_V3S_Open",
"UK3CB_C_Sedan",
"UK3CB_C_Skoda",
"UK3CB_C_S1203",
"UK3CB_C_S1203_Ambulance",
"C_Tractor_01_F",
"UK3CB_C_Tractor",
"UK3CB_C_Tractor_Old",
"UK3CB_C_UAZ_Open",
"UK3CB_C_UAZ_Closed",
"UK3CB_C_Ural_Covered",
"UK3CB_C_Ural_Fuel",
"UK3CB_C_Ural_Open",
"UK3CB_C_Ural_Empty",
"UK3CB_C_Ural_Recovery",
"UK3CB_C_Ural_Repair",
"UK3CB_C_Gaz24"

]] call DICT_fnc_set;

[_dict, "box", "C_IDAP_supplyCrate_F"] call DICT_fnc_set;

_dict
