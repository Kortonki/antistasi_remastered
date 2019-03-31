#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_petrosDeath");

//HQ garrison continues as HC group
["fia_hq"] call AS_fnc_garrisonRelease;

//Halve nato support
private _nato = AS_P("NATOsupport");
_nato = floor (_nato/2);
AS_Pset("NATOsupport", _nato);

//Halve all city support for FIA

{
  private _sup = [_x, "FIAsupport"] call AS_location_fnc_get;
  _sup = floor (_sup/2);
  [_x, "FIAsupport", _sup] call AS_location_fnc_set;
} forEach (call AS_location_fnc_cities);



waitUntil {sleep 5; isPlayer AS_commander};
[] remoteExec ["AS_fnc_selectNewHQ", AS_commander];
