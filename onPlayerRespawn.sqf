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
	hcRemoveAllGroups  _old; //Just in case it's not possible for a group to have two or more commanders. Trying to resolve problem not having HC after respawn
	[_old] remoteExecCall ["hcRemoveAllGroups", 0];

	//AS_commander synchronizeObjectsRemove [HC_comandante];
	//HC_comandante synchronizeObjectsRemove [AS_commander];

	AS_commander = _new;
	publicVariable "AS_commander";
};
private _type = player call AS_fnc_getFIAUnitType;
private _unit = [_type, "kill"] call AS_fnc_spawnPlayer;

waitUntil {player == _unit};

private _money = AS_P("resourcesFIA");

if isMultiplayer then {
	//private _money = [player, "money"] call AS_players_fnc_get;
	//[player, "money", -round (0.1*_money)] remoteExec ["AS_players_fnc_change", 2];


	if (_money < 50) then {
		[-1, 0] remoteExec ["AS_fnc_changeFIAMoney", 2];
		if (([player, "money"] call AS_players_fnc_get) >= 50)
		then {
			[player, "money", -50] remoteExec ["AS_players_fnc_change", 2];
		} else {
			if ((AS_P("NATOsupport")) >= 2) then {
				[-2, 0] remoteExec ["AS_fnc_changeForeignSupport", 2];
			} else {
				{
					[0,-1, _x] call AS_fnc_changeCitySupport;
				} foreach ([] call AS_location_fnc_cities);
			};

		};
	} else {
		[-1, -50] remoteExec ["AS_fnc_changeFIAMoney", 2];
	};

} else {

		if (_money < 50) then {
			[-1, 0] remoteExec ["AS_fnc_changeFIAMoney", 2];
				if ((AS_P("NATOsupport")) >= 2) then {
					[-2, 0] remoteExec ["AS_fnc_changeForeignSupport", 2];
				} else {
					{
						[0,-1, _x] call AS_fnc_changeCitySupport;
					} foreach ([] call AS_location_fnc_cities);
				};

		} else {
			[-1, -50] remoteExec ["AS_fnc_changeFIAMoney", 2];
		};



};

AS_respawning = nil;
