#include "../macros.hpp"
AS_SERVER_ONLY("AS_AI_fnc_setOrders.sqf");

params [["_location", ""], ["_combatMode", ""], ["_behaviour", ""]];

private _groups = ([_location, "resources"] call AS_spawn_fnc_get) select 1;

if (_combatMode != "") then {
    {
      [_x, _combatMode] remoteExec ["setCombatMode", groupOwner _x];
      (leader _x) sidechat (format ["Our ROE is now %1", _combatMode]);
    } foreach _groups;
};

if (_behaviour != "") then {
  {
    [_x, _behaviour] remoteExec ["setBehaviour", groupOwner _x];
    (leader _x) sidechat (format ["We are now %1 mode", _behaviour]);
  } foreach _groups;
};
