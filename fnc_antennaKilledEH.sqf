#include "macros.hpp"
params ["_antenna"];
private _type = typeof _antenna;
private _antennaPos = [(AS_P("antenasPos_alive")), getpos _antenna] call bis_fnc_NearestPosition;
AS_Pset("antenasPos_alive", AS_P("antenasPos_alive") - [_antennaPos]);
AS_Pset("antenasPos_dead", AS_P("antenasPos_dead") + [_antennaPos]);
["TaskSucceeded", ["", "Radio Tower Destroyed"]] remoteExec ["BIS_fnc_showNotification", [0, -2] select isDedicated];
_antenna removeAllEventHandlers "Killed";

private _marker = [allMapMarkers select {markerType _x == "loc_Transmitter"}, _antennaPos] call BIS_fnc_nearestPosition;
_marker setMarkerType "hd_destroy";
_marker setMarkerColor "ColorRed";

//Store antenna type into mission name space
private _typeVarName = format ["%1_type", _marker];
missionNameSpace setVariable [_typeVarName, _type, true];

//FIA gets city support penalty for destroying their radio coverage
[-5,-5,_antennaPos, true] remoteExec ["AS_fnc_changeCitySupport", 2];

//Distortin in AAF organization

[30*60] remoteExec ["AS_fnc_changeSecondsforAAFattack", 2];
