#include "../../macros.hpp"

#define MAX_TIME 60

private _fnc_initialize = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	// mission timer
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + MAX_TIME];

	private _tskTitle = _mission call AS_mission_fnc_title;
	private _tskDesc = format [localize "STR_tskDesc_PRBrain",
		[_location] call AS_fnc_location_name,
		numberToDate [2035,dateToNumber _fechalim] select 3,
		numberToDate [2035,dateToNumber _fechalim] select 4];

	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
	[_mission, "position", _position] call AS_spawn_fnc_set;
	[_mission, [_tskDesc,_tskTitle,_location], _position, "Heal"] call AS_mission_spawn_fnc_saveTask;
};

private _fnc_spawn = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = [_mission, "position"] call AS_spawn_fnc_get;

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	// find bases and airports to serve as spawnpoints for reinforcements
	private _bases = [];
	{
		private _posbase = _x call AS_location_fnc_position;
		if ((_position distance2D _posbase < 7500) and
		    (_position distance2D _posbase > 1500) and !(_x call AS_location_fnc_spawned)) then {
			_bases pushBack _x;
		};
	} forEach (["base", "AAF"] call AS_location_fnc_TS);

	private _base = "";
	if (count _bases > 0) then {
		_base = [_bases,_position] call BIS_fnc_nearestPosition;
	};

	private _airports = [];
	{
		private _posAirport = _x call AS_location_fnc_position;
		if ((_position distance2D _posAirport < 20000) and
		    (_position distance2D _posAirport > 3000) and
			!(_x call AS_location_fnc_spawned)) then {
			_airports pushBack _x;
		};
	} forEach (["airfield", "AAF"] call AS_location_fnc_TS);
	private _airport = "";
	if (count _airports > 0) then {
		_airport = [_airports, _position] call BIS_fnc_nearestPosition;
	};

	// spawn mission vehicle
	private _propTruck = [selectRandom (["FIA", "vans"] call AS_fnc_getEntity), getpos vehiclePad, "FIA"] call AS_fnc_createEmptyVehicle;
	[_propTruck] remoteExec ["AS_fnc_changePersistentVehicles", 2];
	[0,-600] remoteExec ["AS_fnc_changeFIAMoney", 2];
	//publicVariable "_propTruck";

	// spawn eye candy
	private _grafArray = [];
	private _graf1 = "Land_Graffiti_02_F" createVehicle [0,0,0];
	_graf1 attachTo [_propTruck,[-1.32,-2.5,-0.15]];
	_graf1 setDir (getDir _propTruck + 90);
	_grafArray pushBack _graf1;

	private _graf2 = "Land_Graffiti_05_F" createVehicle [0,0,0];
	_graf2 attachTo [_propTruck,[-1.32,0.6,-0.5]];
	_graf2 setDir (getDir _propTruck + 90);
	_grafArray pushBack _graf2;

	private _graf3 = "Land_Graffiti_05_F" createVehicle [0,0,0];
	_graf3 attachTo [_propTruck,[1.32,0.6,-0.5]];
	_graf3 setDir (getDir _propTruck + 270);
	_grafArray pushBack _graf3;

	private _graf4 = "Land_Graffiti_03_F" createVehicle [0,0,0];
	_graf4 attachTo [_propTruck,[1.32,-2.5,-0.15]];
	_graf4 setDir (getDir _propTruck + 270);
	_grafArray pushBack _graf4;

	// initialize mission vehicle
	{_x reveal _propTruck} forEach (allPlayers - (entities "HeadlessClient_F"));
	_propTruck setVariable ["destino", [_location] call AS_fnc_location_name, true];
	_propTruck addEventHandler ["GetIn", {
		if (_this select 1 == "driver") then {
			private _texto = format ["Bring this gear to %1",(_this select 0) getVariable "destino"];
			_texto remoteExecCall ["hint",_this select 2];
		};
	}];
	//[_propTruck,"Mission Vehicle"] spawn AS_fnc_setConvoyImmune;

	// set the flags for active item and active broadcast
	//AS_Sset("activeItem", _propTruck);
	_propTruck setVariable ["BCactive", false, true];

	// dispatch a small QRF
	private _qrf_specs = [_base, _position, _location, MAX_TIME, "transport", "small"];
	if (_airport != "") then {
		_qrf_specs set [0, _airport];
	};
	[_qrf_specs, "AS_movement_fnc_sendEnemyQRF"] remoteExec ["AS_scheduler_fnc_execute", 2];

	[_mission, "resources", [_task, [], _grafArray + [_propTruck], []]] call AS_spawn_fnc_set;
};

private _fnc_wait_to_arrive = {
	params ["_mission"];
	private _position = [_mission, "position"] call AS_spawn_fnc_get;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _propTruck = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 4;

	private _fnc_missionFailedCondition = {(dateToNumber date > _max_date) or (not alive _propTruck)};

	// wait until the vehicle enters the target area
	waitUntil {sleep 1; (_propTruck distance2D _position < 150) or _fnc_missionFailedCondition};

	if (call _fnc_missionFailedCondition) then {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];

		// we set the spawn state to `run` so that the next one is `clean`, since this ends the mission
		[_mission, "state_index", 5] call AS_spawn_fnc_set;
	};
};

