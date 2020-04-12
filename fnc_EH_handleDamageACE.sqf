#include "macros.hpp"
params ["_unit", "_part", "_dam", "_injurer"];

if (captive _injurer) then {
	[_injurer, false] remoteExecCall ["setCaptive", _injurer];
};
if (_injurer isKindOf "LandVehicle" and {_injurer call AS_fnc_getSide == "FIA"}) then {
	AS_Sset("reportedVehs", AS_S("reportedVehs") + [_injurer]);
};

//OBSOLOTE for optimisation's sake and servertime is problematic (only synced every 5 minutes)
/*private _currentTime = [time, serverTime] select isMultiplayer;
if ((_part == "head") and not (_unit call AS_medical_fnc_isUnconscious)) then {
	_unit setVariable ["firstHitTime", _currentTime, false];
};*/


//EXPERIMENT running ACE medical as vanilla. might have been source of the double killed eh?
/*if not (_part in ["hand_l","hand_r","leg_l","leg_r","arms"]) then {
	if (_dam > 1) exitWith {
	//private _sameHit = (_unit getVariable ["firstHitTime", _currentTime]) + 0.5 >= _currentTime;
	    if (not(isPlayer _unit)) then {
					[_unit, true] call ACE_medical_fnc_setDead;
				};
    };
};/*
// this handler is only used to kill unconscious people
_dam
