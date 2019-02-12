#include "../../macros.hpp"

private _fnc_initialize = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _tskTitle = _mission call AS_mission_fnc_title;

	private _tiempolim = 240;
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];

	private _posHQ = "FIA_HQ" call AS_location_fnc_position;
	private _fMarkers = "FIA" call AS_location_fnc_S;

	// select list of valid bases
	private _bases = [];
	{
		private _basePosition = _x call AS_location_fnc_position;
		if ((_position distance _basePosition < 7500) and
			(_position distance _basePosition > 1500) and
			(not (_x call AS_location_fnc_spawned))) then {_bases pushBack _x}
	} forEach (["base", "AAF"] call AS_location_fnc_TS);

	// select nearest base to
	private _base = "";
	private _basePosition = [];
	if (count _bases > 0) then {
		_base = [_bases,_position] call BIS_fnc_nearestPosition;
		_basePosition = _base call AS_location_fnc_position;
	};
	if (_base == "") exitWith {
		[_mission, "resources", [taskNull, [], [], []]] call AS_spawn_fnc_set;
		[_mission, "state_index", count AS_mission_helpMeds_states - 2] call AS_spawn_fnc_set;
		[_mission] remoteExecCall ["AS_mission_fnc_cancel", 2];
		[[petros, "sideChat", "_tskTitle canceled"], "AS_fnc_localCommunication"] call BIS_fnc_MP;
	};

	// find a suitable position for the medical supplies
	// try 20 times, if fail, the mission does not start
	private _crashPosition = [];
	for "_i" from 0 to 20 do {
		sleep 0.1;
		_crashPosition = [_position,2000,random 360] call BIS_fnc_relPos;
		private _nfMarker = [_fMarkers,_crashPosition] call BIS_fnc_nearestPosition;
		private _fposition = _nfMarker call AS_location_fnc_position;
		private _hposition = _nfMarker call AS_location_fnc_position;
		if ((!surfaceIsWater _crashPosition) &&
		    (_crashPosition distance _posHQ < 4000) &&
			(_fposition distance _crashPosition > 500) &&
			(_hposition distance _crashPosition > 800)) exitWith {};
	};

	if (_crashPosition isEqualTo []) exitWith {
		[_mission, "resources", [taskNull, [], [], []]] call AS_spawn_fnc_set;
		[_mission, "state_index", count AS_mission_helpMeds_states - 2] call AS_spawn_fnc_set;
		[_mission] remoteExecCall ["AS_mission_fnc_cancel", 2];
		[[petros, "sideChat", "_tskTitle canceled"], "AS_fnc_localCommunication"] call BIS_fnc_MP;
	};

	private _tskDesc = format [localize "STR_tskDesc_logMedical",
		[_location] call AS_fnc_location_name, _location,
		[_base] call AS_fnc_location_name, _base,
		numberToDate [2035,dateToNumber _fechalim] select 3,
		numberToDate [2035,dateToNumber _fechalim] select 4,
		(["AAF", "name"] call AS_fnc_getEntity)
	];

	private _vehicleType = selectRandom (["FIA", "vans"] call AS_fnc_getEntity);
	private _crateType = (["CIV", "box"] call AS_fnc_getEntity);


	_crashPosition = ([_crashPosition, _basePosition] call AS_fnc_findSpawnSpots) select 0;
	//_crashPosition = _crashPosition findEmptyPosition [0,100,_vehicleType]; //DEBUG: This can return nil
	private _crashPositionMrk = [_crashPosition,random 200,random 360] call BIS_fnc_relPos;
	private _mrkfin = createMarker [format ["REC%1", random 100], _crashPositionMrk];
	_mrkfin setMarkerShape "ICON";

	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
	[_mission, "crashPosition", _crashPosition] call AS_spawn_fnc_set;
	[_mission, "vehicleType", _vehicleType] call AS_spawn_fnc_set;
	[_mission, "crateType", _crateType] call AS_spawn_fnc_set;
	[_mission, "basePosition", _basePosition] call AS_spawn_fnc_set;
	[_mission, "resources", [taskNull, [], [], [_mrkfin]]] call AS_spawn_fnc_set;
	[_mission, [_tskDesc,_tskTitle,_mrkfin], _crashPositionMrk, "Heal"] call AS_mission_spawn_fnc_saveTask;
};

