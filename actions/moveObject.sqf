//This action is local

//if (player != AS_commander) exitWith {hint "Only Player Commander is allowed to move assets"}; // No need to MM. Maybe make option?
if (vehicle player != player) exitWith {hint "You cannot move assets while in a vehicle"};

params ["_vehicle","_player","_EHid", ["_arguments", nil]];

if (_player != player) exitWith {
	diag_log "[AS] Error: moveObject called from not-player.";
};

private _attachPoint = [0,2,1];  // default attach point

private _nearest = (["FIA" call AS_location_fnc_S, _player] call BIS_fnc_nearestPosition);
	//private _nearest = [("FIA" remoteExecCall ["AS_location_fnc_S", 2]), _player] call  BIS_fnc_nearestPosition;
private	_position = _nearest call AS_location_fnc_position;
private _distance = 200;

private _bbr = boundingBoxReal _vehicle;
private _p1 = _bbr select 0;
private _p2 = _bbr select 1;
private _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
if (_maxHeight > 2.5) then {
		_attachPoint = [0,6,1];
};
if (_maxHeight > 3) then {
		_attachPoint = [0,8,1.5];
};


if (position _vehicle distance _position > _distance) exitWith {hint "Asset is too far (>200m) from the flag."};

_vehicle removeAction _EHid;
[_vehicle, false] remoteExecCall ["enableSimulationGlobal", 2]; //don't wreck anything
_vehicle attachTo [_player,_attachPoint];
_player setVariable ["ObjAttached", _vehicle, true];

private _EHid = _player addAction [localize "STR_act_dropAsset", {
	params ["_obj", "_caller", "_actionID"];
	_obj removeAction _actionID;
	_caller allowDamage false;
	detach (_obj getVariable "ObjAttached");
	_caller setVariable ["ObjAttached", nil];
	}, nil, 0, false, true, "", "!isNull (_target getVariable ['ObjAttached',objNull])"];

waitUntil {sleep 1;
	(vehicle _player != _player) or  // not inside a vehicle
	(_player distance _position > _distance) or // too far
	(!alive _player) or (!isPlayer _player) or // not inside a vehicle
	isNull (_player getVariable ['ObjAttached',objNull])  // object dropped
};

// detach it if other conditions were satisfied
if !(isNull (_player getVariable ['ObjAttached',objNull])) then  {
	detach (_player getVariable 'ObjAttached');
		_player setVariable ["ObjAttached", nil];
};

// add the action back
_vehicle addAction [localize "STR_act_moveAsset", "actions\moveObject.sqf",nil,0,false,true,"","(_this == AS_commander)", 5];

_player removeAction _EHid;

_player allowDamage false;
_vehicle setPosATL [getPosATL _vehicle select 0,getPosATL _vehicle select 1,0];


private _vehDistance = position _vehicle distance _position;
if (_vehDistance > _distance) then {
	hint format ["You cannot move assets farther than %1m from the location.", _distance];
	// it became unreachable to move again. Find a position where it is reachable
	private _pos = position _vehicle;
	while {_pos distance _position > _distance} do {
		_pos = [_vehicle, _vehDistance - _distance + 3, random 360] call BIS_Fnc_relPos;
	};
	_vehicle setPos _pos;
};

_vehicle setVectorUp (surfacenormal (getPosATL _vehicle));

[_vehicle, true] remoteExecCall ["enableSimulationGlobal", 2];
_player allowDamage true;

if (vehicle _player != _player) exitWith {hint "You dropped the asset to enter in the vehicle"};
