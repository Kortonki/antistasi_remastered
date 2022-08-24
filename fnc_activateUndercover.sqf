#include "macros.hpp"
AS_CLIENT_ONLY("fnc_activateUndercover");
params ["_notify"];
if (player call AS_fnc_controlsAI) exitWith {hint "You cannot go Undercover while you are controlling AI"};

// the player may be temporarly controlling another unit. We check the original unit
// the player cannot become undercover on an AI controlled unit, so this is ok
private _player = player getVariable ["AS_controller", player];
private _vehicle = vehicle _player;

if (captive _player) exitWith {hint "You are already undercover"};


private _heli_spotters = [["base","airfield"], "AAF"] call AS_location_fnc_TS;
private _all_spotters = [["base","airfield","outpost","seaport","hill", "hillAA"], "AAF"] call AS_location_fnc_TS; //Roadblock removed from here: there are dogs for spotting
_all_spotters append ([["hillAA"], "CSAT"] call AS_location_fnc_TS);

private _undercoverVehicles = (["CIV", "vehicles"] call AS_fnc_getEntity) + civHeli;

private _compromised = _player getVariable "compromised";
private _reason = "";

private _isMilitaryDressedConditions = [
	{primaryWeapon _player != ""},
	{secondaryWeapon _player != ""},
	{handgunWeapon _player != ""},
	{vest _player != "" and !(vest _player in (["FIA", "vests"] call AS_fnc_getEntity))},
	{headgear _player != "" and !(headgear _player in (["FIA", "helmets"] call AS_fnc_getEntity))},
	{hmd _player != ""},
	{!(uniform _player in CIVUniforms)}
];
private _isMilitaryHints = [
	"a weapon",
	"a weapon",
	"a handgun",
	"a military vest",
	"a military helmet",
	"a military head set",
	"a military uniform"
];

private _isMilitaryDressed = {
	private _result = false;
	{
		if (call _x) exitWith {
			_result = true;
		};
	} forEach _isMilitaryDressedConditions;
	_result
};


///// Check whether the player can become undercover
if (_vehicle != _player) then {
	if (not(typeOf(vehicle _player) in _undercoverVehicles)) then {
		_reason = "You cannot go undercover because you are in a non-civilian vehicle.";
	};
	if (vehicle _player in AS_S("reportedVehs")) then {
		_reason = "You cannot go undercover because you are in a compromised vehicle. Change your vehicle or renew it in the Garage to become undercover.";
	};
	if ([_player, 4] call AS_fnc_detected) then {
		_reason = "You cannot go undercover because the enemy knows you.";
	};

	if (count (ropeAttachedObjects _vehicle) > 0) then {
		private _attached = ropeAttachedObjects _vehicle select 0;
			if (!(_attached in _undercoverVehicles) or _attached in AS_S("reportedVehs")) then {
				_reason = "You're towing a compromised vehicle";
			} else {
				if (count (ropeAttachedObjects _attached) > 0) then {
					_reason = "You're towing more than one vehicle";
				};
			};

	};
} else {
	{
		if (call _x) exitWith {
			_reason = "You cannot go undercover because you are wearing " + (_isMilitaryHints select _forEachIndex);
		};
	} forEach _isMilitaryDressedConditions;
	if (dateToNumber date < _compromised) then {
		_reason = "You cannot go undercover because you are compromised. [use heal and repair in HQ or wait 30 minutes]";
	};
};

if (_reason != "" and _notify) exitWith {
	hint _reason;
};



private _setUndercover = {
	_player setCaptive true;

	// set AI members to be undercovered.
	if (_player == leader group _player) then {
		{if (!isplayer _x and {!(captive _x)}) then {[_x] remoteExec ["AS_fnc_activateUndercoverAI", _x]}} forEach (units group _player);
			};

	//Set everyone in same vehicle undercover
	["<t color='#1DA81D'>Undercover</t>",0,0,4,0,0,4] spawn bis_fnc_dynamicText;
};

call _setUndercover;

