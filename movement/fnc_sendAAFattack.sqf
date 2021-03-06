#include "../macros.hpp"

params [["_skipping", false]];

AS_AAF_attackLock = true;

private _debug_prefix = "AS_movement_fnc_sendAAFattack: ";
private _debug_message = "";

private _objectives = [];
private _count_easy = 0;
private _alarm = false;

private _FIAbases = [["base","airfield"], "FIA"] call AS_location_fnc_TS;

private _useCSAT = call AS_fnc_useCSAT;

private _validTypes = ["base", "airfield", "outpost", "powerplant", "factory", "resource"]; //City removed from types, until fixed (gets stuck without error, prolly infinite loap). Probably needs balancing too now, as useCSAT criteria has changed
//Fia_hq, watchpost, roadblock, camp must be first discovered by AAF

// only attack cities and use CSAT if FIA controls a base or airfield
/*if (!_useCSAT) then {
	_validTypes = _validTypes - ["city"];
};*/

private _validLocations = ([_validTypes, "FIA"] call AS_location_fnc_TS); //Fixed locations + FIA locations discovered by the AAF
private _knownLocations = [] call AS_location_fnc_knownLocations;
_validLocations append _knownLocations;

private _enemyLocations = "NATO" call AS_location_fnc_S; //This changed so known locations are checked and excluding minefields to avoid errors
_enemyLocations append _validLocations;

if (count _validLocations == 0) exitWith {

	_debug_message = "postponed: no valid targets. Starting a convoy mission for AAF or recon patrol";
	diag_log (_debug_prefix + _debug_message);

	_alarm = [_skipping] call AS_movement_fnc_sendAAFConvoy;
		//Schedule next attack
		private _attFreq = AS_P("secondsForAAFattack");
		private _nextAttack = [date select 0, date select 1, date select 2, date select 3, (date select 4) + (_attFreq/60)];
		_nextAttack = datetoNumber _nextAttack;
		AS_Pset("nextAttack", _nextAttack);
		AS_AAF_attackLock = nil;

		//The alarm for skipping time
		_alarm
};

// the potential the AAF has to attack
private _scoreLand = ("apcs" call AS_AAFarsenal_fnc_countAvailable) + 5*("tanks" call AS_AAFarsenal_fnc_countAvailable);
private _scoreAir = ("helis_armed" call AS_AAFarsenal_fnc_countAvailable) + 5*("planes" call AS_AAFarsenal_fnc_countAvailable);
if (_useCSAT) then {
	_scoreLand = _scoreLand + 15;
	_scoreAir = _scoreAir + 15;
};

