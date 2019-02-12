params ["_unit"];

if(!(local _unit)) exitWith {
		diag_log format ["[AS] Error: InitUnitNATO run where the unit is not local. InitUnitNATO remoteExec'd where it's local. Time: %1, Unit: %2", time, _unit];
		[_unit] remoteExec ["AS_fnc_initUnitNATO", _unit];
};

[_unit, "NATO"] call AS_fnc_setSide;

[_unit] call AS_debug_fnc_initUnit;

[_unit] call AS_medical_fnc_initUnit;
_unit allowFleeing 0;

[_unit] call AS_fnc_setDefaultSkill;

_unit setVariable ["BLUFORSpawn",true,true];

_unit addEventHandler ["killed", {
	private _unit = _this select 0;
	[0.25,0,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
	[_unit] remoteExec ["AS_fnc_activateCleanup",2];
	_unit removeAllEventHandlers "HandleDamage";

	private _vehicle = vehicle _unit;
	if (_vehicle != _unit and {!(_vehicle isKindOf "StaticWeapon")}) then {
		([_unit, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magazineRemains"];
		[_vehicle, _cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_populateBox;
		[_vehicle, _magazineRemains] call AS_fnc_addMagazineRemains;
		_unit call AS_fnc_emptyUnit;
	};



}];

if (sunOrMoon > 1) then {
	_unit call AS_fnc_removeNightEquipment;
};

_unit enableIRLasers true;
_unit enableGunLights "AUTO";
