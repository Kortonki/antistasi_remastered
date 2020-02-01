#include "macros.hpp"
waitUntil {sleep 0.1; !isNull player};
waitUntil {sleep 0.1; player == player};



if hasACEhearing then {player addItem "ACE_EarPlugs"};

[player, "FIA"] call AS_fnc_setSide;

player addEventHandler ["HandleDamage", AS_fnc_EH_handleDamage_AIcontrol];
player call AS_medical_fnc_initUnit;

player call AS_fnc_initPlayerPosition;

//Take command of HC groups again as commander
//EXPERIMENT no HC fiddling

if (player == AS_commander) then {

//EXPERIMENT not fiddling with syncing
	AS_commander synchronizeObjectsAdd [HC_comandante];
	HC_comandante synchronizeObjectsAdd [AS_commander];

	//[HC_comandante] execVM '\A3\modules_f\HC\data\scripts\hc.sqf';

	{
			//player hcSetGroup [_x];
			[player, [_x]] remoteExec ["hcSetGroup", 0];
	} foreach (allGroups select {(_x getVariable ["isHCgroup", false])});
};

if (!(hasACE)) then {
	[player,"repackMagazines"] call AS_fnc_addAction;
};

player addEventHandler ["WeaponAssembled", {
	params ["_EHunit", "_EHobj"];
	if (_EHobj isKindOf "StaticWeapon") then {
		if !(_EHobj in AS_P("vehicles")) then {
            [_EHobj] remoteExec ["AS_fnc_changePersistentVehicles", 2];
		};
	};
    [_EHobj, "FIA"] call AS_fnc_initVehicle;
}];

//Any reason why the backpacks need an init? More important worry is that former static get removed from persistents
/*player addEventHandler ["WeaponDisassembled", {
    [_this select 1, "FIA"] call AS_fnc_initVehicle;
	[_this select 2, "FIA"] call AS_fnc_initVehicle;
}];*/

/*
if (isMultiplayer) then {
    player addEventHandler ["Fired", {
		private _tipo = _this select 1;
		if ((_tipo == "Put") or (_tipo == "Throw")) then {
			if (player distance petros < 50) then {
				deleteVehicle (_this select 6);
				if (_tipo == "Put") then {
					if (player distance petros < 10) then {[player,60] spawn AS_fnc_penalizePlayer};
				};
			};
		};
	}];
};

*/

player addEventHandler ["GetInMan", {
    params ["_unit", "_seat", "_vehicle"];
	private _exit = false;
	//TODO: This is commented oout until there's a way to unlock dead group leaders vehicles after the group breaks
	/*if isMultiplayer then {
		private _owner = _vehicle getVariable "AS_vehOwner";


		if (!isNil "_owner" and
            {{getPlayerUID _x == _owner} count (units group player) == 0}) then {
			hint "You can only enter in other's vehicle if you are in its group";
			moveOut _unit;
			_exit = true;
		};
	};*/
	if not _exit then {

		private _detected = false;
		{
			if (!(side _x in [("FIA" call AS_fnc_getFactionSide), civilian]) and {(_x distance _player < 5) or ((_x knowsAbout (vehicle _player) > 1.4) and {_x distance _player < 500})}) exitWith {
				_detected = true;
			};
		} forEach allUnits;

		//Detected player seen entering a vehicle -> vehicle to wanted list

		if (!(_detected)) then {
				//[true] spawn AS_fnc_activateUndercover; //Let's try to only UNdercover manually
		} else {
				AS_Sset("reportedVehs", AS_S("reportedVehs") + [_vehicle]);
		};


		private _EHid2 = [_vehicle, "radio"] call AS_fnc_addAction;
		private _ids = player getVariable ["EH_ids", []];
		_ids pushBack _EHid2;
		player setVariable ["EH_ids", _ids];



	};
}];

player addEventHandler ["GetOutMan", {
    params ["_unit", "_seat", "_vehicle"];
	{_vehicle removeAction _x} forEach (player getVariable ["EH_ids", []]);
	player setVariable ["EH_ids", nil];
}];

player addEventHandler ["killed", {
	params ["_unit"];
	private _vehicle = vehicle _unit;
	//_unit removeAllEventHandlers "HandleDamage"; //These are no longer needed //IMPORTANT: this also removes "killed" eventhNdlers!

		if (_vehicle != _unit and {!(_vehicle isKindOf "StaticWeapon")}) then {
			([_unit, false] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magazineRemains"];
			[_vehicle, _cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_populateBox;
			[_vehicle, _magazineRemains] call AS_fnc_addMagazineRemains;
	    _unit call AS_fnc_emptyUnit;
		};

	private _group = group _unit;
	if (count (units _group select {alive _x}) == 0) then {
		deleteGroup _group;
	};
	//Stats
	[_unit, "deaths", 1] call AS_players_fnc_change;

	}];

//Eventhandler to increase City support for healing CIVS
player addEventhandler ["handleHeal", {
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

			[_healer, "civHealed", 1] call AS_players_fnc_change;
		} else {
			[_healer, "healed", 1] call AS_players_fnc_change;
		};

		//Stats



		_return
	}];
