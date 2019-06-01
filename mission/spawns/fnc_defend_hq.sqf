#include "../../macros.hpp"

private _fnc_initialize = {
	params ["_mission"];
	private _tskTitle = localize "STR_tsk_HQAttack";
	private _tskDesc = localize "STR_tskDesc_HQAttack";

	private _location = "fia_hq";
	private _position = _location call AS_location_fnc_position;

	[_mission, [_tskDesc,_tskTitle,_location], _position, "Defend"] call AS_mission_spawn_fnc_saveTask;
};

private _fnc_spawn = {
	params ["_mission"];
	private _location = "fia_hq";
	private _position = _location call AS_location_fnc_position;
	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
	private _origin = getMarkerPos "spawnCSAT";

	private _vehiculos = [];
	private _soldiers = [];
	private _groups = [];

	private _patrolMarker = createMarker [format ["defhq_%1", round (diag_tickTime/60)], _position];
	_patrolMarker setMarkerShape "ELLIPSE";
	_patrolMarker setMarkerSize [50,50];
	_patrolMarker setMarkerAlpha 0;

	if (AS_P("resourcesAAF") > 20000) then {
		[-20000] remoteExec ["AS_fnc_changeAAFmoney",2];
		[5,0] remoteExec ["AS_fnc_changeForeignSupport",2];

	//Transport choppers. They will come regardless of support

	for "_i" from 1 to (1 + round random 2) do {
		private _pos = [_origin, 300, random 360] call BIS_Fnc_relPos;
		private _type = selectRandom (["CSAT", "helis_transport"] call AS_fnc_getEntity);
		([_type, _pos, random 360, "CSAT", "pilot", 300, "FLY"] call AS_fnc_createVehicle) params ["_heli", "_grupoHeli", "_pilot"];
		_groups pushBack _grupoheli;
		_vehiculos pushBack _heli;

		{_x setBehaviour "CARELESS";} forEach units _grupoheli;
		private _tipoGrupo = [["CSAT", "recon_squad"] call AS_fnc_getEntity, "CSAT"] call AS_fnc_pickGroup;
		private _grupo = [_pos, ("CSAT" call AS_fnc_getFactionSide), _tipoGrupo] call BIS_Fnc_spawnGroup;
		{_x assignAsCargo _heli; _x moveInCargo _heli; _x call AS_fnc_initUnitCSAT} forEach units _grupo;
		_groups pushBack _grupo;
		[_heli,"CSAT Air Transport"] spawn AS_fnc_setConvoyImmune;
		[_origin, _position, _grupoheli, _patrolMarker, _grupo] spawn AS_tactics_fnc_heli_fastrope;
	};

	//CSAT attack helis

	if ((AS_P("CSATSupport")) >= 75) then {

		private _count = 1;

		if (((AS_P("CSATSupport")) + random 25) > 100) then {_count = 2}; //Nearing CSAT supprt 100, bigger possibility to spawn 2 attack helos

		for "_i" from 1 to _count do {

			private _helicopterType = selectRandom (["CSAT", "helis_armed"] call AS_fnc_getEntity) + (["CSAT", "helis_attack"] call AS_fnc_getEntity);

			([_helicopterType, _origin, 0, "CSAT", "pilot", 300, "FLY"] call AS_fnc_createVehicle) params ["_heli", "_grupoheli"];

			private _wp1 = _grupoheli addWaypoint [_position, 0];
			_wp1 setWaypointType "SAD";

			_groups pushBack _grupoheli;
			_vehiculos pushBack _heli;
			_heli setVariable ["origin", getMarkerpos "spawnCSAT", true]; //Attack helos return elsewhere than others
		};

	};

	{_soldiers append (units _x)} forEach _groups;

	//Use arty and air strike

	[_location] spawn {
		params ["_location"];
		if ((AS_P("CSATSupport")) >= 50) then {
			for "_i" from 0 to round (random (AS_P("CSATSupport")/25)) do {
				[_location, selectRandom (["CSAT", "planes"] call AS_fnc_getEntity)] spawn AS_fnc_activateAirstrike;
				sleep 30;
				};
		};

	if ((AS_P("CSATSupport")) >= 25) then {
		[_location] spawn AS_fnc_dropArtilleryShells;
		};

	};

};
	//Spawn AAF land attack as well

	private _base = [_position, true] call AS_fnc_getBasesForCA;


	private _originPos = [];
	if (_base != "") then {
		[_base,60] call AS_location_fnc_increaseBusy;
		_originPos = _base call AS_location_fnc_positionConvoy;
		private _size = _base call AS_location_fnc_size;

		// compute number of trucks based on the marker size
		private _nVeh = (round (_size/30)) max 1;

		private _threat = [_position] call AS_fnc_getLandThreat;



		// spawn them
		for "_i" from 1 to _nveh do {
			private _toUse = "trucks";
			if (_threat > 3 and ("apcs" call AS_AAFarsenal_fnc_count > 0)) then {
				_toUse = "apcs";
				};
			if (_threat > 5 and ("tanks" call AS_AAFarsenal_fnc_count > 0)) then {
				_toUse = "tanks";
				};
			([_toUse, _originPos, _patrolMarker, _threat] call AS_fnc_spawnAAFlandAttack) params ["_groups1", "_vehicles1"];
			_groups append _groups1;
			_vehiculos append _vehicles1;
			{_soldiers append (units _x)} foreach _groups1;
			sleep 5;
			};
		};



	[_mission, "resources", [_task, _groups, _vehiculos, [_patrolMarker]]] call AS_spawn_fnc_set;
	[_mission, "soldiers", _soldiers] call AS_spawn_fnc_set;
	[_mission, "originPos", _originPos] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_mission"];
	private _soldiers = [_mission, "soldiers"] call AS_spawn_fnc_get;
	private _groups = ([_mission, "resources"] call AS_spawn_fnc_get) select 1;
	private _originPos = [_mission, "originPos"] call AS_spawn_fnc_get;

	private _min_fighters = round ((count _soldiers)/2);
	private _max_time = time + 60*60;

	private _fnc_missionFailedCondition = {not(alive petros)};
	private _fnc_missionFailed = {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];

		//After a while after petros' death, send the soldiers away:

		[_soldiers, _groups, _originPos] spawn {
				params ["_soldiers",["_groups",[]], ["_originPos",[0,0,0]]];
				sleep (60*5 + (random (60*50)));

				{_x doMove _originPos} forEach _soldiers;
				{
					//If no spesicif origin spesified, use the defualt origin

					if (isNil {(vehicle leader _x) getVariable "origin"}) then {
						private _wpRTB = _x addWaypoint [_originPos, 0];
						_x setCurrentWaypoint _wpRTB;
					} else {
						private _wpRTB = _x addWaypoint [_origin, 0];
						_x setCurrentWaypoint _wpRTB;
						_x setCombatMode "GREEN";
					};
				} forEach _groups;
		};

	};

	//SUCCESS happens after some time, defeating most of the enemy or by moving the HQ
	private _fnc_missionSuccessfulCondition = {
		{_x call AS_fnc_canFight} count _soldiers < _min_fighters or
		time > _max_time or !("fia_hq" in ([] call AS_location_fnc_knownLocations))
	};
	private _fnc_missionSuccessful = {
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_success", 2];

		//private _origin = getMarkerPos "spawnCSAT";

		{_x doMove _originPos} forEach _soldiers;

		{
			//If no spesicif origin spesified, use the defualt origin

			if (isNil {(vehicle leader _x) getVariable "origin"}) then {
				private _wpRTB = _x addWaypoint [_originPos, 0];
				_x setCurrentWaypoint _wpRTB;
			} else {
				private _wpRTB = _x addWaypoint [_origin, 0];
				_x setCurrentWaypoint _wpRTB;
				_x setCombatMode "GREEN";
			};
		} forEach _groups;
	};

	[_fnc_missionFailedCondition, _fnc_missionFailed, _fnc_missionSuccessfulCondition, _fnc_missionSuccessful] call AS_fnc_oneStepMission;
};

AS_mission_defendHQ_states = ["initialize", "spawn", "run", "clean"];
AS_mission_defendHQ_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_run,
	AS_mission_spawn_fnc_clean
];
