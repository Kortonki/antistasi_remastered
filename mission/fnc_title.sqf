params ["_mission"];
private _missionType = _mission call AS_mission_fnc_type;
if (_missionType == "kill_officer") exitWith {localize "STR_tsk_ASOfficer"};
if (_missionType == "kill_specops") exitWith {localize "STR_tsk_ASSpecOp"};
if (_missionType == "kill_traitor") exitWith {localize "STR_tsk_ASSTraitor"};
if (_missionType == "black_market") exitWith {localize "Str_tsk_fndExp"};
if (_missionType == "pamphlets") exitWith {
  format [localize "STR_tsk_PRPamphlet", _mission call AS_mission_fnc_location]
};
if (_missionType == "broadcast") exitWith {localize "STR_tsk_PRBrain"};
if (_missionType == "convoy_armor") exitWith {localize "STR_tsk_CVY_Armor"};
if (_missionType == "convoy_ammo") exitWith {localize "STR_tsk_CVY_Ammo"};
if (_missionType == "convoy_money") exitWith {localize "STR_tsk_CVY_Money"};
if (_missionType == "convoy_fuel") exitWith {localize "STR_tsk_CVY_Fuel"};
if (_missionType == "convoy_supplies") exitWith {
  format [localize "STR_tsk_CVY_Supply", _mission call AS_mission_fnc_location]
};
if (_missionType == "convoy_prisoners") exitWith {localize "STR_tsk_CVY_Pris"};
if (_missionType == "convoy_hvt") exitWith {localize "STR_tsk_CVY_HVT"};
if (_missionType == "rescue_prisioners") exitWith {localize "STR_tsk_resPrisoners"};
if (_missionType == "rescue_refugees") exitWith {localize "STR_tsk_resRefugees"};
if (_missionType == "rob_bank") exitWith {localize "STR_tsk_logBank"};
if (_missionType == "help_meds") exitWith {
  format [localize "STR_tsk_logMedical", _mission call AS_mission_fnc_location]
};
if (_missionType == "send_meds") exitWith {
  format [localize "STR_tsk_logSupply", _mission call AS_mission_fnc_location]
};
if (_missionType == "steal_ammo") exitWith {localize "STR_tsk_logAmmo"};
if (_missionType == "steal_fuel") exitWith {localize "STR_tsk_logFuel"};
if (_missionType == "destroy_vehicle") exitWith {localize "STR_tsk_DesVehicle"};
if (_missionType == "destroy_helicopter") exitWith {localize "STR_tsk_DesHeli"};
if (_missionType == "destroy_antenna") exitWith {localize "STR_tsk_DesAntenna"};
if (_missionType == "repair_antenna") exitWith {localize "STR_tsk_repAntenna"};
if (_missionType == "conquer") exitWith {"Take location"};
diag_log format ["[AS] Error: mission_title: invalid type '%1'", _missionType];
