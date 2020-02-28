#include "../macros.hpp"
//No reason to be server only
//AS_SERVER_ONLY("fnc_sendEnemyQRF");
/*
parameters
0: base/airport/carrier to start from (marker)
1: target location (position)
2: marker for dismounts to patrol (marker) //OBSOLETE
3: patrol duration (time in minutes)
4: composition: transport/destroy/mixed (string)
5: size: large/small (string)
6: source of the QRF request (optional)

If origin is an airport/carrier, the QRF will consist of air cavalry. Otherwise it'll be ground forces in MRAPs/trucks.
*/
params ["_origin", "_destination", "_location", "_duration", "_composition", "_size", ["_source", ""]];

// AAF bases/airports
private _bases = ["base", "AAF"] call AS_location_fnc_TS;

private _posComp = ["transport", "destroy", "mixed"];
if !(_composition in _posComp or _composition == "random") exitWith {
	diag_log format ["AS_movement_fnc_sendEnemyQRF error: invalid composition: %1, caller %2", _composition, _source];
};

if (_composition == "random") then {
	_composition = selectRandom _posComp;
};

private _noArsenal = false;

// define type of QRF and vehicles by type of origin, plus method of troop insertion by air (rope or land)
private _type = "air";
private _method = "fastrope";
private _faction = "CSAT";
private _side = "CSAT" call AS_fnc_getFactionSide;
private _attackVehicle = selectRandom (["CSAT", "helis_armed"] call AS_fnc_getEntity);
private _transportVehicle = selectRandom (["CSAT", "helis_transport"] call AS_fnc_getEntity);
private _dismountGroup = [["CSAT", "recon_team"] call AS_fnc_getEntity, "CSAT"] call AS_fnc_pickGroup;
if (not (_origin isEqualTo "spawnCSAT")) then {
	_method = "disembark";
	_faction = "AAF";
	if (_size == "small") then {

		if (_origin in _bases) then {
			if ("cars_armed" call AS_AAFarsenal_fnc_countAvailable < 2 or "trucks" call AS_AAFarsenal_fnc_countAvailable < 2) exitWith {_noArsenal = true;};
			_type = "land";
			_attackVehicle = selectRandom (["AAF", "cars_armed"] call AS_fnc_getEntity);
			_transportVehicle = selectRandom ("trucks" call AS_AAFarsenal_fnc_valid);
			_dismountGroup = [["AAF", "teams"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		} else {
			if ("helis_transport" call AS_AAFarsenal_fnc_countAvailable < 2 or (_composition in ["mixed", "destroy"] and {"helis_armed" call AS_AAFarsenal_fnc_countAvailable < 2})) exitWith {_noArsenal = true;};
			_attackVehicle = selectRandom (["AAF", "helis_armed"] call AS_fnc_getEntity);
			_transportVehicle = selectRandom (["AAF", "helis_transport"] call AS_fnc_getEntity);
			_dismountGroup = [["AAF", "teams"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		};
	} else {

		if (_origin in _bases) then {
			if ("apcs" call AS_AAFarsenal_fnc_countAvailable < 2 or "trucks" call AS_AAFarsenal_fnc_countAvailable < 2) exitWith {_noArsenal = true;};
			_type = "land";
			_attackVehicle = selectRandom ("apcs" call AS_AAFarsenal_fnc_valid);
			_transportVehicle = selectRandom ("trucks" call AS_AAFarsenal_fnc_valid);
			_dismountGroup = [["AAF", "squads"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		} else {
			if ("helis_transport" call AS_AAFarsenal_fnc_countAvailable < 2 or (_composition in ["mixed", "destroy"] and {"helis_armed" call AS_AAFarsenal_fnc_countAvailable < 2})) exitWith {_noArsenal = true;};
			_attackVehicle = selectRandom (["AAF", "helis_armed"] call AS_fnc_getEntity);
			_transportVehicle = selectRandom (["AAF", "helis_transport"] call AS_fnc_getEntity);
			_dismountGroup = [["AAF", "squads"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
			_method = "fastrope";
		};
	};
} else {
	_origin = getMarkerPos "spawnCSAT";

	if (_side == "small") then {

		if (AS_P("CSATsupport") < 5) exitWith {
			_noArsenal = true;
		};
		[0,-5] remoteExec ["AS_fnc_changeForeignSupport", 2];
	} else {
		if (AS_P("CSATsupport") < 10) exitWith {
			_noArsenal = true;
		};
		[0,-10] remoteExec ["AS_fnc_changeForeignSupport", 2];
	};
};

if (_noArsenal) exitWith {diag_log "[AS]: Not enough vehicles, cancelling QRF";};

if (_size == "small") then {
	[_origin,5] call AS_location_fnc_increaseBusy;
} else {
	[_origin,10] call AS_location_fnc_increaseBusy;
};

// get the position of the target marker
if (typeName _origin != "ARRAY") then {
	if (_type == "land") then {
		_origin = _origin call AS_location_fnc_positionConvoy;
	} else {
		_origin = _origin call AS_location_fnc_position;
	};
};



// arrays of all resources (resources owned by this script)
private _grupos = [];
private _soldados = [];
private _vehiculos = [];
private _markers = [];

// create a patrol marker
private _patrolMarker = createMarkerLocal [format ["Patrol-%1-%2", (diag_tickTime/60), round (random 100)],_destination];
_patrolMarker setMarkerShapeLocal "RECTANGLE";
_patrolMarker setMarkerSizeLocal [150,150];
_patrolMarker setMarkerAlpha 0;
_markers pushBack _patrolMarker;


private _spawnGroup = {
	params ["_groupType"];
	private _group = [_origin, _side, _groupType] call BIS_Fnc_spawnGroup;
	if (_faction == "AAF") then {
		{_x call AS_fnc_initUnitAAF} forEach units _group;
	} else {
		{_x call AS_fnc_initUnitCSAT} forEach units _group;
	};
	_grupos pushBack _group;
	_soldados append units _group;
	_group
};

private _spawnVehicle = {
	params ["_vehicleType", "_position", "_direction"];
	//([_position, _direction, _vehicleType, _side] call bis_fnc_spawnvehicle) params ["_vehicle", "_units", "_group"];

	if (_type == "air") exitWith {

		([_vehicleType, _position, _direction, _faction, "any", 400, "FLY", true, 7] call AS_fnc_createVehicle) params ["_vehicle", "_crew_group"];
		_grupos pushBack _crew_group;
		_soldados append units _crew_group;
		_vehiculos pushBack _vehicle;
		[_vehicle, _crew_group]
	};

		([_vehicleType, _position, _direction, _faction, "any", 0, "NONE", true, 7] call AS_fnc_createVehicle) params ["_vehicle", "_crew_group"];
		_grupos pushBack _crew_group;
		_soldados append units _crew_group;
		_vehiculos pushBack _vehicle;
		[_vehicle, _crew_group]


};

if (_type == "air") then {
	private _dir = [_origin, _destination] call BIS_fnc_dirTo;

	if ((_composition == "destroy") || (_composition == "mixed")) then {
		([_attackVehicle, _origin, _dir] call _spawnVehicle) params ["_grpveh1", "_crew_group"];

		[_origin, _destination, _crew_group] spawn AS_tactics_fnc_heli_attack;
	};

	// small delay to prevent crashes when both helicopters are spawned
	if (_composition == "mixed") then {
		sleep 5;
	};

	if ((_composition == "transport") || (_composition == "mixed")) then {
		// shift the spawn position of second chopper (in `mixed`) to avoid crash
		private _pos2 = +_origin;
		_pos2 set [2, (_origin select 2) + 50];

		// troop transport chopper

		private _vehArray = [_transportVehicle, _pos2, _dir] call _spawnVehicle;
		private _transportHeli = _vehArray select 0;
		private _crew_group = _vehArray select 1;

		// spawn dismounts
		private _cargo_group = _dismountGroup call _spawnGroup;
		{
			_x assignAsCargo _transportHeli;
			_x moveInCargo _transportHeli;
		} forEach units _cargo_group;

		if (_method == "fastrope") then {
			[_origin, _destination, _crew_group, _patrolMarker, _cargo_group] spawn AS_tactics_fnc_heli_fastrope;
		} else {
			_vehiculos append ([_origin, _destination, _crew_group, _cargo_group, _patrolMarker] call AS_tactics_fnc_heli_disembark);
		};

		// if the QRF is dispatched to an FIA camp, provide the group
		if (_source == "campQRF") then {
			AS_Sset("campQRF", [_cargo_group]);
		};
	};
} else { // ground
	// find a road to spawn
	private _posData = [_origin, _destination] call AS_fnc_findSpawnSpots;
	private _posRoad = _posData select 0;
	private _dir = _posData select 1;

	// spawn the attack vehicle
	if ((_composition == "destroy") || (_composition == "mixed")) then {
		([_attackVehicle, _posRoad, _dir] call _spawnVehicle) params ["_veh", "_crew_group"];

		[_origin, _destination, _crew_group, _patrolMarker] spawn AS_tactics_fnc_ground_attack;
	};

	// small delay to allow for AI pathfinding
	if (_composition == "mixed") then {
		sleep 5;
	};

	// spawn the transport vehicle
	if ((_composition == "transport") || (_composition == "mixed")) then {
		// transport vehicle
		([_transportVehicle, _posRoad, _dir] call _spawnVehicle) params ["_transport", "_crew_group"];


		// dismount group
		private _grpDis2 = _dismountGroup call _spawnGroup;
		{
			_x assignAsCargo _transport;
			_x moveInCargo _transport;
		} forEach units _grpDis2;

		[_grpDis2, _transport] spawn AS_AI_fnc_DismountOnDanger;
		[_grpDis2, _destination] spawn AS_AI_fnc_dangerOnApproach;

		[_origin, _destination, _crew_group, _patrolMarker, _grpDis2] spawn AS_tactics_fnc_ground_disembark;
	};
};

private _endTime = dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
waitUntil {sleep 10; (dateToNumber date > _endTime) or ({_x call AS_fnc_canFight} count _soldados) < ({!(_x call AS_fnc_canFight)} count _soldados)};

[_grupos, _vehiculos, _markers] call AS_fnc_cleanMissionResources;
