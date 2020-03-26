#include "../../macros.hpp"

private _fnc_initialize = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	private _tiempolim = 720;
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];

	private _taskTitle = _mission call AS_mission_fnc_title;
	private _taskDesc = format [localize "STR_tskDesc_logSupply",
		[_location] call AS_fnc_location_name,
		_location,
		numberToDate [2035,dateToNumber _fechalim] select 3,
		numberToDate [2035,dateToNumber _fechalim] select 4
	];

	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
	[_mission, "position", _position] call AS_spawn_fnc_set;
	[_mission, [_taskDesc,_taskTitle,_location], _position, "Heal"] call AS_mission_spawn_fnc_saveTask;
};

private _fnc_spawn = {
	params ["_mission"];

	private _location = _mission call AS_mission_fnc_location;

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	private _crateType = ["CIV", "box"] call AS_fnc_getEntity;
	private _pos = (getMarkerPos "FIA_HQ") findEmptyPosition [1,50,_crateType];

	if (!(isnull vehiclePad)) then  {_pos = getpos vehiclePad};

	private _crate = _crateType createVehicle _pos;
	[0,-100] remoteExec ["AS_fnc_changeFIAMoney", 2];
	[_crate] call AS_fnc_emptyCrate;
	//_crate addItemCargoGlobal ["FirstAidKit", 80]; //Removed to not be able to exploit med supplies
	[_crate, "loadCargo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
	_crate setVariable ["asCargo", false, true];
	_crate setVariable ["requiredVehs", ["Truck_F"], true];
	_crate setVariable ["dest", _location, true];
	//{_x reveal _crate} forEach (allPlayers - (entities "HeadlessClient_F"));

	[_mission, "resources", [_task, [], [_crate], []]] call AS_spawn_fnc_set;
};

private _fnc_wait = {
	params ["_mission"];
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _crate = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 0;
	private _location = _mission call AS_mission_fnc_location;
	private _position = [_mission, "position"] call AS_spawn_fnc_get;

	private _fnc_missionFailedCondition = {
		(not alive _crate) or (dateToNumber date > _max_date)
	};

	waitUntil {sleep 1; ((_crate distance2D _position < 100) and (speed _crate < 1)) or _fnc_missionFailedCondition};

	if (call _fnc_missionFailedCondition) exitWith {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];

		// set the spawn state to `run` so that the next one is `clean`, since this ends the mission
		[_mission, "state_index", 3] call AS_spawn_fnc_set;
	};
};

private _fnc_run = {
	params ["_mission"];
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _crate = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 0;
	private _location = _mission call AS_mission_fnc_location;
	private _position = [_mission, "position"] call AS_spawn_fnc_get;

	//Random chance for AAF patrol to be called by the civilians
	if (([_location, "AAFsupport"] call AS_location_fnc_get / [_location, "FIAsupport"] call AS_location_fnc_get) > (random 2)) then {
		[[_position], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
	};

	private _fnc_unloadCondition = {
		// The condition to allow loading the crates into the truck
		(_crate distance2D _position < 100) and {not(_crate getVariable ["asCargo", false]) or (isNull attachedTo _crate)} and
		{{alive _x and not (_x call AS_medical_fnc_isUnconscious)} count ([50, _crate, "BLUFORSpawn"] call AS_fnc_unitsAtDistance) > 0} and
		{{!(side _x in [("FIA" call AS_fnc_getFactionSide), civilian]) and {!(_x call AS_fnc_isDog)} and {_x distance _crate < 50} and {!(_x call AS_medical_fnc_isUnconscious)}} count allUnits == 0}
	};

	private _str_unloadStopped = "Have someone close to the crate and no enemies around";
	private _str_unloadStart = "Guard the crate!";

	// make all FIA around the truck non-captive
	[_mission, _crate] spawn {
		params ["_mission", "_crate"];
		while {([_mission, "state_index"] call AS_spawn_fnc_get) == 3} do {
			{
				private _soldierFIA = _x;
				if (captive _soldierFIA) then {
					[_soldierFIA,false] remoteExec ["setCaptive",_soldierFIA];
				};
			} forEach ([300, _crate, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);
			sleep 10;
		};
	};

	{
		// make all enemies around notice the truck
		if (!(side _x in [("FIA" call AS_fnc_getFactionSide), civilian]) and {_x == (leader _x)} and {_x distance2D _position < 1000}) then {
			if (_x distance2D _position < 300) then {
				_x move position _crate;
			} else {
				//Farther groups have probability to move based on their distance. Farther units have less probability, 300m away are sure to come.
				if ((random 1) < (300/(_x distance _position))) then {

					if (vehicle _x != _x) then {
							private _wp0 = (group _x) addWaypoint [_position, 500]; //TODO: improve this to consider the direction of approach
							_wp0 setWaypointType "UNLOAD";
							_wp0 setWaypointBehaviour "SAFE";
							(group _x) setCurrentWaypoint _wp0;
							private _wp1 = (group _x) addwaypoint [position _crate, 10];
							_wp1 setWaypointBehaviour "AWARE";

					} else {
							group _x move position _crate;

							group _x setSpeedMode "FULL";
							group _x setBehaviour "AWARE";
							group _x setFormation "LINE";
					};
				};
			};
		};
		// send all nearby civilians to the truck
		if ((side _x == civilian) and {_x distance _position < 300}) then {_x doMove position _crate};
	} forEach allUnits;

	private _fnc_missionFailedCondition = {
		(not alive _crate) or (dateToNumber date > _max_date)
	};

	// wait for the truck to unload (2m) or the mission to fail
	[_crate, _position, 120, _fnc_unloadCondition, _fnc_missionFailedCondition, _str_unloadStopped, _str_unloadStart] call AS_fnc_wait_or_fail;

	if (call _fnc_missionFailedCondition) then {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];
	} else {
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_success", 2];
		[_crate] call AS_fnc_emptyCrate;
	};

};

AS_mission_sendMeds_states = ["initialize", "spawn", "run", "clean"];
AS_mission_sendMeds_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_wait,
	_fnc_run,
	AS_mission_spawn_fnc_clean
];
