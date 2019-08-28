#include "../../macros.hpp"

private _fnc_spawn = {
	params ["_location"];

	private _soldados = [];
	private _grupos = [];
	private _vehiculos = [];
	private _soldadosFIA = [];
	private _markers = [];

	_vehiculos append (_location call AS_fnc_spawnComposition);

	private _posicion = _location call AS_location_fnc_position;
	private _size = _location call AS_location_fnc_size;
	private _prestigio = AS_P("NATOsupport")/100;
	private _buildings = nearestObjects [_posicion, ["Land_LandMark_F"], _size / 2];

	if (count _buildings > 1) then {
		private _pos1 = getPos (_buildings select 0);
		private _pos2 = getPos (_buildings select 1);
		private _ang = [_pos1, _pos2] call BIS_fnc_DirTo;

		private _pos = [_pos1, 5,_ang] call BIS_fnc_relPos;
		private _grupo = createGroup ("NATO" call AS_fnc_getFactionSide);
		_grupos pushBack _grupo;
		for "_i" from 1 to (round (5*_prestigio)) do {
			if !(_location call AS_location_fnc_spawned) exitWith {};
			private _tipoveh = selectRandom (["NATO", "helis"] call AS_fnc_getEntity);
			private _veh = createVehicle [_tipoveh, _pos, [],3, "NONE"];
			_veh setDir (_ang + 90);
			[_veh, "NATO"] call AS_fnc_initVehicle;
			_vehiculos pushBack _veh;

			private _unit = ([_posicion, 0, ["NATO", "pilot"] call AS_fnc_getEntity, _grupo] call bis_fnc_spawnvehicle) select 0;
			[_unit] call AS_fnc_initUnitNATO;
			_soldados pushBack _unit;

			// new position
			_pos = [_pos, 20,_ang] call BIS_fnc_relPos;
			sleep 1;
			};
		[leader _grupo, _location, "SAFE","SPAWNED","NOFOLLOW","NOVEH2"] spawn UPSMON;
	};

	// create flag
	private _pos = [_posicion, 3,0] call BIS_fnc_relPos;
	private _veh = createVehicle [(["NATO", "flag"] call AS_fnc_getEntity), _pos, [],0, "CAN_COLLIDE"];
	_veh allowDamage false;
	[_veh, "unit"] RemoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
	[_veh,"vehicle"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
	//[_veh,"garage"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
	_vehiculos pushBack _veh;

	//create _bunker, only if there's no preset composition
	if (!([([AS_compositions, "locations"] call DICT_fnc_get), _location] call DICT_fnc_exists)) then {
		private _bunker = AS_big_bunker_type createVehicle ([_posicion, 0, 50, 5, 0, 5, 0,[], _posicion] call BIS_Fnc_findSafePos);
		_vehiculos pushBack _bunker;
	};

	// number of vehicles and groups spawned (at least 1)
	private _nVeh = (round ((_size/100)*_prestigio)) max 1;

	// create vehicles
	for "_i" from 1 to _nVeh do {
		if !(_location call AS_location_fnc_spawned) exitWith {};

		private _tipoVeh = selectRandom (["NATO", "other_vehicles"] call AS_fnc_getEntity);
		private _pos = [_posicion, 10, _size/2, 10, 0, 0.3, 0] call BIS_Fnc_findSafePos;
		private _veh = createVehicle [_tipoVeh, _pos, [], 0, "NONE"];
		_veh setDir random 360;
		_vehiculos pushBack _veh;
		[_veh, "NATO"] call AS_fnc_initVehicle;
		sleep 1;
	};

	// create NATO garrison (creates at least 1)
	for "_i" from 1 to _nVeh do {
		if !(_location call AS_location_fnc_spawned) exitWith {};

		// get random pos
		private _pos = [];
		while {true} do {
			_pos = [_posicion, random _size,random 360] call BIS_fnc_relPos;
			if (!surfaceIsWater _pos) exitWith {};
		};
		private _grupo = [_pos, ("NATO" call AS_fnc_getFactionSide), [["NATO", "squads"] call AS_fnc_getEntity, "NATO"] call AS_fnc_pickGroup] call BIS_Fnc_spawnGroup;
		_grupos pushBack _grupo;
		{[_x] call AS_fnc_initUnitNATO; _soldados pushBack _x} forEach units _grupo;
		[leader _grupo, _location, "SAFE","SPAWNED", "RANDOM","NOVEH2", "NOFOLLOW"] spawn UPSMON;
		sleep 1;
	};

	for "_i" from 1 to (floor (_nVeh/2)) do {
		if !(_location call AS_location_fnc_spawned) exitWith {};

		private _vehClass = selectRandom ["cars_armed", "apcs", "tanks", "self_aa"];
		private _vehicleType = selectRandom (["NATO", _vehClass] call AS_fnc_getEntity);

		([_vehicleType, _location, "NATO"] call AS_fnc_spawnVehiclePatrol) params ["_veh2", "_group2", "_patrolMarker2"];

		_vehiculos pushback _veh2;
		_grupos pushBack _group2;
		_markers pushback _patrolMarker2;

	};

	// Create FIA garrison
	(_location call AS_fnc_createFIAgarrison) params ["_soldados1", "_grupos1", "_marker1"];
	_soldadosFIA append _soldados1;
	_grupos append _grupos1;
	_markers pushback _marker1;

	[_location, _grupos] call AS_fnc_spawnJournalist;

	[_location, "resources", [taskNull, _grupos, _vehiculos, _markers]] call AS_spawn_fnc_set;
	[_location, "soldiers", _soldados] call AS_spawn_fnc_set;
	[_location, "FIAsoldiers", _soldadosFIA] call AS_spawn_fnc_set;
};

AS_spawn_createFIAairfield_states = ["spawn", "run", "clean"];
AS_spawn_createFIAairfield_state_functions = [
	_fnc_spawn,
	AS_location_spawn_fnc_FIAwait_capture,
	AS_location_spawn_fnc_FIAlocation_clean
];
