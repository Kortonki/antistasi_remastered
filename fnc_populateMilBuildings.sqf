params ["_location", "_side", "_grupo", ["_airfield", false]]; //At airports, choppers are spawned via others

private _posicion = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;
private _buildings = nearestObjects [_posicion, AS_destroyable_buildings, _size*1.5];
private _addChopper = !(_airfield) and {_side == "AAF"} and
	{!([_location] call AS_fnc_location_isFrontline)} and
	{["helis_transport", 0.7] call AS_fnc_vehicleAvailability}; //Lowish priority for non airfield helis

private _minimumShare = 1/4; //This is how much surplus AAF needs to allow spawning vehicles to location. Higher number, lower priority location.

if (_location call AS_location_fnc_type in ["base", "airfield"]) then {
	_minimumShare = 0;
};

private _staticAA = ([_side, "static_aa"] call AS_fnc_getEntity) select 0;
private _staticMG = ([_side, "static_mg"] call AS_fnc_getEntity) select 0;
private _gunnerCrew = [_side, "gunner"] call AS_fnc_getEntity;

private _soldiers = [];
private _vehicles = [];
private _groups = [];
private _markers = [];

{
	private _building = _x;
	private _buildingType = typeOf _building;

	if (_buildingType in AS_MGbuildings) then {

	call {
				if (((_side == "AAF" and {["static_aa", _minimumShare] call AS_fnc_vehicleAvailability}) or _side != "AAF") and {_buildingType in ["Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F"]}) exitWith {
					private _veh = [_staticAA, (_building buildingPos 8), _side, getDir _building, "CAN_COLLIDE"] call AS_fnc_createEmptyVehicle;
					_veh setPosATL [(getPos _building select 0),(getPos _building select 1),(getPosATL _veh select 2)];
					private _unit = _grupo createUnit [_gunnerCrew, _posicion, [], 0, "NONE"];
					_unit moveInGunner _veh;
					_soldiers pushback _unit;
					_vehicles pushback _veh;
				};

				if (((_side == "AAF" and {["static_mg", _minimumShare] call AS_fnc_vehicleAvailability}) or _side != "AAF") and {_buildingType in ["Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F"]}) exitWith {
					private _veh = [_staticMG, (_building buildingPos 1), _side, (getDir _building) - 180, "CAN_COLLIDE"] call AS_fnc_createEmptyVehicle;
					private _ang = (getDir _building) - 180;
					private _pos = [getPosATL _veh, 2.5, _ang] call BIS_Fnc_relPos;
					_veh setPosATL _pos;
					_veh setDir (getDir _building) - 180;
					private _unit = _grupo createUnit [_gunnerCrew, _posicion, [], 0, "NONE"];
					_unit moveInGunner _veh;
					_soldiers pushback _unit;
					_vehicles pushback _veh;
				};

				if (((_side == "AAF" and {["static_mg", _minimumShare] call AS_fnc_vehicleAvailability}) or _side != "AAF") and {_buildingType in ["Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"]}) exitWith {
				private _veh = [_staticMG, (_building buildingPos 13), _side, random 360, "CAN_COLLIDE"] call AS_fnc_createEmptyVehicle;
				private _unit = _grupo createUnit [_gunnerCrew, _posicion, [], 0, "NONE"];
				_unit moveInGunner _veh;
				_soldiers pushback _unit;
				_vehicles pushback _veh;

				_veh = createVehicle [_staticMG, getpos _building, [], 0, "CAN_COLLIDE"];
				_unit = _grupo createUnit [_gunnerCrew, _posicion, [], 0, "NONE"];
				_unit moveInGunner _veh;
				_soldiers pushback _unit;
				_vehicles pushback _veh;

			};

			//This is for small sandbag bunkers

			if ((_side == "AAF" and {["static_mg", _minimumShare] call AS_fnc_vehicleAvailability}) or _side != "AAF") exitWith {
				private _veh = [_staticMG, getpos _building, _side, getDir _building, "CAN_COLLIDE"] call AS_fnc_createEmptyVehicle;
				private _unit = _grupo createUnit [_gunnerCrew, _posicion, [], 0, "NONE"];
				_unit moveInGunner _veh;
				_soldiers pushback _unit;
				_vehicles pushback _veh;
			};

		};
	};
	if (_addChopper and (_buildingType == "Land_HelipadSquare_F")) then {
		private _vehType = selectRandom ("helis_transport" call AS_AAFarsenal_fnc_valid);
	  private _veh = [_vehType, position _building, _side, getDir _building, "CAN_COLLIDE"] call AS_fnc_createEmptyvehicle;
		_vehicles pushback _veh;

		([_veh, _side, "pilot"] call AS_fnc_createVehicleGroup) params ["_pilotGroup", "_units"];

		private _patrolMarker = [_pilotGroup, _veh, [([["base", "airfield"], "AAF"] call AS_location_fnc_TS) + "spawnCSAT", _posicion] call bis_fnc_nearestPosition, _size*0.5] call AS_tactics_fnc_crew_sentry; //TODO figure a way if situation is such that there's no aaf baeses/airfield?

		_groups pushback _pilotGroup;
		_markers pushback _patrolMarker;
		//Soldiers are added later, to avoid double init in location spawn
	};

} forEach _buildings;

[_soldiers, _vehicles, _groups, _markers]
