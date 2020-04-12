#include "../../macros.hpp"
private _fnc_spawn = {
	params ["_location"];

	private _soldados = [];
	private _grupos = [];
	private _vehiculos = [];
	private _markers = [];

	private _posicion = _location call AS_location_fnc_position;
	private _size = _location call AS_location_fnc_size;
	private _frontera = _location call AS_fnc_location_isFrontline;
	private _busy = _location call AS_location_fnc_busy;

	_findPlaneParking = {
		private _return = [];
		{
			private _type = toLowerANSI (typeof _x);
			//This finds all hangars, but excludes those with "2" referring to double hanagas (checked with vanilla + cup objects)
			if (_type find "hangar" > -1 and {!(_type find "ruins" > -1) and {!(_type find "2" > -1)}}) then {
				_return pushback _x;
			};
		} foreach _this; //_this is array from nearestobjects
		_return
	};

	_vehiculos append (_location call AS_fnc_spawnComposition);

	private _helipads = _vehiculos select {_x isKindOf "Heli_H"};
	private _planepads = _vehiculos call _findPlaneParking;

	// spawn flag
	private _flag = createVehicle [["AAF", "flag"] call AS_fnc_getEntity, _posicion, [],0, "CAN_COLLIDE"];
	_flag allowDamage false;
	_vehiculos pushBack _flag;

	// spawn crate
	private _veh = (["AAF", "box"] call AS_fnc_getEntity) createVehicle _posicion;
	[_veh, "Airfield"] call AS_fnc_fillCrateAAF;
	_vehiculos pushBack _veh;

	//create _bunker, only if there's no preset composition
	if (!([([AS_compositions, "locations"] call DICT_fnc_get), _location] call DICT_fnc_exists)) then {
		private _bunker = AS_big_bunker_type createVehicle ([_posicion, 0, 50, 5, 0, 5, 0,[], _posicion] call BIS_Fnc_findSafePos);
		_vehiculos pushBack _bunker;
	};


	private _grupo = createGroup ("AAF" call AS_fnc_getFactionSide);
	_grupos pushBack _grupo;
	//spawn at
	private _atAmount = ["static_at", "airfield"] call AS_location_fnc_vehicleAmount;

	// spawn AT road checkpoint
	for "_i" from 1 to (_atAmount min ("static_at" call AS_AAFarsenal_fnc_countAvailable)) do {
		if ((_location call AS_location_fnc_spawned)) then {
			([_posicion, _grupo, 0] call AS_fnc_spawnAAF_roadAT) params ["_units1", "_vehicles1"];
			_soldados append _units1;
			_vehiculos append _vehicles1;
		};
	};

	private _aaAmount = ["static_aa", "airfield"] call AS_location_fnc_vehicleAmount;

		// spawn AA
		for "_i" from 1 to (_aaAmount min ("static_aa" call AS_AAFarsenal_fnc_countAvailable)) do {
			if ((_location call AS_location_fnc_spawned)) then {

				([_posicion, _grupo, _size, 0] call AS_fnc_spawnAAF_AA) params ["_units1", "_vehicles1"];
				_soldados append _units1;
				_vehiculos append _vehicles1;
			};
		};

	//Populate mil buildings and add choppers to pads

	([_location, "AAF", _grupo, true] call AS_fnc_populateMilBuildings) params ["_gunners2", "_vehicles2", "_groups2", "_markers2"];
	{[_x, false] call AS_fnc_initUnitAAF} forEach _gunners2;
	_soldados append _gunners2;
	_vehiculos append _vehicles2;
	_grupos append _groups2;
	_markers append _markers2;

	{
		_soldados append (units _x);
	} foreach _groups2;

	// spawn 4 patrols
	// _mrk => to be deleted at the end
	([_location, 4] call AS_fnc_spawnAAF_patrol) params ["_units1", "_groups1", "_mrk"];
	_grupos append _groups1;
	_markers pushback _mrk;

	// spawn parked air vehicles

	//Find pads which were not in composition but in the map instead
  _helipads append nearestObjects [_posicion, ["HeliH"], _size, true];
	_planepads append ((nearestObjects [_posicion, ["House"], _size, true]) call _findPlaneParking);
	//Here no arrayintersect for uniques: duplicates will be deleted anyway.

	//private _pos = _posicion findEmptyPosition [10, _size/2, "I_Heli_Transport_02_F"];
	//posOrig is only for automatic locations if no pads
	private _ang = markerdir _location;
	private _posOrig = [_flag, -(_size*0.5), _ang + 90] call BIS_fnc_relPos;
	private _pos = +_posOrig;
	private _airVehClasses = ("airfield" call AS_location_fnc_vehicleClasses) arrayIntersect ["helis_transport", "helis_armed", "planes"];

	{
		if !(_location call AS_location_fnc_spawned) exitWith {};
		private _vehCount = [_x, "airfield"] call AS_location_fnc_vehicleAmount;

		for "_i" from 1 to (_vehCount min (_x call AS_AAFarsenal_fnc_countAvailable)) do {

			private _pad = objNull;


			private _tipoVeh = selectRandom ([_x] call AS_AAFarsenal_fnc_valid);

			//If frontline make some armed helis to patrol
			if (_frontera and {_x in ["helis_armed", "planes"] and {random 10 < 5}}) then {

				([_tipoVeh, _posicion, _ang, "AAF", "pilot", 200, "FLY"] call AS_fnc_createVehicle) params ["_veh", "_pilotGroup", "_pilot"];

				_soldados append (units _pilotGroup);
				_grupos pushback _pilotGroup;

				[_posicion, _posicion, _pilotGroup] spawn AS_tactics_fnc_heli_attack;

			//Otherwise fiddle with empty locations
			} else {

				if (count _helipads > 0 and {_x in ["helis_transport", "helis_armed"]}) then {
					_pad = _helipads select 0;
					_pos = getpos _pad;
					_ang = getdir _pad;
					_helipads = _helipads - [_pad]; // Do not use the same twice
				};

				if (count _planepads > 0 and {_x == "planes"}) then {
					_pad = _planepads select 0;
					_pos = getpos _pad;
					_ang = getdir _pad;
					_planepads = _planepads - [_pad]; // Do not use the same twice
				};

				if (isnull _pad) then {

					_pos = [_posOrig, _size*0.05,_ang + 90] call BIS_fnc_relPos; //If no longer landing pads, next one is 20 meters to the right of the last pad
				 	_posOrig = _pos;
				};
					//Aditional check
					//Commented out, need solid object classes to avoid, with no class avoids also helipads, which are also buildings
					/*
					if (count (nearestObjects [_pos, [], 5, true]) > 0) then {
						_pos = [_posOrig, 0, _size*0.5, 7, 0, 0.3, 0, [], [_posOrig, [0,0,0]]] call BIS_Fnc_findSafePos;
						_posOrig = _pos;
					};*/

				([_tipoVeh,_pos,"AAF", _ang] call AS_fnc_createEmptyVehicle) params ["_veh"];
				sleep 0.5;
				_vehiculos pushBack _veh;

				([_veh, "AAF", "pilot"] call AS_fnc_createVehicleGroup) params ["_pilotGroup", "_units"];

				private _patrolMarker = [_pilotGroup, _veh, _location, _size*0.5] call AS_tactics_fnc_crew_sentry;

				_soldados append _units;
				_grupos pushback _pilotGroup;
				_markers pushback _patrolMarker;
				};
			};
			sleep 1;
			//Switch side for automatic placing, but only for once:
			if (_forEachIndex == 0) then {
				_posOrig = [position _flag, (_size*0.1), _ang + 90] call BIS_fnc_relPos;
			};
	} foreach _airVehClasses;


	// spawn parked land vehicles
	//TODO check if the following functions check for arsenal availability for vehicles
	private _groupCount = round (_size/60);


	// spawn parked vehicles


	private _LandvehClasses = ("airfield" call AS_location_fnc_vehicleClasses) arrayIntersect ["cars_transport", "cars_armed", "trucks", "apcs"];
	{
		if !(_location call AS_location_fnc_spawned) exitWith {};
		private _vehCount = [_x, "airfield"] call AS_location_fnc_vehicleAmount;

		//Find parking for vehicle class

		private _pos_dir = [_location, _vehCount] call AS_location_fnc_vehicleParking;

		for "_i" from 0 to ((_vehCount min (_x call AS_AAFarsenal_fnc_countAvailable)) - 1) do {

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
			if ((!(_frontera) and {random 10 <= 5}) or (_x in (["trucks", "cars_transport"]))) then {
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
	} foreach _landVehClasses;

	private _support_pos_dir = [_location, 3] call AS_location_fnc_vehicleParking;

	{
		private _pos = (_support_pos_dir select 0) select _forEachIndex;
		private _dir = (_support_pos_dir select 1) select _forEachIndex;
		([_pos, _dir, _pos, "AAF", [_x]] call AS_fnc_spawnAAF_support) params ["_supVehs", "_supGroup", "_supUnits"];

		_vehiculos append _supVehs;
		_grupos pushback _supGroup;
		_soldados append _supUnits;
	} foreach ["ammo", "fuel", "repair"];

	// spawn guarding squads
	if (_frontera) then {_groupCount = _groupCount * 2};
	([_location, 1 + _groupCount] call AS_fnc_spawnAAF_patrolSquad) params ["_units1", "_groups1"];
	_soldados append _units1;
	_grupos append _groups1;



	[_location, _grupos] call AS_fnc_spawnJournalist;

	[_location, "resources", [taskNull, _grupos, _vehiculos, _markers]] call AS_spawn_fnc_set;
	[_location, "soldiers", _soldados] call AS_spawn_fnc_set;
};

AS_spawn_createAAFairfield_states = ["spawn", "wait_capture", "clean"];
AS_spawn_createAAFairfield_state_functions = [
	_fnc_spawn,
	AS_location_spawn_fnc_AAFwait_capture,
	AS_location_spawn_fnc_AAFlocation_clean
];
