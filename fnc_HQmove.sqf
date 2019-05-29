#include "macros.hpp"
AS_SERVER_ONLY("fnc_HQmove.sqf");

petros enableAI "MOVE";
petros enableAI "AUTOTARGET";
petros forceSpeed -1;

[petros, "remove"] remoteExec ["AS_fnc_addaction", [0,-2] select isDedicated, true];
//call AS_fnc_rearmPetros; //no reason for this
[petros] join AS_commander;
petros setBehaviour "AWARE";

if isMultiplayer then {
	{_x hideObjectGlobal true} forEach AS_permanent_HQplacements;
} else {
	{_x hideObject true} forEach AS_permanent_HQplacements;
};

//TODO: maybe some kind of a delay here? or let hq objects despawn when in distance
"delete" call AS_fnc_HQaddObject;

AS_HQ_moving = true;

sleep 5;

[petros, "buildHQ"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated, true];
petros setVariable ["pos", position petros, true];

["fia_hq"] call AS_fnc_garrisonRelease;
