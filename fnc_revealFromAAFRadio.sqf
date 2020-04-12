#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_revealFromAAFRadio.sqf");

private _chance = 5;
{
	private _location = [call AS_location_fnc_all, _x] call BIS_fnc_nearestPosition;
	if ((_location call AS_location_fnc_side == "FIA") and (alive ((nearestObjects [_location call AS_location_fnc_position, AS_antenasTypes, 200]) select 0))) then {
		_chance = _chance + 2.25;
	};
} forEach AS_P("antenasPos_alive");

if (random 100 < _chance) then {
	if !(AS_S("revealFromRadio")) then {
		["TaskSucceeded", ["", (["AAF", "shortname"] call AS_fnc_getEntity) + " Comms Intercepted"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
		AS_Sset("revealFromRadio",true);
		[] remoteExec ["AS_fnc_revealToPlayer", 2];
	};
} else {
	if (AS_S("revealFromRadio")) then {
		["TaskFailed", ["", (["AAF", "shortname"] call AS_fnc_getEntity) + " Comms Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
		AS_Sset("revealFromRadio",false);
	};
};
