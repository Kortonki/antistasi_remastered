#include "../../macros.hpp"

private _fnc_initialize = {
	params ["_mission"];
	private _locationType = [_mission, "locationType"] call AS_mission_fnc_get;
	private _position = [_mission, "position"] call AS_mission_fnc_get;

	if !(_locationType in ["watchpost","roadblock","camp"]) exitwith {
		diag_log format ["[AS] Error: establishFIALocation called with wrong type '%1'", _locationType];
	};

	private _locationName = "";
	switch _locationType do {
		case "watchpost": {
			_locationName = "watchpost";
		};
		case "roadblock": {
			_locationName = "roadblock";
		};
		case "camp": {
			_locationName = "camp";
		};
	};
	private _taskTitle = format ["Establish %1", _locationName];
	private _taskDesc = format ["The vehicle to establish the %1 is ready. Drive it to the destination.", _locationName];

	// give 30m to complete mission
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30];

	// this is a hidden marker used by the task.
	// If the mission is completed, it becomes owned by the new location
	private _mrk = createMarker [format ["FIAlocation%1", (diag_tickTime / 60)], _position];
	_mrk setMarkerShape "ELLIPSE";
	_mrk setMarkerSize [50,50];
	_mrk setMarkerAlpha 0;

	[_mission, [_taskDesc, _taskTitle, _mrk], _position, "Move"] call AS_mission_spawn_fnc_saveTask;
	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
	[_mission, "resources", [taskNull, [], [], [_mrk]]] call AS_spawn_fnc_set;
};

