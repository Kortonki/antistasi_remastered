#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_lose_neutrallocation.sqf");
params ["_location"];

if (!(_location call AS_location_fnc_side == "Neutral")) exitWith {
	diag_log format ["[AS] Error: AS_fnc_lose_neutrallocation called for AAF or FIA location '%1'", _location];
};

private _posicion = _location call AS_location_fnc_position;
private _type = _location call AS_location_fnc_type;
private _size = _location call AS_location_fnc_size;
private _city = [call AS_location_fnc_cities, _posicion] call BIS_fnc_nearestPosition;
private _cityIsFriendly = false;
if (_city call AS_location_fnc_side == "AAF") then { _cityIsFriendly = true};

[_location,"side","AAF"] call AS_location_fnc_set;

// remove all garrison
// todo: transfer alive garrison to FIA_HQ

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

if (_type == "seaport") then {
	if (_cityIsFriendly) then {
	[5,0,_posicion] call AS_fnc_changeCitySupport;
};
	["TaskFailed", ["", "Seaport captured"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
};
if (_type == "powerplant") then {
	[5,0] call AS_fnc_changeForeignSupport;
	if (_cityIsFriendly) then {
	[10,0,_posicion] call AS_fnc_changeCitySupport;
};
	["TaskFailed", ["", "Powerplant captured"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
	[_location] call AS_fnc_recomputePowerGrid;
};
if (_type in ["resource", "factory"]) then {
	if (_cityIsFriendly) then {
	[5,0,_posicion] call AS_fnc_changeCitySupport;
};
	[2,0] call AS_fnc_changeForeignSupport;

	if (_type == "resource") then {
		["TaskFailed", ["", "Resource captured"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
	} else {
		["TaskFailed", ["", "Factory captured"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
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
