#include "macros.hpp"
params ["_position"];

private _location = _position call AS_location_fnc_nearest;

private _threat = 0;

if (_location call AS_location_fnc_side == "AAF") then {
	{
			private _positionOther = _x call AS_location_fnc_position;
			if (_positionOther distance _position < (AS_P("spawnDistance")*1.5)) then {
				if ((_x call AS_location_fnc_type) in ["base", "airfield"]) then {
					_threat = _threat + 3;
				} else {
					_threat = _threat + 1;
				};
			};
	} forEach ([["base", "airfield", "watchpost", "roadblock", "hill"], "AAF"]call AS_location_fnc_TS);
} else {
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
	} forEach (([["base", "airfield", "outpost"], "FIA"]call AS_location_fnc_TS) + ([["watchpost", "roadblock", "fia_hq"], "FIA"] call AS_location_fnc_TS arrayIntersect ([] call AS_location_fnc_knownLocations)));
};

{
	 if (random 1 < 0.5) then {
	 	if ((secondaryWeapon _x) in (AS_weapons select 8)) then {_threat = _threat + 2;};
		if ((primaryWeapon _x) in (AS_weapons select 6)) then {_threat = _threat + 0.5;};
		_threat = _threat + 0.1;
	};

} forEach ([500, _position, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);

{

	private _veh = _x;
	private _type = typeOf _x;

		call {

		//ORDER MATTERS: more spesific conditions are first because AA vehicles can also be Tanks

	  //AA Vehicle ThreatEval

	  if (_type in (["CSAT", "self_aa"] call AS_fnc_getEntity)) exitWith {
	        _threat = _threat + 10;
	  };

	  //TANK Threat

	  if (_veh isKindof "Tank" or _type in BE_class_MBT) exitWith {

	    _threat = _threat + 2;
	  };

	  //APC Threat
	  if (_veh isKindOf "APC_Wheeled_01_base_F" or _veh isKindof "APC_Tracked_01_base_F" or
	    _veh isKindOf "APC_Wheeled_02_base_F" or _veh isKindof "APC_Tracked_02_base_F" or
	    _type in BE_class_APC) exitWith {
	     _threat = _threat + 2;
	  };

	  //MRAP Threat

	  if (typeOf _veh in BE_class_MRAP) exitWith {
	      _threat = _threat + 2;
	  };

	  //STATICs threat

	  if (_veh in AS_allAAStatics) exitWith {_threat = _threat + 5;};
	  if (_veh in AS_allMGStatics) exitWith {_threat = _threat + 1;};

	  //Helicopter threat
	  //TODO: attack helos + tweak BE_module to include NATO stuff?

	  if (_veh in BE_class_Heli or _veh isKindof "Helicopter") exitWith {

	    call {

	        if (_veh in AS_allAttackHelis) exitWith {
	        _threat = _threat + 5;

	        };
	        if (_veh in AS_allArmedHelis) exitWith {
	        _threat = _threat + 2;
	        };
	    };
	  };

	  //Plane threat. All planes are assumed armed as they're from template file

	  if (_veh in AS_allPlanes) exitWith {
	    _threat = _threat + 15;
	  	};
		};

} foreach (vehicles select {!((typeof _x) isEqualTo "WeaponHolderSimulated") and {_x distance2D _position < 1500 and {_x call AS_fnc_getSide == "FIA"}}});

_threat
