private _dict = ([AS_entities, "RHS_FIA_WEST"] call DICT_fnc_get) call DICT_fnc_copy;
[_dict, "side", str east] call DICT_fnc_set;
[_dict, "name", "Freedom and Independence Army"] call DICT_fnc_set;
[_dict, "name_info", "RHS"] call DICT_fnc_set;
[_dict, "flag", "Flag_Blue_F"] call DICT_fnc_set;

/*[_dict, "soldier", "rhsgref_ins_rifleman"] call DICT_fnc_set;
[_dict, "crew", "rhsgref_ins_crew"] call DICT_fnc_set;
[_dict, "survivor", "rhsgref_ins_rifleman"] call DICT_fnc_set;
[_dict, "engineer", "rhsgref_ins_engineer"] call DICT_fnc_set;
[_dict, "medic", "rhsgref_ins_medic"] call DICT_fnc_set;
*/
[_dict, "soldier", "O_G_Soldier_F"] call DICT_fnc_set;
[_dict, "crew", "O_G_Soldier_lite_F"] call DICT_fnc_set;
[_dict, "survivor", "O_G_Survivor_F"] call DICT_fnc_set;
[_dict, "engineer", "O_G_engineer_F"] call DICT_fnc_set;
[_dict, "medic", "O_G_medic_F"] call DICT_fnc_set;

_dict
