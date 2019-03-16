
private _fnc_initialize = {
	params ["_mission"];
	private _missionType = _mission call AS_mission_fnc_type;
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	private _tiempolim = 120;
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];

	private _tskTitle = _mission call AS_mission_fnc_title;
	private _tskDesc = call {
		if (_missionType == "rescue_prisioners") exitWith {
			format [localize "STR_tskDesc_resPrisoners",
				[_location] call AS_fnc_location_name,
				numberToDate [2035,dateToNumber _fechalim] select 3,
				numberToDate [2035,dateToNumber _fechalim] select 4
			]
		};
		if (_missionType == "rescue_refugees") exitWith {
			format [localize "STR_tskDesc_resRefugees", [_location] call AS_fnc_location_name, (["AAF", "name"] call AS_fnc_getEntity)]
		};
		""
	};

	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
	[_mission, [_tskDesc,_tskTitle,_location], _position, "run"] call AS_mission_spawn_fnc_saveTask;
};

private _fnc_spawn = {
	params ["_mission"];
	private _missionType = _mission call AS_mission_fnc_type;
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	private _spawnFail = false;

	private _grpPOW = createGroup ("FIA" call AS_fnc_getFactionSide);
	if (_missionType == "rescue_prisioners") then {
		private _prisioners = 5 + round random 10;

		for "_i" from 1 to _prisioners do {
			private _unit = ["Survivor", [_position, 5, random 360] call BIS_Fnc_relPos, _grpPOW] call AS_fnc_spawnFIAUnit;
			_unit call AS_fnc_initUnitSurvivor;
			[_unit, "prisionero"] remoteExec ["AS_fnc_addaction", [0, -2] select isDedicated];
		};
	};
	if (_missionType == "rescue_refugees") then {
		// get a house with at least 12 positions: Note changed to 12 to avoid errors
		//Changed to 8 to avoid too many cancellations on rural maps
		private _size = _location call AS_location_fnc_size;
		private _houses = nearestObjects [_position, ["house"], _size];
		private _house_positions = [];
		private _house = _houses select 0;
		while {count _house_positions < 8} do {
			_house = selectRandom _houses;
			_house_positions = [_house] call BIS_fnc_buildingPositions;
			if (count _house_positions < 8) then {
				_houses = _houses - [_house]
			};
			if (count _houses == 0) exitWith {_spawnFail = true}
		};

		if (_spawnFail) exitWith { //Cancel mission if no proper house position found
			//[_mission, "resources", [taskNull, [], [], []]] call AS_spawn_fnc_set; //Unnecessary?
			[petros, "sideChat", str _tskTitle + " canceled"] remoteExec ["AS_fnc_localCommunication", [0,-2] select isDedicated];
		};
		// update position
		_position = position _house;

		private _num = ((count _house_positions)/2) min 8; //Note: this edited so there's at least 2 positions per refugee
		for "_i" from 0 to _num - 1 do {
			private _unit = ["Survivor", _house_positions select _i, _grpPOW] call AS_fnc_spawnFIAUnit;
			_unit call AS_fnc_initUnitSurvivor;
			[_unit, "refugiado"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
		};

		// send a patrol
		[_position, _mission] spawn {
			params ["_position", "_mission"];
			sleep (5*60 + random (15*60));
			if (_mission call AS_mission_fnc_status == "active") then {
				[[_position], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
			};
		};
	};



	private _task = ([_mission, "CREATED", "", _position] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	[_mission, "resources", [_task, [_grpPOW], [], []]] call AS_spawn_fnc_set;

		{_x allowDamage true} forEach units _grpPOW;


	if _spawnFail exitWith {
	[_mission, "state_index", 3] call AS_spawn_fnc_set;
	[_mission] remoteExecCall ["AS_mission_fnc_cancel", 2];
	};

};

private _fnc_run = {
	params ["_mission"];
	private _grpPOW = (([_mission, "resources"] call AS_spawn_fnc_get) select 1) select 0;
	private _pows = units _grpPOW;

	private _fnc_missionFailedCondition = {{alive _x} count _pows < (count _pows)/2};

	private _fnc_missionFailed = {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission,  [{not alive _x or captive _x} count _pows]] remoteExec ["AS_mission_fnc_fail", 2];

		{
			_x setCaptive false;
			if (group _x != _grpPOW) then {_x setVariable ["AS_type", "Rifleman", true]}; //Remnants of POWs who were already rescued join FIA and are usable
		} forEach _pows;
	};

	private _fnc_missionSuccessfulCondition = {
		{(alive _x) and (_x distance getMarkerPos "FIA_HQ" < 50)} count _pows >
		 ({alive _x} count _pows) / 2
	 };

	private _fnc_missionSuccessful = {
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission,   [{alive _x} count _pows]] remoteExecCall ["AS_mission_fnc_success", 2];

		{
			if (captive _x) then {
				_x setcaptive false;
			};
		} foreach _pows;

			//Wait unit to lose undercover and get weapons back

		sleep 30;

		private _cargo_w = [[], []];
		private _cargo_m = [[], []];
		private _cargo_i = [[], []];
		private _cargo_b = [[], []];

		{
			[_x] join _grpPOW;
			[_x] orderGetin false;

			private _arsenal = [_x, true] call AS_fnc_getUnitArsenal;  // restricted to locked weapons
			_cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
			_cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
			_cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
			_cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
			[cajaVeh, (_arsenal select 4)] call AS_fnc_addMagazineRemains;

			[_x]  RemoteExec ["deleteVehicle", _x];

			} forEach _pows;

		[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;

	};

	[_fnc_missionFailedCondition, _fnc_missionFailed, _fnc_missionSuccessfulCondition, _fnc_missionSuccessful] call AS_fnc_oneStepMission;
};


/* Commented to check if this works inside mission succesful
private _fnc_clean = {

params ["_mission"];
private _grpPOW = (([_mission, "resources"] call AS_spawn_fnc_get) select 1) select 0;
private _pows = units _grpPOW;

private _time = time + 30;

waitUntil {sleep 1; (time > _time)};

private _cargo_w = [[], []];
private _cargo_m = [[], []];
private _cargo_i = [[], []];
private _cargo_b = [[], []];

	{
		if (alive _x) then {


			private _arsenal = [_x, true] call AS_fnc_getUnitArsenal;  // restricted to locked weapons
			_cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
			_cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
			_cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
			_cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;

		};

		deleteVehicle _x;


	} foreach _pows;


[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_populateBox;

_mission call AS_mission_spawn_fnc_clean;

};

*/

AS_mission_rescue_states = ["initialize", "spawn", "run", "clean"];
AS_mission_rescue_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_run,
	AS_mission_spawn_fnc_clean
];
