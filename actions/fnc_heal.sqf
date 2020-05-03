params ["_pos", "_unit"];


if ([_unit, nil] call AS_fnc_enemiesNearby) exitWith {Hint "You cannot heal with enemies nearby";};

{
	if (_x call AS_fnc_getSide == "FIA" and {_x distance _pos < 20}) then {
		if (hasACE) then {
      		[_x] remoteExec ["ace_medical_treatment_fnc_fullHealLocal", _x];
    	} else {
      		_x setDamage 0;
		};
	};
} forEach allUnits;

hint "Your stomach stopped growling, and you feel youself healed and completely refreshed";
