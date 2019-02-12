#include "macros.hpp"
params ["_unit"];


if (player call AS_fnc_controlsAI) exitWith {
	diag_log "[AS] Error: unit was respawned while controlling an AI";
	call AS_fnc_completeDropAIcontrol;
};
if not isPlayer _unit exitWith {
	diag_log "[AS] Error: non-player was respawned";
};



["Respawning",0,0,3,0,0,4] spawn bis_fnc_dynamicText;
titleText ["", "BLACK IN", 0];


	[_unit, _unit] call compile preprocessFileLineNumbers "onPlayerRespawn.sqf";
