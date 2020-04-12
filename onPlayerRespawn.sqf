#include "macros.hpp"

if (isDedicated) exitWith {};
params ["_new", "_old"];



if (player call AS_fnc_controlsAI) exitWith {
	hint "The unit you were controlling died";
	call AS_fnc_completeDropAIcontrol;
	deleteVehicle _new;
};

if (not(isNil "AS_respawning")) exitWith {
	diag_log "[AS] Error: Attempting to respawn while respawning";
};

AS_respawning = true; // avoids double-respawn

// temporarly set the commander locally. It is meant to be overwritten by AS_fnc_spawnPlayer.
if (_old == AS_commander) then {
 //Just in case it's not possible for a group to have two or more commanders. Trying to resolve problem not having HC after respawn
	[_old] remoteExecCall ["hcRemoveAllGroups", 0];

	//AS_commander synchronizeObjectsRemove [HC_comandante];
	//HC_comandante synchronizeObjectsRemove [AS_commander];

	AS_commander = _new;
	publicVariable "AS_commander";
};
private _type = player call AS_fnc_getFIAUnitType;
private _unit = [_type, "kill"] call AS_fnc_spawnPlayer;

waitUntil {player == _unit};

AS_respawning = nil;
