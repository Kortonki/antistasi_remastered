#include "../macros.hpp"
private ["_chequeo","_pos","_veh","_newPos","_coste"];

if ([position player, 500] call AS_fnc_enemiesNearby) exitWith {
	Hint "You cannot buy vehicles with enemies nearby (500m)";
};

private _vehicleType = selectRandom (["FIA", "water_vehicles"] call AS_fnc_getEntity);

_coste = _vehicleType call AS_fnc_getFIAvehiclePrice;

if (AS_P("resourcesFIA") < _coste) exitWith {hint format ["You need %1 € to buy a boat",_coste]};

_chequeo = false;
private _ang = 0;
private _dist = 200;
private _i = 0;
private _j = 0;

while {true} do
	{
	_pos = [position player, _dist, _ang] call BIS_Fnc_relPos;
	if (surfaceIsWater _pos) then
		{
		while {true} do
			{
			_dist = _dist - 5;
			_j = _j + 1;
			_newPos = [position player, _dist, _ang] call BIS_Fnc_relPos;
			if (!(surfaceIsWater _newPos)) exitWith {_chequeo = true};
			if (_j > 41) exitWith {};
			};
		};
	if (_chequeo) exitWith {};
	_ang = _ang + 31;
	_i = _i + 1;
	if (_i > 12) exitWith {};
};

if (!(_chequeo)) exitWith {
	Hint "No water nearby (200m)";
};

_veh = _vehicleType createVehicle _pos;

[_veh, "FIA"] call AS_fnc_initVehicle;
player reveal _veh;
[0,-200] remoteExec ["AS_fnc_changeFIAmoney",2];
hint "Boat purchased";
