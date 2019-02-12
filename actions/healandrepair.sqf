#include "../macros.hpp"
private ["_posHQ"];
_posHQ = getMarkerPos "FIA_HQ";

if ([position player, 500] call AS_fnc_enemiesNearby) exitWith {
	Hint "You cannot repair and heal with enemies nearby";
};


{
	if ((side _x == ("FIA" call AS_fnc_getFactionSide)) and (_x distance _posHQ < 100)) then {
		if (hasACE) then {
      		[_x, _x] call ace_medical_fnc_treatmentAdvanced_fullHeal;
    	} else {
      		_x setDamage 0;
		};
	};
} forEach allUnits;

{if ((side _x == ("FIA" call AS_fnc_getFactionSide)) and (_x distance _posHQ < 30)) then {_x setVariable ["compromised",0];}} forEach allPlayers - entities "HeadlessClient_F";


private _reportedVehs = AS_S("reportedVehs");
{
	if (_x distance _posHQ < 50) then {
		 _reportedVehs = _reportedVehs - [_x];

//This might set ammo to 0 for undercover AI with magazines: Maybe only has to do with gunning positions
//For now only rearm buyable FIA armed cars and unlocked aaf vehicle types. Avoid FFV vehicles during rearm.
		if (["vehicle", typeOf _x, _x] call fnc_BE_permission) then {
		[_x,1] remoteExec ["setVehicleAmmoDef",_x];
		[_x,0] remoteExec ["setDamage", _x];
		};
	};
} forEach vehicles;
AS_Sset("reportedVehs", _reportedVehs);

hint "All nearby units and vehicles have been healed or repaired. Near vehicles have been rearmed at full load, plates have been switched.";