private _fnc_wait_to_activate = {
	params ["_mission"];
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _position = [_mission, "position"] call AS_spawn_fnc_get;
	private _propTruck = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 4;

	private _fnc_missionFailedCondition = {(dateToNumber date > _max_date) or (not alive _propTruck)};

	while {not (_propTruck getVariable ["BCactive", false] or _fnc_missionFailedCondition)} do {
		private _active = false;
		while {(_propTruck distance _position < 150) and
			not (_propTruck getVariable ["BCactive", false] or _fnc_missionFailedCondition)} do {
			// activate if it is not moving
			if (not _active and (speed _propTruck < 1)) then {
				_active = true;
				[_propTruck, "toggle_device"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
				_propTruck setVariable ["BCdisabled", false, true];
			};
			// deactivate if it moves
			if (_active and (speed _propTruck > 1)) then {
				_active = false;
				[_propTruck, "remove"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
				_propTruck setVariable ["BCdisabled", true, true];
			};
			sleep 1;
		};
		sleep 1;
	};

	if (call _fnc_missionFailedCondition) then {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];

		// we set the spawn state to `run` so that the next one is `clean`, since this ends the mission
		[_mission, "state_index", 5] call AS_spawn_fnc_set;
	};
};

private _fnc_spawn_activator = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _propTruck = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 4;
	// create & spawn the propaganda site
	private _PRsite = [
		["Land_BagFence_Round_F",[1.57227,1.87622,-0.00130129],99.7986,1,0,[0,-0],"","",true,false],
		["Land_Sacks_heap_F",[2.81982,-0.622803,0],323.257,1,0,[0,0],"","",true,false],
		["Land_Loudspeakers_F",[3.146,0.9729,0],0,1,0,[0,0],"","",true,false],
		["Land_PortableLight_single_F",[3.54053,-2.40137,0],228.698,1,0,[0,0],"","",true,false],
		["Land_Leaflet_02_F",[4.14307,-1.47192,0.688],183.52,1,0,[-90,-90],"","",true,false],
		["Land_Leaflet_02_F",[4.1499,-1.65796,0.688],180,1,0,[-90,-90],"","",true,false],
		["Land_WoodenBox_F",[4.52734,0.615967,4.76837e-007],152.102,1,0,[6.94714e-005,1.89471e-005],"","",true,false],
		["Land_Leaflet_02_F",[4.2959,-1.56104,0.688],198.517,1,0,[-90,-90],"","",true,false],
		["Land_Leaflet_02_F",[4.27979,-1.82007,0.688],216.361,1,0,[-90,-90],"","",true,false],
		["Land_Leaflet_02_F",[4.49463,-1.39014,0.688],156.16,1,0,[-90,-90],"","",true,false],
		["Land_WoodenCrate_01_F",[4.44775,-1.86304,4.76837e-007],0.000621233,1,0.0256633,[-5.14494e-005,-0.000126096],"","",true,false],
		["Land_WoodenBox_F",[4.82568,0.0627441,0],329.984,1,0,[-4.90935e-005,1.14739e-006],"","",true,false],
		["Land_BagFence_Round_F",[3.896,3.3252,-0.00130129],193.76,1,0,[0,0],"","",true,false],
		["Land_Leaflet_02_F",[4.58105,-1.7041,0.688],127.235,1,0,[-90,-90],"","",true,false],
		["Land_WoodenCrate_01_stack_x3_F",[3.84229,-3.79712,0],0,1,0,[0,0],"","",true,false],
		[["FIA", "flag"] call AS_fnc_getEntity,[5.04297,-2.52319,0],0,1,0,[0,0],"","",true,false],
		["Land_Sacks_heap_F",[6.08154,1.64722,0],27.137,1,0,[0,0],"","",true,false],
		["Land_PortableLight_single_F",[5.90527,2.94946,0],18.0931,1,0,[0,0],"","",true,false],
		["Land_Graffiti_05_F",[6.84229,-0.0407715,2.28578],128.676,1,0,[0,-0],"","",true,false],
		["SignAd_SponsorS_F",[6.84619,-0.0651855,6.67572e-006],130.045,1,0,[0,-0],"","",true,false]
	];

	private _posSiteBackup = (position _propTruck) findEmptyPosition [1,25,typeOf _propTruck];
	private _posSite = [position _propTruck, 0, 20, 2, 0, 0.3, 0, [], [_posSiteBackup,[]]] call BIS_Fnc_findSafePos;
	private _objectsToDelete = [_posSite, random 360, _PRsite] call BIS_fnc_ObjectsMapper;

	// remove crew from the truck, lock it, turn off the engine
	{
		_x action ["eject", _propTruck];
	} forEach (crew _propTruck);
	_propTruck lock 2;
	_propTruck engineOn false;

	// reveal the truck's location to all nearby enemies, blow the cover of all nearby friendlies
	{
		private _amigo = _x;
		if (captive _amigo) then {
			[_amigo,false] remoteExec ["setCaptive",_amigo];
		};
		{
			if ((side _x == ("AAF" call AS_fnc_getFactionSide)) and (_x distance2D _propTruck < AS_P("spawnDistance"))) then {
				if (_x distance2D _propTruck < 300) then {_x doMove position _propTruck}; //Reveal removed, unrealistic
			};
		} forEach allUnits;
	} forEach ([300, _propTruck, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);

	// trigger attack wave
	/*
	trigger the attack waves
	parameters:
	_timing: launch of a specific wave, time in minutes after the activation of the device
	_comp: type of wave, see fnc_spawnAttackWaves.sqf for details

	default setting based on number of players online
	*/
	private	_timing = [0,5,10,20];
	private _comp = ["QRF_air_mixed_small", "QRF_land_mixed_large", "QRF_land_transport_large","CSAT_small"];

	[_location, 30, _timing, _comp] spawn AS_fnc_spawnAttackWaves;

	([_mission, "ASSIGNED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	private _resources = [_mission, "resources"] call AS_spawn_fnc_get;
	(_resources select 2) append _objectsToDelete;
	[_mission, "resources", _resources] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_mission"];
	private _propTruck = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 4;

	private _fnc_missionFailedCondition = {not (alive _propTruck)};

	// counter stops forever when no player within 300m or car deactivated
	private _fnc_continueCounterCondition = {
		_propTruck getVariable ["BCactive", false] and
		({(side _x isEqualTo ("FIA" call AS_fnc_getFactionSide)) and (_x distance _propTruck < 300)} count allPlayers > 0) and {not call _fnc_missionFailedCondition}
	};

	// counter increases when no enemy within 50m and anyone conscious
	private _fnc_increaseCounterCondition = {
		{_x call AS_medical_fnc_isUnconscious} count ([300, _propTruck, "BLUFORSpawn"] call AS_fnc_unitsAtDistance) !=
		 count ([300, _propTruck, "BLUFORSpawn"] call AS_fnc_unitsAtDistance) and
		({(side _x == ("AAF" call AS_fnc_getFactionSide)) and (_x distance _propTruck < 50)} count allUnits == 0)
	};

	/*
	_minTimer: duration before the mission is not a failure
	_counter: counts current duration
	_active: flag for running counter
	*/
	private _minTimer = 600;
	private _counter = 0;
	private _active = false;
	while _fnc_continueCounterCondition do {
		while {True and _fnc_continueCounterCondition and _fnc_increaseCounterCondition} do {

			// activate the timer
			if !(_active) then {
				_active = true;
				[petros,"globalChat","Hold this position for as long as you can! They will throw a lot at you, so be prepared!"] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];
			};

			{
				// warn players at the edge of the area to not stray too far
				private _distance = _x distance _propTruck;
				if (_distance > 250 and _distance < 350) then {
					[petros,"hint", "stay within 250m of the station!"] remoteExec ["AS_fnc_localCommunication", _x];
				};
			} forEach (allPlayers - (entities "HeadlessClient_F"));

			_counter = _counter + 1;
			sleep 1;
		};

		// suspend the counter
		if (not call _fnc_increaseCounterCondition) then {
			_active = false;

			if (not call _fnc_missionFailedCondition) then {
				[petros,"globalChat","Hostile forces near the position"] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];
			};

			waitUntil {sleep 1; call _fnc_increaseCounterCondition or {not call _fnc_continueCounterCondition}};
		};
	};

	// stop the attack script from spawning additional waves
	AS_Sset("waves_active", false);

	// 10 city support for 10 minutes plus 1 for every additional 60 seconds
	private _prestige = 0;
	if (_counter >= _minTimer) then {
		_prestige = 10 + floor ((_counter - _minTimer) / 60);
	};

	// inform players about timer at the end of the mission
	private _info = format ["You held the area clear for %1 minutes and %2 seconds.", floor (_counter / 60), _counter mod 60];
	if (_prestige == 0) then {
		_info = format ["You only held the area for %1 minutes and %2 seconds. That is unacceptable.", floor (_counter / 60), _counter mod 60];
	};
	{
		if (isPlayer _x) then {
			[petros,"globalChat", _info] remoteExec ["AS_fnc_localCommunication",_x]
		}
	} forEach ([300, _propTruck, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);

	// failure if you held out for less than 10 minutes
	if (_prestige == 0) then {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];
	} else {
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission, [_prestige]] remoteExec ["AS_mission_fnc_success", 2];
	};
};

AS_mission_broadcast_states = ["initialize", "spawn", "wait_to_arrive",
	"wait_to_activate", "spawn_activator", "run", "clean"];
AS_mission_broadcast_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_wait_to_arrive,
	_fnc_wait_to_activate,
	_fnc_spawn_activator,
	_fnc_run,
	AS_mission_spawn_fnc_clean
];
