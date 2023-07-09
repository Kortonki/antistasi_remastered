private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str civilian] call DICT_fnc_set;
[_dict, "roles", ["civilian"]] call DICT_fnc_set;
[_dict, "name", "Altis (RHS)"] call DICT_fnc_set;
[_dict, "flat", "Flag_White_F"] call DICT_fnc_set;

[_dict, "units", [
"C_man_1","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F","C_man_hunter_1_F",
"C_man_p_beggar_F","C_man_p_beggar_F_afro","C_man_p_fugitive_F",
"C_man_p_shorts_1_F","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F",
"C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_shorts_1_F",
"C_man_shorts_2_F","C_man_shorts_3_F","C_man_shorts_4_F","C_scientist_F","C_Man_casual_1_F_euro",
"C_Man_casual_2_F_euro","C_Man_casual_3_F_euro","C_Man_casual_4_F_euro","C_Man_casual_5_F_euro",
"C_Man_casual_6_F_euro"
]] call DICT_fnc_set;

[_dict, "vehicles", [
"C_Hatchback_01_F",
"C_Hatchback_01_sport_F",
"C_Offroad_01_F",
"C_Offroad_02_unarmed_F",
"C_SUV_01_F",
"C_Van_01_box_F",
"C_Van_01_fuel_F",
"C_Van_01_transport_F",
"C_Truck_02_transport_F",
"C_Truck_02_covered_F",
"C_Truck_02_box_F",
"C_Truck_02_fuel_F",
"RHS_Ural_Open_Civ_01",
"RHS_Ural_Open_Civ_02",
"RHS_Ural_Open_Civ_03",
"RHS_Ural_Civ_01",
"RHS_Ural_Civ_02",
"RHS_Ural_Civ_03",
"C_Van_02_transport_F",
"C_Van_02_vehicle_F",
"C_Van_02_service_F",
"C_Van_02_medevac_F",
"C_IDAP_Van_02_medevac_F"
]] call DICT_fnc_set;

[_dict, "box", "C_IDAP_supplyCrate_F"] call DICT_fnc_set;

_dict
