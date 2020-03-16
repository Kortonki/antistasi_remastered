#include "macros.hpp"
params ["_position", ["_enemyside", "FIA"]]; //_side = enemyside

private _location = _position call AS_location_fnc_nearest;

private _enemyside_short = _enemyside call AS_fnc_getFactionSide;
private _enemySpawnSide = ["BLUFORSpawn", "OPFORSpawn"] select (_enemyside in ["AAF", "CSAT"]);

private _enemySides = [["FIA", "NATO"],["AAF", "CSAT"]] select (_enemyside in ["AAF", "CSAT"]);
private _friendlySides = [["AAF","CSAT"],["FIA", "NATO"]] select (_enemyside in ["AAF", "CSAT"]);


private _threat = 0;

//If closer to a friendly than enemy location, nearby friendly locations decrease threat
if ((_location call AS_location_fnc_side) in _friendlySides) then {
	{
			private _positionOther = _x call AS_location_fnc_position;
			if (_positionOther distance2D _position < (AS_P("spawnDistance"))) then {
				if ((_x call AS_location_fnc_type) in ["base", "airfield"]) then {
					_threat = _threat - 3;
				} else {
					_threat = _threat - 1;
				};
			};
	} forEach ([["base", "airfield", "outpost", "outpostAA","roadblock", "watchpost", "fia_hq", "camp"], _friendlySides select 0] call AS_location_fnc_TS);
};

if (_enemySide == "FIA") then {
	{
		private _positionOther = _x call AS_location_fnc_position;
		private _garrison = _x call AS_location_fnc_garrison;
		private _size = _x call AS_location_fnc_size;
		if (_positionOther distance _position < AS_P("spawnDistance")) then {
			_threat = _threat + (floor((count _garrison)/4)) + (2*({(_x == "AA Specialist")} count _garrison));
			private _estaticas = AS_P("vehicles") select {_x distance _positionOther < _size};
			if (count _estaticas > 0) then {
				_threat = _threat + ({typeOf _x in AS_allMGstatics} count _estaticas) + (5*({typeOf _x in AS_allAAstatics} count _estaticas));
			};
		};
	} forEach (([["base", "airfield", "outpost", "outpostAA"], "FIA"] call AS_location_fnc_TS) + (([["watchpost", "roadblock", "fia_hq", "camp"], "FIA"] call AS_location_fnc_TS) arrayIntersect ([] call AS_location_fnc_knownLocations)));
} else {
	{
		if ((_x call AS_location_fnc_side) in _enemySides and {(_x call AS_location_fnc_position) distance2D _position < 2000}) then {
			if ((_x call AS_location_fnc_type) in ["outpostAA", "base", "airfield", "hillAA"]) then {
				_threat = _threat + 3;
			} else {
				_threat = _threat + 1;
			};
		};

	} foreach (["base", "airfield", "outpost", "outpostAA","roadblock", "hillAA"] call AS_location_fnc_T);

};

//Foot soldier threat

{
	 if (random 1 < 0.5) then {
	 	if ((secondaryWeapon _x) in (AS_weapons select 8)) then {_threat = _threat + 2;};
		if ((primaryWeapon _x) in (AS_weapons select 6)) then {_threat = _threat + 0.5;};
		_threat = _threat + 0.1;
	};

} forEach ([500, _position, _enemySpawnSide] call AS_fnc_unitsAtDistance);

//vehicle threat

{

	private _veh = _x;
	private _type = typeOf _x;

		call {

		//ORDER MATTERS: more spesific conditions are first because AA vehicles can also be Tanks

	  //AA Vehicle ThreatEval

	  if (_type in ((["CSAT", "self_aa"] call AS_fnc_getEntity) + (["NATO", "self_aa"] call AS_fnc_getEntity))) exitWith {
	        _threat = _threat + 10;
	  };

	  //TANK Threat

	  if (_veh isKindof "Tank" or _type in BE_class_MBT) exitWith {

	    _threat = _threat + 4;
	  };

	  //APC Threat
	  if (_veh isKindOf "APC_Wheeled_01_base_F" or _veh isKindof "APC_Tracked_01_base_F" or
	    _veh isKindOf "APC_Wheeled_02_base_F" or _veh isKindof "APC_Tracked_02_base_F" or
	    _type in BE_class_APC) exitWith {
	     _threat = _threat + 2;
	  };

	  //MRAP Threat

		if (_type in (["FIA", "cars_aa"] call AS_fnc_getEntity)) exitWith {
			_threat= _threat + 8;
		};

	  if (_type in (BE_class_MRAP + (["FIA", "cars_armed"] call AS_fnc_getEntity))) exitWith {
	      _threat = _threat + 2;
	  };

	  //STATICs threat

	  if (_type in AS_allAAStatics) exitWith {_threat = _threat + 7;};
	  if (_type in AS_allMGStatics) exitWith {_threat = _threat + 1;};

	  //Helicopter threat
	  //TODO: attack helos + tweak BE_module to include NATO stuff?

	  if (_type in BE_class_Heli or _veh isKindof "Helicopter") exitWith {

	    call {

	        if (_type in AS_allAttackHelis) exitWith {
	        _threat = _threat + 5;

	        };
	        if (_type in AS_allArmedHelis) exitWith {
	        _threat = _threat + 2;
	        };
	    };
	  };

	  //Plane threat. All planes are assumed armed as they're from template file

	  if (_type in AS_allPlanes) exitWith {
	    _threat = _threat + 15;
	  	};
		};

} foreach (vehicles select {!((typeof _x) isEqualTo "WeaponHolderSimulated") and {side _x == _enemyside_short and {_x distance2D _position < 1500}}});

_threat
