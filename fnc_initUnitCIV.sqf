params ["_unit",["_location", ""]];

if(!(local _unit)) exitWith {
		diag_log format ["[AS] Error: InitUnitCIV run where the unit is not local. InitUnitCIV remoteExec'd where it's local. Time: %1, Unit: %2", time, _unit];
		[_unit, _location] remoteExec ["AS_fnc_initUnitCIV", _unit];
};

if (!isNil{_unit getVariable "init"}) exitWith {diag_log format ["Unit %1 attempting to init but already initing", _unit]};

_unit setVariable ["init", true, false];


[_unit, "CIV"] call AS_fnc_setSide;

[_unit] call AS_debug_fnc_initUnit;

[_unit] call AS_medical_fnc_initUnit;

_unit setSkill 0;

_unit setVariable ["location", _location, true];

private _EHkilledIdx = _unit addEventHandler ["killed", {
	private _unit = _this select 0;
	private _killer = _this select 1;

	//ACE might make the killed eventhandler fire twice. Prevent it.
	if (!(isnil{_unit getVariable "k"})) exitWith {
		diag_log format ["[AS] InitUnitCIV: Killed eventhandler fired twice. Killed %1", _unit];
	};
	_unit setVariable ["k", true, false];

	if (hasACE) then {
		if ((isNull _killer) || (_killer == _unit)) then {
			_killer = _unit getVariable ["ace_medical_lastDamageSource", _killer];
		};
	};

	//Decrease population
	private _location = _unit getvariable ["location", ""];
	if (_location != "") then {
		[_location, "population", (([_location, "population"] call AS_location_fnc_get) - 1) max 0] call AS_location_fnc_set;
	};

	if (_unit == _killer) then {
		[-1,-1,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
	} else {

		private _coeff = 1;
		if (typeOf _unit == "C_journalist_F") then {
			_coeff = 10;
			[_killer call AS_fnc_getSide, 1, "journalistKills"] remoteExec ["AS_stats_fnc_change", 2];




		};
		private _sideKiller = side _killer;

		if (_killer call AS_fnc_getSide in ["AAF", "NATO", "CSAT", "FIA"]) then {
			[_killer call AS_fnc_getSide, 1, "civKills"] remoteExec ["AS_stats_fnc_change", 2];
		};

		if (_killer call AS_fnc_getSide in ["NATO", "FIA"]) then {
			[-1*_coeff,0] remoteExec ["AS_fnc_changeForeignSupport",2];
			[0,-5,getPos _unit, true] remoteExec ["AS_fnc_changeCitySupport",2]; //Civ killing penalties hardened
			//Journalist kills lower city support everywhere %5, civs not
			{[0,floor(-0.5*_coeff),_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);

			if (isPlayer _killer) then {

					if (typeOf _unit == "C_journalist_F") then {
						[_killer, "score", -40] remoteExec ["AS_players_fnc_change", 2];
						[_killer, "journalistKills", 1] remoteExec ["AS_players_fnc_change", 2];
					} else {
						[_killer, "score", -20] remoteExec ["AS_players_fnc_change", 2];
						[_killer, "civKills", 1] remoteExec ["AS_players_fnc_change", 2];
					};
			};

			//Global message reporting

			if (typeOf _unit == "C_journalist_F") then {
			private _msg = format [localize "STR_msg_FIA_killsReporter",

			worldName,
			["FIA", "shortname"] call AS_fnc_getEntity,
			["NATO", "shortname"] call AS_fnc_getEntity
			];

			[_msg, 10, "reporterKilledFIA", true] remoteExec ["AS_fnc_globalMessage", 2];

		};

		} else {
			if (_killer call AS_fnc_getSide in ["AAF", "CSAT"]) then {
				[1*_coeff,0] remoteExec ["AS_fnc_changeForeignSupport",2];
				[-5,0,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2]; //Civ killing penalties hardened 1 -> 5%
				//Journalist kills lower city support everywhere 5%, civs not
				{[floor(-0.5*_coeff),0,_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);

				//Global message reporting

				if (typeOf _unit == "C_journalist_F") then {

					private _msg = format [localize "STR_msg_AAF_killsReporter",

					worldName,
			    ["AAF", "shortname"] call AS_fnc_getEntity,
			    ["NATO", "shortname"] call AS_fnc_getEntity,
					["FIA", "shortname"] call AS_fnc_getEntity
			    ];

					[_msg, 10, "reporterKilledAAF", true] remoteExec ["AS_fnc_globalMessage", 2];
				};
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
		sleep 5;

		if (!(alive _unit)) exitWith {}; //If unit was killed, then only kill penalty

			//Journalist INJURY penalties
			if (_source call AS_fnc_getSide in ["NATO", "FIA"]) then {
					[0, -1, getpos _unit, true] remoteExec ["AS_fnc_changeForeignSupport", 2];
					{[0,-1,_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
					[0,-4,getPos _unit, true] remoteExec ["AS_fnc_changeCitySupport",2];
				};
			if (_source call AS_fnc_getSide in ["AAF", "CSAT"]) then {
					[0, 1, getpos _unit, true] remoteExec ["AS_fnc_changeForeignSupport", 2];
					{[-1, 0,_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
					[-4,0,getPos _unit, true] remoteExec ["AS_fnc_changeCitySupport",2];
				};
			};
		}];
	} else {
		_unit addEventHandler ["handleDamage", {
 		private _unit = _this select 0;
 		private _source = _this select 3;

 		if (_source == _unit or {diag_tickTime - (_unit getVariable ["hitTime", 0]) < 0.1}) exitWith {}; //No duplicate activation

 		_unit setVariable ["hitTime", diag_tickTime, false];

		[_unit, _source] spawn {
			params ["_unit", "_source"];
			sleep 5;

			if (!(alive _unit)) exitWith {}; //If unit was killed, then only kill penalty
			//Civilian INJURY penalties
 			if (_source call AS_fnc_getSide in ["NATO", "FIA"]) then {
					[0,-2,getPos _unit, true] remoteExec ["AS_fnc_changeCitySupport",2];
 			};
			if (_source call AS_fnc_getSide in ["AAF", "CSAT"]) then {
					[-2,0,getPos _unit, true] remoteExec ["AS_fnc_changeCitySupport",2];
 			};
		};
 	}];
};
