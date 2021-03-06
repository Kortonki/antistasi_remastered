#include "macros.hpp"
params ["_pool"];
private _slow = false;

if (player call AS_fnc_controlsAI) exitWith {hint "You cannot access the Garage while you are controlling AI"};

if ([position player, nil] call AS_fnc_enemiesNearby) exitWith {
	Hint "You cannot manage the Garage with enemies nearby";
};

if ([position player, AS_enemyDist*2] call AS_fnc_enemiesNearby) then {
	hint "Accessing garage is slow, enemies nearby";
	_slow = true;
};

if (_slow) then {[bandera, position player, 2*60, {true}, {speed player < 1}, "Stay put to access the garage", ""] call AS_fnc_wait_or_fail;};

if (player distance2D bandera > 10) exitWith {};

if _pool then {
	vehInGarageShow = [player, "garage"] call AS_players_fnc_get;
} else {
	vehInGarageShow = AS_P("vehiclesInGarage");
};

if (count vehInGarageShow == 0) exitWith {
	hintC "The Garage is empty"
};

private _break = false;
garagePos = [];
if (isNil "vehiclePad") then {
	garagePos = position player findEmptyPosition [5,45,"C_Truck_02_transport_F"];
} else {
	garagePos = position vehiclePad;
	garagePos set [2, 0.5]; //Spawn vehicles above ground to avoid clipping
	if (count (vehiclePad nearObjects ["AllVehicles",4]) > 0) then {_break = true}; //[type, radius] will fail if objects withn 5 (old 7)
};
if _break exitWith {hintC "Clear the area, not enough space to spawn a vehicle."};

if (count garagePos == 0) exitWith {hint "Couldn't find a safe position to spawn the vehicle, or the area is too crowded to spawn it safely"};

// the selected as an index
cuentaGarage = 0;

// the selected as a vehicle
garageVeh = createVehicle [(vehInGarageShow select cuentaGarage), garagePos, [], 0, "CAN_COLLIDE"];
garageVeh allowDamage false;
[garageVeh, false] remoteExecCall ["enablesimulationGlobal", 2];
garageVeh setDir AS_S("AS_vehicleOrientation");
garageVeh setpos garagePos;

Cam = "camera" camCreate (player modelToWorld [0,0,4]);
Cam camSetTarget garagePos;
Cam cameraEffect ["internal", "BACK"];
//Cam camCommand "Manual On";
Cam camCommit 0;

["<t size='0.6'>Garage Keys.<t size='0.5'><br/>A-D Navigate<br/>SPACE to Select<br/>ESCAPE to Exit",0,0,5,0,0,4] spawn bis_fnc_dynamicText;

garageKeys = (findDisplay 46) displayAddEventHandler ["KeyDown", {
	//This to avoid multiple spawn if player spams the keys
	if (isNull garageVeh) exitWith {false};
	private _key = _this select 1;
	if not (_key in [57, 1, 32, 30]) exitWith {
		false
	};
	private _exitGarage = false;
	private _changeVehicle = false;
	private _takeVehicle = false;
	["<t size='0.6'>Garage Keys.<t size='0.5'><br/>A-D Navigate<br/>SPACE to Select<br/>ESCAPE to Exit",0,0,5,0,0,4] spawn bis_fnc_dynamicText;
	if (_this select 1 == 57) then {
		// space: take and leave
		_exitGarage = true;
		_takeVehicle = true;
	};
	if (_key == 1) then {
		// escape: leave
		_exitGarage = true;
		deleteVehicle garageVeh;
	};
	// A and D: rotate
	if (_key == 32) then {
		if (cuentaGarage + 1 > (count vehInGarageShow) - 1) then {
			cuentaGarage = 0
		} else {
			cuentaGarage = cuentaGarage + 1
		};
		_changeVehicle = true;
	};
	if (_key == 30) then {
		if (cuentaGarage - 1 < 0) then {
			cuentaGarage = (count vehInGarageShow) - 1
		} else {
			cuentaGarage = cuentaGarage - 1
		};
		_changeVehicle = true;
	};
	if _changeVehicle then {
		[garageVeh, false] remoteExecCall ["enableSimulationGlobal",2];
		deleteVehicle garageVeh;
		private _tipo = vehInGarageShow select cuentaGarage;
		if (isNil "_tipo") then {_exitGarage = true};
		if (typeName _tipo != typeName "") then {_exitGarage = true};
		if (!_exitGarage) then {
			//Here we need the spawned function to have 0.2 secs between vehicles so don't collide because of network lag
			[_tipo] spawn {
				params ["_tipo"];

				sleep 0.2;
				garageVeh = createVehicle [_tipo, garagePos, [], 0, "CAN_COLLIDE"];
				[garageVeh, false] remoteExecCall ["enablesimulationGlobal", 2];
				garageVeh allowDamage false;
				garageVeh setDir AS_S("AS_vehicleOrientation");
			};
		};
	};
	if _exitGarage then {
		Cam camSetPos position player;
		Cam camCommit 1;
		Cam cameraEffect ["terminate", "BACK"];
		camDestroy Cam;
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", garageKeys];
		if not _takeVehicle then {
			["",0,0,5,0,0,4] spawn bis_fnc_dynamicText;
		} else {
			[garageVeh, "FIA"] call AS_fnc_initVehicle;
			[garageVeh] remoteExec ["AS_fnc_changePersistentVehicles", 2];
			["<t size='0.6'>Vehicle retrieved from Garage",0,0,3,0,0,4] spawn bis_fnc_dynamicText;
			private _newArr = [];
			private _found = false;
			{
				if ((_x != (vehInGarageShow select cuentaGarage)) or (_found)) then {
					_newArr pushBack _x
				} else {
					_found = true
				};
			} forEach vehInGarageShow;

			if (vehInGarageShow isEqualTo AS_P("vehiclesInGarage")) then {
				AS_Pset("vehiclesInGarage", _newArr);
			} else {
				[player, "garage", _newArr] remoteExec ["AS_players_fnc_set", 2];
				garageVeh setVariable ["AS_vehOwner", getPlayerUID player, true];
			};
			if (garageVeh isKindOf "StaticWeapon") then {
				[garageVeh] remoteExec ["AS_fnc_changePersistentVehicles", 2];
			};
			[garageVeh] call AS_fnc_emptyCrate;
			garageVeh allowDamage true;
			[garageVeh, true] remoteExecCall ["enablesimulationGlobal", 2];

			//[garageVeh, "out"] call fnc_BE_checkVehicle; //This is unnecessary, checkVehicle obsolete
		};
		//vehInGarageShow = nil;
		//garagePos = nil;
		//cuentaGarage = nil;
		//garageVeh = nil;
	};
	true
}];
