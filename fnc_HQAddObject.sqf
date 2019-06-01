#include "macros.hpp"
AS_SERVER_ONLY("fnc_HQAddObject.sqf");
params ["_objType", "_player"];

//this happens at init and at players discretion

if (_objType == "delete") exitWith {
	//call AS_fnc_HQdeletePad; //No need to delete, 
	{
		[_x] RemoteExec ["deleteVehicle", _x];
	} foreach AS_HQ_placements;
	AS_HQ_placements = [];
};

//Check if player

private _position = "FIA_HQ" call AS_location_fnc_position;

if (position _player distance _position > 100) exitWith {
	private _text = "This location is too far from HQ";
  [_player, "hint", _text] call AS_fnc_localCommunication;
};

if (_objType == "pad") exitWith {
	call AS_fnc_HQdeletePad;
	{
		if (str typeof _x find "Land_Bucket_painted_F" > -1) then {
			[_x, {deleteVehicle _this}] remoteExec ["call", 0];
		};
	} forEach nearestObjects [petros, [], 80];
	private _padBag = "Land_Bucket_painted_F" createVehicle [0,0,0];
	_padBag setPos ([getPos _player, 2, getDir _player] call BIS_Fnc_relPos);
	[_padBag, "moveObject"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
	[_padBag, "deploy"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
};

private _pos = [getPos _player, 5, getDir _player] call BIS_Fnc_relPos;
private _item = objNull;
if (_objType == "lantern") then {
	_item = "Land_Camping_Light_F";
};

if (_objType == "net") then {
	_item = AS_camonet_type;
};

if (_objType == "sandbag") then {
	_item = AS_sandbag_type_round;
};

if (_objType == "small_bunker") then {
	_item = AS_small_bunker_type;
};

if (_objType == "big_bunker") then {
	_item = AS_big_bunker_type;
};

if (_objType == "h_barrier") then {
	_item = AS_h_barrier_type;
};

private _object = _item createVehicle _pos;
AS_HQ_placements pushBack _object;

[_object, "moveObject"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
