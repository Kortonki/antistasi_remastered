private ["_killed","_killer","_cost","_enemy","_group"];
_killed = _this select 0;
_killer = _this select 1;
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

if ((side _killer == ("FIA" call AS_fnc_getFactionSide)) || (captive _killer)) then { //Investigate if this triggers for civilians
	["kill"] remoteExec ["fnc_BE_XP", 2];
	_group = group _killed;

	// if dead has no weapons, it is an unlawful kill
	if ((vehicle _killed == _killed) and {count weapons _killed < 1}) then { //if manning a driver/commander, non-weapon position, do not penalize
		[-1,0] remoteExec ["AS_fnc_changeForeignSupport",2];
		[1,-1,getPos _killed] remoteExec ["AS_fnc_changeCitySupport",2];
		if (isPlayer _killer) then {
			[_killer, "score", -20, false] remoteExec ["AS_players_fnc_change", 2];
		};
	} else {
		// otherwise, it decreases by -0.5.
		_cost = (typeOf _killed) call AS_fnc_getCost;
		[-_cost] remoteExec ["AS_fnc_changeAAFmoney",2];
		[-0.5,0,getPos _killed] remoteExec ["AS_fnc_changeCitySupport",2];
		if (isPlayer _killer) then {
			[_killer, "score", 2, false] remoteExec ["AS_players_fnc_change", 2];
		};
	};



	// surrender and fleeing updates.

	//Bigger values = less chance for surrender



	private _coeffSurr = 8; //TODO experiment this: 4 is in the ballpark for 1 vs 1 surrender inside 50 meters and 0.5 courage => 50% chance for surrendering
	private _coeffSurrConstant = -0.7; //TODO experiment this. Setting this to 1 and 1 vs 1 never surrenders, but 1 vs 2 has 50% chance if coeffSurr = 4


	//TODO Figure a way to increase surrender probability when squadmates surrender
	//TODO optimise by declaring a variable for the group and group count
	{
		if (alive _x) then {
			if (fleeing _x) then {
				if !(_x getVariable ["surrendered",false]) then {
					if (([200, _x, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance) and
							{_coeffSurrConstant + _coeffSurr*(random ({alive _x and {!([_x] call AS_fnc_isDog) and {!(_x getVariable ["surrendered", false])}}} count units _group))*(_x skill "courage") < count ([50, _x, "BLUFORSpawn"] call AS_fnc_unitsAtDistance)})
							then {
								if (_x == leader group _x) then {
									{[_x] spawn AS_AI_fnc_surrender} foreach (units group _x); 	//If squad leader surrenders, everybody in the group surrender as well
								} else {
									[_x] spawn AS_AI_fnc_surrender;
								};

							} else {
								[_x,_x] spawn AS_AI_fnc_smokeCover;
							};
				};
			} else {
				if (random 1 < 0.5) then {_x allowFleeing (0.5 -(_x skill "courage") + (({(!alive _x) or (_x getVariable ["surrendered",false]) or ([_x] call AS_fnc_isDog)} count units _group)/(count units _group)))};
			};

			if (_x == leader group _x and {!([_x] call AS_fnc_isDog) and {(position _x) call AS_fnc_hasRadioCoverage}}) then {
				if (random 1 < 0.5) then { //This was increased from 0.1 to 0.5 and moved to be used if AAF unit killed, doesn't require fleeing
					_enemy = _x findNearestEnemy _x;
					if (!isNull _enemy) then {
						([_x] call AS_fnc_getContactThreat) params ["_threatEval_Land", "_threatEval_Air"];
						private _position = position _enemy;
						diag_log format ["AS: AAF taking casualties, sending patrol to: %1 ThreatEval Land/Air %2 / %3", _position, _threatEval_Land, _threatEval_Air];
						[_position,"", _threatEval_Land, _threatEval_Air] remoteExec ["AS_movement_fnc_sendAAFpatrol", 2];
						if (_threatEval_Land + _threatEval_Air > random 30) then {

							//Bases first if one's close enough
							private _origin = [_position] call AS_fnc_getBasesForCA;
							private _threat = _threatEval_Land + _threatEval_Air;
							if (_origin == "") then {
								_origin = [_position] call AS_fnc_getAirportsForCA;
							} else {
								if ((_origin call AS_location_fnc_position) distance2D _position > 3000 or _threatEval_Land > (_threatEval_Air + random 5)) then {
									_origin = [_position] call AS_fnc_getAirportsForCA;
								};
							};

							if (_origin != "") then {
								private _size = "small";
								private _type = "random";
								if (random 30 < _threat) then {_size = "large"};
								if (random 20 < _threatEval_Land) then {_type = selectRandom ["destroy", "mixed"]};
								[_origin, _position, "", 30, _type, _size] remoteExec ["AS_movement_fnc_sendEnemyQRF", 2];
								diag_log format ["AS: AAF taking casualties, sending QRF to: %1 ThreatEval Land/Air %2 / %3, size: %4, type: %5 Origin: %6", _position, _threatEval_Land, _threatEval_Air, _size, _type, _origin];
							};


						};
					};
				};
			};

			if (count (magazines _x) < 1) then {

				if (count ([50, _x, "BLUFORSpawn"] call AS_fnc_unitsAtDistance) > 0) then {
					[_x] spawn AS_AI_fnc_surrender;
				}	else {
					_x allowFleeing 1;
				};

			};
		};
	} forEach units _group;
};
