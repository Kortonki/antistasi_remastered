private ["_unit","_enemigos"];

_unit = _this select 0;

if(!(local _unit)) exitWith {
		diag_log format ["[AS] Error: InitUnitCIV run where the unit is not local. InitUnitCIV remoteExec'd where it's local. Time: %1, Unit: %2", time, _unit];
		[_unit] remoteExec ["AS_fnc_initUnitCIV", _unit];
};

[_unit, "CIV"] call AS_fnc_setSide;

[_unit] call AS_debug_fnc_initUnit;

_unit setSkill 0;

_EHkilledIdx = _unit addEventHandler ["killed", {
	private _muerto = _this select 0;
	private _killer = _this select 1;

	if (hasACE) then {
		if ((isNull _killer) || (_killer == _muerto)) then {
			_killer = _muerto getVariable ["ace_medical_lastDamageSource", _killer];
		};
	};

	if (_muerto == _killer) then {
		[-1,-1,getPos _muerto] remoteExec ["AS_fnc_changeCitySupport",2];
	} else {
		if (isPlayer _killer) then {
			[_killer, "score", -20] remoteExec ["AS_players_fnc_change", 2];
		};
		_multiplicador = 1;
		if (typeOf _muerto == "C_journalist_F") then {_multiplicador = 10};
		if (side _killer == ("FIA" call AS_fnc_getFactionSide)) then {
			[-1*_multiplicador,0] remoteExec ["AS_fnc_changeForeignSupport",2];
			[0,-5,getPos _muerto] remoteExec ["AS_fnc_changeCitySupport",2]; //Civ killing penalties hardened
		} else {
			if (side _killer == ("AAF" call AS_fnc_getFactionSide)) then {
				[1*_multiplicador,0] remoteExec ["AS_fnc_changeForeignSupport",2];
				[-5,0,getPos _muerto] remoteExec ["AS_fnc_changeCitySupport",2]; //Civ killing penalties hardened 1 -> 5%
			};
		};
	};
}];
