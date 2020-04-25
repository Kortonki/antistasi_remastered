#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_spendAAFmoney.sqf");

waitUntil {isNil "AS_resourcesIsChanging"};
AS_resourcesIsChanging = true;

//this does not use external func for resource calcs as it is updated during the buying process and dictionary is not updated during

private _resourcesAAF = AS_P("resourcesAAF");
private _skillAAF = AS_P("skillAAF");

private _AAFlocCount = count ([["base","airfield","outpost","resource","factory","powerplant","seaport"],"AAF"] call AS_location_fnc_TS);
private _AAFresAdj = _resourcesAAF / _AAFlocCount; //Consider this also as it affects units ammo and fuel

private _debug_prefix = "[AS] Debug AS_fnc_spendAAFmoney: ";
private _debug_message = format ["buying with %1", _resourcesAAF];
diag_log (_debug_prefix + _debug_message);

//First check if aaf has enough casualties to warrant a skill drop
//Assume all new recruits are skill 1 and has 50 soldiers per location

private _skillDropLimit = (_AAFlocCount*AS_AAFSoldierperLocRef) / ((_skillAAF - 1) max 0.1);
private _AAFskillDropKills = AS_P("AAFskillDropKills");

while {_AAFskillDropKills >= _skillDropLimit and {_skillAAF > 1}} do {
  _skillAAF = (_skillAAF - 1);
  _AAFskillDropKills = _AAFskillDropKills - _skillDropLimit;
  AS_Pset("skillAAF", _skillAAF);
  AS_Pset("AAFskillDropKills", _AAFskillDropKills);
  diag_log format ["[AS] Skilldrop: Skill dropped due to casualties. Skill now: %1 Casualty limit: %2 Casualties since last drop: %3", _skillAAF, _skillDropLimit, _AAFskillDropKills];

  [format [localize "STR_msg_AAFSkillDrop", ["AAF", "shortname"] call AS_fnc_getEntity], 10, "aafSkillDrop", false] spawn AS_fnc_globalMessage;

};

//////////////// try to restore cities ////////////////
if (_resourcesAAF > 5000 and {_AAFresAdj > 1000}) then {
	// todo: this only repairs cities. It should repair everything. TEST below, AAF should now only repair their own cities
	//private _destroyedCities = AS_P("destroyedLocations") arrayIntersect (call AS_location_fnc_cities);
 	private _destroyedCities = AS_P("destroyedLocations") arrayIntersect ([["powerplant","city","factory","resource"], "AAF"] call AS_location_fnc_TS);
	private _repaired = [];
	if (count _destroyedCities > 0) then {
		{
			private _destroyed = _x;
			if ((_resourcesAAF > 5000 and _AAFresAdj > 1000) and (not(_destroyed call AS_location_fnc_spawned))) then {
				_resourcesAAF = _resourcesAAF - 5000;
        _AAFresAdj = _resourcesAAF / _AAFlocCount;
				_repaired pushBack _destroyed;
				private _type = _destroyed call AS_location_fnc_type;
				private _position = _destroyed call AS_location_fnc_position;
				private _nombre = [_destroyed] call AS_fnc_location_name;
				[10,0,_position] remoteExec ["AS_fnc_changeCitySupport",2];
				if (_type == "city") then {[40,0,_position] call AS_fnc_changeCitySupport;};
				[-5,0] call AS_fnc_changeForeignSupport;
				if (_type == "powerplant") then {[_destroyed] call AS_fnc_recomputePowerGrid};
        ["TaskFailed", ["", format ["%1 rebuilt by %2",_nombre, (["AAF", "shortname"] call AS_fnc_getEntity)]]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];
			};
		} forEach _destroyedCities;
		AS_Pset("destroyedLocations", _destroyedCities - _repaired);
	} else {
		private _fnc_isNotRepairing = {count ("repair_antenna" call AS_mission_fnc_active_missions) == 0};
		if (call _fnc_isnotRepairing) then {
			// try to rebuild one antenna.
			{
				private _location = _x call AS_location_fnc_nearest;
				if ((_resourcesAAF > 5000 and _AAFresAdj > 1000) and
				    {_location call AS_location_fnc_side == "AAF"} and
					{!(_location call AS_location_fnc_spawned)} and
					_fnc_isnotRepairing) exitWith {
						_resourcesAAF = _resourcesAAF - 5000;
            _AAFresAdj = _resourcesAAF / _AAFlocCount;
						private _mission = ["repair_antenna", _location] call AS_mission_fnc_add;
						_mission call AS_mission_fnc_activate;
				};
			} forEach AS_P("antenasPos_dead");
		};
	};
};

