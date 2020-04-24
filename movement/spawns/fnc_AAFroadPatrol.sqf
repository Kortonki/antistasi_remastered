#include "../../macros.hpp"

private _fnc_spawn = {
	params ["_spawnName"];
	AS_Sset("AAFpatrols", AS_S("AAFpatrols") + 1);
	private _type = [_spawnName, "type"] call AS_spawn_fnc_get;
	private _isFlying = [_spawnName, "isFlying"] call AS_spawn_fnc_get;
	private _origin = [_spawnName, "origin"] call AS_spawn_fnc_get;
	private _posbase = _origin call AS_location_fnc_position;
	private _dir = 0;
	private _special = ["NONE", "FLY"] select _isFlying;
	private _crew = ["gunner", "pilot"] select _isFlying;

	if not _isFlying then {
		if (_type in (["AAF", "boats"] call AS_fnc_getEntity)) then {
			_posbase = [_posbase,50,150,10,2,0,0] call BIS_Fnc_findSafePos;
			_crew = "gunner";
		} else {

			private _posdir = [_origin call AS_location_fnc_positionConvoy, getmarkerpos "FIA_HQ"] call AS_fnc_findSpawnSpots;
			_posbase = _posdir select 0;
			_dir = _posdir select 1;

			//commented out, using finsdpawnspots function
			/*private _tam = 10;
			private _roads = [];
			while {count _roads == 0} do {
				_roads = _posbase nearRoads _tam;
				_tam = _tam + 10;
			};
			private _road = _roads select 0;
			_posbase = position _road;*/
		};
	};

	([_type, _posbase, _dir, "AAF", _crew , 0, _special] call AS_fnc_createVehicle) params ["_veh", "_grupoVeh"];


	if (_type isKindOf "Car") then {
		private _groupType = [["AAF", "patrols"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		private _tempGroup = createGroup ("AAF" call AS_fnc_getFactionSide);
		[_groupType call AS_fnc_groupCfgToComposition, _tempGroup, _posbase, _veh call AS_fnc_availableSeats] call AS_fnc_createGroup;
		{
			_x assignAsCargo _veh;
			_x moveInCargo _veh;
			[_x] joinsilent _grupoveh;
			[_x] call AS_fnc_initUnitAAF;
		} forEach units _tempGroup;
		deleteGroup _tempGroup;
		[_veh] spawn AS_AI_fnc_activateUnloadUnderSmoke;
	};

	if (_isFlying) then {
		_veh flyInHeight 700;
	};

	private _AAFresAdj = [] call AS_fnc_getAAFresourcesAdj;
	private _min = (0.3*(_AAFresAdj / 1500)) min 0.3; //TODO: make this an external function
	private _max = (_AAFresAdj / 2000) min 1;

	[_veh, _min, _max] call AS_fuel_fnc_randomFuelCargo;

	[_spawnName, "resources", [taskNull, [_grupoVeh], [_veh], []]] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_spawnName"];
	private _isFlying = [_spawnName, "isFlying"] call AS_spawn_fnc_get;
	private _type = [_spawnName, "type"] call AS_spawn_fnc_get;

	private _grupoveh = ([_spawnName, "resources"] call AS_spawn_fnc_get) select 1 select 0;
	private _veh = ([_spawnName, "resources"] call AS_spawn_fnc_get) select 2 select 0;
	private _markers = ([_spawnName, "resources"] call AS_spawn_fnc_get) select 3;
	private _soldados = units _grupoveh;

	private _fnc_destinations = {

		private _potentialLocations = call {
			if (_type in (["AAF", "boats"] call AS_fnc_getEntity)) exitWith {
				//TODO: implement seamarkers here
				[["seaport"], "AAF"] call AS_location_fnc_TS
			};
			[["base", "airfield", "resource", "factory", "powerplant", "outpost", "outpostAA"],
			"AAF"] call AS_location_fnc_TS
		};

		private _posHQ = getMarkerPos "FIA_HQ";
		private _distance = [5000, 20000] select _isFlying;
		_potentialLocations select {_posHQ distance2D (_x call AS_location_fnc_position) < _distance}
	};

	private _combat_init = {

		params ["_vehicle", "_targetpos", "_isFlying"];
		if (_vehicle getvariable ["combatInit", false]) exitWith {};

		private _size = [300, 1000] select _isFlying;
		private _leader = leader (driver _vehicle);
		(group _leader) setSpeedMode "NORMAL";

		private _patrolMarker = createMarker [format ["roadpatrol_%1", diag_tickTime], _targetpos];
		_patrolMarker setMarkerShape "RECTANGLE";
		_patrolMarker setMarkerSize [_size,_size];
		_patrolMarker setMarkerAlpha 0;

		[_leader, _patrolMarker, "COMBAT", "SPAWNED", "NOFOLLOW", "NOVEH"] spawn UPSMON;

		_vehicle setVariable ["combatInit", true, true];

		[[_targetpos], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];

		_patrolMarker

	};

	private _arraydestinos = call _fnc_destinations;
	private _distancia = [200, 1000] select _isFlying; //to avoid choppers getting stuck

	if (count _arraydestinos < 1) exitWith {
		AS_ISDEBUG("[AS] debug: fnc_createRoadPatrol cancelled: no valid destinations");
	};

	private _continue_condition = {
		(canMove _veh) and {alive _veh} and {count _arraydestinos > 0} and
		{{_x call AS_fnc_canFight} count _soldados != 0} and {fuel _veh > 0.2}
	};

	private _destino = selectRandom _arraydestinos;
	private _posdestino = _destino call AS_location_fnc_positionConvoy;
	private _Vwp0 = _grupoVeh addWaypoint [_posdestino, 0];
	_grupoVeh setcurrentWaypoint _Vwp0;
	_Vwp0 setWaypointType "MOVE";
	_Vwp0 setWaypointBehaviour "SAFE";
	_Vwp0 setWaypointSpeed "LIMITED";
	[_veh,"RoadPatrol"] spawn AS_fnc_setConvoyImmune;



	private _sideFIA = ("FIA" call AS_fnc_getFactionSide);
	private _sideAAF = ("AAF" call AS_fnc_getFactionSide);

	//Conisder if this kind of target sharing is necessary. OTOH the patrol doesn't use UPSMON to share info
	while {(_veh distance2D _posdestino > _distancia) and _continue_condition} do {
		sleep 30;
		{
			if (_x select 2 == _sideFIA) then {
				private _arevelar = _x select 4;
				private _nivel = (driver _veh) knowsAbout _arevelar;
				if (!(_veh getVariable ["combatInit", false]) and {_nivel > 1.4}) then {
					{
						if (leader _x distance2D _veh < AS_P("spawnDistance")) then {_x reveal [_arevelar,_nivel]};
					} forEach (allGroups select {side _x isEqualTo _sideAAF});
					private _marker = [_veh, _x select 0, _isFlying] call _combat_init;
					_markers pushback _marker;
				};
			};
		} forEach (driver _veh nearTargets AS_P("spawnDistance"));
	};

	if (_type in (["AAF", "boats"] call AS_fnc_getEntity)) then {
		_arraydestinos = ([["seaport"], "AAF"] call AS_location_fnc_TS) select {(_x call AS_location_fnc_position) distance2D (position _veh) < 2500};
	} else {
		_arraydestinos = call _fnc_destinations;
	};


	if (call _continue_condition) then {
		// repeat this state
		[_spawnName, "state_index", 0] call AS_spawn_fnc_set;
	} else {
		//Cleanup, so update markers
		[_spawnName, "resources", [taskNull, [_grupoVeh], [_veh], _markers]] call AS_spawn_fnc_set;
	};
};

private _fnc_clean = {
	params ["_spawnName"];
	AS_Sset("AAFpatrols", AS_S("AAFpatrols") - 1);
	([_spawnName, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];
	[_groups, _vehicles, _markers] call AS_fnc_cleanMissionResources;
	[_spawnName, "delete", true] call AS_spawn_fnc_set;
};

AS_spawn_AAFroadPatrol_states = ["spawn", "run", "clean"];
AS_spawn_AAFroadPatrol_state_functions = [
	_fnc_spawn,
	_fnc_run,
	_fnc_clean
];
