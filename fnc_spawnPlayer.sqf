#include "macros.hpp"
AS_CLIENT_ONLY("fnc_spawnPlayer");
params ["_type", ["_oldFate", "delete"]];

call AS_fnc_completeDropAIcontrol;

private _isCommander = (player == AS_commander);
/*private _default_score = 0;
if _isCommander then {_default_score = 25}; // so the commander does not lose the position immediately.*/

private _group = createGroup ("FIA" call AS_fnc_getFactionSide);

private _old_player = player;
private _position = ((getMarkerPos "FIA_HQ") findEmptyPosition [1, 50, "C_Offroad_01_F"]);
private _compromised = player getvariable ["compromised", 0];
private _punish = player getVariable ["punish", 0];

private _unit = [_type, _position, _group] call AS_fnc_spawnFIAunit;

_unit setVariable ["BLUFORSpawn", true, true]; // players make things spawn

_unit setvariable ["compromised", _compromised];
_unit setVariable ["punish", _punish, true];

selectPlayer _unit;


[_unit] call AS_fnc_emptyUnit;
_unit call AS_fnc_equipDefault;

//Make player undercover on respawn (ability to escape conquered hq for example)
_unit forceAddUniform (selectRandom CIVUniforms);
//sleep for good measure to account for uniform change
waitUntil {player == _unit};
[false] spawn AS_fnc_activateUndercover;


if _isCommander then {
	[_unit] remoteExec ["AS_fnc_setCommander", 2];
};


// loads traits, rank, etc.
call AS_players_fnc_loadLocal;

// init event handlers, medic, etc.
call AS_fnc_initPlayer;

private _money = AS_P("resourcesFIA");

//This is reimbursed in start game. Player HR is returned in disconnect and savegame so player rejoining should cost the same

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
						[0,-1, _x] remoteExec ["AS_fnc_changeCitySupport", 2];
					} foreach ([] call AS_location_fnc_cities);
				};

		} else {
			[-1, -50] remoteExec ["AS_fnc_changeFIAMoney", 2];
		};



};

//Waituntil missions init to get tasks at game load
waitUntil {sleep 0.5; !(isNil "AS_dataInitialized")};

// Reassign player tasks (temporary fix for tasks disappearing after respawn)
//EXPERIMENT to avoid task spam each player respawn
private _tasks = _old_player call BIS_fnc_tasksUnit;
{
	//_x call BIS_fnc_taskSetCurrent;

	[_x, false, false] call bis_fnc_setTaskLocal;
} foreach _tasks;

if (_oldFate == "delete") then {

		{deleteVehicle _x} forEach units group _old_player;
		deleteGroup group _old_player;
};
if (_oldFate == "kill") then {
    {[_x] joinsilent group player} forEach (units group _old_player);
    group player selectLeader player;
		[player, {(group _this) setgroupOwner (owner _this)}] remoteExec ["call", 2]; //This here an attempt to fix bug where arma crashes when player team members enter vehicles after player death or disconnect
		deletegroup (group _old_player);
		deleteVehicle _old_player;
};

// remove any progress bar the player had
[0,true] remoteExec ["AS_fnc_showProgressBar",player];

_unit setVariable ["inited", true, true];

_unit
