#include "../macros.hpp"

params [["_skipping", false]];

AS_AAF_attackLock = true;

private _debug_prefix = "AS_movement_fnc_sendAAFattack: ";
private _debug_message = "";

private _objectives = [];
private _count_easy = 0;
private _alarm = false;

private _FIAbases = [["base","airfield"], "FIA"] call AS_location_fnc_TS;

private _useCSAT = true;

private _validTypes = ["base", "airfield", "outpost", "city", "powerplant", "factory", "resource"];
//Fia_hq, watchpost, roadblock, camp must be first discovered by AAF

// only attack cities and use CSAT if FIA controls a base or airfield
if ((random 100 > AS_P("CSATsupport")) or (count _FIAbases == 0) or AS_S("blockCSAT")) then {
	_validTypes = _validTypes - ["city"];
	_useCSAT = false;
};

private _validLocations = ([_validTypes, "FIA"] call AS_location_fnc_TS); //Fixed locations + FIA locations discovered by the AAF
private _knownLocations = [] call AS_location_fnc_knownLocations;
_validLocations append _knownLocations;

private _enemyLocations = ["FIA","NATO"] call AS_location_fnc_S;

if (count _validLocations == 0) exitWith {

	//If skipping time, don't spam anything
	if (!(_skipping))	then {
	_debug_message = "postponed: no valid targets. Starting a convoy mission for AAF or recon patrol";
	diag_log (_debug_prefix + _debug_message);

	//Possible mission types for AAF if it can't attack anywhere

	private _missions = (call AS_mission_fnc_all) select {_x call AS_mission_fnc_status in ["available"] and
		{_x call AS_mission_fnc_type in [
			"convoy_ammo",
			"convoy_armor",
			"convoy_fuel",
			"convoy_hvt",
			"convoy_supplies",
			"convoy_money",
			"convoy_prisoners",
			"help_meds"
			]}};

		if (count _missions > 0) then {
			private _mission = selectRandom _missions;
			_mission call AS_mission_fnc_activate;
			_debug_message = "Valid mission found, starting mission";
			diag_log(_debug_prefix + _debug_message);
		} else {
				//if nothing else, send recon patrols somewhere
				private _position = [];
				private _valid = false;
				private _i = 0;
				while {_i = _i + 1; !(_valid) and {_i < 100}} do { //Limit to 100 iterations
					private _searchFrom = selectRandom ([["base", "outpost", "airfield"], "AAF"] call AS_location_fnc_TS);
					_position = [(_searchFrom call AS_location_fnc_position), 500 + random 2000, random 360] call bis_fnc_relPos; //TODO check for map edges
					_valid = true;
					if (surfaceisWater _position) then {_valid = false;}
					else {
						{
							if ((_x call AS_location_fnc_position) distance2D _position < 500) exitWith {_valid = false;}; //position is not too close to any other enemy position
						} foreach (["AAF", "CSAT"] call AS_location_fnc_S);
					};
				};

				if (_valid) then {
					[_position] spawn AS_movement_fnc_sendAAFpatrol;
					_debug_message = "No valid missions: Send AAF recon patrol";
					diag_log(_debug_prefix + _debug_message);
				} else {
					_debug_message = "No valid missions or recon areas for AAF. Do nothing";
					diag_log(_debug_prefix + _debug_message);
				};

		};
	};
		//Schedule next attack
		private _attFreq = AS_P("secondsForAAFattack");
		private _nextAttack = [date select 0, date select 1, date select 2, date select 3, (date select 4) + (_attFreq/60)];
		_nextAttack = datetoNumber _nextAttack;
		AS_Pset("nextAttack", _nextAttack);
		AS_AAF_attackLock = nil;

		//The alarm for skipping time
		false
};

// the potential the AAF has to attack
private _scoreLand = ("apcs" call AS_AAFarsenal_fnc_count) + 5*("tanks" call AS_AAFarsenal_fnc_count);
private _scoreAir = ("helis_armed" call AS_AAFarsenal_fnc_count) + 5*("planes" call AS_AAFarsenal_fnc_count);
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
		// todo: make a camp discoverable by AAF before being attackable...
		if (_type == "camp") exitWith {_objectives append [_x, _x, _x, _x, _x]};
		private _base = [_position, true] call AS_fnc_getBasesForCA;
		private _aeropuerto = [_position, true] call AS_fnc_getAirportsForCA;

		// short circuit if no valid bases or airfields to attack
		if ((_base != "") or (_aeropuerto != "")) then {
			private _closeEnemylocations = _enemyLocations select {((_x call AS_location_fnc_position) distance _position < AS_P("spawnDistance")/2)};

			(_closeEnemylocations call AS_fnc_AAFattackScore) params ["_scoreNeededLand", "_scoreNeededAir"];

			private _isEasy = (_scoreNeededLand < 4) and (_scoreNeededAir < 4) and (count _garrison < 4) and !(_type in ["base", "airfield"]);

			_debug_message = format ["%1: (%2,%3) (%4,%5) %6", _location, _scoreAir, _scoreNeededAir, _scoreLand, _scoreNeededLand, _isEasy];
			diag_log(_debug_prefix + _debug_message);

			// decide to attack or not depending on the scores
			if (_scoreNeededLand > _scoreLand) then {
				_base = "";
			} else {  // if it is easy,
				if (_isEasy and (_base != "") and (_count_easy < 4)) then {
					if !(_location in AS_P("patrollingLocations")) then {
						_count_easy = _count_easy + 2;
						[[_location,_base], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
						//sleep 15; this function is called as well
					};
				};
			};
			if (_scoreNeededAir > _scoreAir) then {
				_aeropuerto = "";
			}
			else {
				if (_isEasy and (_base == "") and (_aeropuerto != "") and (_count_easy < 4)) then {
					if !(_location in AS_P("patrollingLocations")) then {
						_count_easy = _count_easy + 1;
						[[_location,_aeropuerto], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
						//sleep 15;
					};
				};
			};

			// add the location to the objectives
			if (((_base != "") or (_aeropuerto != "")) and (!_isEasy)) then {
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
			_debug_message = format ["  %1: No valid bases or airfields to attack.", _location];
			diag_log(_debug_prefix + _debug_message);
		};
	};
} forEach _validLocations;

if ((count _objectives > 0) and (_count_easy < 3)) then {
	private _location = selectRandom _objectives;
	call {
		if (_location call AS_location_fnc_type == "camp") exitWith {
			_location call AS_mission_fnc_createDefendCamp;
			_alarm = true;
		};
		if (_location call AS_location_fnc_type == "city") exitWith {
			_location call AS_mission_fnc_createDefendCity;
			_alarm = true;
		};
		if (_location call AS_location_fnc_type == "fia_hq") exitWith {
			_location call AS_mission_fnc_createDefendHQ;
			_alarm = true;
		};
		_location call AS_mission_fnc_createDefendLocation;
		_alarm = true;
	};

};

//Schedule next attack
private _attFreq = AS_P("secondsForAAFattack");
private _nextAttack = [date select 0, date select 1, date select 2, date select 3, (date select 4) + (_attFreq/60)];
_nextAttack = datetoNumber _nextAttack;
AS_Pset("nextAttack", _nextAttack);
AS_AAF_attackLock = nil;

//Alarm for skipping time
_alarm
