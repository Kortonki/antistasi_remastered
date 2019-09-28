#include "../../macros.hpp"

private _fnc_initialize = {
	params ["_mission"];
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	private _missionType = _mission call AS_mission_fnc_type;

	private _origin = [_position] call AS_fnc_getBasesForConvoy;
	if (_origin == "") exitWith {
		[petros, "hint", "mission is no longer available"] call AS_fnc_localCommunication;

		[_mission, "state_index", 100] call AS_spawn_fnc_set; // terminate everything
		[_mission, "delete", true] call AS_spawn_fnc_set;
	};

	private _tiempolim = 70;
	private _startAfter = 10;
	private _fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
	private _startTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _startAfter];

	private _tskTitle = _mission call AS_mission_fnc_title;
	private _tskDesc = "";
	private _tskIcon = "";
	private _mainVehicleType = "";

//Convoy_money & convoy_suppliess go from base to cities, others from base to base
//Supply convoy ends in target city for city support, money convoy ends in FIA hq for money and negative city support

	call {
		if (_missionType == "convoy_money") exitWith {
			_tskDesc = localize "STR_tskDesc_CVY_Money";
			_tskIcon = "move";
			_mainVehicleType = selectRandom (["FIA", "vans"] call AS_fnc_getEntity);
		};
		if (_missionType == "convoy_supplies") exitWith {
			_tskDesc = localize "STR_tskDesc_CVY_Supply";
			_tskIcon = "heal";
			_mainVehicleType = selectRandom (["FIA", "vans"] call AS_fnc_getEntity);
		};
		if (_missionType == "convoy_fuel") exitWith {
			_tskDesc = localize "STR_tskDesc_CVY_Fuel";
			_tskIcon = "refuel";
			_mainVehicleType = ["AAF", "truck_fuel"] call AS_fnc_getEntity;
		};
		if (_missionType == "convoy_armor") exitWith {
			_tskDesc = localize "STR_tskDesc_CVY_Armor";
			_tskIcon = "destroy";
			private _type = "tanks";
			if (_type call AS_AAFarsenal_fnc_countAvailable == 0) then {
				_type = "apcs";
				diag_log format ["[AS] Error: convoy: tanks requested but not available", _mission];
			};
			_mainVehicleType = selectRandom (_type call AS_AAFarsenal_fnc_valid);
		};
		if (_missionType == "convoy_ammo") exitWith {
			_tskDesc = localize "STR_tskDesc_CVY_Ammo";
			_tskIcon = "rearm";
			_mainVehicleType = ["AAF", "truck_ammo"] call AS_fnc_getEntity;
		};
		if (_missionType == "convoy_hvt") exitWith {
			_tskDesc = localize "STR_tskDesc_CVY_HVT";
			_tskIcon = "destroy";
			private _types = ["cars_transport", "cars_armed", "trucks"];
			private _type = selectRandom _types;
			while {(_type call AS_AAFarsenal_fnc_countAvailable) == 0 and {count _types > 0}} do {
					_types = _types - [_type];
					_type = selectRandom _types;
			};

			//If no vehicle, AAF buys one:
			if (isNil "_type") then {
				_type = "cars_transport";
				private _cost = "cars_transport" call AS_AAFarsenal_fnc_cost;
				"cars_transport" call AS_AAFarsenal_fnc_addVehicle;
				[-(_cost)] remoteExec ["AS_fnc_changeAAFmoney", 2];
			};

			_mainVehicleType = selectRandom (_type call AS_AAFarsenal_fnc_valid);
		};
		if (_missionType == "convoy_prisoners") exitWith {
			_tskDesc = localize "STR_tskDesc_CVY_Pris";
			_tskIcon = "run";
			_mainVehicleType = selectRandom ("trucks" call AS_AAFarsenal_fnc_valid);
			if ("trucks" call AS_AAFarsenal_fnc_countAvailable == 0) then {
				diag_log format ["[AS] Error: convoy: truck requested but not available", _mission];
			};
		};
	};

	_tskDesc = format [_tskDesc,
		[_origin] call AS_fnc_location_name, _origin,
		[_location] call AS_fnc_location_name, _location];
	_tskTitle = format [_tskTitle, (["AAF", "name"] call AS_fnc_getEntity)];

	[_mission, "origin", _origin] call AS_spawn_fnc_set;
	[_mission, "mainVehicleType", _mainVehicleType] call AS_spawn_fnc_set;
	[_mission, "max_date", dateToNumber _fechalim] call AS_spawn_fnc_set;
	[_mission, "startTime", dateToNumber _startTime] call AS_spawn_fnc_set;
	[_mission, [_tskDesc,_tskTitle,_location], _position, _tskIcon] call AS_mission_spawn_fnc_saveTask;
};