private _fnc_spawn = {
	params ["_mission"];
	private _vehType = [_mission, "vehicleType"] call AS_mission_fnc_get;
	private _groupType = [_mission, "groupType"] call AS_mission_fnc_get;
	private _locationType = [_mission, "locationType"] call AS_mission_fnc_get;

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	private _vehicles = [];
	private _group = createGroup ("FIA" call AS_fnc_getFactionSide);
	[_groupType, getMarkerPos "FIA_HQ", _group] call AS_fnc_spawnFIAsquad;
	AS_commander hcSetGroup [_group];
	_group setVariable ["isHCgroup", true, true];
	{[_x] remoteExecCall ["AS_fnc_initUnitFIA", _x]} forEach units _group;

	// get a road close to the FIA_HQ
	// if there's a vehicle spawn pad, use it

	private _pos = [];

	if !(isNil "vehiclePad") then {
		_pos = (position vehiclePad) findEmptyPosition [0,30,_vehType];
	} else {

		private _tam = 10;
		private _roads = [];
		while {count _roads == 0} do {
			_roads = getMarkerPos "FIA_HQ" nearRoads _tam;
			_tam = _tam + 10;
		};
		private _road = _roads select 0;
		_pos = (position _road) findEmptyPosition [0,30,_vehType];
	};

	if (isNil "_pos") exitWith {
				_pos = getMarkerPos "FIA_HQ";
	 };

	// create vehicle
	private _vehicle = createvehicle [_vehType, _pos, [], 0, "NONE"];
	[_vehicle, "FIA"] call AS_fnc_initVehicle;
	_vehicles pushBack _vehicle;

	if (_locationType == "camp") then {
		private _crate = (typeOf caja) createVehicle _pos;
		_crate attachTo [_vehicle, [0.0,-1.2,0]];
		_vehicles pushBack _crate;
	};

	//Crate is fixed to the vehicle for now: Vehicle is left to the location so it must be delivered too
	//TODO: Rewrite this so box and men are only needed in destination, vehicles optional

	{
		if (_vehicle emptypositions "Gunner" > 0) then {
				_x assignasgunner _vehicle;
				_x moveingunner _vehicle;
		} else {
			if (_vehicle emptyPositions "Commander" > 0) then {
				_x assignasCommander _vehicle;
				_x moveinCommander _vehicle;
			} else {
				_x assignasCargo _vehicle;
				_x moveincargo _vehicle;
			};
		};
		[_x] allowGetin true;
		[_x] orderGetin true;
	} foreach (units _group);
	leader _group setBehaviour "SAFE";
	[_group, _vehicle] spawn AS_AI_fnc_dismountOnDanger;

	private _markers = ([_mission, "resources"] call AS_spawn_fnc_get) select 3;
	[_mission, "resources", [_task, [_group], _vehicles, _markers]] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_mission"];
	private _locationType = [_mission, "locationType"] call AS_mission_fnc_get;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _position = [_mission, "position"] call AS_mission_fnc_get;
	private _resources = [_mission, "resources"] call AS_spawn_fnc_get;
	private _task = _resources select 0;
	private _group = _resources select 1 select 0;
	private _vehicle = _resources select 2 select 0;
	private _crate = _resources select 2 select 1;
	private _mrk = _resources select 3 select 0;

	private _success = false;
	waitUntil {sleep 5;
		_success = ({alive _x and (_x distance2d _position) < 50} count units _group > 0) and {_vehicle distance _position < 50};

		_success or ({alive _x} count units _group == 0) or (dateToNumber date > _max_date) or not(alive _vehicle)
	};

	if _success then {
		if (isPlayer leader _group) then {
			remoteExec ["AS_fnc_completeDropAIcontrol", leader _group];
			waitUntil {!(isPlayer leader _group)};
		};

		[_mrk, _locationType, false] call AS_location_fnc_add;
		// location takes ownership of _mrk
		if (_locationType == "camp") then {
			private _name = selectRandom campNames;
			campNames = campNames - [_name];
			[_mrk, "name", _name, false] call AS_location_fnc_set;
		};
		[_mrk, "side", "FIA"] call AS_location_fnc_set;
		_resources set [3, []];
		[_mission, "resources", _resources] call AS_spawn_fnc_set;

		// add the vehicle to the location. Roadblock spawns this vehicle already
		private _newVehicle = (typeOf _vehicle) createVehicle (getMarkerPos _mrk findEmptyPosition [0,30, typeOf _vehicle]);
		[_newVehicle, "FIA"] call AS_fnc_initVehicle;
		[_newVehicle] remoteExec ["AS_fnc_changePersistentVehicles", 2];

		// add the team to the garrison
		//TODO: this needs a check for towing. If towing the veh while mission completes, duplicate stuff
		private _garrison = [_mrk, "garrison"] call AS_location_fnc_get;
		{
			if (alive _x) then {
				([_x, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
				[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
				[cajaVeh, _remains] call AS_fnc_addMagazineRemains;

				_garrison pushBack (_x call AS_fnc_getFIAUnitType);
				[_x] remoteExecCall ["deleteVehicle", _x];
			};

		} forEach units _group;
		AS_commander hcRemoveGroup _group;
		[_mrk, "garrison", _garrison] call AS_location_fnc_set;

		//Recover fuel from the vehicle, it doesn't move

		private _fuel = _vehicle call AS_fuel_fnc_getVehicleFuel;
		if (finite (getFuelCargo _vehicle)) then {_fuel = _fuel + (_vehicle getVariable ["fuelCargo",0])};
		[_fuel] RemoteExec ["AS_fuel_fnc_changeFIAfuelReserves", 2];

		_vehicle setvelocity [0,0,0];
		moveOut (driver _vehicle);
		[_vehicle] remoteExecCall ["deleteVehicle", _vehicle];
		{[_x] remoteExecCall ["deleteVehicle", _x]} forEach attachedObjects _vehicle;

		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_success", 2];
	} else {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];


		[_mission, "resources", [_task, [], [], _markers]] call AS_spawn_fnc_set;

		_group addVehicle _vehicle;
		[[_group]] remoteExec ["AS_fnc_dismissFIAsquads", _group];
	};
};

AS_mission_establishFIAlocation_states = ["initialize", "spawn", "run", "clean"];
AS_mission_establishFIAlocation_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_run,
	AS_mission_spawn_fnc_clean
];
