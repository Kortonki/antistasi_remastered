//This script sends random convoy mission if AAF can't attack anywhere

private _missions = (call AS_mission_fnc_all) select {_x call AS_mission_fnc_status in ["available","possible"] and
  {_x call AS_mission_fnc_type in [
    "convoy_ammo",
    "convoy_armor",
    "convoy_fuel",
    "convoy_hvt",
    "convoy_supplies",
    "convoy_money",
    "convoy_prisoners"
    ]}};

  if (count _missions > 0) then {
    private _mission = selectRandom _missions;
    _mission call AS_mission_fnc_activate;
    _debug_message = ;
    diag_log "[AS] sendAAFConvoy: Valid convoy mission found, starting mission";
  } else {
    [] call AS_movement_fnc_sendAAFRecon;
  };
