#include "../../macros.hpp"

private _fnc_initialize = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	private _base = [_mission, "base"] call AS_mission_fnc_get;
	private _airfield = [_mission, "airfield"] call AS_mission_fnc_get;
	private _useCSAT = [_mission, "useCSAT"] call AS_mission_fnc_get;

	private _name = [_location] call AS_fnc_location_name;

	private _tskTitle = "Defend " + _name;
	private _tskDesc = (["AAF", "name"] call AS_fnc_getEntity) + " is attacking %1. Defend it or we lose it";
	if _useCSAT then {
		_tskDesc = (format ["%1 and %2", (["AAF", "name"] call AS_fnc_getEntity), ["CSAT", "name"] call AS_fnc_getEntity]) + " are attacking %1. Defend it or we lose it";
	};
	_tskDesc = format [_tskDesc,_name];

	[_mission, [_tskDesc,_tskTitle,_location], _position, "Defend"] call AS_mission_spawn_fnc_saveTask;
};

private _fnc_spawn = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _base = [_mission, "base"] call AS_mission_fnc_get;
	private _airfield = [_mission, "airfield"] call AS_mission_fnc_get;
	private _useCSAT = [_mission, "useCSAT"] call AS_mission_fnc_get;

	[_location, true] call AS_location_fnc_spawn;

	private _patrolMarker = createMarker [format ["def_%1", round (diag_tickTime/60)], _position];
	_patrolMarker setMarkerShape "ELLIPSE";
	_patrolMarker setMarkerSize [50,50];
	_patrolMarker setMarkerAlpha 0;


	private _threatEvalAir = 0;
	if (_airfield != "" or _useCSAT) then {_threatEvalAir = [_position] call AS_fnc_getAirThreat};

	private _threatEvalLand = 0;
	if (_base != "") then {_threatEvalLand = [_position] call AS_fnc_getLandThreat};

	private _groups = [];
	private _vehicles = [];

	//CSAT attack

	if (_useCSAT) then {

		[5,0] remoteExec ["AS_fnc_changeForeignSupport",2];
		private _cuenta = 3;
		if ((_base == "") or (_airfield == "")) then {_cuenta = 6};

		([_location, _cuenta, _threatEvalAir] call AS_fnc_spawnCSATattack) params ["_groups1", "_vehicles1"];
		_groups append _groups1;
		_vehicles append _vehicles1;

		// drop artillery at bases or airfields
		[["TaskSucceeded", ["", format ["%1 under artillery fire",[_location] call AS_fnc_location_name]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		[_location] spawn {
			params ["_location"];
			if ((AS_P("CSATSupport")) >= 50) then {
				for "_i" from 0 to round(random (AS_P("CSATSupport")/25)) do {
					[_location, selectRandom (["CSAT", "planes"] call AS_fnc_getEntity)] spawn AS_fnc_activateAirstrike;
					sleep 30;
				};
			};
			if ((AS_P("CSATSupport")) >= 25) then {
				[_location] spawn AS_fnc_dropArtilleryShells;
			};
		};
	};

	private _originPos = [];
	if (_base != "") then {
		[_base,60] call AS_location_fnc_increaseBusy;
		_originPos = _base call AS_location_fnc_positionConvoy;
		private _size = _base call AS_location_fnc_size;

		// compute number of trucks based on the marker size -> this is stupid, different places have varying marker size not representing the danger
		//Enchantement: threat evaluation
		//Attack size is dependent on how much arsenal AAF has and threat evaluation TODO: prolly NEEDS BALANCING,
		//private _nVeh = (round (_size/30)) max 1;
		private _arsenalCount = (["trucks", "apcs", "tanks"] call AS_AAFarsenal_fnc_countAvailable);
		private _nVeh = (round((_threatEvalLand/2)*(_arsenalCount/50)) max 1) min (_arsenalCount min 10);




		// spawn them
		for "_i" from 1 to _nVeh do {
			private _toUse = "trucks";
			if (_threatEvalLand > 3 and ("apcs" call AS_AAFarsenal_fnc_countAvailable > 0)) then {
				_toUse = "apcs";
			};
			if (_threatEvalLand > 5 and ("tanks" call AS_AAFarsenal_fnc_countAvailable > 0)) then {
				_toUse = "tanks";
			};
			([_toUse, _originPos, _patrolMarker, _threatEvalLand] call AS_fnc_spawnAAFlandAttack) params ["_groups1", "_vehicles1"];
			_groups append _groups1;
			_vehicles append _vehicles1;
			sleep 5;
		};
		diag_log format ["[AS] DefendLocation: Number of vehicles: %1, ThreatEval Land: %2, Location: %3 ArsenalCount: %4", _nVeh, _threatEvalLand, _location, _arsenalCount];
	};

	if (_airfield != "") then {
		[_airfield,60] call AS_location_fnc_increaseBusy;
		if (_base != "") then {sleep ((_originPos distance _position)/16)};

		_originPos = _airfield call AS_location_fnc_position;
		_originPos set [2,300];

		// spawn a UAV
		private _uavTypes = ["AAF", "uavs_attack"] call AS_fnc_getEntity;
		if (count _uavTypes != 0) then {
			private _uav = createVehicle [selectRandom _uavTypes, _originPos, [], 0, "FLY"];
			_uav flyInHeight 1000; // so it is in safe altitude.
			_vehicles pushBack _uav;
			[_uav, "AAF"] call AS_fnc_initVehicle;
			[_uav, "UAV"] spawn AS_fnc_setConvoyImmune;
			createVehicleCrew _uav;
			private _grupouav = group (crew _uav select 0);
			_groups pushBack _grupouav;
			{[_x] call AS_fnc_initUnitAAF} forEach units _grupouav;
			private _uwp0 = _grupouav addWayPoint [_position,0];
			_uwp0 setWaypointType "LOITER";
		};

		for "_i" from 1 to 3 do {
			private _toUse = "helis_transport";  // last attack is always a transport

			// first 2 rounds can be any unit, stronger the higher the treat
			if (_i < 3) then {
				if ("helis_armed" call AS_AAFarsenal_fnc_countAvailable > 0) then {
					_toUse = "helis_armed";
				};
				if (_threatEvalAir > 15 and ("planes" call AS_AAFarsenal_fnc_countAvailable > 0)) then {
					_toUse = "planes";
				};
			};
			([_toUse, _originPos, _position, _patrolMarker] call AS_fnc_spawnAAFairAttack) params ["_groups1", "_vehicles1"];
			_groups append _groups1;
			_vehicles append _vehicles1;
			sleep 15;
		};
	};

	private _soldiers = [];
	{_soldiers append (units _x)} forEach _groups;

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
	[_mission, "originPos", _originPos] call AS_spawn_fnc_set;
  [_mission, "resources", [_task, _groups, _vehicles, [_patrolMarker]]] call AS_spawn_fnc_set;
	[_mission, "soldiers", _soldiers] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _soldiers = [_mission, "soldiers"] call AS_spawn_fnc_get;
	private _groups = ([_mission, "resources"] call AS_spawn_fnc_get) select 1;

	private _min_fighters = round ((count _soldiers)/2);
	private _max_time = time + 60*60;



	private _fnc_missionFailedCondition = {_location call AS_location_fnc_side != "FIA"};
	private _fnc_missionFailed = {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];
	};
	private _fnc_missionSuccessfulCondition = {
		{_x call AS_fnc_canFight} count _soldiers < _min_fighters or
		{time > _max_time}
	};
	private _fnc_missionSuccessful = {
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_success", 2];



		private _originPos = [_mission, "originPos"] call AS_spawn_fnc_get;

		{_x doMove _originPos} forEach _soldiers;
		{
			_x setVariable ["UPSMON_Remove", true]; //UPSMON no longer interferes
			private _wpRTB = _x addWaypoint [_originPos, 0];
			_x setCurrentWaypoint _wpRTB;
		} forEach _groups;
	};

	[_fnc_missionFailedCondition, _fnc_missionFailed, _fnc_missionSuccessfulCondition, _fnc_missionSuccessful] call AS_fnc_oneStepMission;
};

private _fnc_clean = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	[_location, true] call AS_location_fnc_despawn;
	_mission call AS_mission_spawn_fnc_clean;
};

AS_mission_defendLocation_states = ["initialize", "spawn", "run", "clean"];
AS_mission_defendLocation_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_run,
	_fnc_clean
];
