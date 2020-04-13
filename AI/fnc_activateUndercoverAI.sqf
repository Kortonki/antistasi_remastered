#include "../macros.hpp"
params ["_unit"];

if (captive _unit) exitWith {diag_log format ["[AS] Warning: AI activating undercover while already undercover. Time: %1 Unit: %2", time, _unit]};

private _leader = leader _unit;
private _vehicle = vehicle _unit;
waitUntil {sleep 1; _vehicle = vehicle _unit; (vehicle _leader != _leader and {_vehicle == vehicle _leader}) or (vehicle _leader == _leader)}; //Check if ai is in the same vehicle or all dismounted

if ([_unit] call AS_fnc_detected) exitWith {_unit groupChat "Can't go undercover, I'm being observed by the enemy"};
if (captive _unit) exitWith {diag_log format ["[AS] Warning: AI activating undercover while already undercover. Time: %1 Unit: %2", time, _unit]};
	_unit groupChat "I'm undercover now";
[_unit, true] remoteExecCall ["setCaptive", _unit];


_unit disableAI "TARGET";
_unit disableAI "AUTOTARGET";
_unit setUnitPos "UP";

// save and remove gear:
private _primaryWeapon = primaryWeapon _unit call BIS_fnc_baseWeapon;
private _primaryWeaponItems = primaryWeaponItems _unit;
private _primaryWeaponMag = [];
private _secondaryWeapon = secondaryWeapon _unit;
private _secondaryWeaponItems = secondaryWeaponItems _unit;
private _secondaryWeaponMag = [];
private _handGunWeapon = handGunWeapon _unit call BIS_fnc_baseWeapon;
private _handGunItems = handgunItems _unit;
private _handGunMag = [];
private _headgear = headgear _unit;
private _hmd = hmd _unit;

//Get currently attached Magazines TODO: figure if there's a easier way than magazinesAmmoFull

{
	if ((_x select 3) == 1) then {_primaryWeaponMag = [_x select 0, _x select 1]};
	if ((_x select 3) == 2) then {_handGunMag = [_x select 0, _x select 1]};
	if ((_x select 3) == 4) then {_secondaryWeaponMag = [_x select 0, _x select 1]};
} forEach magazinesAmmoFull _unit;

// remove equipment
_unit setBehaviour "CARELESS";
_unit removeWeaponGlobal _primaryWeapon;
_unit removeWeaponGlobal _secondaryWeapon;
_unit removeWeaponGlobal _handGunWeapon;
removeHeadGear _unit;
_unit unlinkItem _hmd;

private _detectingLocations = [["base","roadblock","outpost","outpostAA"], "AAF"] call AS_location_fnc_TS;
private _undercoverVehicles = (["CIV", "vehicles"] call AS_fnc_getEntity) + civHeli;
while {(captive (leader _unit)) and {captive _unit}} do {
	sleep 1;
	private _type = typeOf vehicle _unit;
	// vehicle reported.
	if ((vehicle _unit != _unit) and {not(_type in _undercoverVehicles) || vehicle _unit in AS_S("reportedVehs")}) exitWith {};

	private _location = [_detectingLocations, _unit] call BIS_fnc_nearestPosition;
	private _position = _location call AS_location_fnc_position;
	private _size = _location call AS_location_fnc_size;
	if (_unit distance _position < _size*2) exitWith {[_unit, false] remoteExecCall ["setCaptive", _unit];};
};

if (!(captive _unit)) then {
	_unit groupChat "Shit, they have spotted me!";
	//If one in a vehicle is spotted, everyone is
	//if-then is just for optimization: allUnits are not run unnecessarily
	if (vehicle _unit != _unit) then {
			{
				[_x, false] remoteExecCall ["setCaptive", _x];
			} foreach (crew (vehicle _unit));
		};
	} else {
		[_unit, false] remoteExecCall ["setCaptive", _unit];
	};
if (captive (leader _unit)) then {sleep 5};

_unit enableAI "TARGET";
_unit enableAI "AUTOTARGET";
_unit setUnitPos "AUTO";

// load and add gear.
// private _sinMochi = false;
/*
if ((backpack _unit == "") and (_secondaryWeapon == "")) then {
	_sinMochi = true;
	_unit addbackpack selectRandom (["FIA", "unlockedBackpacks"] call AS_fnc_getEntity);
};*/
//{if (_x != "") then {[_unit, _x, 1, 0] call BIS_fnc_addWeapon};} forEach [_primaryWeapon,_secondaryWeapon,_handGunWeapon]; //Doesn't account for partial magazine nor is global

//TODO:
//Here check for locality if it changed during undercover?
{if (_x != "") then {_unit addWeapon _x};} forEach [_primaryWeapon,_secondaryWeapon,_handGunWeapon];
{_unit addPrimaryWeaponItem _x} forEach _primaryWeaponItems;
{_unit addSecondaryWeaponItem _x} forEach _secondaryWeaponItems;
{_unit addHandgunItem _x} forEach _handgunItems;
//if (_sinMochi) then {removeBackpackGlobal _unit};
_unit addHeadgear _headgear;
_unit linkItem _hmd;
_unit setBehaviour "AWARE";

//Add magazines that were loaded to the weapons last to avoid adding mags to full inventroy
//TODO: optimise this by putting it inside addweaponglobal loop (it's possible)
sleep 1;
{
		if (!(_x isEqualTo [])) then {[_unit, _x] remoteExecCall ["addMagazine", _unit]};
} foreach [_primaryWeaponMag, _handGunMag, _secondaryWeaponMag];
