params ["_unit", ["_spawned", true]];

if(!(local _unit)) exitWith {
		diag_log format ["[AS] Error: InitUnitCSAT run where the unit is not local. InitUnitCSAT remoteExec'd where it's local. Time: %1, Unit: %2", time, _unit];
		[_unit] remoteExec ["AS_fnc_initUnitCSAT", _unit];
};

if (!isNil{_unit getVariable "init"}) exitWith {diag_log format ["Unit %1 attempting to init but already initing", _unit]};

_unit setVariable ["init", true, false];

if (_spawned) then {
	_unit setVariable ["OPFORSpawn",true,true];
};

[_unit, "CSAT"] call AS_fnc_setSide;

[_unit] call AS_debug_fnc_initUnit;

[_unit] call AS_medical_fnc_initUnit;

[_unit] call AS_fnc_setDefaultSkill;

if (SunOrMoon > 1) then {
	_unit call AS_fnc_removeNightEquipment;
};

_unit addEventHandler ["killed",AS_fnc_EH_CSATKilled];

_unit enableIRLasers true;
_unit enableGunLights "AUTO";
