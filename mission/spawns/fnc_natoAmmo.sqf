#include "../../macros.hpp"

private _fnc_initialize = {
	params ["_mission"];
	private _position = [_mission, "position"] call AS_mission_fnc_get;

	private _mrkfin = createMarker [_mission, _position];
	_mrkfin setMarkerShape "ICON";
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + 60];

	private _tskTitle = format ["%1 Ammodrop", (["NATO", "shortname"] call AS_fnc_getEntity)];
	private _tskDesc = format ["Our Commander has asked %1 for a supply drop. Command the transport with your HC module and bring it to the designated position. Once it has landed you are free to use the equipment or bring it back to HQ.",
		(["NATO", "shortname"] call AS_fnc_getEntity)];

	[_mission, [_tskDesc,_tskTitle,_mrkfin], _position, "rifle"] call AS_mission_spawn_fnc_saveTask;
	[_mission, "resources", [taskNull, [], [], [_mrkfin]]] call AS_spawn_fnc_set;
	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
};

private _fnc_spawn = {
	params ["_mission"];

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	private _vehicles = [];
	private _groups = [];

	private _orig = getMarkerPos "spawnNATO";

	// get heli with largest capacity (cargo transport)
	private _heli = [];
	{
		_heli pushBack [_x, getNumber (configfile >> "CfgVehicles" >> _x >> "transportSoldier")];
	} forEach (["NATO", "helis_transport"] call AS_fnc_getEntity);
	_heli = (([_heli, [], {_x select 1}, "DESC"] call BIS_fnc_sortBy) select 0) select 0;

	([_heli, _orig, random 360, "NATO", "any", 0, "FLY"] call AS_fnc_createVehicle) params ["_heliVeh", "_grupoHeli"];
	_groups pushBack _grupoHeli;
	_vehicles pushback _heliVeh;

	_heliVeh disableAI "TARGET";
	_heliVeh disableAI "AUTOTARGET";
	_heliVeh flyInHeight 200;
	_grupoHeli setCombatMode "BLUE";

	AS_commander hcSetGroup [_grupoHeli];
	_grupoHeli setVariable ["isHCgroup", true, true];

	private _markers = ([_mission, "resources"] call AS_spawn_fnc_get) select 3;
	[_mission, "resources", [_task, [_grupoHeli], _vehicles, _markers]] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_mission"];
	private _position = [_mission, "position"] call AS_mission_fnc_get;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _vehicles = ([_mission, "resources"] call AS_spawn_fnc_get) select 2;

	private _heli = _vehicles select 0;
	private _grupoHeli = (([_mission, "resources"] call AS_spawn_fnc_get) select 1) select 0;

	waitUntil {sleep 1;
		(_heli distance2D _position < 100) or
		{!canMove _heli} or
		{dateToNumber date > _max_date}
	};

	if (_heli distance2D _position < 100) then {
		private _support = [_mission, "NATOsupport"] call AS_mission_fnc_get;
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_success", 2];
		private _chute = createVehicle ["B_Parachute_02_F", [0, 0, 0], [], 0, 'NONE'];
	    _chute setPos [getPos _heli select 0, getPos _heli select 1, (getPos _heli select 2) - 20];
	    private _crate = createVehicle [["NATO", "box"] call AS_fnc_getEntity, [0, 0, 0], [], 0, 'NONE'];
	    _crate attachTo [_chute, [0, 0, -1.3]];
	    [_crate, _support] call AS_fnc_fillCrateNATO;
	    _vehicles append [_chute, _crate];
	    private _wp3 = _grupoHeli addWaypoint [getMarkerPos "spawnNATO", 0];
		_wp3 setWaypointType "MOVE";
		_wp3 setWaypointSpeed "FULL";
		waitUntil {(position _crate select 2) < 2 || isNull _chute};
		detach _crate;
		[_crate, "loadCargo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
		_crate setVariable ["requiredVehs", ["Truck_F"], true];
		_crate setVariable ["asCargo", false, true];
		private _humo = "SmokeShellBlue" createVehicle (position _crate);
		_vehicles pushBack _humo;


	} else {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];
	};
	//Send enemy patrol to investigate the drop

	[[_position], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];

	_grupoHeli setVariable ["isHCgroup", false, true];
	AS_commander hcRemoveGroup _grupoHeli;
	[_heli, _grupoHeli] spawn {
		params ["_heli", "_grupoHeli"];
		waitUntil {sleep 5; _heli distance2D (getmarkerPos "spawnNATO") < 500 or ({alive _x} count (units _grupoHeli) == 0) };
		{
			_x setVariable ["BLUFORSpawn", false, true]; //This should activate the cleanup, no bluforspawn nearby
		} foreach (units _grupoHeli);
	};
};

AS_mission_natoAmmo_states = ["initialize", "spawn", "run", "clean"];
AS_mission_natoAmmo_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_run,
	AS_mission_spawn_fnc_clean
];
