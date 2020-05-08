#include "../macros.hpp"
AS_SERVER_ONLY("fnc_sendAAFpatrol");
params ["_location", ["_fromBase", ""], ["_threatEval_Land", 0], ["_threatEval_Air", 0], ["_start", false]];

private _debug_prefix = format ["sendAAFPatrol from '%1' to '%2' cancelled: ", _fromBase, _location];

private _FIAbases = [["base","airfield"], "FIA"] call AS_location_fnc_TS;

private _isDirectAttack = false;
private _base = "";
private _aeropuerto = "";
private _exit = false;

if (!(_fromBase isEqualto "")) then {
	_isDirectAttack = true;
	if (_fromBase call AS_location_fnc_type == "airfield") then {
		_aeropuerto = _base;
		_base = "";
	} else {
		_base = _fromBase;
	};
};

private _isLocation = false;
private _exit = false;
private _position = "";
if (typeName _location == typeName "") then {
	if (!(_location call AS_location_fnc_exists)) exitWith {
		//If location no longer exists, delete it. Happens with temporary FIA locations (roadblocks etc.)
		AS_Pset("patrollingLocations", (AS_P("patrollingLocations") - [_location]));
		_exit = true
		};
	_isLocation = true;
	_position = _location call AS_location_fnc_position;
} else {
	_position = _location;
};

if _exit exitWith {};

if (!_isDirectAttack and !(_position call AS_fnc_hasRadioCoverage)) exitWith {
	private _message = "no radio contact";
	diag_log (_debug_prefix + _message);
};

if (_isLocation and !_isDirectAttack and (_location in AS_P("patrollingLocations"))) exitWith {
	private _message = "location being patrolled";
	diag_log (_debug_prefix + _message);
};

private _exit = false;
if (!_isLocation) then {
	// do not patrol closeby patrol locations.
	private _closestPatrolPosition = [AS_P("patrollingPositions"), _position] call BIS_fnc_nearestPosition;
	if (_closestPatrolPosition distance2D _position < 500) exitWith {_exit = true;};

	// do not patrol closeby to patrolled markers.
	if (count AS_P("patrollingLocations") > 0) then {
		private _closestPatrolMarker = [AS_P("patrollingLocations"), _position] call BIS_fnc_nearestPosition;
		if ((_closestPatrolMarker call AS_location_fnc_position) distance2D _position < 500) then {_exit = true;};
	};
};

//start is to skip this step in mission load where above check will fail
if (_exit and {!(_start)}) exitWith {
	private _message = "nearby being patrolled";
	diag_log (_debug_prefix + _message);
};

// select base to attack from.
if (!_isDirectAttack) then {
	_base = [_position] call AS_fnc_getBasesForCA;
	if (_base == "") then {_aeropuerto = [_position] call AS_fnc_getAirportsForCA};
};

private _scoreLand = ("trucks" call AS_AAFarsenal_fnc_countAvailable) + ("apcs" call AS_AAFarsenal_fnc_countAvailable)*2 + 5*("tanks" call AS_AAFarsenal_fnc_countAvailable);
private _scoreAir = ("helis_transport" call AS_AAFarsenal_fnc_countAvailable) + ("helis_armed" call AS_AAFarsenal_fnc_countAvailable)*2 + 5*("planes" call AS_AAFarsenal_fnc_countAvailable);

private _useCSAT = call AS_fnc_useCSAT;

if (_useCSAT) then {
	_scoreLand = _scoreLand + 15;
	_scoreAir = _scoreAir + 15;
};

// check if CSAT will help.
//Changed to same condition as in sendAAFattack


if ((_base == "") and {(_aeropuerto == "") and {!(_useCSAT)}}) exitWith {
	private _message = "no bases close to attack";
	diag_log (_debug_prefix + _message);
};  // if no way to create patrol, exit.

// Compute threat and decide to use bases airfields or none.

private _threatEval = 0;

// decide to not use airfield if not enough air units or AA treat too high
if (_aeropuerto != "") then {
	private _transportHelis = "helis_transport" call AS_AAFarsenal_fnc_countAvailable;
	private _armedHelis = "helis_armed" call AS_AAFarsenal_fnc_countAvailable;
	private _planes = "planes" call AS_AAFarsenal_fnc_countAvailable;
	// 1 transported + any other if _isLocation.
	//Check for two vehs as that's the max for a patrol
	if (_transportHelis < 2 or (_isLocation and {_transportHelis + _armedHelis + _planes < 2})) then {
		_aeropuerto = "";
	};

	// decide to not send air units if treat of AA is too high.
	if (_aeropuerto != "" and !_isDirectAttack) then {
		_threatEval = _threatEval_Air max ([_position, "FIA"] call AS_fnc_getAirThreat);

		if (_threatEval > _scoreAir or _threatEval > 15) then { //ThreatEval 15 is a hard limit for air operations, which equals to AA vehivles
			_aeropuerto = "";
		};
	};
};

// decide to not send if treat is too high.
if (_base != "") then {
	_threatEval = _threatEval_Land max ([_position] call AS_fnc_getLandThreat);
	private _trucks = "trucks" call AS_AAFarsenal_fnc_countAvailable;
	private _apcs = "apcs" call AS_AAFarsenal_fnc_countAvailable;
	private _tanks = "tanks" call AS_AAFarsenal_fnc_countAvailable;

	if (!_isDirectAttack) then {
		if (_threatEval > _scoreLand or (_trucks + _apcs + _tanks < (_threatEval/3))) then {
			_base = "";
		};
	};
};

if ((_base == "") and {_aeropuerto == ""}) exitWith {
	private _message = format ["threat too high or no arsenal. Threat: %1, hasCSAT: %2", _threatEval, _useCSAT];
	["true", "true", -0.1] remoteExec ["AS_AI_fnc_adjustThreatModifier", 2]; //This should make AAF send patrol, eventually. Very small effect, it is expected this happens often
	diag_log (_debug_prefix + _message);
};

/////////////////////////////////////////////////////////////////////////////
////////////////////// Checks passed. spawn the patrol //////////////////////
/////////////////////////////////////////////////////////////////////////////

private _spawnName = format ["aaf_patrol_%1%2", round(diag_ticktime/60), round(random 100)];
[_spawnName, "AAFpatrol"] call AS_spawn_fnc_add;
[_spawnName, "location", _location] call AS_spawn_fnc_set;
[_spawnName, "base", _base] call AS_spawn_fnc_set;
[_spawnName, "airfield", _aeropuerto] call AS_spawn_fnc_set;
[_spawnName, "useCSAT", _useCSAT] call AS_spawn_fnc_set;
[_spawnName, "isDirectAttack", _isDirectAttack] call AS_spawn_fnc_set;
[_spawnName, "threatEval", _threatEval] call AS_spawn_fnc_set;

diag_log format ["[AS] Send AAF Patrol: Spawname %1, Location %2, Base %3, Airfield %4, useCSAT %5, isDirectAttack %6 threatEval %7", _spawnName, _location, _base, _aeropuerto, _useCSAT, _isDirectAttack, _threatEval];

[_spawnName] spawn AS_spawn_fnc_execute;
