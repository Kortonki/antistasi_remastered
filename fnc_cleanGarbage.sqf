#include "macros.hpp"

[petros,"hint","Deleting Garbage..."] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];

//TODO easy way to check if these have cargo -> do not delete

private _toDelete = nearestObjects [markerPos "AS_base", ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder", "Box_IND_Wps_F"], 16000];
{
	[_x] remoteExec ["deleteVehicle", _x];
} forEach _toDelete;
{deleteVehicle _x} forEach allDead;

private _deleteVehicles = vehicles select {!(alive _x)};
{
	[_x] remoteExec ["deleteVehicle", _x];
	if (_x in (AS_P("vehicles"))) then {
		[_x, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
	};
} foreach _deleteVehicles;

//TODO consider this, might delete proper objects
/*private _obsoletePersistents = (AS_P("vehicles")) select {
	(((getpos _x) select 2) < -1) //sunken objects
};

{
	[_x, false] remoteExec ["AS_fnc_changePersistentVehicles", 2];
} foreach _obsoletePersistents;*/

[petros,"hint","Garbage deleted"] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];
