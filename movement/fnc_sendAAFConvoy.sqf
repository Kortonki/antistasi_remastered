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

    private _mission = "";

    //TODO improve this to find a city nearest to a base

    /*{
      private _supplyMission = _x;
      {
        if (_supplyMission find _x != -1) exitWith {_mission = _supplyMission};
      } foreach (["city", "FIA"] call AS_location_fnc_TS);

    if (_mission != "") exitWith {};

    } foreach (_missions select {_x find "supplies" != -1 or _x find "money" != -1});*/

    //Check for FIA towns where to send supply convoy first

    {
      private _loc = _x;
      {
        if (_x find _loc != -1) exitwith {_mission = _x};

      } foreach (_missions select {_x find "supplies" != -1 or _x find "money" != -1});
      if (_mission != "") exitWith  {};

    } foreach (["city", "FIA"] call AS_location_fnc_TS);

    if (_mission == "") then {_mission = selectRandom _missions;};
    _mission call AS_mission_fnc_activate;
    diag_log "[AS] sendAAFConvoy: Valid convoy mission found, starting mission";
  } else {
    [] call AS_movement_fnc_sendAAFRecon;
  };
