#include "../../macros.hpp"

private _fnc_initialize = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	private _foundSuitablePlace = false;
	private _posCmp = "";
	private _dirveh = 0;
	{
		// roads farther than 150m and closer than 300m
		private _road = _x;
		if ((_road distance _position > 150) and (_road distance _position < 300)) then {
			private _road2 = (_road nearRoads 5) select 0;
			if (!isNil "_road2") then {
				private _p2 = getPos ((roadsConnectedto _road2) select 0);
				_posCmp = [_road, 8, ([_road,_p2] call BIS_fnc_DirTo) + 90] call BIS_Fnc_relPos;
				_dirveh = [_posCmp,_road] call BIS_fnc_DirTo;
				if (count (nearestObjects [_posCmp, [], 6]) < 1) then {
					_foundSuitablePlace = true;
				};
			};
		};
		if _foundSuitablePlace exitWith {};
	} forEach (([_location, "roads"] call AS_location_fnc_get) call AS_fnc_shuffle);

	if not _foundSuitablePlace exitWith {
		[[petros, "globalChat", "Dealer cancelled the deal."],"AS_fnc_localCommunication"] call BIS_fnc_MP;
		_mission call AS_mission_fnc_remove;

		// set the spawn state to `run` so that the next one is `clean`, since this ends the mission
		[_mission, "state_index", 3] call AS_spawn_fnc_set;
	};

	private _tiempolim = 120;
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];

	private _tskTitle = _mission call AS_mission_fnc_title;
	private _tskDesc = format [localize "Str_tskDesc_fndExp",
		[_location] call AS_fnc_location_name,
		numberToDate [2035,dateToNumber _fechalim] select 3,
		numberToDate [2035,dateToNumber _fechalim] select 4];

	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
	[_mission, "campDisposition", [_posCmp, _dirveh]] call AS_spawn_fnc_set;
	[_mission, [_tskDesc,_tskTitle,_location], _position, "Find"] call AS_mission_spawn_fnc_saveTask;
};

private _fnc_spawn = {
	params ["_mission"];
	([_mission, "campDisposition"] call AS_spawn_fnc_get) params ["_posCmp", "_dirveh"];

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	private _objs = [_posCmp, _dirveh, call AS_fnc_dealerComposition] call BIS_fnc_ObjectsMapper;

	private _groupDev = createGroup ("FIA" call AS_fnc_getFactionSide);
	private _dealer = _groupDev createUnit ["C_Nikos", [0,0,0], [], 0.9, "NONE"];
	_dealer allowDamage false;
	_dealer setPos _posCmp;
	_dealer setDir _dirveh;
	_dealer removeWeaponGlobal (primaryWeapon _dealer);
	//_dealer disableAI "MOVE";
	//_dealer setunitpos "up";
	_dealer setCaptive true;
	_dealer allowfleeing 0;
	_dealer setBehaviour "SAFE";
	_dealer stop true;

	//Arm the guy with pistol
	private _dweapon = (selectRandom (AS_weapons select 4));
	_dealer addWeapon _dweapon;
	private _magtype = (selectRandom ((AS_allWeaponsAttrs select (AS_allWeapons find _dweapon)) select 2));
	_dealer addMagazines [_magtype, 4];

	{
		call {
			if (str typeof _x find "Box_IND_Wps_F" > -1) exitWith {expCrate = _x; [expCrate] call AS_fnc_emptyCrate;};
			if (str typeof _x find "Box_Syndicate_Wps_F" > -1) exitWith { [_x] call AS_fnc_emptyCrate;};
			if (str typeof _x find "Box_IED_Exp_F" > -1) exitWith { [_x] call AS_fnc_emptyCrate;};
		};
	} forEach _objs;

	[_mission, "dealer", _dealer] call AS_spawn_fnc_set;
	[_mission, "resources", [_task, [_groupDev], _objs, []]] call AS_spawn_fnc_set;
};

private _fnc_wait_to_arrive = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _dealer = [_mission, "dealer"] call AS_spawn_fnc_get;
	private _posCmp = ([_mission, "campDisposition"] call AS_spawn_fnc_get) select 0;

	private _fnc_missionFailedCondition = {(dateToNumber date > _max_date) or !(alive _dealer)};

	private _missionStartCondition = {
		{_x distance _dealer < 200} count (allPlayers - (entities "HeadlessClient_F")) > 0
	};

	waitUntil {sleep 1; False or _missionStartCondition or _fnc_missionFailedCondition};

	if (call _fnc_missionFailedCondition) then {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		_mission remoteExec ["AS_mission_fnc_fail", 2];
		// set the spawn state to `run` so that the next one is `clean`, since this ends the mission
		[_mission, "state_index", 3] call AS_spawn_fnc_set;
	} else {
		_dealer allowDamage true;
		[["spawnCSAT", _posCmp, _location, 15, "transport", "small"], "AS_movement_fnc_sendEnemyQRF"] remoteExec ["AS_scheduler_fnc_execute", 2];
	};
};

private _fnc_wait_to_end = {
	params ["_mission"];
	private _dealer = [_mission, "dealer"] call AS_spawn_fnc_get;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;

	private _fnc_missionFailedCondition = {(dateToNumber date > _max_date) or !(alive _dealer)};

	private _fnc_missionFailed = {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];
	};
	private _fnc_missionSuccessfulCondition = {
		{((side _x isEqualTo ("FIA" call AS_fnc_getFactionSide)) or (side _x isEqualTo civilian)) and
		  (_x distance _dealer < 10)} count allPlayers > 0
	};
	private _fnc_missionSuccessful = {
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

		//[[_dealer,"buy_exp"],"AS_fnc_addAction"] call BIS_fnc_MP;
		[_dealer, "buy_exp"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
		[_dealer, false] remoteExecCall ["setcaptive", _dealer];
		[_dealer, 1] remoteExecCall ["allowFleeing", _dealer];
		_dealer stop false;

		[_mission] remoteExec ["AS_mission_fnc_success", 2];
	};

	[_fnc_missionFailedCondition, _fnc_missionFailed, _fnc_missionSuccessfulCondition, _fnc_missionSuccessful] call AS_fnc_oneStepMission;

	//The dealer will wait for 15 minutes
	private _time = time + 15*60;
	waitUntil {sleep 1; (time > _time or dateToNumber date > _max_date) or !(alive _dealer) or (fleeing _dealer)};


	//[[_dealer,"remove"],"AS_fnc_addAction"] call BIS_fnc_MP;
	[_dealer, "remove"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
	if (alive _dealer) then {
		//_dealer enableAI "ANIM";
		//_dealer enableAI "MOVE";
		[_dealer, "globalChat", "That's it, i'm out of here!"] call AS_fnc_localCommunication;
		_dealer doMove ((selectRandom ("resource" call AS_location_fnc_T)) call AS_location_fnc_position);
	};
};

AS_mission_blackMarket_states = ["initialize", "spawn", "wait_to_arrive", "wait_to_end", "clean"];
AS_mission_blackMarket_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_wait_to_arrive,
	_fnc_wait_to_end,
	AS_mission_spawn_fnc_clean
];
