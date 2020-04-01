params ["_location"];

//If the location not spawned, no need to respawn things

if !(_location call AS_spawn_fnc_exists) exitWith {};

//Get spawned location states and set it to last state (clean state). That will make the location respawn


//This will end the run state of locations and start the cleanup and deletion of the spawn. Then it will respawn after a delay.
//forced_spawned not added so garrison can't be increased when attack is on its way
[_location, "spawned", false] call AS_location_fnc_set;
//[_location, "forced_spawned", false] call AS_location_fnc_set;


//Clean vehicles asap because despawn might not trigger before respawning vehicles (unusual despawning) b
//Exclude cars and ammoboxes
//Cleaning resources is triggered via above and will remove markers group etc. properly

([_location, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];

{
 [_x] remoteExec ["deleteVehicle", _x];
} foreach (_vehicles select {!(_x isKindof "B_supplyCrate_F") and {!(_x isKindof "AllVehicles")}});
