// The first line below copies the dictionary, thus "inheriting" all its attributes.
// We then modify the ones we want to be different.
private _dict = ([AS_entities, "FIA_WEST"] call DICT_fnc_get) call DICT_fnc_copy;
[_dict, "side", str east] call DICT_fnc_set;

[_dict, "soldier", "O_G_Soldier_F"] call DICT_fnc_set;
[_dict, "crew", "O_G_Soldier_lite_F"] call DICT_fnc_set;
[_dict, "survivor", "O_G_Survivor_F"] call DICT_fnc_set;
[_dict, "engineer", "O_G_engineer_F"] call DICT_fnc_set;
[_dict, "medic", "O_G_medic_F"] call DICT_fnc_set;

_dict