// loop until we have a reason to not be undercover.
while {_reason == ""} do {
	sleep 1;
	if (!captive _player) exitWith {
		_reason = "reported";
	};

	private _veh = vehicle _player;
	private _type = typeOf _veh;
		if (_veh != _player) then {
		_reason = call {
			if (not(_type in _undercoverVehicles)) exitWith {
				"militaryVehicle"
			};
			if (_veh in AS_S("reportedVehs")) exitWith {
				"compromisedVehicle"
			};
			if (not (_type in civHeli) and
				{count (_veh nearRoads 50) == 0} and
				{[_veh] call AS_fnc_detected}
				) exitWith {
				// no roads within 50m and detected.
				"awayFromRoad"
			};
			if (not (_type in civHeli) and {
				private _base = [_all_spotters, _player] call BIS_fnc_nearestPosition;
				private _position = _base call AS_location_fnc_position;
				private _size = _base call AS_location_fnc_size;
				_player distance2D _position < _size}) exitWith {
					"distanceToLocation"
			};
			if ((_type in civHeli) and {
				private _base = [_heli_spotters, _player] call BIS_fnc_nearestPosition;
				private _position = _base call AS_location_fnc_position;
				private _size = _base call AS_location_fnc_size;
				_player distance2D _position < _size*2}) exitWith {
					"distanceToLocation"
			};
			if (hasACE and {not(_type in civHeli)} and
				{false or
					{((position _player nearObjects ["DemoCharge_Remote_Ammo", 5]) select 0) mineDetectedBy ("AAF" call AS_fnc_getFactionSide)} or
					{((position _player nearObjects ["SatchelCharge_Remote_Ammo", 5]) select 0) mineDetectedBy ("AAF" call AS_fnc_getFactionSide)}} and
					{[_veh] call AS_fnc_detected}) exitWith {
				"vehicleWithExplosives"
			};

			if (call _isMilitaryDressed and {[_veh, 4] call AS_fnc_detected}) exitWith {
				"militaryDressed"
			};

			private _exit = "";

			if (count (ropeAttachedObjects _veh) > 0) then {

				private _attached = (ropeAttachedObjects _veh) select 0;
				if (!(_attached in _undercoverVehicles) or _attached in AS_S("reportedVehs")) then {
					_exit = "towing";
				} else {

					if (count (ropeAttachedObjects _attached) > 0) then {
						_exit = "towingMany";
					};
				};

			};

			if (_exit != "") exitWith {_exit};

			""
		};
	} else {
		_reason = call {
			if call _isMilitaryDressed exitWith {
				"militaryDressed"
			};
			if (dateToNumber date < _compromised) exitWith {
				_reason = "compromised"
			};
			if (true and {
				private _loc = [_all_spotters, _player] call BIS_fnc_nearestPosition;
				private _position = _loc call AS_location_fnc_position;
				private _size = _loc call AS_location_fnc_size;
				_player distance2d _position < _size*2 and {
				[_player] call AS_fnc_detected
					}}) exitWith {
				"distanceToLocation"
			};
			""
		};
	};
};



private _setPlayerCompromised = {
	params ["_player"];
	if (captive _player) then {_player setCaptive false};

	private _setVehicleGroupCompromised = {
		{
			[_x, false] remoteExec ["setcaptive", _x];
		} foreach (crew (vehicle _player));
	};

	//TODO: if player in a vehicle everyone in the vehicle become compromised

	// the player only becomes compromised when he is detected
	//
	if ([vehicle _player] call AS_fnc_detected) then {
		if (vehicle _player == _player) then {
				_player setVariable ["compromised", (dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
			} else {
				AS_Sset("reportedVehs", AS_S("reportedVehs") + [vehicle _player]);
				if ([vehicle _player, 4] call AS_fnc_detected) then {
					call _setVehicleGroupCompromised;
					_player setVariable ["compromised", (dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
				};
			};
	};
		//If player is spotted while in a vehicle make it comprose (after the initilian bust
		//If player goes back to undercover, ditch this check
		waitUntil {sleep (AS_spawnLoopTime); [vehicle _player] call AS_fnc_detected or not(alive _player) or (captive _player)};
		if ([vehicle _player] call AS_fnc_detected and {alive _player and {!(captive _player)}}) then {
			if (vehicle _player == _player) then {
				_player setVariable ["compromised", (dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
			} else {
				AS_Sset("reportedVehs", AS_S("reportedVehs") + [vehicle _player]);
				if ([vehicle _player, 4] call AS_fnc_detected) then {
					call _setVehicleGroupCompromised;
					_player setVariable ["compromised", (dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
				};
			};
		};
};

//It is spawned so waituntil won't stop from showing the message below
[_player] spawn _setPlayerCompromised;

["<t color='#D8480A'>Not undercover</t>",0,0,4,0,0,4] spawn bis_fnc_dynamicText;

switch _reason do {
	case "reported": {
		hint "You cannot remain undercover because you have been reported";
	};
	case "militaryVehicle": {
		hint "You cannot remain undercover on a non-civilian vehicle";
	};
	case "compromisedVehicle": {
		hint "You cannot remain undercover on a compromised vehicle";
	};
	case "vehicleWithExplosives": {
		hint "You cannot remain undercover on a vehicle with spotted explosives";
	};
	case "awayFromRoad": {
		hint "You cannot remain undercover because this vehicle has been compromised because you went too far from the roads";
	};
	case "militaryDressed": {
		hint "You cannot remain undercover because you are wearing military equipment:\n\nweapon in hand\nVest\nHelmet\nNV Googles\nGuerrilla Uniform";
	};
	case "compromised": {
		hint "You cannot remain undercover because you are compromised. [use heal and repair in HQ or wait 30m]";
	};
	case "distanceToLocation": {
		hint "You cannot remain undercover because you are too close to an enemy location";
	};
	case "towing": {
		hint "You cannot remain undercover because you're towing a compromised vehicle";
	};
	case "towingMany": {
		hint "You cannot remain undercover because you're towing too many vehicles";
	};
};
