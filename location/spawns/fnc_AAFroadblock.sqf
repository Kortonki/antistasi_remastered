#include "../../macros.hpp"

private _fnc_spawn = {
	params ["_location"];
	private _vehiculos = [];
	private _soldados = [];
	private _groups = [];
	private _markers = [];

	private _posicion = _location call AS_location_fnc_position;

	(_posicion call AS_fnc_roadAndDir) params ["_road", "_dirveh"];

	// create bunker on one side
	private _pos1 = [getPos _road, 8, _dirveh + 270] call BIS_Fnc_relPos;
	private _bunker1 = AS_small_bunker_type createVehicle _pos1;
	_bunker1 setDir _dirveh;
	_vehiculos pushBack _bunker1;

	// create bunker on the other side
	private _pos2 = [getPos _road, 8, _dirveh + 90] call BIS_Fnc_relPos;
	private _bunker2 = AS_small_bunker_type createVehicle _pos2;
	_vehiculos pushBack _bunker2;
	_bunker2 setDir _dirveh + 180;

	private _static_mg = (["AAF", "static_mg"] call AS_fnc_getEntity) select 0;
	private _gunner = ["AAF", "gunner"] call AS_fnc_getEntity;

	private _grupoE = createGroup ("AAF" call AS_fnc_getFactionSide);  // temp group

	//If low on mgs, (25%) save them for bases and such
	if (["static_mg", 1/4] call AS_fnc_vehicleAvailability) then {

				private _mg1 = [_static_mg, _pos1, "AAF", _dirVeh, "CAN_COLLIDE"] call AS_fnc_createEmptyVehicle;
				_mg1 setPosATL (getPosATL _bunker1);
				_vehiculos pushBack _mg1;

				private _unit1 = ([_posicion, 0, _gunner, _grupoE] call bis_fnc_spawnvehicle) select 0;
				_soldados pushBack _unit1;
				[_unit1, false] call AS_fnc_initUnitAAF;
				_unit1 moveInGunner _mg1;
				sleep 1;

				private _mg2 = [_static_mg, _pos2, "AAF", _dirVeh + 180, "CAN_COLLIDE"] call AS_fnc_createEmptyVehicle;
				_mg2 setPosATL (getPosATL _bunker2);
				_vehiculos pushback _mg2;

				private _unit2 = ([_posicion, 0, _gunner, _grupoE] call bis_fnc_spawnvehicle) select 0;
				_soldados pushBack _unit2;
				[_unit2, false] call AS_fnc_initUnitAAF;
				_unit2 moveInGunner _mg2;
	};

	// Create flag
	private _pos = [getPos _bunker2, 6, getDir _bunker2] call BIS_fnc_relPos;
	private _flag = createVehicle [["AAF", "flag"] call AS_fnc_getEntity, _pos, [],0, "CAN_COLLIDE"];
	_vehiculos pushBack _flag;

	// create the patrol group(s)

	private _mrk = createMarker [format ["%2_%1_patrolarea", (diag_tickTime), random 100], _pos];
	_mrk setMarkerShape "RECTANGLE";
	_mrk setMarkerSize [50,50];
	_mrk setMarkerType "hd_warning";
	_mrk setMarkerColor "ColorRed";
	_mrk setMarkerBrush"DiagGrid";
	_mrk setMarkerAlpha 0;

	_markers pushback _mrk;

	private _count = 0;
	private _amount = [1,2] select (_location call AS_fnc_location_isFrontline);
	private _amount = round(_amount*AS_teamSizeRef);
	while {_count < _amount} do {
		private _grupo = [_posicion, ("AAF" call AS_fnc_getFactionSide), [["AAF", "teams"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup] call BIS_Fnc_spawnGroup;

		_count = _count + (count (units _grupo));

		{[_x, false] call AS_fnc_initUnitAAF; _soldados pushBack _x} forEach units _grupo;

		if (!(isnull _grupoE)) then {
			{[_x] join _grupo} forEach units _grupoE;
			deleteGroup _grupoE;
		};
		// add dog
		if (random 10 < 2.5) then {
			[_grupo] call AS_fnc_spawnDog;
		};

		_groups pushback _grupo;

		[leader _grupo, _mrk, "SAFE","SPAWNED","NOVEH","NOFOLLOW"] spawn UPSMON;

	};

	//Spawn parked apc or armed car and crew on sentry

	private _priority = [0.8, 0.5] select (_location call AS_fnc_location_isFrontline);
	private _class = "";

	if (["apcs", _priority] call AS_fnc_vehicleAvailability) then {
		_class = "apcs";
	} else {
		if (["cars_armed", _priority] call AS_fnc_vehicleAvailability) then {
			_class = "cars_armed";
		};
	};

	if (_class != "") then {
			private _apc_pos_dir = [_location, 1, _class, 200] call AS_location_fnc_vehicleParking;
			private _apcPos = (_apc_pos_dir select 0) select 0;
			private _apcDir = (_apc_pos_dir select 1) select 0;
			private _type = selectRandom ([_class] call AS_AAFarsenal_fnc_valid);
			([_type, _apcPos, "AAF", _apcDir] call AS_fnc_createEmptyVehicle) params ["_apc"];
			_vehiculos pushback _apc;

			([_apc, "AAF", "crew"] call AS_fnc_createVehicleGroup) params ["_crewGroup", "_units"];

			private _patrolMarker = [_crewGroup, _apc, _location, 50] call AS_tactics_fnc_crew_sentry;

			_soldados append _units;
			_groups pushback _crewGroup;
			_markers pushback _patrolMarker;
	};


	[_location, "resources", [taskNull, _groups, _vehiculos, _markers]] call AS_spawn_fnc_set;
	[_location, "soldiers", _soldados] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_location"];
	private _posicion = _location call AS_location_fnc_position;

	private _soldados = [_location, "soldiers"] call AS_spawn_fnc_get;

	waitUntil {sleep AS_spawnLoopTime;
		!(_location call AS_location_fnc_spawned) or
		{_x call AS_fnc_canFight} count _soldados == 0
	};

	private _wasDestroyed = false;

	if (_location call AS_location_fnc_spawned) then {

		_wasDestroyed = true;
		[-5,0,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
		["TaskSucceeded", ["", "Roadblock Cleared"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
		[[_posicion], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
		["cl_loc"] remoteExec ["fnc_BE_XP", 2];

	};

	[_location, "wasDestroyed", _wasDestroyed] call AS_spawn_fnc_set;
};

private _fnc_clean = {
	params ["_location"];

	([_location, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];
	private _wasDestroyed = [_location, "wasDestroyed"] call AS_spawn_fnc_get;

	//Send each soldier away from closest BLUFORspawn to avoid soldier multiplying when location despawns and spawns while
	//soldiers do not (individually checked for spawn condition). OTOH removing them immediately might make them
	//despawn far away from location but close to a player or FIA soldiers (UPSMON can send them away and otherwise)

	[_location, _groups] spawn AS_fnc_sendAwayFromBlufor;

	waitUntil {sleep AS_spawnLoopTime; not(_location call AS_location_fnc_spawned)};

	if (_wasDestroyed) then {
			[_location] remoteExec ["AS_location_fnc_remove", 2];
	};

	[_groups,  _vehicles, _markers] call AS_fnc_cleanResources;

	//EXPERIMENT despawning normally to avoid duplicate vehicles
	/*
	{
		[_x] spawn AS_fnc_activateVehicleCleanup;
	} foreach _vehicles;*/

	[_location, "delete", true] call AS_spawn_fnc_set;

};

AS_spawn_createAAFroadblock_states = ["spawn", "wait_capture", "clean"];
AS_spawn_createAAFroadblock_state_functions = [
	_fnc_spawn,
	_fnc_run,
	_fnc_clean
];
