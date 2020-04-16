_pos = _this select 0;

{
	if ((side _x == ("FIA" call AS_fnc_getFactionSide)) and (_x distance _pos < 20)) then {
		if (hasACE) then {
      		[_x] remoteExec ["ace_medical_treatment_fnc_fullHealLocal", _x];
    	} else {
      		_x setDamage 0;
		};
	};
} forEach allUnits;

hint "Your stomach stopped growling.\n\n Get back in the fight, soldier!";
