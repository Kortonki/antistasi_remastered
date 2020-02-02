#include "macros.hpp"

params ["_unit", ["_spawned", true]];

if(!(local _unit)) exitWith {
		diag_log format ["[AS] Error: InitUnitAAF run where the unit is not local. InitUnitAAF remoteExec'd where it's local. Time: %1, Unit: %2 Spawned: %3", time, _unit, _spawned];
		[_unit, _spawned] remoteExecCall ["AS_fnc_initUnitAAF", _unit];
};

if (!isNil{_unit getVariable "init"}) exitWith {diag_log format ["Unit %1 attempting to init but already initing", _unit]};

_unit setVariable ["init", true, false];

[_unit, "AAF"] call AS_fnc_setSide;

[_unit] call AS_debug_fnc_initUnit;

if (_unit call AS_fnc_isDog) exitWith {};

[_unit] call AS_medical_fnc_initUnit;
if (_spawned) then {
	_unit setVariable ["OPFORSpawn",true,true];
};

private _skillAAF = AS_P("skillAAF");
[_unit, _skillAAF] call AS_fnc_setDefaultSkill;

_unit call AS_fnc_removeNightEquipment;

if (SunOrMoon < 1) then {
	if ((floor random 100)/100 < _skillAAF/AS_maxSkill) then {
		_unit linkItem selectRandom (AS_allNVGs arrayIntersect AAFItems);
		_unit addPrimaryWeaponItem selectRandom (AS_allLasers arrayIntersect AAFItems);
	} else {
		_unit addPrimaryWeaponItem selectRandom (AS_allFlashlights arrayIntersect AAFItems);
	};
};

_unit addEventHandler ["killed", AS_fnc_EH_AAFKilled];

_unit enableIRLasers true;
_unit enableGunLights "AUTO";

/*private _AAFres = AS_P("resourcesAAF");
private _AAFlocCount = count ([["base","airfield","outpost","outpostAA","resource","factory","powerplant","seaport"],"AAF"] call AS_location_fnc_TS);
private _AAFresAdj = _AAFres / _AAFlocCount;*/ //Replaced with external cfgFunction

private _AAFresAdj = [] call AS_fnc_getAAFresourcesAdj;

private _max = (0.8*(_AAFresAdj / 1000)) min 0.8;
_unit setVehicleAmmo (0.2 + _max);
