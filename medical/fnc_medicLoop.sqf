params ["_unit"];

private _wasUnconscious = false;
private _bestDistance = 100; // best distance of the current medic (max distance for first medic)
private _medic = objNull;
private _distance = _bestDistance;

private _canHeal = {
    params ["_candidate"];
    (alive _candidate) and
    {not isPlayer _candidate} and
    {not (_candidate call AS_medical_fnc_isUnconscious)} and
    {unitReady _candidate} and //EXPERIMENT this to not override eg. player issued commands
    {vehicle _candidate == _candidate} and
    {[_candidate, _unit] call AS_medical_fnc_canHeal} and
    {_candidate distance2D _unit < _distance}
};

//LOOP START

while {alive _unit} do {
    sleep AS_spawnlooptime*2;

    private _isUnconscious = _unit call AS_medical_fnc_isUnconscious;

    if (_unit getvariable ["autoHeal", false] and {vehicle _unit == _unit}) then {


      if (_unit getVariable ["selfHeal", false] and {damage _unit > 0.25 or (damage _unit > 0 and {_unit call AS_medical_fnc_isMedic})}) then {
      _unit setVariable ["selfHeal", true];
      [_unit] spawn {
        params ["_unit"];
        _unit setVariable ["selfHeal", nil];

        //TODO: Maybe check for targetknowlege lastthreat. Figure out the format for that
        private _time = time;
        waitUntil {sleep AS_spawnLoopTime; private _enemy = (_unit findNearestEnemy _unit);
          !(_enemy != objNull and
          {_enemy distance2D _unit < 150 and
          {([objNull, "VIEW"] checkVisibility [eyePos _unit, eyePos _enemy]) > 0 and {
          time < _time + 10
          }}})};

        sleep 1;
        if(!(_unit call AS_medical_fnc_isUnconscious)) then {
          [_unit, _unit] call AS_medical_fnc_healAction;

          //_unit action ["HealSoldierSelf", _unit];
          };
        };
      };

      // For rest of the healing call a medic

      if (damage _unit > 0 and {!(_unit call AS_medical_fnc_isMedic) and {!_isUnconscious and {isNull(_unit call AS_medical_fnc_getAssignedMedic)}}}) then {

        _distance = _bestDistance;

        {
            //Nearbu group medic is always picked first
            if ([_x] call AS_medical_fnc_isMedic and {_x call _canHeal and {_x getvariable ["autoHeal", false]}}) exitWith {
              _medic = _x;
            };

        } forEach units group _unit;

        // If no group medic nearby look for other friendly medic twice the distance away

        if (isNull _medic) then {
         _distance = _bestDistance*2;
          {
            if ([_x] call AS_medical_fnc_isMedic and {_x call _canHeal and {_x getvariable ["autoHeal", false]}}) then {
              _medic = _x;
              _distance = _x distance2D _unit;
            };
          } foreach (allUnits select {alive _x and {((side (group _x) == side (group _unit)) or (side _unit == civilian)) and {_x distance2D _unit < _bestDistance*2}}});
        };


        if (!(isNull _medic)) then {
          [_medic, _unit] call AS_medical_fnc_healUnit;
          _medic = objNull;
        };


      };
    };

    //AUTOHEAL END

    if (not _wasUnconscious and _isUnconscious) then {
        // became unconscious
        if (random 10 > 5) then {_unit setCaptive true};

        _wasUnconscious = true;
    };

    //below is not needed for non-ace: clearing assigns is done via heal_action

      if (hasACEmedical) then {
        //Black tagged or dead units or stabliisied units are cleared from healqueue
        private _medic = (_unit call AS_medical_fnc_getAssignedMedic);
        //TODO: Consider if the following conditions could be reversed and run through lazy eval with ands
        //Possible better this way, as it is more rare event that medic is released, than vice versa, continuin treatment
        if (not isNull _medic and {
          not alive _medic or
          {_medic call AS_medical_fnc_isUnconscious or
          {(!([_unit] call ace_medical_blood_fnc_isBleeding) and {not (_medic call AS_medical_fnc_isMedic)}) or //Medics can handle unconscious stabilised patients
          {(_unit getVariable ["ace_medical_triageLevel", -1]) == 4 or //Drop it if black triaged
          {(_unit getVariable ["ace_medical_bloodVolume", 6]) <= 3 or //Lost fatal amounts of blood, drop it
          {(_unit call AS_medical_fnc_isMoved) or
          {not(alive _unit) or
          {(_unit call ace_medical_status_fnc_isInStableCondition)
          }}}}}}}
          })

          then {
            [_unit, _medic] call AS_medical_fnc_clearAssignedMedic;
        };
      };

        //If Has ACE medical, player can prevent AI healing hopeless cases by black triage card
        if (_isUnconscious  and {isNull (_unit call AS_medical_fnc_getAssignedMedic) and {!(_unit call AS_medical_fnc_isMoved) and {
          !(hasACEmedical) or
          {hasACEmedical and {(_unit getVariable ["ace_medical_triageLevel", -1]) != 4 and {(_unit getVariable ["ace_medical_bloodVolume", 6] > 3) and {!([_unit] call ace_medical_status_fnc_isInStableCondition)}}}

            }}}}) then {
            // Choose a medic. Medic also has to have autoheal turned on. For default autoheal on for player squad AIs, for others no (AI leader takes care of that decently)

            _distance = _bestDistance;

            {
                //Medic is always picked first
                if ([_x] call AS_medical_fnc_isMedic and {_x call _canHeal}) exitWith {
                  _medic = _x;
                };
                if (_x call _canHeal) then {
                    _medic = _x;
                    _distance = _x distance2D _unit;
                };
            } forEach units group _unit;

            //Only medics attempt to heal civs automatically

            if isNull _medic then {
              {
                if ([_x] call AS_medical_fnc_isMedic and {_x call _canHeal}) then {
                  _medic = _x;
                  _distance = _x distance2D _unit;
                };


              } foreach (allUnits select {alive _x and {((side (group _x) == side (group _unit)) or (side _unit == civilian)) and {_x distance2D _unit < _bestDistance*2}}});
            };

            if isNull _medic then {
              {
              if (_x call _canHeal) then {
                _medic = _x;
                _distance = _x distance2D _unit;
              };
            } foreach (allUnits select {alive _x and {side (group _x) == side (group _unit) and {_x distance2D _unit < _bestDistance*2}}});
          };

            if not isNull _medic then {
                [_medic, _unit] call AS_medical_fnc_healUnit;
                _medic = objNull;
            };
        };

        if (not(hasACEmedical)) then {

          if _isUnconscious then {
              _unit setHit ["body",((_unit getHit "body") + 0.003)];  //Bleedout, test & tweak: Was 0.0005, now 0.003. 0.0005 would take 416 minutes in avg from 0 to 1
                if (_unit call AS_medical_fnc_isHealed) then {

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

//Sketch for other medic release condition (inversed, needs checking)
/*
!(alive _medic and
{!(_medic call AS_medical_fnc_isUnconscious) and
{[_unit] call ace_medical_blood_fnc_isBleeding or ([_unit] call AS_medical_fnc_isMedic) and
{(_unit getVariable ["ace_medical_triageLevel", 1]) != 4 and
{!(_unit call AS_medical_fnc_isMoved) and
{alive _unit and
{!(_unit call AS_medical_status_fnc_inStableCondition)



}}}}}})
*/
