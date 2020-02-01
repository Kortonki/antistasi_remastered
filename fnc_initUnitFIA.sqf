#include "macros.hpp"
params ["_unit", ["_spawned", true], ["_place", nil], ["_equipment", []]];

if(!(local _unit)) exitWith {
	if (isNil "_place") then {
		diag_log format ["[AS] Error: InitUnitFIA run where the unit is not local. InitUnitFIA remoteExec'd where it's local. Time: %1, Unit: %2 Spawned: %3 place nil Equipment %3", time, _unit, _spawned, _equipment];
	} else {
		diag_log format ["[AS] Error: InitUnitFIA run where the unit is not local. InitUnitFIA remoteExec'd where it's local. Time: %1, Unit: %2 Spawned: %3 place % 4 Equipment %4", time, _unit, _spawned, _place, _equipment];
	};
	[_unit, _spawned, _place, _equipment] remoteExec ["AS_fnc_initUnitFIA", _unit];

};

_unit removeAllEventHandlers "killed"; //This effects mainly prisoners/refugees, AAF don't get unarmed killing penalty anymore

[_unit, "FIA"] call AS_fnc_setSide;

[_unit] call AS_debug_fnc_initUnit;

if (_spawned) then {
	_unit setVariable ["BLUFORSpawn",true,true];
} else {
	if (!isNil "_place") then {_unit setVariable ["marcador", _place, true]};
};

_unit addEventHandler ["HandleDamage", AS_fnc_EH_handleDamage_AIcontrol];
[_unit] call AS_medical_fnc_initUnit;


[_unit, AS_P("skillFIA")] call AS_fnc_setDefaultSkill;


if (count _equipment == 0) then {
    _equipment = [[_unit] call AS_fnc_getFIAUnitType] call AS_fnc_getBestEquipment;
};

//Warn if no launchers for squad members

if (([_unit] call AS_fnc_getFIAUnitType) in ["AT Specialist", "AA Specialist"] and {_equipment select 6 == ""}) then {

	[player, "hint", "No proper launcher for squad launcher specialist. He proceeds without one."] remoteExec ["AS_fnc_localCommunication", player];
	};

//Fallback if unit still has no weapon

if ((_equipment select 4 == "") and {([_unit] call AS_fnc_getFIAUnitType) != "Survivor"}) then {
	(call AS_fnc_unlockedCargoList) params ["_unlockedCargoWeapons", "_unlockedCargoMagazines"];
	if (not(isNil {(_unlockedCargoWeapons select 0) select 0})) then {_equipment set [4,((_unlockedCargoWeapons select 0) select 0)];};
	_equipment set [5,([caja, (_equipment select 4), 10] call AS_fnc_getBestMagazines)];

	[player, "hint", "No proper weapons available for a squad member. He armed himself with whatever there was."] remoteExec ["AS_fnc_localCommunication", player];
};

[_unit, _equipment] call AS_fnc_equipUnit;


