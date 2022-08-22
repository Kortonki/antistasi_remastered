#include "macros.hpp"
params ["_unit", "_part", "_dam", "_injurer"];

if (captive _injurer and {!(side _injurer in [("FIA" call AS_fnc_getFactionSide), civilian]) or [_injurer] call AS_fnc_detected}) then {
	[_injurer, false] remoteExecCall ["setCaptive", _injurer];
};

if (_injurer isKindOf "LandVehicle" and {_injurer call AS_fnc_getSide == "FIA"}) then {
	AS_Sset("reportedVehs", AS_S("reportedVehs") + [_injurer]);
};

if (vehicle _unit == _unit or vehicle _unit isKindOf "StaticWeapon") then {

	/*private _currentTime = [time, serverTime] select isMultiplayer; //Servertime is problematic, only synced every 5 minutes
	if ((_part == "head") and {not (_unit call AS_medical_fnc_isUnconscious)}) then {
	_unit setVariable ["firstHitTime", _currentTime, false]; //THIS IS LOCAL, maybe causing immortal uncoscious enemies?
	//ALSO obsolote, and for optimisations sake, don't use as has only minor effect
	};*/

	if (_dam > 5) exitWith {};

	if not (_part in ["hand_l","hand_r","leg_l","leg_r","arms"]) then {

		if (_dam > 0.95) exitWith {
		//private _sameHit = ((_unit getVariable ["firstHitTime", _currentTime]) + 0.1) >= _currentTime; OBSOLETE, probably useless check


			if (not (_unit call AS_medical_fnc_isUnconscious)) then {
				[_unit,true] call AS_medical_fnc_setUnconscious;
				_dam = 0.95; //If unconscious, damage is as is. Moved from parent scope
			};
		};
	};
	if ((not (_unit call AS_medical_fnc_isUnconscious)) and {_dam > 0.2}) then {

		//If standing or running fall down from the Hit
		//AI will take then default prone stance
			if (stance _unit == "STAND") then {
		_unit switchMove "AmovPercMstpSrasWrflDnon_AadjPpneMstpSrasWrflDright";
			[_unit] spawn {
			params ["_unit"];
			if (!(isPlayer _unit)) then {
				sleep 1;
				if (([_unit] call AS_medical_fnc_isUnconscious)) exitWith {};
				waitUntil {animationState _unit != "AmovPercMstpSrasWrflDnon_AadjPpneMstpSrasWrflDright" or !alive _unit};
				_unit switchMove "AadjPpneMstpSrasWrflDright_AmovPpneMstpSrasWrflDnon";
				//sleep 1;
				//waitUntil {animationState _unit != "AadjPpneMstpSrasWrflDright_AmovPpneMstpSrasWrflDnon" or !alive _unit};

				};
			};
		};

		if (!(isPlayer _unit)) then { [_unit,_unit] spawn AS_AI_fnc_smokeCover;};
	};


};
_dam
