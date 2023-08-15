
private _fnc_initialize = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _missionType = _mission call AS_mission_fnc_type;

	private _tiempolim = 120;  // 2h
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];

	private _tskDescType = "";

	switch (_missionType) do {
    case "steal_ammo": {_tskDescType = "STR_tskDesc_logAmmo";};
    case "steal_fuel": {_tskDescType = "STR_tskDesc_logFuel";};
    default {_tskDescType = "Error: Invalid mission type";};
	};

	private _tskTitle = _mission call AS_mission_fnc_title;
	private _tskDesc = format [localize _tskDescType,
		[_location] call AS_fnc_location_name,
		numberToDate [date select 0,dateToNumber _fechalim] select 3,
		numberToDate [date select 0,dateToNumber _fechalim] select 4];

	[_mission, [_tskDesc,_tskTitle,_location], _position, "rearm"] call AS_mission_spawn_fnc_saveTask;
	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
};

private _fnc_wait_spawn = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;


	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	waitUntil {sleep 1;False or {dateToNumber date > _max_date} or (_location call AS_location_fnc_spawned)};

	if (dateToNumber date > _max_date) then {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];

		// we set the spawn state to `run` so that the next one is `clean`, since this ends the mission
		[_mission, "state_index", 4] call AS_spawn_fnc_set;
	};

	[_mission, "resources", [_task, [], [], []]] call AS_spawn_fnc_set;
};

private _fnc_spawn = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _missionType = _mission call AS_mission_fnc_type;
	private _truckType = "";

	switch (_missionType) do {
		case "steal_ammo": {_truckType = ["AAF", "truck_ammo"] call AS_fnc_getEntity;};
		case "steal_fuel": {_truckType = ["AAF", "truck_fuel"] call AS_fnc_getEntity;};
		default {_truckType = (["AAF", "trucks"] call AS_fnc_getEntity) select 0;};
	};

	/*private _pos = [];
	while {count _pos < 3} do {
		_pos = _position findEmptyPosition [0,_size, _truckType];
		_size = _size + 20
	};*/

([_position] call AS_fnc_findSpawnSpots) params ["_pos", "_dir"];

	private _vehicles = [];
	private _groups = [];

	//private _truck = _truckType createVehicle _pos;
	private _truck = [_truckType, _pos, "AAF", _dir] call AS_fnc_createEmptyVehicle;
	_vehicles pushBack _truck;



	switch (_missionType) do {
			case "steal_ammo": {[_truck, "Convoy"] call AS_fnc_fillCrateAAF;};
			case "steal_fuel": {[_truck, 0.95, 1] call AS_fuel_fnc_randomFuelCargo;};
			default {};
	};

	// patrol marker. To be deleted in the end
	private _mrk = createMarkerLocal [format ["%1patrolarea", floor (diag_tickTime)], _pos];
	_mrk setMarkerShapeLocal "RECTANGLE";
	_mrk setMarkerSizeLocal [100,100];
	_mrk setMarkerTypeLocal "hd_warning";
	_mrk setMarkerColorLocal "ColorRed";
	_mrk setMarkerBrushLocal "DiagGrid";
	_mrk setMarkerAlphaLocal 0;

	// patrol groups
	for "_i" from 1 to (2 + floor random 3) do {
		private _tipoGrupo = [["AAF", "patrols"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		private _group = [_pos, "AAF" call AS_fnc_getFactionSide, _tipogrupo] call BIS_Fnc_spawnGroup;
		_groups pushback _group;
		if (random 10 < 3) then {
			[_group] call AS_fnc_spawnDog;
		};
		[leader _group, _mrk, "SAFE","SPAWNED", "NOVEH"] spawn UPSMON;
		{[_x, false] call AS_fnc_initUnitAAF} forEach units _group;
	};

	private _task = ([_mission, "resources"] call AS_spawn_fnc_get) select 0;
	[_mission, "resources", [_task, _groups, _vehicles, [_mrk]]] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_mission"];

	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _missionType = _mission call AS_mission_fnc_type;

	private _vehicles = ([_mission, "resources"] call AS_spawn_fnc_get) select 2;

	private _truck = _vehicles select 0;
	private _fnc_missionSuccessfulCondition = {(({_x getVariable ["BLUFORSpawn",false]} count (crew _truck) > 0) and {_truck distance2D _position > 500}) or not(alive _truck)};

	private _fnc_missionSuccessful = {
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission, [getPos _truck]] remoteExec ["AS_mission_fnc_success", 2];

		/* //Done at missionsuccss
		if (_location call AS_location_fnc_type in ["base", "airfield"]) then {
			[_location, 30] call AS_location_fnc_increaseBusy;
		};

		//Done at missionsucces
		/*switch (_missionType) do {
				case "steal_ammo": {[-10000] remoteExec ["AS_fnc_changeAAFmoney",2];};
				case "steal_fuel": {[-5000] remoteExec ["AS_fnc_changeAAFmoney",2];};
				default {};*/

	};

	private _fnc_missionFailedCondition = {dateToNumber date > _max_date};

	private _fnc_missionFailed = {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];
			//Check if the vehicle is destroyed or is emptied of any supplies it carried to penalise AAF. Either fuel or weapons
	};

	[_fnc_missionFailedCondition, _fnc_missionFailed, _fnc_missionSuccessfulCondition, _fnc_missionSuccessful] call AS_fnc_oneStepMission;
	[[position _truck], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
};

AS_mission_stealTruck_states = ["initialize", "spawn_wait_spawn", "wait_spawn", "spawn", "run", "clean"];
AS_mission_stealTruck_state_functions = [
	_fnc_initialize,
	AS_mission_spawn_fnc_wait_spawn,
	_fnc_wait_spawn,
	_fnc_spawn,
	_fnc_run,
	AS_mission_spawn_fnc_clean
];
