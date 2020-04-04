#include "macros.hpp"
params ["_position", ["_enemySide", "FIA"]];

private _location = _position call AS_location_fnc_nearest;

private _enemyside_short = _enemyside call AS_fnc_getFactionSide;
private _enemySpawnSide = ["BLUFORSpawn", "OPFORSpawn"] select (_enemySide in ["AAF", "CSAT"]);

private _enemySides = [["FIA", "NATO"],["AAF", "CSAT"]] select (_enemySide in ["AAF", "CSAT"]);
private _friendlySides = [["AAF","CSAT"],["FIA", "NATO"]] select (_enemySide in ["AAF", "CSAT"]);

private _threat = 0;

//If closer to a friendly than enemy location, nearby friendly locations decrease threat
if ((_location call AS_location_fnc_side) in _friendlySides) then {
	{
			private _positionOther = _x call AS_location_fnc_position;
			if (_positionOther distance2D _position < 1000) then {
				if ((_x call AS_location_fnc_type) in ["base", "airfield"]) then {
					_threat = _threat - 3;
				} else {
					_threat = _threat - 1;
				};
			};
	} forEach ([["base", "airfield", "outpost", "outpostAA","roadblock", "watchpost", "fia_hq", "camp"], _friendlySides select 0] call AS_location_fnc_TS);
};

// roadblocks
if (_enemySide == "FIA") then {

	_threat = _threat + 2 * (
		{(_x call AS_location_fnc_position) distance2D _position < 1000} count (([["roadblock", "watchpost", "fia_hq"], "FIA"] call AS_location_fnc_TS) arrayIntersect ([] call AS_location_fnc_knownLocations)));

	// bases
	{
		private _otherPosition = _x call AS_location_fnc_position;

		if (_otherPosition distance2D _position < 1000) then {
			private _garrison = _x call AS_location_fnc_garrison;
			private _size = _x call AS_location_fnc_size;

			_threat = _threat + (2*({(_x == "AT Specialist")} count _garrison)) + (floor((count _garrison)/8)); //Ammo bearer here changed to AT spesialist (wtf)
			private _estaticas = AS_P("vehicles") select {_x distance2D _otherPosition < _size};
			if (count _estaticas > 0) then {
				_threat = _threat + ({typeOf _x in AS_allMortarStatics} count _estaticas) + (2*({typeOf _x in AS_allATstatics} count _estaticas));
			};
		};
	} forEach (([["base", "airfield", "outpost", "outpostAA", "resource", "factory", "seaport", "powerplant"], "FIA"]call AS_location_fnc_TS) + (([["watchpost", "roadblock", "fia_hq"], "FIA"] call AS_location_fnc_TS) arrayIntersect ([] call AS_location_fnc_knownLocations)));

} else {
	{
		if ((_x call AS_location_fnc_side) in _enemySides and {(_x call AS_location_fnc_position) distance2D _position < 1000}) then {
			if ((_x call AS_location_fnc_type) in ["base", "airfield"]) then {
				_threat = _threat + 3;
			} else {
				_threat = _threat + 1;
			};
		};

	} foreach (["base", "airfield", "outpost", "outpostAA","roadblock", "hillAA", "resource", "factory", "seaport", "powerplant"] call AS_location_fnc_T);
};
//Other vehicles
//ATM it's randomised which units presence is known to AAF when calculating threat
//All vehicles are knowns

{
	 if (random 1 < 0.5) then {
	 	if ((secondaryWeapon _x) in (AS_weapons select 10)) then {_threat = _threat + 2;};
		_threat = _threat + 0.1;
	};

} forEach ([500, _position, _enemySpawnSide] call AS_fnc_unitsAtDistance);

{
	private _veh = _x;
	private _type = typeOf _x;


		call {
			if (_type in ((["CSAT", "self_aa"] call AS_fnc_getEntity) + (["NATO", "self_aa"] call AS_fnc_getEntity))) exitWith {
		    _threat = _threat + 2;
		  };

		  //TANK Threat

		  if (_veh isKindof "Tank" or _type in BE_class_MBT) exitWith {
		    _threat = _threat + 10;
		  };

		  //APC Threat
		  if (_veh isKindOf "APC_Wheeled_01_base_F" or _veh isKindof "APC_Tracked_01_base_F" or
		    _veh isKindOf "APC_Wheeled_02_base_F" or _veh isKindof "APC_Tracked_02_base_F" or
		    _type in BE_class_APC) exitWith {
		    _threat = _threat + 5;
		  };

		  //MRAP Threat

			if (_type in (["FIA", "cars_at"] call AS_fnc_getEntity)) exitWith {
				_threat = _threat + 4;
			};

		  if (_type in (BE_class_MRAP + (["FIA", "cars_armed"] call AS_fnc_getEntity))) exitWith {
		    _threat = _threat + 2;
		  };

		  //STATICs threat

		  if (_type in AS_allATStatics) exitWith {_threat = _threat + 2;};
		  if (_type in AS_allMGStatics) exitWith {_threat = _threat + 1;};
		  if (_type in AS_allMortarStatics) exitWith {_threat = _threat + 1;};

		  //Helicopter threat
		  //TODO: attack helos + tweak BE_module to include NATO stuff?

		  if (_type in BE_class_Heli or _veh isKindof "Helicopter") exitWith {

		    call {

		        if (_type in AS_allAttackHelis) exitWith {
		          _threat = _threat + 15; //attack helos are more dangerous than tanks

		        };
		        if (_type in AS_allArmedHelis) exitWith {

		        _threat = _threat + 2;
		        };
		    };
		  };

		  //Plane threat. All planes are assumed armed as they're from template file

		  if (_type in AS_allPlanes) exitWith {

		    _threat = _threat + 5;
		  };
		};



} foreach (vehicles select {!((typeof _x) isEqualTo "WeaponHolderSimulated") and {(_x call AS_fnc_getSide) in _enemySides and {_x distance2D _position < 1000}}}); //Changed to side so undercover (side civilian) don't affect this


_threat