{  // forEach _validLocations
	private _location = _x;
	private _type = _location call AS_location_fnc_type;
	private _position = _location call AS_location_fnc_position;
	private _garrison = _location call AS_location_fnc_garrison;

	call {
		if (_type == "city") exitWith {
			// cities are attacked by CSAT, so no need to compute anything
			private _FIAsupport = [_x, "FIAsupport"] call AS_location_fnc_get;
			private _AAFsupport = [_x, "AAFsupport"] call AS_location_fnc_get;

			// only attack cities that have high FIA and low AAF support
			if ((_AAFsupport < 5) and (_FIAsupport > 70)) then {
				_objectives append [_x, _x, _x, _x, _x];
			};
		};

		if (_type == "camp") exitWith {_objectives append [_x, _x, _x, _x, _x]};
		private _base = [_position, true] call AS_fnc_getBasesForCA;
		private _aeropuerto = [_position, true] call AS_fnc_getAirportsForCA;

		// short circuit if no valid bases or airfields to attack
		if ((_base != "") or (_aeropuerto != "")) then {
			private _closeEnemylocations = _enemyLocations select {((_x call AS_location_fnc_position) distance2D _position < AS_P("spawnDistance")/2)};

			(_closeEnemylocations call AS_fnc_AAFattackScore) params ["_scoreNeededLand", "_scoreNeededAir"];

			private _isEasy = (_scoreNeededLand < 4) and (_scoreNeededAir < 4) and (count _garrison < 4) and !(_type in ["base", "airfield", "fia_hq"]);

			_debug_message = format ["%1: (%2,%3) (%4,%5) %6, Base %7, Airport %8", _location, _scoreAir, _scoreNeededAir, _scoreLand, _scoreNeededLand, _isEasy, _base, _aeropuerto];
			diag_log(_debug_prefix + _debug_message);

			// decide to attack or not depending on the scores
			//don't make them send nonexistant vehicle or the last one, just for a good measure
			if (_scoreNeededLand > _scoreLand or ("trucks" call AS_AAFarsenal_fnc_countAvailable < 2)) then {
				_base = "";
			} else {  // if it is easy,
				if (_isEasy and {_base != ""}) then {
					if !(_location in AS_P("patrollingLocations")) then {
						_count_easy = _count_easy + 2;
						[[_location,_base], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
						//sleep 15; this function is called as well
					};
				};
			};
			//don't make them send nonexistant vehicle or the last one, just for a good measure
			if (_scoreNeededAir > _scoreAir or ("helis_transport" call AS_AAFarsenal_fnc_countAvailable < 2)) then {
				_aeropuerto = "";
			}
			else {
				if (_isEasy and {_base == "" and {_aeropuerto != ""}}) then {
					if !(_location in AS_P("patrollingLocations")) then {
						_count_easy = _count_easy + 1;
						[[_location,_aeropuerto], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
						//sleep 15;
					};
				};
			};

			// add the location to the objectives
			if (((_base != "") or (_aeropuerto != ""))) then {
				// increase likelihood of bases and others
				private _cuenta = 1;
				if (_type in ["resource"]) then {_cuenta = 3};
				if (_type in ["powerplant", "factory"]) then {_cuenta = 4};
				if (_type in ["base", "airfield"]) then {_cuenta = 5};

				// amplify the effect to combined attacks or close targets.
				if (_base != "") then {
					if (_aeropuerto != "") then {_cuenta = _cuenta*2};
					if (_location == [_validLocations, _base] call bis_fnc_nearestPosition) then {_cuenta = _cuenta*2};
				};
				for "_i" from 1 to _cuenta do {
					_objectives pushBack _location;
				};
			};
		} else {
			_debug_message = format ["  %1: No valid hq, bases or airfields to attack.", _location];
			diag_log(_debug_prefix + _debug_message);

			//TODO: send convoy or recon patrol here. Make an external function of it and call it above if validLocations == 0

		};
	};
} forEach _validLocations;

if (count _objectives > 0) then {
	private _location = selectRandom _objectives;
	call {
		//TODO make isEasy  parameter effect attack strength inside functions below
		//CAmps are now attacked like any location
		/*if (_location call AS_location_fnc_type == "camp") exitWith {
			_location call AS_mission_fnc_createDefendCamp;
			_alarm = true;
		};*/
		if (_location call AS_location_fnc_type == "city") exitWith {
			_location call AS_mission_fnc_createDefendCity;
			_alarm = true;
		};
		if (_location call AS_location_fnc_type == "fia_hq") exitWith {
			_alarm = [] call AS_mission_fnc_createDefendHQ; //If mission creation fails, no alarm

		};
		[_location, _useCSAT] call AS_mission_fnc_createDefendLocation;
		_alarm = true;
	};

} else {
	if ([_skipping] call AS_movement_fnc_sendAAFConvoy) then {_alarm = true}; //Convoys to FIA locations trigger alarm
};

//Schedule next attack
private _attFreq = AS_P("secondsForAAFattack");
private _nextAttack = [date select 0, date select 1, date select 2, date select 3, (date select 4) + (_attFreq/60)];
_nextAttack = datetoNumber _nextAttack;
AS_Pset("nextAttack", _nextAttack);
AS_AAF_attackLock = nil;

//Alarm for skipping time
_alarm
