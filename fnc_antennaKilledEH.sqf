#include "macros.hpp"
params ["_antenna"];
private _antennaPos = [(AS_P("antenasPos_alive")), getpos _antenna] call bis_fnc_NearestPosition;
AS_Pset("antenasPos_alive", AS_P("antenasPos_alive") - [_antennaPos]);
AS_Pset("antenasPos_dead", AS_P("antenasPos_dead") + [_antennaPos]);
[["TaskSucceeded", ["", "Radio Tower Destroyed"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
["TaskSucceeded", ["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotificatio", [0, -2] select isDedicated];
_antenna removeAllEventHandlers "Killed";
