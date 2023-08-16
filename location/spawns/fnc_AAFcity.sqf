private _fnc_spawn = {
	params ["_location"];
	private _grupos = [];
	private _soldados = [];

	private _posicion = _location call AS_location_fnc_position;
	private _size = _location call AS_location_fnc_size;
	private _population = [_location, "population"] call AS_location_fnc_get;

	private _markers = [];

	private _patrolMarker = createMarker [format ["%1_gar", call AS_fnc_uniqueID], _posicion];
	_patrolMarker setMarkerShape "ELLIPSE";
	_patrolMarker setMarkerSize [_size,_size];
	_patrolMarker setMarkerAlpha 0;

	_markers pushback _patrolMarker;

	private _AAFsupport = [_location, "AAFsupport"] call AS_location_fnc_get;

	private _num = round (_population/50); // [200, 800] -> [2, 8] //4 is the reference size for patrol groups //EXPERIMENT depends on population, was 1 patrol per 100 of size
	_num = _num * (0.5 + 0.5*_AAFsupport/100); //EXPERIMENT AAFsupport dependency halved, has constant now
	if (_location call AS_fnc_location_isFrontline) then {_num = _num * 2};
	_num = _num max 1;
	_num = _num min (_size/100); //Size gives the max cap now
	_num = round(_num*AS_patrolSizeRef); //Number of groups changed to number of units

	// generate _num patrols.
	private _count = 0;
	while {_count < _num} do {
		//if !(_location call AS_location_fnc_spawned) exitWith {};
		private _grupo = [_posicion, ("AAF" call AS_fnc_getFactionSide), [["AAF", "patrols"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup] call BIS_Fnc_spawnGroup;
		private _units = units _grupo;
		_count = _count + (count _units);

		// generate dog with some probability.
		// For ref side group chance is 25%, depends on size
		if (random 10 < ((count _units)*2.5/AS_patrolSizeRef)) then {
			[_grupo] call AS_fnc_spawnDog;
		};
		//_soldados pushBack _dog; //Dog shouldn't be counted as a soldier

		{
			[_x, false] call AS_fnc_initUnitAAF;
			_soldados pushBack _x
		} forEach _units;


		// put then on patrol.
		[leader _grupo, _patrolMarker, "SAFE", "RANDOM", "SPAWNED","NOVEH", "NOFOLLOW"] spawn UPSMON;
		_grupos pushBack _grupo;
	};

	[_location, "resources", [taskNull, _grupos, [], _markers]] call AS_spawn_fnc_set;
	[_location, "soldiers", _soldados] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_location"];
	private _posicion = _location call AS_location_fnc_position;

	private _soldados = [_location, "soldiers"] call AS_spawn_fnc_get;

	waitUntil {sleep AS_spawnLoopTime;
		!(_location call AS_location_fnc_spawned) or
		({_x call AS_fnc_canFight} count _soldados == 0)
	};

	// send patrol
	if ({_x call AS_fnc_canFight} count _soldados == 0) then {
		[[_posicion], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
	};
};

AS_spawn_createAAFcity_states = ["spawn", "run", "clean"];
AS_spawn_createAAFcity_state_functions = [
	_fnc_spawn,
	_fnc_run,
	AS_location_spawn_fnc_AAFlocation_clean
];
