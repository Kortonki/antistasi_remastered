private ["_unit","_enemigos"];

_unit = _this select 0;

if(!(local _unit)) exitWith {
		diag_log format ["[AS] Error: InitUnitCIV run where the unit is not local. InitUnitCIV remoteExec'd where it's local. Time: %1, Unit: %2", time, _unit];
		[_unit] remoteExec ["AS_fnc_initUnitCIV", _unit];
};

[_unit, "CIV"] call AS_fnc_setSide;

[_unit] call AS_debug_fnc_initUnit;

[_unit] call AS_medical_fnc_initUnit;

_unit setSkill 0;

private _EHkilledIdx = _unit addEventHandler ["killed", {
	private _unit = _this select 0;
	private _killer = _this select 1;

	if (hasACE) then {
		if ((isNull _killer) || (_killer == _unit)) then {
			_killer = _unit getVariable ["ace_medical_lastDamageSource", _killer];
		};
	};

	if (_unit == _killer) then {
		[-1,-1,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
	} else {
		if (isPlayer _killer) then {
			[_killer, "score", -20] remoteExec ["AS_players_fnc_change", 2];
		};
		private _coeff = 1;
		if (typeOf _unit == "C_journalist_F") then {_coeff = 10};
		if (side _killer == ("FIA" call AS_fnc_getFactionSide)) then {
			[-1*_coeff,0] remoteExec ["AS_fnc_changeForeignSupport",2];
			[0,-5,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2]; //Civ killing penalties hardened
			//Journalist kills lower city support everywhere %5, civs not
			{[0,floor(-0.5*_coeff),_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
		} else {
			if (side _killer == ("AAF" call AS_fnc_getFactionSide)) then {
				[1*_coeff,0] remoteExec ["AS_fnc_changeForeignSupport",2];
				[-5,0,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2]; //Civ killing penalties hardened 1 -> 5%
				//Journalist kills lower city support everywhere 5%, civs not
				{[floor(-0.5*_coeff),0,_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
			};
		};
	};
	_unit removeAllEventHandlers "HandleDamage"; //these are no longer needed


}];

//TODO consider amount of damage to effect citysupport loss

if (typeOf _unit == "C_Journalist_F") then {
	 _unit addEventHandler ["handleDamage", {
		private _unit = _this select 0;
		private _source = _this select 3;

		if (diag_tickTime - (_unit getVariable ["hitTime", 0]) < 0.1) exitWith {}; //No duplicate activation

		_unit setVariable ["hitTime", diag_tickTime, false];

		[_unit, _source] spawn {
		params ["_unit", "_source"];
		sleep 1;

		if (!(alive _unit)) exitWith {}; //If unit was killed, then only kill penalty

			//Journalist INJURY penalties
			if (side _source == ("FIA" call AS_fnc_getFactionSide)) then {
					[0, -1, getpos _unit] remoteExec ["AS_fnc_changeForeignSupport", 2];
					{[0,-1,_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
					[0,-4,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
				} else {
					[0, 1, getpos _unit] remoteExec ["AS_fnc_changeForeignSupport", 2];
					{[-1, 0,_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
					[-4,0,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
				};
			};
		}];
	} else {
		_unit addEventHandler ["handleDamage", {
 		private _unit = _this select 0;
 		private _source = _this select 3;

 		if (diag_tickTime - (_unit getVariable ["hitTime", 0]) < 0.1) exitWith {}; //No duplicate activation

 		_unit setVariable ["hitTime", diag_tickTime, false];

		[_unit, _source] spawn {
			params ["_unit", "_source"];
			sleep 1;

			if (!(alive _unit)) exitWith {}; //If unit was killed, then only kill penalty
			//Civilian INJURY penalties
 			if (side _source == ("FIA" call AS_fnc_getFactionSide)) then {
					[0,-2,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
 			} else {
					[-2,0,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
 			};
		};
 	}];
};

//TODO handleheal to increase support of FIA heals civilians
