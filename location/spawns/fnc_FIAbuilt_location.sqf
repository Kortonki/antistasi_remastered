#include "../../macros.hpp"

private _fnc_spawn = {
	params ["_location"];

	private _position = _location call AS_location_fnc_position;
	private _type = _location call AS_location_fnc_type;

	private _soldiers = [];
	private _groups = [];
	private _vehicles = [];
	private _markers = [];

	// Create the garrison
	(_location call AS_fnc_createFIAgarrison) params ["_soldados1", "_grupos1", "_marker1"];
	_soldiers append _soldados1;
	_groups append _grupos1;
	_markers pushback _marker1;

	if (_type == "roadblock") then {
		/*private _tam = 1;
		private _road = [];
		while {count _road == 0} do {
			_road = _position nearRoads _tam;
			if (count _road > 0) exitWith {};
			_tam = _tam + 5;
		};
		private _roadcon = roadsConnectedto (_road select 0);
		private _dirveh = [_road select 0, _roadcon select 0] call BIS_fnc_DirTo;*/

		//private _vehicleType = [count (["FIA", "team_at"] call AS_fnc_getEntity), "DESCEND"] call AS_fnc_getFIABestSquadVehicle;
		/*private _rbVehs = AS_P("vehicles") select {_x distance _position < _size and {!(typeOf _x in AS_allStatics)}};
		{
			private _veh = _x;
			_veh lock 3;

			private _gunner = selectRandom _soldiers;
			//group _gunner addVehicle _veh;
			_gunner moveInGunner _veh;
			_gunner assignAsGunner _veh;
		} foreach _rbVehs;*/
		//TODO: use FIA RB composition
		{
				_vehicles pushBack _x;
		} forEach (([_position] call fnc_RB_placeDouble) select 0);
	};

	if (_type == "camp") then {
		private _campBox = objNull;
		// find a suitable position
		_position = _position findEmptyPosition [5,50,"I_Heli_Transport_02_F"];

		// spawn the camp objects
		private _objs = ([_position, floor(random 360), selectRandom AS_campList] call BIS_fnc_ObjectsMapper);
		{
			call {
				if (typeof _x == "Box_NATO_Equip_F") exitWith {_campBox = _x;};
				if (typeof _x == "Land_MetalBarrel_F") exitWith {[_x,"refuel"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];};
				if (typeof _x == "Land_Campfire_F") exitWith {_x inflame true;};
			};
			_x setVectorUp (surfaceNormal (position _x));
		} forEach _objs;

		_vehicles append _objs;

		[_campBox] call AS_fnc_emptyCrate;

		// adds options to access the box
		[_campBox,"heal_camp"] RemoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
		[_campBox,"arsenal"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
		[_campBox,"transferFrom"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];

		//OBSOLETE if no arsenal waiting
		//_campBox addEventHandler ["ContainerOpened", {_this spawn AS_fnc_showUnlocked}];

		[_location, "campBox", _campBox] call AS_spawn_fnc_set;
	};

	{
		[_x, _location] spawn AS_location_fnc_reveal;
	} foreach (_soldiers);

	_location spawn AS_location_fnc_revealLoc;


	[_location, "resources", [taskNull, _groups, _vehicles, _markers]] call AS_spawn_fnc_set;
	[_location, "soldiers", _soldiers] call AS_spawn_fnc_set;
	[_location, "FIAsoldiers", _soldiers] call AS_spawn_fnc_set;
};

private _fnc_wait_for_destruction = {
	params ["_location"];
	private _position = _location call AS_location_fnc_position;
	private _type = _location call AS_location_fnc_type;

	private _soldiers = [_location, "FIAsoldiers"] call AS_spawn_fnc_get;

	//is _wasabondoned obsolete as abandonfialocation abandons on its own?
	private _wasAbandoned = ({!(isnil{_x getVariable "marcador"})} count _soldiers == 0);  // abandoned when it has no garrison
	private _wasDestroyed = ({alive _x} count _soldiers) == 0;

	private _destroyed = false;

	waitUntil {sleep AS_spawnLoopTime;
 _wasAbandoned = ({!(isnil{_x getVariable "marcador"})} count _soldiers == 0);  // abandoned when it has no garrison
 _wasDestroyed = ({alive _x} count _soldiers) == 0;
		_wasAbandoned or !(_location call AS_location_fnc_spawned) or _wasDestroyed
	};

	if _wasDestroyed then {
		[5,-5,_position] remoteExec ["AS_fnc_changeCitySupport",2];
		_destroyed = true;

		switch _type do {
			case "roadblock": {
				["TaskFailed", ["", "Roadblock Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
			};
			case "watchpost": {
				["TaskFailed", ["", "Watchblock Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
			};
			case "camp": {
				["TaskFailed", ["", "Camp Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
			};
			default {
				["TaskFailed", ["", "Location Lost"]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
			};
		};
	};

	[_location, "destroyed", _destroyed] call AS_spawn_fnc_set;
};

private _fnc_wait_to_abandon = {
	params ["_location"];
	private _type = _location call AS_location_fnc_type;

	private _soldiers = [_location, "FIAsoldiers"] call AS_spawn_fnc_get;
	private _destroyed = [_location, "destroyed"] call AS_spawn_fnc_get;

	private _wasAbandoned = ({!(isnil{_x getVariable "marcador"})} count _soldiers == 0);  // abandoned when garrison is released
	private _toRemove = false; //This is passed to the clean function

	waitUntil {sleep AS_spawnLoopTime;
		_wasAbandoned or _destroyed or !(_location call AS_location_fnc_spawned)
	};

	if (_wasAbandoned or _destroyed) then {
		_toRemove = true;
	};

	if _destroyed then {
		if (_type == "camp") then {
			// remove 10% of every item (rounded up) from caja
			//waitUntil {not AS_S("lockTransfer")};
			//AS_Sset("lockTransfer", true);

			//Improved removal, no variable checks but UNSCHEDULED at SERVER to avoid errors due to lag etc.
			 ([caja, true] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

				   {
		        private _values = _x select 1;
		        for "_i" from 0 to (count _values - 1) do {
		            private _new_value = floor ((_values select _i)*0.1);
		            _values set [_i, _new_value];
		        };
		    } forEach [_cargo_w, _cargo_m, _cargo_i, _cargo_b];

				[[_cargo_w, _cargo_m, _cargo_i, _cargo_b]] remoteExecCall ["AS_fnc_removeFromArsenal", 2];
		};
	} else {
		if (_wasAbandoned) then {
			_location call AS_fnc_garrisonRelease;
		};
		if (_type == "camp") then {
			[[_location, "campBox"] call AS_spawn_fnc_get, caja] call AS_fnc_transferToBox;
		};
	};
	[_location, "toRemove", _toRemove] call AS_spawn_fnc_set;
};


private _fnc_clean = {
		params ["_location"];

		private _toRemove = [_location, "toRemove"] call AS_spawn_fnc_get;

		if (!_toRemove) then {
			_location call AS_location_spawn_fnc_FIAlocation_clean;
		} else {

			([_location, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];
			[_groups,  _vehicles, _markers] call AS_fnc_cleanResources;
			[_location, false] call AS_location_fnc_knownLocations;

			//Set the side to empty to trigger possible defend location mission fail so below waituntil can finish
			[_location, "side", "EMPTY"] call AS_location_fnc_set;
			//Check for active defence missions before removing location.
			waitUntil {sleep AS_spawnLoopTime; (call AS_mission_fnc_active_missions) find (format ["defend_location_%1", _location]) == -1};
			[_location] remoteExec ["AS_location_fnc_remove", 2];
			[_location, "delete", true] call AS_spawn_fnc_set;

	};

};


AS_spawn_createFIAbuilt_location_states = ["spawn", "wait_for_destruction", "wait_to_abandon", "clean"];
AS_spawn_createFIAbuilt_location_state_functions = [
	_fnc_spawn,
	_fnc_wait_for_destruction,
	_fnc_wait_to_abandon,
	_fnc_clean
];
