#include "../../macros.hpp"

private _fnc_spawn = {
	params ["_location"];

	private _soldados = [];
	private _grupos = [];
	private _vehiculos = [];
	private _markers = [];

	private _spatrol = [];

	private _posicion = _location call AS_location_fnc_position;
	private _size = _location call AS_location_fnc_size;
	private _frontera = _location call AS_fnc_location_isFrontline;
	private _busy = _location call AS_location_fnc_busy;

	_vehiculos append (_location call AS_fnc_spawnComposition);

	private _grupo = createGroup ("AAF" call AS_fnc_getFactionSide);
	_grupos pushBack _grupo;

	([_location, "AAF", _grupo] call AS_fnc_populateMilBuildings) params ["_gunners", "_vehicles"];
	{[_x, false] call AS_fnc_initUnitAAF} forEach _gunners;
	_soldados append _gunners;
	_vehiculos append _vehicles;

	// spawn flag and crate
	private _bandera = createVehicle [["AAF", "flag"] call AS_fnc_getEntity, _posicion, [],0, "CAN_COLLIDE"];
	_bandera allowDamage false;
	_vehiculos pushback _bandera;

	private _veh = (["AAF", "box"] call AS_fnc_getEntity) createVehicle _posicion;
	[_veh, "Watchpost"] call AS_fnc_fillCrateAAF;
	_vehiculos pushBack _veh;


	//create _bunker, only if there's no preset composition
	if (!([([AS_compositions, "locations"] call DICT_fnc_get), _location] call DICT_fnc_exists)) then {
		private _bunker = AS_big_bunker_type createVehicle ([_posicion, 0, 50, 5, 0, 5, 0,[], _posicion] call BIS_Fnc_findSafePos);
		_vehiculos pushBack _bunker;
	};

	// spawn up to 4 mortars
	for "_i" from 1 to ((round (_size / 30)) min 4) do {
		if !(_location call AS_location_fnc_spawned) exitWith {};
		([_posicion, "AAF"] call AS_fnc_spawnMortar) params ["_mortar_units", "_mortar_groups", "_mortar_vehicles"];
		_soldados append _mortar_units;
		_vehiculos append _mortar_vehicles;
		_grupos append _mortar_groups;
		sleep 1;
	};

	// spawn AT road checkpoint
	if ((_location call AS_location_fnc_spawned) and _frontera) then {
		([_posicion, _grupo] call AS_fnc_spawnAAF_roadAT) params ["_units1", "_vehicles1"];
		_soldados append _units1;
		_vehiculos append _vehicles1;
	};

	// spawn parked vehicles
	private _groupCount = (round (_size/30)) max 1;

	if (!_busy) then {
		private _count_vehicles = ["trucks", "cars_armed", "apcs", "tanks"] call AS_AAFarsenal_fnc_countAvailable;
		private _vehClasses = ["trucks", "cars_armed", "apcs", "tanks"];

		for "_i" from 0 to (_groupCount min _count_vehicles) - 1 do {
			if !(_location call AS_location_fnc_spawned) exitWith {};
			private _vehClass = selectRandom _vehClasses;
			//TODO: improve checking for availability (spawned vehs and such). if multiple spawned with vehicles able to get vehicle count negative
			if ((_vehClass call AS_AAFarsenal_fnc_countAvailable) > 0) then {

				private _tipoVeh = selectRandom ([_vehClass] call AS_AAFarsenal_fnc_valid);
				private _pos = [];
				if (_size > 40) then {
					_pos = [_posicion, 10, _size/2, 10, 0, 0.3, 0, [], [_posicion, [0,0,0]]] call BIS_Fnc_findSafePos;
					} else {
					_pos = _posicion findEmptyPosition [10,60,_tipoVeh];
				};
				if (random 10 < 5 or (_tipoVeh in (["AAF", "trucks"] call AS_fnc_getEntity))) then {
					([_tipoVeh,_pos,"AAF", random 360] call AS_fnc_createEmptyVehicle) params ["_veh"];
					_vehiculos pushBack _veh;
					} else {
						([_tipoVeh, _location, "AAF"] call AS_fnc_spawnVehiclePatrol) params ["_veh2", "_group2", "_patrolMarker2"];
						_vehiculos pushback _veh2;
						_grupos pushBack _group2;
						_markers pushback _patrolMarker2;
					};
				};
			sleep 1;
		};
	};

	// spawn patrols
	// _mrk => to be deleted at the end
	([_location, _groupCount] call AS_fnc_spawnAAF_patrol) params ["_units1", "_groups1", "_mrk"];
	_spatrol append _units1;
	_grupos append _groups1;
	_markers pushBack _mrk;

	// spawn guarding squads
	if (_frontera) then {_groupCount = _groupCount * 2};
	([_location, 1 + _groupCount] call AS_fnc_spawnAAF_patrolSquad) params ["_units1", "_groups1"];
	_soldados append _units1;
	_grupos append _groups1;

	[_location, _grupos] call AS_fnc_spawnJournalist;

	[_location, "resources", [taskNull, _grupos, _vehiculos, _markers]] call AS_spawn_fnc_set;
	[_location, "soldiers", _soldados] call AS_spawn_fnc_set;
};

AS_spawn_createAAFbase_states = ["spawn", "wait_capture", "clean"];
AS_spawn_createAAFbase_state_functions = [
	_fnc_spawn,
	AS_location_spawn_fnc_AAFwait_capture,
	AS_location_spawn_fnc_AAFlocation_clean
];
