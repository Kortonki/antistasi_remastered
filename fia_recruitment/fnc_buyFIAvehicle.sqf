#include "../macros.hpp"
if (player call AS_fnc_controlsAI) exitWith {hint "You cannot buy vehicles while you are controlling AI"};

if ([position player, nil] call AS_fnc_enemiesNearby) exitWith {
	Hint "You cannot buy vehicles with enemies nearby";
};

params ["_type"];

private _position = position player;
private _location = [call AS_location_fnc_all select {(_x call AS_location_fnc_side == "FIA")}, _position] call BIS_fnc_nearestPosition;

private _coste = [_type] call AS_fnc_getFIAvehiclePrice;

private _resourcesFIA = AS_P("resourcesFIA");
if (isMultiPlayer and player != AS_commander) then {
	_resourcesFIA = [player, "money"] call AS_players_fnc_get;
};

if (_resourcesFIA < _coste) exitWith {hint format ["You do not have enough money for this vehicle: %1 € required",_coste]};

private _pos = [];
if (_location == "fia_hq" and{!(isNil "vehiclePad") and {!(count (vehiclePad nearObjects ["AllVehicles",7]) > 0)}}) then {
	_pos = position vehiclePad;
	_pos set [2, 0.5];
} else {
	_pos = _position findEmptyPosition [5,50,_type];
};


if (count _pos == 0) exitWith {
	hint "Not enough space to place this vehicle";
};
private _veh = _type createVehicle _pos;

if (isMultiPlayer and player != AS_commander) then {
	[player, "money", -_coste] remoteExec ["AS_players_fnc_change", 2];
	_veh setVariable ["AS_vehOwner", getPlayerUID player, true];
} else {
	[0,-_coste] remoteExec ["AS_fnc_changeFIAmoney",2];
};

[_veh, "FIA"] call AS_fnc_initVehicle;

if (_type isKindOf "StaticWeapon") then {
	[_veh,"moveObject"] remoteExec ["AS_fnc_addaction", [0,-2] select isDedicated];
};
hint "Vehicle Purchased";
player reveal _veh;
[_veh] remoteExec ["AS_fnc_changePersistentVehicles", 2];