private _fnc_spawn = {
	params ["_mission"];
	private _crashPosition = [_mission, "crashPosition"] call AS_spawn_fnc_get;
	private _basePosition = [_mission, "basePosition"] call AS_spawn_fnc_get;
	private _vehicleType = [_mission, "vehicleType"] call AS_spawn_fnc_get;
	private _crateType = [_mission, "crateType"] call AS_spawn_fnc_get;

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	private _vehiculos = [];
	private _grupos = [];
	private _truckPosition = _crashPosition findemptyPosition [0, 40, (_vehicleType)];
	if (_truckPosition isEqualTo []) then {_truckPosition = _crashPosition};
	private _truck = createVehicle [_vehicleType, _truckPosition, [], 0, "NONE"];
	[_truck, "AAF"] call AS_fnc_initVehicle;
	_truck sethit ["motor", (random 0.89)];
	//[_truck,"Mission Vehicle"] spawn AS_fnc_setConvoyImmune;
	//AS_Sset("reportedVehs", AS_S("reportedVehs") + [_truck]);
	_vehiculos pushBack _truck;

	private _crate = _crateType createVehicle _crashPosition;
	_vehiculos append [_crate];
	[_crate, "loadCargo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
	_crate setVariable ["requiredVehs", ["Truck_F"], true];
	_crate setVariable ["asCargo", false, true];

	_crate setPos ([getPos _truck, 6, 185] call BIS_Fnc_relPos);
	_crate setDir (getDir _truck + (floor random 180));
	[_crate] call AS_fnc_emptyCrate;
	_crate addItemCargoGlobal ["FirstAidKit", 80];

	private _tipoGrupo = [["AAF", "patrols"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
	private _grupo = [_crashPosition, ("AAF" call AS_fnc_getFactionSide), _tipogrupo] call BIS_Fnc_spawnGroup;
	_grupos pushBack _grupo;

	{[_x] call AS_fnc_initUnitAAF} forEach units _grupo;

/*	private _tam = 100;
	private _road = objNull;
	while {true} do {
		private _roads = _basePosition nearRoads _tam;
		if (count _roads > 0) exitWith {_road = _roads select 0;};
		_tam = _tam + 50;
	};*/

	[_basePosition, _crashPosition] call AS_fnc_findSpawnSpots params ["_posRoad","_dir"];
	//[_posRoad, 0, 20, 7, 0, 2, 0, [], _posRoad] call BIS_fnc_findSafePos;  //These are commented out because createVehicle is quite foolproof with vehicle explosions

	private _veh = createvehicle [(selectRandom ("trucks" call AS_AAFarsenal_fnc_valid)), _posRoad, [], 0, "NONE"];
	_veh setdir _dir;
	createVehicleCrew _veh;

	//private _vehicle = [_posRoad, _dir, selectRandom ("trucks" call AS_AAFarsenal_fnc_valid), "AAF" call AS_fnc_getFactionSide] call bis_fnc_spawnvehicle;
	//private _veh = _vehicle select 0;
	private _grupoVeh = group ((crew _veh) select 0);
	{[_x] call AS_fnc_initUnitAAF} forEach units _grupoVeh;
	[_veh, "AAF"] call AS_fnc_initVehicle;


	//private _grupoVeh = _vehicle select 2;

	_grupos pushBack _grupoVeh;
	_vehiculos pushBack _veh;

	sleep 1;

	_tipoGrupo = [["AAF", "squads"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
	_grupo = [_basePosition, "AAF" call AS_fnc_getFactionSide, _tipogrupo] call BIS_Fnc_spawnGroup;

	{
		_x assignAsCargo _veh;
		_x moveInCargo _veh;
		[_x] call AS_fnc_initUnitAAF;
		[_x] joinSilent _grupoVeh;
		} forEach units _grupo;
		deleteGroup _grupo;

	//[_veh] spawn AS_AI_fnc_activateUnloadUnderSmoke;
	//[_grupoVeh, _veh] spawn AS_AI_fnc_DismountOnDanger;

	private _Vwp0 = _grupoVeh addWaypoint [_crashPosition, 30];
	_Vwp0 setWaypointCompletionRadius 50;
	_grupoVeh setCurrentWaypoint _Vwp0;
	_Vwp0 setWaypointType "GETOUT";
	_Vwp0 setWaypointBehaviour "SAFE";
	private _Vwp1 = _grupoVeh addWaypoint [_crashposition, 0];
	_vwp1 setwaypointType "SAD";

	[_veh, "AAF Escort", _crashPosition] spawn AS_fnc_setConvoyImmune;

	private _markers = ([_mission, "resources"] call AS_spawn_fnc_get) select 3;
	[_mission, "escort", _veh] call AS_spawn_fnc_set;
	[_mission, "truck", _truck] call AS_spawn_fnc_set;
	[_mission, "crate", _crate] call AS_spawn_fnc_set;
	[_mission, "resources", [_task, _grupos, _vehiculos, _markers]] call AS_spawn_fnc_set;
};

private _fnc_wait_to_arrive = {
	params ["_mission"];
	private _crate = [_mission, "crate"] call AS_spawn_fnc_get;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;

	private _fnc_missionFailedCondition = {(dateToNumber date > _max_date) or (not alive _crate)};
	// wait for any activity around the truck
	waitUntil {sleep 5;
		({(side _x == ("FIA" call AS_fnc_getFactionSide)) and (_x distance _crate < 50)} count allUnits > 0) or _fnc_missionFailedCondition
	};

	if (call _fnc_missionFailedCondition) then {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];

		// set the spawn state to `run` so that the next one is `clean`, since this ends the mission
		[_mission, "state_index", 3] call AS_spawn_fnc_set;
	};
};

private _fnc_wait_to_unload = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _crate = [_mission, "crate"] call AS_spawn_fnc_get;
	private _truck = [_mission, "truck"] call AS_spawn_fnc_get;
	private _veh = [_mission, "escort"] call AS_spawn_fnc_get;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _groups = ([_mission, "resources"] call AS_spawn_fnc_get) select 1;

	private _crashPosition = [_mission, "crashPosition"] call AS_spawn_fnc_get;

	([_mission, "AUTOASSIGNED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	// make all FIA around the truck non-captive
	{
		if (captive _x) then {
			[_x,false] remoteExec ["setCaptive",_x];
		};
	} forEach ([300, _crate, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);

	// make all enemies rush to the truck
	{
		{
			_x doMove _crashPosition;
		} forEach units _x;
	} forEach _groups;

	private _message1 = format ["Stop a truck closeby and have someone load the crate", [_location] call AS_fnc_location_name];
	{
		if (isPlayer _x) then {
			[petros,"globalChat",_message1] remoteExec ["AS_fnc_localCommunication",_x]
		};
	} forEach ([80, _crate, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);

	private _fnc_missionFailedCondition = {(dateToNumber date > _max_date) or (not alive _crate)};

	waitUntil {
		sleep 5;
		if ((_crate getVariable "asCargo")) exitWith {true};
		true and _fnc_missionFailedCondition
	};
	// wait for the truck to unload (2m) or the mission to fail

	if (call _fnc_missionFailedCondition) then {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];

		// set the spawn state to `run` so that the next one is `clean`, since this ends the mission
		[_mission, "state_index", 3] call AS_spawn_fnc_set;
	} else {
		([_mission, "AUTOASSIGNED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

		private _message2 = format ["Good to go. Deliver these supplies to %1 on the double.",[_location] call AS_fnc_location_name];
		{
			if (isPlayer _x) then {
				[petros,"globalChat",_message2] remoteExec ["AS_fnc_localCommunication",_x]
			};
		} forEach ([80, _crate, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);

		//Make enemy chase to the town

		{
			_x addVehicle _veh;
			_x addVehicle _truck;
			_x setspeedMode "FULL";

			private _Vwp2 = _x addWaypoint [_position, 10];
			_x setCurrentWaypoint _Vwp2;
			_Vwp2 setWaypointType "GETOUT";
			_Vwp2 setWaypointBehaviour "SAFE";

			[_veh, "AAF Escort",  _position] spawn AS_fnc_setConvoyImmune;
			[_truck, "AAF Escort", _position] spawn AS_fnc_setConvoyImmune;


		} forEach _groups;

		//These are no longer needed because of the crate loading

		/* private _crates = [_mission, "crates"] call AS_spawn_fnc_get;
		_crates params ["_crate1", "_crate2", "_crate3", "_crate4"];
		_crate1 attachTo [_truck, [0.3,-1.0,-0.4]];
		_crate2 attachTo [_truck, [-0.3,-1.0,-0.4]];
		_crate3 attachTo [_truck, [0,-1.6,-0.4]];
		_crate4 attachTo [_truck, [0,-2.0,-0.4]];*/
	};
};

private _fnc_wait_to_deliver = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _crate = [_mission, "crate"] call AS_spawn_fnc_get;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;

	private _fnc_missionFailedCondition = {(dateToNumber date > _max_date) or (not alive _crate)};

	waitUntil {
		sleep 5;
		if ((_crate distance _position < 40) and {!(_crate getVariable "asCargo")}) exitWith {true};
		true and _fnc_missionFailedCondition
	};

	if ((_crate distance _position < 40) and {!(_crate getVariable "asCargo")}) then {
		([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

		private _message = "Leave the crate here, they'll come to pick it up.";
		[_crate] call AS_fnc_emptyCrate;
		[_mission] remoteExecCall ["AS_mission_fnc_success", 2];

		{
			if (isPlayer _x) then {
				[petros,"globalChat",_message] remoteExec ["AS_fnc_localCommunication",_x]
			};
		} forEach ([80, _crate, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);

	} else {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExecCall ["AS_mission_fnc_fail", 2];
	};
};

AS_mission_helpMeds_states = ["initialize", "spawn", "wait_to_arrive",
	"wait_to_unload", "wait_to_deliver", "clean"];
AS_mission_helpMeds_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_wait_to_arrive,
	_fnc_wait_to_unload,
	_fnc_wait_to_deliver,
	AS_mission_spawn_fnc_clean
];
