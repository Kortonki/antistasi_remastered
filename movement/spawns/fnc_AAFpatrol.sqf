#include "../../macros.hpp"

private _fnc_spawn = {
	params ["_spawnName"];
	private _location = [_spawnName, "location"] call AS_spawn_fnc_get;
	private _base = [_spawnName, "base"] call AS_spawn_fnc_get;
	private _aeropuerto = [_spawnName, "airfield"] call AS_spawn_fnc_get;
	private _useCSAT = [_spawnName, "useCSAT"] call AS_spawn_fnc_get;
	private _isDirectAttack = [_spawnName, "isDirectAttack"] call AS_spawn_fnc_get;
	private _threatEval = [_spawnName, "threatEval"] call AS_spawn_fnc_get;

	private _isLocation = false;
	private _position = "";
	if (typeName _location == typeName "") then {
		_isLocation = true;
		_position = _location call AS_location_fnc_position;
	} else {
		_position = _location;
	};

	if _isLocation then {
		AS_Pset("patrollingLocations", AS_P("patrollingLocations") + [_location]);
	} else {
		AS_Pset("patrollingPositions", AS_P("patrollingPositions") + [_position]);
	};

	// lists of spawned stuff to delete in the end.
	private _vehiculos = [];
	private _grupos = [];
	private _markers = [];

	// save the marker or position
	//Location needs a patrol marker for good measure as well
	private _patrolMarker = createMarker [format ["patrol_%1_%2", (diag_tickTime), round(random 100)], _position];
	_patrolMarker setMarkerShape "RECTANGLE";
	_patrolMarker setMarkerSize [200, 200];
	_patrolMarker setMarkerAlpha 0;
	_markers pushBack _patrolMarker;

	private _origin = [];



	if (_base != "") then {
		_origin = _base call AS_location_fnc_positionConvoy;
		_aeropuerto = "";
		if (!_isDirectAttack) then {[_base,15] call AS_location_fnc_increaseBusy;};

		private _toUse = "trucks";
		if (_threatEval > 3 and {"apcs" call AS_AAFarsenal_fnc_countAvailable > 0}) then {
			_toUse = "apcs";
		};
		if (_threatEval > 5 and {"tanks" call AS_AAFarsenal_fnc_countAvailable > 0}) then {
			_toUse = "tanks";
		};

		([_toUse, _origin, _patrolMarker, _threatEval] call AS_fnc_spawnAAFlandAttack) params ["_groups1", "_vehicles1"];
		_grupos append _groups1;
		_vehiculos append _vehicles1;
	};

	if (_aeropuerto != "") then {
		if (!_isDirectAttack) then {[_aeropuerto,15] call AS_location_fnc_increaseBusy;};
		_origin = _aeropuerto call AS_location_fnc_position;
		private _cuenta = 1;
		if (_isLocation) then {_cuenta = 2};
		for "_i" from 1 to _cuenta do {  // the attack has 2 units for a non-marker
			private _toUse = "helis_transport";  // last attack is always a transport

			// first attack (1/2) can be any unit, stronger the higher the treat
			if (_i < _cuenta) then {
				if ("helis_armed" call AS_AAFarsenal_fnc_countAvailable > 0) then {
					_toUse = "helis_armed";
				};
				if (_threatEval > 15 and ("planes" call AS_AAFarsenal_fnc_countAvailable > 0)) then {
					_toUse = "planes";
				};
			};
			([_toUse, _origin, _position, _patrolMarker] call AS_fnc_spawnAAFairAttack) params ["_groups1", "_vehicles1"];
			_grupos = _grupos + _groups1;
			_vehiculos = _vehiculos + _vehicles1;
			sleep 30;
		};
	};

	if _useCSAT then {
		([_patrolMarker, 3, _threatEval] call AS_fnc_spawnCSATattack) params ["_groups1", "_vehicles1"];
		_grupos append _groups1;
		_vehiculos append _vehicles1;
	};

	[_spawnName, "resources", [taskNull, _grupos, _vehiculos, _markers]] call AS_spawn_fnc_set;
	[_spawnName, "origin", _origin] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_spawnName"];
	private _location = [_spawnName, "location"] call AS_spawn_fnc_get;
	private _origin = [_spawnName, "origin"] call AS_spawn_fnc_get;
	private _isLocation = false;
	private _position = "";

	if (typeName _location == typeName "") then {
		_isLocation = true;
		_position = _location call AS_location_fnc_position;
	} else {
		_position = _location;
		_location = (([_spawnName, "resources"] call AS_spawn_fnc_get) select 2) select 0; //Vehicle as location? Investigate
	};
	private _groups = (([_spawnName, "resources"] call AS_spawn_fnc_get) select 1);

	private _soldados = [];
	{
		_soldados append (units _x);
	} forEach _groups;

	if _isLocation then {
		private _tiempo = time + 3600; // 60 minutes

		waitUntil {sleep 10;
			({_x call AS_fnc_canFight} count _soldados) < ({!(_x call AS_fnc_canFight)} count _soldados) or
			_location call AS_location_fnc_side == "AAF" or
			time > _tiempo
		};

		AS_Pset("patrollingLocations", AS_P("patrollingLocations") - [_location]);
		waitUntil {sleep 10; not (_location call AS_location_fnc_spawned)};
	} else {
		private _tiempo = time + 1800; //30 minutes
		//TODO: arrange pickup for the troops

		waitUntil {sleep 10; time > _tiempo or ({_x call AS_fnc_canFight} count _soldados) < ({!(_x call AS_fnc_canFight)} count _soldados)};


		AS_Pset("patrollingPositions", AS_P("patrollingPositions") - [_position]);
	};

	//RTB
	{
			[_x, "AWARE"] remoteExec ["setBehaviour", _x];
			[_x, "GREEN"] remoteExec ["setCombatmode", _x];
			[_x, _origin]  remoteExec ["move", _x];
	} foreach (_groups select {(leader _x) call AS_fnc_getSide == "AAF"});

	//This leaves quite a lot of groups retreating and costs perfomance vise
	//Also throws undefined error for _return (empty foreach loop? = nil)
	/*waitUntil {sleep 10;
	private _return = true;
	_return = {
		if ((position _x) distance2D _origin > 300) exitWith {false};
		true
		} foreach (_soldados select {alive _x and {!(_x call AS_medical_fnc_isUnconscious)}});
	_return
	};*/
};

private _fnc_clean = {
	params ["_spawnName"];
	private _groups = (([_spawnName, "resources"] call AS_spawn_fnc_get) select 1);
	private _vehicles = (([_spawnName, "resources"] call AS_spawn_fnc_get) select 2);
	private _markers = (([_spawnName, "resources"] call AS_spawn_fnc_get) select 3);

	//Choose only alive for cleanup -> dead are handled already by other function and bodies lootable

	[_groups, _vehicles, _markers] call AS_fnc_cleanMissionResources;
	[_spawnName, "delete", true] call AS_spawn_fnc_set;
};

AS_spawn_patrolAAF_states = ["spawn", "run", "clean"];
AS_spawn_patrolAAF_state_functions = [
	_fnc_spawn,
	_fnc_run,
	_fnc_clean
];
