#include "macros.hpp"

if (alive petros) exitWith {
  [AS_commander, "hint", "Petros is alive"] calL AS_fnc_localCommunication;
};

//TODO: Consider making the nearby enemies check when there's other ways to force a new HQ
/*if ([getmarkerPos "FIA_HQ",500] call AS_fnc_enemiesNearby) exitWith {
  [AS_commander, "hint", "Enemies nearby, can't respawn Petros"] remoteExec ["AS_fnc_localCommunication", AS_commander];
};*/

[] remoteExecCall ["AS_fnc_initPetros", 2];

waitUntil {sleep 5; alive petros};

[petros, "sideChat", "Radio Check. Petros is ready at the HQ"] call AS_fnc_localCommunication;
