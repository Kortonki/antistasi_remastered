params ["_unit"];
private _wasUnconscious = false;
while {alive _unit} do {
    sleep AS_spawnlooptime*2;



    private _isUnconscious = _unit call AS_medical_fnc_isUnconscious;




    if (not _wasUnconscious and _isUnconscious) then {
        // became unconscious
        if (random 10 > 5) then {_unit setCaptive true};

        _wasUnconscious = true;
    };

    //below is not needed for non-ace: clearing assigns is done via heal_action

      if (hasACEmedical) then {
        //Black tagged or dead units or stabliisied units are cleared from healqueue
        private _medic = (_unit call AS_medical_fnc_getAssignedMedic);
        if (not isNull _medic and {
          not alive _medic or
          _medic call AS_medical_fnc_isUnconscious or
          (!([_unit] call ace_medical_blood_fnc_isBleeding) and {not ([_unit] call AS_medical_fnc_isMedic)}) or //Medics can handle unconscious stabilised patients
          (_unit getVariable ["ace_medical_triageLevel", -1]) == 4 or
          not(alive _unit)})

          then {
            [_unit, _medic] call AS_medical_fnc_clearAssignedMedic;
        };
      };

        //If Has ACE medical, player can prevent AI healing hopeless cases by black triage card
        if (_isUnconscious and {isNull (_unit call AS_medical_fnc_getAssignedMedic) and {!(hasACEmedical) or (_unit getVariable ["ace_medical_triageLevel", -1]) != 4 or (hasACEmedical and {[_unit] call ace_medical_blood_fnc_isBleeding})}}) then {
            // Choose a medic.
            private _bestDistance = 81; // best distance of the current medic (max distance for first medic)

            private _canHeal = {
                params ["_candidate"];
                (alive _candidate) and
                {not isPlayer _candidate} and
                {not (_candidate call AS_medical_fnc_isUnconscious)} and
                {_candidate call AS_medical_fnc_canHeal} and
                {vehicle _candidate == _candidate} and
                {_candidate distance2D _unit < _bestDistance} and
                {unitReady _candidate} //EXPERIMENT this to not override eg. player issued commands
            };

            private _medic = objNull;
            {
                //Medic is always picked first
                if ([_x] call AS_medical_fnc_isMedic and {_x call _canHeal}) exitWith {
                  _medic = _x;
                };
                if (_x call _canHeal) then {
                    _medic = _x;
                    _bestDistance = _x distance2D _unit;
                };
            } forEach units group _unit;

            if isNull _medic then {
              {
                if ([_x] call AS_medical_fnc_isMedic and {_x call _canHeal}) exitWith {
                  _medic = _x;
                };

                if (_x call _canHeal) then {
                  _medic = _x;
                  _bestDistance = _x distance2D _unit;
                };
              } foreach (allUnits select {alive _x and {side (group _x) == side (group _unit) and {_x distance2D _unit < 50}}});
            };

            if not isNull _medic then {
                [_medic, _unit] call AS_medical_fnc_healUnit;
            };
        };

        if (not(hasACEmedical)) then {

          if _isUnconscious then {
              _unit setHit ["body",((_unit getHit "body") + 0.0005)];  //Bleedout, test & tweak
                if (_unit call AS_medical_fnc_isHealed) then {
                    sleep (5 + random 15);

                    if (([_unit] call AS_medical_fnc_isUnconscious)) then {[_unit, false] call AS_medical_fnc_setUnconscious;};


                };

           /*else {
                // Commented out for now, to work with newest ace med
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

            };*/
        };

    };

    if (_wasUnconscious and not _isUnconscious) then {
        // became conscious
        if (!(_unit getVariable ["surrendered", false])) then  {_unit setCaptive false};
        _unit setFatigue 1;

        _wasUnconscious = false;

        if ((_unit call AS_fnc_getSide) in ["AAF", "CSAT"] and {[_unit, 5] call AS_fnc_friendlyNearby}) then {
          [_unit] spawn AS_AI_fnc_surrender; //If FIA healing wounded, make them surrender
        };
    };

    //Set unconscious if too much damage. This in case got hurt in a vehicle and then disembarked

    if not hasACEmedical then {
        if (damage _unit > 0.95 and {not(_isUnconscious) and (vehicle _unit == _unit)}) then {
            [_unit, true] call AS_medical_fnc_setUnconscious;
        };
    };
};

//For good measure when unit dead
if (not isnull (_unit call AS_medical_fnc_getAssignedMedic)) then {
  [_unit, (_unit call AS_medical_fnc_getAssignedMedic)] call AS_medical_fnc_clearAssignedMedic;
};
