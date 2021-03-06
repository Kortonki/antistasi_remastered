#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_lose_location.sqf");
params ["_location"];

if (_location call AS_location_fnc_side == "AAF") exitWith {
	diag_log format ["[AS] Error: AS_fnc_lose_location called for AAF location '%1'", _location];
};

private _posicion = _location call AS_location_fnc_position;
private _type = _location call AS_location_fnc_type;
private _size = _location call AS_location_fnc_size;

[_location,"side","AAF"] call AS_location_fnc_set;

// remove all garrison
// todo: transfer alive garrison to FIA_HQ
[_location, "garrison", []] call AS_location_fnc_set;

// Remove all statics there. Commented, will be done via fcleanup funcition
/* /
private _staticsRemoved = [];
{
	if ((position _x) distance _posicion < _size) then {
		_staticsRemoved pushBack _x;
		deleteVehicle _x;
	};
} forEach AS_P("vehicles");
[_staticsRemoved, false] call AS_fnc_changePersistentVehicles;
*/

if (_type in ["outpost", "outpostAA", "seaport"]) then {
	[10,-10,_posicion] call AS_fnc_changeCitySupport;
	if (_type in ["outpost", "outpostAA"]) then {
		["TaskFailed", ["", "Outpost Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
		{[5, -5,_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
	} else {
		["TaskFailed", ["", "Seaport Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
	};
};
if (_type == "powerplant") then {
	[0,-5] call AS_fnc_changeForeignSupport;
	[10,-10,_posicion] call AS_fnc_changeCitySupport;
	["TaskFailed", ["", "Powerplant Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
	[_location] call AS_fnc_recomputePowerGrid;
};
if (_type in ["resource", "factory"]) then {
	[10,-10,_posicion] call AS_fnc_changeCitySupport;
	[0,-5] call AS_fnc_changeForeignSupport;

	if (_type == "resource") then {
		["TaskFailed", ["", "Resource Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
	} else {
		["TaskFailed", ["", "Factory Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
	};
};
if (_type in ["base", "airfield"]) then {
	[20,-20,_posicion] call AS_fnc_changeCitySupport;
	{[10, -10,_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
	[0,-10] call AS_fnc_changeForeignSupport;
	[_location,60] call AS_location_fnc_increaseBusy;

	if (_type == "base") then {
		["TaskFailed", ["", "Base Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
	} else {
		["TaskFailed", ["", "Airport Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
    };
};

//Recalculate AAF arsenal
{
	[_x, "max", _x call AS_AAFarsenal_fnc_updateMax] call AS_AAFarsenal_fnc_set;
} forEach ([] call AS_AAFarsenal_fnc_all);

waitUntil {sleep 1;
	(not (_location call AS_location_fnc_spawned)) or
	(({(not(vehicle _x isKindOf "Air")) and (alive _x)} count ([_size, _posicion, "BLUFORSpawn"] call AS_fnc_unitsAtDistance)) >
	3*({(alive _x) and (!fleeing _x)} count ([_size, _posicion, "OPFORSpawn"] call AS_fnc_unitsAtDistance)))
};

if (_location call AS_location_fnc_spawned) then {
	[_location] spawn AS_fnc_win_location;
} else {
	[_location] call AS_location_fnc_addRoadblocks;
};
