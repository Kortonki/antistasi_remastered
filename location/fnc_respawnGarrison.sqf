params ["_location"];

//If the location not spawned, no need to respawn things

if (_location call AS_spawn_fnc_exists) exitWith {};

//Get spawned location states and set it to last state (clean state). That will make the location respawn


//This will end the run state of locations and start the cleanup and deletion of the spawn. Then it will respawn after a delay.
[_location, "spawned", false] call AS_location_fnc_set;
