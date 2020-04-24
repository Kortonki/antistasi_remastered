private _dict = ([AS_entities, "3CB_FIA_WEST_LRA"] call DICT_fnc_get) call DICT_fnc_copy;
[_dict, "side", str east] call DICT_fnc_set;
[_dict, "name", "Livonia Resistance Army (RHS and 3CB)"] call DICT_fnc_set;

/*[_dict, "soldier", "rhsgref_ins_rifleman"] call DICT_fnc_set;
[_dict, "crew", "rhsgref_ins_crew"] call DICT_fnc_set;
[_dict, "survivor", "rhsgref_ins_rifleman"] call DICT_fnc_set;
[_dict, "engineer", "rhsgref_ins_engineer"] call DICT_fnc_set;
[_dict, "medic", "rhsgref_ins_medic"] call DICT_fnc_set;
*/
[_dict, "soldier", "UK3CB_CCM_O_RIF_1"] call DICT_fnc_set;
[_dict, "crew", "UK3CB_CCM_O_RIF_2"] call DICT_fnc_set;
[_dict, "survivor", "UK3CB_CCM_O_RIF_LITE"] call DICT_fnc_set;
[_dict, "engineer", "UK3CB_CCM_O_ENG"] call DICT_fnc_set;
[_dict, "medic", "UK3CB_CCM_O_MD"] call DICT_fnc_set;

private _config = configfile >> "CfgGroups" >> "East" >> "UK3CB_CCM_O" >> "Infantry";
private _FIAsoldiers = _config call AS_fnc_getAllUnits;

// List of all FIA 3CB equipment
private _result = [_FIAsoldiers] call AS_fnc_listUniqueEquipment;

private _uniforms = _result select 4;
_uniforms append [
"U_BG_Guerrilla2_2",
"U_BG_Guerrilla_6_1",
"U_I_E_Uniform_01_shortsleeve_F"
];

[_dict, "uniforms", _uniforms
] call DICT_fnc_set;

_dict
