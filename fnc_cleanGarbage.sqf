#include "macros.hpp"

private _time = diag_tickTime;

[petros,"hint","Deleting Garbage..."] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];

//TODO easy way to check if these have cargo -> do not delete

private _toDelete = nearestObjects [markerPos "AS_base", ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder", "Box_IND_Wps_F"], 16000];
{
	//Recover equipment if near FIA location
	//OPTIMIZATION: consider here to only check for FIA locations
	private _nearest = [[] call AS_location_fnc_all, position _x] call BIS_fnc_nearestPosition;
	if (_nearest call AS_location_fnc_side == "FIA" and {_nearest distance2D _x <= (_nearest call AS_location_fnc_size)}) then {
		([_x, true] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
		[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
		[cajaVeh, _remains] call AS_fnc_addMagazineRemains;
	};


	[_x] remoteExec ["deleteVehicle", _x];
} forEach _toDelete;

//Dead bodies

{
	private _nearest = [[] call AS_location_fnc_all, position _x] call BIS_fnc_nearestPosition;
	if (_nearest call AS_location_fnc_side == "FIA" and {_nearest distance2D _x <= (_nearest call AS_location_fnc_size)}) then {
		([_x, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
		[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
		[cajaVeh, _remains] call AS_fnc_addMagazineRemains;
	};
	_x call AS_fnc_emptyUnit;
	[_x] remoteExec ["AS_fnc_safeDelete", _x];
} forEach allDeadMen;

private _deleteVehicles = vehicles select {!(alive _x)};

{
	private _nearest = [[] call AS_location_fnc_all, position _x] call BIS_fnc_nearestPosition;
	if (_nearest call AS_location_fnc_side == "FIA" and {_nearest distance2D _x <= (_nearest call AS_location_fnc_size)}) then {
		([_x, true] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
		[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
		[cajaVeh, _remains] call AS_fnc_addMagazineRemains;
	};

	if (_x in (AS_P("vehicles"))) then {
		[_x, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
	};
	[_x] remoteExec ["deleteVehicle", _x];
} foreach _deleteVehicles;

//DELETE empty groups

{
	private _group = _x;
	if ({alive _x} count (units _group) == 0) then {
		//This is ok, always run from server
		[_group] remoteExec ["deletegroup", groupOwner _group];
	};
} foreach allGroups;


//TODO consider this, might delete proper objects
/*private _obsoletePersistents = (AS_P("vehicles")) select {
	(((getpos _x) select 2) < -1) //sunken objects
};

{
	[_x, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
} foreach _obsoletePersistents;*/

[petros,"hint","Garbage deleted"] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];

diag_log format ["[AS] Garbage deleted, duration: %1", diag_tickTime - _time];
