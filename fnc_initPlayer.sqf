#include "macros.hpp"
waitUntil {sleep 0.1; !isNull player};
waitUntil {sleep 0.1; player == player};

if hasACEhearing then {player addItem "ACE_EarPlugs"};

[player, "FIA"] call AS_fnc_setSide;

player addEventHandler ["HandleDamage", AS_fnc_EH_handleDamage_AIcontrol];
player call AS_medical_fnc_initUnit;

player call AS_fnc_initPlayerPosition;

//Take command of HC groups again as commander
if (player == AS_commander) then {
	{
			player hcSetGroup [_x, ""];
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

player addEventHandler ["WeaponDisassembled", {
    [_this select 1, "FIA"] call AS_fnc_initVehicle;
	[_this select 2, "FIA"] call AS_fnc_initVehicle;
}];

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
	if isMultiplayer then {
		private _owner = _vehicle getVariable "AS_vehOwner";
		if (!isNil "_owner" and
            {{getPlayerUID _x == _owner} count (units group player) == 0}) then {
			hint "You can only enter in other's vehicle if you are in its group";
			moveOut _unit;
			_exit = true;
		};
	};
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

		if (_seat == "driver" and _vehicle isKindOf "Truck_F") then {
			private _EHid = [_vehicle, "transferFrom"] call AS_fnc_addAction;
			player setVariable ["EH_ids", [_EHid, _EHid1]];
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
