#include "../../macros.hpp"

private _fnc_spawn = {
	params ["_location"];

	private _soldados = [];
	private _grupos = [];
	private _vehiculos = [];
	private _markers = [];

	_vehiculos append (_location call AS_fnc_spawnComposition);

	private _posicion = _location call AS_location_fnc_position;
	private _size = _location call AS_location_fnc_size;
	private _frontera = _location call AS_fnc_location_isFrontline;

	private _grupo = createGroup ("AAF" call AS_fnc_getFactionSide);
	_grupos pushBack _grupo;

	([_location, "AAF", _grupo] call AS_fnc_populateMilBuildings) params ["_gunners2", "_vehicles2", "_groups2", "_markers2"];
	{[_x, false] call AS_fnc_initUnitAAF} forEach _gunners2;
	_soldados append _gunners2;
	_vehiculos append _vehicles2;
	_grupos append _groups2;
	_markers append _markers2;

	{
		_soldados append (units _x);
	} foreach _groups2;

	// create flag
	private _bandera = createVehicle [["AAF", "flag"] call AS_fnc_getEntity, _posicion, [],0, "CAN_COLLIDE"];
	_bandera allowDamage false;
	_vehiculos pushBack _bandera;

	private _caja = (["AAF", "box"] call AS_fnc_getEntity) createVehicle _posicion;
	[_caja, "loadCargo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
	_caja setVariable ["requiredVehs", ["Truck_F"], true];
	_caja setVariable ["asCargo", false, true];
 [_caja, "Watchpost"] call AS_fnc_fillCrateAAF;

	_vehiculos pushBack _caja;

	//create _bunker, only if there's no preset composition
	if (!([([AS_compositions, "locations"] call DICT_fnc_get), _location] call DICT_fnc_exists)) then {
		private _bunker = AS_big_bunker_type createVehicle ([_posicion, 0, 50, 5, 0, 5, 0,[], _posicion] call BIS_Fnc_findSafePos);
		_vehiculos pushBack _bunker;
	};

	{[_x, "AAF"] call AS_fnc_initVehicle;} forEach _vehiculos;

	if (_location call AS_location_fnc_type == "seaport") then {
		private _pos = [_posicion,_size,_size*3,10,2,0,0] call BIS_Fnc_findSafePos;
		private _vehicleType = selectRandom (["AAF", "boats"] call AS_fnc_getEntity);
		([_vehicleType, _pos, random 360, "AAF", "gunner", 0, "NONE", false] call AS_fnc_createVehicle) params ["_veh", "_vehCrew", "_driver"];
		_soldados append (units _vehCrew);
		_grupos pushBack _vehCrew;
		_vehiculos pushBack _veh;
		sleep 1;
	} else {
		if (_frontera) then {
			private _validBases = [["base"], "FIA"] call AS_location_fnc_TS;
			if (count _validBases > 0) then {
				private _base = [_validBases,_posicion] call BIS_fnc_nearestPosition;
				private _position = _base call AS_location_fnc_position;
				if (_position distance _posicion > 1000) then {
					([_posicion, "AAF", _size, 0.3] call AS_fnc_spawnMortar) params ["_mortar_units", "_mortar_groups", "_mortar_vehicles"];
					_soldados append _mortar_units;
					_vehiculos append _mortar_vehicles;
					_grupos append _mortar_groups;
					sleep 1;
				};
			};
		};

		if ((_location call AS_location_fnc_spawned) and _frontera) then {
			([_posicion, _grupo, _size, 0.3] call AS_fnc_spawnAAF_roadAT) params ["_units1", "_vehicles1"];
			_soldados append _units1;
			_vehiculos append _vehicles1;
		};
	};

	// spawn truck
	([_location] call AS_fnc_spawnAAF_truck) params ["_vehicles1"];
	_vehiculos append _vehicles1;

	private _groupCount = round (_size/60);
	if (_frontera) then {_groupCount = _groupCount * 2};
	_groupCount = _groupCount max 1;

	// spawn guarding squads
	([_location, _groupCount] call AS_fnc_spawnAAF_patrolSquad) params ["_units1", "_groups1"];
	_soldados append _units1;
	_grupos append _groups1;

	[_location, _grupos] call AS_fnc_spawnJournalist;

	[_location, "resources", [taskNull, _grupos, _vehiculos, _markers]] call AS_spawn_fnc_set;
	[_location, "soldiers", _soldados] call AS_spawn_fnc_set;
};

AS_spawn_createAAFoutpost_states = ["spawn", "wait_capture", "clean"];
AS_spawn_createAAFoutpost_state_functions = [
	_fnc_spawn,
	AS_location_spawn_fnc_AAFwait_capture,
	AS_location_spawn_fnc_AAFlocation_clean
];
