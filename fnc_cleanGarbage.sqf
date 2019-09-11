#include "macros.hpp"

[[petros,"hint","Deleting Garbage..."],"AS_fnc_localCommunication"] call BIS_fnc_MP;

//TODO easy way to check if these have cargo -> do not delete

private _toDelete = nearestObjects [markerPos "AS_base", ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 16000];
{
	[_x] remoteExec ["deleteVehicle", _x];
} forEach _toDelete;
{deleteVehicle _x} forEach allDead;

private _deleteVehicles = vehicles select {!(alive _x)};
{
	[_x] remoteExec ["deleteVehicle", _x];
} foreach _deleteVehicles;

private _obsoletePersistents = (AS_P("vehicles")) select {
	(((getpos _x) select 2) < -1) //sunken objects
};

[[petros,"hint","Garbage deleted"],"AS_fnc_localCommunication"] call BIS_fnc_MP;