//////////////// try to expand arsenal ////////////////

// extra conditions to avoid AAF being too strong.
// Categories without condition always buy if given enough money
private _FIAcontrolledLocations = count (
	[["outpost", "factory", "powerplant", "resource", "airfield", "base", "city"], "FIA"] call AS_location_fnc_TS);
private _FIAcontrolledBases = count (
	[["airfield", "base"], "FIA"] call AS_location_fnc_TS);

private _extra_conditions = createSimpleObject ["Static", [0, 0, 0]];
_extra_conditions setVariable ["helis_transport", _FIAcontrolledLocations >= 1];
_extra_conditions setVariable ["tanks", _FIAcontrolledLocations >= 3 or _FIAcontrolledBases >= 1];
_extra_conditions setVariable ["helis_armed", _FIAcontrolledLocations >= 3 or _FIAcontrolledBases >= 1];
_extra_conditions setVariable ["planes", _FIAcontrolledBases >= 1];

{
	private _debug_bought_count = 0;
	private _cost = _x call AS_AAFarsenal_fnc_cost;
	private _extra_condition = _extra_conditions getvariable [_x,true];

	while {_extra_condition and {_x call AS_AAFarsenal_fnc_canAdd} and {_resourcesAAF > _cost and _AAFresAdj > 1000}} do {
		_x call AS_AAFarsenal_fnc_addVehicle;
		_resourcesAAF = _resourcesAAF - _cost;
    _AAFresAdj = _resourcesAAF / _AAFlocCount;
		_debug_bought_count = _debug_bought_count + 1;
	};

	_debug_message = format ["bought %1 '%2' (%3,%4), remaining money: %5",
			_debug_bought_count, _x, _x call AS_AAFarsenal_fnc_canAdd, _extra_condition, _resourcesAAF];
	diag_log (_debug_prefix + _debug_message);
} forEach AS_AAFarsenal_buying_order;

deleteVehicle _extra_conditions;

//////////////// try to upgrade skills ////////////////
private _skillFIA = AS_P("skillFIA");
if ((_skillAAF < (_skillFIA + 4)) && (_skillAAF < AS_maxSkill)) then {
	private _coste = 1000 + (1.5*(_skillAAF *750)*(_AAFlocCount/AS_AAFlocCountRef)); //AAF location count resembels amount of soldiers thus the universal cost to train them
	if (_coste < _resourcesAAF and {_AAFresAdj > 1000}) then {
        AS_Pset("skillAAF", _skillAAF + 1);
        _skillAAF = _skillAAF + 1;
		_resourcesAAF = _resourcesAAF - _coste;
    _AAFresAdj = _resourcesAAF / _AAFlocCount;
	};
};

//////////////// try to build a minefield ////////////////
if (_resourcesAAF > 2000 and {_AAFresAdj > 1000} and {count (["minefield","AAF"] call AS_location_fnc_TS) < 3}) then {
	private _minefieldDeployed = call AS_fnc_deployAAFminefield;
	if (_minefieldDeployed) then {
    _resourcesAAF = _resourcesAAF - 2000;
    private _debug_message = "AAF minefield deployed";
    diag_log (_debug_prefix + _debug_message);
  };
};
AS_Pset("resourcesAAF",round _resourcesAAF);

AS_resourcesIsChanging = nil;
