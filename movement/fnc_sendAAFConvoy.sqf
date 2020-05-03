//This script sends random convoy mission if AAF can't attack anywhere

params [["_skipping", false]];

private _alarm = false;

private _missions = (call AS_mission_fnc_all) select {_x call AS_mission_fnc_status in ["available","possible"] and
  {_x call AS_mission_fnc_type in [
    "convoy_ammo",
    "convoy_armor",
    "convoy_fuel",
    "convoy_hvt",
    "convoy_supplies",
    "convoy_money",
    "convoy_prisoners"
    ] and {!(_x call AS_spawn_fnc_exists)}}};

  //Send recon every 10th time anyway
  if (count _missions > 0 and {random 1 < 0.90 and {sunOrMoon == 1 or (random 1 < 0.1)}}) then { //AAF will only send convoys in daylight with only small exceptions

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

    call {

      //If low on money prioritize logistics to get money. Random component added
      if ((call AS_fnc_getAAFresourcesAdj) < 2000 or (random 1 < 0.1)) then {

        {
          if ("ammo" in _x or "fuel" in _x or "money" in _x) exitwith {
            _mission = _x;
          };
        } foreach _missions;
      };

      if (_mission != "") exitWith {};

      //Then FIA cities
      {
        private _loc = _x;
        {
          if (_loc in _x) exitwith {_mission = _x};

        } foreach (_missions select {"supplies" in _x});
        if (_mission != "") exitWith  {};

      } foreach (["city", "FIA"] call AS_location_fnc_TS);

      if (_mission != "" and {random 1 < 0.90}) exitWith {_alarm = true; _skipping = false}; //random component here. aaf won't allways send to fia cities

      //Then others where support is needed
      {
        private _loc = _x;
        {
          if (([_loc, "AAFsupport"] call AS_location_fnc_get) <= 80 and {_loc in _x}) exitWith {
            _mission = _x;
          };
        } foreach (_missions select {"supplies" in _x});
        if (_mission != "") exitWith  {};
      } foreach ("city" call AS_location_fnc_T);

    };


    if (_mission == "") then {
      call AS_movement_fnc_sendAAFRecon;
    } else { //Prevent changing mission if it's worth an alarm
      _mission call AS_mission_fnc_activate;
      [_mission, "skipping", _skipping] call AS_mission_fnc_set; //Tell convoy missions if skipping time: Will automatically fail if not bound to FIA location
      diag_log "[AS] sendAAFConvoy: Valid convoy mission found, starting mission";
    };
  } else {
    call AS_movement_fnc_sendAAFRecon;
  };
  _alarm