private _fnc_spawn = {
	params ["_mission"];
	private _missionType = _mission call AS_mission_fnc_type;
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _origin = [_mission, "origin"] call AS_spawn_fnc_get;
	private _posbase = _origin call AS_location_fnc_positionConvoy;
	private _mainVehicleType = [_mission, "mainVehicleType"] call AS_spawn_fnc_get;
	private _startTime = [_mission, "startTime"] call AS_spawn_fnc_get;
	private _speed = "NORMAL";
	private _separation = 30;

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	private _groups = [];
	private _vehicles = [];

	[_origin,10] call AS_location_fnc_increaseBusy;

	private _group = createGroup ("AAF" call AS_fnc_getFactionSide);
	_groups pushBack _group;
	//_posbase = _posbase findEmptyPosition [50, 100, _mainVehicleType];
	([_posbase, _position] call AS_fnc_findSpawnSpots) params ["_posRoad", "_dir"];
	//_posbase = _posbase findEmptyPosition [0, 10, _mainVehicleType];
	private _escortSize = 1;
	private _frontLine = false;
	if ([_location] call AS_fnc_location_isFrontline) then {
		_frontLine = true;
		_escortSize = (round random 2) + 1
	};

	// spawn escorts
	for "_i" from 1 to _escortSize do {
		private _category = [
			["trucks", "apcs"],
			["trucks" call AS_AAFarsenal_fnc_countAvailable,
			 "apcs" call AS_AAFarsenal_fnc_countAvailable]
			] call BIS_fnc_selectRandomWeighted;
		private _escortVehicleType = selectRandom (_category call AS_AAFarsenal_fnc_valid);

		([_escortVehicleType, _posRoad, _dir, "AAF", "any"] call AS_fnc_createVehicle) params ["_vehicle", "_vehicleGroup"];
		_posRoad = [(_posRoad select 0) - (15*(sin _dir )), (_posRoad select 1) - (15*(cos _dir)), 0]; //next one is 15m behind

		{
			if (_i == _escortSize and {_escortSize > 1}) then {_x setRank "PRIVATE";} else {_x setRank "SERGEANT";}; //Make one escort last of the convoy
			[_x] join _group;
		} forEach units _vehicleGroup;

		deleteGroup _vehicleGroup;
		_vehicles pushBack _vehicle;

		private _tipoGrupo = "";
		if (_escortVehicleType call AS_AAFarsenal_fnc_category == "apcs") then {
			_tipoGrupo = [["AAF", "teams"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
			_separation = 20;
		} else {
			_tipoGrupo = [["AAF", "squads"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		};

		//_vehicle setConvoySeparation _separation; //Experiment not using this if it's causing AI to freeze in convoy

		//Updated to make sure the group fits in the vehicle
		//private _grupoEsc = [_posbase, ("AAF" call AS_fnc_getFactionSide), _tipoGrupo] call BIS_Fnc_spawnGroup;
		private _grupoEsc = createGroup ("AAF" call AS_fnc_getFactionSide);
		[_tipoGrupo call AS_fnc_groupCfgToComposition, _grupoEsc, _posbase, _vehicle call AS_fnc_availableSeats] call AS_fnc_createGroup;
		{
			[_x] call AS_fnc_initUnitAAF;
			_x assignAsCargo _vehicle;
			_x moveInCargo _vehicle;
		} forEach units _grupoEsc;
		_groups pushBack _grupoEsc;
		_grupoEsc setbehaviour "SAFE";
		[_grupoEsc, _vehicle] spawn AS_AI_fnc_DismountOnDanger;
		//This should make escort disembark when approaching FIA locations or they are near
		if (_frontLine) then {
			[_group, _location] spawn AS_AI_fnc_dangerOnApproach;
		};

	};
	_posRoad = [(_posRoad select 0) - (15*(sin _dir )), (_posRoad select 1) - (15*(cos _dir)), 0]; //next pos is 15m behing

	([_mainVehicleType, _posRoad, _dir, "AAF", "any"] call AS_fnc_createVehicle) params ["_mainVehicle","_mainVehicleGroup","_driver"];
	_vehicles pushBack _mainVehicle;
	{
		[_x] joinSilent _group;
	} foreach units _mainVehicleGroup;
	//_mainVehicle setConvoySeparation _separation;

	//The crate for money and supply convoys

	private _crate =  objnull;
	if (_missionType in ["convoy_supplies", "convoy_money"]) then {
		_crate = (["CIV", "box"] call AS_fnc_getEntity) createVehicle [0,0,0];
		[_crate] call AS_fnc_emptyCrate;
		_vehicles pushBack _crate;

		private _manifest = format ["Supplies to %1", _location];
		if (_missionType == "convoy_money") then {
			_manifest = format ["Money to %1", _location];
		};
		_crate setVariable ["dest", _manifest, true];
		_crate setVariable ["requiredVehs", ["Truck_F"], true];
		[_crate, "loadCargo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];

		_crate attachTo [_mainVehicle, [0, 0, 0], "trup"];
		_mainVehicle setVariable ["boxCargo", [_crate], true];
		[_mainVehicle, "unloadCargo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
		_crate setvariable ["asCargo", true, true];
	};

	//Override fuel cargo from InitVehicle

	if (_missionType == "convoy_fuel") then {
		[_mainVehicle, 0.95, 1] call AS_fuel_fnc_randomFuelCargo;

	};

	_driver setRank "CORPORAL";
	_driver addEventHandler ["killed", {
		{
			[_x] orderGetIn false;
			[_x] allowGetIn false;
			if (isNull (assignedDriver _mainVehicle) or !(alive _driver)) then { //Was: if (_forEachIndex == ((count crew _mainVehicle) - 1))
				unassignVehicle _x;
				_x assignasDriver _mainVehicle;
				[_x] join _group;
			};
			[_x] orderGetIn true;
			[_x] allowGetIn true;
		} forEach (units _mainVehicleGroup select {alive _x});


	}];

	if (_missionType == "convoy_hvt") then {
		private _hvt = ([_posbase, 0, ["AAF", "officer"] call AS_fnc_getEntity, _group] call bis_fnc_spawnvehicle) select 0;
		[_hvt] call AS_fnc_initUnitAAF;
		_hvt assignAsCargo _mainVehicle;
		_hvt moveInCargo _mainVehicle;
		[_mission, "hvt", _hvt] call AS_spawn_fnc_set;

		//TODO improve this, spawn suitable group or something
		//or special forces units

		private _cargo = 0;
		while {_cargo = _cargo + 1; (_mainVehicle emptyPositions "Cargo") > 0 or _cargo < 6} do {
				private _unit = _group createUnit [["AAF", "gunner"] call AS_fnc_getEntity, _posbase, [], 0, "NONE"]; //TODO: Consider spec-op class here
				[_unit] call AS_fnc_initUnitAAF;
				_unit assignAsCargo _mainVehicle;
				_unit moveInCargo _mainVehicle;

		};

	};
	if (_missionType == "convoy_armor") then {
		_mainVehicle lock 3;
	};
	if (_missionType == "convoy_prisoners") then {
		private _grpPOW = createGroup ("FIA" call AS_fnc_getFactionSide);
		private _POWs = [];
		_groups pushBack _grpPOW;
		for "_i" from 1 to (1+ round (random 11)) do {
			private _unit = ["Survivor", _position, _grpPOW] call AS_fnc_spawnFIAUnit;
			_unit call AS_fnc_initUnitSurvivor;
			_unit assignAsCargo _mainVehicle;
			_unit moveInCargo [_mainVehicle, _i + 3]; // 3 because first 3 are in front
			[_unit, "refugiado"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
			_POWs pushBack _unit;
		};
		[_mission, "grpPOW", _grpPOW] call AS_spawn_fnc_set;
		[_mission, "POWs", _POWs] call AS_spawn_fnc_set;
	};
	if (_missionType in ["convoy_money", "convoy_supplies", "convoy_fuel", "convoy_ammo"]) then {
		AS_Sset("reportedVehs", AS_S("reportedVehs") + [_mainVehicle]);
	};

	// set everyone in motion after a delay
	[_startTime, _group, _position, _mainVehicle, _speed, _vehicles] spawn {

		params ["_startTime", "_group", "_position","_mainVehicle","_speed", "_vehicles"];

		waitUntil {sleep 10; (dateToNumber date > _startTime)};

		_wp0 = _group addWaypoint [_position, 0];
		_group setCurrentWaypoint _wp0;
		_wp0 setWaypointType "MOVE";
		_wp0 setWaypointBehaviour "SAFE";
		_wp0 setWaypointSpeed _speed;
		_wp0 setWaypointFormation "COLUMN";

		{
			[_x, "Convoy", _position] call AS_fnc_setConvoyImmune;
		} foreach _vehicles;

				//TODO better condition to end the loop
		// Trying if this works without as it might be buggy
		/*while {alive _mainVehicle} do {

			waitUntil {sleep 60; currentWaypoint (group (leader (driver _mainVehicle))) != (_wp0 select 2)};

			_group move _position;
			_group setBehaviour "SAFE";
			_group setSpeedMode _speed;
			_group setFormation "COLUMN";

			[_mainVehicle, "Convoy", _position] call AS_fnc_setConvoyImmune;

		_mainVehicle setVelocity [
			10 * sin (getDir _mainVehicle),
			10 * cos (getDir _mainVehicle),
			0
			];

		(vehicle (leader (driver _mainVehicle))) setVelocity [
		10 * sin (getDir (vehicle (leader (driver _mainVehicle)))),
		10 * cos (getDir (vehicle (leader (driver _mainVehicle)))),
		0
		];
		};*/
	};

	[_mission, "mainGroup", _group] call AS_spawn_fnc_set;
	[_mission, "mainVehicle", _mainVehicle] call AS_spawn_fnc_set;
	[_mission, "crate", _crate] call AS_spawn_fnc_set;
	[_mission, "resources", [_task, _groups, _vehicles, []]] call AS_spawn_fnc_set;
};

private _fnc_run = {
	params ["_mission"];
	private _missionType = _mission call AS_mission_fnc_type;
	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;
	private _max_date = [_mission, "max_date"] call AS_spawn_fnc_get;
	private _mainVehicle = [_mission, "mainVehicle"] call AS_spawn_fnc_get;
	private _crate = [_mission, "crate"] call AS_spawn_fnc_get;

	private _fnc_missionFailedCondition = call {
		if (_missionType in ["convoy_money","convoy_supplies"]) exitWith {
			{
				private _hasArrived = {
					_crate distance2D _position < 150 and {!([_position, 150] call AS_fnc_friendlyNearby)}}; //Check if blufor is not near
				(false) or _hasArrived
			}
		};
		if (_missionType in ["convoy_armor", "convoy_ammo", "convoy_fuel"]) exitWith {
			{
				private _hasArrived = {((driver _mainVehicle) call AS_fnc_getSide == "AAF") and
					{_mainVehicle distance2D _position < 150 and {!([_position, 150] call AS_fnc_friendlyNearby)}}}; //Check if blufor is not near
				(false) or _hasArrived
			}
		};

		if (_missionType == "convoy_hvt") exitWith {
			{
				private _hvt = [_mission, "hvt"] call AS_spawn_fnc_get;
				private _hasArrived = {_hvt distance2D _position < 100};

				(dateToNumber date > _max_date) or _hasArrived
			}
		};
		if (_missionType == "convoy_prisoners") exitWith {
			{
				private _hasArrived = {(not (driver _mainVehicle getVariable ["BLUFORSpawn",false])) and
					{_mainVehicle distance2D _position < 100}};
				private _POWs = [_mission, "POWs"] call AS_spawn_fnc_get;
				(dateToNumber date > _max_date) or _hasArrived or ({alive _x} count _POWs < ({alive _x} count _POWs)/2)
			}
		};
	};

	private _fnc_missionFailed = {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission] remoteExec ["AS_mission_fnc_fail", 2];

		if (_missionType == "convoy_ammo") then {
			[_mainVehicle] call AS_fnc_emptyCrate;
		};

		if (_missionType == "convoy_fuel") then {
			[_mainVehicle , 0, 0.3] call AS_fuel_fnc_randomFuelCargo;
			_mainVehicle setFuelCargo 0.3;
		};
	};

	private _fnc_missionSuccessfulCondition = call {
		if (_missionType in ["convoy_money","convoy_supplies"]) exitWith {
			{
				(not(alive _crate)) or (!(_crate getVariable ["asCargo", false])) or (dateToNumber date > _max_date)
			}
		};
		if (_missionType in ["convoy_ammo","convoy_fuel"]) exitWith {
			{
				(not(alive _mainVehicle)) or (driver _mainVehicle getVariable ["BLUFORSpawn",false]) or (dateToNumber date > _max_date)
			}
		};
		if (_missionType == "convoy_armor") exitWith {
			{not(alive _mainVehicle) or (dateToNumber date > _max_date)}
		};
		if (_missionType == "convoy_hvt") exitWith {
			{
				private _hvt = [_mission, "hvt"] call AS_spawn_fnc_get;
				not(alive _hvt)
			}
		};
		if (_missionType == "convoy_prisoners") exitWith {
			{
				private _POWs = [_mission, "POWs"] call AS_spawn_fnc_get;
				({(alive _x) and (_x distance2D getMarkerPos "FIA_HQ" < 50)} count _POWs) >= (({alive _x} count _POWs) / 2)
			 }
		};
	};

	private _fnc_missionSuccessful = call {
		if (_missionType in ["convoy_money", "convoy_ammo", "convoy_supplies", "convoy_fuel"]) exitWith {
			{
				private _fnc_missionFailedCondition = {not(alive _mainVehicle) or (dateToNumber date > _max_date and {_mainVehicle call AS_fnc_getSide == "AAF"})};
				if (_missionType in ["convoy_money", "convoy_supplies"]) then {
					//Money convoy doesn't expire so FIA can deliver it to the base
					_fnc_missionFailedCondition = {not(alive _crate) or (dateToNumber date > _max_date and {_missionType == "convoy_supplies"})};
				};
				private _fnc_missionFailed = {
					([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

					if (_missionType in ["convoy_supplies", "convoy_money"]) then {
						if (not(alive _crate)) then {
							//Crate was destroyed by FIA
							[-10,-10, _position] remoteExec ["AS_fnc_changeCitySupport",2];
							if (_missionType == "convoy_money") then {
								[-5000] remoteExec ["AS_fnc_changeAAFmoney",2];
							};
						} else {
							//The AAF delivery is late
							[-10, 0, _position] remoteExec ["AS_fnc_changeCitySupport",2];
						};
					};
					//Killing the convoy is always better than it being late
					if (_missionType == "convoy_fuel") then {
						if (not(alive _mainVehicle)) then {
							[-5000] remoteExec ["AS_fnc_changeAAFmoney",2];
						};
						[20*60] remoteExec ["AS_fnc_changeSecondsforAAFattack",2];
					};

					if (_missionType == "convoy_ammo") then {
						if (not(alive _mainVehicle)) then {
							[-10000] remoteExec ["AS_fnc_changeAAFmoney",2];
						};
						[20*60] remoteExec ["AS_fnc_changeSecondsforAAFattack",2];
					};

					//Part of the success/fail to ensure mission is cleaned up properly

					[_mission] remoteExec ["AS_mission_fnc_cancel",2];
					//"Minor" victory -> EXP
					["mis"] remoteExec ["fnc_BE_XP",2];



				};
				private _destination = getMarkerPos "FIA_HQ";

				if (_missionType == "convoy_supplies") then {
					_destination = _position;
				};

				private _fnc_missionSuccessfulCondition = {(_mainVehicle distance2D _destination < 50) and {speed _mainVehicle < 1}};
				private _fnc_missionSuccessful = {
					([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

					if (_missionType in ["convoy_money","convoy_fuel"]) then {
						[-5000] remoteExec ["AS_fnc_changeAAFmoney",2];
					};

					if (_missionType == "convoy_ammo") then {
						[-10000] remoteExec ["AS_fnc_changeAAFmoney",2];
					};

					[_mission, [getPos _mainVehicle]] remoteExec ["AS_mission_fnc_success", 2];
				};
				[_fnc_missionFailedCondition, _fnc_missionFailed, _fnc_missionSuccessfulCondition, _fnc_missionSuccessful] call AS_fnc_oneStepMission;
			}
		};
		if (_missionType == "convoy_armor") exitWith {
			{
				([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
				[_mission, [getPos _mainVehicle]] remoteExec ["AS_mission_fnc_success", 2];

				[position _mainVehicle] spawn AS_movement_fnc_sendAAFpatrol;
			}
		};
		if (_missionType == "convoy_hvt") exitWith {
			{
				private _hvt = [_mission, "hvt"] call AS_spawn_fnc_get;
				([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
				[_mission, [getPos _mainVehicle]] remoteExec ["AS_mission_fnc_success", 2];

				[position _hvt] spawn AS_movement_fnc_sendAAFpatrol;
			}
		};
		if (_missionType == "convoy_prisoners") exitWith {
			{
				private _pows = [_mission, "POWs"] call AS_spawn_fnc_get;
				private _grpPOW = [_mission, "grpPOW"] call AS_spawn_fnc_get;
				[_mission,  [getPos _mainVehicle, ({alive _x} count _POWs)]] remoteExec ["AS_mission_fnc_success", 2];

				{
					if (captive _x) then {
						_x setcaptive false;
					};
				} foreach _pows;

					//Wait unit to lose undercover and get weapons back

				sleep 30;

				private _cargo_w = [[], []];
				private _cargo_m = [[], []];
				private _cargo_i = [[], []];
				private _cargo_b = [[], []];

				{
					[_x] join _grpPOW;
					[_x] orderGetin false;

					private _arsenal = [_x, true] call AS_fnc_getUnitArsenal;  // restricted to locked weapons
					_cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
					_cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
					_cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
					_cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
					[cajaVeh, (_arsenal select 4)] call AS_fnc_addMagazineRemains;

					[_x]  RemoteExec ["AS_fnc_safeDelete", _x];

				} forEach _pows;

				[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
			}
		};
	};

	[_fnc_missionFailedCondition, _fnc_missionFailed, _fnc_missionSuccessfulCondition, _fnc_missionSuccessful] call AS_fnc_oneStepMission;
};

private _fnc_clean = {
	params ["_mission"];
	private _mainVehicle = [_mission, "mainVehicle"] call AS_spawn_fnc_get;
	private _group = [_mission, "mainGroup"] call AS_spawn_fnc_get;
	private _origin = [_mission, "origin"] call AS_spawn_fnc_get;
	private _posbase = _origin call AS_location_fnc_positionConvoy;

	private _wp0 = _group addWaypoint [_posbase, 0];
	_wp0 setWaypointType "MOVE";
	_wp0 setWaypointBehaviour "SAFE";
	_wp0 setWaypointSpeed "NORMAL";
	_wp0 setWaypointFormation "COLUMN";

	// before calling cleanResources
	//Consider is this necessary? Clean resources will not delete vehs immediately
	/*
	if (typeOf _mainVehicle in ["convoy_money","convoy_ammo", "convoy_fuel"]) then {
		[_mainVehicle, caja] call AS_fnc_transferToBox;
		AS_Sset("reportedVehs", AS_S("reportedVehs") - [_mainVehicle]);
	};*/

	_mission call AS_mission_spawn_fnc_clean;
};

AS_mission_convoy_states = ["initialize", "spawn", "run", "clean"];
AS_mission_convoy_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_run,
	_fnc_clean
];