//This is to recover cargo if unit dies inside vehicle
_unit addEventHandler ["killed", {
	params ["_unit"];
	private _vehicle = vehicle _unit;
	//_unit removeAllEventHandlers "HandleDamage"; //These are no longer needed //IMPORTANT: this also removes "killed" eventhNdlers!

		if (_vehicle != _unit and {!(_vehicle isKindOf "StaticWeapon")}) then {
			([_unit, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magazineRemains"];
			[_vehicle, _cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_populateBox;
			[_vehicle, _magazineRemains] call AS_fnc_addMagazineRemains;
	    _unit call AS_fnc_emptyUnit;
		};
	}];

_unit allowFleeing 0;	//Experminet with this: way to make garrison stay in area,or detect fleeing and do things like disband etc.

if (isPlayer(leader _unit)) then {
	if (captive player and {!(captive _unit)}) then {[_unit] remoteExec ["AS_fnc_activateUndercoverAI", _unit]};
	_unit addEventHandler ["killed", {
		params ["_unit", "_killer"];
		[_unit] remoteExec ["AS_fnc_activateCleanup",2];

		[0,-0.5,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
		_unit setVariable ["BLUFORSpawn",nil,true];

		//Stats
		if (isPlayer _killer) then {
			[_killer, "score", -20, false] remoteExec ["AS_players_fnc_change", 2];
			[_killer, "friendlyKills", 1] call AS_players_fnc_change;
		};

	}];

	_unit setVariable ["rearming",false];

	_unit addEventHandler ["GetInMan", {
		private ["_soldier","_veh"];
		_soldier = _this select 0;
		_veh = _this select 2;

		private _undercoverVehicles = (["CIV", "vehicles"] call AS_fnc_getEntity) + civHeli;
		if ((typeOf _veh) in _undercoverVehicles) then {
			if !(_veh in AS_S("reportedVehs")) then {

				//IF a non-undercover AI is seen to enter a vehicle, make it compromised

				private _detected = false;

				if (!(captive _soldier)) then {

					{
						if (!(side _x in [("FIA" call AS_fnc_getFactionSide), civilian]) and {(_x distance _soldier < 5) or ((_x knowsAbout _soldier > 1.4) and {_x distance _soldier < 500})}) exitWith {
								AS_Sset("reportedVehs", AS_S("reportedVehs") + [_veh]);
								_detected = true;
						};
					} forEach allUnits;
				};

				//if (!(_detected) and {!(captive _soldier)}) then {[_soldier] remoteExec ["AS_fnc_activateUndercoverAI", _soldier]}; //Probably unnecessary, activate player undercover already does this
			};
		};




	}];
} else {
	_unit addEventHandler ["killed", {
		params ["_unit", "_killer"];
		[_unit] remoteExec ["AS_fnc_activateCleanup",2];

		private _group = group _unit;

		//Stats
		// player team-kill
		if (isPlayer _killer) then {
			[_killer, "score", -20, false] remoteExec ["AS_players_fnc_change", 2];
			[_killer, "friendlyKills", 1] call AS_players_fnc_change;
		};
		[0,-0.5,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
		["death"] remoteExec ["fnc_be_XP", 2];

		if (_unit getVariable ["BLUFORSpawn",false]) then {
			_unit setVariable ["BLUFORSpawn",nil,true];
		};

		if (_group getVariable ["isHCgroup", false] and {{alive _x} count (units _group) < 1}) then {
			_group setVariable ["isHCgroup", false, true];
			deleteGroup _group;
		};

		private _location = _unit getVariable "marcador";
		if (!(isNil "_location")) then {
			if (_location call AS_location_fnc_side == "FIA") then {
				private _garrison = _location call AS_location_fnc_garrison;
				_garrison deleteAt (_garrison find (_unit call AS_fnc_getFIAUnitType));
				[_location, "garrison", _garrison, true] call AS_location_fnc_set;
			};
		};
	}];
};

_unit enableIRLasers true;
_unit enableGunLights "AUTO";


//Eventhandler to increase City support for healing CIVS
_unit addEventhandler ["handleHeal", {
		params ["_unit", "_healer", "_isMedic"];

		private _return = false; //Use normal heal if not healing a civilian
		if ((_unit call AS_fnc_getSide) isEqualTo "CIV") then {

				//Maximum support from healing single CIV = 1.5 < 2 (penalty of wounding a CIV)
				//Thus, no possibility to exploit
				private _support = 0;
				if (damage _unit > 0.25) then { //First aid via anybody heals some -> some support
					_support = _support + 0.5;
					_unit setdamage 0.25;
				};
				if (_isMedic) then { //Using medic gains more support
					_support = _support + 0.5;
					_unit setdamage 0;
				};
				if (_unit call AS_medical_fnc_isUnconscious) then {
					_support = _support + 0.5;
				};

				if (typeOf _unit == "C_Journalist_F") then {
					[0,_support*3, position _unit, true] remoteExec ["AS_fnc_changeCitySupport", 2];
					{[0, round(_support/2),_x] remoteExec ["AS_fnc_changeCitySupport", 2]} forEach (call AS_location_fnc_cities);
					[1, 0, getpos _unit] remoteExec ["AS_fnc_changeForeignSupport", 2];
				}
				else {
					[0,_support, position _unit, true] remoteExec ["AS_fnc_changeCitySupport", 2];
				};
				[_unit, _healer] spawn {
					params ["_unit", "_healer"];
					_unit stop true;
					_healer playActionNow "MedicOther";
					sleep 8;
					_unit stop false;
				};
			_return = true;
		};


		_return
	}];
