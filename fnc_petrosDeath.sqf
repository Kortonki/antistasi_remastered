#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_petrosDeath");

//This is probablyn not needed, as the HQ is not moved
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

{"Petros is Dead" hintC "Petros has been killed. You lot part of your influence. You can respawn Petros when there's no enemies nearby HQ"} remoteExec ["bis_fnc_call", AS_commander];
{hint "Petros is Dead"} remoteExec ["bis_fnc_call", [0,-2] select isDedicated];

//This is unnecessary. Petros death' no longer forces player to move HQ
//waitUntil {sleep 5; isPlayer AS_commander};
//[] remoteExec ["AS_fnc_selectNewHQ", AS_commander];
