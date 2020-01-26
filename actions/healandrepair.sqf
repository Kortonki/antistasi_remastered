#include "../macros.hpp"
private ["_posHQ"];
_posHQ = getMarkerPos "FIA_HQ";
private _slow = false;

if ([position player, nil] call AS_fnc_enemiesNearby) exitWith {Hint "You cannot repair and heal with enemies nearby";};

if ([position player, AS_enemyDist*2] call AS_fnc_enemiesNearby) then {
	hint "Repair and healing is slow, enemies in the area";
	_slow = true;

};


{
	if ((side _x == ("FIA" call AS_fnc_getFactionSide)) and {_x distance2D _posHQ < 100}) then {


		if (_slow) then {[cajaVeh, _posHQ, (damage _x * 20), {true}, {_x distance2D cajaVeh < 100}, "Stay close to the box to heal", ""] call AS_fnc_wait_or_fail;};

		if (hasACE) then {
					 		[_x, _x] call ace_medical_fnc_treatmentAdvanced_fullHeal;
    	} else {
      		_x setDamage 0;
		};
	};
} forEach allUnits;

{if ((side _x == ("FIA" call AS_fnc_getFactionSide)) and (_x distance2D _posHQ < 200)) then {_x setVariable ["compromised",0];}} forEach allPlayers - entities "HeadlessClient_F";


private _reportedVehs = AS_S("reportedVehs");
{
	if (_x distance2D _posHQ < 200) then {



	 _reportedVehs = _reportedVehs - [_x];

//This might set ammo to 0 for undercover AI with magazines: Maybe only has to do with gunning positions
//For now only rearm buyable FIA armed cars and unlocked aaf vehicle types. Avoid FFV vehicles during rearm.

//Todo consider what vehicles to set persistent
//Repair and ream only when empty to avoid setting 0 ammo to FFV positions. TODO: check turrets and load them manually
		if (["vehicle", typeOf _x, _x] call fnc_BE_permission and {count (crew _x select {alive _x}) == 0}) then {

			if (alive _x and {!(_x in (AS_P("vehicles"))) and {_x call AS_fnc_getSide == "FIA"}}) then {[_x] remoteExec ["AS_fnc_changePersistentVehicles", 2]};

			if (_slow) then {[cajaVeh, _posHQ, 4*60*(damage _x) + (1*60), {true}, {speed _x < 5}, "Stay put close to the box to repair and rearm", ""] call AS_fnc_wait_or_fail;};

			if (speed _x < 5) then {

				[_x,1] remoteExec ["setVehicleAmmoDef",_x];
				[_x,0] remoteExec ["setDamage", _x];
			};
		};
	};
} forEach vehicles;
AS_Sset("reportedVehs", _reportedVehs);

hint "All nearby units and vehicles have been healed or repaired. Near vehicles have been rearmed at full load, plates have been switched.";
