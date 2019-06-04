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

// define type of QRF and vehicles by type of origin, plus method of troop insertion by air (rope or land)
private _type = "air";
private _method = "fastrope";
private _faction = "CSAT";
private _side = "CSAT" call AS_fnc_getFactionSide;
private _attackVehicle = selectRandom (["CSAT", "helis_armed"] call AS_fnc_getEntity);
private _transportVehicle = selectRandom (["CSAT", "helis_transport"] call AS_fnc_getEntity);
private _dismountGroup = [["CSAT", "recon_team"] call AS_fnc_getEntity, "CSAT"] call AS_fnc_pickGroup;
if not (_origin isEqualTo "spawnCSAT") then {
	_method = "disembark";
	_faction = "AAF";
	if (_size == "small") then {
		_transportVehicle = selectRandom (["AAF", "helis_transport"] call AS_fnc_getEntity);
		_dismountGroup = [["AAF", "teams"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		if (_origin in _bases) then {
			_type = "land";
			_attackVehicle = selectRandom (["AAF", "cars_armed"] call AS_fnc_getEntity);
			_transportVehicle = selectRandom ("trucks" call AS_AAFarsenal_fnc_valid);
			_dismountGroup = [["AAF", "squads"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		};
	} else {
		_transportVehicle = selectRandom (["AAF", "helis_transport"] call AS_fnc_getEntity);
		_dismountGroup = [["AAF", "squads"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
		_method = "fastrope";
		if (_origin in _bases) then {
			_type = "land";
			_attackVehicle = selectRandom ("apcs" call AS_AAFarsenal_fnc_valid);
			_transportVehicle = selectRandom ("trucks" call AS_AAFarsenal_fnc_valid);
		};
	};
} else {
	_origin = getMarkerPos "spawnCSAT";
};

// get the position of the target marker
if (typeName _origin != "ARRAY") then {
	_origin = _origin call AS_location_fnc_positionConvoy;
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

		([_vehicleType, _position, _direction, _faction, "any", 400, "FLY", true, 7] call AS_fnc_createVehicle) params ["_vehicle", "_crewGroup"];
		_grupos pushBack _crewGroup;
		_soldados append units _crewGroup;
		_vehiculos pushBack _vehicle;
		_vehicle
	};

		([_vehicleType, _position, _direction, _faction, "any", 0, "NONE", true, 7] call AS_fnc_createVehicle) params ["_vehicle", "_crewGroup"];
		_grupos pushBack _crewGroup;
		_soldados append units _crewGroup;
		_vehiculos pushBack _vehicle;
		_vehicle


};

if (_type == "air") then {
	private _dir = [_origin, _destination] call BIS_fnc_dirTo;

	if ((_composition == "destroy") || (_composition == "mixed")) then {
		private _grpVeh1 = [_attackVehicle, _origin, _dir] call _spawnVehicle;

		[_origin, _destination, _grpVeh1] spawn AS_tactics_fnc_heli_attack;
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

		private _transportHeli = [_transportVehicle, _pos2, _dir] call _spawnVehicle;

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
		private _veh = [_attackVehicle, _posRoad, _dir] call _spawnVehicle;

		[_origin, _destination, (group (driver _veh)), _patrolMarker] spawn AS_tactics_fnc_ground_attack;
	};

	// small delay to allow for AI pathfinding
	if (_composition == "mixed") then {
		sleep 5;
	};

	// spawn the transport vehicle
	if ((_composition == "transport") || (_composition == "mixed")) then {
		// transport vehicle
		private _transport = [_transportVehicle, _posRoad, _dir] call _spawnVehicle;


		// dismount group
		private _grpDis2 = _dismountGroup call _spawnGroup;
		{
			_x assignAsCargo _transport;
			_x moveInCargo _transport;
		} forEach units _grpDis2;

		[_origin, _destination, (group (driver _transport)), _patrolMarker, _grpDis2] spawn AS_tactics_fnc_ground_disembark;
	};
};

private _endTime = dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
waitUntil {sleep 10; (dateToNumber date > _endTime) or ({_x call AS_fnc_canFight} count _soldados == 0)};

[_grupos, _vehiculos, _markers] call AS_fnc_cleanResources;
