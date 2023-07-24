#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_fromDict");
params ["_dict"];
call AS_mission_fnc_deinitialize;
[AS_container, "mission", _dict call DICT_fnc_copyGlobal] call DICT_fnc_setGlobal; //Changed to copyGlobal
[] spawn {
  //This to make sure tasks etc. load properly
  waitUntil {count (allPlayers select {_x getVariable ["inited", false]}) > 0};
  {
    _x call AS_mission_fnc_activate;
    private _i = 0;
    waitUntil {sleep 1; _i = _i + 1; [_x, "state_index"] call AS_spawn_fnc_get >= 2 or !(_x call AS_spawn_fnc_exists) or _i > 20};
  } forEach ([] call AS_mission_fnc_active_missions);
};
