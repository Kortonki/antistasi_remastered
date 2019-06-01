#include "macros.hpp"
AS_SERVER_ONLY("fnc_HQbuild.sqf");

[petros] join grupoPetros;

[petros, "remove"] remoteExec ["AS_fnc_addAction", AS_CLIENTS];
[petros, "mission"] remoteExec ["AS_fnc_addAction", AS_CLIENTS];
petros forceSpeed 0;

["fia_hq", "position", getPos petros] call AS_location_fnc_set;
if ((getpos petros) distance2D (petros getVariable ["pos", [0,0,0]]) >= 500) then {
	//If new FIA HQ is far enough from the old one, AAF has to discover it again
	["fia_hq", false] call AS_location_fnc_knownLocations;
};

// place everything on its place
call AS_fnc_HQdeploy;

// and then show everything
if isMultiplayer then {
	{_x hideObjectGlobal false} forEach AS_permanent_HQplacements;
} else {
	{_x hideObject false} forEach AS_permanent_HQplacements;
};

AS_HQ_moving = nil;
publicVariable "AS_HQ_moving"; //This is used to check for group dismission
