params ["_unit"];
private _wasUnconscious = false;
while {alive _unit} do {
    sleep 2;



    private _isUnconscious = _unit call AS_medical_fnc_isUnconscious;




    if (not _wasUnconscious and _isUnconscious) then {
        // became unconscious
        if (random 10 > 5) then {_unit setCaptive true};

        _wasUnconscious = true;
    };

    private _medic = (_unit call AS_medical_fnc_getAssignedMedic);
    if (not isNull _medic and {not alive _medic or _medic call AS_medical_fnc_isUnconscious}) then {
        _unit setVariable ["ace_medical_ai_assignedMedic", objNull];
        _medic setVariable ["ace_medical_ai_healQueue", []];
    };

    if (_isUnconscious and {isNull (_unit call AS_medical_fnc_getAssignedMedic)}) then {
        // Choose a medic.
        private _bestDistance = 81; // best distance of the current medic (max distance for first medic)

        private _canHeal = {
            params ["_candidate"];
            (alive _candidate) and
            {not isPlayer _candidate} and
            {not (_candidate call AS_medical_fnc_isUnconscious)} and
            {_candidate call AS_medical_fnc_canHeal} and
            {vehicle _candidate == _candidate} and
            {_candidate distance2D _unit < _bestDistance}
        };

        private _medic = objNull;
        {
            if (_x call _canHeal) then {
                _medic = _x;
                _bestDistance = _x distance2D _unit;
            };
        } forEach units group _unit;

        if isNull _medic then {
          {
            if (_x call _canHeal) then {
              _medic = _x;
              _bestDistance = _x distance2D _unit;
            };
          } foreach (allUnits select {alive _x and {side _x == side _unit and {_x distance2D _unit < 50}}});
        };

        if not isNull _medic then {
            [_medic, _unit] call AS_medical_fnc_healUnit;
        };
    };
    if _isUnconscious then {
        if not hasACEmedical then {
          _unit setHit ["body",((_unit getHit "body") + 0.0005)];  //Bleedout, test & tweak
            if (_unit call AS_medical_fnc_isHealed) then {
                sleep (5 + random 15);

                if (([_unit] call AS_medical_fnc_isUnconscious)) then {[_unit, false] call AS_medical_fnc_setUnconscious;};

                if ((_unit call AS_fnc_getSide) in ["AAF", "CSAT"] and {[_unit, 5] call AS_fnc_friendlyNearby}) then {
                  [_unit] spawn AS_AI_fnc_surrender; //If FIA healing wounded, make them surrender
                };
            };

        } else {
            // this would not be needed, but currently the medic does not use epipen.
            // See https://github.com/acemod/ACE3/pull/5433
            // So, we just do it ourselves (without animations and stuff)
            private _hasBandaging = ([_unit] call ACE_medical_fnc_getBloodLoss) == 0;
            private _hasMorphine  = (_unit getVariable ["ACE_medical_pain", 0]) <= 0.2;
            if (_hasBandaging and _hasMorphine) then {
                [_unit, false] call AS_medical_fnc_setUnconscious;

                if ((_unit call AS_fnc_getSide) in ["AAF", "CSAT"] and {[_unit, 5] call AS_fnc_friendlyNearby}) then {
                  [_unit] spawn AS_AI_fnc_surrender; //If FIA healing wounded, make them surrender
                };

            };

        };
    };

    if (_wasUnconscious and not _isUnconscious) then {
        // became conscious
        if (!(_unit getVariable ["surrendered", false])) then  {_unit setCaptive false};
        _unit setFatigue 1;

        _wasUnconscious = false;
    };

    //Set unconscious if too much damage. This in case got hurt in a vehicle and then disembarked

    if not hasACEmedical then {
        if (damage _unit > 0.9 and {not(_isUnconscious) and (vehicle _unit == _unit)}) then {
            [_unit, true] call AS_medical_fnc_setUnconscious;
        };
    };
};
