private ["_killed","_killer","_cost","_enemy", "_group"];
_killed = _this select 0;
_killer = _this select 1;
_group = group _killed;

//ACE might make the killed eventhandler fire twice. Prevent it.
if (!(isnil{_killed getVariable "k"})) exitWith {
	diag_log format ["[AS] EH_AAFKilled: Killed eventhandler fired twice. Killed %1", _killed];
};
_killed setVariable ["k", true, false];

if (_killed getVariable ["OPFORSpawn",false]) then {_killed setVariable ["OPFORSpawn",nil,true]};
_unit removeAllEventHandlers "HandleDamage";


	//This to be able to recover weapons if it dies inside a vhicle
	private _vehicle = vehicle _killed;
	if (_vehicle != _killed and {!(_vehicle isKindOf "StaticWeapon")}) then {
		([_killed, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magazineRemains"];
		[_vehicle, _cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_populateBox;
		[_vehicle, _magazineRemains] call AS_fnc_addMagazineRemains;
  	_killed call AS_fnc_emptyUnit;
	};


[_killed] remoteExec ["AS_fnc_activateCleanup",2];

if (hasACE) then {
	if ((isNull _killer) || (_killer == _killed)) then {
		_killer = _killed getVariable ["ace_medical_lastDamageSource", _killer];
	};
};

//NATO killing AAF triggers CSAT attacks, save the date for the record
if (_killer call AS_fnc_getSide == "NATO" and {isNil{["NATO_killAAF_date"] call AS_stats_fnc_get}}) then {
	["NATO_killAAF_date", date] call AS_stats_fnc_set;
};

if ((side _killer == ("FIA" call AS_fnc_getFactionSide)) || (captive _killer)) then { //Investigate if this triggers for civilians
	["kill"] remoteExec ["fnc_BE_XP", 2];

	// if dead has no weapons, it is an unlawful kill
	if ((vehicle _killed == _killed) and {count weapons _killed < 1}) then { //if manning a driver/commander, non-weapon position, do not penalize
		[-1,0] remoteExec ["AS_fnc_changeForeignSupport",2];
		[1,-1,getPos _killed, true] remoteExec ["AS_fnc_changeCitySupport",2];
		//Stats
		if (isPlayer _killer) then {
			[_killer, "score", -20, false] remoteExec ["AS_players_fnc_change", 2];
			[_killer, "unarmedKills", 1] call AS_players_fnc_change;
		};
	} else {
		// otherwise, it decreases by -0.5.
		_cost = (typeOf _killed) call AS_fnc_getCost;
		[-_cost] remoteExec ["AS_fnc_changeAAFmoney",2];
		[-0.5,0,getPos _killed] remoteExec ["AS_fnc_changeCitySupport",2];

		//Stats
		["AAF", 1, "casualties"] remoteExec ["AS_stats_fnc_change", 2];

		if (isPlayer _killer) then {
			[_killer, "score", 2, false] remoteExec ["AS_players_fnc_change", 2];
			[_killer, "kills", 1] call AS_players_fnc_change;
		};
	};




	// surrender and fleeing updates.

	//Bigger values = less chance for surrender






	//TODO Figure a way to increase surrender probability when squadmates surrender
	//TODO optimise by declaring a variable for the group and group count
	//TODO Consider if this needed only for the leader (optimization, makes sense ?)
	private _units = units _group;
	{
		if (alive _x) then {
			//OPTIMISATION: following checks can be done unscheduled so spawn. Lag has been when vehicles full of soldiers have been killed:
			[_x, _group, _units] spawn {
				params ["_unit", "_group", "_units"];

				if (fleeing _unit) then {
					if !(_unit getVariable ["surrendered",false]) then {

						private _coeffSurr = 7; //TODO experiment this: 4 is in the ballpark for 1 vs 1 surrender inside 50 meters and 0.5 courage => 50% chance for surrendering. samaller the less chance for surrender
						private _coeffSurrConstant = -1; //TODO experiment this. Setting this to 1 and 1 vs 1 never surrenders, but 1 vs 2 has 50% chance if coeffSurr = 4

						if (([200, _unit, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance) and
								{_coeffSurrConstant + _coeffSurr*(random ({alive _unit and {!([_unit] call AS_fnc_isDog) and {!(_unit getVariable ["surrendered", false])}}} count _units))*(_unit skill "courage") < count ([50, _unit, "BLUFORSpawn"] call AS_fnc_unitsAtDistance)})
								then {
									if (_unit == leader _group) then {
										{[_unit] spawn AS_AI_fnc_surrender} foreach (_units select {!(_unit getVariable ["surrendered", false])}); 	//If squad leader surrenders, everybody in the group surrender as well
									} else {
										[_unit] spawn AS_AI_fnc_surrender;
									};

								} else {
									[_unit,_unit] spawn AS_AI_fnc_smokeCover;
								};
					};
				} else {
					if (random 1 < 0.5) then {_unit allowFleeing (0.5 -(_unit skill "courage") + (({(!alive _unit) or (_unit getVariable ["surrendered",false]) or ([_unit] call AS_fnc_isDog)} count _units)/(count _units)))};
				};

				if (_unit == leader group _unit and {!([_unit] call AS_fnc_isDog) and {(position _unit) call AS_fnc_hasRadioCoverage}}) then {
					if (random 1 < 0.5) then { //This was increased from 0.1 to 0.5 and moved to be used if AAF unit killed, doesn't require fleeing
						_enemy = _unit findNearestEnemy _unit;
						if (!isNull _enemy) then {
							([_unit] call AS_fnc_getContactThreat) params ["_threatEval_Land", "_threatEval_Air"];
							private _position = position _enemy;
							diag_log format ["AS: AAF taking casualties, sending patrol to: %1 ThreatEval Land/Air %2 / %3", _position, _threatEval_Land, _threatEval_Air];
							[_position,"", _threatEval_Land, _threatEval_Air] remoteExec ["AS_movement_fnc_sendAAFpatrol", 2];
							private _threat = _threatEval_Land + _threatEval_Air;
							//Consider vehicle availabilty so AAF doesn't throw it's last vehicles into enemy //TODO prolly needs BALANCING
							private _arsenalCount = ["cars_armed", "apcs", "tanks", "helis_transport", "helis_armed", "planes"] call AS_AAFarsenal_fnc_countAvailable;
							if (_threat > ((random 20) - (_arsenalCount/20))) then {
								//Bases first if one's close enough
								private _origin = [_position] call AS_fnc_getBasesForCA;

								if (_origin == "") then {
									_origin = [_position] call AS_fnc_getAirportsForCA;
								} else {
									if ((_origin call AS_location_fnc_position) distance2D _position > 3000 or _threatEval_Land > (_threatEval_Air + random 10)) then {
										_origin = [_position] call AS_fnc_getAirportsForCA;
									};
								};

								if (_origin != "") then {
									private _size = "small";
									private _type = "random";
									if (random 20 < _threat) then {_size = "large"};
									if (random 20 < _threatEval_Land) then {_type = selectRandom ["destroy", "mixed"]};
									[_origin, _position, "", 30, _type, _size] remoteExec ["AS_movement_fnc_sendEnemyQRF", 2];
									diag_log format ["AS: AAF taking casualties, sending QRF to: %1 ThreatEval Land/Air %2 / %3, size: %4, type: %5 Origin: %6", _position, _threatEval_Land, _threatEval_Air, _size, _type, _origin];
								};


							};
						};
					};
				};

				if (count (magazines _unit) < 1) then {

					if (count ([100, _unit, "BLUFORSpawn"] call AS_fnc_unitsAtDistance) > 0) then {
						[_unit] spawn AS_AI_fnc_surrender;
					}	else {
						_unit allowFleeing 1;
					};

				};
			};
		};
	} forEach _units;
};
