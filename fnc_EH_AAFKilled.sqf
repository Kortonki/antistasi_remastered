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

if ((side _killer == ("FIA" call AS_fnc_getFactionSide)) || (captive _killer)) then {
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

	{
		if (alive _x) then {
			if (fleeing _x) then {
				if !(_x getVariable ["surrendered",false]) then {
					if (([200, _x, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance) and
							{_coeffSurrConstant + (random ({alive _x and {!([_x] call AS_fnc_isDog) and {!(_x getVariable ["surrendered", false])}}} count units _group))*(_x skill "courage")*_coeffSurr < count ([50, _x, "BLUFORSpawn"] call AS_fnc_unitsAtDistance)})
							then {
								[_x] spawn AS_AI_fnc_surrender;
							} else {
								[_x,_x] spawn AS_AI_fnc_smokeCover;
							};
				};
			} else {
				if (random 1 < 0.5) then {_x allowFleeing (0.5 -(_x skill "courage") + (({(!alive _x) or (_x getVariable ["surrendered",false]) or ([_x] call AS_fnc_isDog)} count units _group)/(count units _group)))};
			};

			if (_x == leader group _x and {!([_x] call AS_fnc_isDog)}) then {
				if (random 1 < 0.5) then { //This was increased from 0.1 to 0.5 and moved to be used if AAF unit killed, doesn't require fleeing
					_enemy = _x findNearestEnemy _x;
					if (!isNull _enemy) then {
						diag_log format ["AS: AAF taking casualties, sending patrol to: %1", position _enemy];
						[[position _enemy], "AS_movement_fnc_sendAAFpatrol"] remoteExec ["AS_scheduler_fnc_execute", 2];
					};
				};
			};

			if (count (magazines _x) < 1 and {count ([50, _x, "BLUFORSpawn"] call AS_fnc_unitsAtDistance) > 0}) then {[_x] spawn AS_AI_fnc_surrender;};
		};
	} forEach units _group;
};
