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

	([_location, "AAF", _grupo] call AS_fnc_populateMilBuildings) params ["_gunners2", "_vehicles2", "_groups2", "_markers2"];
	{[_x, false] call AS_fnc_initUnitAAF} forEach _gunners2;
	_soldados append _gunners2;
	_vehiculos append _vehicles2;
	_grupos append _groups2;
	_markers append _markers2;

	{
		_soldados append (units _x);
	} foreach _groups2;

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

	//Amount of vehicles is same propoprtion of location max as there are vehicles in total compared to allowed total
	private _mortarAmount = ["static_mortar", "base"] call AS_location_fnc_vehicleAmount;

	// spawn up to available mortars (failsafe, above calc should already limit it)
	for "_i" from 1 to (_mortarAmount min ("static_mortar" call AS_AAFarsenal_fnc_countAvailable)) do {
		if !(_location call AS_location_fnc_spawned) exitWith {};
		([_posicion, "AAF"] call AS_fnc_spawnMortar) params ["_mortar_units", "_mortar_groups", "_mortar_vehicles"];
		_soldados append _mortar_units;
		_vehiculos append _mortar_vehicles;
		_grupos append _mortar_groups;
		sleep 1;
	};

	//spawn at
	private _atAmount = ["static_at", "base"] call AS_location_fnc_vehicleAmount;

	// spawn AT road checkpoint
	for "_i" from 1 to (_atAmount min ("static_at" call AS_AAFarsenal_fnc_countAvailable)) do {
		if ((_location call AS_location_fnc_spawned)) then {
			([_posicion, _grupo, 0] call AS_fnc_spawnAAF_roadAT) params ["_units1", "_vehicles1"];
			_soldados append _units1;
			_vehiculos append _vehicles1;
		};
	};

	//Spawn some AA	private _atAmount = round((("static_at" call AS_AAFarsenal_fnc_count) / ("static_at" call AS_AAFarsenal_fnc_max)) * (["static_at", "base"] call AS_location_fnc_vehicles));

	private _aaAmount = ["static_aa", "base"] call AS_location_fnc_vehicleAmount;

		// spawn AA
		for "_i" from 1 to (_aaAmount min ("static_aa" call AS_AAFarsenal_fnc_countAvailable)) do {
			if ((_location call AS_location_fnc_spawned)) then {

				([_posicion, _grupo, _size, 0] call AS_fnc_spawnAAF_AA) params ["_units1", "_vehicles1"];
				_soldados append _units1;
				_vehiculos append _vehicles1;
			};
		};

	// spawn parked vehicles


	private _vehClasses = ("base" call AS_location_fnc_vehicleClasses) arrayIntersect ["cars_transport", "cars_armed", "trucks", "apcs", "tanks"];

	{
		if !(_location call AS_location_fnc_spawned) exitWith {};
		private _vehCount = [_x, "base"] call AS_location_fnc_vehicleAmount;

		private _pos_dir = [_location, _vehCount] call AS_location_fnc_vehicleParking;

		for "_i" from 0 to ((_vehCount min (_x call AS_AAFarsenal_fnc_countAvailable)) -1) do {

			//TODO: improve checking for availability (spawned vehs and such). if multiple spawned with vehicles able to get vehicle count negative
			private _tipoVeh = selectRandom ([_x] call AS_AAFarsenal_fnc_valid);
			private _pos = [];
			private _dir = random 360;

			if (count (_pos_dir select 0) > 0) then {
				_pos = (_pos_dir select 0) select _i;
				_dir = (_pos_dir select 1) select _i;
			} else {
				if (_size > 40) then {
					_pos = [_posicion, 5, _size, 10, 0, 0.3, 0, [], [_posicion, [0,0,0]]] call BIS_Fnc_findSafePos;
					} else {
					_pos = _posicion findEmptyPosition [10,60,_tipoVeh];
				};
			};
			//In frontilne no parked combat vehicles
			if ((!(_frontera) and {random 10 < 5}) or (_x in (["trucks", "cars_transport"]))) then {
				([_tipoVeh,_pos,"AAF", _dir] call AS_fnc_createEmptyVehicle) params ["_veh"];
				_vehiculos pushBack _veh;

				if (!(_x in ["trucks", "cars_transport"])) then {
					([_veh, "AAF", "crew"] call AS_fnc_createVehicleGroup) params ["_crewGroup", "_units"];

					private _patrolMarker = [_crewGroup, _veh, _location, _size*0.5] call AS_tactics_fnc_crew_sentry;

					_soldados append _units;
					_grupos pushback _crewGroup;
					_markers pushback _patrolMarker;
				};

				} else {
					([_tipoVeh, _location, "AAF"] call AS_fnc_spawnVehiclePatrol) params ["_veh2", "_group2", "_patrolMarker2"];
					_vehiculos pushback _veh2;
					_grupos pushBack _group2;
					_markers pushback _patrolMarker2;
				};
			sleep 1;
		};
	} foreach _vehClasses;

	//Create support vehicles, own group for each type

	private _support_pos_dir = [_location, 3] call AS_location_fnc_vehicleParking;

	{
		private _pos = (_support_pos_dir select 0) select _forEachIndex;
		private _dir = (_support_pos_dir select 1) select _forEachIndex;
		([_pos, _dir, _pos, "AAF", [_x]] call AS_fnc_spawnAAF_support) params ["_supVehs", "_supGroup", "_supUnits"];

		_vehiculos append _supVehs;
		_grupos pushback _supGroup;
		_soldados append _supUnits;
	} foreach ["ammo", "fuel", "repair"];

	// spawn patrols
	private _groupCount = (round (_size/45)) max 1; //Increased to 45 to 30 to make them less crowded
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
