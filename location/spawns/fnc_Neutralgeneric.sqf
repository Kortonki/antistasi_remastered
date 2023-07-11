#include "../../macros.hpp"

private _fnc_spawn = {
	params ["_location"];

	// Spawned stuff
	private _grupos = [];
	private _vehiculos = [];
	private _markers = [];
	private _civs = [];

	_vehiculos append (_location call AS_fnc_spawnComposition);

	private _posicion = _location call AS_location_fnc_position;
	private _size = _location call AS_location_fnc_size;
	private _type = _location call AS_location_fnc_type;
	private _isDestroyed = _location in AS_P("destroyedLocations");

	if (_type != "city") then {
		// The flag
		private _veh = createVehicle [["CIV", "flag"] call AS_fnc_getEntity, _posicion, [],0, "CAN_COLLIDE"];
		_veh allowDamage false;
		_vehiculos pushBack _veh;
		//create _bunker, only if there's no preset composition
		//THis commented out for now, bunkers tend to get in the way
		/*if (!([([AS_compositions, "locations"] call DICT_fnc_get), _location] call DICT_fnc_exists)) then {
			private _bunker = AS_big_bunker_type createVehicle ([_posicion, 0, 50, 5, 0, 5, 0,[], _posicion] call BIS_Fnc_findSafePos);
			_vehiculos pushBack _bunker;
		};*/
		// worker civilians in non-military non-destroyed markers
		if ((_type in ["powerplant","resource","factory"]) and !_isDestroyed) then {
			if ((daytime > 8) and (daytime < 18)) then {
				private _grupo = createGroup civilian;
				_grupos pushBack _grupo;
				for "_i" from 1 to 8 do {
					private _civ = _grupo createUnit ["C_man_w_worker_F", _posicion, [],0, "NONE"];
					[_civ] spawn AS_fnc_initUnitCIV;
					_civs pushBack _civ;
					sleep 0.5;
				};
				[_location,_civs] spawn AS_fnc_location_canBeDestroyed;  // power shuts if everyone is killed
				[leader _grupo, _location, "SAFE", "SPAWNED","NOFOLLOW", "NOSHARE","DORELAX","NOVEH2"] spawn UPSMON;
			};
		};
	};


	[_location, _grupos] call AS_fnc_spawnJournalist;

	[_location, "resources", [taskNull, _grupos, _vehiculos, _markers]] call AS_spawn_fnc_set;

};

private _fnc_run = {
	params ["_location"];
	private _type = _location call AS_location_fnc_type;

	if !(_type in ["fia_hq","city"]) then {
		_location call AS_location_spawn_fnc_Neutralwait_capture;
	} else {
		waitUntil {AS_spawnLoopTime; !(_location call AS_location_fnc_spawned)};
	};
};

AS_spawn_createNeutralgeneric_states = ["spawn", "run", "clean"];
AS_spawn_createNeutralgeneric_state_functions = [
	_fnc_spawn,
	_fnc_run,
	AS_location_spawn_fnc_Neutrallocation_clean
];
