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

	// flag and crate
	private _bandera = createVehicle [["AAF", "flag"] call AS_fnc_getEntity, _posicion, [],0, "CAN_COLLIDE"];
	_bandera allowDamage false;
	_vehiculos pushBack _bandera;
	private _caja = (["AAF", "box"] call AS_fnc_getEntity) createVehicle _posicion;
	_vehiculos pushBack _caja;
	private _bunker = AS_big_bunker_type createVehicle ([_posicion, 0, 50, 5, 0, 5, 0,[], _posicion] call BIS_Fnc_findSafePos);
	_vehiculos pushBack _bunker;

	{[_x, "AAF"] call AS_fnc_initVehicle;} forEach _vehiculos;

	if (_frontera) then {
		private _validBases = [["base"], "FIA"] call AS_location_fnc_TS;
		if (count _validBases > 0) then {
			private _base = [_validBases,_posicion] call BIS_fnc_nearestPosition;
			private _position = _base call AS_location_fnc_position;
			if (_position distance _posicion > 1000) then {
				([_posicion, "AAF"] call AS_fnc_spawnMortar) params ["_mortar_units", "_mortar_groups", "_mortar_vehicles"];
				_soldados append _mortar_units;
				_vehiculos append _mortar_vehicles;
				_grupos append _mortar_groups;
				sleep 1;
			};
		};
		([_posicion, _grupo] call AS_fnc_spawnAAF_roadAT) params ["_units1", "_vehicles1"];
		_soldados append _units1;
		_vehiculos append _vehicles1;
	};

	// spawn truck
	([_location] call AS_fnc_spawnAAF_truck) params ["_vehicles1"];
	_vehiculos append _vehicles1;

	// Create an AA team
	_grupo = [_posicion, ("AAF" call AS_fnc_getFactionSide), [["AAF", "teamsAA"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup] call BIS_Fnc_spawnGroup;
	_grupos pushBack _grupo;
	{[_x, false] call AS_fnc_initUnitAAF; _soldados pushBack _x;} forEach units _grupo;
	[leader _grupo, _location, "SAFE","SPAWNED","RANDOM","NOVEH","NOFOLLOW"] spawn UPSMON;

	private _groupsCount = (round (_size/50)) max 1;
	if (_frontera) then {_groupsCount = _groupsCount * 2};


	for "_i" from 1 to _groupsCount do {
		if !(_location call AS_location_fnc_spawned) exitWith {};
		_grupo = [_posicion, ("AAF" call AS_fnc_getFactionSide), [["AAF", "teams"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup] call BIS_Fnc_spawnGroup;
		private _stance = "RANDOM";
		if (_i == 1) then {_stance = "RANDOMUP"};
		[leader _grupo, _location, "SAFE","SPAWNED",_stance,"NOVEH","NOFOLLOW"] spawn UPSMON;
		_grupos pushBack _grupo;
		{[_x, false] call AS_fnc_initUnitAAF; _soldados pushBack _x} forEach units _grupo;
	};

	[_location, _grupos] call AS_fnc_spawnJournalist;

	[_location, "resources", [taskNull, _grupos, _vehiculos, _markers]] call AS_spawn_fnc_set;
	[_location, "soldiers", _soldados] call AS_spawn_fnc_set;
};

AS_spawn_createAAFoutpostAA_states = ["spawn", "wait_capture", "clean"];
AS_spawn_createAAFoutpostAA_state_functions = [
	_fnc_spawn,
	AS_location_spawn_fnc_AAFwait_capture,
	AS_location_spawn_fnc_AAFlocation_clean
];
